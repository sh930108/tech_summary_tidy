#!/bin/sh
killall rsync &> /dev/null

systemctl stop keepalived
systemctl stop rsync-inotify.service

## keepalived rpm 卸载
keep_rpm_name=`rpm -qa keepalived`
if [ -n ${keep_rpm_name} ];then
	rpm -e ${keep_rpm_name}
fi

## rsync rpm 卸载
rsync_rpm_name=`rpm -qa rsync`
if [ -n ${rsync_rpm_name} ];then
	rpm -e ${rsync_rpm_name}
fi

## inotify rpm 卸载
inotify_rpm_name=`rpm -qa inotify-tools`
if [ -n ${inotify_rpm_name} ];then
	rpm -e ${inotify_rpm_name}
fi

rm -rf  /usr/lib/systemd/system/keepalived.service
rm -rf  /usr/lib/systemd/system/rsync-inotify.service.service
systemctl daemon-reload

##删除keepalived相关文件
rm -f /usr/local/sbin/keepalived
rm -f /usr/local/etc/rc.d/init.d/keepalived
rm -f /usr/local/etc/sysconfig/keepalived
rm -rf /usr/local/etc/keepalived
rm -f /usr/local/bin/genhash
rm -rf /usr/local/keepalived
rm -rf /etc/keepalived
rm -f /etc/rc.d/init.d/keepalived
rm -f /usr/sbin/keepalived
rm -f /etc/sysconfig/keepalived
rm -f /etc/systemd/system/multi-user.target.wants/keepalived.service

##删除rsync相关文件
rm -rf /etc/rsync
rm -f /var/log/rsyncd.log