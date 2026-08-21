#!/bin/sh
set -eu

TOOL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
AGWS_ROOT=$(CDPATH= cd -- "$TOOL_DIR/../.." && pwd)
ADLAIRE_DESIGN_ROOT=$(CDPATH= cd -- "$AGWS_ROOT/../Adlaire-Design" 2>/dev/null && pwd || true)
TMP_DIR="${TMPDIR:-/tmp}/agws-check.$$"

mkdir -p "$TMP_DIR"
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM

for path in \
  AGENTS.md \
  README.md \
  CHANGELOG.md \
  index.html \
  about.html \
  contact.html \
  legal.html \
  architect.css \
  style.css \
  adlaire-design/Tokens/colors.css \
  adlaire-design/Tokens/surface.css \
  adlaire-design/Tokens/status.css \
  adlaire-design/Tokens/effects.css \
  adlaire-design/UI/adlaire.css \
  adlaire-design/UI/base.css \
  adlaire-design/UI/grid.css \
  adlaire-design/UI/layout.css \
  adlaire-design/UI/components.css \
  adlaire-design/UI/site.css \
  adlaire-design/UI/forms.css \
  adlaire-design/UI/content.css \
  adlaire-design/UI/utilities.css \
  adlaire-design/UI/compat-agws.css; do
  if [ ! -e "$AGWS_ROOT/$path" ]; then
    echo "missing AGWS required path: $AGWS_ROOT/$path" >&2
    exit 1
  fi
done

if [ ! -d "$AGWS_ROOT/Tools/check" ]; then
  echo "AGWS required path must be a directory: $AGWS_ROOT/Tools/check" >&2
  exit 1
fi

if [ ! -d "$AGWS_ROOT/adlaire-design" ]; then
  echo "AGWS required path must be a directory: $AGWS_ROOT/adlaire-design" >&2
  exit 1
fi

if find "$AGWS_ROOT" \( -name 'package.json' -o -name 'package-lock.json' -o -name 'node_modules' \) -print | grep . >/dev/null 2>&1; then
  echo "AGWS must not use Node.js/npm project files." >&2
  exit 1
fi

if find "$AGWS_ROOT" -name '*.js' -print | grep . >/dev/null 2>&1; then
  echo "AGWS Ver.0.6 must not depend on JavaScript files." >&2
  exit 1
fi

if ! grep -F '# Adlaire Group Web Site' "$AGWS_ROOT/README.md" >/dev/null 2>&1; then
  echo "AGWS README must identify the repository." >&2
  exit 1
fi

if ! grep -F 'Architect CSS' "$AGWS_ROOT/README.md" >/dev/null 2>&1; then
  echo "AGWS README must reference Architect CSS." >&2
  exit 1
fi

if ! grep -F 'Adlaire-Design CSS' "$AGWS_ROOT/README.md" >/dev/null 2>&1; then
  echo "AGWS README must reference Adlaire-Design CSS." >&2
  exit 1
fi

if ! grep -F 'Adlaire-Design全面採用方針' "$AGWS_ROOT/README.md" >/dev/null 2>&1; then
  echo "AGWS README must document the Adlaire-Design full adoption policy." >&2
  exit 1
fi

if ! grep -F '全面採用の確定事項' "$AGWS_ROOT/README.md" >/dev/null 2>&1; then
  echo "AGWS README must document the full adoption decisions." >&2
  exit 1
fi

if ! grep -F 'Adlaire-Design CSSは全面採用済み' "$AGWS_ROOT/AGENTS.md" >/dev/null 2>&1; then
  echo "AGWS AGENTS.md must document the Adlaire-Design CSS full adoption policy." >&2
  exit 1
fi

cat >"$TMP_DIR/expected-css-order" <<'EOF'
adlaire-design/Tokens/colors.css
adlaire-design/Tokens/surface.css
adlaire-design/Tokens/status.css
adlaire-design/Tokens/effects.css
adlaire-design/UI/adlaire.css
adlaire-design/UI/base.css
adlaire-design/UI/grid.css
adlaire-design/UI/layout.css
adlaire-design/UI/components.css
adlaire-design/UI/site.css
adlaire-design/UI/forms.css
adlaire-design/UI/content.css
adlaire-design/UI/utilities.css
adlaire-design/UI/compat-agws.css
EOF

for page in index.html about.html contact.html legal.html; do
  grep -Eo '<link rel="stylesheet" href="[^"]+">' "$AGWS_ROOT/$page" \
    | sed 's/^<link rel="stylesheet" href="//' \
    | sed 's/">$//' >"$TMP_DIR/$page-css-order"

  if ! cmp -s "$TMP_DIR/expected-css-order" "$TMP_DIR/$page-css-order"; then
    echo "AGWS page must load Adlaire-Design CSS files in the required order: $page" >&2
    diff -u "$TMP_DIR/expected-css-order" "$TMP_DIR/$page-css-order" >&2 || true
    exit 1
  fi

  if grep -F '<link rel="stylesheet" href="architect.css">' "$AGWS_ROOT/$page" >/dev/null 2>&1; then
    echo "AGWS formal migration pages must not load legacy architect.css directly: $page" >&2
    exit 1
  fi

  if grep -F '<link rel="stylesheet" href="style.css">' "$AGWS_ROOT/$page" >/dev/null 2>&1; then
    echo "AGWS formal migration pages must not load legacy style.css directly: $page" >&2
    exit 1
  fi

  if ! grep -F 'class="site-header"' "$AGWS_ROOT/$page" >/dev/null 2>&1; then
    echo "AGWS page must include site-header: $page" >&2
    exit 1
  fi

  if ! grep -F 'class="main-content"' "$AGWS_ROOT/$page" >/dev/null 2>&1; then
    echo "AGWS page must include main-content: $page" >&2
    exit 1
  fi

  if ! grep -F 'class="site-footer"' "$AGWS_ROOT/$page" >/dev/null 2>&1; then
    echo "AGWS page must include site-footer: $page" >&2
    exit 1
  fi
done

if [ -n "$ADLAIRE_DESIGN_ROOT" ] && [ -d "$ADLAIRE_DESIGN_ROOT" ]; then
  for css in \
    Tokens/colors.css \
    Tokens/surface.css \
    Tokens/status.css \
    Tokens/effects.css \
    UI/adlaire.css \
    UI/base.css \
    UI/grid.css \
    UI/layout.css \
    UI/components.css \
    UI/site.css \
    UI/forms.css \
    UI/content.css \
    UI/utilities.css \
    UI/compat-agws.css; do
    if ! cmp -s "$ADLAIRE_DESIGN_ROOT/$css" "$AGWS_ROOT/adlaire-design/$css"; then
      echo "AGWS vendored Adlaire-Design CSS differs from source: $css" >&2
      exit 1
    fi
  done
fi

if ! grep -F '`architect.css` と `style.css` は直接読み込まず、ロールバック用の既存CSSとして維持する。' "$AGWS_ROOT/README.md" >/dev/null 2>&1; then
  echo "AGWS README must document legacy CSS as rollback-only after full adoption." >&2
  exit 1
fi

if ! grep -F '`architect.css` と `style.css` は、当面はロールバック用の既存CSSとして維持し、削除しないこと。' "$AGWS_ROOT/AGENTS.md" >/dev/null 2>&1; then
  echo "AGWS AGENTS.md must keep the legacy CSS rollback policy." >&2
  exit 1
fi

echo "agws-check-ok"
