---
title: tf基础
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

#### http://wiki.ros.org/tf/Tutorials/

### 1. 演示

**安装Demo**

```sh
sudo apt-get install ros-kinetic-ros-tutorials ros-kinetic-geometry-tutorials ros-kinetic-rviz ros-kinetic-rosbash ros-kinetic-rqt-tf-tree
```

**运行Demo**

```sh
roslaunch turtle_tf turtle_tf_demo.launch
```

可以用方向键控制中心龟运动，另一个龟会跟着它，直到重合。另一只龟一直朝向中心龟，所以运动轨迹是弧形。

**原理**

这个演示使用tf库创建三个框架(坐标系)：世界框架，乌龟1框架和乌龟2框架。本教程使用tf发布器发布乌龟坐标框架和tf监听器来计算乌龟框架的差异，并移动一只乌龟来跟随另一只乌龟。

### 2. tf工具

现在让我们看看如何使用tf来创建这个演示。我们可以使用tf工具来查看幕后的工作。

**使用view_frames**

```sh
rosrun tf view_frames
```

会生成pdf文件，在这里我们可以看到由tf广播的三个框架：world，turtle1和turtle2。我们还可以看到world是turtle1和turtle2帧的父级。出于调试目的，view_frames还会报告有关何时收到最旧和最近的帧变换以及将tf帧发布到tf的速度的一些诊断信息。

**使用rqt_tf_tree**

```sh
rosrun rqt_tf_tree rqt_tf_tree
```

和刚才图像类似

**使用tf_echo**

```sh
rosrun tf tf_echo [reference_frame] [target_frame]
```

例如

```sh
rosrun tf tf_echo turtle1 turtle2
```

显示格式为

```
At time 1416409795.450
- Translation: [0.000, 0.000, 0.000]
- Rotation: in Quaternion [0.000, 0.000, 0.914, 0.405]
            in RPY [0.000, -0.000, 2.308]
```

当你驾驶你的乌龟时，你会看到变换随着两只乌龟相对移动而变化。

**/tf话题的内容**

```sh
rostopic echo  /tf
```

内容如下：

```sh
transforms: 
  - 
    header: 
      seq: 0
      stamp: 
        secs: 1542251108
        nsecs:  27065038
      frame_id: "world"
    child_frame_id: "turtle1"
    transform: 
      translation: 
        x: 0.550171077251
        y: 3.50581622124
        z: 0.0
      rotation: 
        x: 0.0
        y: 0.0
        z: 0.794140891677
        w: 0.607733695105

```

会循环播放turtle1和turtle2

### 3. rviz和tf

rviz是一个可视化工具，可用于检查tf帧。让我们用rviz来看看龟框架。让我们使用rviz的-d选项使用turtle_tf配置文件启动rviz：

```sh
rosrun rviz rviz -d `rospack find turtle_tf`/rviz/turtle_rviz.rviz
```

在侧栏中，您将看到由tf广播的帧。当你驾驶乌龟时，你会看到坐标框架在rviz中移动。

### 4. 编写一个tf广播器(Python)

#### 创建一个新的ros包

```sh
cd ~/catkin_ws/src
catkin_create_pkg learning_tf tf roscpp rospy turtlesim
cd ~/catkin_ws
catkin_make
```

#### 创建文件`nodes/turtle_tf_broadcaster.py`并添加执行权限

