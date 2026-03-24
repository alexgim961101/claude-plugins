#!/usr/bin/env bash
#
# install-antigravity.sh — Install smart plugin for Antigravity
#
# Usage:
#   bash install-antigravity.sh            # Install (symlink)
#   bash install-antigravity.sh --uninstall # Remove symlinks
#
set -euo pipefail

ANTIGRAVITY_DIR="${HOME}/.gemini/antigravity"
SKILLS_DIR="${ANTIGRAVITY_DIR}/skills"
WORKFLOWS_DIR="${ANTIGRAVITY_DIR}/global_workflows"

# Resolve the plugin source directory (where this script lives)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="${SCRIPT_DIR}/plugins/smart"

SKILL_NAMES=("init" "spec" "plan" "impl" "review")

# ─────────────────────────────────────────
# Colors
# ─────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

info()  { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# ─────────────────────────────────────────
# Uninstall
# ─────────────────────────────────────────
uninstall() {
    info "Uninstalling smart plugin from Antigravity..."
    local removed=0

    for name in "${SKILL_NAMES[@]}"; do
        local skill_link="${SKILLS_DIR}/smart-${name}"
        if [[ -L "$skill_link" || -e "$skill_link" ]]; then
            rm -rf "$skill_link"
            ok "Removed skill: smart-${name}"
            ((removed++))
        fi

        local workflow_link="${WORKFLOWS_DIR}/smart-${name}.md"
        if [[ -L "$workflow_link" || -e "$workflow_link" ]]; then
            rm -f "$workflow_link"
            ok "Removed workflow: smart-${name}.md"
            ((removed++))
        fi
    done

    if [[ $removed -eq 0 ]]; then
        warn "Nothing to uninstall — no smart plugin files found."
    else
        ok "Uninstalled ${removed} items."
    fi
}

# ─────────────────────────────────────────
# Install
# ─────────────────────────────────────────
install() {
    info "Installing smart plugin for Antigravity..."
    echo ""

    # Validate source
    if [[ ! -d "$PLUGIN_DIR" ]]; then
        error "Plugin directory not found: ${PLUGIN_DIR}"
        exit 1
    fi

    if [[ ! -d "${PLUGIN_DIR}/skills" ]]; then
        error "Skills directory not found: ${PLUGIN_DIR}/skills"
        exit 1
    fi

    if [[ ! -d "${PLUGIN_DIR}/workflows" ]]; then
        error "Workflows directory not found: ${PLUGIN_DIR}/workflows"
        exit 1
    fi

    # Validate target directories exist
    if [[ ! -d "$SKILLS_DIR" ]]; then
        error "Antigravity skills directory not found: ${SKILLS_DIR}"
        error "Is Antigravity installed?"
        exit 1
    fi

    if [[ ! -d "$WORKFLOWS_DIR" ]]; then
        error "Antigravity global_workflows directory not found: ${WORKFLOWS_DIR}"
        error "Is Antigravity installed?"
        exit 1
    fi

    # Check for existing installation
    local existing=0
    for name in "${SKILL_NAMES[@]}"; do
        if [[ -e "${SKILLS_DIR}/smart-${name}" || -e "${WORKFLOWS_DIR}/smart-${name}.md" ]]; then
            ((existing++))
        fi
    done

    if [[ $existing -gt 0 ]]; then
        warn "Existing installation detected (${existing} items)."
        read -rp "Overwrite? [y/N] " answer
        if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
            info "Aborted."
            exit 0
        fi
        # Remove existing links first
        uninstall
        echo ""
    fi

    # Install skills (symlink directories)
    info "Installing skills..."
    for name in "${SKILL_NAMES[@]}"; do
        local src="${PLUGIN_DIR}/skills/${name}"
        local dest="${SKILLS_DIR}/smart-${name}"

        if [[ ! -d "$src" ]]; then
            warn "Skill source not found, skipping: ${src}"
            continue
        fi

        ln -s "$src" "$dest"
        ok "  smart-${name} → ${src}"
    done

    echo ""

    # Install workflows (symlink files)
    info "Installing workflows..."
    for name in "${SKILL_NAMES[@]}"; do
        local src="${PLUGIN_DIR}/workflows/smart-${name}.md"
        local dest="${WORKFLOWS_DIR}/smart-${name}.md"

        if [[ ! -f "$src" ]]; then
            warn "Workflow source not found, skipping: ${src}"
            continue
        fi

        ln -s "$src" "$dest"
        ok "  smart-${name}.md → ${src}"
    done

    echo ""
    ok "Installation complete!"
    echo ""
    info "Available slash commands in Antigravity:"
    for name in "${SKILL_NAMES[@]}"; do
        echo "  /smart-${name}"
    done
    echo ""
    info "To uninstall: bash $(basename "$0") --uninstall"
}

# ─────────────────────────────────────────
# Main
# ─────────────────────────────────────────
case "${1:-}" in
    --uninstall|-u)
        uninstall
        ;;
    --help|-h)
        echo "Usage: bash $(basename "$0") [--uninstall|--help]"
        echo ""
        echo "Install the smart plugin for Antigravity."
        echo "Creates symlinks in ~/.gemini/antigravity/ for skills and workflows."
        echo ""
        echo "Options:"
        echo "  --uninstall, -u   Remove all smart plugin symlinks"
        echo "  --help, -h        Show this help message"
        ;;
    "")
        install
        ;;
    *)
        error "Unknown option: $1"
        echo "Usage: bash $(basename "$0") [--uninstall|--help]"
        exit 1
        ;;
esac
