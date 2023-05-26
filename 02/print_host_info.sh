#!/bin/bash

HOSTNAME=$(cat /etc/hostname)
TIMEZONE=$(cat /etc/timezone)
UTC_OFFSET=$(date +%:::z)
OS=$(uname -o)
OS_NAME=$(cat /etc/os-release | grep ^NAME= | cut -c 6- | tr -d \")
OS_VERSION=$(cat /etc/os-release | grep ^VERSION= | cut -c 9- | tr -d \")

echo "HOSTNAME = $HOSTNAME"
echo "TIMEZONE = $TIMEZONE UTC $UTC_OFFSET"
echo "USER = $USER"
echo "OS = $OS $OS_NAME $OS_VERSION"

