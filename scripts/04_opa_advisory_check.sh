#!/usr/bin/env bash
# Validate examples/ (intentionally-bad manifests) and append result to the OPA report.
# Useful to show the FAIL case in the deliverables.
set -euo pipefail

cd "$(dirname "$0")/.."

OPA=${OPA:-./opa}
[ -x "$OPA" ] || { curl -sL -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64_static; chmod +x opa; OPA=./opa; }

REPORT="reports/opa-validation-report.md"

for f in examples/*.yaml; do
  TMP=$(mktemp)
  python3 -c "import yaml,json;print(json.dumps(yaml.safe_load(open('$f'))))" > "$TMP"
  OUT=$($OPA eval --format json --data policies/ --input "$TMP" "data.main.deny")
  COUNT=$(echo "$OUT" | python3 -c "import sys,json;d=json.load(sys.stdin);print(len(d['result'][0]['expressions'][0]['value']))")
  {
    echo ""
    echo "## $f (advisory — must FAIL)"
    echo "- Result: **FAIL** ($COUNT violations)"
    echo '```'
    echo "$OUT" | python3 -c "import sys,json;[print('-',m) for m in json.load(sys.stdin)['result'][0]['expressions'][0]['value']]"
    echo '```'
  } >> "$REPORT"
  rm -f "$TMP"
done

echo "Appended advisory results to $REPORT"
