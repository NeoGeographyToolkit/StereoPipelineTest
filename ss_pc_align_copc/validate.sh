#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-trans_reference.laz run/run-trans_source.laz; do 
  
  gold=gold/$(basename $file)
  
  echo "Comparing: $file with $gold"

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi

    pdal info --all $file | grep -v filename | grep -v date | grep -i -v software | grep -v now | grep -v creation | grep -v href | grep -v file_size > run/run.txt
    ans=$?
    if [ $ans -ne 0 ]; then
        echo Validation failed
        exit 1
    fi

    pdal info --all $gold |grep -v filename | grep -v date | grep -i -v software | grep -v now | grep -v creation | grep -v href | grep -v file_size > gold/run.txt
    ans=$?
    if [ $ans -ne 0 ]; then
        echo Validation failed
        exit 1
    fi

    diff=$(diff run/run.txt gold/run.txt | head -n 50)

    rm -f run/run.txt gold/run.txt

    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi
done

echo Validation succeeded
exit 0

