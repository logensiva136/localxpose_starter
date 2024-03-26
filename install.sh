#!/usr/bin/env bash

if [ ! $(which wget) ]; then
    echo 'Please install wget package'
    exit 1
fi

if [ ! $(which unzip) ]; then
    echo 'Please install wget package'
    exit 1
fi

if (( $EUID != 0 )); then
    echo "Please run as root"
    exit 1
fi

cp lxp.service /lib/systemd/system/
mkdir -p /opt/lxp
cp config.yml /opt/lxp
cp lxp.sh /opt/lxp

systemctl enable lxp.service
systemctl start lxp.service

echo "Done installing Local Xpose"
exit 0