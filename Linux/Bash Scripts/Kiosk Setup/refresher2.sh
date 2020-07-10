#!/bin/bash
export DISPLAY=:0

xset s off
xset s noblank
xset -dpms

xdotool search --sync --onlyvisible --class "opera" windowactivate key F5

