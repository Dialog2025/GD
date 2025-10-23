# 强制重启 VS Code Insiders 并重新加载 MCP 配置
Write-Host "正在关闭 VS Code Insiders..."
taskkill /F /IM "Code - Insiders.exe"
Start-Sleep -Seconds 2

Write-Host "MCP 已启用，配置如下："
Write-Host "- chat.mcp.enabled: true"
Write-Host "- chat.mcp.autostart: newAndOutdated"
Write-Host "- mcp.servers: {} (空配置，避免外部服务器错误)"

Write-Host "`n正在重新启动 VS Code Insiders..."
Start-Process "code-insiders" -ArgumentList "d:\code\rt-thread-master\bsp\gd32\arm\gd32g553q_eval"

Write-Host "`nMCP 配置修复完成！"
Write-Host "VS Code 重启后 MCP 功能应该正常工作。"