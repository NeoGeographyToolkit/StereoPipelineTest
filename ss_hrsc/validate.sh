#!/bin/bash
source ../bin/setup_env.sh

# Validate cam_test output: pixel diff must be under 1 pixel
for channel in s12 s22; do
  file=run/cam_test_${channel}.txt
  if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1
  fi
  # Extract max pixel diff (cam1 to cam2)
  max_pix=$(grep -A3 "cam1 to cam2 pixel diff" $file | grep "Max:" | awk '{print $2}')
  if [ -z "$max_pix" ]; then
    echo "ERROR: Could not parse cam_test pixel diff from $file"
    exit 1
  fi
  # Check it is less than 1.0
  ok=$(echo "$max_pix < 1.0" | bc -l)
  if [ "$ok" != "1" ]; then
    echo "ERROR: cam_test $channel max pixel diff $max_pix >= 1.0"
    exit 1
  fi
  echo "cam_test $channel: max pixel diff $max_pix (OK)"
done

# Validate DEM
file=run/run-DEM.tif
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
gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/run.txt
gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/run.txt

diff=$(diff run/run.txt gold/run.txt)
cat run/run.txt

rm -f run/run.txt gold/run.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
