#!/bin/bash
## java 路径为环境变量方式传入
JAVA=${JDK_PATH}/bin/java
echo "$JAVA">jre.txt
DIR="$( cd "$( dirname "$0" )" && pwd )"
## 组件目录
COM_DIR=${DIR}/../..
echo ${COM_DIR}
service_name=$1
chmod 777 -R ${COM_DIR}/script/

## 1. 服务注册
sed -i "2c Description=$1 start" template.service
sed -i "11c ExecStart=${COM_DIR}/script/rabbitmq-auth/start.sh" ${COM_DIR}/script/rabbitmq-auth/template.service
\cp -f ${COM_DIR}/script/rabbitmq-auth/template.service  /usr/lib/systemd/system/${service_name}.service
systemctl daemon-reload
systemctl enable ${service_name}.service
echo "register rabbitmq-auth successfully...."
## 2.启动服务
systemctl start ${service_name}.service
echo "start rabbitmq-auth...."
exit 0
