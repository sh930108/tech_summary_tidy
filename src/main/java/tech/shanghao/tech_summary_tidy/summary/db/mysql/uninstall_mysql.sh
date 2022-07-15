#!/usr/bin/env bash
systemctl stop mysqld

##删除mysql 相关文件
rm -rf /etc/selinux/targeted/active/modules/100/mysql
rm -rf /etc/logrotate.d/mysql
rm -rf /var/lib/mysql
rm -rf /var/lib/mysql-files
rm -rf /var/lib/mysql-keyring
rm -rf /usr/bin/mysql
rm -rf /usr/lib/ocf/resource.d/heartbeat/mysql
rm -rf /usr/lib64/mysql
rm -rf /usr/share/resource-agents/ocft/configs/mysql
rm -rf /etc/my.cnf.d
rm -f /etc/init.d/mysql
rm -f /var/log/mysqld.log
rm -f /usr/lib/systemd/system/mysqld.service
rm -f /usr/lib/systemd/system/mysqld@.service

systemctl daemon-reload