```python
#!/usr/bin/env python
#coding=utf-8
import roslib
#roslib.load_manifest('learning_tf')
import rospy
import tf
import turtlesim.msg
#本程序订阅/turtleX/pose的姿态数据，据此创建/world到/turtleX的坐标变换，发布到/tf主题上


# 每收到一次turtleX/pose的消息，运行此函数
def handle_turtle_pose(msg, turtlename):
    br = tf.TransformBroadcaster()
    br.sendTransform((msg.x, msg.y, 0),
                     tf.transformations.quaternion_from_euler(0, 0, msg.theta),
                     rospy.Time.now(),
                     turtlename,#子坐标系
                     "world")#父坐标系

if __name__ == '__main__':
    rospy.init_node('turtle_tf_broadcaster')
# 读取参数（乌龟名称），该节点只有这一个参数
    turtlename = rospy.get_param('~turtle')
# 本节点订阅主题“turtleX/pose”并在每个传入消息上运行函数handle_turtle_pose
    rospy.Subscriber('/%s/pose' % turtlename,
                     turtlesim.msg.Pose,
                     handle_turtle_pose,
                     turtlename)
    rospy.spin()
```

#### 创建文件`launch/start_demo.launch`

```xml
<launch>
    <!-- Turtlesim Node-->
    <node pkg="turtlesim" type="turtlesim_node" name="sim"/>
    <node pkg="turtlesim" type="turtle_teleop_key" name="teleop" output="screen"/>

    <node name="turtle1_tf_broadcaster" pkg="learning_tf" type="turtle_tf_broadcaster.py" respawn="false" output="screen" >
      <param name="turtle" type="string" value="turtle1" />
    </node>
    <node name="turtle2_tf_broadcaster" pkg="learning_tf" type="turtle_tf_broadcaster.py" respawn="false" output="screen" >
      <param name="turtle" type="string" value="turtle2" /> 
    </node>

  </launch>
```

### 5. 编写一个tf广播器(C++)

#### 创建一个新的ros包

同上

#### 创建文件`src/turtle_tf_broadcaster.cpp`

```c++
#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
#include <turtlesim/Pose.h>

std::string turtle_name;

//收到/turtleX/pose的消息时调用该回调函数
void poseCallback(const turtlesim::PoseConstPtr& msg){
  static tf::TransformBroadcaster br;
  tf::Transform transform;
  transform.setOrigin( tf::Vector3(msg->x, msg->y, 0.0) );//起始位置
  tf::Quaternion q;
  q.setRPY(0, 0, msg->theta);
  transform.setRotation(q);
  br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "world", turtle_name));
}

int main(int argc, char** argv){
  ros::init(argc, argv, "my_tf_broadcaster");
  if (argc != 2){ROS_ERROR("need turtle name as argument"); return -1;};
  turtle_name = argv[1];

  ros::NodeHandle node;
  ros::Subscriber sub = node.subscribe(turtle_name+"/pose", 10, &poseCallback);

  ros::spin();
  return 0;
};
```

#### 在`CMakeLists.txt`文件中添加

```cmake
add_executable(turtle_tf_broadcaster src/turtle_tf_broadcaster.cpp)
target_link_libraries(turtle_tf_broadcaster ${catkin_LIBRARIES})
```

然后编译一下

#### 创建文件`launch/start_demo.launch`

```xml
  <launch>
    <!-- Turtlesim Node-->
    <node pkg="turtlesim" type="turtlesim_node" name="sim"/>

    <node pkg="turtlesim" type="turtle_teleop_key" name="teleop" output="screen"/>
    <!-- Axes -->
    <param name="scale_linear" value="2" type="double"/>
    <param name="scale_angular" value="2" type="double"/>

    <node pkg="learning_tf" type="turtle_tf_broadcaster"
          args="/turtle1" name="turtle1_tf_broadcaster" />
    <node pkg="learning_tf" type="turtle_tf_broadcaster"
          args="/turtle2" name="turtle2_tf_broadcaster" />

  </launch>
```

### 6. 编写一个tf监听器(Python)

#### 创建文件`nodes/turtle_tf_listener.py`

