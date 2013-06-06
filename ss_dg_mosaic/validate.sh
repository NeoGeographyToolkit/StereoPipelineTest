#!/bin/bash

for g in gold/run.r25.tif gold/run.r25.xml gold/run.small.png; do
  
  if [ ! -e "$g" ]; then
      echo "ERROR: File $g does not exist."
      exit 1
  fi

  f=${g/gold/run}
  if [ ! -e "$f" ]; then
      echo "ERROR: File $f does not exist."
      exit 1
  fi

  diff=$(cmp $f $g)
  echo diff is $diff
 
  if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
  fi

done

echo Validation succeded
exit 0

