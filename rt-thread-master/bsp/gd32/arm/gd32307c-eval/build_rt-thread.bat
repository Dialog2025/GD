@echo off
echo ===============================================================================
echo RT-Thread Build Script for GD32307C-EVAL
echo ===============================================================================
echo.
echo This script will attempt to build the RT-Thread project for GD32307C-EVAL.
echo.
echo IMPORTANT: You need to have one of the following toolchains installed:
echo   1. ARM GCC Toolchain (arm-none-eabi-gcc)
echo   2. Keil MDK (armcc)
echo   3. IAR EWARM (iccarm)
echo.
echo If you have ARM GCC installed, set RTT_EXEC_PATH to the toolchain bin directory:
echo   Example: set RTT_EXEC_PATH=C:\Program Files (x86)\GNU Arm Embedded Toolchain\bin
echo.
echo If you have Keil MDK installed, set RTT_CC=keil and RTT_EXEC_PATH:
echo   Example: set RTT_CC=keil
echo   Example: set RTT_EXEC_PATH=C:\Keil_v5\ARM\ARMCC\bin
echo.
echo Current settings:
echo   RTT_ROOT=%RTT_ROOT%
echo   RTT_CC=%RTT_CC%
echo   RTT_EXEC_PATH=%RTT_EXEC_PATH%
echo.

REM Set default RT-Thread root directory
if "%RTT_ROOT%"=="" set RTT_ROOT=d:\code\rt-thread-master

echo Setting RTT_ROOT to: %RTT_ROOT%
echo.

echo Running scons to check project configuration...
scons --help > nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo SUCCESS: scons command is working correctly!
    echo.
    echo You can now run one of the following commands:
    echo   scons --target=mdk5    ^(Generate Keil MDK5 project^)
    echo   scons --target=iar     ^(Generate IAR project^)
    echo   scons -n               ^(Dry run to see build commands^)
    echo   scons                  ^(Build if toolchain is available^)
) else (
    echo ERROR: scons command failed. Please check your Python and scons installation.
)
echo.
echo ===============================================================================