#!/bin/bash
PATH=$PATH:/home/kof/bin
startx &
sleep 1
export DISPLAY=:0.0
xset -dpms
xset s off
xset b off
xdotool mousemove 1024 768
cd ~/globeOstrava
git commit -am "change @ production machine `date`"
git pull
git push
cd geom
pp
