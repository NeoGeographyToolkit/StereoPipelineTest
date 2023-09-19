#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-TC1W2B0_01_02934N034E0959.adjusted_state.json \
    run/run-TC1W2B0_01_02935N034E0949.adjusted_state.json \
    run/run-TC2W2B0_01_02934N036E0959.adjusted_state.json \
    run/run-TC2W2B0_01_02935N036E0949.adjusted_state.json; do 

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
  diff=$(diff $file $gold)

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeded
exit 0
