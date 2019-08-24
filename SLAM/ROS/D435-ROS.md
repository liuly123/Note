[官方说明](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md),[参考](https://blog.csdn.net/Carminljm/article/details/86353775)

### 安装SDK

```sh
#更新系统内核到最新版，并安装依赖
sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade
sudo apt-get install --install-recommends linux-generic-lts-xenial xserver-xorg-core-lts-xenial xserver-xorg-lts-xenial xserver-xorg-video-all-lts-xenial xserver-xorg-input-all-lts-xenial libwayland-egl1-mesa-lts-xenial
#重启
sudo update-grub && sudo reboot
#下载源码
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
#安装依赖
sudo apt-get install git libssl-dev libusb-1.0-0-dev pkg-config libgtk-3-dev
sudo apt-get install libglfw3-dev	#针对16.04
#编译并安装uvc的内核驱动
./scripts/setup_udev_rules.sh
./scripts/patch-realsense-ubuntu-lts.sh
#cmake编译安装SDK
mkdir build && cd build
cmake ..
make
sudo make install
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
#RGB-D测试
roslaunch realsense2_camera rs_rgbd.launch
#打开rviz，add要显示的topic>: /camera/depth_registered/points
#获取内参矩阵k
rostopic echo /camera/color/camera_info
#K = [fx 0 cx 0 fy cy 0 0 1 ]
#双目摄像头的基线为55mm
```

### ORB-SLAM2测试

**创建配置文件**

```yaml
%~/ORB-SLAM2/Examples/ROS/ORB_SLAM2/D435.yaml
%YAML:1.0

#--------------------------------------------------------------------------------------------
# Camera Parameters. Adjust them!
#--------------------------------------------------------------------------------------------

# Camera calibration and distortion parameters (OpenCV) 
Camera.fx: 613.893310546875
Camera.fy: 613.830810546875
Camera.cx: 315.91748046875
Camera.cy: 249.05508422851562

Camera.k1: 0.0
Camera.k2: 0.0
Camera.p1: 0.0
Camera.p2: 0.0

Camera.width: 640
Camera.height: 480

# Camera frames per second 
Camera.fps: 30.0

# IR projector baseline times fx (aprox.)
Camera.bf: 30.720571899

# Color order of the images (0: BGR, 1: RGB. It is ignored if images are grayscale)
Camera.RGB: 1

# Close/Far threshold. Baseline times.
ThDepth: 50.0

# Deptmap values factor
DepthMapFactor: 1000.0

#--------------------------------------------------------------------------------------------
# ORB Parameters
#--------------------------------------------------------------------------------------------

# ORB Extractor: Number of features per image
ORBextractor.nFeatures: 1000

# ORB Extractor: Scale factor between levels in the scale pyramid 	
ORBextractor.scaleFactor: 1.2

# ORB Extractor: Number of levels in the scale pyramid	
ORBextractor.nLevels: 8

# ORB Extractor: Fast threshold
# Image is divided in a grid. At each cell FAST are extracted imposing a minimum response.
# Firstly we impose iniThFAST. If no corners are detected we impose a lower value minThFAST
# You can lower these values if your images have low contrast			
ORBextractor.iniThFAST: 20
ORBextractor.minThFAST: 7

#--------------------------------------------------------------------------------------------
# Viewer Parameters
#--------------------------------------------------------------------------------------------
Viewer.KeyFrameSize: 0.05
Viewer.KeyFrameLineWidth: 1
Viewer.GraphLineWidth: 0.9
Viewer.PointSize:2
Viewer.CameraSize: 0.08
Viewer.CameraLineWidth: 3
Viewer.ViewpointX: 0
Viewer.ViewpointY: -0.7
Viewer.ViewpointZ: -1.8
Viewer.ViewpointF: 500
```

**修改源文件中订阅的topic**

```c++
    message_filters::Subscriber<sensor_msgs::Image> rgb_sub(nh, "/camera/rgb/image_raw", 1);
    message_filters::Subscriber<sensor_msgs::Image> depth_sub(nh, "camera/depth_registered/image_raw", 1);
```

改为

```c++
    message_filters::Subscriber<sensor_msgs::Image> rgb_sub(nh, "/camera/color/image_raw", 1);
    message_filters::Subscriber<sensor_msgs::Image> depth_sub(nh, "/camera/depth/image_rect_raw", 1);
```

**重新编译**

```sh
./build_ros.sh
```

**运行**

```sh
roslaunch realsense2_camera rs_camera.launch
rosrun ORB_SLAM2 RGBD ~/ORB-SLAM2/Vocabulary/ORBvoc.txt ~/ORB-SLAM2/Examples/ROS/ORB_SLAM2/D435.yaml
```

### RTAB-Map测试

RTAB-Map安装参考`ZED-ROS-RTAB.md`

**测试**

```sh
#启动d435
roslaunch realsense2_camera rs_camera.launch align_depth:=true
#启动rtab
roslaunch rtabmap_ros rtabmap.launch rtabmap_args:="--delete_db_on_start" depth_topic:=/camera/aligned_depth_to_color/image_raw rgb_topic:=/camera/color/image_raw camera_info_topic:=/camera/color/camera_info approx_sync:=false
```

