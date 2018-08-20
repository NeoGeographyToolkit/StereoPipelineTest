#!/bin/bash

#if [ "$#" -lt 1 ]; then echo Usage: $0 argName; exit; fi

ipfind right_hillshade_a300_e20.tif right_pc_scale1.3/run-trans_source-DEM_hillshade_a300_e20.tif  --ip-per-tile 50000 --interest-operator OBALoG --descriptor-generator sgrad
ipmatch  right_hillshade_a300_e20.tif right_hillshade_a300_e20.vwip right_pc_scale1.3/run-trans_source-DEM_hillshade_a300_e20.tif right_pc_scale1.3/run-trans_source-DEM_hillshade_a300_e20.vwip

pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_plane/run 

pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_point/run --alignment-method point-to-point

pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_similarity_point_to_point/run --alignment-method similarity-point-to-point

pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_similarity_point_to_point_match/run --alignment-method similarity-point-to-point --match-file right_hillshade_a300_e20__run-trans_source-DEM_hillshade_a300_e20.match 

pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_plane_init_estim/run --initial-transform run_similarity_point_to_point_match/run-transform.txt

#0 iteratations, exact trans
pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_plane_init_estim/run --initial-transform scale1.3_inv.txt --save-transformed-source-points --num-iterations 0
point2dem  --t_srs '+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs ' --tr 90  run_point_to_plane_init_estim/run-trans_source.tif
di  right.tif run_point_to_plane_init_estim/run-trans_source-DEM.tif
  Minimum=0.000, Maximum=387.199, Mean=4.599, StdDev=11.140

# 500 iteratations exact trans
pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_plane_init_estim/run --initial-transform scale1.3_inv.txt --save-transformed-source-points --num-iterations 500
point2dem  --t_srs '+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs ' --tr 90  run_point_to_plane_init_estim/run-trans_source.tif
di  right.tif run_point_to_plane_init_estim/run-trans_source-DEM.tif
 Minimum=0.000, Maximum=455.294, Mean=4.849, StdDev=11.309

# 0 iterations computed trans point to plane
pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_plane_init_estim/run --initial-transform run_similarity_point_to_point_match/run-transform.txt --save-transformed-source-points --num-iterations 0
point2dem  --t_srs '+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs ' --tr 90  run_point_to_plane_init_estim/run-trans_source.tif
di  right.tif run_point_to_plane_init_estim/run-trans_source-DEM.tif
 Minimum=0.000, Maximum=399.325, Mean=4.936, StdDev=11.400

# 500 iterations computed trans point to plane
pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_plane_init_estim/run --initial-transform run_similarity_point_to_point_match/run-transform.txt --save-transformed-source-points --num-iterations 500
point2dem  --t_srs '+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs ' --tr 90  run_point_to_plane_init_estim/run-trans_source.tif
di  right.tif run_point_to_plane_init_estim/run-trans_source-DEM.tif
   Minimum=0.000, Maximum=433.702, Mean=4.825, StdDev=11.347

# 0 iterations computed trans similiarity point to point
pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_plane_init_estim/run --initial-transform run_similarity_point_to_point_match/run-transform.txt --save-transformed-source-points --num-iterations 0 --alignment-method similarity-point-to-point
point2dem  --t_srs '+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs ' --tr 90  run_point_to_plane_init_estim/run-trans_source.tif
di  right.tif run_point_to_plane_init_estim/run-trans_source-DEM.tif
Minimum=0.000, Maximum=399.325, Mean=4.936, StdDev=11.400

# 500 iterations computed trans similiarity point to point
pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_plane_init_estim/run --initial-transform run_similarity_point_to_point_match/run-transform.txt --save-transformed-source-points --num-iterations 500 --alignment-method similarity-point-to-point
point2dem  --t_srs '+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs ' --tr 90  run_point_to_plane_init_estim/run-trans_source.tif
di  right.tif run_point_to_plane_init_estim/run-trans_source-DEM.tif
  Minimum=0.000, Maximum=731.743, Mean=5.572, StdDev=14.232

