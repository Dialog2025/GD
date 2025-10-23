# 修复 MCP 配置 - 使用更稳定的本地配置
$settingsPath = "$env:APPDATA\Code - Insiders\User\settings.json"

# 备份当前设置
Copy-Item $settingsPath "$settingsPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# 读取当前设置
$settings = Get-Content $settingsPath -Raw | ConvertFrom-Json

# 移除有问题的 MCP 服务器配置
if ($settings.PSObject.Properties.Name -contains "mcp.servers") {
    $settings.PSObject.Properties.Remove("mcp.servers")
}

# 添加更简单稳定的配置
$settings | Add-Member -NotePropertyName "chat.mcp.enabled" -NotePropertyValue $true -Force
$settings | Add-Member -NotePropertyName "chat.mcp.autostart" -NotePropertyValue "newAndOutdated" -Force

# 暂时禁用外部 MCP 服务器，使用内置功能
$mcpServers = @{}
$settings | Add-Member -NotePropertyName "mcp.servers" -NotePropertyValue $mcpServers -Force

# 保存设置
$settings | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding UTF8

Write-Host "MCP 配置已修复为更稳定的版本"
Write-Host "请重启 VS Code 以应用更改"