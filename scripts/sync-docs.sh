#!/usr/bin/env bash
# =============================================================================
# sync-docs.sh
# Fetches markdown docs from github.com/gomlx/gomlx and converts them into
# Hugo-ready content pages with proper front matter.
#
# Usage:
#   ./scripts/sync-docs.sh              # fetch latest from main
#   ./scripts/sync-docs.sh v0.17.0      # fetch a specific tag
#
# Requirements: curl, jq
# =============================================================================

set -euo pipefail

REPO="gomlx/gomlx"
BRANCH="${1:-main}"
API_BASE="https://api.github.com/repos/${REPO}"
RAW_BASE="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
OUT_DIR="$(dirname "$0")/../content/docs"
WEIGHT=10   # incremented per file for sidebar ordering

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()    { echo -e "${CYAN}[sync]${NC} $*"; }
success() { echo -e "${GREEN}[done]${NC} $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC} $*"; }

# ── Fetch file list from GitHub API ─────────────────────────────────────────

HUGO_TOML="$(dirname "$0")/../hugo.toml"

if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
  info "Fetching latest GoMLX release version for hugo.toml..."
  LATEST_VERSION=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" | jq -r '.tag_name')
  if [[ -n "$LATEST_VERSION" && "$LATEST_VERSION" != "null" ]]; then
    info "Updating hugo.toml with version: $LATEST_VERSION"
    sed -i.bak -E "s/version[ ]*=[ ]*\".*\"/version = \"${LATEST_VERSION}\"/" "$HUGO_TOML"
  else
    warn "Could not fetch latest release version. Keeping current version."
  fi
else
  info "Updating hugo.toml with version: $BRANCH"
  sed -i.bak -E "s/version[ ]*=[ ]*\".*\"/version = \"${BRANCH}\"/" "$HUGO_TOML"
fi
rm -f "${HUGO_TOML}.bak"

info "Fetching file list from ${REPO}/docs (branch: ${BRANCH})..."
FILES=$(curl -fsSL "${API_BASE}/contents/docs?ref=${BRANCH}" \
  -H "Accept: application/vnd.github.v3+json" \
  | jq -r '.[] | select(.type=="file") | select(.name | endswith(".md")) | .name')

if [[ -z "$FILES" ]]; then
  warn "No markdown files found in /docs. Check the branch name or API rate limit."
  exit 1
fi

mkdir -p "$OUT_DIR"

# ── Helper: derive a clean title from filename ──────────────────────────────
to_title() {
  echo "$1" \
    | sed 's/\.md$//' \
    | sed 's/[-_]/ /g' \
    | sed 's/\b\(.\)/\u\1/g'
}

# ── Helper: infer section label from filename prefix ────────────────────────
to_section() {
  case "$1" in
    context*|graph*|tensor*|node*|backend*) echo "Reference" ;;
    train*|loss*|optim*|metric*)            echo "Training"  ;;
    layer*|dense*|conv*|attention*)         echo "Layers"    ;;
    example*|mnist*|cifar*|transformer*)    echo "Examples"  ;;
    install*|quick*|start*|intro*)          echo "Get started" ;;
    *)                                       echo "Guides"    ;;
  esac
}

# ── Process each file ────────────────────────────────────────────────────────
for FNAME in $FILES; do
  RAW_URL="${RAW_BASE}/docs/${FNAME}"
  SLUG=$(echo "$FNAME" | sed 's/\.md$//' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g')
  TITLE=$(to_title "$FNAME")
  SECTION=$(to_section "$SLUG")
  OUT_FILE="${OUT_DIR}/${SLUG}.md"

  info "Fetching ${FNAME}..."
  CONTENT=$(curl -fsSL "$RAW_URL")

  # Strip a leading H1 if it matches the title (Hugo renders the title itself)
  BODY=$(echo "$CONTENT" | sed '/^# /{ /^# /{ N; s/^# .*\n//; } }')

  # Write Hugo front matter + body
  cat > "$OUT_FILE" <<FRONTMATTER
---
title: "${TITLE}"
section: "${SECTION}"
weight: ${WEIGHT}
source: "https://github.com/${REPO}/blob/${BRANCH}/docs/${FNAME}"
---

${BODY}
FRONTMATTER

  success "→ content/docs/${SLUG}.md"
  WEIGHT=$((WEIGHT + 10))
done

# ── Also pull the root README as a "what is GoMLX" overview page ────────────
info "Fetching root README.md as overview..."
README=$(curl -fsSL "${RAW_BASE}/README.md")

# Keep only the first ~80 lines (the intro section) to avoid duplication
INTRO=$(echo "$README" | head -n 120)

cat > "${OUT_DIR}/overview.md" <<FRONTMATTER
---
title: "What is GoMLX?"
section: "Get started"
weight: 1
source: "https://github.com/${REPO}/blob/${BRANCH}/README.md"
---

${INTRO}

> This page is excerpted from the [full README](https://github.com/${REPO}). For complete documentation, browse the sections in the sidebar.
FRONTMATTER

success "→ content/docs/overview.md"

echo ""
success "Sync complete. $(echo "$FILES" | wc -w | tr -d ' ') doc files written to content/docs/"
echo ""
echo "  Next steps:"
echo "  1. Run 'hugo server' to preview"
echo "  2. Check content/docs/ and tweak front matter weights/sections as needed"
echo "  3. Commit the synced files to your repo"
