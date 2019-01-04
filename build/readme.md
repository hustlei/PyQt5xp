本目录下文件使用方法说明如下：

+ pyqt5-build.md: 自行编译pyqt5的参考步骤
+ qt加载dll路径.md：发布pyqt5配置原理说明，有兴趣可以参考
+ pyqt5-sip.bat, build-pyqt5.bat：编译pyqt5的脚本，参考本文使用


# 手动编译pyqt5方法

如果要自行编译pyqt5, 可以参考build目录下[pyqt5-build.md](build/pyqt5-build.md)。

# 使用bat脚本编译pyqt5的方法

编译前请确认已安装好msvc, qt, python。

1. 把pyqt5源码和pyqt5-sip源码分别解压在pyqt5-xx，sip-xx文件夹下。
2. 编译sip
    1. 把本项目build目录下build-sip.bat复制到sip-xx文件夹下。
    2. 修改build-sip.bat中msvc安装路径
    3. 双击执行build-sip.bat。
3. 编译pyqt5
    1. 把本项目build目录下build-pyqt5.bat复制到pyqt5-xx文件夹下。
    2. 修改build-pyqt5.bat中qt安装路径、msvc安装路径以及sip-xx文件夹名称。
    3. 双击执行build-pyqt5.bat
4. 发布pyqt5
    1. 把C:\Qt\Qt5.x.x\5.x.x\msvc2013\目录下的bin文件夹和plugins文件夹复制到c:/python27/Lib/site-packages/PyQt5目录下
    2. 然后编辑PyQt5目录下__init__.py文件，添加如下代码：

    ```
    import os
    dir=os.path.join(os.path.dirname(__file__),'bin;')
    os.environ['path']=dir+os.environ['path']

    from PyQt5.QtWidgets import QApplication
    QApplication.addLibraryPath(os.path.join(os.path.dirname(__file__),"plugins"));
    ```