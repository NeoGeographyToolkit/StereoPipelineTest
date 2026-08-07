#!/bin/bash

# Triage a failed nightly: re-validate every failing test against its run/ dir and
# rank the failures by max error, worst first. Read the failing test names from a
# pytest report (report.txt by default), re-run each test's validate.sh (gdalinfo +
# diff only, NOT run.sh), and print PASS/FAIL plus the max abs err per test.
#
# Why: the ss*/validate_out.txt files on disk are stale manual scratch and lie. The
# only honest per-test diff is re-running validate.sh against the nightly run/ dir.
# See ~/projects/asp_regression_tests.sh "TRIAGING A FAILED NIGHTLY".
#
# Usage (from the test suite root, with the ASP test env active):
#   conda activate asp_deps        # provides gdalinfo/PROJ; also set ISISROOT/PATH
#   bash bin/triage_fails.sh [report.txt]

set -u

report=${1:-report.txt}

if [ ! -f "$report" ]; then
  echo "ERROR: report file not found: $report"
  echo "Run from the test suite root, or pass the report path as arg 1."
  exit 1
fi

if ! command -v gdalinfo > /dev/null 2>&1; then
  echo "ERROR: gdalinfo not on PATH. Activate the test env first (conda activate"
  echo "asp_deps) so validate.sh can compare. See asp_regression_tests.sh env section."
  exit 1
fi

# Failing test names from the pytest report (the test_run[<name>] entries).
tests=$(grep -oE 'test_run\[[^]]+\]' "$report" | sed 's/test_run\[//; s/\]//' | sort -u)

if [ -z "$tests" ]; then
  echo "No failing tests found in $report (nothing matched test_run[...])."
  exit 0
fi

rows=""
npass=0
nfail=0

for t in $tests; do
  if [ ! -d "$t" ] || [ ! -f "$t/validate.sh" ]; then
    rows+=$(printf "%-55s %-5s %s\n" "$t" "SKIP" "no dir or validate.sh")$'\n'
    continue
  fi
  out=$(cd "$t" && bash validate.sh 2>/dev/null)
  if echo "$out" | grep -qi "Validation succeeded"; then
    st=PASS
    npass=$((npass + 1))
  else
    st=FAIL
    nfail=$((nfail + 1))
  fi
  err=$(echo "$out" | grep -m1 "Max abs err" \
        | sed -E 's/ at line.*//; s/Max abs err is //')
  rows+=$(printf "%-55s %-5s %s\n" "$t" "$st" "${err:-NA}")$'\n'
done

echo "=== failures ranked by max abs err (worst first) ==="
printf '%s' "$rows" | sort -k3 -g -r
echo
echo "PASS=$npass  FAIL=$nfail  (re-validated against the nightly run/ dirs)"
