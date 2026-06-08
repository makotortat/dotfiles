[CmdletBinding()]
param(
    [switch]$Install,
    [switch]$Force
)

Set-StrictMode -Version Latest

$DotfilesRoot = Split-Path -Parent $PSScriptRoot

function Get-DotfilesNvimRoot {
    Join-Path $DotfilesRoot ".config\nvim"
}

function Get-WindowsNvimInitPath {
    Join-Path $env:LOCALAPPDATA "nvim\init.vim"
}

function New-NvimInitLoader {

    $sourceInit = Join-Path $DotfilesRoot ".config\nvim\init.vim"
    $targetInit = Join-Path $env:LOCALAPPDATA "nvim\init.vim"
    $targetDir  = Split-Path $targetInit -Parent

    if (-not (Test-Path $sourceInit)) {
        throw "dotfiles init.vim not found: $sourceInit"
    }

    if (-not (Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir | Out-Null
    }

    $sourceInitVim = $sourceInit -replace '\\','/'

    $loader = @"
let s:dotfiles_init = '$sourceInitVim'
execute 'source' fnameescape(s:dotfiles_init)
"@

    # target が存在しない
    if (-not (Test-Path $targetInit)) {
        Write-Host "[INFO] creating new init.vim loader"
        Set-Content $targetInit $loader -Encoding UTF8
        return
    }

    # 既存内容取得
    $current = Get-Content $targetInit -Raw

    # 同じなら何もしない
    if ($current -eq $loader) {
        Write-Host "[INFO] loader already installed"
        return
    }

    # dotfiles loader かどうか
    if ($current -match "dotfiles_init") {
        Write-Host "[INFO] updating existing loader"
        Copy-Item $targetInit "$targetInit.bak" -Force
        Set-Content $targetInit $loader -Encoding UTF8
        return
    }

    # 完全に別ファイル
    Write-Warning "existing init.vim detected"
    Write-Warning "backup created"

    $backup = "$targetInit.userbackup"
    Copy-Item $targetInit $backup

    Set-Content $targetInit $loader -Encoding UTF8
}

function Install-Dotfiles {
    param(
        [switch]$Force
    )

    New-NvimInitLoader -Force:$Force
    Write-Host "[OK] Dotfiles install complete."
}

if ($Install) {
    Install-Dotfiles -Force:$Force
}
