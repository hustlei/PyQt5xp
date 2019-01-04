:: author: lileilei
:: website: hustlei.github.io
@echo off
echo "使用前请先修改本脚本中MSVC安装位置."
echo "如果已修改，请点击任意键继续.."
pause>nul
echo "start configure..."
python configure.py -p win32-msvc --sip-module=PyQt5.sip ^
    --target-py-version 2.7 -b "out" -e "out\include" ^
    -d "out\Lib\site-packages" -v "out\sip" ^
    --pyidir="out\Lib\site-packages"
    
echo.
echo "press any key to start build..."
pause > nul
echo "load nmake"
rem "C:\Program Files\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86
call "C:\Program Files\Microsoft Visual Studio 12.0\VC\bin\vcvars32.bat"
cd /d %~dp0
echo "build..."
nmake
nmake install

echo.
echo "build successfully"
echo "see the result in the dir out"
pause>nul
exit