#!/bin/sh
#echo -e "\033[31m 红色字 \033[0m"
#echo -e "\033[32m 绿色字 \033[0m" 

## 获取当前目录
CUR_DIR=$(cd `dirname $0`; pwd)
## 创建目录， 强制拷贝文件
mkdir -p /etc/keepalived/scripts
## scripts下文件拷到scripts下
\cp -rf ${HOME_DIR}/scripts/. /etc/keepalived/scripts
\cp -rf ${HOME_DIR}/conf/rsyncd.conf /etc/rsyncd.conf
## 强制覆盖文件夹 将rabbitmq文件夹拷到bin/目录下面，进行覆盖；若bin/rabbitmq下不一致文件不会删除
\cp -rf /opt/test/rabbitmq/_output/rabbitmq  /opt/test/rabbitmq/output/bin

## 获取配置文件nodename名称并过滤由于文件格式引起的换行等符号
node_name=`grep nodename ${HOME_DIR}/conf/config.properties|cut -d'=' -f2 | sed 's/\r//'`

#此处^$1=为了使匹配能够全字匹配
  echo $(awk -v ri="^$1=" -F "^$1=" '$0~ri{print $2}' $2)	

## if and判断 空值判断，如果传入第一个值和第二个值为空则退出
if [[ ! -n "$1" ]] && [[ ! -n "$2" ]];then
	echo ${resultMessage}
    exit
fi

## if 字符串对比 []  [[]] 双括号中无需转义可以直接使用|| &&等
## -ne —比较两个参数是否不相等
## -lt —参数1是否小于参数2
## -le —参数1是否小于等于参数2
## -gt —参数1是否大于参数2
## -ge —参数1是否大于等于参数2
## -f — 检查某文件是否存在（例如，if [ -f "filename" ]）
## -d — 检查目录是否存在
https://www.cnblogs.com/jjzd/p/6397495.html


if [[  ${rsync_version}x == 'rsync-3.1.1-1.el7.rfx.x86_64'x ]];
then
    echo "rsync has installed!"
else
	echo ""
fi

## 判断文件是否为空
## 若环境上存在erlang则为cookie赋600权限，防止服务启动失败
file="/root/.erlang.cookie"
if [[ -f ${file} ]];then
    chmod 600 ${file}
    echo "set erlang 600!"
fi

## 判断文件夹是否为空
path="/home"
#if [ ! -d ${path} ];then
if [ -d ${path} ];then
    echo dir ${path} exist!
else
    echo dir ${path} not exist!
fi

## sed 占位符替换 $1 为传入参数
sed -i "s/virtualIp/$1/g" $CUR_DIR/hello.conf
## -i 表示 inplace edit,就地修改文件    /g所有匹配的
sed -i "s/virtualIp/$1/g" $HOME_DIR/keepalived.conf
### 第二行替换 并自动备份
sed -i.bak "2c NODE_PORT=$amqpPort" $PKG_PATH/hello.conf
## 文件追加 第二个从第二行开始追加
sed -i '$a\我来自火星。' first.txt
sed -i '$2\我来自火星。' first.txt

#从指定配置文件中获取xxx=aa的值
#使用方法  getVarFormProperties key filepath
#示例：
# echo $(getVarFormProperties "rabbitmq.1.webPort" "/opt/web/components/rabbitmq.1/conf/config.properties" )
function getVarFormProperties(){
 # echo awk -v ri="/^$1=/" -F "=" '$0~ri{print $2}' $2
 #此处^$1=为了使匹配能够全字匹配
  echo $(awk -v ri="^$1=" -F "^$1=" '$0~ri{print $2}' $2)
}

# 给指定配置项写入值
# 示例：changeVar key value path
function changeVar(){
  #防止特殊字符对替换的干扰
  tempname=$(echo $2 | sed 's#\/#\\\/#g')
  sed -i.rmqbak "s/^\($1=\).*/\1$tempname/" $3
}
### 网卡获取
network="eth0"
function ips(){
	local nics=$(route -n | grep ^0.0.0.0 | awk '{print $8}') 
	for nic in $nics
	do
	    local ip=$(ifconfig $nic | grep -E 'inet\s+' | awk '{print $2}')
		if [ $ip = "$2" ]; then 
			network=$nic
		fi
	done
}

