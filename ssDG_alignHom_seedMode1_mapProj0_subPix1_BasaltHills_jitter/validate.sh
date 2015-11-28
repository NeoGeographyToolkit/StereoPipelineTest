#!/bin/bash
export PATH=../bin:$PATH

# compare floating point values
function fcomp() {
    awk -v n1=$1 -v n2=$2 'BEGIN{ if (n1<n2) exit 0; exit 1}'
}

for file in run/run-DEM.tif run/run-DRG.tif; do 

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
  gdalinfo -stats $file | grep -v Files | grep -v -i tif > run.txt
  gdalinfo -stats $gold | grep -v Files | grep -v -i tif > gold.txt

  #diff=$(diff run.txt gold.txt)
  diff=$(cmp_stats.sh $file $gold | grep -i "Max rel err" | awk '{print $8}')

  # Allow some discrepancy, for some reason, the result is not always the same
  echo Discrepancy is $diff  
  fcomp $diff 3e-1
  ans=$?
   
  if [ "$ans" != "0" ]; then 
      echo Validation failed
      exit 1
  fi

done

echo Validation succeded
exit 0
