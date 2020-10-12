---
title: windows安装shadowsocks
author: liuly
date: 2020-03-06 16:48:14
categories:

- Windows
typora-root-url: ../..
---

### windows安装shadowsocks

#### 1安装[nodejs](https://nodejs.org/en/)

#### 2安装shadowssocks

```
npm install -g shadowsocks
```

#### 3修改配置

打开路径`C:\Users\liuly\AppData\Roaming\npm\node_modules\shadowsocks`，修改文件`config.json`

```json
{
    "server":"::",
    "server_port":8388,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"abc12345",
    "timeout":600,
    "method":"aes-256-cfb"
}
```

#### 4运行

双击`C:\Users\liuly\AppData\Roaming\npm\ssserver.cmd`

获知打开node.js，输入`ssserver`

#### 5自启动

```
@echo off

start C:\Windows\System32\cmd.exe /k "C:\ProgramFiles\nodejs\nodevars.bat"

start C:\Windows\System32\cmd.exe /k"ssserver"
```

放入`C:\Users\liuly\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\ss.bat`

