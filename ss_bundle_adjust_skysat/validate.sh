#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-a1000.adjust run/run-a1010.adjust run/run-a1020.adjust run/run-a1030.adjust run/run-a1040.adjust run/run-a1050.adjust; do 

  gold=${file/run/gold}

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  echo diff $file $gold
  diff $file $gold

  max_err.pl $file $gold # print the error
  ans=$(max_err.pl $file $gold 0.0001) # compare the error
  echo answer is $ans
  if [ "$ans" -eq 0 ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeded
exit 0
