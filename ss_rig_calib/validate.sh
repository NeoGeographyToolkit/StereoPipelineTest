#!/bin/bash
export PATH=../bin:$PATH

# It is vary hard to do proper validation as the results are not unique.
# For now, just check if the files were at least successfully created
for file in run/rig_config.txt           \
    run/cameras.txt                      \
    run/convergence_angles.txt           \
    run/fused_mesh.ply                   \
    run/texrecon_out/nav_cam/texture.obj \
    run/texrecon_out/sci_cam/texture.obj \
    run/stereo/nav_cam/fused_mesh.ply;   \
    do 
  
  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi
  
done

echo Validation succeded
exit 0