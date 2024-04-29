#!/bin/bash
export PATH=../bin:$PATH

# It is vary hard to do proper validation as the results are not unique.
# For now, just check if the files were at least successfully created
for file in run/submap1.nvm run/submap2.nvm run/merged.nvm; do 

  gold=${file/run\//gold\/}
  echo $file $gold

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  diff=$(diff $file $gold | head -n 50)

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeded
exit 0
