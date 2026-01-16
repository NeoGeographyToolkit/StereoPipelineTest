#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-trans_reference.tif run/run-trans_source.tif; do
	gold=${file/run\//gold\/}
	echo $run $gold

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

  diff=$(diff run/run.txt gold/run.txt | head -n 50)
  cat run/run.txt

  rm -f run/run.txt gold/run.txt

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi
done
echo Validation succeeded
