# update_badges.ps1
# Uso: .\update_header.ps1 -BaseDir . -Readme README.md
#
# Guias      = nº total de ficheros .md bajo BaseDir (recursivo), excluyendo
#              ExcludeDirs y ExcludeFiles.
# Categorias = nº de carpetas de primer nivel bajo BaseDir que contienen
#              al menos un .md válido en cualquier profundidad.
#
# Requiere: PowerShell 5.1+ o 7+

param(
    [string]$BaseDir = (Join-Path $PSScriptRoot "..\guide"),
    [string]$Readme  = (Join-Path $PSScriptRoot "..\README.md")
)

# Carpetas que nunca cuentan como guías/categorías. Edita según tu proyecto.
$ExcludeDirs = @(".git", "node_modules", ".idea", ".vscode", "dist", "build", "__pycache__", "target")

# Ficheros .md concretos (ruta relativa a BaseDir) que NO son "guías".
$ExcludeFiles = @("README.md", "CHANGELOG.md", "CONTRIBUTING.md")

if (-not (Test-Path -LiteralPath $BaseDir -PathType Container)) {
    Write-Error "'$BaseDir' no es un directorio"
    exit 1
}
if (-not (Test-Path -LiteralPath $Readme)) {
    Write-Error "No existe $Readme"
    exit 1
}

$readmeContent = Get-Content -LiteralPath $Readme -Raw -Encoding UTF8
if ($readmeContent -notmatch '<!-- BADGES:START -->' -or $readmeContent -notmatch '<!-- BADGES:END -->') {
    Write-Error "El README no contiene los marcadores <!-- BADGES:START --> / <!-- BADGES:END -->."
    exit 1
}

$BaseDir = (Resolve-Path -LiteralPath $BaseDir).Path

$allMd = Get-ChildItem -LiteralPath $BaseDir -Recurse -File -Filter *.md -Force | Where-Object {
    $rel = $_.FullName.Substring($BaseDir.Length + 1) -replace '\\', '/'
    $parts = $rel -split '/'
    $dirParts = $parts[0..($parts.Count - 2)]
    $inExcludedDir = $false
    foreach ($p in $dirParts) {
        if ($ExcludeDirs -contains $p) { $inExcludedDir = $true; break }
    }
    (-not $inExcludedDir) -and ($ExcludeFiles -notcontains $rel)
}

$Guias = $allMd.Count

$TopDirs = @{}
foreach ($f in $allMd) {
    $rel = $f.FullName.Substring($BaseDir.Length + 1) -replace '\\', '/'
    if ($rel -match '/') {
        $TopDirs[$rel.Split('/')[0]] = $true
    }
}
$Categorias = $TopDirs.Count

$fecha = Get-Date -Format "yyyy/MM"
$fechaEnc = $fecha -replace '/', '%2F'

# Caracteres acentuados a partir de su punto de código Unicode: no depende
# de si el .ps1 se guardó con BOM UTF-8 o de la codepage del sistema.
$iAcute = [char]0x00ED   # í
$Uacute = [char]0x00DA   # Ú
$oAcute = [char]0x00F3   # ó

$lblGuias      = "Gu${iAcute}as completadas"
$lblCategorias = "Categor${iAcute}as activas"
$lblFecha      = "${Uacute}ltima actualizaci${oAcute}n"
$anchor        = "#-${iAcute}ndice-de-gu${iAcute}as"

$block = @"
<!-- BADGES:START -->
[![$lblGuias](https://img.shields.io/badge/Gu%C3%ADas-$Guias-4CAF50?style=flat-square)](./docs/CHANGELOG.md)
[![$lblCategorias](https://img.shields.io/badge/Categor%C3%ADas_activas-$Categorias-blue?style=flat-square)]($anchor)
[![$lblFecha](https://img.shields.io/badge/%C3%9Altima_actualizaci%C3%B3n-$fechaEnc-blue?style=flat-square)](./docs/CHANGELOG.md)
<!-- BADGES:END -->
"@

$pattern = '(?s)<!-- BADGES:START -->.*?<!-- BADGES:END -->'
$evaluator = { param($m) $block }
$newContent = [regex]::Replace($readmeContent, $pattern, [System.Text.RegularExpressions.MatchEvaluator]$evaluator)

[System.IO.File]::WriteAllText((Resolve-Path $Readme), $newContent, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "OK: badges actualizados en $Readme (Guias=$Guias, Categorias=$Categorias, Fecha=$fecha)"