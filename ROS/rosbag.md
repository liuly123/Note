---
title: rosbag
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

### 使用`rosbag`记录数据

```bash
MobileSim -m /usr/local/MobileSim/AMROffice.map -r pioneer-lx
roscore
rosrun rosaria RosAria _publish_aria_lasers:=true
rosbag record -a
```

### 播放数据

```bash
rosbag  play  2019-04-26-18-34-52.bag
```
