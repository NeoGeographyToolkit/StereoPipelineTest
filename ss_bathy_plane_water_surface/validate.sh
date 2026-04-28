#!/bin/bash
source ../bin/setup_env.sh

for file in run/plane.txt; do

  gold=gold/$(basename $file)

  echo $file $gold

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  diff=$(cmp $file $gold 2>&1)

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeeded
exit 0
