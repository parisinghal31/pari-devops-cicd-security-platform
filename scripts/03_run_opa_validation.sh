#!/usr/bin/env bash
# Validates every file in deployments/ against every policy in policies/.
# Writes a report to reports/opa-validation-report.md.
set -euo pipefail

cd "$(dirname "$0")/.."

REPORT="reports/opa-validation-report.md"
mkdir -p "$(dirname "$REPORT")"

if ! command -v opa >/dev/null; then
  echo "Installing OPA locally to ./opa"
  curl -sL -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static
  chmod +x opa
  OPA=./opa
else
  OPA=opa
fi

{
  echo "# OPA Validation Report"
  echo "_Generated: $(date -u)_"
  echo
} > "$REPORT"

FAIL=0
for f in deployments/*.yaml; do
  echo "## $f" >> "$REPORT"
  TMP=$(mktemp)
  python3 -c "import yaml,json,sys;print(json.dumps(yaml.safe_load(open('$f'))))" > "$TMP"
  OUT=$($OPA eval --format json --data policies/ --input "$TMP" "data.main.deny")
  COUNT=$(echo "$OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);print(len(d['result'][0]['expressions'][0]['value']))")
  if [ "$COUNT" = "0" ]; then
    echo "- Result: **PASS** (0 violations)" >> "$REPORT"
  else
    FAIL=1
    echo "- Result: **FAIL** ($COUNT violations)" >> "$REPORT"
    echo '```' >> "$REPORT"
    echo "$OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);[print('-',m) for m in d['result'][0]['expressions'][0]['value']]" >> "$REPORT"
    echo '```' >> "$REPORT"
  fi
  echo >> "$REPORT"
  rm -f "$TMP"
done

echo "Report: $REPORT"
exit $FAIL
