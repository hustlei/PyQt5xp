---
layout: post
title: qt dll动态链接库搜索路径
category: Qt
group: IT
tags: [Qt]
keywords:[Qt]
description: qt dll动态链接库搜索路径

author: lileilei
revision:
    editor: lileilei
    date: 2018-11-10
---

编译好的qt应用程序，或者pyqt代码，在自己电脑上运行很好，换台电脑就经常会出现找不到dll，或者出现“could not find or load the Qt platform plugin windows”错误，这都是因为找不到需要qt库dll文件，插件等。经过几天的折腾终于大致搞明白了是怎么回事。


# qt应用程序搜索dll的方式

## qt的dll链接库等文件分为两种

+ 第1种：程序启动的时候就要加载的（比如Qt5Core.dll等）
+ 第2种：程序启动后，在需要的时候动态加载的（比如Qt Plugins等）

## qt静态加载dll 路径搜索方式

第1种(程序启动的时候就要加载的)qt dll从应用程序所在目录和path环境变量路径搜索。

## qt动态加载plugins dll 路径搜索方式

第2种(程序启动后在需要的时候动态加载的)，主要是plugins dll, 程序会遍历这个个字符串列表`QStringList QCoreApplication::libraryPaths()`，从列表内路径搜索插件或动态库。

QCoreApplication::libraryPaths()怎么来的呢，看源代码可以知道，她依次加入了如下内容：

1.  
将 QLibraryInfo::location(QLibraryInfo::PluginsPath) 路径加入
2.  确保将应用程序本身所在路径QCoreApplication::applicationFilePath()加入

3.  将QT_PLUGIN_PATH 环境变量指定的路径依次加入

可是QLibraryInfo::location(QLibraryInfo::PluginsPath) 又是怎么来的呢？它受两方面影响：

+ 如果有符合条件的 qt.conf 文件，将使用该文件的内容
+ 如果没有这样的 qt.conf 文件，将使用编译Qt时写死的内容

写死的内容通常就是直接安装Qt的目录，不能用于发布自己的软件。所以可以通过自定义conf 文件修改Qt 提供的一些变量。qt.conf文件格式如下：

[Paths]
Prefix = .
Plugins= plugins

Prefix指Qt目录，目录下通常有bin和plugins两个目录，分别放第1种库和plugins。

那么qt.conf应该放在什么位置呢？软件通常会在以下三个路径查找conf文件：

1. 软件先会在qrc资源文件中寻找:/qt/etc/qt.conf（使用资源系统时）
2. MAC OS X中， 在应用程序目录下的 Resource目录。 
3. 应用程序可执行文件所在目录，也就是QCoreApplication::applicationDirPath() + QDir::separator() + "qt.conf"

所以要指定第2种动态库（plugins等）的位置，可以使用下边几种方式：

1. 直接使用QCoreApplication::addLibraryPath()或QCoreApplication::setLibraryPaths()修改QCoreApplication::libraryPaths
2. 编写qt.conf配置文件，放在应用程序启动目录或者系统资源文件内
3. 设置QT_PLUGIN_PATH环境变量

# pyqt查找qt dll方法

对于PyQt应用程序qt.conf理论上应该放在python.exe相同的目录下。但是我从来没有成功过，所以为了简单，建议使用QCoreApplication.addLibraryPath()或者设置QT_PLUGIN_PATH环境变量

我在自己编译的pyqt5中就用addlibrarypath方法添加qt dll路径。方法如下：

+ 把所有依赖的qt dll放在bin文件夹内
+ 把所有plugin dll放在plugins文件夹内
+ 把bin和plugins文件夹放到pyqt5 python库文件夹下
+ 在pyqt5库的__init__.py尾部添加如下代码

```
import os
dir=os.path.join(os.path.dirname(__file__),'bin;')
os.environ['path']=dir+os.environ['path']

from PyQt5.QtWidgets import QApplication
QApplication.addLibraryPath(os.path.join(os.path.dirname(__file__),"plugins"));
```

这样在导入pyqt5库时，都会执行__init__.py，也就是说在调用pyqt5前都会先执行上述代码，设置好qt dll搜索路径。

# C++ qt应用程序查找qt dll方法

如果是c++编写的qt应用程序，可以使用windeployqt.exe自动查找依赖。假如编写的程序为bin\myapp.exe，则用如下命令自动查找依赖的qt dll。

``` bat
windeployqt.exe bin\myapp.exe --release --force --compiler-runtime -libdir bin -dir bin\plugins
```

+ 第1种文件(程序启动的时候就要加载的dll)会放到bin目录下
+ 第2种文件(程序启动后在需要的时候动态加载的dll)会放到bin\plugins目录下

# 参考文章

+ <https://stackoverflow.com/questions/28298507/qt-qcoreapplication-addlibrarypath-use>
+ <https://blog.csdn.net/dbzhang800/article/details/6543489>