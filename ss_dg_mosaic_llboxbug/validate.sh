#!/bin/bash
export PATH=../bin:$PATH

for g in gold/run.r100.xml; do

  if [ ! -e "$g" ]; then
      echo "ERROR: File $g does not exist."
      exit 1
  fi

  f=${g/gold/run}
  if [ ! -e "$f" ]; then
      echo "ERROR: File $f does not exist."
      exit 1
  fi

  cat $f | perl -pi -e "s#(\<|\>)# \$1 #g" > run.txt
  cat $g | perl -pi -e "s#(\<|\>)# \$1 #g" > gold.txt
  max_err.pl run.txt gold.txt

  diff=$(cmp $f $g)
  echo diff is $diff

  if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
  fi

done

echo Validation succeded
exit 0

