#!/bin/bash

set -x verbose
rm -rfv run
mkdir -p run

# Find the 'bathy' conda env python. It has extra modules (gdal, scipy, numpy)
# that are not in ASP's own python. The conda base differs by machine
# (miniconda3 on the nightly, anaconda3 on a Mac) and both may be present, so
# probe them in a fixed order and use the first that has the env.
bathy_py=""
for base in "$HOME/miniconda3" "$HOME/anaconda3"; do
    if [ -x "$base/envs/bathy/bin/python" ]; then
        bathy_py="$base/envs/bathy/bin/python"
        break
    fi
done
if [ -z "$bathy_py" ]; then
    echo "ERROR: could not find the bathy conda env python." 1>&2
    exit 1
fi

# Generate a tiny self-contained test case: a smooth DEM, and control points
# whose heights equal the DEM plus a known smooth bias field. dem_detrend must
# fit and remove that bias, pulling the DEM onto the control points. This keeps
# the test fully reproducible with no external data to stage.
$bathy_py - <<'PY'
import numpy as np
from osgeo import gdal
gdal.UseExceptions()
nx, ny, res = 160, 120, 2.0
x0, y0 = 340000.0, 3030000.0            # UTM 17N, like the Florida site
gt = (x0, res, 0.0, y0, 0.0, -res)
# A gentle bowl terrain, with a nodata border.
cx, cy = np.meshgrid(np.arange(nx), np.arange(ny))
dem = -3.0 + 0.0004 * ((cx - nx/2)**2 + (cy - ny/2)**2)
nod = -3.4e38
dem[:4] = nod; dem[-4:] = nod; dem[:, :4] = nod; dem[:, -4:] = nod
drv = gdal.GetDriverByName("GTiff")
d = drv.Create("run/dem.tif", nx, ny, 1, gdal.GDT_Float32,
               options=["COMPRESS=DEFLATE", "TILED=YES"])
d.SetGeoTransform(gt); d.SetProjection("EPSG:32617")
b = d.GetRasterBand(1); b.SetNoDataValue(nod); b.WriteArray(dem.astype(np.float32))
d.FlushCache(); d = None

# A smooth bias field (amplitude ~1 m), sampled at scattered interior points.
def bias(X, Y):
    u = (X - x0) / (nx * res); v = (y0 - Y) / (ny * res)
    return 0.8 * np.sin(np.pi * u) + 0.5 * v - 0.3
rng = np.random.default_rng(0)
n = 300
px = rng.uniform(x0 + 12*res, x0 + (nx-12)*res, n)
py = rng.uniform(y0 - (ny-12)*res, y0 - 12*res, n)
col = ((px - x0) / res).astype(int); row = ((y0 - py) / res).astype(int)
z = dem[row, col] + bias(px, py) + rng.normal(0, 0.02, n)
with open("run/points.csv", "w") as f:
    f.write("X,Y,Z\n")
    for a, bb, c in zip(px, py, z):
        f.write(f"{a:.3f},{bb:.3f},{c:.4f}\n")
print("generated run/dem.tif and run/points.csv")
PY

# Detrend the DEM against the control points.
$bathy_py $(which dem_detrend)                                   \
    --dem run/dem.tif --csv run/points.csv                       \
    --output-dem run/dem_detrend.tif --output-trend run/trend.tif \
    --seed 0 > run/run-log.txt 2>&1

cat run/run-log.txt
