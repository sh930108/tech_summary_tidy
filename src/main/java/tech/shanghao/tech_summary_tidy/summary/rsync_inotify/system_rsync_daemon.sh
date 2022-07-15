#!/bin/sh
param=$1
if [ ! -n "$param" ];then
	param="start"
fi
case "$param" in
  start )
	## 从服务器启动 rsync --daemon;用于主服务器文件同步
	pid=$(lsof -n -i4TCP:"873" | grep LISTEN | grep -v grep | awk '{print $2}')
	if [  -n  "$pid" ];
	then
		## 已经启动，杀掉进程重启rsync
		echo "rsync-daemon is running"
		kill -9 $pid
		echo "rsync-daemon is restart"
		rsync --daemon
	else
		## 未启动启动
		rsync --daemon
		echo "rsync-daemon start successed!"
	fi
  ;;
  stop )
	pid=$(lsof -n -i4TCP:"873" | grep LISTEN | grep -v grep | awk '{print $2}')
	if [  -n  "$pid" ];
	then
		kill -9 $pid
		echo "rsync-daemon stopped successed!"
	fi
  ;;
  * )
    echo "Usage:$0 start|stop"
  ;;
esac