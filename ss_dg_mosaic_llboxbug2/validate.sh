#!/bin/bash
export PATH=../bin:$PATH

for g in gold/run.r100.xml; do

  if [ ! -e "$g" ]; then
      echo "ERROR: File $g does not exist."
      exit 1
  fi

  f=${g/gold/run}
  if [ ! -e "$f" ]; then
      echo "ERROR: File $f does not exist."
      exit 1
  fi

  diff $f $g
  
  max_err.pl $f $g # print the error
  ans=$(max_err.pl $f $g 1e-10) # compare the error
  if [ "$ans" -eq 0 ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeded
exit 0

