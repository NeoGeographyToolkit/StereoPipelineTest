#!/bin/bash
export PATH=../bin:$PATH

for file in \
    run/log/run-left_sub16__right_sub16.match       \
    run/log/run-left_sub16__right_sub16_v2.match    \
    run/obalog/run-left_sub16__right_sub16.match    \
    run/obalog/run-left_sub16__right_sub16_v2.match \
    run/sift/run-left_sub16__right_sub16.match      \
    run/sift/run-left_sub16__right_sub16_v2.match   \
    run/orb/run-left_sub16__right_sub16.match       \
    run/orb/run-left_sub16__right_sub16_v2.match    \
    run/log/matches.txt                             \
    run/log/matches_v2.txt                          \
    run/obalog/matches.txt                          \
    run/obalog/matches_v2.txt                       \
    run/sift/matches.txt                            \
    run/sift/matches_v2.txt                         \
    run/orb/matches.txt                             \
    run/orb/matches_v2.txt
  do 

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
