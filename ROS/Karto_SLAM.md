---
title: Karto_SLAM
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

### 1. 安装

**源码安装**

ROS包：[slam_karto](https://github.com/ros-perception/slam_karto)、[open_carto](https://github.com/ros-perception/open_karto)、[sba包](https://github.com/ros-perception/sparse_bundle_adjustment)

大型稀疏矩阵运算库：`sudo apt install libsuitesparse-dev`

**或apt安装**

```bash
sudo apt install ros-kinetic-slam-karto
```

### 2. 运行

节点参数很少

```xml
<launch>
  <node pkg="slam_karto" type="slam_karto" name="slam_karto" output="screen">
    <remap from="scan" to="base_scan"/>
    <param name="odom_frame" value="odom_combined"/>
    <param name="map_update_interval" value="25"/>
    <param name="resolution" value="0.025"/>
  </node>
</launch>
```

