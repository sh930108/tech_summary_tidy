
> 前言：首先安装erlang

#### 安装启动
1. 下载二进制包 <br/>
    https://www.rabbitmq.com/install-generic-unix.html<br/>
    本例使用rabbitmq-server-generic-unix-3.8.2.tar.xz
2. 解压即用无需安装
```
## 解压
tar xvf rabbitmq-server-generic-unix-3.8.2.tar.xz

## 进入目录
cd /opt/rabbitMQ/rabbitmq_server-3.8.2/sbin

## 启动服务
## 直接启动
./rabbitmq-server

## 后台启动
./rabbitmq-server -detached

## 停止服务
./rabbitmqctl shutdown

## 插件配置
./rabbitmq-plugins enable rabbitmq_management
./rabbitmq-plugins enable rabbitmq_federation
./rabbitmq-plugins enable rabbitmq_stomp
./rabbitmq-plugins enable rabbitmq_mqtt

```
3. rabbitMQ的配置在etc/rabbit/目录下配置，老版本rabbitmq.config;新版本rabbitmq.conf；模板可以从github上获取rabbitmq.config.example和rabbitmq.conf.example

4. 访问控制台时
报错：HTTP access denied: user 'guest' - User can only log in via localhost <br/>
默认配置只支持guest本机访问，可以将rabbitmq.conf（etc/rabbit/）中配置
放开：loopback_users.guest = false 即可

#### 权限设置

```
## 添加用户  ./rabbitmqctl add_user username password
./rabbitmqctl add_user shanghao 123456
## 授权用户管理员 
./rabbitmqctl set_user_tags shanghao administrator
## 添加虚拟机
./rabbitmqctl add_vhost /test_host
## 授权用户到虚拟机
./rabbitmqctl set_permissions -p /test_host shanghao ".*" ".*" ".*"
## 查看用户
./rabbitmqctl list_users
```

#### 集群安装
- 单一模式：即单机情况不做集群，就单独运行一个rabbitmq而已。
- 普通模式：默认模式，以两个节点（rabbit01、rabbit02）为例来进行说明。对于Queue来说，消息实体只存在于其中一个节点rabbit01（或者rabbit02），rabbit01和rabbit02两个节点仅有相同的元数据，即队列的结构。当消息进入rabbit01节点的Queue后，consumer从rabbit02节点消费时，RabbitMQ会临时在rabbit01、rabbit02间进行消息传输，把A中的消息实体取出并经过B发送给consumer。所以consumer应尽量连接每一个节点，从中取消息。即对于同一个逻辑队列，要在多个节点建立物理Queue。否则无论consumer连rabbit01或rabbit02，出口总在rabbit01，会产生瓶颈。当rabbit01节点故障后，rabbit02节点无法取到rabbit01节点中还未消费的消息实体。如果做了消息持久化，那么得等rabbit01节点恢复，然后才可被消费；如果没有持久化的话，就会产生消息丢失的现象。
- 镜像模式:把需要的队列做成镜像队列，存在与多个节点属于RabbitMQ的HA方案。该模式解决了普通模式中的问题，其实质和普通模式不同之处在于，消息实体会主动在镜像节点间同步，而不是在客户端取数据时临时拉取。该模式带来的副作用也很明显，除了降低系统性能外，如果镜像队列数量过多，加之大量的消息进入，集群内部的网络带宽将会被这种同步通讯大大消耗掉。所以在对可靠性要求较高的场合中适用。

##### 普通集群

```
## 修改hostname
vi /etc/hosts
## 修改如下（本例用的虚拟机，重启了hostname没有立即生效）
# 127.0.0.1 bigbaby localhost localhost.localdomain localhost4 localhost4.localdomain4
# ::1 bigbaby localhost localhost.localdomain localhost6 localhost6.localdomain6
# 192.168.2.225 bigbaby
# 192.168.2.116 littlebaby
## end 

## 修改两台机器的.erlang.cookie 
# 路径在$HOME中或者在/var/lib/rabbitmq中
# var/log/rabbitmq/rabbit@littlebaby.log 可以找到home路径，本机（/root）
# 二进制解压的一般在home下

## 修改文件权限
chmod 600 .erlang.cookie

## 在192.168.2.116 littlebaby上操作
## 停止当前机器中rabbitmq的服务
./rabbitmqctl stop_app

## 把bigbaby中的rabbitmq加入到集群中来
./rabbitmqctl join_cluster --ram rabbit@bigbaby

##开启当前机器的rabbitmq服务
./rabbitmqctl start_app

## 查看集群状态
./rabbitmqctl cluster_status

```

##### 搭建rabbitmq的镜像高可用模式集群

```
## 镜像策略配置
## 设置各个节点的所有状态全部一致
./rabbitmqctl set_policy ha-all "^" '{"ha-mode":"all"}'
## 清除策略
./rabbitmqctl clear_policy  ha-all
## 接单reset （1. 从集群中删除节点 2. 清除节点中的数据）
./rabbitmqctl stop_app
./rabbitmqctl reset
./rabbitmqctl start_app

## 设置节点备份数为2， 策略名称为 ha-two-node
./rabbitmqctl set_policy ha-two-node "^"   '{"ha-mode":"exactly","ha-params":2,"ha-sync-mode":"automatic"}'
```