## 放开浮动ip的224.0.0.18的访问
firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 0 --in-interface $network --destination 224.0.0.18 --protocol vrrp -j ACCEPT

## 服务开机自启动
systemctl enable keepalived

## 判断服务状态是否是running状态
inotify_status=`systemctl status rsync-inotify.service | grep "running"`

## 判断873端口所占端口的进程
pid=$(lsof -n -i4TCP:"873" | grep LISTEN | grep -v grep | awk '{print $2}')

## 文件夹权限赋值
chmod 777 -R /etc/keepalived/scripts

## shell脚本调试
sh -ux hello.sh

## 函数调用 参数传入
check_service_status(){
    node_status=$1
    service_name=$2
}
check_service_status master "1.service"

## sh 脚本引入
source $PKG_PATH/script/mq/common.sh

#防止特殊字符对替换的干扰
tempname=$(echo $2 | sed 's#\/#\\\/#g')

## 防火墙操作
sudo iptables -A OUTPUT -p tcp --dport 7018 -j DROP

## yum 指令
yum repolist
yum clean all
yum makecache
yum install net-snmp 

## 远程ssh无法连接	
vim /etc/ssh/sshd_config
PermitRootLogin yes

## 查看tcmalloc 是否被使用：	
cat /proc/10468/maps | awk '{print $6}' | grep '\.so' | sort | uniq

#create group if not exists
egrep "^$group" /etc/group >& /dev/null
if [[ $? -ne 0 ]]
then
    groupadd $group
fi

## nohup和&的区别
# &:指在后台运行
# nohup :不挂断的运行，注意并没有后台运行的功能。
# 就是指，用nohup运行命令可以使命令永久的执行下去，和用户终端没有关系，例如我们断开SSH连接都不会影响他的运行，注意了nohup没有后台运行的意思；&才是后台运行
## 服务开机自启动
systemctl enable service1.service
## 服务重新加载
systemctl daemon-reload
## jvm 调优参数
JAVA_OPTS="-Xms512m -Xmx1024m -Xss256k -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=384m -XX:NewSize=1536m -XX:MaxNewSize=1536m -XX:SurvivorRatio=8"
JAVA_OPTS="$JAVA_OPTS -XX:ParallelGCThreads=4 -XX:MaxTenuringThreshold=9 -XX:+DisableExplicitGC -XX:+ScavengeBeforeFullGC -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+ExplicitGCInvokesConcurrent -XX:+HeapDumpOnOutOfMemoryError -XX:-OmitStackTraceInFastThrow -Duser.timezone=Asia/Shanghai -Dclient.encoding.override=UTF-8 -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/./urandom"
## java -jar 执行，并输出到对应日志中
# 2>&1 ：标准输出
# &:指在后台运行
# nohup :不挂断的运行，注意并没有后台运行的功能。
nohup $JDK_PATH $JAVA_OPTS -jar adminservice.jar >> $BASE_DIR/adminservice/adminservice.log 2>&1 &

## 获取服务状态
FIRE=`systemctl status firewalld | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1`
if [[ "$FIRE" == "running" ]]
     then
        firewall-cmd --add-port=${config_port}/tcp --permanent
		firewall-cmd --add-port=${admin_port}/tcp --permanent
        firewall-cmd --add-port=${portal_port}/tcp --permanent
		firewall-cmd --add-port=3306/tcp --permanent
		firewall-cmd --reload
else
		firewall-offline-cmd --add-port=${config_port}/tcp
		firewall-offline-cmd --add-port=${admin_port}/tcp
		firewall-offline-cmd --add-port=${portal_port}/tcp
        firewall-offline-cmd --add-port=3306/tcp
fi

## 循环
### 进程等待时间为1分钟，若主进程都没有，说明无法启动
while [[ x"${rabbitmq_pid}" = x ]];do
  if [[ ${try_count} -ge 4 ]];then
    echo "wait main process finished">> ${RABBIT_HOME}/check.logs 2>&1
    break
  fi
  echo "rabbitmq is not running, so restart , count is:"${try_count}
  sleep 15
  try_count=$(($try_count+1))
  rabbitmq_pid=$(get_pid)
done
