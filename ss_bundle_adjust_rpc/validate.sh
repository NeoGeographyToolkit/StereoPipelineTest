#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.adjust           \
            run/run-09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.adjust           \
            run/run-convergence_angles.txt                                              \
            run/run-triangulation_uncertainty.txt                                       \
            run/run-09OCT11191503-P1BS_R1C1-052783426010_01_P001_sub10.adjusted_rpc.xml \
            run/run-09OCT11191555-P1BS_R1C1-052783426010_01_P001_sub10.adjusted_rpc.xml \
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
