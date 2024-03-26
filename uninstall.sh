#!/usr/bin/env bash

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

systemctl stop lxp.service
systemctl disable lxp.service
rm /lib/systemd/system/lxp.service
rm -rf /opt/lxp