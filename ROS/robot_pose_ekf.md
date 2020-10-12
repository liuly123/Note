---
title: robot_pose_ekf
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

### 1. 里程计IMU融合`robot_pose_ekf`

订阅的主题：`/odom`、`/imu_data`

发布的主题：`/robot_pose_ekf/odom_combined`

发布的tf：odom_combined` → `base_footprint

#### 1.1 安装

```bash
sudo apt install ros-kinetic-robot-pose-ekf
rosdep install robot_pose_ekf
roscd robot_pose_ekf
rosmake
```

#### 1.2 launch文件

```xml
    <node pkg="robot_pose_ekf" type="robot_pose_ekf" name="robot_pose_ekf">
        <param name="output_frame" value="odom"/>
        <param name="freq" value="30.0"/>
        <param name="sensor_timeout" value="1.0"/>
        <param name="odom_used" value="true"/>
        <param name="imu_used" value="true"/>
        <param name="vo_used" value="false"/>
        <param name="debug" value="false"/>
        <param name="self_diagnose" value="false"/>
    </node>
```

#### 1.3 `/odom`里程计数据：

tf只有position和orientation。odom有位姿、速度、协方差。

```yaml
header: 
  seq: 1112
  stamp: 
    secs: 22
    nsecs: 415000000
  frame_id: "odom"
child_frame_id: "base_link"
pose: 
  pose: 
    position: 
      x: -8.24608844519e-06
      y: -0.000178601022118
      z: -1.45735762347e-09
    orientation: 
      x: -1.19448094995e-09
      y: -4.32005549201e-08
      z: 2.01247894141e-06
      w: 0.999999999998
  covariance: [1e-05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1e-05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1000000000000.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1000000000000.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1000000000000.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.001]
twist: 
  twist: 
    linear: 
      x: 1.97446405576e-05
      y: -8.1309133873e-06
      z: 0.0
    angular: 
      x: 0.0
      y: 0.0
      z: 8.58624585776e-07
  covariance: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
---
```



#### 1.4 `imu`数据：（九轴）

```yaml
header: 
  seq: 793
  stamp: 
    secs: 79
    nsecs: 579000000
  frame_id: "imu_link" //IMU的位置
orientation: 			//磁场方向及协方差
  x: -1.29253276193e-09
  y: 3.07688575148e-08
  z: 4.41769886557e-06
  w: 0.99999999999
orientation_covariance: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
angular_velocity: 		//角加速度及协方差
  x: -1.95721709783e-07
  y: 0.000147919743856
  z: -6.89713308081e-07
angular_velocity_covariance: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
linear_acceleration: 	//线加速度及协方差
  x: -6.03044763088e-07
  y: -2.53367623617e-08
  z: 9.8
linear_acceleration_covariance: [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
---
```

