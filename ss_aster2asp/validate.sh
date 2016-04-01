#!/bin/bash
export PATH=../bin:$PATH

for gold in gold/run-Band3N.xml gold/run-Band3B.xml; do

  file=${gold/gold/run}

  if [ ! -e "$file" ]; then
      echo "ERROR: File $f does not exist."
      exit 1
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1
  fi

  diff=$(cmp $file $gold)
  echo diff is $diff

  if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
  fi

done

for gold in gold/run-Band3N.tif gold/run-Band3B.tif; do
    
    file=${gold/gold/run}
    
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
done

echo Validation succeded
exit 0
