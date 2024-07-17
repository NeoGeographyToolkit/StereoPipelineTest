#!/bin/bash
export PATH=../bin:$PATH

for file in run/*cub; do

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

  echo Comparing $file $gold
  cmp_stats.sh $file $gold
  gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v xml > run/run.txt
  gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v xml > gold/run.txt

  diff=$(diff run/run.txt gold/run.txt)
  cat run.txt

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeded
exit 0
