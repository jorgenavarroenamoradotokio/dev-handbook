# generate_index.ps1
# Uso: .\generate_index.ps1 -BaseDir ../../guide -Readme ../../README.md
#
# Misma logica que generate_index.sh. Ver ese fichero para la explicacion
# completa de reglas (Modulo/Guia/Estado, carpeta vacia, titulo de seccion).
#
# Requiere: PowerShell 5.1+ o 7+

param(
    [string]$BaseDir = (Join-Path $PSScriptRoot "..\guide"),
    [string]$Readme  = (Join-Path $PSScriptRoot "..\README.md")
)

if (-not (Test-Path -LiteralPath $BaseDir -PathType Container)) {
    Write-Error "'$BaseDir' no es un directorio"
    exit 1
}
if (-not (Test-Path -LiteralPath $Readme)) {
    Write-Error "No existe $Readme"
    exit 1
}

$readmeContent = Get-Content -LiteralPath $Readme -Raw -Encoding UTF8
if ($readmeContent -notmatch '<!-- INDEX:START -->' -or $readmeContent -notmatch '<!-- INDEX:END -->') {
    Write-Error "El README no contiene los marcadores <!-- INDEX:START --> / <!-- INDEX:END -->."
    exit 1
}

$BaseDir = (Resolve-Path -LiteralPath $BaseDir).Path

$ExcludeDirs = @(".git", "node_modules", ".idea", ".vscode", "dist", "build", "__pycache__", "target")

# Emoji construidos a partir de su punto de codigo Unicode: no dependen de
# si el .ps1 se guarda con BOM UTF-8 o de la codepage del sistema, que fue
# la causa del error de parseo anterior.
$EGreen  = [System.Char]::ConvertFromUtf32(0x1F7E2)   # verde
$EYellow = [System.Char]::ConvertFromUtf32(0x1F7E1)   # amarillo
$ERed    = [System.Char]::ConvertFromUtf32(0x1F534)   # rojo
$ESoon   = [System.Char]::ConvertFromUtf32(0x1F51C)   # pronto
$EmDash  = [char]0x2014                                # guion largo para titulos

$MarkGreen  = "$EGreen Completo"
$MarkYellow = "$EYellow En progreso"
$MarkRed    = "$ERed Borrador"

function ConvertTo-Prettify {
    param([string]$Name)
    $n = [System.IO.Path]::GetFileNameWithoutExtension($Name)
    $n = $n -replace '-', ' '
    $n = $n -replace '_', ' '
    $n = [regex]::Replace($n, '([a-z0-9])([A-Z])', '$1 $2')
    $n = ($n -replace '\s+', ' ').Trim()
    if ([string]::IsNullOrWhiteSpace($n)) { return $n }
    $words = $n -split ' ' | Where-Object { $_ -ne '' }
    $result = foreach ($w in $words) {
        $w.Substring(0,1).ToUpper() + $w.Substring(1)
    }
    return ($result -join ' ')
}

function Get-FileStatus {
    param([string]$Path)
    $content = Get-Content -LiteralPath $Path -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if ([string]::IsNullOrWhiteSpace($content)) {
        return $ESoon
    }
    if ($content.Contains($MarkGreen)) { return $MarkGreen }
    if ($content.Contains($MarkYellow)) { return $MarkYellow }
    if ($content.Contains($MarkRed)) { return $MarkRed }
    Write-Warning "'$Path' no tiene marcador de estado, se asume '$MarkYellow'"
    return $MarkYellow
}

# Encuentra todas las carpetas finales (sin subcarpetas, excluyendo ExcludeDirs)
$allDirs = Get-ChildItem -LiteralPath $BaseDir -Recurse -Directory -Force |
    Where-Object {
        $parts = $_.FullName.Substring($BaseDir.Length + 1) -split '[\\/]'
        -not ($parts | Where-Object { $ExcludeDirs -contains $_ })
    }
$allDirs = @($allDirs) + (Get-Item -LiteralPath $BaseDir)

$leafDirs = $allDirs | Where-Object {
    $dir = $_
    $subs = Get-ChildItem -LiteralPath $dir.FullName -Directory -Force -ErrorAction SilentlyContinue |
        Where-Object { $ExcludeDirs -notcontains $_.Name }
    ($subs | Measure-Object).Count -eq 0
} | Sort-Object FullName

$sb = New-Object System.Text.StringBuilder

foreach ($dir in $leafDirs) {
    $rel = $dir.FullName.Substring($BaseDir.Length + 1) -replace '\\', '/'
    if ([string]::IsNullOrWhiteSpace($rel)) { continue }

    $root = $rel -split '/' | Select-Object -First 1
    $leaf = Split-Path -Leaf $rel

    if ($root -eq $leaf) {
        $title = ConvertTo-Prettify $root
    } else {
        $title = "$(ConvertTo-Prettify $root) $EmDash $(ConvertTo-Prettify $leaf)"
    }

    [void]$sb.AppendLine("### $title (``/$rel``)")
    [void]$sb.AppendLine("")
    [void]$sb.AppendLine("| Modulo | Guia | Estado |")
    [void]$sb.AppendLine("|:-------|:-----|:------:|")

    $files = Get-ChildItem -LiteralPath $dir.FullName -File -Filter *.md -Force -ErrorAction SilentlyContinue

    if (($files | Measure-Object).Count -eq 0) {
        [void]$sb.AppendLine("| - | Proximamente | $ESoon |")
    } else {
        $rows = foreach ($f in $files) {
            $name = $f.Name
            $num = $null
            $rawTitle = $null
            if ($name -match '^(?i)modulo[-_]?([0-9]+)[-_](.+)\.md$') {
                $num = $Matches[1]
                $rawTitle = $Matches[2]
            } elseif ($name -match '^([0-9]+)[-_](.+)\.md$') {
                $num = $Matches[1]
                $rawTitle = $Matches[2]
            } else {
                $num = "-"
                $rawTitle = [System.IO.Path]::GetFileNameWithoutExtension($name)
            }
            $guia = ConvertTo-Prettify $rawTitle
            $estado = Get-FileStatus -Path $f.FullName
            $sortKey = if ($num -eq "-") { 9999 } else { [int]$num }
            [PSCustomObject]@{ SortKey = $sortKey; Line = "| $num | $guia | $estado |" }
        }
        $rows = $rows | Sort-Object SortKey
        foreach ($r in $rows) { [void]$sb.AppendLine($r.Line) }
    }
    [void]$sb.AppendLine("")
}

$indexContent = $sb.ToString().TrimEnd("`r", "`n")
$block = "<!-- INDEX:START -->`n$indexContent`n<!-- INDEX:END -->"

$pattern = '(?s)<!-- INDEX:START -->.*?<!-- INDEX:END -->'
$evaluator = { param($m) $block }
$newContent = [regex]::Replace($readmeContent, $pattern, [System.Text.RegularExpressions.MatchEvaluator]$evaluator)

[System.IO.File]::WriteAllText((Resolve-Path $Readme), $newContent, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "OK: indice actualizado en $Readme"