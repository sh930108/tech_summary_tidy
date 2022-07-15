
> 前言：virtual box 使用

#### 安装启动
1. 下载路径
https://www.virtualbox.org/wiki/Downloads


#### 配置
```
## 1. 添加镜像，分配资源进行安装 
Linux
Red HAT（64-bit）

## 2. 网络配置
管理--- 全局设定 ---- 网络 ----  “+”加上 NatNetwork

## 3. 设置  
网卡1 --- NAT网络   网卡2 ---- 仅主机（Host-Only）网络，混杂模式：全部允许 接入网线

## 4. 系统命令补全
yum install -y bash-completion
```


#### 异常报错

```
## 错误信息1
概要： 报Job for network.service failed because the control process exited with error code. See “systemctl status network.service” and “journalctl -xe” for details. 的错误

## 解决
NetworkManager网络管理工具 
1. 重启网络管理工具
systemctl stop NetworkManager
systemctl disable NetworkManager

2. 然后重新启动服务
service network restart

## 错误信息2
概要：输入ifconfig 提示不存在

## 解决
1. yum install ifconfig
2. 提示没有ifconfig安装包。我们再使用yum search ifconfig来搜索下ifconfig的相关
3. 查看ifconfig匹配的是net-tools.x86_64包，安装net-tools.x86_64包                      
yum install net-tools.x86_64 -y
4. 输入ifconfig 查看效果

## 错误信息3 
概要：无法访问ssh

## 解决
管理--- 全局设定 ---- 网络 ---- NatNetwork 右键编辑，---端口转发，配置映射端口

ps：ssh服务需要正常运行
vi /etc/ssh/sshd_config 调整PermitRootLogin参数值为yes
/etc/init.d/ssh restart
systemctl status sshd


```

### 配置文件 
1. 路径
/etc/sysconfig/network-scripts/ifcfg-enp0s3

2. 配置
```
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp0s3
UUID=efc39d7c-4e3b-4463-981d-be49df650bc7
DEVICE=enp0s3
ONBOOT=yes
```
主要是修改 ONBOOT=yes



















