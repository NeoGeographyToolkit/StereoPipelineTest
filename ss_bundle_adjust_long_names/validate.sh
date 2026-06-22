#!/bin/bash
source ../bin/setup_env.sh

# The image names are long, so the match file names use the full, untruncated
# image names. If the name shortening logic regresses (for example, truncating
# names to a fixed length), these full-name files will not be produced and the
# test will fail. See the ASP doc section on match file naming.

L=cas_cal_sc_20210725T202821-20210725T202825-16378-10-PAN-838849161-8-0__4_0
R=cas_cal_sc_20210725T202911-20210725T202915-16378-10-PAN-838849162-2-0__4_0

for file in                      \
    run/run-${L}__${R}.match     \
    run/run-${L}__${R}-clean.match
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
