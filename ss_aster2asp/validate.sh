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

  echo Comparing $file and $gold
  max_err.pl $file $gold # print the error
  ans=$(max_err.pl $file $gold 1e-10) # comapre the error with threshold
  if [ "$ans" -eq 0 ]; then
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

    echo Comparing $file and $gold
    cmp_stats.sh $file $gold
    gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v xml > run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v xml > gold.txt

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
