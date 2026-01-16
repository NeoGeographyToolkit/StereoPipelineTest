#!/bin/bash
export PATH=../bin:$PATH

for file in run/run-0009996.795966815-c1.tif run/run-0009996.795966815-c3.map.tif; do
    
    gold=gold/$(basename $file)

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

    diff=$(diff run/run.txt gold/run.txt |grep -E "Minimum=|Maximum=")
    
    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi

done

# Also validate the tsai files
for file in \
  run/run-0010003.204033185-c1.tsai \
  run/run-0010003.204033185-c1-ref.tsai \
  run/run-0010003.204033185-c2.tsai run/run-0010003.204033185-c2-ref.tsai\
  ; do 
    gold=gold/$(basename $file)
    echo Comparing $file and $gold 
    diff=$(diff $file $gold | head -n 50)
    echo diff is $diff
    if [ "$diff" != "" ]; then
        echo Validation failed
        exit 1
    fi
done

echo Validation succeeded
exit 0

