#!/bin/bash
export PATH=../bin:$PATH

for file in run/theia_fltr/cameras.nvm; do

  gold=${file/run\/run/gold\/run}
  echo Comparing: $file $gold

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  diff=$(diff $file $gold | head -n 10)

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeeded
exit 0
