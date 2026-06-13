#!/bin/bash
source ../bin/setup_env.sh

# Negative case (neg): both options set, stereo_parse expected to fail.
# Positive control (pos): only --min-matches set, expected to succeed.
# Compare the recorded exit statuses against gold.
for tag in neg pos; do
  file=run/${tag}_status.txt
  gold=gold/${tag}_status.txt
  if [ ! -e "$file" ]; then echo "ERROR: File $file does not exist."; echo Validation failed; exit 1; fi
  if [ ! -e "$gold" ]; then echo "ERROR: File $gold does not exist."; echo Validation failed; exit 1; fi
  diff=$(diff $file $gold)
  if [ "$diff" != "" ]; then
    echo "Status mismatch for $tag: run=$(cat $file) gold=$(cat $gold)"
    echo Validation failed
    exit 1
  fi
done

echo Validation succeeded
exit 0
