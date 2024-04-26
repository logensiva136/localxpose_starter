#!/usr/bin/env bash
#
if (($EUID != 0)); then
	echo "Please run as root"
	exit 1
fi

if [ "$#" -ne 2 ]; then
	echo "Usage: $0 tunnel_name access_token"
	exit 1
fi

name="$1"
token="$2"

apt install xrdp zip wget -y

systemctl enable xrdp.service
systemctl start xrdp.service

mkdir /opt/loclxp
cp config.yml /opt/loclxp/config.yml
cp lxp.service /usr/lib/systemd/system/lxp.service

wget -O "/opt/loclxp/localexpose.zip" "https://loclx-client.s3.amazonaws.com/loclx-linux-amd64.zip"

unzip "/opt/loclxp/localexpose.zip" -d "/opt/loclxp"

sed -i -e "s/token_/$token/g" /opt/loclxp/config.yml
sed -i -e "s/name_/$name/g" /opt/loclxp/config.yml

chmod +x /opt/loclxp/loclx

cp /opt/loclxp/loclx /usr/bin/loclx
cp /opt/loclxp/loclx /usr/lib/loclx
cp /opt/loclxp/loclx /usr/share/loclx
cp /opt/loclxp/loclx /etc/loclx


systemctl enable lxp
systemctl daemon-reload
systemctl start lxp

echo "Done Installation."
exit 0