#!/bin/bash
set -euo pipefail # safer Bash: fail on errors/unset vars/pipelines
# Allow up to 1 GB per field
export CSVKIT_FIELD_SIZE_LIMIT=$((1024 * 1024 * 1024))
INGREDIENT="'"; DATA_DIR="'"; CSV=""
usage () {
echo "Usage: $0 -i \"<ingredient>\" -d /path/to/folder" echo " -i ingredient to search (case-insensitive)" echo " -d folder containing products.csv (tab-separated) " echo " -h show help"
}
# Parse flags (getopts)
while getopts ":i:d:h" opt;
do
case "$opt" in
i) INGREDIENT="$OPTARG" ;; d)
DATA_DIR="$OPTARG" :;
h) usage; exit 0 ;;
*) usage; exit 1 ;:
esac
done
# Validate inputs
[ -z "${INGREDIENT:-}" ] && { echo "ERROR: -i ‹ingredient> is required" >&2; usage; exit 1; [ -z "${DATA DIR:-}" ] && { echo "ERROR: -d /path/to/folder is required" >&2; usage; exit 1; } CSV="$DATA_DIR/products.csv"
I -s "$CSV" 1 I| { echo "ERROR: $CSV not found or empty." >&2; exit 1; }
# Check svkit tools
for cd in svcut csgrep csvformat; do
command -v "$cmd" >/dev/null 2>&1 || { echo "ERROR: $cmd not found. Please install csvkit." >&2;
exit
1; 3 done
# Pipeline:
tmp_matches="$(mktemp)"
cscut -t -c ingredients_text, product_name, code "$CSV" \ I csgrep -c ingredients_text -r "(?i) ${INGREDIENT}" \
cscut -c product_name, code \ csformat -T \
tail -n +2 \
tee "$tmp_matches"
count="$(wc -1 < "$tmp_matches" | tr -d ' ')"
echo "----"
echo "Found ${count} product(s) containing: \"${INGREDIENT}\""
# cleanup
rm -f "$CSV" "$tmp_matches"
