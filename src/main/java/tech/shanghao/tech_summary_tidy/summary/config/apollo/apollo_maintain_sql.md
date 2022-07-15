
#### 维护sql

1. 查询sql
```
select  *FROM ApolloConfigDB.App where AppId like '%apigw%';
select  *FROM ApolloPortalDB.App where AppId like '%apigw%';
select  *FROM ApolloConfigDB.Cluster where AppId like '%apigw%';
select  *FROM ApolloPortalDB.App where AppId like '%api%';
select  *FROM ApolloConfigDB.AppNamespace where AppId like '%api%';
select  *FROM ApolloConfigDB.Namespace where AppId='apigw_1.0.0' and ClusterName='default' and NamespaceName='values.yaml';
select  *FROM ApolloConfigDB.Item where NamespaceId=63;
select  *FROM ApolloConfigDB.App where AppId=63;
```

```
DELETE FROM ApolloConfigDB.App  WHERE AppId like '%apigw%';
DELETE FROM ApolloConfigDB.AppNamespace  WHERE AppId like '%apigw%';
DELETE FROM ApolloConfigDB.Namespace  WHERE AppId like '%apigw%';
DELETE FROM ApolloConfigDB.Cluster  WHERE AppId like '%apigw%';
DELETE FROM ApolloConfigDB.Commit  WHERE AppId like '%apigw%';
DELETE FROM ApolloConfigDB.Release  WHERE AppId like '%apigw%';
DELETE FROM ApolloConfigDB.ReleaseHistory  WHERE AppId like '%apigw%';
DELETE FROM ApolloConfigDB.ReleaseMessage  WHERE Message like '%apigw%';

DELETE FROM ApolloPortalDB.App  WHERE AppId like '%apigw%';
DELETE FROM ApolloPortalDB.AppNamespace  WHERE AppId like '%apigw%';
DELETE FROM ApolloPortalDB.Permission  WHERE TargetId like '%apigw%';
DELETE FROM ApolloPortalDB.RolePermission where PermissionId in (
    select Permission.Id from ApolloPortalDB.Permission where TargetId  like '%apigw%'
    );
    
## 删除相关表记录
truncate table App;
truncate table AppNamespace;
truncate table Namespace;
truncate table Cluster;
truncate table Commit;
truncate table Release;
truncate table ReleaseHistory;
truncate table ReleaseMessage;

    
```

















