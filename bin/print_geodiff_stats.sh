#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 file1 file2; exit; fi

a=$1
b=$2

rm -fv tmp-diff* > /dev/null 2>&1
geodiff --absolute $a $b -o tmp > /dev/null 2>&1
gdalinfo -stats tmp-diff.tif | grep -i Maximum | grep -i --colour=auto mean
rm -fv tmp-diff* > /dev/null 2>&1
