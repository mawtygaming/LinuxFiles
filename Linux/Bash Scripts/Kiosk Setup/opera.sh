#!/bin/sh
export DISPLAY=:0 
export XAUTHORITY=/home/username/.Xauthority 

xset s off 
xset s noblank 
xset -dpms 

opera --window-size=1920,1080 --window-position=1920,0 --noerrors --disable-infobars --noerrdialogs https://google.com &
# sleep 10s;
# xdotool key F11
xdotool search --sync --onlyvisible --class "opera" windowactivate key F11
