#!/bin/bash
source ../bin/setup_env.sh

for file in run/ba/run-spot5_front_crop.adjusted_state.json              \
            run/ba/run-spot5_back_crop.adjusted_state.json               \
            run/jitter/run-run-spot5_front_crop.adjusted_state.json      \
            run/jitter/run-run-spot5_back_crop.adjusted_state.json; do

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
