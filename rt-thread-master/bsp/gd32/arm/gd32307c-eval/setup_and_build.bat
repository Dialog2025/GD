@echo off
echo ===== 配置pip镜像源 =====
if not exist "%USERPROFILE%\.pip" mkdir "%USERPROFILE%\.pip"

echo [global] > "%USERPROFILE%\.pip\pip.ini"
echo index-url = https://pypi.tuna.tsinghua.edu.cn/simple/ >> "%USERPROFILE%\.pip\pip.ini"
echo trusted-host = pypi.tuna.tsinghua.edu.cn >> "%USERPROFILE%\.pip\pip.ini"
echo [install] >> "%USERPROFILE%\.pip\pip.ini"
echo trusted-host = pypi.tuna.tsinghua.edu.cn >> "%USERPROFILE%\.pip\pip.ini"

echo pip配置文件已创建：
type "%USERPROFILE%\.pip\pip.ini"

echo.
echo ===== 安装SCons =====
pip install --index-url https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn --trusted-host pypi.org --trusted-host files.pythonhosted.org scons

echo.
echo ===== 验证安装 =====
scons --version
if %ERRORLEVEL% EQU 0 (
    echo SCons安装成功！
) else (
    echo SCons安装失败，尝试使用RT-Thread内置工具...
    python ..\..\..\..\tools\building.py --help
)

echo.
echo ===== 尝试构建项目 =====
if exist "SConstruct" (
    echo 使用SCons构建...
    scons
) else (
    echo 使用RT-Thread工具构建...
    python ..\..\..\..\tools\building.py
)

pause