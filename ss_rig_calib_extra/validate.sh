#!/bin/bash
export PATH=../bin:$PATH

for file in run/rig_config.txt                \
    run/cameras.nvm; do 
  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1
  fi
  
  # same for gold
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

echo Validation succeded
exit 0
