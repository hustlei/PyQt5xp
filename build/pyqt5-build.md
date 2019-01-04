---
layout: post
title: 编译支持winxp的PyQt5
category: python
group: IT
tags: [pyqt5]
keywords:[python, pyqt5]
description: 让pyqt5支持windows xp

author: lileilei
revision:
    editor: lileilei
    date: 2018-11-10
---


为了在xp上使用pyqt，折腾了一大圈。

+ Windows xp 不能运行python3.5及以上版本python。
+ Windows xp 不能运行qt5.7及以上版本qt。
+ Pyqt5官方预编译二进制文件不能在xp上运行。

+ Windows xp 能运行的最高版本的python版本为：python3.4和python2.7
+ Windows xp 上能运行的最高版本的qt为qt5.6.3

编译PyQt5，需要PyQt5源码、PyQt5-sip，python、qt以及c++编译器。windows上C++编译器可以选择msvc或MinGW。

本文选择下列版本文件编译pyqt5

+ python2.7
+ qt5.6.3 32bit
+ msvc2013
+ PyQt5_gpl-5.11.3源码
+ PyQt5-sip-4.19.13源码

> 因为python2.7比python3.4支持的库更多，所以使用python2.7编译pyqt5。
>
> 因为2018年qt5.6.3 msvc版只有msvc 2013，msvc 2015编译版，所以使用msvc2013。


# 软件环境准备

编译pyqt5，需要下载