```python
#!/usr/bin/env python
#coding=utf-8
import roslib
roslib.load_manifest('learning_tf')
import rospy
import math
import tf
import geometry_msgs.msg
import turtlesim.srv

if __name__ == '__main__':
    rospy.init_node('turtle_tf_listener')

    listener = tf.TransformListener()
#创建一只乌龟，起始位置在(4,2,0)
    rospy.wait_for_service('spawn')
    spawner = rospy.ServiceProxy('spawn', turtlesim.srv.Spawn)
    spawner(4, 2, 0, 'turtle2')

    turtle_vel = rospy.Publisher('turtle2/cmd_vel', geometry_msgs.msg.Twist,queue_size=1)

    rate = rospy.Rate(10.0)
    while not rospy.is_shutdown():
        try:
            (trans,rot) = listener.lookupTransform('/turtle2', '/turtle1', rospy.Time(0))
        except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException):
            continue

        angular = 4 * math.atan2(trans[1], trans[0])
        linear = 0.5 * math.sqrt(trans[0] ** 2 + trans[1] ** 2)
        cmd = geometry_msgs.msg.Twist()
        cmd.linear.x = linear
        cmd.angular.z = angular
        turtle_vel.publish(cmd)

        rate.sleep()
```

添加执行权限

#### 在`launch`文件中添加

```xml
<node pkg="learning_tf" type="turtle_tf_listener.py" name="listener" />
```

### 7. 编写一个tf监听器(C++)

#### 创建文件`src/turtle_tf_listener.cpp`

```c++
#include <ros/ros.h>
#include <tf/transform_listener.h>
#include <geometry_msgs/Twist.h>
#include <turtlesim/Spawn.h>
//本程序先调用turtlesim的服务spawn创建一只乌龟
//然后根据/turtle2和/turtle1的坐标变换数据，向/turtle2发布控制指令

int main(int argc, char** argv){
  ros::init(argc, argv, "my_tf_listener");

  ros::NodeHandle node;

//调用spawn服务，添加一致乌龟，未指定起始位置，所以运行时会报错，并将乌龟2放在左下角
  ros::service::waitForService("spawn");
  ros::ServiceClient add_turtle =
    node.serviceClient<turtlesim::Spawn>("spawn");
  turtlesim::Spawn srv;
  add_turtle.call(srv);

//发布turtle2的控制指令
  ros::Publisher turtle_vel =
    node.advertise<geometry_msgs::Twist>("turtle2/cmd_vel", 10);

  tf::TransformListener listener;

  ros::Rate rate(10.0);
  while (node.ok()){
    tf::StampedTransform transform;
    try{//读取最近的turtle2坐标系到turtle1坐标系的转换，保存在transform中
      listener.lookupTransform("/turtle2", "/turtle1",
                               ros::Time(0), transform);//Time(0)表示缓冲区中最新可用的变换
    }
    catch (tf::TransformException &ex) {
      ROS_ERROR("%s",ex.what());
      ros::Duration(1.0).sleep();
      continue;
    }
//发布消息
    geometry_msgs::Twist vel_msg;
    vel_msg.angular.z = 4.0 * atan2(transform.getOrigin().y(),//转向角度为误差的4倍
                                    transform.getOrigin().x());
    vel_msg.linear.x = 0.5 * sqrt(pow(transform.getOrigin().x(), 2) +
                                  pow(transform.getOrigin().y(), 2));//前进距离为距离的一半
    turtle_vel.publish(vel_msg);

    rate.sleep();
  }
  return 0;
};
```

#### 在`CMakeLists.txt`文件中添加

```cmake
add_executable(turtle_tf_listener src/turtle_tf_listener.cpp)
target_link_libraries(turtle_tf_listener ${catkin_LIBRARIES})
```

然后编译一下

#### 在`launch`文件中添加

```xml
<node pkg="learning_tf" type="turtle_tf_listener" name="listener" />
```

### 8. 添加一个坐标系变换(Python)

#### 创建文件`nodes/fixed_tf_broadcaster.py`

```python
#!/usr/bin/env python
import roslib

import rospy
import tf

if __name__ == '__main__':
    rospy.init_node('fixed_tf_broadcaster')
    br = tf.TransformBroadcaster()
    rate = rospy.Rate(10.0)
    while not rospy.is_shutdown():
        br.sendTransform((0.0, 2.0, 0.0),#平移
                         (0.0, 0.0, 0.0, 1.0),#表示旋转的四元数
                         rospy.Time.now(),
                         "carrot1",#子坐标系
                         "turtle1")#父坐标系
        rate.sleep()
```

