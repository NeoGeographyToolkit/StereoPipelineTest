#!/bin/bash

# Round-trip test for the equisolid and stereographic fisheye projection
# distortion models. Project each sampled pixel to the ground and back with
# cam_test (cam1 == cam2), which exercises the closed-form forward distortion
# and the Newton-Raphson inverse. The round-trip must be within a small
# tolerance. Also verify the distortion is non-trivial by comparing against
# the same camera with no distortion.

set -x verbose
rm -rfv run
mkdir -p run

img=../data/fisheye_proj_test_1000.tif
tol=0.001

get_max_pixel_diff() {
  grep -A3 "cam1 to cam2 pixel diff" | grep Max | awk '{print $2}'
}

for model in equisolid stereographic orthographic; do
  cam=../data/fisheye_${model}_nadir.tsai
  maxdiff=$(cam_test --image $img --cam1 $cam --cam2 $cam --session1 pinhole --session2 pinhole --datum WGS84 --height-above-datum 0 --sample-rate 100 2>/dev/null | get_max_pixel_diff)
  ok=$(echo "$maxdiff $tol" | awk '{print ($1 < $2) ? "PASS" : "FAIL"}')
  echo "roundtrip $model $ok" >> run/run-out.txt
done

# Non-trivial distortion check: equisolid camera vs the same geometry with no
# distortion. Expect a shift of at least one pixel.
perl -pe 's/FISHEYE_EQUISOLID/NULL/; s/^k[1-4] = .*\n//' ../data/fisheye_equisolid_nadir.tsai > run/null.tsai
shift=$(cam_test --image $img --cam1 ../data/fisheye_equisolid_nadir.tsai --cam2 run/null.tsai --session1 pinhole --session2 pinhole --datum WGS84 --height-above-datum 0 --sample-rate 100 2>/dev/null | get_max_pixel_diff)
ok=$(echo "$shift" | awk '{print ($1 > 1.0) ? "PASS" : "FAIL"}')
echo "nontrivial equisolid $ok" >> run/run-out.txt
