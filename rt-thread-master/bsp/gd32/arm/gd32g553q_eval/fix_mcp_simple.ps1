Write-Host "正在修复 MCP 设置..." -ForegroundColor Green

$settingsPath = "$env:APPDATA\Code - Insiders\User\settings.json"

if (Test-Path $settingsPath) {
    # 创建备份
    Copy-Item $settingsPath "$settingsPath.backup" -Force
    Write-Host "已创建备份文件" -ForegroundColor Yellow
    
    # 正确的配置内容
    $config = '{
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
    "chat.mcp.serverSampling": {},
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
}'
    
    # 写入新配置
    $config | Out-File -FilePath $settingsPath -Encoding UTF8
    Write-Host "MCP 设置已修复！请重启 VS Code。" -ForegroundColor Green
    
} else {
    Write-Host "找不到设置文件: $settingsPath" -ForegroundColor Red
}