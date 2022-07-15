#!/bin/bash
# 当前路径
_CURRENT_HOME="$(cd "$(dirname "$0")" && pwd)"
# 组件壳路径
_PKG_HOME=$(
    cd $(dirname $0)
    cd ../../../
    pwd
)
source $_PKG_HOME/script/mq/common.sh

# 获取组件index号
rmqindex=$(awk -F "=" '/^rabbitmq.@index=/ {print $2}' $_PKG_HOME/conf/installation.properties)

CIPHER_RABBITMQ_PASSWORD=$(getVarFormProperties "rabbitmq.$rmqindex.password" "$_PKG_HOME/conf/config.properties")
echo "密文：["${CIPHER_RABBITMQ_PASSWORD}"]" > cipher.log
# 解密
RABBITMQ_PASSWORD=$(python ${_CURRENT_HOME}/bicIdentify.py -d ${CIPHER_RABBITMQ_PASSWORD})
# 不能有别的输出了，不然获取密码的脚本提取密码时会有问题
echo ${RABBITMQ_PASSWORD}
