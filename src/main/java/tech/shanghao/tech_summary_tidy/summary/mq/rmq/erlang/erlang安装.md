
## Erlang安装

### 方法一：

1. 下载Erlang安装包
    https://www.erlang.org/downloads
    本例使用 otp_src_22.2.tar.gz
2. 安装包放在/opt (可自行调整) 下
3. 安装步骤
```
## 1. /user 创建目录
mkdir -p /usr/local/erlang 

## 2. 解压
tar -xvf otp_src_22.2.tar.gz

## 3. 准备环境
yum -y install make gcc gcc-c++ kernel-devel m4 ncurses-devel openssl-devel

## 4.进入解压目录
cd /opt/erlang/otp_src_22.2

## 5. 设定安装规则
./configure --prefix=/usr/local/erlang --with-ssl --enable-threads --enable-smp-support --enable-kernel-poll --enable-hipe --without-javac

## 6.安装
make && make install

## 7. set erlang environment
ERL_PATH=/usr/local/erlang/bin
PATH=$ERL_PATH:$PATH

echo 'export PATH=$PATH:/usr/local/erlang/bin' >> /etc/profile

## 8.使配置生效
source /etc/profile

## 9.检验是否安装成功
erl
## 检查是否支持ssl,如果不支持rabbitmq启动失败
>ssl:versions().
## 退出
>halt().
```


### erlang 22.3编译
```
## 进入编译文件夹
cd /opt/erlang/otp_src_22.3
## 依赖
yum -y install make gcc gcc-c++ kernel-devel m4 ncurses-devel openssl-devel
## 配置路径
./configure --prefix=/usr/local/rabbitmq/erlang --with-ssl --enable-threads --enable-smp-support --enable-kernel-poll --enable-hipe --without-javac
## 编译
make && make install

## 国产化安装需要将对应的ssl进行拷到相对路径中
./configure --prefix=/usr/local/rabbitmq/erlang --with-ssl --with-ssl-rpath=./ --enable-threads --enable-smp-support --enable-kernel-poll --enable-hipe --without-javac
## --with-ssl-rpath=./
## 查看编译的ssl路径
cd /usr/local/rabbitmq/erlang/lib/erlang/lib/crypto-4.6.5/priv/lib
ldd -r crypto.so

可以看到 libcrypto.so.1.1 => /lib64/libcrypto.so.1.1 (0x0000ffffba6e0000)
## 将/lib64/libcrypto.so.1.1库拷到bin路径下

## 打包成成果物

## rabbitmq 在国产化执行还是报crypto依赖库缺失
需要将libcrypto.so.1.1拷到rmq命令执行目录：sbin下



```