1. pyqt5源码[[下载]](https://riverbankcomputing.com/software/pyqt/download5)
2. pyqt5-sip源码[[下载]](https://www.riverbankcomputing.com/software/sip/download)(pyqt5需要使用sip编译)
3. Qt5[[下载]](http://download.qt.io/official_releases/qt/)
4. Visual Studio[[下载]](https://msdn.itellyou.cn/)（也可以使用MinGW，pyqt官方也是用vs，所以建议使用vs）
5. python2.7[[下载]](https://www.python.org/downloads/windows/)（必须有python才能编译）

## python2.7

感觉python2.7的库比python3.4的库更多，比如Pythonocc就没有python3.4版本的，所以，我选择了python2.7 32bit，下载地址如下：

[https://www.python.org/downloads/release/python-2715/](https://www.python.org/downloads/release/python-2715/)。

## Qt5

Qt5可以使用msvc编译器和mingw编译器，而msvc的编译器从2015开始就对xp的支持变差，就算通过各种编译配置命令设置，能xp下运行，但是会很可能发生一些奇奇怪怪的bug。而mingw编译器没有这个问题，同一个版本可以在xp win7 win10各个系统使用，而无需其他配置。
另外，Qt5目前有两个长期支持版本（Long Term Support）Qt5.6和Qt5.9，Qt5.6可以在XP和win7及以上系统开发，而Qt5.9只支持win7以上的系统开发和部署。 所以如果想使用Qt5的新功能，又想开发出的软件能在xp系统上运行，可以选择Qt5.6的mingw-32bit版本或者vs2013版本进行开发。

1. Qt从5.7版本开始不再支持WinXP系统，即编译生成的exe文件无法在WinXP系统运行。
2. Qt5.6是长期支持版本Long Term Support，它可以支持WinXP-32bit的系统。

参考：http://doc.qt.io/qt-5.6/supported-platforms.html

下载网站是：

+ http://download.qt.io/official_releases/qt/
+ http://download.qt.io/archive/qt

请注意，这几个版本是完全ok的：

+ qt-opensource-windows-x86-msvc2013_64-5.6.3.exe
+ qt-opensource-windows-x86-msvc2013-5.6.3.exe
+ qt-opensource-windows-x86-mingw492-5.6.3.exe

vs2015编译出来的版本是不ok的，在WinXP环境下，会出现字体乱码（含删除线）的问题。

所以qt选择5.6.3版本。

## Visual Studio

需要安装和qt版本相同的visual Studio。所以我使用vs2013。

下载地址：https://msdn.itellyou.cn/

## pyqt5 和 pyqt5-sip源码

虽然qt版本比较低，但是仍然可以使用最新版本的PyQt5和pyqt5-sip源码。但是我在编译的时候遇到了下边的问题，编译的时候禁止QtNfc就可以了

>> QAEXABVQNdefRecord@@@Z) 已经在 sipQtNfcQList0100QNdefRecord.obj 中定义
>> 正在创建库 release\QtNfc.lib 和对象 release\QtNfc.exp
>> release\QtNfc.dll : fatal error LNK1169: 找到一个或多个多重定义的符号

所以我下载了：

+ PyQt5_gpl-5.11.3.zip
+ sip-4.19.13.zip

## 安装

1. 安装python2.7
2. 安装vs2013
3. 安装qt5.6.3
4. 解压PyQt5_gpl-5.11.3.zip到PyQt5_gpl-5.11.3文件夹
5. 解压sip-4.19.13.zip到sip-4.19.13文件夹

# 编译安装sip：

1. 进入VS2013环境
    + 在开始菜单中运行VS2013 x86 本机工具命令提示
    + 也可以在cmd中执行命令： "D:\Program\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
    + 也可以直接在cmd中执行： "C:\Program Files\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
2. 进入sip目录
    + cd sip-4.19.13
3. 编译sip
    + 配置编译参数：python configure.py --sip-module PyQt5.sip  -b "out" -d "out\Lib\site-packages" -e "out\include" -v "out\sip" --target-py-version 2.7
        - 切记一定要有--sip-module PyQt5选项，否则即使编译完全没有错误，最后运行也会出现“ValueError: PyCapsule_GetPointer called with invalid PyCapsule object”错误
    + 编译：nmake
    + 将编译后得到的文件安装到out目录下：nmake install
    + 在这个阶段我们得到了sip.exe和sip.h，这两个文件仅用于编译PyQt5，PyQt5运行时不需要。
    + 在这个阶段我们得到了sip.pyd文件，这个文件是PyQt5编译后运行需要的文件，将这个文件复制到Python27\Lib\sitepackages\PyQt5目录下就ok了。

    
# 编译PyQt5
        
1. 进入Qt环境
    + 在开始菜单中运行Qt 5.6.3 32-bit for Desktop (MSVC 2013)。
    + 相当于直接在cmd中运行 "C:\Qt\Qt5.6.3\5.6.3\msvc2013\bin\qtenv2.bat"
2. 进入VS2013环境
    + 在cmd中执行命令： "D:\Program\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
3. 进入pyqt5源码目录
    + cd PyQt5_gpl-5.11.3
4. 编译PyQt5
    + 配置编译参数：python configure.py --sip-incdir=out\include --sip=out\sip.exe  --qmake=C:\Qt\Qt5.6.3\5.6.3\msvc2013\bin\qmake.exe  --no-sip-files --disable=QtNfc
        - 为了加快编译速度我还禁止了很多其他模块：--disable=QtAndroidExtras --disable=QtDBus --disable=QtSensors --disable=QtSerialPort --disable=QtQml --disable=QtQuick --disable=QtBluetooth --disable=QtPositioning --disable=QtLocation 
    + 编译：nmake（时间比较长）
    + 安装到python：nmake install
        - 将会直接安装到python27/Lib/site-packages/PyQt5目录下，可以使用pip卸载。
4. 配置PyQt5运行环境
    PyQt5还需要Qt5的dll文件以及插件文件夹，有两种方法
    
    1. 直接把C:\Qt\Qt5.6.3\5.6.3\msvc2013\bin目录添加到path环境变量
    2. 把C:\Qt\Qt5.6.3\5.6.3\msvc2013\目录下的bin文件夹和plugins文件夹复制到python27/Lib/site-packages/PyQt5目录下，然后编辑PyQt5目录下__init__.py文件，添加如下代码：

```
import os
dir=os.path.join(os.path.dirname(__file__),'bin;')
os.environ['path']=dir+os.environ['path']

from PyQt5.QtWidgets import QApplication
QApplication.addLibraryPath(os.path.join(os.path.dirname(__file__),"plugins"));
```

注：使用vs2013编译的pyqt5,依赖VC12运行库，所以不要忘记msvcr120.dll和msvcp120.dll


32bit python2.7 版pyqt5编译安装成功，enjoy it!