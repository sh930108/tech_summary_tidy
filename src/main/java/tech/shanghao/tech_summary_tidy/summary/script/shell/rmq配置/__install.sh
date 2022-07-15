#!/bin/bash

function install(){
    
    basepath=$(cd `dirname $0`; pwd)
	BIN_DIR=$(dirname "$basepath")
	PKG_DIR=$(dirname "$BIN_DIR")
    echo ${basepath}
	## 适配国产化环境
	ARCH=$(uname -p)

	if [[ "$ARCH" == "x86_64" ]]; then
        ## erlang 环境准备 环境中erlang不存在则拷贝erlang
        if [[ ! -d "/usr/local/rabbitmq" || ! -f "/usr/local/rabbitmq/erlang/bin/erl" ]];then
            mkdir -p /usr/local/rabbitmq
            unzip -o -d /usr/local/rabbitmq/ ${basepath}/erlang/centos/erlang.zip
            chmod -R 777 /usr/local/rabbitmq/erlang
        fi
	elif [[ "$ARCH" == "aarch64" ]]; then
	    ## arm环境中erlang环境准备 环境中erlang不存在则拷贝erlang
        if [[ ! -d "/usr/local/rabbitmq" || ! -f "/usr/local/rabbitmq/erlang/bin/erl" ]];then
            mkdir -p /usr/local/rabbitmq
            unzip -o -d /usr/local/rabbitmq/ ${basepath}/erlang/arrch64/erlang.zip
            chmod -R 777 /usr/local/rabbitmq/erlang
        fi
        ## 更新Python解密库
        rm -rf ${basepath}/libIdentify.so
        \cp -rf ${basepath}/erlang/arrch64/libIdentifyArm.so ${basepath}/libIdentify.so
        ## 更新rabbitmq依赖的crypto库，放到rmq执行目录中，不去获取系统库中ssl，避免系统库缺失
        \cp -rf ${basepath}/erlang/arrch64/libcrypto.so.1.1 ${PKG_DIR}/bin/rabbitmq/sbin/libcrypto.so.1.1
	else
        echo "CPU types not currently supported, [types=${ARCH}]"
    fi
}

install
echo "success"