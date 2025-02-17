#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-transform.txt; do 
	
	gold=${file/run/gold}

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

diff=$(diff $file $gold | head -n 50)

echo diff is $diff
if [ "$diff" != "" ]; then
  echo Validation failed
  exit 1
fi

done

echo Validation succeeded
exit 0

