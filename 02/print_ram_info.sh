#!/bin/bash

MEM_INFO=$(free -b | grep Mem)

RAM_TOTAL_B=$(echo $MEM_INFO | awk '/Mem/{print$2}')
RAM_USED_B=$(echo $MEM_INFO | awk '/Mem/{print$3}')
RAM_FREE_B=$(echo $MEM_INFO | awk '/Mem/{print$4}')

RAM_TOTAL=$(echo "scale = 3; $RAM_TOTAL_B / 1000.0 / 1000.0 / 1000.0" | \
            bc | awk '{printf "%.3f", $0}')

RAM_USED=$(echo "scale = 3; $RAM_USED_B / 1000.0 / 1000.0 / 1000.0" | \
            bc | awk '{printf "%.3f", $0}')

RAM_FREE=$(echo "scale = 3; $RAM_FREE_B / 1000.0 / 1000.0 / 1000.0" | \
           bc | awk '{printf "%.3f", $0}')

echo RAM_TOTAL = $RAM_TOTAL GB
echo RAM_USED = $RAM_USED GB
echo RAM_FREE = $RAM_FREE GB

