# MDK项目验证脚本
Write-Host "GD32F503V-EVAL BSP MDK项目验证" -ForegroundColor Green

Write-Host "`n1. 检查项目文件是否存在..." -ForegroundColor Yellow
if (Test-Path "project.uvprojx") {
    Write-Host "✓ project.uvprojx 存在" -ForegroundColor Green
} else {
    Write-Host "✗ project.uvprojx 不存在" -ForegroundColor Red
    exit 1
}

Write-Host "`n2. 检查C99相关配置..." -ForegroundColor Yellow
$c99_check = Select-String -Pattern "c99|C99" -Path "project.uvprojx" -SimpleMatch
if ($c99_check) {
    Write-Host "✗ 发现C99相关配置:" -ForegroundColor Red
    $c99_check | ForEach-Object { Write-Host "  Line $($_.LineNumber): $($_.Line.Trim())" }
} else {
    Write-Host "✓ 未发现C99相关配置" -ForegroundColor Green
}

Write-Host "`n3. 检查编译器设置..." -ForegroundColor Yellow
$compiler_lines = Select-String -Pattern "TargetOption|uAC6" -Path "project.uvprojx"
foreach ($line in $compiler_lines) {
    if ($line.Line -match "uAC6.*>1<") {
        Write-Host "✓ 使用ARM Compiler 6" -ForegroundColor Green
        break
    }
}

Write-Host "`n4. 检查MiscControls设置..." -ForegroundColor Yellow
$misc_controls = Select-String -Pattern "<MiscControls>" -Path "project.uvprojx"
$empty_misc = $true
foreach ($line in $misc_controls) {
    if ($line.Line -notmatch "<MiscControls>\s*</MiscControls>") {
        Write-Host "✗ 发现非空MiscControls: $($line.Line.Trim())" -ForegroundColor Red
        $empty_misc = $false
    }
}
if ($empty_misc) {
    Write-Host "✓ 所有MiscControls都为空" -ForegroundColor Green
}

Write-Host "`n5. 项目结构检查..." -ForegroundColor Yellow
$required_files = @("applications\main.c", "board\board.c", "rtconfig.h", "SConstruct")
foreach ($file in $required_files) {
    if (Test-Path $file) {
        Write-Host "✓ $file 存在" -ForegroundColor Green
    } else {
        Write-Host "✗ $file 缺失" -ForegroundColor Red
    }
}

Write-Host "`n验证完成!" -ForegroundColor Green
Write-Host "现在可以使用Keil MDK打开project.uvprojx进行编译。" -ForegroundColor Cyan
Write-Host "如果仍有编译问题，请检查Keil MDK版本和ARM Compiler 6安装。" -ForegroundColor Cyan