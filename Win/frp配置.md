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