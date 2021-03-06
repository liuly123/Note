---
title: GitHub常用命令
author: liuly
date: 2020-03-06 16:48:14
categories:
- Linux
typora-root-url: ../..
---

### 1. 注册和创建储存库

[教程](https://www.jianshu.com/p/68b9e463333f)

创建的存储库地址为：https://github.com/liuly123/ORB-SLAM2。下面以此为背景

### 2. Ubuntu

#### 2.1 初始化

```sh
#设置用户名和邮箱
git config --global user.name "liuly123"
git config --global user.email "2240057686@qq.com"
#生成key
ssh-keygen -t rsa -C "2240057686@qq.com"
#复制生成的ssh key
cat ~/.ssh/id_rsa.pub
#粘贴到网站上：登录github-> Your profile -> 右边Edit profile -> SSH and GPG Keys-> New SSH key添加
```

#### 2.2 新建一个本地仓库

```sh
cd ORB-SLAM2
#初始化
git init
#添加github的地址，使用ssh方式可以避免每次输入密码（打开repository->clone or download -> Use SSH -> 复制地址）
git  remote add origin git@github.com:liuly123/ORB-SLAM2.git
#同步本地文件（commit）
git add -A
git commit -m '本次commit的说明'
git push origin master
```

**以后每次提交更改**

```sh
cd ORB-SLAM2
git add -A
git commit -m '本次commit的说明'
git push origin master
```

### 2.3其他说明

```sh
#查看同步状态
git status
#强制同步（会覆盖之前的所有版本），第一次一般需要
git push -u origin +master
#注意：无法上传超过100M的文件
#同步大文件出错的解决办法：
#查看commit id
git log
#回退到之前版本（本地文件也会别修改、删除）
git reset --hard 9ff7cad52bce71a0fb7a57928e1673f1a4f536f1
#本地与远程保持同步
git pull origin master
#抓取远程仓库
git clone git@github.com:liuly123/Note.git
```

### 2.3简化脚本

```sh
#!/bin/bash

time=$(date "+%Y-%m-%d %H:%M:%S")
git add -A
git commit -m "$time"
git push origin master
```

### 2.3浏览器扩展access token

```
960afe953e3e7e23d17c5c32d2ef8e39a15bb563
```

