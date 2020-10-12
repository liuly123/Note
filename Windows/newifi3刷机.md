---
title: newifi3刷机
author: liuly
date: 2020-03-06 16:48:14
categories:

- Windows
typora-root-url: ../..
---

### 开启ssh

打开连接http://192.168.99.1/newifi/ifiwen_hss.html，（没试过）

或登陆路由器，安装ssh插件

### 刷breed

把`newifi-d2-jail-break.ko`文件放进U盘，插路由器上

打开`putty.exe`，连接`192.168.99.1`，用户名是`root`，密码是`web登陆密码`

```sh
cd /mnt/sda1 #进入U盘，我的u盘名叫A，就是cd /mnt/A
ls #显示当前目录的文件
insmod newifi-d2-jail-break.ko #加载一个驱动文件（就是刷机）
```

等重启或半分钟

### 进breed，备份编程器固件，刷机

1. 拔电源，按住`reset键`，插电源
2. 浏览器输入http://192.168.1.1
3. 选择`固件备份`，点编程器固件，下载`full.bin`文件（编程器固件是整个flash的数据，含有无线矫正数据，所以要备份）
4. 选择`恢复出厂设置`，闪存布局选择`公版`，点`恢复出厂`
5. 选择`固件更新`，点`固件`右边的浏览，选择`NEWIFI-D2_3.4.3.9-099_20181020-1912.trx`或下载的对应固件，点`上传`，点`刷机`

### 设置ipv6

1. 进路由器，点`administration`，最下面选中文
2. 点`自定义设置`>`脚本`>`在防火墙规则启动后执行`>填入

```sh
modprobe ip6table_mangle
ebtables -t broute -A BROUTING -p ! ipv6 -j DROP -i eth2.2
brctl addif br0 eth2.2
```

都要点**应用本页设置**