##### 设置服务器hostname
sudo hostnamectl set-hostname rabbitmqnode1

##### 日志插件
```
## 1.进入sbin目录下
./rabbitmq-plugins enable rabbitmq_tracing

## 2.界面上 admin列会看到trace

添加trace

## 3.默认日志在/var/tmp/rabbitmq-tracing
```

##### rabbitmq策略
```
## 策略配置地址

## 1.给所有队列，配置ttl 默认配置3天
./rabbitmqctl set_policy TTL ".*" '{"message-ttl":259200000}' --apply-to queues

## 2.给队列配置上限 分为俩种：一种为队列上限，一种是消息数上限  \ 用作换行
my-pol:策略名称 "^one-meg$" 正则表达式^ 开头 $ 结尾
./rabbitmqctl set_policy my-pol "^one-meg$" \
  '{"max-length-bytes":1048576}' \
  --apply-to queues
./rabbitmqctl set_policy Max-length-test ".*" '{"max-length-bytes":50}' --apply-to queues
./rabbitmqctl set_policy Max-length ".*" '{"max-length":50,"overflow":"reject-publish"}' --apply-to queues
  
## 队列上限设置不能超过1M  
./rabbitmqctl set_policy Max-length-byte ".*" '{"max-length-bytes":1048576}' --apply-to queues
## 队列上限设置50条消息
./rabbitmqctl set_policy Max-length ".*" '{"max-length":50,"overflow":"reject-publish"}' --apply-to queues


./rabbitmqctl set_policy Main-policy ".*" \
'{"max-length-bytes":1048576,"max-length":50,"overflow":"drop-head","message-ttl":259200000}' --apply-to queues

## 删除对应策略
./rabbitmqctl clear_policy  Max-length
```

```
https://www.rabbitmq.com/queues.html 队列相关介绍
https://www.rabbitmq.com/ttl.html ttl策略
## 队列限制策略
#### 官网链接 https://www.rabbitmq.com/maxlength.html
1. 配置项
x-max-length: 限制队列中消息数量（非0）
x-max-length-bytes: 限制队列中消息大小（非0）1048576 ==> 1M 

x-overflow: 配合使用（reject-publish/drop-head）
    reject-publish: 最新发的消息将会丢弃
    drop-head（默认）: 最老的消息将会被丢弃

2. 俩个配置同时设置的情况下，策略都会生效；以最先达到的阀值为准

注： 只针对 ready消息，unack的消息不在内

同一个队列只有一个policy生效 10G或者50w条消息
HOME=/root ./rabbitmqctl set_policy Main-policy ".*" '{"max-length-bytes":10485760000,"max-length":500000,"message-ttl":259200000}' --apply-to queues

```

```
https://www.rabbitmq.com/queues.html 队列相关介绍
https://www.rabbitmq.com/quorum-queues.html 仲裁队列
queue在rmq中是用来存储消息的
FIFO 先进先出
FIFO 的顺序无法保证的情况 ：priority and sharded queues（优先级的消费者，和分片消费者）

顺序的影响因素：多个竞争消费者；消费者的优先级；消息的重新投递

多个消费者权重一致的情况下，通过轮询的方式访问；（在没有超过消费者的预取值）

队列的持久化，以及消息的持久化：
    队列持久化 在节点重启时会恢复，不会删除； 临时队列会在节点重启后被删除
    持久化消息 在节点重启也会保留； 非持久化的消息在节点重启会被删除（就算保存在持久化的队列中也会被删除）
    
大多数场景下，吞吐量和延迟是不受持久化属性影响的。只有环境上，队列被高频的删除和声明（每秒100次及以上删除或者声明）        

一般推荐使用持久化队列（仲裁队列只支持持久化）
    一般只有生命周期比较短的消费者：一些手机应用或者设备（经常下线或者身份信息经常变的应用，重连就会变）
   
临时队列的自动删除：
    1. 设置 auto-delete队列，自动删除队列会在最后一个消费者取消订阅的时候自动删除
    2. 排查队列（只能被声明的连接进行使用，其他连接连接时会被拒绝RESOURCE_LOCKED）
    
```

##### rabbitmq监控
```
## 监控描述
https://www.rabbitmq.com/rabbitmq-diagnostics.8.html

## 查看所有队列，报错（队列名称和消息数量）
./rabbitmq-diagnostics list_queues （效果同 ./rabbitmqctl list_queues）
#### 不带表头
./rabbitmq-diagnostics -s list_exchanges （效果同 ./rabbitmqctl -s list_exchanges）
## 获取所有host /下用户权限信息 -p设置host
./rabbitmqctl -q list_permissions -p /

#### http api 方式请求rabbitmq
https://www.cnblogs.com/weschen/p/11833835.html

### https://pulse.mozilla.org/api/ 基本释义

### rabbitmq集成prometheus
https://www.rabbitmq.com/prometheus.html
## 参考blog
https://blog.csdn.net/yaomingyang/article/details/104037083

## prometheus接口暴露
http://10.19.141.131:15692/metrics
```














