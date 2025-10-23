# 修复 MCP 设置的 PowerShell 脚本
Write-Host "正在修复 MCP 服务器配置..." -ForegroundColor Green

# VS Code Insiders 用户设置路径
$settingsPath = "$env:APPDATA\Code - Insiders\User\settings.json"

Write-Host "设置文件路径: $settingsPath" -ForegroundColor Yellow

# 检查文件是否存在
if (Test-Path $settingsPath) {
    Write-Host "找到设置文件，正在备份..." -ForegroundColor Yellow
    
    # 创建备份
    $backupPath = "$settingsPath.backup"
    Copy-Item $settingsPath $backupPath -Force
    Write-Host "备份已创建: $backupPath" -ForegroundColor Green
    
    # 正确的 MCP 配置
    $correctSettings = @'
{
    "http.proxyStrictSSL": false,
    "http.systemCertificates": true,
    "github.copilot.enable": {
        "*": true,
        "plaintext": true,
        "markdown": false,
        "scminput": false
    },
    "workbench.settings.applyToAllProfiles": [
        "chat.mcp.enabled"
    ],
    "chat.mcp.enabled": true,
    "chat.mcp.serverSampling": {
        "Code - Insiders 中的全局: context7": {
            "allowedModels": [
                "copilot/auto",
                "copilot/claude-3.5-sonnet",
                "copilot/claude-3.7-sonnet",
                "copilot/claude-3.7-sonnet-thought",
                "copilot/claude-sonnet-4",
                "copilot/gemini-2.0-flash-001",
                "copilot/gemini-2.5-pro",
                "copilot/gpt-4.1",
                "copilot/gpt-4o",
                "copilot/gpt-5",
                "copilot/o3-mini",
                "copilot/o4-mini"
            ]
        }
    },
    "workbench.iconTheme": "vs-minimal",
    "KeilAssistant.C51.Uv4Path": "\"D:/software/Keil5/UV4/UV4.exe\"",
    "KeilAssistant.MDK.Uv4Path": "\"D:/software/Keil5/UV4/UV4.exe\"",
    "KeilAssistant.Project.ExcludeList": [
        "template.uvproj",
        "template.uvprojx"
    ],
    "editor.accessibilitySupport": "on",
    "chat.mcp.assisted.nuget.enabled": true,
    "chat.mcp.discovery.enabled": {
        "claude-desktop": true,
        "windsurf": true,
        "cursor-global": true,
        "cursor-workspace": true
    },
    "mcp.servers": {
        "context7": {
            "command": "npx",
            "args": [
                "-y",
                "@upstash/context7-mcp@latest"
            ]
        }
    }
}
'@
    
    # 写入修复后的配置
    $correctSettings | Out-File -FilePath $settingsPath -Encoding UTF8 -Force
    Write-Host "设置文件已修复！" -ForegroundColor Green
    
    Write-Host "现在请重启 VS Code 以使更改生效。" -ForegroundColor Cyan
    
} else {
    Write-Host "错误: 找不到设置文件 $settingsPath" -ForegroundColor Red
}

Write-Host "修复完成！" -ForegroundColor Green