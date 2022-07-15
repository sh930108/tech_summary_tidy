
#### 安装启动
1. 下载二进制包 <br/>
    http://mirrors.sohu.com/mysql/MySQL-5.7/<br/>
    http://ftp.ntu.edu.tw/MySQL/Downloads/MySQL-5.7/<br/>
    本例使用mysql-5.7.23-el7-x86_64.tar.gz

2. 安装
```
## 解压 安装路径/opt
tar -xzvf mysql-5.7.23-el7-x86_64.tar.gz

## 重命名
mv mysql-5.7.23-el7-x86_64 mysql57

## 准备工作

## 判断用户是否存在
egrep "mysql" /etc/group >& /dev/null
egrep "mysql" /etc/passwd >& /dev/null

## 1. 添加用户 －M不要自动建立用户的登入目录 －s：指定用户登入后所使用的shell
groupadd mysql
useradd -g mysql mysql -M -s /sbin/nologin

## 初始化数据库 
cd /opt/mysql57/bin
./mysqld --initialize --user=mysql --basedir=/opt/mysql57/ --datadir=/opt/mysql57/data

## 服务注册，移动配置文件；修改初始配置 my.cnf mysql.server
cd /opt/mysql57/support-files
## 配置conf basedir datadir三个参数
cp mysql.server /etc/init.d/mysqld
## 配置my.cnf相关参数

## 启动MySQL
/etc/init.d/mysqld start

```

3. root用户远程连接
```
## 连接数据库 注意关闭防火墙
./mysql -u root -p -h ip地址
> grant all privileges on *.* to 'root'@'%' identified by '1234' with grant option;
> flush privileges;
```

#### 数据库操作

```
## 添加用户  bin/ 目录 第一次登陆需要输入数据库生成的临时密码并改密码
## 如果root已经设置过密码，采用如下方法
./mysql -uroot -p
> alter user root@localhost identified by '1234'; 
> flush privileges;
./mysqladmin -u root -p 'oldpassword' password 'newpassword'

## 客户端连接 输入密码
./mysql -u root -p -h ip地址

## 显示所有数据库
>show databases;

## 查看用户和访问的host
>select user,host from mysql.user;

## 退出
>exit

## 数据库操作
# 使用数据库
use 数据库;
# 创建数据库
create database if not exists apollodb;
./mysqladmin -u user -p create test

##创建用户　　
insert into mysql.user (user,host,password) values ('mysql','%',password('密码'));
##修改密码　　
update mysql.user set password=password('新密码') where user='用户名';
##授权　　　　
grant insert,update,select,delete on 数据库.* to 用户@'%';
grant all privileges on *.* to root@localhost identified by '123456';
grant all privileges on *.* to 'root'@'localhost' identified by '123456' with grant option; 
##撤销权限　　
revoke delete on 数据库.*  from 用户;
##更新权限　　
flush privileges;
# 显示所有数据库表，查看表所有列
show tables;
show full columns from 表名;
## 查看引擎
show variables like '%storage_engine%':

## 无法访问'root'@'localhost'
配置文件中skip-grant-tables  跳过表的权限验证，用户可以执行增删改查<br/>
insert into mysql.user(user,host,password) values('root','localhost',password('123456'));<br/>
update mysql.user set select_priv='Y' where user='root';<br/>
flush privileges;  <br/>
```


















