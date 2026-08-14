# generate_tree.ps1
# Uso: .\generate_tree.ps1 -BaseDir . -Readme README.md -Annotations tree-annotations.txt
#
# Fichero de anotaciones (opcional): texto plano, una linea por entrada:
#   ruta/relativa/al/item|comentario a mostrar
#
# Requiere: PowerShell 5.1+ o 7+

param(
    [string]$BaseDir = (Join-Path $PSScriptRoot "..\guide"),
    [string]$Readme  = (Join-Path $PSScriptRoot "..\README.md"),
    [string]$Annotations = ""
)

$Exclude = @(".git", "node_modules", ".idea", ".vscode", "dist", "build", "__pycache__", ".DS_Store", "target")

# Caracteres de dibujo de caja y emojis construidos a partir de su punto de
# código. No se usan como literales en el fichero: si el .ps1 se guarda o se
# lee sin BOM UTF-8 (comportamiento por defecto de PowerShell 5.1 en Windows),
# los literales multibyte se corrompen y rompen el parser, no solo el texto.
$BoxV = [char]0x2502                              # │
$BoxT = [char]0x251C                              # ├
$BoxL = [char]0x2514                              # └
$BoxH = "$([char]0x2500)$([char]0x2500)"          # ──
$ConnMid  = "$BoxT$BoxH"                          # ├──
$ConnLast = "$BoxL$BoxH"                          # └──
$FolderIcon = [System.Char]::ConvertFromUtf32(0x1F4C1)  # 📁
$FileIcon   = [System.Char]::ConvertFromUtf32(0x1F4C4)  # 📄

if (-not (Test-Path -LiteralPath $BaseDir -PathType Container)) {
    Write-Error "'$BaseDir' no es un directorio"
    exit 1
}
if (-not (Test-Path -LiteralPath $Readme)) {
    Write-Error "No existe $Readme"
    exit 1
}

$readmeContent = Get-Content -LiteralPath $Readme -Raw -Encoding UTF8
if ($readmeContent -notmatch '<!-- TREE:START -->' -or $readmeContent -notmatch '<!-- TREE:END -->') {
    Write-Error "El README no contiene los marcadores <!-- TREE:START --> / <!-- TREE:END -->. Anadelos manualmente antes de usar el script."
    exit 1
}

$BaseDir = (Resolve-Path -LiteralPath $BaseDir).Path

$Comments = @{}
if ($Annotations -and (Test-Path -LiteralPath $Annotations)) {
    Get-Content -LiteralPath $Annotations -Encoding UTF8 | ForEach-Object {
        $line = $_
        if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#')) { return }
        $parts = $line -split '\|', 2
        if ($parts.Count -eq 2) {
            $key = $parts[0].Trim().TrimEnd('/', '\')
            $Comments[$key] = $parts[1].Trim()
        }
    }
} elseif ($Annotations) {
    Write-Warning "Fichero de anotaciones '$Annotations' no encontrado, se ignora."
}

$sb = New-Object System.Text.StringBuilder

function Add-Tree {
    param(
        [string]$Dir,
        [string]$Prefix,
        [int]$Depth
    )

    $items = Get-ChildItem -LiteralPath $Dir -Force |
        Where-Object { $Exclude -notcontains $_.Name } |
        Sort-Object @{Expression = { -not $_.PSIsContainer } }, Name

    $count = $items.Count
    $i = 0

    foreach ($item in $items) {
        $i++
        $rel = $item.FullName.Substring($BaseDir.Length + 1) -replace '\\', '/'
        $comment = $Comments[$rel.TrimEnd('/')]

        if ($i -eq $count) {
            $connector = $ConnLast
            $newPrefix = "$Prefix    "
        } else {
            $connector = $ConnMid
            $newPrefix = "$Prefix$BoxV   "
        }

        if ($item.PSIsContainer) {
            $line = "$Prefix$connector $FolderIcon $($item.Name)/"
        } else {
            $line = "$Prefix$connector $FileIcon $($item.Name)"
        }
        if ($comment) { $line = "$line  # $comment" }
        [void]$sb.AppendLine($line)

        if ($item.PSIsContainer) {
            Add-Tree -Dir $item.FullName -Prefix $newPrefix -Depth ($Depth + 1)
        }

        # Linea en blanco entre entradas de primer nivel, para legibilidad
        if ($Depth -eq 0 -and $i -lt $count) {
            [void]$sb.AppendLine("$Prefix$BoxV")
        }
    }
}

[void]$sb.AppendLine('```')
[void]$sb.AppendLine("$(Split-Path -Leaf $BaseDir)/")
[void]$sb.AppendLine($BoxV)
Add-Tree -Dir $BaseDir -Prefix "" -Depth 0
[void]$sb.AppendLine('```')

$treeContent = $sb.ToString().TrimEnd("`r", "`n")
$block = "<!-- TREE:START -->`n$treeContent`n<!-- TREE:END -->"

$pattern = '(?s)<!-- TREE:START -->.*?<!-- TREE:END -->'
$evaluator = { param($m) $block }
$newContent = [regex]::Replace($readmeContent, $pattern, [System.Text.RegularExpressions.MatchEvaluator]$evaluator)

[System.IO.File]::WriteAllText((Resolve-Path $Readme), $newContent, (New-Object System.Text.UTF8Encoding($false)))

Write-Host "OK: arbol actualizado en $Readme (base: $BaseDir)"