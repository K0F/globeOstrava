#!/bin/bash
startx &
sleep 1
export DISPLAY=:0.0
xset -dpms
xset s off
xset b off
xdotool mousemove 1024 768
cd ~/globeOstrava
git commit -am "`date`"
git pull
cd geom
pp