在这里，我们创建一个新的转换，从父“turtle1”到新的子“carrot1”。carrot1框架距离turtle1框架偏移2米。

#### 在`launch`文件中添加

```xml
	<node pkg="learning_tf" type="fixed_tf_broadcaster.py" name="broadcaster_fixed" />
```

#### 随时间变化的坐标变换

```python
#!/usr/bin/env python  
import roslib
roslib.load_manifest('learning_tf')

import rospy
import tf
import math

if __name__ == '__main__':
    rospy.init_node('dynamic_tf_broadcaster')
    br = tf.TransformBroadcaster()
    rate = rospy.Rate(10.0)
    while not rospy.is_shutdown():
        t = rospy.Time.now().to_sec() * math.pi
        br.sendTransform((2.0 * math.sin(t), 2.0 * math.cos(t), 0.0),
                         (0.0, 0.0, 0.0, 1.0),
                         rospy.Time.now(),
                         "carrot1",
                         "turtle1")
        rate.sleep()
```

### 9. 添加一个坐标系变换(C++)

#### 创建文件`src/frame_tf_broadcaster.cpp`

```c++
#include <ros/ros.h>
#include <tf/transform_broadcaster.h>
//carrot1框架距离turtle1框架偏移2米

int main(int argc, char** argv){
  ros::init(argc, argv, "my_tf_broadcaster");
  ros::NodeHandle node;

  tf::TransformBroadcaster br;
  tf::Transform transform;

  ros::Rate rate(10.0);
  while (node.ok()){
    transform.setOrigin( tf::Vector3(0.0, 2.0, 0.0) );
    transform.setRotation( tf::Quaternion(0, 0, 0, 1) );
    br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "turtle1", "carrot1"));
    rate.sleep();
  }
  return 0;
};
```

#### 修改`CMakeList.txt`

```cmake
add_executable(frame_tf_broadcaster src/frame_tf_broadcaster.cpp)
target_link_libraries(frame_tf_broadcaster ${catkin_LIBRARIES})
```

#### 随时间改变的坐标变换

```c++
    transform.setOrigin( tf::Vector3(2.0*sin(ros::Time::now().toSec()), 2.0*cos(ros::Time::now().toSec()), 0.0) );
    transform.setRotation( tf::Quaternion(0, 0, 0, 1) );
```

### 10. 等待转换(C++)

修改文件`src/turtle_tf_listener.cpp`

```c++
  try{
    ros::Time now = ros::Time::now();
    listener.waitForTransform("/turtle2", "/turtle1",
                              now, ros::Duration(3.0));//超时3s
    listener.lookupTransform("/turtle2", "/turtle1",
                             now, transform);
```

为什么要等待？每个监听器都有一个缓冲区，用于存储来自不同广播器的所有坐标转换。当广播器发出变换时，变换进入缓冲区需要一些时间（通常是几毫秒）。因此，当您在“now”时请求帧变换时，您应该等待几毫秒才能到达该信息。所有在一开始的时候还是会有错误出现，因为最开始的now时刻还没有数据。

### 11. 使用过去的状态(C++)

修改文件`src/turtle_tf_listener.cpp`

```c++
try{
    ros::Time now = ros::Time::now();//现在的时刻(注意此刻的转换还没完成，所以用waitForTran..)
    ros::Time past = now - ros::Duration(5.0);//5s前的时刻
    listener.waitForTransform("/turtle2", now,
                              "/turtle1", past,
                              "/world", ros::Duration(1.0));
    listener.lookupTransform("/turtle2", now,
                             "/turtle1", past,
                             "/world", transform);
```

