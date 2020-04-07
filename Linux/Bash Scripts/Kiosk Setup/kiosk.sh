#!/bin/bash
 
# Where to display
export DISPLAY=:0
 
# Hide the mouse cursor
unclutter &
# Disable any form of screen saver / screen blanking / power management
xset s off xset s noblank xset -dpms
# Allow quitting the X server with CTRL-ATL-Backspacea
setxkbmap -option terminate:ctrl_alt_bksp &
 
/usr/bin/firefox --window-size=1920,1080 --window-position=0,0 https://yahoo.com &
sleep 10s &
/home/vpms-rufino/opera.sh
