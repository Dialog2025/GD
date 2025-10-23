# RT-Thread 构建环境配置指南

## 重要说明
请在 **RT-Thread Env Tool (ConEmu)** 终端中执行以下命令，不要在普通的PowerShell中执行！

## 步骤1：确认环境
确保您的终端显示如下提示符：
```
(.venv) zhiwei.zhang@HFGY11001062 D:\software\env-windows-v2.0.0\env-windows
$
```

## 步骤2：配置pip镜像源
```bash
# 创建pip配置目录
mkdir %USERPROFILE%\.pip

# 创建pip配置文件
echo [global] > %USERPROFILE%\.pip\pip.ini
echo index-url = https://pypi.tuna.tsinghua.edu.cn/simple/ >> %USERPROFILE%\.pip\pip.ini
echo trusted-host = pypi.tuna.tsinghua.edu.cn >> %USERPROFILE%\.pip\pip.ini

# 验证配置
type %USERPROFILE%\.pip\pip.ini
```

## 步骤3：安装SCons
```bash
# 使用国内镜像源安装SCons
pip install --index-url https://pypi.tuna.tsinghua.edu.cn/simple/ --trusted-host pypi.tuna.tsinghua.edu.cn --trusted-host pypi.org --trusted-host files.pythonhosted.org scons

# 验证安装
scons --version
```

## 步骤4：构建RT-Thread项目
```bash
# 进入项目目录
cd /d D:\code\rt-thread-master\bsp\gd32\arm\gd32307c-eval

# 使用SCons构建（如果安装成功）
scons

# 或者使用RT-Thread内置工具（推荐）
python ..\..\..\..\tools\building.py
```

## 步骤5：如果pip安装仍有问题
```bash
# 尝试离线安装SCons（需要先下载wheel文件）
pip install --no-index --find-links . scons-4.5.2-py3-none-any.whl

# 或者直接使用RT-Thread内置构建系统
python ..\..\..\..\tools\building.py
```

## 注意事项
1. 必须在RT-Thread Env Tool环境中操作，提示符应显示 (.venv)
2. 如果SSL问题持续，可以完全跳过SCons，直接使用 python tools/building.py
3. 构建成功后会生成 rtthread.bin 文件