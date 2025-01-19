#!/bin/bash
export PATH=../bin:$PATH

for file in \
	run/ba-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json  \
	run/ba-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json \
	run/jitter-B17_016219_1978_XN_17N282W.8bit.adjusted_state.json \
	run/jitter-B18_016575_1978_XN_17N282W.8bit.adjusted_state.json \
			; do 

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
  diff=$(diff $file $gold | head -n 50)

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeeded
exit 0

