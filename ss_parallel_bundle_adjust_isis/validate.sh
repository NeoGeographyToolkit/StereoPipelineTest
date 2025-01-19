#!/bin/bash
export PATH=../bin:$PATH

for file in run/*adjust \
	run/run-final_residuals_pointmap.csv \
	run/run-cnet-final_residuals_pointmap.csv \
	run/run-cnet2-final_residuals_pointmap.csv; do

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
