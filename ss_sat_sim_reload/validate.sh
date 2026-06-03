#!/bin/bash
source ../bin/setup_env.sh

# The more-lines effect: the native render uses the camera's 16 lines, the
# tall render uses the requested 100 lines (more than the camera has). The raw
# image dimensions must match --image-size exactly (no square-pixel adjust).
declare -a sizes=( "run/reload_ls_native/run-run.tif:Size is 100, 16"
                   "run/reload_ls/run-run.tif:Size is 100, 100" )
for item in "${sizes[@]}"; do
    file=${item%%:*}
    want=${item#*:}
    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi
    got=$(gdalinfo "$file" | grep "Size is")
    echo "$file: $got (expected: $want)"
    if [ "$got" != "$want" ]; then
        echo Validation failed
        exit 1
    fi
done

# The reloaded images must exist (they do not get created before the velocity
# fix, since sat_sim errors out for the linescan case). Compare statistics
# against gold, for the native and tall linescan reloads and the pinhole reload.
for file in run/reload_ls_native/run-run.tif run/reload_ls/run-run.tif run/reload_pin/run-run-10000.tif; do

    # Qualify the gold name with the parent dir, as some basenames collide.
    gold=gold/$(basename $(dirname $file))-$(basename $file)

    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi

    echo Comparing $file and $gold
    gdalinfo -stats $file | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > run/run.txt
    gdalinfo -stats $gold | grep -v Files | grep -v -i tif | grep -i -v size | grep -v Left | grep -v Right > gold/run.txt

    diff=$(diff run/run.txt gold/run.txt | grep -E "Minimum=|Maximum=")
    rm -f run/run.txt gold/run.txt

    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

echo Validation succeeded
exit 0
