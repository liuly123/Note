1. 下载安装1.88版

   [地址](https://www.arduino.cc/en/Main/Software?setlang=cn)

2. 添加开发板

   [github地址](https://github.com/esp8266/esp8266.github.io/tree/master/stable)，[json地址](https://raw.githubusercontent.com/esp8266/esp8266.github.io/master/stable/package_esp8266com_index.json)。

   在`文件>首选项>附加开发板管理器`里添加json地址

   在`工具>开发板管理`中添加esp8266开发板，安装2.5.2版

   选择开发板ESP-12E

3. 安装VS Code

   安装插件Arduino（微软开发）

   点Arduino扩展的齿轮>设置Arduino ：Path为`C:\Program Files (x86)\Arduino`

4. 打开空文件夹

   创建`.ino`文件（文件名和文件夹相同）

   在下面状态栏设置：`AVRISP.mkll`、`ModeMCU1.0`、`COM4`
   右上Upload