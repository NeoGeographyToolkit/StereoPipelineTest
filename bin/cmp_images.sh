#!/bin/bash

plainDiff=0
if [ "$#" -eq 3 ]; then
    shift
    plainDiff=1
fi

out1=tmpimg1.txt
out2=tmpimg2.txt

# Remove cached xmls
rm -fv "$1.aux.xml"
rm -fv "$2.aux.xml"

echo $1 > $out1
echo $2 > $out2

# Sanity checks, this is a bugfix for byss
opts="-proj4"
gdalinfo -stats $opts $1 > /dev/null
status="$?"
if [ $status -ne 0 ]; then
    echo "gdalinfo does not support option: $opts"
    opts=""
fi

gdalinfo -stats $opts $1 | grep -v Min= | grep -v .tif | perl -pi -e "s#=# = #g" >> $out1
gdalinfo -stats $opts $2 | grep -v Min= | grep -v .tif | perl -pi -e "s#=# = #g" >> $out2

if [ "$plainDiff" -eq 1 ]; then
    diff $out1 $out2
else
    tkdiff $out1 $out2
fi

max_err.pl  $out1 $out2
rm -f $out1 $out2
