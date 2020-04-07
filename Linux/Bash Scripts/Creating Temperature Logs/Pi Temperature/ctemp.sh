# /bin/bash

DATETO=$(date +"%m-%d-%Y")
TEMPLOGS1=/home/pi/Scripts/temp.sh
LOGPATH=/home/pi/Templogs/templogs_$DATETO
TIME=$(date +"%A  %B-%d-%Y %r")
TODAY=$(date +"%B-%d-%Y")
LOGDIR=/home/pi/Templogs
BACKUP=60

cpuTemp0=$(cat /sys/class/thermal/thermal_zone0/temp)
cpuTemp1=$(($cpuTemp0/1000))
cpuTemp2=$(($cpuTemp0/100))
cpuTempM=$(($cpuTemp2 % $cpuTemp1))

gpuTemp0=$(/opt/vc/bin/vcgencmd measure_temp)
gpuTemp0=${gpuTemp0//\'/º}
gpuTemp0=${gpuTemp0//temp=/}

if [[ -f "$LOGPATH" ]]; then
	echo "[$TIME] The VPMS-Core was restarted." >> $LOGPATH 
	$TEMPLOGS1
    echo "Boss may file ho." 
	
else
	echo "[$TIME] Creating the log file for $TODAY" > $LOGPATH
	echo "[$TIME] Collecting Temperature...">> $LOGPATH
	echo "[$TIME] CPU Temp: $cpuTemp1.$cpuTempMºC" >> $LOGPATH 
	echo "[$TIME] GPU Temp: $gpuTemp0" >> $LOGPATH 
	echo "[$TIME] Collecting Temperature Completed." >> $LOGPATH
	echo "Boss nakagawa na bago para ngayon $DATETO"
fi

find $LOGDIR -mtime $BACKUP -exec rm -R {} \;

# On 12:01 AM and reboot


