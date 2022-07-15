
#### sql
```
## 数据拷备
insert into App (key1,key2,key3) select a,b,c from table2 # 插入指定字段值

例：
-- ServiceInstanceDetail
INSERT INTO `PROConfigDB`.ServiceInstanceDetail (ComponentVersion,ComponentIdentification,AppId,ClusterName,ContainerId,
SourceType,DataChange_CreatedBy,DataChange_CreatedTime,DataChange_LastModifiedBy,DataChange_LastTime)
select substring_index(a.AppId ,"_",-1),substring_index(a.AppId ,"_",1),a.AppId,c.Name,c.Name,
2,a.DataChange_CreatedBy,a.DataChange_CreatedTime ,a.DataChange_LastModifiedBy ,a.DataChange_LastTime 
FROM `ApolloConfigDB`.App a Left Join `ApolloConfigDB`.Cluster c on a.AppId = c.AppId WHERE a.`Type` = "SERVICE" AND a.AppId LIKE "%-%"; 

## sting 处理
substring_index("aaa_bbb_ccc","_",1) 返回为 aaa；
substring_index("aaa_bbb_ccc","_",2) 返回为 aaa_bbb；
substring_index(substring_index("aaa_bbb_ccc","_",-2),"_",1) 返回为 bbb；

```



















