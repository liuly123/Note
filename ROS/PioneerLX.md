---
title: lx总结
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

#### 1. 安装Ubuntu16.04 64位

1. f11选择临时启动项

2. u盘启动后没有操作界面，按Alt+F4会弹出退出界面，点退出会进入试用界面，这时能正常显示桌面

3. 系统装好后，设置[远程桌面](https://www.cnblogs.com/xuliangxing/p/7642650.html)。

   由于内置了lvds显示器，分辨率为800x600，远程桌面无法调高分辨率，所以无法运行rviz。

   安装Ubuntu时不显示安装界面，也是由于内置显示器的原因

4. 设置ssh：`sudo apt install openssh-server`

#### 2. 安装ROS等软件

1. [安装](http://wiki.ros.org/cn/kinetic/Installation/Ubuntu)ROS并初始化和建立工作区

2. 安装libaria：`sudo dpkg -i libaria_2.9.4+ubuntu16_amd64.deb`

3. 安装机器人描述文件：`git clone https://github.com/MobileRobots/amr-ros-config`

4. 安装RosAria：`git clone https://github.com/amor-ros-pkg/rosaria.git`

5. 安装gmapping：`sudo apt install ros-kinetic-gmapping`

6. launch文件

   ```xml
   <launch>
   
     <arg name="urdf" default="$(find test)/launch/pioneer-lx.urdf" />
     <arg name="joint_state_gui" default="False" />
     <param name="robot_description" textfile="$(arg urdf)" />
     <node name="RosAria" pkg="rosaria" type="RosAria" args="_port:=/dev/ttyUSB0 _baud:=57600 _publish_aria_lasers:=true"/>
      <node name="joint_state_publisher" pkg="joint_state_publisher" type="joint_state_publisher" />
     <node name="robot_state_publisher" pkg="robot_state_publisher" type="state_publisher" />
   
     <node name="gmapping" pkg="gmapping" type="slam_gmapping">
   	<remap from="scan" to="/RosAria/S3Series_1_laserscan"/>
       <param name="base_frame" value="base_link"/>
       <param name="odom_frame" value="odom"/>
       <param name="map_frame" value="map"/>
       <param name="xmin" value="-10"/>
       <param name="ymin" value="-10"/>
       <param name="xmax" value="10"/>
       <param name="ymax" value="10"/>
     </node> 
   
   </launch>
   ```

7. 相关命令

   demo程序：`/usr/local/Aria/examples/demo -robotPort /dev/ttyUSB0 -robotBaud 57600`

   RosAria连接：`rosrun rosaria RosAria _port:=/dev/ttyUSB0 _baud:=57600`

#### 3. 主从机通信的配置

**lx修改**

`/etc/hosts`中添加

```
10.113.55.152	liuly-ubuntu
```

**笔记本修改**

`~/.bashrc`中添加

```
ROS_MASTER_URI=http://lx-ubuntu:11311
```

`/etc/hosts`中添加

```
10.113.38.26	lx-ubuntu
```

#### 4. rviz中无法显示`laserscan`

​	RosAria发布两个激光topics（不知道为什么有两个）：`/RosAria/S3Series_1_laserscan`和`/RosAria/tim3XX_2_laserscan`

​	这两个laserscan数据中的坐标系都是`laser_frame`，而`/tf`中的坐标系是`laser\x01_frame`和`laser\x02_frame`，应该是RosAria的bug

解决办法是只使用`S3Series_1_laserscan`中的数据：修改文件`~/catkin_ws/src/rosaria/LaserPublisher.cpp`，将`laser_frame`替换为`laser\x01_frame`