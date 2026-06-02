#!/bin/bash
source ../bin/setup_env.sh

# Goal: a 0-height pixel in the DEM must stay a valid 0-height pixel after
# masking with the documented command, instead of being turned into nodata.

stat() { gdalinfo -stats "$1" 2>/dev/null | grep -m1 "$2" | sed 's/.*=//'; }

dem_valid=$(stat run/dem_clip_min_ht0.tif STATISTICS_VALID_PERCENT)
new_min=$(stat run/masked_new.tif STATISTICS_MINIMUM)
new_valid=$(stat run/masked_new.tif STATISTICS_VALID_PERCENT)
old_valid=$(stat run/masked_old.tif STATISTICS_VALID_PERCENT)

echo "DEM valid%        = $dem_valid"
echo "new-masked min    = $new_min   valid% = $new_valid"
echo "old-masked valid% = $old_valid"

ok=1
# New approach: 0-height pixels preserved, so min stays 0 and valid% unchanged.
awk "BEGIN{exit !($new_min == 0)}" \
  || { echo "FAIL: new-masked min height is not 0"; ok=0; }
awk "BEGIN{exit !($new_valid == $dem_valid)}" \
  || { echo "FAIL: new-masked valid% changed (0-height pixels lost)"; ok=0; }
# Old approach: 0-height pixels nuked, so valid% strictly lower.
awk "BEGIN{exit !($old_valid < $dem_valid)}" \
  || { echo "FAIL: old approach did not drop the 0-height pixels"; ok=0; }

if [ $ok -eq 1 ]; then
  echo "Validation succeeded"; exit 0
else
  echo "Validation failed"; exit 1
fi
