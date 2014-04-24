#!/bin/bash
export PATH=../bin:$PATH

file=run/run.osg
gold=gold/run.osg

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

osgviewer run/run.osg
status=$?

if [ "$status" != "0" ]; then 
  echo Validation failed
  exit 1
fi

echo Validation succeded
exit 0

