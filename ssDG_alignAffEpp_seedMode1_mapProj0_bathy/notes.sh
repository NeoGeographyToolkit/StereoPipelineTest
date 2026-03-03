image_calc -c "sign(var_0 - 300)" --input-nodata-value 0 --output-nodata-value -1 run/right_bathy_b3_corr.map.mask.tif -o run/right_bathy_b3_corr.map.mask2.tif
image_calc -c "sign(var_0 - 300)" --input-nodata-value 0 --output-nodata-value -1 run/left_bathy_b3_corr.map.mask.tif -o run/left_bathy_b3_corr.map.mask2.tif
parallel_stereo ../data/left_bathy_b3_corr.map.tif ../data/right_bathy_b3_corr.map.tif ../data/left_bathy.xml ../data/right_bathy.xml --left-bathy-mask run/left_bathy_b3_corr.map.mask2.tif --right-bathy-mask run/right_bathy_b3_corr.map.mask2.tif --dem ../data/dem_nobathy.tif --refraction-index 1.333 --bathy-plane run/bathy-plane.txt --prev-run-prefix run/run run_mask2/run
cmx run_nobathy/run-PC.tif run_mask2/run-PC.tif

# Bug: bathy mask with no nodata metadata
# mask2 has nodata=-1, pixels are 0 (water) and 1 (land). The mask2 command
# runs to completion but bathy is silently NOT applied because
# read_bathy_mask() in BathyStereoModel.cc only marks pixels as water when
# they equal the file's nodata value. Since no pixel has value -1, all pixels
# are "valid" (land), areMasked() always returns false, and bathy correction
# never fires. This is a silent failure - identical output to no-bathy run.
#
# mask3: same pixel values as mask2 but with the nodata tag stripped:
gdal_translate -a_nodata none \
  run/left_bathy_b3_corr.map.mask2.tif \
  run/left_bathy_b3_corr.map.mask3.tif
gdal_translate -a_nodata none \
  run/right_bathy_b3_corr.map.mask2.tif \
  run/right_bathy_b3_corr.map.mask3.tif

# This throws immediately:
#   ERROR: Unable to read the nodata value from run/left_bathy_b3_corr.map.mask3.tif
parallel_stereo \
  ../data/left_bathy_b3_corr.map.tif \
  ../data/right_bathy_b3_corr.map.tif \
  ../data/left_bathy.xml ../data/right_bathy.xml \
  --left-bathy-mask run/left_bathy_b3_corr.map.mask3.tif \
  --right-bathy-mask run/right_bathy_b3_corr.map.mask3.tif \
  --dem ../data/dem_nobathy.tif \
  --refraction-index 1.333 \
  --bathy-plane run/bathy-plane.txt \
  --prev-run-prefix run/run \
  run_mask3/run

# Summary of bugs in read_bathy_mask() (BathyStereoModel.cc) and
# crop_bathy_mask() (StereoSessionBathy.cc):
#
# 1. Throws if the mask file has no nodata metadata. Should default to 0.
#
# 2. Uses only the file's literal nodata to decide water vs land via
#    create_mask(). Pixels with value 0 (water) are treated as valid (land)
#    unless 0 happens to be the nodata value. areMasked() checks only
#    is_valid(), so water pixels are never detected.
#
# 3. bathy_plane_calc.cc already does this correctly:
#      mask_nodata_val = std::max(0.0f, mask_nodata_val);
#    This ensures values <= 0 are treated as water. The same logic must be
#    applied in read_bathy_mask() and crop_bathy_mask().
#
# Fix (implemented on Mac, needs validation on lunokhod1):
#
# In read_bathy_mask() (BathyStereoModel.cc):
#   - Don't throw on missing nodata
#   - Use create_mask() with file nodata (or -max_float if absent)
#   - Then per_pixel_view with InvalidateNonPositive functor to also
#     invalidate pixels with value <= 0
#   - Return nodata_val = max(0, file_nodata) for callers writing mask back
#   - areMasked() unchanged - is_valid() now correctly catches both cases
#
# In crop_bathy_mask() (StereoSessionBathy.cc):
#   - Don't throw on missing nodata, default to 0
#
# In bathy_plane_calc.cc and BathyPlaneCalc.cc:
#   - Use read_bathy_mask() + apply_mask(masked, 0.0f) instead of inline
#     max(0, nodata) threshold logic
#
# Doc and help text updated in bathy.rst, StereoSettings.cc,
# BundleAdjustParse.cc, jitter_solve.cc, bathy_plane_calc.cc to say
# "non-positive value or be no-data" for water pixels.
#
# run.sh updated to use sign(max(thresh, var_0)-thresh) formula which
# produces a clean 0/1 mask (1=land, 0=water, nodata=-1). This mask
# previously failed silently; now works with the fixed read_bathy_mask().

