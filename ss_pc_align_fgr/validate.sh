#!/bin/bash
export PATH=../bin:$PATH

# This validation script has to deal with the fact that this test returns close but non-unque
# results. For example, two runs can return these values for the output errors:

# Output: mean of smallest errors (meters): 25%: 0.101385, 50%: 0.218089, 75%: 0.368646, 100%: 3.22971
# Output: mean of smallest errors (meters): 25%: 0.102273, 50%: 0.218718, 75%: 0.369394, 100%: 3.23402

# Yet, the 50-th percentile error is about the same, 0.22. Hence, parse for this number from
# the current run's log file and from the gold log file, and see if they equal each other
# when rounded to two digits. This logic uses bash, awk and perl, and ideally this
# should be converted to python.

runLog=$(ls -atrd run/*log* | tail -n 1)
if [ ! -f "$runLog" ]; then
	echo Missing file $runLog
	exit 1
fi

runErr=$(grep "Output: mean of smallest errors" $runLog | awk '{print $17}' | perl -pi -e 's#(0.\d+).*?$#int($1*100+0.5)/100#eg')

goldLog=$(ls -atrd gold/*log* | tail -n 1)
goldErr=$(grep "Output: mean of smallest errors" $goldLog | awk '{print $17}' | perl -pi -e 's#(0.\d+).*?$#int($1*100+0.5)/100#eg')

echo $runErr > run.txt
echo $goldErr > gold.txt

diff run.txt gold.txt

max_err.pl run.txt gold.txt # print the error
ans=$(max_err.pl run.txt gold.txt 0.75) # compare the error
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

rm -f run.txt gold.txt

echo Validation succeeded
exit 0
