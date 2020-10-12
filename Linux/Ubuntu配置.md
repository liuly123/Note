---
title: Ubuntu配置
author: liuly
date: 2020-03-06 16:48:14

categories:
- Linux
typora-root-url: ../..
---
#### 安装Typora

地址https://support.typora.io/Typora-on-Linux/

```sh
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo apt-get update
sudo apt-get install typora
```

另一款remarkable

#### 美化

[链接](https://blog.csdn.net/seniusen/article/details/79815107)

#### SSR

[教程](https://github.com/qingshuisiyuan/electron-ssr-backup)

#### 安装搜狗拼音

地址https://pinyin.sogou.com/linux/

不要从系统设置里修改，在任务栏上修改

#### 设置rtc时间

```sh
timedatectl set-local-rtc true
```

#### 安装CLion

[教程](https://blog.csdn.net/u010925447/article/details/73251780)，[下载地址](https://www.jetbrains.com/clion/download/#section=linux)

账号：2240057686@qq.com

密码：IJndwerfwertynyuzxfbn

[汉化](https://github.com/pingfangx/jetbrains-in-chinese/tree/master/CLion)

**修改字体：**设置>编辑器>切换配色方案>Color Scheme Font>备用字体>SimSun(已经安装windows字体)。（其他的备用字体最好也换，如Console Font）

**远程调试：**

![image-20200310101158919](/images/Ubuntu配置/image-20200310101158919.png)

**乱码问题：**帮助->编辑自定义VM选项，添加

```ini
-Dconsole.encoding=UTF-8
-Dfile.encoding=UTF-8
```

#### 添加设备文件读写权限

```sh
sudo usermod -a -G dialout $USER
sudo chmod a+rw /dev/ttyUSB0
```

#### 安装wps

下载地址http://linux.wps.cn/

#### 安装录屏软件

```sh
sudo add-apt-repository ppa:maarten-baert/simplescreenrecorder
sudo apt update
sudo apt install simplescreenrecorder
```

#### 安装chrome

```sh
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt-get update 
sudo apt-get install google-chrome-stable
```

或者直接[下载](https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
)

#### 安装中国版火狐

[下载](http://www.firefox.com.cn/download/)，解压

```sh
sudo apt remove firefox
sudo mv firefox /opt #firefox是解压得到的文件夹
cd /usr/share/applications
sudo gedit firefox.desktop
```

内容为

```ini
[Desktop Entry]
Name=firefox
Name[zh_CN]=火狐浏览器
Comment=火狐浏览器
Exec=/opt/firefox/firefox
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Appliction;
Encoding=UTF-8
StartupNotify=true
```

#### 状态栏网速

```sh
sudo add-apt-repository ppa:fossfreedom/indicator-sysmonitor
sudo apt-get update
sudo apt-get install indicator-sysmonitor
indicator-sysmonitor &
#设置开机启动
```

#### Understand代码分析

https://scitools.com/download/all-builds/

**添加环境变量**

```sh
export PATH="$PATH:/home/liuly/snap/scitools/bin/linux64"
```

**输入license**

enter liscense > option > use lagacy licensing > 输入09E58CD1FB79

**添加快捷方式**

```sh
[Desktop Entry]
Name=understand
Type=Application
Comment=scitools understand
Icon=/home/liuly/snap/scitools/bin/linux64/understand_64.png
Exec=/home/liuly/snap/scitools/bin/linux64/understand %F
Terminal=false
Categories=Development;
```

#### 安装VScode

https://code.visualstudio.com/Download

**设置中文**

商店搜索Chinese，安装`适用于 VS Code 的中文（简体）语言包`，并设置`locale.json`

**扩展**

`C/C++` `Python` `ROS`

#### RoboWare

https://github.com/TonyRobotics/RoboWare/tree/master/Studio

#### 修改grub主题

https://blog.csdn.net/w84963568/article/details/78884003

#### 安装字体

字体[参考](https://www.cnblogs.com/Dylansuns/p/7648002.html)，还有time和simhei

```sh
cd /usr/share/fonts/winfonts
cp ~/msyh.ttf ./
sudo chmod 644 *
sudo mkfontscale #创建雅黑字体的fonts.scale文件，它用来控制字体旋转缩放
sudo mkfontdir #创建雅黑字体的fonts.dir文件，它用来控制字体粗斜体产生
sudo fc-cache -fv #建立字体缓存信息，也就是让系统认识雅黑
```

#### 终端分屏

```bash
sudo apt install terminator
```

使用

```
Ctrl+Shift+E    垂直分割窗口
Ctrl+Shift+O    水平分割窗口
    F11         全屏
Ctrl+Shift+C    复制
Ctrl+Shift+V    粘贴
Ctrl+Shift+N    或者 Ctrl+Tab 在分割的各窗口之间切换
Ctrl+Shift+X    将分割的某一个窗口放大至全屏使用
Ctrl+Shift+Z    从放大至全屏的某一窗口回到多窗格界面
```

#### 双系统蓝牙鼠标

https://www.jianshu.com/p/56f6b0dc231e

#### 批量修改文件夹/文件权限

```sh
#当前目录下及递归
find -type d|xargs chmod 755
find -type f|xargs chmod 664
```

#### 源码安装cmake

[下载](https://cmake.org/download/)

```sh
#编译安装，不要卸载原来的
tar -xzvf cmake-3.14.5.tar.gz
cd cmake-3.14.5
./bootstrap
make
sudo make install
```

#### 安装rtk8811cu驱动

```sh
git clone https://github.com/whitebatman2/rtl8821CU
cd rtl8821CU
make
sudo make install
sudo modprobe 8821cu
```

#### 修改ROS源

```sh
sudo sh -c 'echo "deb http://mirrors.ustc.edu.cn/ros/ubuntu/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -
```

#### 蓝牙断开不重连

```sh
bluetoothctl
trust 70:F0:87:23:FB:F4 #信任设备
```

####  设置pac

```sh
#生成pac文件
sudo apt-get install python-pip
sudo pip install genpac
genpac -p "SOCKS5 127.0.0.1:10808" --gfwlist-proxy="SOCKS5 127.0.0.1:10808" --gfwlist-url=https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt --output="autoproxy.pac"
#赋值pac文件到/etc/v2ray
```

```sh
sudo apt-get install nginx
sudo nano /etc/nginx/nginx.conf
```

```nginx
#在http{...}中添加内容
server
{
    listen 80;
    server_name 127.0.0.1;
    location /autoproxy.pac
    {
        alias /etc/v2ray/autoproxy.pac;
    }
}
```

```
#然后执行：
sudo /etc/init.d/nginx restart
#设置系统自动代理地址：
http://127.0.0.1/autoproxy.pac
```

#### 安装gcc、g++

```sh
sudo pip install genpac
```

#### cmake卸载

```sh
cat install_manifest.txt | sudo xargs rm
```

