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
    param(
        [switch]$Force
    )

    $sourceInit = Join-Path (Get-DotfilesNvimRoot) "init.vim"
    $targetInit = Get-WindowsNvimInitPath
    $targetDir  = Split-Path -Parent $targetInit

    if (-not (Test-Path -LiteralPath $sourceInit)) {
        throw "Dotfiles init.vim not found: $sourceInit"
    }

    if (-not (Test-Path -LiteralPath $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    $sourceInitVim = $sourceInit -replace '\\','/'

    $loader = @"
let s:dotfiles_init = '$sourceInitVim'
execute 'source' fnameescape(s:dotfiles_init)
"@

    if ((Test-Path -LiteralPath $targetInit) -and -not $Force) {
        $current = Get-Content -LiteralPath $targetInit -Raw -ErrorAction SilentlyContinue
        if ($current -eq $loader) {
            Write-Host "[INFO] nvim loader already up to date: $targetInit"
            return
        }
        Copy-Item -LiteralPath $targetInit -Destination "$targetInit.bak" -Force
    }

    Set-Content -LiteralPath $targetInit -Value $loader -Encoding UTF8
    Write-Host "[OK] Wrote nvim loader: $targetInit"
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
