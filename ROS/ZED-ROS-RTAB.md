---
title: ZED-ROS-RTAB
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

## ZED Ubuntu16.04 ROS

<https://www.stereolabs.com/docs/ros/>

<https://www.cnblogs.com/zhencv/p/6739061.html>

### 安装ZED的ROS包

1. 切换到NV显卡（用的是nvidia-384，重启会自动把显卡切换到840M）

2. 安装CUDA

   [下载](http://developer.nvidia.com/cuda-downloads)x86_64/16.04/deb(network)

   ```sh
   sudo dpkg -i cuda-repo-ubuntu1604_10.1.168-1_amd64.deb
   #官方添加key的命令不能用，要手动下载再添加
   #下载地址#http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub
   sudo apt-key add 7fa2af80.pub
   sudo apt-get update
   #安装10.0版本，否则默认的cuda是10.1不能用
   sudo apt-get install cuda-10-0
   ```

3. 安装[ZED SDK](https://www.stereolabs.com/developers/release/)

4. 安装ROS包

   ```sh
   cd ~/catkin_ws/src/
   git clone https://github.com/stereolabs/zed-ros-wrapper.git
   cd ..
   catkin_make -DCMAKE_BUILD_TYPE=Release
   ```

5. 测试

   ```sh
   #这启动zed节点发布数据供用户使用
   roslaunch zed_wrapper zed.launch
   #这是用来演示的启动文件，和上面的冲突
   roslaunch zed_display_rviz display_zed.launch
   ```

### 安装RTAB-Map

https://github.com/introlab/rtabmap_ros，参考markdown文件


### apt方式安装

```sh
sudo apt-get install ros-kinetic-rtabmap-ros
```

### 源码方式安装

**安装依赖**

```sh
sudo apt-get install ros-kinetic-rtabmap ros-kinetic-rtabmap-ros
sudo apt-get remove ros-kinetic-rtabmap ros-kinetic-rtabmap-ros
```

**安装RTAB-Map的库**

```sh
cd ~
git clone https://github.com/introlab/rtabmap.git
cd rtabmap/build
cmake ..
make
sudo make install
```

**安装ros-pkg**

```sh
cd ~/catkin_ws
git clone https://github.com/introlab/rtabmap_ros.git src/rtabmap_ros
catkin_make -j1 #单线程编译，不然爆内存
```

### 测试RTAB-Map

```sh
roslaunch zed_rtabmap_example  zed_rtabmap.launch
```

