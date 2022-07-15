#!/bin/sh
DIR="$( cd "$( dirname "$0" )" && pwd )"
COM_DIR=${DIR}/../..
echo ${COM_DIR}
systemctl stop $1.service
rm -rf /usr/lib/systemd/system/$1.service
systemctl daemon-reload
exit 0
