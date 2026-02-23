#!/bin/bash

# TODO(oalexan1): This test needs gold generated on lunokhod1 before it can
# be enabled. Run with the release build, rename run to gold, then remove
# the early exit below.
exit 0

for file in \
    run/left_sub16.vwip                       \
    run/right_sub16.vwip                      \
    run/run-left_sub16__right_sub16.match; do

    gold=$(echo $file | perl -p -e "s#run/#gold/#g")

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi

    echo Comparing $file and $gold

    ans=$(cmp $file $gold 2>&1)

    if [ "$ans" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeeded
exit 0
