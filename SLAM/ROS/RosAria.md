### 1. 前提是已安装ros

http://wiki.ros.org/Robots/AMR_Pioneer_Compatible#Launch_Files_and_Other_Configuration

https://blog.csdn.net/qq_35508344/article/details/77096177

https://blog.csdn.net/David_Han008/article/details/53966532
### 2. 安装rosaria
#### 2.1 建立workspace
```sh
source /opt/ros/kinetic/setup.bash
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin_make
source ~/catkin_ws/devel/setup.bash
```

#### 2.2 下载rosaria源码
```sh
cd ~/catkin_ws/src
git clone https://github.com/amor-ros-pkg/rosaria.git
```

#### 2.3安装libaria

下载地址http://robots.mobilerobots.com/ARIA/download/archives/

```sh
sudo dpkg -i libaria_2.9.4+ubuntu16_amd64.deb
```

#### 2.4 Build rosaria
```sh
cd ~/catkin_ws
catkin_make	#这将构建catkin工作区中的所有包
```

#### 2.5 安装MobileSim
http://robots.mobilerobots.com/wiki/MobileSim

#### 2.6 运行rosaria节点连接机器人
```sh
roscore
rosrun rosaria RosAria
rosrun rosaria RosAria _port:=/dev/ttyUSB0 _baud:=57600 #lx实体机
```

**注意：**使用rosrun指定参数时，ROS参数系统会自动存储此设置以供将来使用，如果省略该参数，将使用先前设置的值。

####  2.7 使用示例程序
```sh
cd ~/catkin_ws/src
git clone https://github.com/pengtang/rosaria_client.git
cd ~/catkin_ws
catkin_make
roscore
roslaunch rosaria_client rosaria_client_launcher.launch
```

### 3. RosAria的说明
#### 3.1 查看姿态
```sh
rostopic echo /RosAria/pose
```


#### 3.2 设定速度
```sh
rostopic pub -1 /RosAria/cmd_vel geometry_msgs/Twist '[0.1, 0.0, 0.0]' '[0.0, 0.0, 0.0]'
```


#### 3.3 打开laser
下次启动会记住设置

```sh
rosrun rosaria RosAria _publish_aria_lasers:=true
```

