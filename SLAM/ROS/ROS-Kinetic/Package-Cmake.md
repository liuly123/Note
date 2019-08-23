### 1. package.xml

```xml
<buildtool_depend>
```

编译工具的依赖包，不需要改

```xml
<build_depend>
```

构建此包所需的包。在构建时需要来自这些包的任何文件时就是这种情况。
这可以在编译时include来自这些包的头文件，link来自这些包的库或在构建时需要的任何其他资源

```xml
<build_export_depend>
```

指定针对此包构建库所需的包。如果您将其标头可传递地包含在此程序包的公共标头中，则会出现这种情况
一般和`<build_depend>`一样

```xml
<exec_depend>
```

指定在此包中运行代码所需的包。当您依赖此包中的共享库时就是这种情况
一般和`<build_depend>`一样

所有包都至少有一个依赖项，一个构建工具依赖于catkin

---

可以将`<build_depend>`、`<build_export_depend>`、`<exec_depend>`用一个`<depend>`代替
不推荐用`<depend>`，因为它会强制您的包的二进制安装依赖于“开发”包，这通常不是必需或不可取的，`package.xml`的依赖项是在发布的时候有用，不用于编译

### 2. CmakeList.txt

`CMake`不了解`package.xml`依赖关系。要编译代码，`CMakeLists.txt`必须明确声明如何解析所有头和库引用

#### 2.1 查找包的依赖项

```xml
find_package(catkin REQUIRED COMPONENTS std_msgs rospy roscpp)
```

#### 2.2 include路径

仅当包的子目录包含用于编译程序的头时，才需要include参数

```xml
include_directories(include ${catkin_INCLUDE_DIRS})
```