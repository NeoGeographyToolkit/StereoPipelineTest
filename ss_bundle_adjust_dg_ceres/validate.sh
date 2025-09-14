#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-WV01_11JAN131652275-P1BS-10200100104A0300.r12.adjust \
        	run/run-WV01_11JAN131653225-P1BS-1020010011862E00.r12.adjust \
			run/run.nvm; do 

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
  ../bin/max_err.pl $file $gold

  tol=0.01
  echo Comparing absolute error with $tol
  ans=$(../bin/max_err.pl $file $gold | grep abs | awk '{print ($5 < '$tol')}')
  if [ "$ans" -ne 1 ]; then
      echo Validation failed
      exit 1
  fi

done

echo Validation succeeded
exit 0
