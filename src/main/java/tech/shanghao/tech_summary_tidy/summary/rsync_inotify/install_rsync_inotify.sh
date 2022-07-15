#!/bin/sh
#脚本需传参：参数是对方ip，注意非本机ip，高可用的另外一台机器ip；本机是主，则传备ip；本机为备机传主机ip。
resultMessage="必要参数为空，请重新传入参数(1个参数)!!! 参数是对方ip，注意非本机ip，高可用的另外一台机器ip；本机是主，则传备ip；本机为备机传主机ip"
## 参数未传提醒
if [ ! -n "$1" ];then
	echo $resultMessage
    exit
fi

echo "opposite_ip is:"$1

CUR_DIR=$(cd `dirname $0`; pwd)
HOME_DIR=$CUR_DIR/rsync_inotify
echo "home_dir:"$HOME_DIR

rsync_version=`rpm -qa rsync`
## 0. 判断环境上是否安装rsync
if [  ${rsync_version}x == 'rsync-3.1.1-1.el7.rfx.x86_64'x ];
then
    echo "rsync has installed!"
else
	## 0.配置文件 设置对方ip
	sed -i "s/opposite_ip/$1/g" $HOME_DIR/conf/rsync/system_rsync_inotify.sh
	sed -i "s/opposite_ip/$1/g" $HOME_DIR/conf/rsyncd.conf

    echo "rsync start installed"
	## 1. 安装
	rpm -ivh $HOME_DIR/rsync-3.1.1-1.el7.rfx.x86_64.rpm
	## 2. 配置文件拷贝
	\cp -rf $HOME_DIR/conf/rsync/. /etc/rsync
	\cp -rf $HOME_DIR/conf/rsyncd.conf /etc/rsyncd.conf
	## 3. 赋权限
	chmod 600 -R /etc/rsync
	chmod 600 -R /etc/rsyncd.conf
	chmod 777 /etc/rsync/system_rsync_inotify.sh
	chmod 777 /etc/rsync/system_rsync_daemon.sh
fi

## 1. 判断环境上是否安装inotify 监听目录以实时同步
inotify_version=`rpm -qa inotify-tools`
if [  ${inotify_version}x == 'inotify-tools-3.14-9.el7.x86_64'x ];
then
    echo "inotify-tools has installed!"
else
    echo "inotify-tools start installed"
	rpm -ivh $HOME_DIR/inotify-tools-3.14-9.el7.x86_64.rpm
	## 添加参数
	grep -q "fs.inotify.max_user_watches=1048576" /etc/sysctl.conf
	if [ $? -ne 0 ]; then
		echo "fs.inotify.max_queued_events=1048576"  >> /etc/sysctl.conf
		echo "fs.inotify.max_user_instances=1024"  >> /etc/sysctl.conf
		echo "fs.inotify.max_user_watches=1048576"  >> /etc/sysctl.conf
	fi
	/sbin/sysctl -p
fi

## 2. 将监听和同步的脚本做成服务
\cp -rf $HOME_DIR/conf/inotify/rsync-inotify.service  /usr/lib/systemd/system/rsync-inotify.service
systemctl daemon-reload


