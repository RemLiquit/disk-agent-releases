# Instala DiskAgent desde el último Release de GitHub (Windows).
#   irm https://raw.githubusercontent.com/RemLiquit/disk-agent-releases/master/install.ps1 | iex
$ErrorActionPreference = 'Stop'
$base = 'https://github.com/RemLiquit/disk-agent-releases/releases/latest/download'
$dir = Join-Path $env:LOCALAPPDATA 'Programs\DiskAgent'
$exe = Join-Path $dir 'disk-agent.exe'
New-Item -ItemType Directory -Force $dir | Out-Null
Write-Host '> Descargando disk-agent-windows-x86_64.exe...'
$tmp = Join-Path $env:TEMP 'disk-agent-download.exe'
Invoke-WebRequest "$base/disk-agent-windows-x86_64.exe" -OutFile $tmp
if (Test-Path $exe) { Remove-Item "$exe.old" -Force -ErrorAction SilentlyContinue; Move-Item $exe "$exe.old" -Force }
Move-Item $tmp $exe -Force
$menu = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
$shell = New-Object -ComObject WScript.Shell
$link = $shell.CreateShortcut((Join-Path $menu 'DiskAgent.lnk'))
$link.TargetPath = $exe
$link.WorkingDirectory = $dir
$link.Save()
Write-Host 'Listo: busca DiskAgent en el menu Inicio.'
