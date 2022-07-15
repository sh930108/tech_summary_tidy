#!/bin/bash


#从指定配置文件中获取xxx=aa的值
#使用方法  getVarFormProperties key filepath
#示例：
# echo $(getVarFormProperties "rabbitmq.webPort" "/opt/config.properties" )
function getVarFormProperties(){
 # echo awk -v ri="/^$1=/" -F "=" '$0~ri{print $2}' $2
 #此处^$1=为了使匹配能够全字匹配
  echo $(awk -v ri="^$1=" -F "^$1=" '$0~ri{print $2}' $2)	
}

# 给指定配置项写入值
# changeVar key  value path
function changeVar(){
  #防止特殊字符对替换的干扰
  tempname=$(echo $2 | sed 's#\/#\\\/#g')
  sed -i.rmqbak "s/^\($1=\).*/\1$tempname/" $3
}


function get_rmq_manager_port(){
  port=$(netstat -anp | grep beam |grep $amqpPort | wc -l)
  echo ${port}
}