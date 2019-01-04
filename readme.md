本项目为已编译好的windows xp上能用的pyqt5。qt和python版本分别为：

+ qt5.6.3 32bit
+ python2.7

因为使用msvc2013编译的，所以依赖vc12的两个dll文件。

# PyQt5xp安装使用方法

copy all files in pyqt5-py27-qt5.6.3-win32-release to C:\Python27, PyQt5 can be run on xp, enjoy it!

把本项目`pyqt5-py27-qt5.6.3-win32-release`文件夹内所有文件复制到Python安装目录下，比如`C:\Python27`目录内，选择合并目录即可。

> 说明：本项目依赖vc12库，所以如果电脑上没有，请安装
>
>> 当然也可以把msvcr120.dll和msvcp120.dll直径复制到项目bin目录下

# 手动编译pyqt5方法

如果要自行编译pyqt5, 可以参考build目录下相关文件。