/world是/turle1和/turle2的父坐标，/turtle1和、turtle2通过/world建立映射关系，在tf监听器中/turtle2到/turtle1的变换未指定/world，只是被省略了。本程序计算/turtle2相对于/turtle1 5s前的位姿，/world未省略。

刚开始会报错，因为5s前还没有/turtle1到/world的映射

### 12. 激光数据从base_laser坐标系变换到base_link坐标系

http://wiki.ros.org/navigation/Tutorials/RobotSetup/TF

base_link是小车的坐标系，lase_laser是激光器的坐标系。本文先建立一个节点发布两个坐标系的转换，然后建立一个节点读取转换结果。假设激光器安装在小车中心点前方10厘米上方20厘米处

#### 先创建一个包

```sh
cd ~/catkin_ws/src
catkin_create_pkg robot_setup_tf roscpp tf geometry_msgs
```

#### 创建文件`src/tf_broadcaster.cpp`

创建一个节点来完成通过ROS广播base_laser→base_link转换的工作

```c++
#include <ros/ros.h>
#include <tf/transform_broadcaster.h>

int main(int argc, char** argv){
  ros::init(argc, argv, "robot_tf_publisher");
  ros::NodeHandle n;

  ros::Rate r(100);

  tf::TransformBroadcaster broadcaster;

  while(n.ok()){
    broadcaster.sendTransform(//只有StampedTransform一个参数
      tf::StampedTransform(//有四个参数：旋转、平移、时间、父坐标系、子坐标系
        tf::Transform(tf::Quaternion(0, 0, 0, 1), tf::Vector3(0.1, 0.0, 0.2)),
        ros::Time::now(),"base_link", "base_laser"));
    r.sleep();
  }
}
```

#### 创建文件`src/tf_listener.cpp`

编写一个节点，该节点将使用上面创建的变换，在“base_laser”坐标系中取一个点并将其转换为“base_link”坐标系中的一个点

```c++
#include <ros/ros.h>
#include <geometry_msgs/PointStamped.h>
#include <tf/transform_listener.h>

void transformPoint(const tf::TransformListener& listener){
  
  geometry_msgs::PointStamped laser_point;//定义laser_point点
  laser_point.header.frame_id = "base_laser";
  laser_point.header.stamp = ros::Time();
  laser_point.point.x = 1.0;
  laser_point.point.y = 0.2;
  laser_point.point.z = 0.0;

  try{
    geometry_msgs::PointStamped base_point;//定义base_point点
    //启动转换，将base_laser中的laser_point点转换到base_link中的base_point点
    listener.transformPoint("base_link", laser_point, base_point);

    ROS_INFO("base_laser: (%.2f, %.2f. %.2f) -----> base_link: (%.2f, %.2f, %.2f) at time %.2f",
        laser_point.point.x, laser_point.point.y, laser_point.point.z,
        base_point.point.x, base_point.point.y, base_point.point.z, base_point.header.stamp.toSec());
  }
  catch(tf::TransformException& ex){//ROS_ERROR不支持中文
   ROS_ERROR("Received an exception trying to transform a point from \"base_laser\" to \"base_link\": %s", ex.what());
  }
}

int main(int argc, char** argv){
  ros::init(argc, argv, "robot_tf_listener");
  ros::NodeHandle n;

  tf::TransformListener listener(ros::Duration(10));

  //每秒执行一次转换
  ros::Timer timer = n.createTimer(ros::Duration(1.0), boost::bind(&transformPoint, boost::ref(listener)));

  ros::spin();

}
```

#### 修改`CMakeList.txt`

```cmake
add_executable(tf_broadcaster src/tf_broadcaster.cpp)
add_executable(tf_listener src/tf_listener.cpp)
target_link_libraries(tf_broadcaster ${catkin_LIBRARIES})
target_link_libraries(tf_listener ${catkin_LIBRARIES})
```

### 13. urdf与robot_state_publisher的示例

http://wiki.ros.org/urdf/Tutorials/Using%20urdf%20with%20robot_state_publisher

