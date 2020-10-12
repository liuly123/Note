---
title: ROS16.04
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

### 1. 安装

<http://wiki.ros.org/kinetic/Installation/Ubuntu>

**设置软件源**

```sh
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
```
**设置key**

```sh
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
```
**安装**
```sh
sudo apt-get update
sudo apt-get install ros-kinetic-desktop-full
```
**安装软件包**

```sh
sudo apt-get install ros-kinetic-<package>
```
**搜索软件包**

```sh
apt-cache search ros-kinetic
```
**初始化rosdp**
rosdep使您可以轻松地为要编译的源安装系统依赖项，并且需要在ROS中运行一些核心组件

```sh
sudo rosdep init
rosdep update
```
**设置环境变量**

```sh
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```
**安装工具包**
```sh
sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool build-essential
```
### 2. 教程
**查看环境配置**
```sh
printenv | grep ROS
```
**创建一个ROS工作区**
```sh
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin_make
```
**将工作区加入到PATH**
```sh
source ~/catkin_ws/devel/setup.bash
echo $ROS_PACKAGE_PATH
```
**安装示例程序**
```sh
sudo apt-get install ros-kinetic-ros-tutorials
```
### Filesystem Tools
**查找package**

```sh
rospack find roscpp
```
**进入package目录**
```sh
roscd roscpp
roscd roscpp/cmake
roscd log
```
**列出package的文件**
```sh
rosls roscpp_tutorials
```
### 3. 创建一个catkin包
**进入src目录**
```sh
cd ~/catkin_ws/src
```
**用catkin_create_pkg创建一个package(后面是依赖)**
```sh
catkin_create_pkg test std_msgs rospy roscpp
build一个catkin工作区并source安装文件
cd ~/catkin_ws
catkin_make
```
**package依赖关系**
```sh
rospack depends1 beginner_tutorials	#一阶依赖
rospack depends beginner_tutorials	#全部依赖，包含间接依赖
```
**定制package.xml和CMakeLists.xml**
http://wiki.ros.org/ROS/Tutorials/CreatingPackage
**build package**
```sh
cd ~/catkin_ws/
catkin_make
#可以自定义源代码所在目录
catkin_make --source my_src
catkin_make install --source my_src
```
### 4. node
**第一步**
```sh
roscore
```
**显示节点**
```sh
rosnode list
rosnode info /rosout
```
**运行节点**

```sh
rosrun turtlesim turtlesim_node
rosrun turtlesim turtlesim_node __name:=my_turtle //启动时修改节点名称
```
**ping节点**
```sh
rosnode ping my_turtle
```
### 5. topic
**使用rqt_graph**
```sh
sudo apt-get install ros-kinetic-rqt
sudo apt-get install ros-kinetic-rqt-common-plugins
rosrun rqt_graph rqt_graph
```
**实时显示topic中的message**
```sh
rostopic echo /turtle1/cmd_vel
```
**显示message类型**
```sh
rostopic list
rostopic list -v
rostopic type /turtle1/cmd_vel
rosmsg show geometry_msgs/Twist
rostopic type /turtle1/cmd_vel | rosmsg show
```
**发送message到topic**
```sh
#一次
rostopic pub -1 /turtle1/cmd_vel geometry_msgs/Twist -- '[2.0, 0.0, 0.0]' '[0.0, 0.0, 1.8]'
#频率为1Hz
rostopic pub /turtle1/cmd_vel geometry_msgs/Twist -r 1 -- '[2.0, 0.0, 0.0]' '[0.0, 0.0, -1.8]'
#数据发送速率
rostopic pub /turtle1/cmd_vel geometry_msgs/Twist -r 1 -- '[2.0, 0.0, 0.0]' '[0.0, 0.0, -1.8]'
```
**数据的滚动时间图**
```sh
rosrun rqt_plot rqt_plot
```
### 6. service
**查看服务**
```sh
rosservice list
rosservice type /clear
```
**调用服务**
```sh
rosservice call /clear
```
**service的信息**
```sh
rosservice type /spawn | rossrv show
```
**查找service**
```sh
rosservice find
```
**查看service的地址**
```sh
rosservice uri
```
### 7. 参数
```sh
rosparam list
```
**修改参数**
```sh
rosparam set /background_r 150
```
**获取参数值**
```sh
rosparam get /background_g
rosparam get /
```
**存储参数**
```sh
rosparam dump params.yaml
```
**加载参数**
```sh
rosparam load params.yaml
rosparam load params.yaml copy
```
### 8. 调试
**查看日志**
```sh
rosrun rqt_console rqt_console
```
**修改记录级别**
```sh
rosrun rqt_logger_level rqt_logger_level
```
### 9. roslaunch
**创建启动文件**
```sh
roscd beginner_tutorials
mkdir launch
nano launch/abc.launch
```
**运行启动文件**
```sh
roslaunch beginner_tutorials abc.launch
```
### 10. 默认编辑器
**设置默认编辑器**
```sh
#在 ~/.bashrc中添加
export EDITOR='nano -w'
```
### 11. 创建msg消息文件
**创建msg文件**
```sh
roscd beginner_tutorials
mkdir msg
echo "int64 num" > msg/Num.msg
```
### 12. 修改package.xml

