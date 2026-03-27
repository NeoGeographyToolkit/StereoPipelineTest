#!/bin/bash
source ../bin/setup_env.sh

for file in run/ba/run-DIM_PER1_20171207153639_SEN_P_000041.adjusted_state.json      \
            run/ba/run-DIM_PER1_20171207153815_SEN_P_000041.adjusted_state.json      \
            run/jitter/run-run-DIM_PER1_20171207153639_SEN_P_000041.adjusted_state.json \
            run/jitter/run-run-DIM_PER1_20171207153815_SEN_P_000041.adjusted_state.json; do

  # Preserve subdir structure: run/ba/foo -> gold/ba/foo
  subdir=$(dirname $file | sed 's|^run/||')
  gold=gold/$subdir/$(basename $file)

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
