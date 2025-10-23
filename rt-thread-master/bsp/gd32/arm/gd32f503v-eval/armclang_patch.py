# Local SConscript patch for ARM Compiler 6 compatibility
# This file patches the DFS component to avoid --c99 option with armclang

import rtconfig
from building import *

# Override DFS component LOCAL_CFLAGS to remove --c99 for armclang
def patch_dfs_cflags(env):
    """
    Patch DFS component to remove --c99 option when using ARM Compiler 6 (armclang)
    """
    if rtconfig.PLATFORM == 'armcc' and rtconfig.CC == 'armclang':
        # Add a preprocessor define to identify armclang vs armcc
        env.Append(CPPDEFINES=['__ARMCLANG__'])
        
        # Remove any --c99 flags that might be added by components
        if '--c99' in str(env['CCFLAGS']):
            env['CCFLAGS'] = [flag for flag in env['CCFLAGS'] if flag != '--c99']
        if '--c99' in str(env['CFLAGS']):
            env['CFLAGS'] = [flag for flag in env['CFLAGS'] if flag != '--c99']
        if '--c99' in str(env['CXXFLAGS']):
            env['CXXFLAGS'] = [flag for flag in env['CXXFLAGS'] if flag != '--c99']

Return('patch_dfs_cflags')