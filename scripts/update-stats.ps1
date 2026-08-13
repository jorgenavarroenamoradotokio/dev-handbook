$ErrorActionPreference = "Stop"

$RootDir = Split-Path -Parent $PSScriptRoot
$ReadmePath = Join-Path $RootDir "README.md"

if (-not (Test-Path $ReadmePath)) {
    Write-Error "No se encontro README.md en $RootDir."
    exit 1
}

$Categories = @("version-control","infrastructure","certifications","languages","platforms","testing","data")

$totalGuides = 0
$activeCategories = 0
$counts = @{}

foreach ($category in $Categories) {
    $path = Join-Path $RootDir $category
    $count = 0
    if (Test-Path $path) {
        $count = (Get-ChildItem -Path $path -Recurse -Filter "*.md" -File -ErrorAction SilentlyContinue).Count
    }
    $counts[$category] = $count
    $totalGuides += $count
    if ($count -gt 0) { $activeCategories++ }
}

$today = Get-Date -Format "yyyy/MM"

$badgesBlock = @"
[![Guías completadas](https://img.shields.io/badge/Guías-$totalGuides-4CAF50?style=flat-square)](./docs/CHANGELOG.md)
[![Categorías activas](https://img.shields.io/badge/Categorías_activas-$activeCategories-blue?style=flat-square)](#-índice-de-guías)
[![Última actualización](https://img.shields.io/badge/Última_actualización-$today-blue?style=flat-square)](./docs/CHANGELOG.md)
"@

# CORREGIDO: sin -Raw, para obtener un array de líneas real
$lines = Get-Content -Path $ReadmePath -Encoding UTF8
$output = New-Object System.Collections.Generic.List[string]
$skip = $false

foreach ($line in $lines) {
    if ($line -match "<!-- BADGES:START -->") {
        $output.Add($line)
        $output.Add($badgesBlock)
        $skip = $true
        continue
    }
    if ($line -match "<!-- BADGES:END -->") {
        $skip = $false
    }
    if (-not $skip) {
        $output.Add($line)
    }
}

# CORREGIDO: escritura UTF-8 sin BOM (evita BOM parásito en el README)
$outText = ($output -join "`n")
[System.IO.File]::WriteAllText($ReadmePath, $outText, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "Total guias: $totalGuides"
Write-Host "Categorias activas: $activeCategories"
foreach ($key in $counts.Keys) {
    Write-Host "  - $key`: $($counts[$key])"
}