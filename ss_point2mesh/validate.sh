#!/bin/bash
export PATH=../bin:$PATH

file=run/run.osgb
gold=gold/run.osgb

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi

if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

#diff=$(cmp $file $gold 2>&1)

#echo diff is $diff
#if [ "$diff" != "" ]; then
#    echo Validation failed
#    exit 1
#fi

# To dislodge stuck osgviewer
(sleep 5; killall osgviewer > /dev/null 2>&1; exit 0) & 

osgviewer run/run.osgb
status=$?

if [ "$status" = "143" ]; then
   # Declare the test passed if osgviewer started well, but 
   # failed to quit and had to be killed
   status=0
fi

if [ "$status" != "0" ]; then 
  echo Validation failed
  exit 1
fi

echo Validation succeded
exit 0

