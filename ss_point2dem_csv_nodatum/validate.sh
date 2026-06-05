#!/bin/bash
source ../bin/setup_env.sh

# Case 1 (negative): point2dem must have failed, and specifically via the
# datum guard, not for some unrelated reason.
neg_status=$(cat run/neg_status.txt 2>/dev/null)
gold_neg=$(cat gold/neg_status.txt 2>/dev/null)
if [ "$neg_status" != "$gold_neg" ]; then
  echo "Validation failed: negative exit status '$neg_status', expected '$gold_neg'."
  exit 1
fi
if ! grep -q "require an explicit datum or SRS" run/neg_out.txt; then
  echo "Validation failed: point2dem failed but not via the datum guard."
  exit 1
fi

# Case 2 (positive control): point2dem must have succeeded and written a DEM.
pos_status=$(cat run/pos_status.txt 2>/dev/null)
gold_pos=$(cat gold/pos_status.txt 2>/dev/null)
if [ "$pos_status" != "$gold_pos" ]; then
  echo "Validation failed: positive exit status '$pos_status', expected '$gold_pos'."
  exit 1
fi
if [ ! -e run/pos-DEM.tif ]; then
  echo "Validation failed: positive control did not produce run/pos-DEM.tif."
  exit 1
fi

echo Validation succeeded
exit 0
