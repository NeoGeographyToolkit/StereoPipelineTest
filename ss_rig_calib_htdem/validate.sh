#!/bin/bash
export PATH=../bin:$PATH

# Some files are expected to be the same each time. Check for that
for file in run/cameras.nvm; do 

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1
  fi
  
  # replace run/ with gold/
  gold=gold/$(basename $file)
    
  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1
  fi
  
  diff=$(diff $file $gold | head -n 50)
  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi
done

echo Validation succeeded
exit 0

