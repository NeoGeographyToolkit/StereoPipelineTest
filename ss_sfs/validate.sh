#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-DEM-iter2.tif run/run-height-error.tif; do 

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
  gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v xml > run/run.txt
  gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v xml > gold/gold.txt

  diff run/run.txt gold/gold.txt

  ../bin/max_err.pl run/run.txt gold/gold.txt # print the error
  ans=$(../bin/max_err.pl run/run.txt gold/gold.txt 1e-9) # compare the error
  if [ "$ans" -eq 0 ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeeded
exit 0
