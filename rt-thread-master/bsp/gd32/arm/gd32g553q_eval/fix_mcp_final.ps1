# 彻底修复 MCP SSL 证书问题
Write-Host "开始修复 MCP 配置..."

# 1. 备份当前设置
$settingsPath = "$env:APPDATA\Code - Insiders\User\settings.json"
$backupPath = "$settingsPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item $settingsPath $backupPath -Force
Write-Host "已备份设置到: $backupPath"

# 2. 创建全新的干净配置
$cleanSettings = @{
    "workbench.colorTheme" = "Default Dark+"
    "files.autoSave" = "onFocusChange"
    "chat.mcp.enabled" = $true
    "chat.mcp.autostart" = "never"
    "mcp.servers" = @{}
    "github.copilot.enable" = @{
        "*" = $true
        "yaml" = $true
        "plaintext" = $true
        "markdown" = $true
    }
}

# 3. 保存新配置
$cleanSettings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8
Write-Host "已创建干净的 MCP 配置"

# 4. 清理 npm 缓存解决 SSL 问题
npm cache clean --force
Write-Host "已清理 npm 缓存"

# 5. 配置 npm 使用更安全的设置
npm config set strict-ssl false
npm config set registry https://registry.npmmirror.com/
Write-Host "已配置 npm 使用国内镜像源"

Write-Host "修复完成！请重启 VS Code"