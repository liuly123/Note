[教程1](https://blog.csdn.net/JohnJim0/article/details/81842249)、[教程2](https://www.cnblogs.com/herelsp/p/8679200.html#_label2)

1. #### 安装CMake

   [地址](https://cmake.org/download/)，验证：控制台输入`cmake`

2. #### 安装MinGW

   [地址](https://sourceforge.net/projects/mingw-w64/)，安装修改：`x86_64`、`posix`。添加环境变量：找到 `mingw-w64.bat`，里面有变量地址（但运行该文件不能添加，所以要手动添加）。把`mingw32-make.exe`复制一份改为`make.exe`

3. #### 测试HelloWord程序

   ```cpp
   #test.cpp文件
   #include <stdio.h>
   int main()
   {
       printf("hello\n");
       return 0;
   }
   ```

   ```cmake
   #CMakeLists.txt文件
   cmake_minimum_required(VERSION 3.0)
   project(Hello)
   set(SOURCE test.cpp)
   add_executable(${PROJECT_NAME} ${SOURCE})
   ```

   ```powershell
   #编译运行
   mkdir build
   cd build
   cmake -G"Unix Makefiles" ../ -DCMAKE_BUILD_TYPE=Release
   make
   .\Hello.exe
   ```

4. #### 安装CLion

   

5. #### 编译OpenCV

   [参考](https://blog.csdn.net/u010798503/article/details/88065863)，注意不要安装Python2（或者换成Python3）

6. 