# 500 iterations, similarity point to point, no initial scale help
pc_align right.tif right_pc_scale1.3/run-trans_source-DEM.tif --max-displacement -1 -o run_point_to_plane_init_estim/run --save-transformed-source-points --num-iterations 500 --alignment-method similarity-point-to-point
point2dem  --t_srs '+proj=utm +zone=10 +datum=WGS84 +units=m +no_defs ' --tr 90  run_point_to_plane_init_estim/run-trans_source.tif
di  right.tif run_point_to_plane_init_estim/run-trans_source-DEM.tif
>> di  right.tif run_point_to_plane_init_estim/run-trans_source-DEM.tif
  Minimum=0.001, Maximum=976.449, Mean=144.914, StdDev=130.854

left=data/zone10-CA_SanLuisResevoir-9m_hillshade_a300_e20
right=data/filled_dem_crop3_hillshade_a300_e20
ipfind $left.tif $right.tif  --ip-per-tile 500 --interest-operator OBALoG --descriptor-generator sgrad
ipmatch $left.tif $left.vwip $right.tif $right.vwip -i 100 --ransac-constraint homography


left0=data/zone10-CA_SanLuisResevoir-9m.tif
right0=data/filled_dem_crop3.tif

#0 iteratations, exact trans
pc_align $left0 $right0 --max-displacement -1 -o run/run --num-iterations 0

# 50% resampled

left=zone10-CA_SanLuisResevoir-9m_50pct_hillshade_a300_e20
right=filled_dem_50pct_hillshade_a300_e20
ipfind $left.tif $right.tif  --ip-per-tile 5000 --interest-operator OBALoG --descriptor-generator sgrad --debug-image 0
ipmatch $left.tif $left.vwip $right.tif $right.vwip -i 100 --ransac-constraint similarity
sg $left.tif $right.tif zone10-CA_SanLuisResevoir-9m_50pct_hillshade_a300_e20__filled_dem_50pct_hillshade_a300_e20.match

# Compute 1.5 scale
pc_align ../data/filled_dem_25pct.tif ../data/filled_dem_25pct.tif -o run_scale/run --max-displacement -1 --initial-transform scale1.5.txt --num-iterations 0 --save-transformed-source-points
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 run_scale/run-trans_source.tif

# Recover 1.5 scale.
left=../data/zone10-CA_SanLuisResevoir-9m_25pct_hillshade_a300_e20
right=run_scale/run-trans_source-DEM_hillshade_a300_e20
left2=${left/_hillshade_a300_e20}
right2=${right/_hillshade_a300_e20}

ipfind $left.tif $right.tif --ip-per-tile 5000 --interest-operator sift --descriptor-generator sift --debug-image 0
ipmatch $left.tif $left.vwip $right.tif $right.vwip -i 100 --ransac-constraint similarity

match_file=../data/zone10-CA_SanLuisResevoir-9m_25pct_hillshade_a300_e20__run-trans_source-DEM_hillshade_a300_e20.match

sg $left.tif $right.tif $match_file

# Compute the transform
pc_align $left2.tif $right2.tif --max-displacement -1 -o run_match/run --alignment-method similarity-point-to-point --match-file $match_file

di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif ../data/filled_dem_25pct.tif
  Minimum=0.000, Maximum=1119.017, Mean=15.914, StdDev=81.855

# Apply the transform
pc_align $left2.tif $right2.tif --max-displacement -1 -o run_init/run --alignment-method similarity-point-to-point --initial-transform run_match/run-transform.txt --save-transformed-source-points --num-iterations 0
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 run_init/run-trans_source.tif

# reference and source
di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif ../data/filled_dem_25pct.tif
  Minimum=0.000, Maximum=1119.017, Mean=15.914, StdDev=81.855

# source and trans-untrans source
di ../data/filled_dem_25pct.tif run_init/run-trans_source-DEM.tif
  Minimum=0.000, Maximum=183.036, Mean=16.673, StdDev=13.119

