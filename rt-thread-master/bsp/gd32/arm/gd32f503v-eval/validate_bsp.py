#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
GD32F503V-EVAL BSP 配置验证脚本
验证BSP的基本配置是否正确
"""

import os
import sys

def check_file_exists(file_path, description):
    """检查文件是否存在"""
    if os.path.exists(file_path):
        print(f"✅ {description}: {file_path}")
        return True
    else:
        print(f"❌ {description}: {file_path} (不存在)")
        return False

def check_directory_exists(dir_path, description):
    """检查目录是否存在"""
    if os.path.isdir(dir_path):
        print(f"✅ {description}: {dir_path}")
        return True
    else:
        print(f"❌ {description}: {dir_path} (不存在)")
        return False

def validate_bsp_structure():
    """验证BSP目录结构"""
    print("=" * 60)
    print("GD32F503V-EVAL BSP 配置验证")
    print("=" * 60)
    
    current_dir = os.getcwd()
    print(f"当前目录: {current_dir}")
    
    # 检查基础文件
    basic_files = [
        ("rtconfig.py", "编译器配置文件"),
        ("rtconfig.h", "RT-Thread配置头文件"),
        ("SConscript", "构建脚本"),
        ("SConstruct", "构建控制文件"),
        ("Kconfig", "配置管理文件"),
        (".config", "当前配置文件"),
        ("README.md", "说明文档"),
    ]
    
    print("\n📁 基础文件检查:")
    basic_ok = True
    for filename, desc in basic_files:
        if not check_file_exists(filename, desc):
            basic_ok = False
    
    # 检查目录结构
    directories = [
        ("applications", "应用程序目录"),
        ("board", "板级配置目录"),
        ("packages", "固件库目录"),
        ("libraries", "驱动库目录"),
        ("board/linker_scripts", "链接脚本目录"),
        ("packages/gd32-arm-cmsis-latest/GD32F50x", "CMSIS库"),
        ("packages/gd32-arm-series-latest/GD32F50x", "标准外设库"),
    ]
    
    print("\n📂 目录结构检查:")
    dir_ok = True
    for dirname, desc in directories:
        if not check_directory_exists(dirname, desc):
            dir_ok = False
    
    # 检查关键驱动文件
    key_files = [
        ("applications/main.c", "主程序文件"),
        ("board/board.c", "板级初始化文件"),
        ("board/board.h", "板级头文件"),
        ("board/linker_scripts/link.ld", "GCC链接脚本"),
        ("board/linker_scripts/link.sct", "Keil链接脚本"),
        ("board/linker_scripts/link.icf", "IAR链接脚本"),
        ("libraries/gd32_drivers/drv_usart.c", "UART驱动"),
        ("libraries/gd32_drivers/drv_gpio.c", "GPIO驱动"),
    ]
    
    print("\n🔧 关键文件检查:")
    key_ok = True
    for filename, desc in key_files:
        if not check_file_exists(filename, desc):
            key_ok = False
    
    # 检查rtconfig.py中的关键配置
    print("\n⚙️  配置文件内容检查:")
    try:
        with open('rtconfig.py', 'r', encoding='utf-8') as f:
            rtconfig_content = f.read()
            
        configs_to_check = [
            ("CPU='cortex-m33'", "Cortex-M33内核配置"),
            ("DGD32F50x", "GD32F50x芯片宏定义"),
            ("mfpu=fpv5-sp-d16", "FPU配置"),
        ]
        
        for config, desc in configs_to_check:
            if config in rtconfig_content:
                print(f"✅ {desc}: 已配置")
            else:
                print(f"❌ {desc}: 未找到配置")
                key_ok = False
                
    except Exception as e:
        print(f"❌ 读取rtconfig.py失败: {e}")
        key_ok = False
    
    # 检查链接脚本中的内存配置
    print("\n💾 内存配置检查:")
    try:
        with open('board/linker_scripts/link.ld', 'r', encoding='utf-8') as f:
            linker_content = f.read()
            
        memory_configs = [
            ("LENGTH = 512K", "Flash大小512KB"),
            ("LENGTH = 192K", "SRAM大小192KB"),
            ("ORIGIN = 0x08000000", "Flash起始地址"),
            ("ORIGIN = 0x20000000", "SRAM起始地址"),
        ]
        
        for config, desc in memory_configs:
            if config in linker_content:
                print(f"✅ {desc}: 已正确配置")
            else:
                print(f"❌ {desc}: 配置可能有误")
                
    except Exception as e:
        print(f"❌ 读取链接脚本失败: {e}")
    
    # 总结
    print("\n" + "=" * 60)
    if basic_ok and dir_ok and key_ok:
        print("🎉 BSP配置验证通过！")
        print("📋 下一步:")
        print("   1. 安装ARM交叉编译工具链 (arm-none-eabi-gcc)")
        print("   2. 安装scons构建工具: pip install scons")
        print("   3. 设置RTT_ROOT环境变量")
        print("   4. 运行scons进行编译")
        return True
    else:
        print("❌ BSP配置存在问题，请检查上述错误")
        return False

if __name__ == "__main__":
    validate_bsp_structure()