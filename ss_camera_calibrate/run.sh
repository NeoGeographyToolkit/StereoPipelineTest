#!/bin/bash

set -x verbose
rm -rfv run

camera_calibrate run 6 9 "../data/chessboard_pics/*.jpg" --overwrite

