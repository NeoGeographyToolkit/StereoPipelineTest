#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-DMS_20171029_183704_02500.adjust run/run-DMS_20171029_183706_02501.adjust run/run-DMS_20171029_183707_02502.adjust; do
  gold=${file/run\/run/gold\/run}

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
