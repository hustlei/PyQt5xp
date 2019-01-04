:: author: lileilei
:: website: hustlei.github.io

@echo off
echo "使用前请先修改本脚本中Qt安装位置及MSVC安装位置."
echo "如果已修改，请点击任意键继续.."
pause>nul
echo "load build environment..."
call "C:\Program Files\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
rem C:\Program Files\Microsoft Visual Studio 12.0\VC\bin\vcvar32.bat
call C:\Qt\Qt5.6.3\5.6.3\msvc2013\bin\qtenv2.bat
cd /d %~dp0
rem 执行qtenv2.bat会把当前路径转移到msvc2013
echo.
echo "press any key to config build var..."
pause>nul
echo "start config.."
python configure.py --target-py-version=2.7 --no-sip-files ^
    --sip-incdir=..\sip-4.19.13\out\include --sip=..\sip-4.19.13\out\sip.exe ^
    --qmake=C:\Qt\Qt5.6.3\5.6.3\msvc2013\bin\qmake.exe --disable=QtNfc
	
::--disable=QtAndroidExtras --disable=QtNfc 
rem --disable=QtDBus --disable=QtSensors --disable=QtSerialPort ^
rem --disable=QtQml --disable=QtQuick --disable=QtBluetooth ^
rem --disable=QtPositioning --disable=QtLocation

::--qtconf-prefix=DIR
::embed a qt.conf file in the QtCore module that has Prefix set to DIR
::因为通常dll都放在bin下，插件都放在plugins下，所以设置为..试试
:: -a, --qsci-api  always install the PyQt API file for QScintilla
:: PyQt5 API file for QScintilla  default install in QT_INSTALL_DATA/qsci

echo.
echo "press any key to start build..."
pause>nul
nmake

echo.
echo "press any key to install pyqt5..."
pause>nul
nmake install
echo "intall successfully"
pause>nul
