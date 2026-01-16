#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-2024-08-08-02-33-49_UMBRA-05_GEC.adjust run/run-2024-06-30-03-03-56_UMBRA-04_GEC.adjust; do 

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

echo Validation succeeded
exit 0
