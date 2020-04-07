#!/bin/bash
 
export DISPLAY=:0
 
unclutter &
 
#sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/kiosk/.config/chromium/Default/Preferences
#sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/kiosk/.config/chromium/Default/Preferences
 
/usr/bin/chromium-browser --window-size=1024,768 --kiosk --window-position=0,0 http://cashier.vpms.com:3001


#remove mouse hover
while (true)
  do
    xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab;
    sleep 15
done
