#!/bin/bash
source ../bin/setup_env.sh

# Compare the two adjusted optical-bar cameras (velocity mode) against gold.
for file in run/run-D3C1216-200533A021_crop_sub16.tsai \
            run/run-D3C1216-200533F021_crop_sub16.tsai; do

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
