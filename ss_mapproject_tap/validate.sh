#!/bin/bash
export PATH=../bin:$PATH

for tag in run-RPC run-RPC-Byte; do

  file=run/${tag}.tif
  gold=gold/${tag}.tif

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
  gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/${tag}.txt
  gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/${tag}.txt

  diff=$(diff run/${tag}.txt gold/${tag}.txt)
  cat run/${tag}.txt

  rm -f run/${tag}.txt gold/${tag}.txt

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo "Validation failed for $tag"
      exit 1
  fi

done

echo Validation succeeded
exit 0
