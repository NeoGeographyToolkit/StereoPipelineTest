#!/bin/bash
source ../bin/setup_env.sh

# Gold-diff the two RPC cameras cam2rpc wrote (datum via --t_srs and via explicit
# axes). A byte-identical match to gold confirms both the Europa datum (sphere
# radius 1,560,800 m) and the RPC coefficients.
for file in run/eur_tsrs.xml run/eur_axes.xml; do

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

echo Validation succeeded
exit 0
