#!/bin/bash
export PATH=../bin:$PATH

# Some files are expected to be the same each time. Check for that
for file in run/cameras.nvm \
    run/ba_matches/run-final_residuals_pointmap.csv \
    run/ba_nvm/run-final_residuals_pointmap.csv; do 

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1
  fi
  
  # replace run/ with gold/
  gold=$(echo $file | perl -p -e "s#^run/#gold/#")
    
  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1
  fi
  
  diff=$(diff $file $gold | head -n 50)
  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi
done

# For other files that may not be unique, just check for existence
for file in                                   \
    run/fused_mesh.ply                        \
    run/texrecon_out/nav_cam/texture.obj      \
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
