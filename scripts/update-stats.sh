```bash
#!/usr/bin/env bash
# scripts/update-stats.sh
# Recalcula badges y tabla de estado del README a partir del contenido real del repo.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
README="$ROOT_DIR/README.md"

declare -A CATEGORIES=(
  ["version-control"]="Version Control"
  ["infrastructure"]="Infrastructure"
  ["certifications"]="Certifications"
  ["languages"]="Languages"
  ["platforms"]="Platforms"
  ["testing"]="Testing"
  ["data"]="Data"
)

total_guides=0
active_categories=0
declare -A counts

for dir in "${!CATEGORIES[@]}"; do
  path="$ROOT_DIR/$dir"
  if [ -d "$path" ]; then
    # Cuenta .md reales, ignora README.md de la raíz si quedara dentro por error
    count=$(find "$path" -type f -name "*.md" | wc -l | tr -d ' ')
  else
    count=0
  fi
  counts["$dir"]=$count
  total_guides=$((total_guides + count))
  if [ "$count" -gt 0 ]; then
    active_categories=$((active_categories + 1))
  fi
done

today=$(date +%Y-%m)

badges=$(cat <<EOF
[![Guías completadas](https://img.shields.io/badge/Guías-${total_guides}-4CAF50?style=flat-square)](./docs/CHANGELOG.md)
[![Categorías activas](https://img.shields.io/badge/Categorías_activas-${active_categories}-blue?style=flat-square)](#-índice-de-guías)
[![Última actualización](https://img.shields.io/badge/Última_actualización-${today}-blue?style=flat-square)](./docs/CHANGELOG.md)
EOF
)

# Reemplaza el bloque entre marcadores en README.md
awk -v badges="$badges" '
  /<!-- BADGES:START -->/ { print; print badges; skip=1; next }
  /<!-- BADGES:END -->/ { skip=0 }
  !skip
' "$README" > "$README.tmp" && mv "$README.tmp" "$README"

echo "Total guías: $total_guides"
echo "Categorías activas: $active_categories"
for dir in "${!counts[@]}"; do
  echo "  - $dir: ${counts[$dir]}"
done
```