# reference and trans-untrans source
di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif run_init/run-trans_source-DEM.tif
  Minimum=0.000, Maximum=1104.173, Mean=25.404, StdDev=81.877

# Perform extra iterations on top with point-to-plane
pc_align $left2.tif $right2.tif --max-displacement 100 -o run_init_p2p/run --alignment-method point-to-plane --initial-transform run_match/run-transform.txt --save-transformed-source-points --num-iterations 100
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 run_init_p2p/run-trans_source.tif
di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif run_init_p2p/run-trans_source-DEM.tif
  Minimum=0.000, Maximum=1104.037, Mean=17.527, StdDev=81.763

# Perform extra iterations on top with similarity-point-to-point
pc_align $left2.tif $right2.tif --max-displacement 100 -o run_init_similarity/run --alignment-method similarity-point-to-point --initial-transform run_match/run-transform.txt --save-transformed-source-points --num-iterations 100
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 run_init_similarity/run-trans_source.tif
di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif run_init_similarity/run-trans_source-DEM.tif
  Minimum=0.000, Maximum=1102.880, Mean=19.124, StdDev=81.888

# Similarity, without using an initial transform
pc_align $left2.tif $right2.tif --max-displacement 4e+6 -o run_noinit_similarity/run --alignment-method similarity-point-to-point --save-transformed-source-points --num-iterations 100
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 run_noinit_similarity/run-trans_source.tif
di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif run_noinit_similarity/run-trans_source-DEM.tif

# point-to-plane, without using an initial transform
pc_align $left2.tif $right2.tif --max-displacement 4e+6 -o run_noinit_p2p/run --alignment-method point-to-plane --save-transformed-source-points --num-iterations 100
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 run_noinit_p2p/run-trans_source.tif
di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif run_noinit_p2p/run-trans_source-DEM.tif

# Using the new pc_align functionality with similarity
out=run_similarity/run
pc_align $left2.tif $right2.tif --max-displacement 100 -o $out --alignment-method similarity-point-to-point --save-transformed-source-points --num-iterations 100 --initial-transform-from-hillshading
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 $out-trans_source.tif
di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif $out-trans_source-DEM.tif

# Using the new pc_align functionality with point-to-plane
out=run_p2p/run
pc_align $left2.tif $right2.tif --max-displacement 100 -o $out --alignment-method point-to-plane --save-transformed-source-points --num-iterations 100 --initial-transform-from-hillshading
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 $out-trans_source.tif
di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif $out-trans_source-DEM.tif

# 25pct
pc_align ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif ../data/filled_dem_scaled.tif --max-displacement 100 -o run_p2p_25pct/run --alignment-method point-to-plane --save-transformed-source-points --num-iterations 100 --initial-transform-from-hillshading
out=run_p2p_25pct/run
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 $out-trans_source.tif
di ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif $out-trans_source-DEM.tif

# 50pct
pc_align ../data/zone10-CA_SanLuisResevoir-9m_50pct.tif ../data/filled_dem_scaled.tif --max-displacement 100 -o run_p2p_50pct/run --alignment-method point-to-plane --save-transformed-source-points --num-iterations 100 --initial-transform-from-hillshading
out=run_p2p_50pct/run
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.000555632716049 $out-trans_source.tif
di ../data/zone10-CA_SanLuisResevoir-9m_50pct.tif $out-trans_source-DEM.tif

# nightly run
pc_align ../data/zone10-CA_SanLuisResevoir-9m_25pct.tif ../data/filled_dem_scaled.tif --max-displacement 300 -o run/run --alignment-method point-to-plane --save-transformed-source-points --num-iterations 100 --initial-transform-from-hillshading
point2dem --t_srs '+proj=longlat +datum=WGS84 +no_defs ' --tr 0.001111265432099 run/run-trans_source.tif
di ../data/zone10-CA_SanLuisResevoir-9m_50pct.tif run/run-trans_source-DEM.tif
