#!/bin/bash
source ../bin/setup_env.sh

log=run/run-log.txt
out=run/dem_detrend.tif
gold=gold/dem_detrend.tif

for f in "$out" run/trend.tif "$log" "$gold"; do
    if [ ! -e "$f" ]; then
        echo "ERROR: File $f does not exist."
        exit 1
    fi
done

# Behavioral check: the known smooth bias must be removed. Parse the before and
# after residual NMAD (robust spread of control point minus DEM) from the log.
before=$(grep "before_clean" "$log" | grep -oE "NMAD=[0-9.]+" | cut -d= -f2)
after=$(grep "after_clean"  "$log" | grep -oE "NMAD=[0-9.]+" | cut -d= -f2)

if [ -z "$before" ] || [ -z "$after" ]; then
    echo "ERROR: Could not parse before/after NMAD from the log."
    exit 1
fi

echo "Control point NMAD: before=$before after=$after m"

ok=$(awk -v b="$before" -v a="$after" \
    'BEGIN{print (a < 0.10 && a < 0.5*b) ? "1" : "0"}')
if [ "$ok" != "1" ]; then
    echo "Detrend did not remove the trend (after NMAD too large)."
    exit 1
fi

# Regression check: the output DEM mean and stddev against the gold, with a
# relative tolerance. The spline solve can shift in the last digits across
# numpy and BLAS versions, so an exact gdalinfo diff is too strict here.
rm -fv "$out.aux.xml" "$gold.aux.xml"
gdalinfo -stats "$out"  | grep -E "STATISTICS_MEAN|STATISTICS_STDDEV" > run/stats.txt
gdalinfo -stats "$gold" | grep -E "STATISTICS_MEAN|STATISTICS_STDDEV" > run/goldstats.txt
rm -fv "$out.aux.xml" "$gold.aux.xml"

tol=0.01
fail=0
while IFS= read -r line; do
    key=$(echo "$line" | cut -d= -f1)
    val=$(echo "$line" | cut -d= -f2)
    goldval=$(grep "$key=" run/goldstats.txt | cut -d= -f2)
    if [ -z "$goldval" ]; then
        echo "ERROR: $key not in gold."; fail=1; continue
    fi
    good=$(awk -v a="$val" -v b="$goldval" -v t="$tol" \
        'BEGIN{d=a-b; if(d<0)d=-d; r=(b!=0)?d/(b<0?-b:b):d; print (r<=t)?"1":"0"}')
    echo "$key run=$val gold=$goldval"
    if [ "$good" != "1" ]; then fail=1; fi
done < run/stats.txt
rm -f run/stats.txt run/goldstats.txt

if [ "$fail" != "0" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
