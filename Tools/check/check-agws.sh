#!/bin/sh
set -eu

TOOL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
AGWS_ROOT=$(CDPATH= cd -- "$TOOL_DIR/../.." && pwd)

for path in \
  AGENTS.md \
  README.md \
  CHANGELOG.md \
  index.html \
  about.html \
  contact.html \
  legal.html \
  architect.css \
  style.css; do
  if [ ! -e "$AGWS_ROOT/$path" ]; then
    echo "missing AGWS required path: $AGWS_ROOT/$path" >&2
    exit 1
  fi
done

if [ ! -d "$AGWS_ROOT/Tools/check" ]; then
  echo "AGWS required path must be a directory: $AGWS_ROOT/Tools/check" >&2
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

if ! grep -F 'Adlaire-Design採用方針' "$AGWS_ROOT/README.md" >/dev/null 2>&1; then
  echo "AGWS README must document the Adlaire-Design adoption policy." >&2
  exit 1
fi

for page in index.html about.html contact.html legal.html; do
  if ! grep -F '<link rel="stylesheet" href="architect.css">' "$AGWS_ROOT/$page" >/dev/null 2>&1; then
    echo "AGWS page must load architect.css: $page" >&2
    exit 1
  fi

  if ! grep -F '<link rel="stylesheet" href="style.css">' "$AGWS_ROOT/$page" >/dev/null 2>&1; then
    echo "AGWS page must load style.css: $page" >&2
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

if ! grep -F 'linear-gradient(135deg, #0066cc 0%, #0055aa 50%, #004499 100%)' "$AGWS_ROOT/style.css" >/dev/null 2>&1; then
  echo "AGWS style.css must keep the header 3-color blue gradient." >&2
  exit 1
fi

if ! grep -F '.content-wrapper' "$AGWS_ROOT/style.css" >/dev/null 2>&1; then
  echo "AGWS style.css must define the content wrapper layout." >&2
  exit 1
fi

echo "agws-check-ok"
