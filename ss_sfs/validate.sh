#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-DEM-iter2.tif; do

  echo $file $gold
  gold=${file/run\/run/gold\/run}

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  # Remove cached xmls
  rm -fv "$file.aux.xml"
  rm -fv "$gold.aux.xml"

  cmp_stats.sh $file $gold
  gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v xml > run.txt
  gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v xml > gold.txt

  diff run.txt gold.txt

  max_err.pl run.txt gold.txt # print the error
  ans=$(max_err.pl run.txt gold.txt 1e-9) # compare the error
  if [ "$ans" -eq 0 ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeded
exit 0