# Instructions for lunokhod1 validation session
# ==============================================
#
# 1. CODE CHANGES TO APPLY
#    The code changes are in VW and ASP repos (not pushed yet from Mac).
#    Files changed:
#      VW:
#        visionworkbench/src/vw/Cartography/BathyStereoModel.cc  (read_bathy_mask fix)
#        visionworkbench/src/vw/Cartography/BathyStereoModel.h   (comment update)
#      ASP:
#        asp/Sessions/StereoSessionBathy.cc   (crop_bathy_mask fix)
#        asp/Core/BathyPlaneCalc.cc           (use read_bathy_mask)
#        asp/Tools/bathy_plane_calc.cc        (use read_bathy_mask + include)
#        asp/Core/StereoSettings.cc           (help text)
#        asp/Sessions/BundleAdjustParse.cc    (help text)
#        asp/Tools/jitter_solve.cc            (help text)
#        docs/examples/bathy.rst              (doc update)
#
# 2. BUILD
#    Build VW first, install, then build ASP:
#      make -C ~/projects/visionworkbench/build -j16
#      make -C ~/projects/visionworkbench/build install
#      make -C ~/projects/StereoPipeline/build -j16
#      make -C ~/projects/StereoPipeline/build install
#
# 3. PULL TEST CHANGES
#    cd ~/projects/StereoPipelineTest && git pull
#    The run.sh for this test now uses the sign() mask formula.
#
# 4. TESTS TO RUN AND VALIDATE
#    Set PATH to dev build:
#      export PATH=~/projects/StereoPipeline/install/bin:$PATH
#
#    Run these tests (bash run.sh > output.txt 2>&1 then bash validate.sh):
#
#    a) ssDG_alignAffEpp_seedMode1_mapProj0_bathy
#       - DEM should match gold (0 error or very close)
#       - run-mask-inliers.shp will have sub-mm float noise vs gold
#         (binary cmp fails, but ogrinfo shows < 0.001mm coordinate diffs)
#       - Bathy threshold test needs bathy conda env (see item 6 below)
#       - REGENERATE GOLD after confirming DEM is correct
#
#    b) ss_bathy_plane_sample_bd
#       - Uses bathy_plane_calc --mask. Binary cmp on run-sample.shp
#         will likely fail with sub-mm float noise.
#       - REGENERATE GOLD
#
#    c) ss_bathy_plane_cam_mask_dem
#       - Uses bathy_plane_calc --mask. Binary cmp on run-mask-inliers.shp
#         will likely fail with sub-mm float noise.
#       - REGENERATE GOLD
#
#    d) ss_bathy_plane_cam_orthomask_dem
#       - Uses bathy_plane_calc --ortho-mask. Binary cmp on
#         run-mask-inliers.shp will likely fail.
#       - REGENERATE GOLD
#
#    e) ssDG_alignAffEpp_bathy_two_planes
#       - Uses bathy masks in stereo. No shapefile cmp, should pass.
#
#    f) ssNadirPinHole_alignAffEpi_seedMode1_mapProj0_subPix1_OIB_dist_bathy
#       - Uses bathy masks in stereo. No shapefile cmp, should pass.
#
#    g) ss_bundle_adjust_DG_bathy
#       - Uses bathy masks in BA. Uses max_err.pl with tolerance, should pass.
#
#    h) ss_cam_test_bathy
#       - Should be unaffected.
#
# 5. HOW TO INSPECT SHAPEFILE DIFFERENCES
#    Use ogrinfo to compare coordinates:
#      ogrinfo -al run/foo.shp | grep POINT > /tmp/run_pts.txt
#      ogrinfo -al gold/foo.shp | grep POINT > /tmp/gold_pts.txt
#      diff /tmp/run_pts.txt /tmp/gold_pts.txt
#    Sub-mm differences (last digit by 1-3) are expected float noise
#    from the processing chain change (read_bathy_mask + apply_mask
#    vs old inline threshold). These are acceptable.
#
# 6. BATHY THRESHOLD TEST (needs bathy conda env)
#    The bathy_threshold_calc.py step in run.sh needs the bathy conda env.
#    This was not testable on the Mac. On lunokhod1:
#      conda activate bathy
#      bathy_threshold_calc.py --image ../data/left_bathy_b7.tif \
#        --num-samples 100000 --no-plot | grep -v -i elapsed \
#        > run/run-threshold.txt
#      diff run/run-threshold.txt gold/run-threshold.txt
#    This should be unchanged by our fix (it doesn't use read_bathy_mask).
#
# 7. GOLD REGENERATION
#    For tests that fail only on shapefile binary cmp with sub-mm diffs:
#      - Confirm DEM/output is correct (0 or near-0 error)
#      - Confirm shapefile diffs are sub-mm via ogrinfo
#      - Copy run/ outputs to gold/:
#          cp run/run-mask-inliers.shp gold/
#          (or whichever shapefile changed)
#      - Re-run validate.sh to confirm it passes
#
# 8. TESTS THAT SHOULD NOT BE AFFECTED
#    ss_bathy_plane_calc_meas, ss_bathy_plane_lonlat,
#    ss_bathy_plane_sample_shapefile, ss_otsu_threshold,
#    ss_refr_index - these don't use --mask or --ortho-mask in
#    bathy_plane_calc and don't use bathy masks in stereo/BA.
#
# 9. DRAFT RESPONSE TO MONICA
#    (Edit as needed before sending)
#
# Hi Monica,
#
# Thanks for tracking this down, it was a real bug. The mask reading logic
# only looked at the file's nodata value to decide what is water, so a
# simple 0/1 mask (or one without a nodata tag at all) would silently fail
# to apply bathy correction.
#
# I fixed it so the mask now accepts any of these:
#   - A mask with no nodata metadata at all (e.g., just 0 and 1)
#   - A mask with a nodata tag set to any value
#
# The rule is: pixels with non-positive values are water, pixels matching
# the file's nodata value are also water, and all positive pixels that are
# not nodata are land. Both conditions are checked, so it works regardless
# of whether nodata is set, what its value is, or whether water pixels
# are 0 or some negative value.
#
# The fix is in read_bathy_mask() in VW, which is used by stereo,
# bundle_adjust, jitter_solve, and bathy_plane_calc. The doc and help
# text were updated to clarify the convention.
#
# Oleg
