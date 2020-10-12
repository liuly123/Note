---
title: N2N配置
date: 2020-04-08 09:17:40
categories:
- Linux
typora-root-url: ../..
---

# Debian/Ubuntu安装

```sh
#服务端与客户端安装过程一样
sudo apt install subversion build-essential libssl-dev autoconf
git clone https://github.com/ntop/n2n.git
cd n2n
./autogen.sh
./configure
make
sudo make install
```

## 服务端

```sh
supernode -l 5000 -v
#表示监听5000端口，-v用于输出日志，便于调试。
```

## 客户端

```sh
sudo /usr/sbin/edge -d edge0 -a 10.0.0.11 -c mynetwork -u 1000 -g 1000 -k passwd -l sparkydog.top:2333 -m ae:e0:4f:e7:47:5c
```

参数说明

- **“-c"** 网络组，相同的网络组内可互通
- **“-a <IP地址>”**选项（静态地）指定了分配给 TAP 接口的 VPN 的 IP 地址。如果你想要使用 DHCP，你需要在其中一台边缘节点上配置一台 DHCP 服务器，然后使用“-a dhcp:0.0.0.0”选项来代替。
- **“-c <组名>”**选项指定了 VPN 组的名字（最大长度为 16 个字节）。这个选项可以被用来在同样一组节点中创建多个 VPN。
- **“-u”和“-g”**选项被用来在创建一个 TAP 接口后降权放弃 root 权限。edge 守护进程将会作为指定的用户/组 ID 运行。
- **“-k <密钥>”**选项指定了一个由 twofish 加密的密钥来使用。如果你想要将密钥从命令行中隐藏，你可以使用 N2N_KEY 环境变量。
- **“-l <IP地址：端口>”**选项指定了超级节点的监听 IP 地址和端口号。为了冗余，你可以指定最多两个不同的超级节点（比如 -l <超级节点 A> -l <超级节点 B>）。
- **“-m ”**给 TAP 接口分配了一个静态的 MAC 地址。不使用这个参数的话，edge 命令将会随机生成一个 MAC 地址。事实上，为一个 VPN 接口强制指定一个静态的 MAC 地址是被强烈推荐的做法。否则，比如当你在一个节点上重启了 edge 守护程序的时候，其它节点的 ARP 缓存将会由于新生成的 MAC 地址而遭到污染，它们将不能向这个节点发送数据，直到被污染的 ARP 记录被消除。





