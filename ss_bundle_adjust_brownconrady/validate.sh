#!/bin/bash
export PATH=../bin:$PATH

for file in                                      \
    run/indiv/run-left_sub16.brownconrady.tsai   \
    run/indiv/run-right_sub16.brownconrady.tsai  \
    run/shared/run-left_sub16.brownconrady.tsai  \
    run/shared/run-right_sub16.brownconrady.tsai \
    ; do 

  gold=$(echo $file | perl -p -e "s#run/#gold/#g")

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

echo Validation succeded
exit 0
