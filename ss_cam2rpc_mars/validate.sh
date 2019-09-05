#!/bin/bash
export PATH=../bin:$PATH

for file in run/run.tif run/run.xml; do

  gold=${file/run\/run/gold\/run}

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1;
  fi

  echo cmp $file $gold
  diff=$(cmp $file $gold)

  echo diff is $diff
  if [ "$file" = "run/run.tif" ]; then
      # The gold tif file must be same as the current one
      if [ "$diff" != "" ]; then
          echo Validation failed
          exit 1
      fi
  else
      # For the xml file, compare the values with a relative error threshold
      if [ "$file" = "run/run.xml" ]; then
          max_err.pl $file $gold # print the error
          ans=$(max_err.pl $file $gold 1e-8) # compare the error
          if [ "$ans" -eq 0 ]; then
          echo Validation failed
          exit 1
          fi
      fi
  fi
done

echo Validation succeded
exit 0
