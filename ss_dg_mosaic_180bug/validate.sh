#!/bin/bash
export PATH=../bin:$PATH

g=gold/run.r100.tif

if [ ! -e "$g" ]; then
    echo "ERROR: File $g does not exist."
    exit 1
fi

f=${g/gold/run}
if [ ! -e "$f" ]; then
    echo "ERROR: File $f does not exist."
    exit 1
fi

gdalinfo -stats $f > $f.txt
gdalinfo -stats $g > $g.txt
ans=$?
if [ "$ans" -ne 0 ]; then
    echo Validation failed
    exit 1
fi

max_err.pl $f.txt $g.txt # print the error
ans=$(max_err.pl $f.txt $g.txt 1e-8) # compare the error
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

# Compare xml files

g=gold/run.r100.xml
  
if [ ! -e "$g" ]; then
    echo "ERROR: File $g does not exist."
    exit 1
fi

f=${g/gold/run}
if [ ! -e "$f" ]; then
    echo "ERROR: File $f does not exist."
    exit 1
fi
  
max_err.pl $f $g # print the error
ans=$(max_err.pl $f $g 1e-8) # compare the error
if [ "$ans" -eq 0 ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0


