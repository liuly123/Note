---
title: map_server
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

http://wiki.ros.org/map_server

### 1. 摘要

map_server提供`map_server` 节点，它提供地图数据作为service可以被调用。它还提供了`map_saver`命令行实用程序，它允许将动态生成的映射保存到文件中。

需要先安装

```sh
sudo apt install ros-kinetic-map-server
```



### 2. 地图格式

由此包中的工具操纵的地图存储在一对文件中。**YAML**文件描述了地图元数据，并命名了图像文件。**图像文件**对占用数据进行编码。

#### 2.1 YAML格式

```yaml
image: testmap.png #图像文件路径
resolution: 0.1 #分辨率，meters / pixel （米/像素）
origin: [0.0, 0.0, 0.0] #原点，地图中左下角像素的二维姿态(x,y,yaw)，yaw表示逆时针旋转
occupied_thresh: 0.65 #占用概率大于此阈值的像素被视为完全占用
free_thresh: 0.196 #占用概率小于此阈值的像素被认为是没占用(自由)
negate: 0 #是否应该反转 白/黑 自由/占用 的语义(阈值的解释不受影响)
mode: trinary #三种模式可选：trinary,scale或raw
```

#### 2.2 数值解释

如果像素的COLOR(颜色)值`x`在`[0,256]`范围内，那么在放入ROS消息时我们应该如何解释这个值？首先，我们将整数`x`转换为浮点数`p`，具体取决于yaml 对`negate`标志的解释：

- 如果`negative: 0`，则`p = (255 - x) / 255.0`，即黑色(0)对应`1.0`，白色(255)对应`0.0`

- 如果`negative: 1`，则`p = x / 255.0`，这是图像的非标准解释，这就是为什么它被称为否定

**trinary**

- `p > occupied_thresh`时，输出值为`100`，表示完全占用

- `p < free_thresh`时，输出值为`0`，表示空闲

- 否则，输出`-1`或`255`(unsigned char)，表示未知

**scale**

这将调整上述解释，以允许比三元组更多的输出值

- 如前所述，如果`p> occupied_thresh`，则输出值`100`；如果`p <free_thresh`，则输出值`0`

- 否则，输出`99 * (p - free_thresh) / (occupied_thresh - free_thresh)`，将输出范围为`[0,100]`的完整渐变值

**raw**

此模式将为每个像素输出`x`，因此输出范围为`[0,255]`

### 3. 命令行工具

#### 3.1 map_server

`map_server`是一个ROS节点，它从磁盘读取地图并通过ROS服务提供它。`map_server`的当前实现将地图图像数据中的颜色值转换为三元占用值：free (0),occupied(100)和unknown(-1)。此工具的未来版本可以使用0到100之间的值来传达更精细的占用等级。

```sh
rosrun map_server map_server mymap.yaml
```

**Topics**

```yaml
map_metadata (nav_msgs/MapMetaData) #地图元数据
map (nav_msgs/OccupancyGrid) #地图
```

**Services**

```yaml
static_map (nav_msgs/GetMap) #通过此服务检索地图
```

**Parameters**

```yaml
~frame_id (string, default: "map") #地图的坐标系
```

#### 3.2 map_saver

`map_saver`将地图保存到磁盘，例如，从SLAM制图服务。

```sh
rosrun map_server map_saver -f mymap #-f指定名称，默认名称为map
```

