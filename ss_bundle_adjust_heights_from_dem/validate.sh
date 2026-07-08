#!/bin/bash
source ../bin/setup_env.sh

for file in run/run-*tsai run/run-mapproj_match_offsets.txt run/run-mapproj_match_offset_stats.txt; do

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

# Validate --heights-from-dem-list
for file in run/run2*tsai; do

  ref=$(echo $file | sed 's|run/run2|run/run|')

  if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1;
  fi

  if [ ! -e "$ref" ]; then
      echo "ERROR: File $ref does not exist."
      exit 1;
  fi

  echo diff $file $ref
  diff=$(diff $file $ref | head -n 50)

  echo diff is $diff
  if [ "$diff" != "" ]; then
      echo "Validation failed: --heights-from-dem-list differs from --heights-from-dem"
      exit 1
  fi

done

echo Validation succeeded
exit 0