首先创建一个机器人的urdf文件，然后编写机器人关节状态发布程序，通过/tf话题发布机器人关节状态。使用rviz显示机器人的3D模型及其运动。

#### 创建urdf文件

http://wiki.ros.org/urdf/Tutorials/Using%20urdf%20with%20robot_state_publisher?action=AttachFile&do=get&target=model.xml

#### 创建一个包，依赖为`roscpp rospy tf sensor_msgs std_msgs`

#### 创建并编译文件`src/state_publisher.cpp`

```c++
#include <string>
#include <ros/ros.h>
#include <sensor_msgs/JointState.h>
#include <tf/transform_broadcaster.h>

int main(int argc, char** argv) {
    ros::init(argc, argv, "state_publisher");
    ros::NodeHandle n;
    ros::Publisher joint_pub = n.advertise<sensor_msgs::JointState>("joint_states", 1);
    tf::TransformBroadcaster broadcaster;
    ros::Rate loop_rate(30);

    const double degree = M_PI/180;

    // 机器人状态
    double tilt = 0, tinc = degree, swivel=0, angle=0, height=0, hinc=0.005;

    // 消息声明
    geometry_msgs::TransformStamped odom_trans;
    sensor_msgs::JointState joint_state;
    odom_trans.header.frame_id = "odom";//world坐标系叫odom
    odom_trans.child_frame_id = "axis";//轴坐标系，相当于一个基座

    while (ros::ok()) {
        //更新关节状态
        joint_state.header.stamp = ros::Time::now();
        joint_state.name.resize(3);
        joint_state.position.resize(3);
        joint_state.name[0] ="swivel";//旋转
        joint_state.position[0] = swivel;
        joint_state.name[1] ="tilt";//倾斜
        joint_state.position[1] = tilt;
        joint_state.name[2] ="periscope";//潜望镜
        joint_state.position[2] = height;


        // 更新变换
        // (使轴做做圆周运动)
        odom_trans.header.stamp = ros::Time::now();
        odom_trans.transform.translation.x = cos(angle)*2;
        odom_trans.transform.translation.y = sin(angle)*2;
        odom_trans.transform.translation.z = .7;
        odom_trans.transform.rotation = tf::createQuaternionMsgFromYaw(angle+M_PI/2);

        // 发布关节状态和变换
        joint_pub.publish(joint_state);
        broadcaster.sendTransform(odom_trans);

        // 创建新的机器人状态

	//用于头的摆动
        tilt += tinc;
        if (tilt<-.5 || tilt>0) tinc *= -1;//在0.5到0.2度之间
        height += hinc;
        if (height>.2 || height<0) hinc *= -1;

        swivel += degree;//用于轴的旋转
        angle += degree/4;//用于计算轴的圆周运动

        loop_rate.sleep();
    }


    return 0;
}
```

#### 创建launch文件

```xml
<launch>
        <param name="robot_description" command="cat $(find r2d2)/launch/model.xml" />
        <node name="robot_state_publisher" pkg="robot_state_publisher" type="state_publisher" />
        <node name="state_publisher" pkg="r2d2" type="state_publisher" />
</launch>
```

#### 测试

运行该`.launch`文件，然后打开新窗口，运行`rosrun rviz rviz`。修改`Fiexed Frame`参数为`odom`，添加`RobotModel`，即可显示机器人。

可见机器人两腿做圆周运动，头和身体随两腿运动，并绕轴摆动，添加各种`Axes`可以显示各个坐标系。

#### 总结

编写的`state_publisher`节点发布的tf话题只有`odom`到`axis`的变化，还发布了3个机器人关节状态`swivel`、`tilt`、`periscope`，分别对应头的旋转、身体的摆动、潜望镜的上下运动。`robot_state_publisher`节点根据urdf文件将这三个关节参数转换为tf变换，并发布到/tf话题。rviz订阅这些/tf话题是机器人模型运动