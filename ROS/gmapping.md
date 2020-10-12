---
title: gmapping
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

### 1. 安装gmapping

直接apt**安装**

```sh
sudo apt install ros-kinetic-gmapping
```

**或下载源码编译**

*openslam_gmapping* https://github.com/ros-perception/openslam_gmapping.git

*gmapping* https://github.com/ros-perception/slam_gmapping.git

openslam_gmapping是实现具体算法的包，gmapping对它进行了封装

### 2. launch文件

```xml
  <node name="gmapping" pkg="gmapping" type="slam_gmapping">
    <param name="base_frame" value="base_link"/>
    <param name="odom_frame" value="odom"/>
    <param name="map_frame" value="map"/>
    <param name="xmin" value="-10"/>
    <param name="ymin" value="-10"/>
    <param name="xmax" value="10"/>
    <param name="ymax" value="10"/>
    <!--本来订阅的是/scan节点，让它订阅/RosAria/sim_S3Series_1_laserscan节点-->
    <remap from="scan" to="/RosAria/sim_S3Series_1_laserscan"/>
  </node> 
```

### 3. 参数说明

**GMapping包装器使用的参数：**

```jade
"~throttle_scans": [int] 扔掉每第n次激光扫描
"~base_frame": [string] 用于机器人基础姿势的tf frame_id
"~map_frame": [string] 发布地图上机器人姿势的tf frame_id
"~odom_frame": [string] 从中读取odometry的tf frame_id
"~map_update_interval": [double] 两次重新计算地图之间的时间
```

**GMapping本身使用的参数：**

激光参数

```jade
"~/maxRange" [double] 激光扫描的最大范围（默认值：第一条LaserScan消息减1cm）
"~/maxUrange" [double] 用于地图构建的激光扫描仪的最大范围（默认值：与maxRange相同）
"~/sigma" [double] 扫描匹配过程的标准偏差（单元格）
"~/kernelSize" [int] 扫描匹配过程的搜索窗口
"~/lstep" [double] 扫描匹配的初始搜索步（线性）
"~/astep" [double] 扫描匹配的初始搜索步骤（角度）
"~/iterations" [int] ]扫描匹配中的细化步骤数。匹配的最终“精度”分别是lstep * 2 ^（ -  iterations）或astep * 2 ^（ -  iterations）。
"~/lsigma" [double] 扫描匹配过程的标准偏差（单激光束）
"~/ogain" [double] 平滑可能性的增益
"~/lskip" [int] 只拍摄第（n + 1）条激光以计算匹配（0 =拍摄所有光线）
"~/minimumScore" [double] 考虑扫描匹配物品结果的最低分数。当使用有限范围（例如5米）的激光扫描仪时，可以避免在大型开放空间中“跳跃”姿势估计（0=默认。分数上升到600+，当遇到“跳跃”估计问题尝试例如50）

```

运动模型参数（高斯噪声模型的所有标准偏差）

```jade
"~/srr" [double] 线性噪声分量（x和y）
"~/stt" [double] 角度噪声分量（θ）
"~/srt" [double] 线性 -> 角度噪声分量
"~/str" [double] 角度 -> 线性噪声分量
```

其他

```jade
"~/linearUpdate" [double] 如果机器人至少移动了这么多米，机器人仅仅处理新的测量值
"~/angularUpdate" [double] 如果机器人至少转动了这么多的rad，机器人仅仅处理新的测量值
"~/resampleThreshold" [double] 粒子在此处重新采样的阈值。更高意味着更频繁的重采样
"~/particles" [int] （固定）粒子数。每个粒子代表机器人行进的可能轨迹
```

可能性采样（用于扫描匹配）

```jade
"~/llsamplerange" [double] 线性范围
"~/lasamplerange" [double] 角度范围
"~/llsamplestep" [double] 线性步长
"~/lasamplestep" [double] 角度步长
```

初始地图尺寸和分辨率

```jade
"~/xmin" [double] 地图中的最小位置[m]
"~/ymin" [double] 地图中的最小y位置[m]
"~/xmax" [double] 地图中的最大x位置[m]
"~/ymax" [double] 地图中的最大y位置[m]
"~/delta" [double] 一个像素的大小[m]
```

