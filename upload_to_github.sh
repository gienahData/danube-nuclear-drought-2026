#!/usr/bin/env bash
# upload_to_github.sh
# ────────────────────────────────────────────────────────────────
# Creates the GitHub repository danube-nuclear-drought-2026 and
# uploads the working paper files in one shot.
#
# Prerequisites
#   - git installed
#   - gh (GitHub CLI) installed: https://cli.github.com/
#
# Usage
#   1. Install gh if needed:  brew install gh   (macOS)
#                              winget install GitHub.cli  (Windows)
#   2. Authenticate once:     gh auth login
#   3. Put the five files in the same folder as this script:
#        README.md
#        danube_figures.html
#        heat_stress.html
#        danube_nuclear.pdf
#        copula_joint_rp.py
#   4. Run:  bash upload_to_github.sh
# ────────────────────────────────────────────────────────────────

set -euo pipefail

REPO_NAME="danube-nuclear-drought-2026"
DESCRIPTION="Supplementary code and figures: Transboundary Climate–Nuclear Risk on the Danube (Szabó, 2026)"

# ── 1. Verify prerequisites ───────────────────────────────────────
echo "▶ Checking prerequisites..."
command -v gh  >/dev/null 2>&1 || { echo "❌  gh CLI not found — install from https://cli.github.com/"; exit 1; }
command -v git >/dev/null 2>&1 || { echo "❌  git not found — install git"; exit 1; }

gh auth status >/dev/null 2>&1 || {
  echo "❌  Not authenticated. Run:  gh auth login"
  exit 1
}

GITHUB_USER=$(gh api user --jq '.login')
echo "   Authenticated as: $GITHUB_USER"

# ── 2. Check required files ───────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REQUIRED=(README.md danube_figures.html heat_stress.html danube_nuclear.pdf copula_joint_rp.py)
for f in "${REQUIRED[@]}"; do
  [[ -f "$SCRIPT_DIR/$f" ]] || { echo "❌  Missing: $f  (put it next to this script)"; exit 1; }
done
echo "   All files found ✓"

# ── 3. Create repository ──────────────────────────────────────────
echo "▶ Creating repository $REPO_NAME..."
if gh repo view "$GITHUB_USER/$REPO_NAME" >/dev/null 2>&1; then
  echo "   Repository already exists — continuing with push."
else
  gh repo create "$REPO_NAME" \
    --public \
    --description "$DESCRIPTION" \
    --confirm 2>/dev/null || \
  gh repo create "$REPO_NAME" \
    --public \
    --description "$DESCRIPTION"
  echo "   Created: https://github.com/$GITHUB_USER/$REPO_NAME"
fi

# ── 4. Initialise git and commit ──────────────────────────────────
WORK_DIR=$(mktemp -d)
echo "▶ Preparing commit in $WORK_DIR..."

cd "$WORK_DIR"
git init -q
git remote add origin "https://github.com/$GITHUB_USER/$REPO_NAME.git"

for f in "${REQUIRED[@]}"; do
  cp "$SCRIPT_DIR/$f" .
done

git config user.email "szabo.tunde@geoinsight.hu"
git config user.name  "Tünde Szabó"

git add .
git commit -q -m "Add supplementary figures, paper, and copula analysis code

Files:
- danube_figures.html   : Figures 1–3 (discharge record, corridor map, copula RP)
- heat_stress.html      : Interactive heat-stress capacity-factor chart
- danube_nuclear.pdf    : Working paper
- copula_joint_rp.py    : Gumbel copula joint RP analysis (core scientific code)
- README.md             : Data sources, usage, citation"

# ── 5. Push ───────────────────────────────────────────────────────
echo "▶ Pushing to GitHub..."
git push -u origin main --force

# ── 6. Done ───────────────────────────────────────────────────────
echo ""
echo "✅  Upload complete!"
echo ""
echo "   Repository : https://github.com/$GITHUB_USER/$REPO_NAME"
echo "   Raw paper  : https://raw.githubusercontent.com/$GITHUB_USER/$REPO_NAME/main/danube_nuclear.pdf"
echo ""
echo "   ── Next steps (optional) ───────────────────────────────"
echo "   GitHub Pages (HTML viewer):"
echo "     gh api repos/$GITHUB_USER/$REPO_NAME/pages \\"
echo "       --method POST \\"
echo "       --field source[branch]=main \\"
echo "       --field source[path]=/"
echo ""
echo "   Zenodo DOI:"
echo "     1. Go to https://zenodo.org/account/settings/github/"
echo "     2. Toggle ON  $REPO_NAME"
echo "     3. Create a GitHub Release — Zenodo mints a DOI automatically"
echo "   ────────────────────────────────────────────────────────"

cd /
rm -rf "$WORK_DIR"
