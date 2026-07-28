#!/bin/bash
source ../bin/setup_env.sh

for file in \
    run/log/run-left_sub16__right_sub16.match       \
    run/log/run-left_sub16__right_sub16_v2.match    \
    run/obalog/run-left_sub16__right_sub16.match    \
    run/obalog/run-left_sub16__right_sub16_v2.match \
    run/sift/run-left_sub16__right_sub16.match      \
    run/sift/run-left_sub16__right_sub16_v2.match   \
    run/orb/run-left_sub16__right_sub16.match       \
    run/orb/run-left_sub16__right_sub16_v2.match    \
    run/log/matches.txt                             \
    run/log/matches_v2.txt                          \
    run/obalog/matches.txt                          \
    run/obalog/matches_v2.txt                       \
    run/sift/matches.txt                            \
    run/sift/matches_v2.txt                         \
    run/orb/matches.txt                             \
    run/orb/matches_v2.txt
  do 

    gold=$(echo $file | perl -p -e "s#run/#gold/#g")
    
    if [ ! -e "$file" ]; then
        echo "ERROR: File $file does not exist."
        exit 1;
    fi
    
    if [ ! -e "$gold" ]; then
        echo "ERROR: File $gold does not exist."
        exit 1;
    fi
    
    echo Comparing $file and $gold
    
    ans=$(cmp $file $gold 2>&1)
    
    if [ "$ans" != "" ]; then
        echo Validation failed
        exit 1
    fi
    
done

# The OpenCV AKAZE and KAZE detectors are new. Rather than an exact gold compare
# (the OpenCV detectors are not guaranteed byte-identical across library builds),
# just make sure each produced some matches that are not all in one spot. This is
# a loose sanity check, not a bullet-proof test.
for method in akaze kaze; do
    mf=run/${method}/run-left_sub16__right_sub16.match
    if [ ! -e "$mf" ]; then
        echo "ERROR: File $mf does not exist."
        exit 1
    fi
    n=$(python3 -c "import struct,sys; print(struct.unpack('<Q', open('$mf','rb').read(8))[0])")
    echo "$method matches: $n"
    if [ "$n" -lt 5 ]; then
        echo "ERROR: $method produced only $n matches (expected at least a few)."
        exit 1
    fi
    # Coverage: the matches should not all sit in one tiny spot. Check that the
    # interest points spread out at least a little in x and y, using the txt dump.
    cov=$(python3 -c "
xs=[]; ys=[]
for ln in open('run/${method}/matches.txt'):
    p=ln.split()
    if len(p)<4: continue
    try: xs.append(float(p[0])); ys.append(float(p[1]))
    except: pass
ok = xs and ys and (max(xs)-min(xs)>30) and (max(ys)-min(ys)>30)
print(1 if ok else 0)
")
    if [ "$cov" != "1" ]; then
        echo "ERROR: $method matches do not spread out at all."
        exit 1
    fi
    echo "$method coverage OK"
done

# BRISK: detect-only check produced interest points.
if [ ! -s run/brisk/left_sub16.vwip ]; then
    echo "ERROR: brisk did not produce interest points."
    exit 1
fi
echo "brisk interest points OK"

echo Validation succeeded
exit 0
