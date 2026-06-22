#!/bin/bash
source ../bin/setup_env.sh

# The input image names are very long and share a long common prefix (see run.sh),
# so the match file names are shortened: each image name is reduced to a leading
# part plus a hash of its full name. If this shortening logic regresses (for
# example, truncating names to a fixed length), the file names below will not be
# produced and the test will fail. The two hashes (af2535afe5c73746 and
# 92184d781eae8e2e) keep the pair distinct. See the ASP doc on match file naming.

for file in            \
    run/run-cas_cal_sc_20210725_16378_PAN_synthetic_test_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad__af2535afe5c73746__cas_cal_sc_20210725_16378_PAN_synthetic_test_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad__92184d781eae8e2e.match            \
    run/run-cas_cal_sc_20210725_16378_PAN_synthetic_test_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad__af2535afe5c73746__cas_cal_sc_20210725_16378_PAN_synthetic_test_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad_pad__92184d781eae8e2e-clean.match
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
