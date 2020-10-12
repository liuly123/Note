---
title: windows下配置openvpn_server
author: liuly
date: 2020-03-06 16:48:14
categories:

- Windows
typora-root-url: ../..
---

## windows下配置openvpn server

### 安装

1.  [下载](https://openvpn.net/index.php/open-source/downloads.html)（需要翻墙），默认安装

2. 复制文件：`ca.crt`、`dh1024.pem`、`server.crt`、`server.key`到`C:\Program Files\OpenVPN\config`

3. 创建文件`server.ovpn`，然后复制到相同路径，内容如下


```yaml
port 1194             #指定监听的本机端口号
proto udp             #指定采用的传输协议，可以选择 tcp 或 udp
dev tun               #指定创建的通信隧道类型，可选 tun 或 tap
ca ca.crt             #指定 CA 证书的文件路径
cert server.crt       #指定服务器端的证书文件路径
key server.key    #指定服务器端的私钥文件路径
dh dh1024.pem         #指定迪菲赫尔曼参数的文件路径
server 192.168.137.0 255.255.255.0   #指定虚拟局域网占用的 IP 地址段和子网掩码，此处配置的服务器自身占用 10.0.0.1。
ifconfig-pool-persist ipp.txt   #服务器自动给客户端分配 IP 后，客户端下次连接时，仍然采用上次的 IP 地址
push "route 0.0.0.0 0.0.0.0"      #表示client通过VPN SERVER上网
push "redirect-gateway def1 bypass-dhcp"    #使client全部网络通信通过vpn
push "dhcp-option DNS 202.196.64.1"      #DNS配置，依据实际情况配置
push "dhcp-option DNS 202.196.64.2"      #DNS配置，依据实际情况配置
#tls-auth ta.key 0     #开启 TLS，使用 ta.key 防御攻击。服务器端的第二个参数值为 0，客户端的为 1。
keepalive 10 120      #每 10 秒 ping 一次，连接超时时间设为 120 秒。
comp-lzo              #开启 VPN 连接压缩，如果服务器端开启，客户端也必须开启
client-to-client      #允许客户端与客户端相连接，默认情况下客户端只能与服务器相连接
persist-key
persist-tun           #持久化选项可以尽量避免访问在重启时由于用户权限降低而无法访问的某些资源。
status openvpn-status.log    #指定记录 OpenVPN 状态的日志文件路径
verb 3                #指定日志文件的记录详细级别，可选 0 - 9，等级越高日志内容越详细
```

### 配置上网

**普通windows**

1、设置server的ip为`192.168.137.0`（server.ovpn）

2、打开网络连接，设置Internet连接共享，共享给vpn的虚拟网卡

（如果不行，就修改注册表开启NAT，`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\IPEnableRouter= 1`）

**windows server**

安装IIS，设置NAT规则