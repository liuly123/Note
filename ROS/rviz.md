---
title: rviz
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

# Displays

**Axes**
显示一组轴
**Effort**
显示放入机器人每个旋转关节的力度
**Camera**
从相机的角度创建一个新的渲染窗口，并将图像叠加在其上
**Grid**	
沿平面显示2D或3D网格
**Grid Cells**
从网格中绘制单元格，通常是来自导航堆栈的成本映射的障碍物。
**Image**	
使用Image创建新的渲染窗口。与相机显示器不同，此显示器不使用CameraInfo。版本：Diamondback +
**InteractiveMarker** 
显示来自一个或多个Interactive Marker服务器的3D对象，并允许鼠标与它们进行交互。 版本：电动+
**Laser Scan**
显示激光扫描的数据，具有渲染模式，累积等的不同选项。
**Map**
在地平面上显示地图。
**Markers**
允许程序员通过主题显示任意原始形状
**Path**
显示导航堆栈中的路径。
**Point**
绘制一个点作为一个小球体。
**Pose**
将姿势绘制为箭头或轴。
**Pose Array**
绘制一个箭头的“云”，一个姿势数组中的每个姿势一个
**Point Cloud(2)**
显示来自点云的数据，具有渲染模式，累积等的不同选项。
**Polygon**
将多边形的轮廓绘制为线条。
**Odometry**
随着时间的推移累积里程表姿势。
**Range**显示表示声纳或红外范围传感器范围测量值的锥体。 版本：电动+
**RobotModel**
以正确姿势显示机器人的可视化表示（由当前TF变换定义）。
**TF**
显示tf变换层次结构。
**Wrench**
绘制扳手为箭头（力）和箭头+圆（扭矩）
**Oculus**
将RViz场景渲染到Oculus耳机