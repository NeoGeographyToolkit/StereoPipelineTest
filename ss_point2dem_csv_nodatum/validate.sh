#!/bin/bash
source ../bin/setup_env.sh

# Negative case: point2dem was expected to fail. Compare the recorded exit
# status against gold.
file=run/neg_status.txt
gold=gold/neg_status.txt
if [ ! -e "$file" ]; then echo "ERROR: File $file does not exist."; echo Validation failed; exit 1; fi
if [ ! -e "$gold" ]; then echo "ERROR: File $gold does not exist."; echo Validation failed; exit 1; fi
diff=$(diff $file $gold)
if [ "$diff" != "" ]; then echo "Negative status: run=$(cat $file) gold=$(cat $gold)"; echo Validation failed; exit 1; fi

# Positive control: compare the produced DEM against gold the usual way.
for file in run/pos-DEM.tif; do

  gold=gold/$(basename $file)

  if [ ! -e "$file" ]; then echo "ERROR: File $file does not exist."; echo Validation failed; exit 1; fi
  if [ ! -e "$gold" ]; then echo "ERROR: File $gold does not exist."; echo Validation failed; exit 1; fi

  # Remove cached xmls
  rm -fv "$file.aux.xml"
  rm -fv "$gold.aux.xml"

  cmp_stats.sh $file $gold
  gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/run.txt
  gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/run.txt

  diff=$(diff run/run.txt gold/run.txt)
  cat run/run.txt

  rm -f run/run.txt gold/run.txt

  echo diff is $diff
  if [ "$diff" != "" ]; then echo Validation failed; exit 1; fi

done

echo Validation succeeded
exit 0
