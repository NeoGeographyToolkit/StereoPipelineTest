#!/bin/bash

if grep -q "different ground sample distances" run/output.txt; then
  echo "PASS: GSD mismatch correctly detected"
  exit 0
else
  echo "FAIL: GSD mismatch error not found in output"
  exit 1
fi
