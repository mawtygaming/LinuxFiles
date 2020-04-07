#!/bin/bash

temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
now=$( date '+%F_%H:%M:%S' )
echo "$now - $temp C"
