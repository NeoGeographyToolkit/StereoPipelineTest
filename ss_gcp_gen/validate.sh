#!/bin/bash
export PATH=../bin:$PATH

for file in run/run.gcp run/run-img_pitch_minus40.tsai; do

  gold=${file/run\/run/gold\/run}

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  ans=$(diff $file $gold)
  echo Diff is $ans
  if [ -n "$ans" ]; then
      echo Validation failed
      exit 1
  fi
done

echo Validation succeeded
exit 0

