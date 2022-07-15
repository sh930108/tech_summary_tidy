#!/bin/bash

CUR_DIR=$(
  cd $(dirname $0)
  pwd
)
PKG_DIR="${CUR_DIR}/../../"

# 获取组件index号
rmqindex=$(awk -F "=" '/^rabbitmq.@index=/ {print $2}' ${PKG_DIR}/conf/installation.properties)
echo ${rmqindex}

#加载读取配置的函数
source ${PKG_DIR}/script/mq/common.sh
amqpPort=$(getVarFormProperties "rabbitmq.$rmqindex.amqpPort" "$PKG_DIR/conf/config.properties")
echo amqpPort:${amqpPort}

## 确保rmq启动后,再执行此脚本
port_listen=$(get_rmq_manager_port)
try_count=0
while [[ ${port_listen} < 1  ]];do
  echo "rmq manager port don't listen, sleep 15s"
  sleep 15
  port_listen=$(get_rmq_manager_port)
  if [[ ${try_count} -ge 20 ]];then
    echo "rabbitmq start failed">> ${RABBIT_HOME}/check.logs 2>&1
    exit 1
  fi
  try_count=$(($try_count+1))
done

cd ${PKG_DIR}/bin/rabbitmq/sbin
echo "cd ${PKG_DIR}/bin/rabbitmq/sbin to config the rabbitmq"

## 添加用户
echo "start to config the user"
ROOT_USER_EXIST="$(HOME=/root ./rabbitmqctl list_users | grep root)"
ROOT_USER_HAVE_PERMISSIONS="$(HOME=/root ./rabbitmqctl list_user_permissions root | grep \*)"
if [[ -z "$ROOT_USER_EXIST" ||  -z "$ROOT_USER_HAVE_PERMISSIONS" ]];then
	# get the dynamic encrypt password config
	CIPHER_RABBITMQ_PASSWORD=$(getVarFormProperties "rabbitmq.$rmqindex.password" "$PKG_DIR/conf/config.properties")
	cd ${CUR_DIR}
	# decrypt the password
	RABBITMQ_PASSWORD=$(python ${CUR_DIR}/bicIdentify.py -d ${CIPHER_RABBITMQ_PASSWORD})
	cd ${PKG_DIR}/bin/rabbitmq/sbin
	HOME=/root ./rabbitmqctl delete_user root
	HOME=/root ./rabbitmqctl add_user root ${RABBITMQ_PASSWORD}
	#set the user tags
	HOME=/root ./rabbitmqctl set_user_tags root administrator
	#set the user permissions
	HOME=/root ./rabbitmqctl set_permissions -p / root ".*" ".*" ".*"
fi
echo "end to config the user"

## 1. 对所有队列消息进行过期时间设置 3d =3 * 24 * 60 * 60 * 1000
## 2. 对所有对应设置策略最大10G 或者50w消息堆积
HOME=/root ./rabbitmqctl set_policy Main-policy ".*" '{"max-length-bytes":10485760000,"max-length":500000,"message-ttl":259200000}' --apply-to queues

echo "after rabbitmq configure,to restart the rabbitmq app"
HOME=/root ./rabbitmqctl stop_app
HOME=/root ./rabbitmqctl start_app