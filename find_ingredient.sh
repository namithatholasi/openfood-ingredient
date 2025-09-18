#!/usr/bin/env bash
# Usage: ./find_ingredient.sh -i "<ingredient>" -d /path/to/folder
# Input: products.csv (comma-separated) must exist inside the folder.
# Output: product_name<TAB>code for matches, then a final count line.

set -euo pipefail
export CSVKIT_FIELD_SIZE_LIMIT=$((1024 * 1024 * 1024))

INGREDIENT=""
DATA_DIR=""
CSV=""

usage() {
    echo "Usage: $0 -i \"<ingredient>\" -d /path/to/folder"
    echo " -i ingredient to search (case-insensitive)"
    echo " -d folder containing products.csv (comma-separated)"
    echo " -h show help"
}

# Parse flags
while getopts ":i:d:h" opt; do
    case "$opt" in
        i) INGREDIENT="$OPTARG" ;;
        d) DATA_DIR="$OPTARG" ;;
        h) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done

# Validate inputs
[ -z "${INGREDIENT:-}" ] && { echo "ERROR: -i <ingredient> is required" >&2; usage; exit 1; }
[ -z "${DATA_DIR:-}" ] && { echo "ERROR: -d /path/to/folder is required" >&2; usage; exit 1; }

CSV="$DATA_DIR/products.csv"
[ -s "$CSV" ] || { echo "ERROR: $CSV not found or empty." >&2; exit 1; }

# Check required tools
for cmd in csvcut csvgrep csvformat; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "ERROR: $cmd not found. Please install csvkit." >&2; exit 1; }
done

# Pipeline: now assume CSV (comma-separated, no -t)
tmp_matches="$(mktemp)"
csvcut -c code,product_name,ingredients_text "$CSV" \
| csvgrep -c ingredients_text -r "(?i)${INGREDIENT}" \
| csvcut -c product_name,code \
| csvformat -T \
| tail -n +2 \
| tee "$tmp_matches"

count="$(wc -l < "$tmp_matches" | tr -d ' ')"
echo "----"
echo "Found ${count} product(s) containing: \"${INGREDIENT}\""

rm -f "$tmp_matches"

