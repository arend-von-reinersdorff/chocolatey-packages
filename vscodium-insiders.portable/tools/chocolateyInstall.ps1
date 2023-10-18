﻿$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$oldPath = $false
$installationPath = Join-Path (Get-ToolsLocation) 'VSCodium'

$logPath = Join-Path $toolsDir 'vscodium.txt'
if (Test-Path $logPath) {
    $oldInstallationPath = Get-Content $logPath
    if ($oldInstallationPath -ne $installationPath) {
        if (Test-Path $oldInstallationPath) {
            $oldPath = $true
            $installationPath = $oldInstallationPath
            Write-Verbose "Old Installation Path detected"
        }
    }
}
Write-Verbose "Installation Path: $installationPath"

# *** Automatically filled ***
$packageArgs = @{
    packageName    = 'vscodium-insiders.portable'
    url            = 'https://github.com/VSCodium/vscodium-insiders/releases/download/1.84.0.23283-insider/VSCodium-win32-ia32-1.84.0.23283-insider.zip'
    url64bit       = 'https://github.com/VSCodium/vscodium-insiders/releases/download/1.84.0.23283-insider/VSCodium-win32-x64-1.84.0.23283-insider.zip'
    unzipLocation  = $installationPath
    checksum       = 'd4b91eed8aac7c2c87c4c6cbadcc4805ca8d1ec50b44bde9f76a9fd885b6a93d'
    checksumType   = 'sha256'
    checksum64     = 'e4b2970e41aa5e8c095b9ebf0e1967a5eb9082df7e63a62304c8a140441c96b0'
    checksumType64 = 'sha256'
}
# *** Automatically filled ***

Install-ChocolateyZipPackage @packageArgs

if (!$oldPath) {
    # Enable Portable mode (for new installation path only)
    $dataPath = Join-Path $installationPath 'data'
    New-Item -ItemType Directory -Path $dataPath -Force -ErrorAction SilentlyContinue
}

$binPath = Join-Path $installationPath 'bin\codium-insiders.cmd'
Install-BinFile -Name 'codium-insiders' -Path $binPath

Set-Content $logPath $installationPath -Encoding UTF8 -Force

$shortcutName = 'VSCodium - Insiders.lnk'
$vscodiumPath = Join-Path $installationPath 'VSCodium - Insiders.exe'
$shortcutPath = Join-Path $([Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonPrograms)) $shortcutName
Install-ChocolateyShortcut -ShortcutFilePath $shortcutPath -TargetPath $vscodiumPath