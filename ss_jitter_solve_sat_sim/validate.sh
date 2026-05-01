#!/bin/bash
source ../bin/setup_env.sh

for file in run/run-f.adjusted_state.json run/run-n.adjusted_state.json \
    run/run-weight-f.adjusted_state.json run/run-weight-n.adjusted_state.json \
    run/run-weight-mapproj_match_offset_stats.txt; do
    
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

# Sanity check: pixel reprojection error mean must be reasonable. Catches
# the case where the optimization diverged but adjusted_state JSON still
# happens to match a previously-recorded bad gold.
tol=5.0
for stats in run/run-final_residuals_stats.txt run/run-weight-final_residuals_stats.txt; do
    if [ ! -e "$stats" ]; then
        echo "ERROR: missing stats file: $stats"
        exit 1
    fi
    bad=$(awk -F', *' -v tol=$tol '$1 !~ /^#/ && $1 != "" && $2+0 > tol {print $1": mean="$2}' "$stats")
    if [ -n "$bad" ]; then
        echo "ERROR: pixel reprojection mean exceeds $tol px in $stats:"
        echo "$bad"
        exit 1
    fi
done

echo Validation succeeded
exit 0

