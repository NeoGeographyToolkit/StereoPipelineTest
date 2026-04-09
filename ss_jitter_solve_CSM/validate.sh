#!/bin/bash
source ../bin/setup_env.sh

for file in run/run-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json \
            run/run-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json \
            run/jitter-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json \
            run/jitter-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json; do 

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

# Check the GCP file with a tolerance
file=run/jitter-cnet.gcp
gold=gold/jitter-cnet.gcp
if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi
if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi
echo diff $file $gold
../bin/max_err.pl $file $gold
tol=0.01
echo Comparing absolute error with $tol
ans=$(../bin/max_err.pl $file $gold | grep abs | awk '{print ($5 < '$tol')}')
if [ "$ans" -ne 1 ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
