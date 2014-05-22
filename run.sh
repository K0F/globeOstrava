#!/bin/bash
startx &
sleep 5
export DISPLAY=:0.0
cd ~/globeOstrava
git pull
cd geom
/home/kof/tmp/processing-2.2.1/processing-java --run --sketch=`pwd` --output="/tmp/trash" --force
