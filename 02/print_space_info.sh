#!/bin/bash

DF_INFO=$(df --block-size=1 / | grep /)

SPACE_ROOT_B=$(echo $DF_INFO | awk '//{print$2}')
SPACE_ROOT_USED_B=$(echo $DF_INFO | awk '//{print$3}')
SPACE_ROOT_FREE_B=$(echo $DF_INFO | awk '//{print$4}')

SPACE_ROOT=$(echo "scale = 2; $SPACE_ROOT_B / 1000.0 / 1000.0" | \
             bc | awk '{printf "%.2f", $0}')
SPACE_ROOT_USED=$(echo "scale = 2; $SPACE_ROOT_USED_B / 1000.0 / 1000.0" | \
                  bc | awk '{printf "%.2f", $0}')
SPACE_ROOT_FREE=$(echo "scale = 2; $SPACE_ROOT_FREE_B / 1000.0 / 1000.0" | \
                  bc | awk '{printf "%.2f", $0}')


echo "SPACE_ROOT = $SPACE_ROOT MB"
echo "SPACE_ROOT_USED = $SPACE_ROOT_USED MB"
echo "SPACE_ROOT_FREE = $SPACE_ROOT_FREE MB"

