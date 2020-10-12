---
title: ZED-VS
author: liuly
date: 2020-03-06 16:48:14
categories:

- Windows
typora-root-url: ../..
---

1. 安装CUDA**

原来下的是CUDA10.1，ZED要求10.0，[下载地址](https://developer.nvidia.com/cuda-10.0-download-archive?target_os=Windows&target_arch=x86_64&target_version=10&target_type=exelocal )，一路下一步，精简安装

**2. 安装ZED-SDK**

一路下一步

**3. 创建VS工程**

3.1 打开VS>Visual C++> 空项目（起名为ZED）

3.2 右键`源文件`>添加>新项目>C++文件>（起名）main.cpp，粘贴内容为：[地址](https://raw.githubusercontent.com/stereolabs/zed-examples/master/plane%20detection/src/main.cpp)（浏览器打开再复制）

3.3 再添加一个C++文件，名叫`GLViewer.cpp`，内容为：[地址](https://raw.githubusercontent.com/stereolabs/zed-examples/master/plane%20detection/src/GLViewer.cpp)

3.4 右键`头文件`，添加一个头文件，名为`GLViewer.hpp`，内容为：[地址](https://raw.githubusercontent.com/stereolabs/zed-examples/master/plane%20detection/include/GLViewer.hpp)

3.5 右键ZED>属性>VC++目录>包含目录>





