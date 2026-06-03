#!/bin/bash
source ../bin/setup_env.sh

for file in run/run-fwd-diff.tif run/run-rev-diff.tif; do

  echo $file $gold
  gold=gold/$(basename $file)

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
  gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v xml > gold/run.txt

  diff=$(diff run/run.txt gold/run.txt)
  cat run/run.txt

  rm -f run/run.txt gold/run.txt

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi

done

# Self-consistency check: the reversed diff must be the negative of the
# forward diff. Verify the mean of the reversed output equals minus the
# mean of the forward output (to a small tolerance).
fwd_mean=$(gdalinfo -stats run/run-fwd-diff.tif | grep STATISTICS_MEAN | head -n 1 | cut -d= -f2)
rev_mean=$(gdalinfo -stats run/run-rev-diff.tif | grep STATISTICS_MEAN | head -n 1 | cut -d= -f2)
echo "fwd_mean=$fwd_mean rev_mean=$rev_mean"
sum=$(echo "$fwd_mean + $rev_mean" | bc -l)
ok=$(echo "(${sum#-} < 0.001)" | bc -l)
if [ "$ok" != "1" ]; then
    echo "Validation failed: reversed mean is not the negative of forward mean (sum=$sum)"
    exit 1
fi

echo Validation succeeded
exit 0
