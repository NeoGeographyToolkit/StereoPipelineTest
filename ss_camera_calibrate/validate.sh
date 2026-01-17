#!/bin/bash
export PATH=../bin:$PATH

for file in run/ocv_cam_params.yml run/solve_cam_params.txt run/vw_cam_params.tsai; do

  gold=gold/$(basename $file)
  echo $file $gold

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  # Rm timestamp
  clean_file=$file.clean
  clean_gold=$gold.clean
  cat $file | grep -v calibration_time > $clean_file
  cat $gold | grep -v calibration_time > $clean_gold
  
  diff=$(diff $clean_file $clean_gold | head -n 50)

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeeded
exit 0
