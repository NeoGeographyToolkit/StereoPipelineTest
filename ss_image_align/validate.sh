#!/bin/bash
source ../bin/setup_env.sh

for file in run/run-align.tif run/run-corr-align.tif; do

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
  gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v xml > gold/gold.txt

  diff run/run.txt gold/gold.txt

  ../bin/max_err.pl run/run.txt gold/gold.txt # print the error
  ans=$(../bin/max_err.pl run/run.txt gold/gold.txt 1e-9) # compare the error
  if [ "$ans" -eq 0 ]; then
      echo Validation failed
      exit 1
  fi

done

# The disparity-based match must carry a per-match sigma (the left-right disparity
# difference) floored at 0.5 pixels, so no value is below 0.5 (and none is 0). The
# sigma is the third column of each row of the text match file.
mf=run/run-corr-image_crop__image_crop_4.5pix-clean.txt
if [ ! -e "$mf" ]; then
    echo "ERROR: File $mf does not exist."
    exit 1
fi
minsig=$(awk 'NR==1{m=$3} $3<m{m=$3} END{printf "%.4f", m}' "$mf")
below=$(awk '$3 < 0.4999 {c++} END{print c+0}' "$mf")
echo "disparity-match sigma: min=$minsig, values below the 0.5 floor: $below"
if [ "$below" -ne 0 ]; then
    echo "Validation failed: match sigma below the 0.5 floor"
    exit 1
fi

echo Validation succeeded
exit 0

