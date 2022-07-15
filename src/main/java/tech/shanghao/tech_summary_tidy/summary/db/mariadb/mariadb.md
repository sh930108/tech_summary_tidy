
#### 安装启动
1. 下载二进制包 <br/>
    https://downloads.mariadb.org/<br/>
    本例使用mariadb-10.1.43-linux-x86_64.tar.gz

2. 安装
```
## 解压 安装路径/opt
tar -xzvf mariadb-10.1.43-linux-x86_64.tar.gz

## 重命名
mv mariadb-10.1.43-linux-x86_64 mariadb

## 准备工作
## 1. 添加用户 －M不要自动建立用户的登入目录 －s：指定用户登入后所使用的shell
groupadd mysql
useradd -g mysql mariadb -M -s /sbin/nologin

## 初始化数据库 
cd /opt/mariadb/scripts
./mysql_install_db --user=mariadb --basedir=/opt/mariadb/ --datadir=/opt/mariadb/data

## 服务注册，移动配置文件；修改初始配置 my-small.cnf mysql.server
cd /opt/mariadb/support-files
## 复制配置文件
cp my-small.cnf /opt/mariadb/my.cnf
cp mysql.server /etc/init.d/mariadb

## 开机自启动
chkconfig mariadb on
```

3. root用户远程连接
```
## 连接数据库
./mysql -u root -p -h ip地址
## 进入mysql database
>use mysql;
## 更新host
>update user set host='%' where user = 'root';

## 权限设置
./mysql_secure_installation

```

#### 数据库操作

```
## 添加用户  bin/ 目录
## 未设置过root用户密码 
./mysqladmin -u root password 'root'
## 如果root已经设置过密码，采用如下方法
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
show full columns from 表名；
## 查看引擎
show variables like '%storage_engine%':

## 无法访问'root'@'localhost'
配置文件中skip-grant-tables  跳过表的权限验证，用户可以执行增删改查<br/>
insert into mysql.user(user,host,password) values('root','localhost',password('123456'));<br/>
update mysql.user set select_priv='Y' where user='root';<br/>
flush privileges;  <br/>
```


















