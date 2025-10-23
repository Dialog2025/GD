# 修复 VS Code MCP 设置的 PowerShell 脚本

$settingsPath = "$env:APPDATA\Code - Insiders\User\settings.json"

$fixedSettings = @'
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

# 备份原始设置文件
if (Test-Path $settingsPath) {
    $backupPath = "$settingsPath.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Copy-Item $settingsPath $backupPath
    Write-Host "已备份原始设置文件到: $backupPath" -ForegroundColor Green
}

# 写入修复后的设置
try {
    $fixedSettings | Out-File -FilePath $settingsPath -Encoding UTF8 -Force
    Write-Host "MCP 设置已修复！" -ForegroundColor Green
    Write-Host "请重启 VS Code 使更改生效。" -ForegroundColor Yellow
} catch {
    Write-Host "修复失败: $($_.Exception.Message)" -ForegroundColor Red
}