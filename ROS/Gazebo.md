---
title: Gazebo
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

https://blog.csdn.net/wangchao7281

## 1.下载Gazebo模型

首次运行Gazebo，加载模型会出现非常缓慢，原因可能是不能正确下载模型。所以要手动下载模型：

```bash
cd ~/.gazebo/models
wget http://file.ncnynl.com/ros/gazebo_models.txt
wget -i gazebo_models.txt
ls model.tar.g* | xargs -n1 tar xzvf
```

## 2. urdf文件

**创建urdf文件**

```bash
cd ~/catkin_ws/src
catkin_create_pkg robot_urdf
cd robot_urdf
gedit urdf/robot1.urdf
```

**文件内容[robot1.urdf](https://github.com/ros/urdf_tutorial/blob/master/urdf/07-physics.urdf)**

注意不能有中文，注释也不行。节选内容：

```xml
<?xml version="1.0"?>
<robot name="robot1">

    <material name="blue"><color rgba="0 0 0.8 1"/></material>
    <material name="white"><color rgba="1 1 1 1"/></material>

    <link name="base_link">
        <visual>
            <geometry>
                <cylinder length="0.6" radius="0.2"/>
            </geometry>
            <material name="blue"/>
        </visual>
        <collision>
            <geometry>
                <cylinder length="0.6" radius="0.2"/>
            </geometry>
        </collision>
        <inertial>
            <mass value="10"/>
            <inertia ixx="1.0" ixy="0.0" ixz="0.0" iyy="1.0" iyz="0.0" izz="1.0"/>
        </inertial>
    </link>

    <link name="head">
        <visual>
            <geometry>
                <sphere radius="0.2"/>
            </geometry>
            <material name="white"/>
        </visual>
        <collision>
            <geometry>
                <sphere radius="0.2"/>
            </geometry>
        </collision>
        <inertial>
            <mass value="2"/>
        <inertia ixx="1.0" ixy="0.0" ixz="0.0" iyy="1.0" iyz="0.0" izz="1.0"/>
        </inertial>
    </link>

    <joint name="head_swivel" type="continuous">
        <parent link="base_link"/>
        <child link="head"/>
        <axis xyz="0 0 1"/>
        <origin xyz="0 0 0.3"/>
    </joint>

</robot>
```

`link`零件，`joint`零件的连接方式，`visual`外观，`collision`碰撞，`inertial`加速度

**在rviz中查看模型**

查看.xaco文件一样

```bash
roslaunch urdf_tutorial  display.launch  model:=`rospack find robot_urdf`/urdf/robot1.urdf
```

## 3. xacro文件

xacro文件与urdf文件是等价的，xacro是宏定义的，编写大文件时便于理解

**创建.xacro文件并转换**

```bash
gedit /urdf/robot.urdf.xacro
#转换为.urdf文件
xacro --inorder robot.xacro > robot.urdf
#在rviz中加载
roslaunch urdf_tutorial  display.launch  model:=`rospack find robot_urdf`/urdf/robot.urdf.xacro
```

**文件内容[robot.urdf.xacro](https://github.com/ros/urdf_tutorial/blob/master/urdf/08-macroed.urdf.xacro)**

节选内容：

```xml
<?xml version="1.0"?>
<robot name="robot" xmlns:xacro="http://ros.org/wiki/xacro">

    <xacro:property name="width" value="0.2" />
    <xacro:property name="polelen" value="0.2" />
    <xacro:property name="bodylen" value="0.6" />

    <material name="blue"><color rgba="0 0 0.8 1"/></material>
    <material name="white"><color rgba="1 1 1 1"/></material>

    <xacro:macro name="default_inertial" params="mass">
        <inertial>
            <mass value="${mass}" />
            <inertia ixx="1.0" ixy="0.0" ixz="0.0" iyy="1.0" iyz="0.0" izz="1.0" />
        </inertial>
    </xacro:macro>

    <link name="base_link">
        <visual>
            <geometry>
            <cylinder radius="${width}" length="${bodylen}"/>
            </geometry>
            <material name="blue"/>
        </visual>
        <collision>
            <geometry>
                <cylinder radius="${width}" length="${bodylen}"/>
            </geometry>
        </collision>
        <xacro:default_inertial mass="10"/>
    </link>

    <link name="head">
        <visual>
            <geometry>
                <sphere radius="${width}"/>
            </geometry>
            <material name="white"/>
        </visual>
        <collision>
            <geometry>
                <sphere radius="${width}"/>
            </geometry>
        </collision>
        <xacro:default_inertial mass="2"/>
    </link>

    <joint name="head_swivel" type="continuous">
        <parent link="base_link"/>
        <child link="head"/>
        <axis xyz="0 0 1"/>
        <origin xyz="0 0 ${bodylen/2}"/>
    </joint>

    <joint name="gripper_extension" type="prismatic">
        <parent link="base_link"/>
        <child link="gripper_pole"/>
        <limit effort="1000.0" lower="-${width*2-.02}" upper="0" velocity="0.5"/>
        <origin rpy="0 0 0" xyz="${width-.01} 0 0.2"/>
    </joint>

    <link name="gripper_pole">
        <visual>
            <geometry>
                <cylinder length="${polelen}" radius="0.01"/>
            </geometry>
            <origin xyz="${polelen/2} 0 0" rpy="0 ${pi/2} 0 "/>
        </visual>
        <collision>
            <geometry>
                <cylinder length="${polelen}" radius="0.01"/>
            </geometry>
            <origin xyz="${polelen/2} 0 0" rpy="0 ${pi/2} 0 "/>
        </collision>
        <xacro:default_inertial mass="0.05"/>
    </link>

    <xacro:macro name="gripper" params="prefix reflect">

        <link name="${prefix}_gripper">
            <visual>
                <origin rpy="${(reflect-1)/2*pi} 0 0" xyz="0 0 0"/>
                <geometry>
                    <mesh filename="package://urdf_tutorial/meshes/l_finger.dae"/>
                </geometry>
            </visual>
            <collision>
                <geometry>
                    <mesh filename="package://urdf_tutorial/meshes/l_finger.dae"/>
                </geometry>
                <origin rpy="${(reflect-1)/2*pi} 0 0" xyz="0 0 0"/>
            </collision>
            <xacro:default_inertial mass="0.05"/>
        </link>

        <joint name="${prefix}_gripper_joint" type="revolute">
            <axis xyz="0 0 ${reflect}"/>
            <limit effort="1000.0" lower="0.0" upper="0.548" velocity="0.5"/>
            <origin rpy="0 0 0" xyz="${polelen} ${reflect*0.01} 0"/>
            <parent link="gripper_pole"/>
            <child link="${prefix}_gripper"/>
        </joint>

        <link name="${prefix}_tip">
            <visual>
                <origin rpy="${(reflect-1)/2*pi} 0 0" xyz="0.09137 0.00495 0"/>
                <geometry>
                    <mesh filename="package://urdf_tutorial/meshes/l_finger_tip.dae"/>
                </geometry>
            </visual>
            <collision>
                <geometry>
                    <mesh filename="package://urdf_tutorial/meshes/l_finger_tip.dae"/>
                </geometry>
                <origin rpy="${(reflect-1)/2*pi} 0 0" xyz="0.09137 0.00495 0"/>
            </collision>
            <xacro:default_inertial mass="0.05"/>
        </link>

        <joint name="${prefix}_tip_joint" type="fixed">
            <parent link="${prefix}_gripper"/>
            <child link="${prefix}_tip"/>
        </joint>

    </xacro:macro>

    <xacro:gripper prefix="left" reflect="1" />
    <xacro:gripper prefix="right" reflect="-1" />

</robot>
```

## 4. 加载机器人

创建launch文件

```bash
roscd rabot_urdf
gedit urdf/gazebo.launch
```

launch文件内容：

```xml
<launch>

    <!-- 参数 -->
    <arg name="paused" default="false"/>
    <arg name="use_sim_time" default="true"/>
    <arg name="gui" default="true"/>
    <arg name="headless" default="false"/>
    <arg name="debug" default="false"/>
    <arg name="model" default="$(find robot_urdf)/urdf/robot.urdf.xacro"/>
    <arg name="rvizconfig" default="$(find urdf_tutorial)/rviz/urdf.rviz" />
    <param name="robot_description" command="xacro --inorder $(arg model)" />

    <!-- 打开gazebo并加载一个空的世界 -->
    <include file="$(find gazebo_ros)/launch/empty_world.launch">
        <arg name="debug" value="$(arg debug)" />
        <arg name="gui" value="$(arg gui)" />
        <arg name="paused" value="$(arg paused)"/>
        <arg name="use_sim_time" value="$(arg use_sim_time)"/>
        <arg name="headless" value="$(arg headless)"/>
    </include>

    <!-- 在gazebo中加载机器人模型 -->
    <node name="urdf_spawner" pkg="gazebo_ros" type="spawn_model" args="-z 1.0 -unpause -urdf -model robot -param robot_description" respawn="false" output="screen" />

    <!-- 将机器人模型的state发布到ros -->
    <node pkg="robot_state_publisher" type="robot_state_publisher"  name="robot_state_publisher">
        <param name="publish_frequency" type="double" value="30.0" />
    </node>

    <!-- 启动rviz -->
    <node name="rviz" pkg="rviz" type="rviz" args="-d $(arg rvizconfig)" />

</launch>
```

## 5. 添加插件

在urdf.xacro文件中添加

**摩擦系数**

```xml
    <gazebo reference="left_wheel">
        <mu1>1</mu1>
        <mu2>1</mu2>
        <material>Gazebo/Black</material>
    </gazebo>
```

**差分驱动**

```xml
 <gazebo>
    <plugin name="differential_drive_controller" filename="libgazebo_ros_diff_drive.so">
        <alwaysOn>true</alwaysOn>
        <updateRate>50.0</updateRate>
        <leftJoint>car_base_left_wheel</leftJoint>
        <rightJoint>car_base_right_wheel</rightJoint>
        <wheelSeparation>1.0</wheelSeparation>
        <wheelDiameter>0.5</wheelDiameter>
        <torque>1.0</torque>
        <commandTopic>cmd_vel</commandTopic>
        <odometryTopic>odom</odometryTopic>
        <odometryFrame>odom</odometryFrame>
        <robotBaseFrame>base_link</robotBaseFrame>
        <publishWheelTF>true</publishWheelTF>
        <publishWheelJointState>true</publishWheelJointState>
        <wheelAcceleration>1</wheelAcceleration>
    </plugin>
 </gazebo>
```

**IMU**

```xml
<gazebo reference="imu_link">
    <gravity>true</gravity>
    <sensor name="imu_sensor" type="imu">
        <always_on>true</always_on>
        <update_rate>100</update_rate>
        <visualize>true</visualize>
        <topic>__default_topic__</topic>
        <plugin filename="libgazebo_ros_imu_sensor.so" name="imu_plugin">
            <topicName>imu</topicName>
            <bodyName>imu_link</bodyName>
            <updateRateHZ>100.0</updateRateHZ>
            <gaussianNoise>0.0</gaussianNoise>
            <xyzOffset>0 0 0</xyzOffset>
            <rpyOffset>0 0 0</rpyOffset>
            <frameName>imu_link</frameName>
        </plugin>
        <pose>0 0 0 0 0 0</pose>
    </sensor>
</gazebo>
```

**激光**

```xml
<gazebo reference="hokuyo_link">
    <material>Gazebo/Blue</material>
    <turnGravityOff>false</turnGravityOff>
    <sensor type="ray" name="head_hokuyo_sensor">
        <pose>0.0 ${car_length*0.3} ${(hokuyo_length+car_height)/2.0} 0 0 ${PI/2}</pose>
        <visualize>true</visualize>
        <update_rate>40</update_rate>
        <ray>
            <scan>
                <horizontal>
                    <samples>720</samples>
                    <resolution>1</resolution>
                    <min_angle>-1.570796</min_angle>
                    <max_angle>1.570796</max_angle>
                </horizontal>
            </scan>
            <range>
                <min>0.3</min>
                <max>10.0</max>
                <resolution>0.001</resolution>
            </range>
        </ray>
        <plugin name="gazebo_ros_head_hokuyo_controller" filename="libgazebo_ros_laser.so">
            <topicName>/scan</topicName>
            <frameName>hokuyo_link</frameName>
        </plugin>
    </sensor>
</gazebo>
```

