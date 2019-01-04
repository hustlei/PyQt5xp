@echo off
echo "本脚本仅编译PyQt5运行发布需要的模块，不变异sip.exe和sip.h"

echo "start configure..."
python configure.py --sip-module=PyQt5.sip --no-tools ^
	-p win32-msvc --target-py-version 2.7 ^
	-d "dist\Lib\site-packages" --pyidir "dist\Lib\site-packages" 

echo.
echo "press any key to start build..."
pause > nul
echo "load nmake"
call "C:\Program Files\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
rem "C:\Program Files\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
cd /d %~dp0
nmake
nmake install
echo.
echo "build successfully"
echo "see the deploy sip.pyd in the dir dist"
pause>nul
exit