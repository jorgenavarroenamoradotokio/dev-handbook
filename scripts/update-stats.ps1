# scripts/update-stats.ps1
# Recalcula badges y tabla de estado del README a partir del contenido real del repo.
# Equivalente funcional de update-stats.sh, para entornos sin bash (PowerShell nativo).
#
# Uso:
#   .\scripts\update-stats.ps1
#
# Si PowerShell bloquea la ejecución de scripts (politica de ejecucion por defecto en Windows),
# ejecuta una vez en esa sesion:
#   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

$ErrorActionPreference = "Stop"

# Resuelve la raíz del repo asumiendo que este script vive en <repo>/scripts/
$RootDir = Split-Path -Parent $PSScriptRoot
$ReadmePath = Join-Path $RootDir "README.md"

if (-not (Test-Path $ReadmePath)) {
    Write-Error "No se encontro README.md en $RootDir. Verifica que el script esta en <repo>/scripts/"
    exit 1
}

# Categorías de nivel superior a contabilizar (debe coincidir con update-stats.sh)
$Categories = @(
    "version-control",
    "infrastructure",
    "certifications",
    "languages",
    "platforms",
    "testing",
    "data"
)

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

    if ($count -gt 0) {
        $activeCategories++
    }
}

$today = Get-Date -Format "yyyy-MM"

$badgesBlock = @"
[![Guías completadas](https://img.shields.io/badge/Guías-$totalGuides-4CAF50?style=flat-square)](./docs/CHANGELOG.md)
[![Categorías activas](https://img.shields.io/badge/Categorías_activas-$activeCategories-blue?style=flat-square)](#-índice-de-guías)
[![Última actualización](https://img.shields.io/badge/Última_actualización-$today-blue?style=flat-square)](./docs/CHANGELOG.md)
"@

# Lee el README completo, línea por línea, y reemplaza solo el bloque entre marcadores
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

Set-Content -Path $ReadmePath -Value $output -Encoding UTF8

Write-Host "Total guias: $totalGuides"
Write-Host "Categorias activas: $activeCategories"
foreach ($key in $counts.Keys) {
    Write-Host "  - $key`: $($counts[$key])"
}