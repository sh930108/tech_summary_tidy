#!/bin/bash

#获取当前路径
CUR_DIR=$(cd `dirname $0`; pwd)
COM_DIR=${CUR_DIR}/../..
jre=$(cat `dirname $0`/jre.txt)
JAVA="${jre}"

#加载读取配置的函数
source ${CUR_DIR}/common.sh

## 0. 服务启动参数,部分参数从配置文件中获取
# 获取组件index号
rmqindex=$(awk -F "=" '/^rabbitmq.@index=/ {print $2}' ${COM_DIR}/conf/installation.properties)
echo ${rmqindex}
## 获取启动端口 rabbitmq-auth.1.webPort
webPort=$(getVarFormProperties "rabbitmq-auth.$rmqindex.webPort" "$COM_DIR/conf/config.properties")
## 动态获取auth段启动端口，并用运管分配的端口启动 
sed -i "5c server.port=$webPort" ${COM_DIR}/bin/rabbitmq-auth/config/application.properties

### 1. 启动java进程
JAVA_OPTS="-Xms128m -Xmx400m -Xss512k -XX:MetaspaceSize=100m -XX:MaxMetaspaceSize=256m -XX:NewSize=100m -XX:MaxNewSize=400m -XX:SurvivorRatio=8"
JAVA_OPTS="$JAVA_OPTS -XX:ParallelGCThreads=4 -XX:MaxTenuringThreshold=9 -XX:+DisableExplicitGC -XX:+ScavengeBeforeFullGC -XX:SoftRefLRUPolicyMSPerMB=0 -XX:+ExplicitGCInvokesConcurrent -XX:+HeapDumpOnOutOfMemoryError -XX:-OmitStackTraceInFastThrow -Duser.timezone=Asia/Shanghai -Dclient.encoding.override=UTF-8 -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/./urandom"
## 将conf/添加classpath,jar中会扫描classpath获取config.properties,comPath 用于日志打印
JAVA_OPTS="$JAVA_OPTS -Xbootclasspath/a:${COM_DIR}/conf/ -Dcom.dir=${COM_DIR}"
cd ${COM_DIR}/bin/rabbitmq-auth/
nohup ${JAVA} ${JAVA_OPTS} -jar rabbitmq-auth-2.0.1.RELEASE.jar >> ${COM_DIR}/logs/rabbitmq-auth/rabbitmq-auth-start.log 2>&1 &
cd ${CUR_DIR}
exit 0