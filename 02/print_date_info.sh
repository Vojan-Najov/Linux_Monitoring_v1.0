#!/bin/bash

DATE_FORMAT="%d %b %Y %l:%M:%S"
DATE=$(date +"$DATE_FORMAT")

UPTIME=$(uptime -p | cut -c 4-)
UPTIME_SINCE=$(uptime -s)
UPTIME_SEC_START=$(date --date="$UPTIME_SINCE" +"%s")
UPTIME_SEC_NOW=$(date --date="now" +"%s")

UPTIME_SEC=0
let "UPTIME_SEC = $UPTIME_SEC_NOW - $UPTIME_SEC_START"

echo "DATE = $DATE"
echo "UPTINE = $UPTIME"
echo "UPTIME_SEC = $UPTIME_SEC"

