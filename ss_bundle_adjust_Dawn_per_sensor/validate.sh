#!/bin/bash
export PATH=../bin:$PATH

# Check the state files
for f in run/run1-FC21B0004011_11224024300F1E.adjusted_state.json \
         run/run1-FC21B0004012_11224030401F1E.adjusted_state.json \
         run/run2-FC21B0004011_11224024300F1E.adjusted_state.json \
         run/run2-FC21B0004012_11224030401F1E.adjusted_state.json; do

        g=${f/run\//gold\/}
        echo $f $g;
        if [ ! -f "$f" ] || [ ! -f "$g"  ]; then
                echo "ERROR: Missing $f or $g"
                exit 1
        fi

    diff=$(diff $f $g)
        echo Diff for $f is $diff
    if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
    fi
done

echo Validation succeded
exit 0
