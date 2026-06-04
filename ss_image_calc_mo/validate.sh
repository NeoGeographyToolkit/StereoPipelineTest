#!/bin/bash
source ../bin/setup_env.sh

file=run/output.tif

if [ ! -e "$file" ]; then
    echo "ERROR: File $file does not exist."
    exit 1
fi

# Read the geoheader metadata. No gold image is needed; we check that the
# metadata round-trips, which is independent of the GDAL/PROJ version.
rm -fv "$file.aux.xml"
gdalinfo "$file" > run/info.txt

# Each pair must appear verbatim. This confirms that values with spaces and
# equal signs are preserved, like the GDAL -mo option, and that the option can
# be repeated or hold several pairs in one string.
status=0
while IFS= read -r expect; do
    [ -z "$expect" ] && continue
    if ! grep -qF "$expect" run/info.txt; then
        echo "ERROR: missing metadata: $expect"
        status=1
    fi
done <<'EOF'
VAR1=val1
VAR2=val2
VAR3=value with spaces
VAR4=a = b
EOF

rm -f run/info.txt

if [ "$status" != "0" ]; then
    echo Validation failed
    exit 1
fi

echo Validation succeeded
exit 0
