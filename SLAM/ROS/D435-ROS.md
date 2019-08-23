### 编译安装库

```sh
git clone https://github.com/IntelRealSense/librealsense
#cmake编译并install
```

### 安装ROS包

```sh
#安装依赖
sudo apt install ros-kinetic-ddynamic-reconfigure
#克隆ROS包并编译
cd ~/catkin_ws/src
git clone https://github.com/IntelRealSense/realsense-ros/
cd ~/catkin_ws
catkin_make
```

### 测试

```sh
roslaunch realsense2_camera rs_camera.launch
```