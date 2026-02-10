#!/bin/bash
export PATH=../bin:$PATH

for file in \
    run/merged-left_sub16__right_sub16.match \
    run/sift-left_sub16__right_sub16.txt     \
    run/sift-left_sub16__right_sub16.match; do

    gold=$(echo $file | perl -p -e "s#run/#gold/#g")

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1
    fi

    echo Comparing $file and $gold

    diff=$(cmp $file $gold 2>&1)

    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeeded
exit 0
