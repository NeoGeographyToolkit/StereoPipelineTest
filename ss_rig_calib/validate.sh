#!/bin/bash
export PATH=../bin:$PATH

# It is vary hard to do proper validation as the results are not unique.
# For now, just check if the files were at least successfully created
for file in run/rig_config.txt           \
    run/cameras.txt                      \
    run/convergence_angles.txt           \
    run/fused_mesh.ply                   \
    run/texrecon_out/nav_cam/texture.obj \
    run/texrecon_out/sci_cam/texture.obj; do 
  
  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi
  
done

# If the file run/pinhole/haz_cam/1637278316.7238007_haz_cam.tsai
# does not exist, then bundle_adjust failed.
if [ ! -e "run/pinhole/haz_cam/1637278316.7238007_haz_cam.tsai" ]; then
    echo "ERROR: File run/pinhole/haz_cam/1637278316.7238007_haz_cam.tsai does not exist."
    exit 1;
fi

echo Validation succeded
exit 0