```sh
#package.xml加入以下两行
<build_depend>message_generation</build_depend>
<run_depend>message_runtime</run_depend>
```
### 13. 修改CMakeLists.txt文件
```sh
#在fand_package()里加入依赖
message_generation

#取消注释，加入msg文件
 add_message_files(
   FILES
   Num.msg
 )

#取消注释
 generate_messages(
   DEPENDENCIES
   std_msgs
 )
#编译后测试消息类型
cd ~/catkin_ws 
catkin_make
rosmsg show test/Num
```

### 14. 创建srv服务文件
**创建srv文件**
```sh
nano ~/catkin_ws/srv/test/add.srv
```
**package.xml不用修改**

**修改CMakeLists.txt文件**
```sh
#在fand_package()里加入依赖
message_generation
#取消注释，增加srv文件
 add_service_files(
   FILES
   sum.srv
 )

#取消注释
 generate_messages(
   DEPENDENCIES
   std_msgs
 )

#检测srv
cd ~/catkin_ws
catkin_make
rossrv show test/sum
```

### 15. 发布者和订阅者(Python)
```sh
roscd beginner_tutorials
mkdir scripts
cd scripts
```
**创建发布者文件**
```sh
nano talker.py
chmod +x talker.py
```
**创建订阅者文件**
```sh
nano listener.py
chmod +x listener.py
```
**build节点**
```sh
cd ~/catkin_ws
catkin_make
```
**测试**
```sh
rosrun beginner_tutorials talker.py
rosrun beginner_tutorials listener.py
```
### 16. 发布者和订阅者(C++)
```sh
roscd beginner_tutorials
```
**创建发布者文件**
```sh
nano src/talker1.cpp
```
**创建订阅者文件**
```sh
nano src/listener1.cpp
```
**修改CMakeLists.txt，添加...**
```

```
**build节点**
```sh
cd ~/catkin_ws
catkin_make
```
#测试
```sh
rosrun beginner_tutorials talker1
rosrun beginner_tutorials listener1
```
### 17. 服务和客户端(Python)
```sh
roscd beginner_tutorials
cd scripts
```
**编写server node**
```sh
nano add_two_ints_server.py
chmod +x add_two_ints_server.py
```
**编写client node**
```sh
nano add_two_ints_client.py
chmod +x add_two_ints_client.py
```
**build 节点**
```sh
cd ~/catkin_ws
catkin_make
```
**测试**
```sh
rosrun beginner_tutorials add_two_ints_server.py
rosrun beginner_tutorials add_two_ints_client.py 1 3
```
#C++略
### 18. 记录和回放数据
**记录所有数据**
```sh
mkdir ~/bagfiles
cd ~/bagfiles
rosbag record -a
```
**查看数据信息**
```sh
rosbag info 2018-06-22-12-19-01.bag
```
**播放bag数据**
```sh
rosbag play 2018-06-22-12-19-01.bag
#空格暂停，s继续
```
**两倍速率播放**
```sh
-r 2
```
**设置起始**
```sh
-s
```
**仅记录特定的数据(subset为.bag名，后面为topics)**
```sh
rosbag record -O subset /turtle1/cmd_vel /turtle1/pose
```
rosbag局限性：时间不准确

### 19. rosservice服务
**查看服务**
```sh
rosservice list
```
**服务信息**
```sh
roservice info /RosAria/set_parameters
```
**服务的类型信息**
```sh
rossrv show `rosservice type /RosAria/set_parameters`
#或
rosservice type /RosAria/set_parameters | rossrv show
```