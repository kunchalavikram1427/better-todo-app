#!/usr/bin/env bash
# lint.sh — Run quick static checks to supplement the code review
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/../../../.." && pwd)"
cd "$PROJECT_DIR"

echo "=== Quick Lint Checks ==="
echo ""

# 1. Check for hardcoded secrets
echo "--- Hardcoded secrets scan ---"
SECRETS_FOUND=0
if grep -rn "SECRET_KEY.*=.*['\"]" app/ run.py 2>/dev/null | grep -v "os.getenv"; then
  echo "  WARNING: Possible hardcoded secret found"
  SECRETS_FOUND=1
fi
if [ "$SECRETS_FOUND" -eq 0 ]; then
  echo "  OK — No hardcoded secrets in app code"
fi
echo ""

# 2. Check for debug mode in production configs
echo "--- Debug mode check ---"
if grep -rn "debug.*=.*True" app/ run.py 2>/dev/null | grep -v "getenv\|environ"; then
  echo "  WARNING: Hardcoded debug=True found"
else
  echo "  OK — Debug mode is environment-controlled"
fi
echo ""

# 3. Check for raw SQL
echo "--- Raw SQL check ---"
if grep -rn "db.engine.execute\|db.session.execute\|text(" app/ 2>/dev/null; then
  echo "  WARNING: Raw SQL found — verify parameterization"
else
  echo "  OK — No raw SQL detected (ORM-only)"
fi
echo ""

# 4. Check for |safe filter in templates
echo "--- Jinja2 |safe filter check ---"
if grep -rn '|.*safe' app/templates/ 2>/dev/null; then
  echo "  WARNING: |safe filter found — potential XSS risk"
else
  echo "  OK — No |safe filters in templates"
fi
echo ""

# 5. Check for TODO/FIXME/HACK comments
echo "--- Code debt markers ---"
MARKERS=$(grep -rn "TODO\|FIXME\|HACK\|XXX" app/ run.py 2>/dev/null || true)
if [ -n "$MARKERS" ]; then
  echo "$MARKERS" | while read -r line; do echo "  NOTE: $line"; done
else
  echo "  OK — No TODO/FIXME/HACK markers"
fi
echo ""

echo "=== Lint Complete ==="
