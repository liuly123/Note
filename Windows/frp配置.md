---
title: frp配置
author: liuly
date: 2020-03-06 16:48:14
categories:

- Windows
typora-root-url: ../..

---

## frp配置

#### [下载](https://github.com/fatedier/frp/releases/)

#### 服务端

```ini
#frps.ini
[common]
bind_port = 7000
dashboard_port = 7500
dashboard_user = liuly
dashboard_pwd = abc12345
token = qwertyabc
```

启动：`./frps -c ./frps.ini`

#### 客户端

```ini
#frpc.ini
[common]
server_addr = liuly.imwork.net
server_port = 7000
token = qwertyabc
[test]
type = tcp
local_ip = 127.0.0.1
local_port = 80
remote_port = 1024
```

启动：`./frps -c ./frps.ini`

## P2P配置

### 客户端

```ini
#frpc.ini
[common] 
server_addr = liuly.imwork.net
server_port = 7000
token = qwertyabc

[rdp_p2p]
remote_port = 3389
type = stcp
sk = aaaaa
local_ip = 192.168.1.172
local_port = 3389
```

### 访问端

```ini
#frpc.ini
[common] 
server_addr = liuly.imwork.net
server_port = 7000
token = qwertyabc

[rdp_visitor]
type = stcp
role = visitor
server_name = rdp_p2p
sk = aaaaa
bind_addr = 127.0.0.1
bind_port = 6666
```

