#!/bin/bash
source ../bin/setup_env.sh

 for file in run/run-left_bathy.adjusted_state.json \
             run/run-right_bathy.adjusted_state.json; do \
                
    gold=gold/$(basename $file)
    echo Comparing $file $gold
    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi

    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi

    # Print the error and check the status
    ../bin/max_err.pl $file $gold 
    ans=$?
    if [ "$ans" -ne 0 ]; then
        echo Validation failed
        exit 1
    fi

    ans=$(../bin/max_err.pl $file $gold 5e-8)
    if [ "$ans" != "1" ]; then
        echo Validation failed
        exit 1
    fi

done

# The bathy run must classify the triangulated points in the final pointmap.csv
# as land or water. Fail if either tag is missing.
pointmap=run/run-final_residuals_pointmap.csv
for tag in "# water" "# land"; do
    if ! grep -q "$tag" $pointmap; then
        echo "ERROR: Did not find '$tag' in $pointmap."
        echo Validation failed
        exit 1
    fi
done

echo Validation succeeded
exit 0
