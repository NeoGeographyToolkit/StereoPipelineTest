#!/bin/bash
export PATH=../bin:$PATH

for g in gold/run.r50.xml gold/run.small.png; do

  if [ ! -e "$g" ]; then
      echo "ERROR: File $g does not exist."
      exit 1
  fi

  f=${g/gold/run}
  if [ ! -e "$f" ]; then
      echo "ERROR: File $f does not exist."
      exit 1
  fi

  diff=$(cmp $f $g)
  echo diff is $diff

  if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
  fi

done

file=run/run.r50.tif
gold=gold/run.r50.tif

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
gdalinfo -stats $file | grep -v Files | grep -v -i tif > run.txt
gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold.txt

diff=$(diff run.txt gold.txt)
cat run.txt

rm -f run.txt gold.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeded
exit 0
