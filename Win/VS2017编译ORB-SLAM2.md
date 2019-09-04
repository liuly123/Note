### VS2017编译ORB-SLAM2

[教程](https://blog.csdn.net/o_ha_yo_yepeng/article/details/80070314)

1. #### 安装CMake

   [地址](https://cmake.org/download/)

2. #### 安装Git Bash（可选）

   [地址](https://gitforwindows.org/)

   ```sh
   git config --global user.name "liuly123"
   git config --global user.email "2240057686@qq.com"
   ssh-keygen -t rsa -C "2240057686@qq.com"
   cat C:\Users\liuly/.ssh
   #添加到GitHub上
   #以上这些步骤都可以省略
   ```

3. #### 下载源码

   [地址](https://github.com/phdsky/ORBSLAM24Windows)，使用git

4. #### 下载OpenCV库

   [地址](https://sourceforge.net/projects/opencvlibrary/files/opencv-win/2.4.13/)，解压，然后添加Path（用于运行）

   ```
   C:\Users\liuly\opencv\build\x64\vc14\bin
   ```

   为CMake添加环境变量：电脑的环境变量——>系统变量——>新建，变量名`OpenCV_DIR`变量值：（动态库）

   ```
   C:\Users\liuly\opencv\build
   ```

5. #### Eigen库

   Eigen库是一个模板库，不需要编译

6. #### 编译DBoW库

   打开CMake-gui，source code输入`C:\Users\liuly\Desktop\ORBSLAM24Windows\Thirdparty\DBoW2`，where to build输入`C:\Users\liuly\Desktop\ORBSLAM24Windows\Thirdparty\DBoW2\build`

   然后点configure，选中vs2017，platform选x64>generate>报错，然后修改OpenCV_DIR为`C:\Users\liuly\opencv\build\x64\vc14\lib`>configure>generate>open project>改成Release>右键ALL_BUILD>生成的lib文件为`ORBSLAM24Windows\Thirdparty\DBoW2\lib\ReleaseDBoW2.lib`

7. #### 编译g2o库

   打开Cmake-gui，输入source code和where to build>configure>generate>open project>改成Release>右键g2o>属性>C++/预处理器/预处理定义>最后一行添加`WINDOWS`>保存>右键ALL_BUILD>生成的lib文件为``ORBSLAM24Windows\Thirdparty\g2o\lib\Release\g2o.lib`

8. #### 编译Pangolin库

   打开Cmake-gui，输入source code和where to build>configure>generate>open project>改成Release。

   注意：Pangolin库编译的时候会在git上下载一些依赖库，需要先打开Shadowsocks，然后在GitBash输入

   ```sh
   git config --global http.proxy 'socks5://127.0.0.1:1080'
   ```

   然后右键ALL_BUILD>生成（会git下载一些文件，还会报错无法发开pthread.lib，忽略）

9. #### 编译ORB-SLAM2

   打开Cmake-gui，输入source code和where to build>configure>报错，然后修改OpenCV_DIR为`C:\Users\liuly\opencv\build\x64\vc14\lib`>configure>generate>open project>改成Release>添加一些库依赖：

   右键ORB-SLAM>属性>C++常规>附加包含目录>添加

   ```
   C:\Users\liuly\Desktop\ORBSLAM24Windows\Thirdparty\DBoW2
   C:\Users\liuly\Desktop\ORBSLAM24Windows\Thirdparty\DBoW2\DBoW2
   C:\Users\liuly\Desktop\ORBSLAM24Windows\Thirdparty\DBoW2\DUtils
   C:\Users\liuly\Desktop\ORBSLAM24Windows\Thirdparty\g2o
   ```

   右键ALL_BUILD>生成

10. #### 测试

    ```powershell
    #C:\Users\liuly\Desktop\ORBSLAM24Windows打开powshell
    #单目测试
    .\Examples\Monocular\Release\mono_tum.exe .\Vocabulary\ORBvoc.txt .\Examples\Monocular\TUM1.yaml C:\Users\liuly\Desktop\rgbd_dataset_freiburg1_xyz
    #双目
    .\Examples\RGB-D\Release\rgbd_tum.exe .\Vocabulary\ORBvoc.txt .\Examples\RGB-D\TUM2.yaml C:\Users\liuly\Desktop\rgbd_dataset_freiburg2_pioneer_360\ C:\Users\liuly\Desktop\rgbd_dataset_freiburg2_pioneer_360\associate.txt
    ```

    