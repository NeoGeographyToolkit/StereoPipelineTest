#!/bin/bash
export PATH=../bin:$PATH

rm -f run/*xml gold/*xml

for f in "" -first -last -min -max -mean -stddev -median -count -block-max; do

  file=run/run-tile-0"$f".tif
  gold=gold/run-tile-0"$f".tif

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  cmp_stats.sh $file $gold
  gdalinfo -stats $file | grep -v Files | grep -v -i tif > run.txt
  gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold.txt

  diff=$(diff run.txt gold.txt)

  if [ "$diff" != "" ]; then
    echo Validation failed
    echo diff is $diff
    exit 1
  fi
done

echo Validation succeded
exit 0
