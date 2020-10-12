---
title: ORB-SLAM
author: liuly
date: 2020-03-06 16:48:14
categories:

- ROS
typora-root-url: ../..
---

### 编译

```sh
git clone https://github.com/raulmur/ORB_SLAM2
cd ORB_SLAM2
./build.sh
#依赖：Pangolin、OpenCV、Eigen3
#DBoW2和g2o（ORB-SLAM自带）
```

### 单目测试

```sh
#下载TMU数据集https://vision.in.tum.de/data/datasets/rgbd-dataset/download
cd ~/ORB_SLAM
./Examples/Monocular/mono_tum ./Vocabulary/ORBvoc.txt ./Examples/Monocular/TUM1.yaml ~/dataset/rgbd_dataset_freiburg1_xyz
```

### 双目测试

```sh
#EuRoC数据集https://projects.asl.ethz.ch/datasets/doku.php?id=kmavvisualinertialdatasets
cd ORB-SLAM
./Examples/Stereo/stereo_euroc ./Vocabulary/ORBvoc.txt ./Examples/Stereo/EuRoC.yaml ~/dataset/mav0/cam0/data ~/dataset/mav0/cam1/data ./Examples/Stereo/EuRoC_TimeStamps/MH01.txt
```

### RGB-D测试

```sh
#下载TUM数据集https://vision.in.tum.de/data/datasets/rgbd-dataset/download
cd ~/ORB_SLAM2
./Examples/RGB-D/rgbd_tum ./Vocabulary/ORBvoc.txt ./Examples/RGB-D/TUM1.yaml ~/dataset/rgbd_dataset_freiburg1_room/ ~/dataset/rgbd_dataset_freiburg1_room/associate.txt
```

### ROS安装

- 把ORB_SLAM2路径添加到ROS包的PATH中

  ```sh
  echo "export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/ORB-SLAM2/Examples/ROS/ORB_SLAM2" >> ~/.bashrc
  ```

- 编译

  ```sh
  cd ~/ORB-SLAM2/Examples/ROS/ORB_SLAM2
  mkdir build
  cd build
  cmake .. -DROS_BUILD_TYPE=Release
  make
  ```

- 解决`_ZN5boost6system15system_categoryEv`错误

  修改CMakeLists.txt的LIB设置，尾行添加`-lboost_system`，变为：

  ```makefile
  set(LIBS 
  ${OpenCV_LIBS} 
  ${EIGEN3_LIBS}
  ${Pangolin_LIBRARIES}
  ${PROJECT_SOURCE_DIR}/../../../Thirdparty/DBoW2/lib/libDBoW2.so
  ${PROJECT_SOURCE_DIR}/../../../Thirdparty/g2o/lib/libg2o.so
  ${PROJECT_SOURCE_DIR}/../../../lib/libORB_SLAM2.so
  -lboost_system
  )
  ```

  重新编译

### D435 RGB-D测试

参考`D435-ROS.md`

