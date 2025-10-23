# GD32F503V-EVAL BSP ARM Compiler 6 兼容性修复

## 问题描述
在使用Keil MDK与ARM Compiler 6编译GD32F503V-EVAL BSP时，出现以下错误：
```
ArmClang: error: unsupported option '--c99'
```

## 根本原因
1. **DFS组件配置问题**：RT-Thread的DFS组件在`components/dfs/dfs_v1/SConscript`中，对所有`armcc`平台添加了`--c99`选项，但这个选项只适用于ARM Compiler 5。
2. **MDK项目生成问题**：当编译器标志中包含c99相关选项时，RT-Thread的MDK生成工具会自动设置`uC99=1`或`uC99=2`，导致Keil在编译时传递不兼容的c99选项给ARM Compiler 6。

## 解决方案

### 1. 修复DFS组件SConscript
**文件**: `components/dfs/dfs_v1/SConscript`

**修改前**:
```python
elif rtconfig.PLATFORM in ['armcc']:
    LOCAL_CFLAGS += ' --c99'
```

**修改后**:
```python
elif rtconfig.PLATFORM in ['armcc']:
    # Check for ARM Compiler version - only use --c99 for Compiler 5
    if rtconfig.CC == 'armcc':
        LOCAL_CFLAGS += ' --c99'
    # ARM Compiler 6 (armclang) doesn't need --c99 option
```

### 2. 修复MDK项目文件uC99设置
将项目文件中所有的`<uC99>2</uC99>`替换为`<uC99>0</uC99>`：
```powershell
(Get-Content project.uvprojx) -replace '<uC99>2</uC99>', '<uC99>0</uC99>' | Set-Content project.uvprojx
```

### 3. 确保MiscControls清空
确保所有`<MiscControls></MiscControls>`标签为空，不包含任何c99相关选项。

## ARM Compiler 版本识别

### ARM Compiler 5 (传统armcc)
- 编译器: `armcc`
- 汇编器: `armasm`
- 链接器: `armlink`
- C99选项: `--c99`

### ARM Compiler 6 (基于LLVM的armclang)
- 编译器: `armclang`
- 汇编器: `armasm`
- 链接器: `armlink`
- C99选项: 默认支持C99，无需额外选项

## 配置说明

### rtconfig.py配置
```python
elif PLATFORM == 'armcc':
    # toolchains
    CC = 'armclang'    # 使用ARM Compiler 6
    CXX = 'armclang'
    AS = 'armasm'
    AR = 'armar'
    LINK = 'armlink'
    TARGET_EXT = 'axf'

    DEVICE = ' --target=arm-arm-none-eabi -mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb '
    CFLAGS = '-c ' + DEVICE + ' -fno-rtti -funsigned-char -fshort-enums -fshort-wchar -ffunction-sections -fdata-sections'
    # 注意：CFLAGS中不包含任何c99相关选项
```

### 项目文件配置
```xml
<!-- ARM Compiler 6 配置 -->
<uAC6>1</uAC6>              <!-- 启用ARM Compiler 6 -->
<uC99>0</uC99>              <!-- 使用C90模式，不传递--c99选项 -->
<MiscControls></MiscControls> <!-- 清空额外编译选项 -->
```

## 验证步骤
1. 在Keil MDK中打开`project.uvprojx`
2. 确认编译器设置为ARM Compiler 6
3. 编译项目，应该不再出现`--c99`错误
4. 验证编译成功并生成rtthread.axf文件

## 相关文件
- `components/dfs/dfs_v1/SConscript` - DFS组件配置修复
- `project.uvprojx` - MDK项目文件
- `rtconfig.py` - 编译器配置文件
- `template.uvprojx` - MDK项目模板文件

## 影响范围
此修复影响所有使用ARM Compiler 6的RT-Thread GD32 BSP项目。建议在其他GD32系列BSP中应用相同的修复。