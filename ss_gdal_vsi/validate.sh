#!/bin/bash
source ../bin/setup_env.sh

# Compare the DEM from point2dem and the transforms from pc_align and n_align
# against the gold results. All three inputs were read through a /vsizip/ path.

# point2dem: compare the DEM statistics, as the other raster tests do.
file=run/point2dem/run-DEM.tif
gold=gold/point2dem/run-DEM.tif

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1
fi
if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1
fi

rm -fv "$file.aux.xml"
rm -fv "$gold.aux.xml"

cmp_stats.sh $file $gold
gdalinfo -stats $file | grep -v Files | grep -v -i tif > run/point2dem/stats.txt
gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold/point2dem/stats.txt

diff=$(diff run/point2dem/stats.txt gold/point2dem/stats.txt | head -n 50)
cat run/point2dem/stats.txt
rm -f run/point2dem/stats.txt gold/point2dem/stats.txt

echo diff is $diff
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

# pc_align and n_align: compare the alignment transforms, which are plain text.
for file in run/pc_align/run-transform.txt \
            run/n_align/run-transform-0.txt \
            run/n_align/run-transform-1.txt; do

  gold=gold/${file#run/}

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1
  fi
  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1
  fi

  diff=$(diff $file $gold | head -n 50)
  echo "Comparing $file with $gold, diff is $diff"
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi
done

echo Validation succeeded
exit 0
