# 彻底清理 MCP 配置脚本

# 1. 停止可能的 MCP 进程
Get-Process | Where-Object {$_.ProcessName -like "*mcp*" -or $_.ProcessName -like "*context*"} | Stop-Process -Force -ErrorAction SilentlyContinue

# 2. 清理 npm 缓存
npm cache clean --force

# 3. 创建最小化配置
$settings = @{
    "workbench.colorTheme" = "Default Dark+"
    "files.autoSave" = "onFocusChange"
    "editor.fontSize" = 14
    "chat.mcp.enabled" = $false
    "chat.mcp.autostart" = "never"
}

# 4. 保存配置
$settings | ConvertTo-Json | Set-Content "$env:APPDATA\Code - Insiders\User\settings.json" -Encoding UTF8

Write-Host "MCP 已完全禁用，配置已清理"
Write-Host "请重启 VS Code"
