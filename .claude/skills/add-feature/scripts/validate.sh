#!/usr/bin/env bash
# validate.sh — Quick syntax and structure checks for the Better Todo App
set -euo pipefail

echo "=== Better Todo App — Validation ==="
echo ""

ERRORS=0

# 1. Check Python syntax for all .py files
echo "--- Python syntax check ---"
for f in app/__init__.py app/models.py app/routes.py run.py; do
  if [ -f "$f" ]; then
    if python3 -c "import py_compile; py_compile.compile('$f', doraise=True)" 2>/dev/null; then
      echo "  OK   $f"
    else
      echo "  FAIL $f"
      ERRORS=$((ERRORS + 1))
    fi
  else
    echo "  SKIP $f (not found)"
  fi
done
echo ""

# 2. Check that all required files exist
echo "--- Required files ---"
for f in app/__init__.py app/models.py app/routes.py app/templates/base.html app/templates/index.html app/static/styles.css run.py requirements.txt; do
  if [ -f "$f" ]; then
    echo "  OK   $f"
  else
    echo "  MISS $f"
    ERRORS=$((ERRORS + 1))
  fi
done
echo ""

# 3. Check HTML templates for unclosed Jinja blocks
echo "--- Template block check ---"
for tmpl in app/templates/*.html; do
  if [ -f "$tmpl" ]; then
    OPENS=$(grep -c '{%.*block ' "$tmpl" 2>/dev/null || true)
    CLOSES=$(grep -c '{%.*endblock' "$tmpl" 2>/dev/null || true)
    if [ "$OPENS" -eq "$CLOSES" ]; then
      echo "  OK   $tmpl (blocks: $OPENS open, $CLOSES close)"
    else
      echo "  WARN $tmpl (blocks: $OPENS open, $CLOSES close — mismatch)"
      ERRORS=$((ERRORS + 1))
    fi
  fi
done
echo ""

# 4. Check CSS for unmatched braces
echo "--- CSS brace check ---"
if [ -f "app/static/styles.css" ]; then
  OPEN_BRACES=$(tr -cd '{' < app/static/styles.css | wc -c | tr -d ' ')
  CLOSE_BRACES=$(tr -cd '}' < app/static/styles.css | wc -c | tr -d ' ')
  if [ "$OPEN_BRACES" -eq "$CLOSE_BRACES" ]; then
    echo "  OK   styles.css (braces: $OPEN_BRACES open, $CLOSE_BRACES close)"
  else
    echo "  FAIL styles.css (braces: $OPEN_BRACES open, $CLOSE_BRACES close — mismatch!)"
    ERRORS=$((ERRORS + 1))
  fi
fi
echo ""

# Summary
if [ "$ERRORS" -eq 0 ]; then
  echo "=== ALL CHECKS PASSED ==="
else
  echo "=== $ERRORS ISSUE(S) FOUND ==="
  exit 1
fi
