#!/bin/bash
source ../bin/setup_env.sh

cams="TC1W2B0_01_02934N034E0959 TC1W2B0_01_02935N034E0949 \
  TC2W2B0_01_02934N036E0959 TC2W2B0_01_02935N036E0949"

for dir in fixed_center float_center; do
  for cam in $cams; do

    file=run/$dir/run-$cam.adjusted_state.json
    gold=gold/$dir/run-$cam.adjusted_state.json

    if [ ! -e "$file" ]; then
      echo "ERROR: File $file does not exist."
      exit 1
    fi

    if [ ! -e "$gold" ]; then
      echo "ERROR: File $gold does not exist."
      exit 1
    fi

    echo diff $file $gold
    diff=$(diff $file $gold | head -n 50)

    echo diff is $diff
    if [ "$diff" != "" ]; then
      echo Validation failed
      exit 1
    fi

  done
done

# Check the sharing: focal length and distortion shared within each sensor and
# not across sensors, optical center per camera.
python3 - $cams <<'EOF'
import json, sys

def load(f):
  t = open(f).read()
  return json.loads(t[t.index('{'):])

def intr(d):
  return ((d['m_detectorSampleOrigin'], d['m_detectorLineOrigin']),
          d['m_focalLength'], d['m_opticalDistCoeffs'])

cams = sys.argv[1:]
ok = True
for run in ['fixed_center', 'float_center']:
  v = [intr(load('run/' + run + '/run-' + c + '.adjusted_state.json')) for c in cams]
  c1a, c1b, c2a, c2b = [x[0] for x in v]
  f1a, f1b, f2a, f2b = [x[1] for x in v]
  d1a, d1b, d2a, d2b = [x[2] for x in v]
  checks = [('focal length shared in TC1', f1a == f1b),
            ('focal length shared in TC2', f2a == f2b),
            ('focal length differs across sensors', f1a != f2a),
            ('distortion shared in TC1', d1a == d1b),
            ('distortion shared in TC2', d2a == d2b),
            ('distortion differs across sensors', d1a != d2a)]
  if run == 'fixed_center':
    checks += [('TC1 camera 1 center kept', c1a == (2048.0, 0.5)),
               ('TC1 camera 2 center kept', c1b == (2073.0, 3.5)),
               ('TC2 camera 1 center kept', c2a == (2048.0, 0.5)),
               ('TC2 camera 2 center kept', c2b == (2048.0, 0.5))]
  else:
    checks += [('centers differ per camera', len(set([c1a, c1b, c2a, c2b])) == 4)]
  for name, res in checks:
    print(run + ': ' + name + ': ' + ('yes' if res else 'NO'))
    ok = ok and res
sys.exit(0 if ok else 1)
EOF

if [ $? -ne 0 ]; then
  echo Validation failed
  exit 1
fi

echo Validation succeeded
exit 0
