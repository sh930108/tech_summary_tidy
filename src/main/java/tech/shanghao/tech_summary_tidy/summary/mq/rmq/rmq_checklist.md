业务实现是：
	1）消息怎么投递的。
	2）消费者怎么消费消息。
	3）消息是否是可靠投递。
	4）消息投递方式。
	5）消息的生命周期。
	6）消息队列生命周期


AMQ 能力特点：
能力
1. topic/ queue (发布订阅 / 点对点)
2. 使用协议：tcp/amqp/stomp/mqtt
3. 安全红线 ssl， 使用用户名密码连接
4. 消息的持久化和非持久化
当broker宕机或者重启，之前发送的消息不会丢失
5. Virtual Topic ：消费者集群，避免重复消费
6. 性能需求

监控能力

SDK能力：
1. 自动重连机制
2. 可以设置消息过期时间
3. 支持ssl


1. 使用协议

amq：tcp/amqp/stomp/mqtt
rmq: amqp/stomp/mqtt/http


##生产检查表：
  
  1. virtual hosts : 在单租户（single-tenant）环境中， RMQ集群给单一系统提供服务时，默认的"/"完全足够了。
  2. Users： 生产环境需要 删除默认 guest 用户
        每个独立的系统建议使用不同的用户。
  	  原因：	
  		1. 让连接和对应的应用有关联关系
  		2. 可以设置细粒度的权限
  		3. 凭证转期(例如:定期或在发生违约时)
  		如果一个用有多个实例，需要权衡安全和简单易用性 （一个实例一个证书还是多个实例共享一个证书）
  		对于一个LOT应用，多个客户端提供一种功能，使用 authenticate using x509 certificates or source IP address ranges  就很有必要了。
  	
  	ps： source IP address ranges： 是个插件https://github.com/gotthardp/rabbitmq-auth-backend-ip-range
  	
  3. 监控：RMQ 发现如果使用内存超过可获得内存（操作系统提供） 的40%，将不再接受消息。配置参数 ：{vm_memory_high_watermark, 0.4}
  	修改RMQ内存参数的官网建议：
  		1. 任何时候都需要保证服务器上有128M的可使用内存；
  		2. 推荐的 vm_memory_high_watermark 范围在 0.4 - 0.66
  		3. 超过0.7不推荐。 由于系统和文件系统需要至少30%的空间，不然系统的性能由于分页 严重下滑。
  		
  4. disk space： 磁盘可用空间：默认 50M （用于开发和教学）
  		生产环境推荐参数：
  			{disk_free_limit, {mem_relative, 1.0}} ： 需要磁盘4GB（可使用空间），小于4GB会告警并阻塞发送者，且所有消息都不再接受。需要清空队列中的信息（消费者中的信息）
  			{disk_free_limit, {mem_relative, 1.5}} ： （更加可靠的设置）需要磁盘4GB（可使用空间） 少于6GB阻塞发送
  			{disk_free_limit, {mem_relative, 2.0}} ： 最保守的生产值。（希望RMQ一直有可用空间可以配置）
  
  5. Open File Handles Limit: 文件句柄数
  		最少 50K， 生产推荐 500K （不会引起硬件资源的消耗）
  
  6. 连接数：能复用同一个连接就复用同一个连接
  		创建连接的代价是很大，频繁创建可能耗光句柄数或者是内存。
  		如果系统不能保证使用少的连接数，需要使用线程池。
  
  7. channel 避免过度使用： 和连接数一样，不用了需要关闭掉
  
  8. 开发者需要避免轮询消费者：
  	轮询使用者(使用basic.get进行的消费)是应用程序开发人员在大多数情况下应该避免的功能，因为轮询本身就效率低下。
  	
  9. 安全
  		1. 建议使用TLS保护节点间通信。这意味着CLI工具也被配置为使用TLS。
  		2. RMQ 端口通产分为俩类：
  				a. 客户端库使用的端口(AMQP 0-9-1, AMQP 1.0, MQTT, STOMP, HTTP API)
  				b. 所有其他端口(节点间通信、CLI工具等)
  		b 通常限制在RMQ节点上或者可以使用CLI服务器上
  
  		TLS：生产环境建议使用自签名证书。
  		
  10. 集群：建议使用奇数节点（3，5），备份数 覆盖到集群的一半节点即可。
  
  11. Partition Handling Strategy： 建议使用 autoheal strategy
  
  12. 节点时间：节点时间保持同步，不同步虽然可以运行但是会导致数据统计不准确	