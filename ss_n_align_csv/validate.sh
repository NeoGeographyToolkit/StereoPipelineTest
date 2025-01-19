#!/bin/bash

for ((i = 0; i < 3; i++)); do
	runTrans=run/run-transform-${i}.txt
	goldTrans=gold/run-transform-${i}.txt
	if [ ! -f "$runTrans" ]; then
		echo Missing $runTrans
		exit 1
	fi
	if [ ! -f "$goldTrans" ]; then
		echo Missing $goldTrans
		exit 1
	fi

	ans=$(diff $runTrans $goldTrans)
	if [ "$ans" != "" ]; then
		echo $runTrans and $goldTrans differ
		exit 1
	else
		echo $runTrans is same as $goldTrans
	fi
done

echo Validation succeeded
exit 0
