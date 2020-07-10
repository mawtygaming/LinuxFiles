#!/bin/bash
export DISPLAY=:0

xset s off
xset s noblank
xset -dpms

xdotool search --sync --onlyvisible --class "firefox" windowactivate key F5
sleep 1s
/home/vpms-rufino/refresher2.sh
