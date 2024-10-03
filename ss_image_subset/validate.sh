#!/bin/bash
export PATH=../bin:$PATH

file=run/subset.txt
gold=gold/subset.txt

# Both must exist
if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1;
fi
if [ ! -e "$gold" ]; then
    echo "ERROR: File $gold does not exist."
    exit 1;
fi

# They must agree
diff=$(diff $file $gold)
if [ "$diff" != "" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeded
exit 0
