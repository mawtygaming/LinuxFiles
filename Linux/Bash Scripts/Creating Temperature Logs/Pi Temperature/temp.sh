#!/bin/bash
cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
cpuTemp1=$(($cpuTemp0/1000))
cpuTemp2=$(($cpuTemp0/100))
cpuTempM=$(($cpuTemp2 % $cpuTemp1))

gpuTemp0=$(/opt/vc/bin/vcgencmd measure_temp)
gpuTemp0=${gpuTemp0//\'/º}
gpuTemp0=${gpuTemp0//temp=/}

DATETO=$(date +"%m-%d-%Y")
LOGPATH=/home/pi/Templogs/templogs
TIME=$(date +"%A  %B-%d-%Y %r")
LOGPATH=/home/pi/Templogs/templogs_$DATETO

echo "[$TIME] Collecting Temperature..." >> $LOGPATH
echo "[$TIME] CPU Temp: $cpuTemp1.$cpuTempMºC" >> $LOGPATH
echo "[$TIME] GPU Temp: $gpuTemp0" >> $LOGPATH
echo "[$TIME] Collecting Temperature Completed." >> $LOGPATH

# per hour