#!/bin/bash
export PATH=../bin:$PATH

# Test .tsai files produced by first run, and then adjust files produced by last run
for file in run/*tsai run/run-v2-left_sub16.null.adjust; do

  gold=gold/$(basename $file)

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  echo diff $file $gold
  diff=$(diff $file $gold | head -n 50)

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi

done

# Test that the cnet got produced.
# This file may contain a creation time, so 
# its actual content will change just because of that.
for file in run/run-cnet.net; do 
 gold=gold/$(basename $file)

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  echo File $file exists

done

echo Validation succeeded
exit 0
