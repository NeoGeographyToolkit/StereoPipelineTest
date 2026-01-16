#!/bin/bash
export PATH=../bin:$PATH

for file in run/dem_cam.xml run/llh_cam.xml; do 

  gold=gold/$(basename $file)

  echo Comparing $file and $gold 
  diff=$(diff $file $gold | head -n 50)
  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi
done

echo Validation succeeded
exit 0
