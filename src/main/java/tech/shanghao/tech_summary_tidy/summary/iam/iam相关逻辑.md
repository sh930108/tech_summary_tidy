
> 前言：iam相关内容

#### 相关业务逻辑
```
## 秘钥协商
接口：
1. 协商接口
2. 请求接口

### 0. 客户端 / 服务端 生成公私钥

### 1. 协商接口
a. 客户端请求参数：客户端公钥, 传入会话Id
b. 服务端接口逻辑：
    根据客户端公钥+自己私钥 根据椭圆算法 算出共享ID shareId （客户端服务端算出结果是一样）
    服务端随机UUID，加上客户端回话ID 重新生成会话ID
c. 返回参数：服务端公钥，会话ID

### 2. 密码入库接口
a. 客户端请求参数：
    DK: 使用AES(sharId + 随机密码)        请求头中
    会话ID: 协商接口中服务端返回会话Id       请求头中
    加密密码: 使用AES(明文密码 + 随机密码)   报文中
b. 服务端接口逻辑:(会话Id和共享秘钥是 一对key-value)
    根据会话ID，找到共享秘钥 shareId
    AES 解密DK, 去除shareId获取 随机密码
    AES 解密加密密码，去除 随机密码，得到明文密码；

ps: 
随机密码（任意字符串）
服务端重新返回会话ID:防止客户端不同的会话采用同一个UUID进行 密码入库请求。 

```

#### Ldap相关用法
```

### 相关概念和原理
https://www.cnblogs.com/wilburxu/p/9174353.html

### 搜索使用的过滤器
https://social.technet.microsoft.com/wiki/contents/articles/5392.active-directory-ldap-syntax-filters.aspx?Sort=MostUseful

### spring集成使用
https://blog.csdn.net/null____/article/details/13021577

### Ldap常用命令
https://www.cnblogs.com/sitoi/p/11819550.html
https://www.cnblogs.com/lemonu/p/11229231.html

```















