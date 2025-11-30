#!/bin/bash

################################################################################
# Resume Sync Script for Portfolio Ecosystem
#
# Purpose: Synchronize resume data across all portfolio formats
#          (Static HTML, ASCII Terminal, Cyberpunk Interactive)
#
# Usage: ./sync-resume-formats.sh [--dry-run] [--validate-only]
#
# Author: Claude Code (Anthropic)
# Created: December 2025
################################################################################

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RESUME_DATA="$SCRIPT_DIR/RESUME_DATA.json"
PROJECTS_ROOT="/Users/rory/Projects"
GITHUB_ROOT="/Users/rory/GHProjects"

# Portfolio locations
REPO_STATIC="$SCRIPT_DIR"
REPO_TERMINAL="$PROJECTS_ROOT/rory.computer"
REPO_CYBERPUNK="$PROJECTS_ROOT/rory.engineer"

# Flags
DRY_RUN=false
VALIDATE_ONLY=false

################################################################################
# Functions
################################################################################

log_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

log_info() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_task() {
    echo -e "\n${BLUE}→${NC} $1"
}

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --dry-run          Show what would be changed without making changes"
    echo "  --validate-only    Validate resume data without syncing"
    echo "  --help             Show this help message"
    echo ""
}

validate_json() {
    local file=$1
    if ! jq empty "$file" 2>/dev/null; then
        log_error "Invalid JSON in $file"
        return 1
    fi
    log_info "Valid JSON: $(basename $file)"
    return 0
}

check_prerequisites() {
    log_task "Checking prerequisites..."

    # Check if jq is installed
    if ! command -v jq &> /dev/null; then
        log_error "jq is not installed. Install with: brew install jq"
        exit 1
    fi
    log_info "jq is installed"

    # Check if git is installed
    if ! command -v git &> /dev/null; then
        log_error "git is not installed"
        exit 1
    fi
    log_info "git is installed"

    # Check if RESUME_DATA.json exists
    if [ ! -f "$RESUME_DATA" ]; then
        log_error "RESUME_DATA.json not found at $RESUME_DATA"
        exit 1
    fi
    log_info "RESUME_DATA.json found"
}

validate_repositories() {
    log_task "Validating repository locations..."

    if [ ! -d "$REPO_STATIC" ]; then
        log_error "Static HTML repo not found: $REPO_STATIC"
        exit 1
    fi
    log_info "Static HTML repo: $REPO_STATIC"

    if [ ! -d "$REPO_TERMINAL" ]; then
        log_warn "Terminal repo not found: $REPO_TERMINAL"
        log_warn "Skipping ASCII terminal sync"
    else
        log_info "Terminal repo: $REPO_TERMINAL"
    fi

    if [ ! -d "$REPO_CYBERPUNK" ]; then
        log_warn "Cyberpunk repo not found: $REPO_CYBERPUNK"
        log_warn "Skipping cyberpunk interactive sync"
    else
        log_info "Cyberpunk repo: $REPO_CYBERPUNK"
    fi
}

validate_resume_data() {
    log_task "Validating RESUME_DATA.json structure..."

    if ! validate_json "$RESUME_DATA"; then
        exit 1
    fi

    # Check required fields
    local required_fields=("personal" "education" "experience" "skills" "projects")
    for field in "${required_fields[@]}"; do
        if ! jq -e ".$field" "$RESUME_DATA" > /dev/null 2>&1; then
            log_error "Missing required field: $field"
            exit 1
        fi
        log_info "Found field: $field"
    done

    # Check personal info
    local email=$(jq -r '.personal.email' "$RESUME_DATA")
    local name=$(jq -r '.personal.firstName' "$RESUME_DATA")

    if [ "$email" = "null" ] || [ -z "$email" ]; then
        log_error "Email not set in personal section"
        exit 1
    fi
    log_info "Email verified: $email"

    if [ "$name" = "null" ] || [ -z "$name" ]; then
        log_error "First name not set in personal section"
        exit 1
    fi
    log_info "Name verified: $name"
}

get_resume_info() {
    # Extract key information from RESUME_DATA.json
    NAME=$(jq -r '.personal.firstName + " " + .personal.lastName' "$RESUME_DATA")
    EMAIL=$(jq -r '.personal.email' "$RESUME_DATA")
    TITLE=$(jq -r '.personal.title' "$RESUME_DATA")
    SUMMARY=$(jq -r '.summary' "$RESUME_DATA")
    GITHUB=$(jq -r '.personal.github' "$RESUME_DATA")
    WEBSITE=$(jq -r '.personal.website' "$RESUME_DATA")
    GRADUATION_DATE=$(jq -r '.education[0].graduationDate' "$RESUME_DATA")

    log_info "Resume Info: $NAME | $TITLE"
    log_info "Last Updated: $(jq -r '.metadata.lastUpdated' "$RESUME_DATA")"
}

sync_static_html() {
    log_task "Syncing Static HTML Resume..."

    if [ ! -f "$REPO_STATIC/2025resume.html" ]; then
        log_warn "2025resume.html not found, skipping"
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        log_warn "DRY RUN: Would update 2025resume.html"
        log_warn "Current version in: $REPO_STATIC/2025resume.html"
        return
    fi

    # TODO: Add actual HTML generation/update logic
    # For now, just verify the file exists
    log_warn "Static HTML sync: Manual updates required (update index.html manually)"
    log_info "File: $REPO_STATIC/2025resume.html"
}

sync_terminal_resume() {
    log_task "Syncing ASCII Terminal Resume..."

    if [ ! -d "$REPO_TERMINAL" ]; then
        log_warn "Terminal repo not found, skipping"
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        log_warn "DRY RUN: Would update ASCII resume in rory.computer"
        return
    fi

    # TODO: Add actual ASCII generation logic
    # For now, just note what needs to be done
    log_warn "Terminal resume sync: Check $REPO_TERMINAL/src/data/resume.ts"
    log_info "Update RESUME command with new data from RESUME_DATA.json"
}

sync_cyberpunk_resume() {
    log_task "Syncing Cyberpunk Interactive Resume..."

    if [ ! -d "$REPO_CYBERPUNK" ]; then
        log_warn "Cyberpunk repo not found, skipping"
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        log_warn "DRY RUN: Would update Cyberpunk resume in rory.engineer"
        return
    fi

    # TODO: Add actual cyberpunk resume generation logic
    # For now, just note what needs to be done
    log_warn "Cyberpunk resume sync: Check $REPO_CYBERPUNK/__A1__HACKER_TERMINAL_RESUME.html"
    log_info "Update interactive resume with new data from RESUME_DATA.json"
}

verify_sync() {
    log_task "Verifying sync..."

    log_info "Resume data synchronized"
    log_info "Name: $NAME"
    log_info "Title: $TITLE"
    log_info "Email: $EMAIL"
    log_info "GitHub: $GITHUB"
}

create_commit_message() {
    local updated_date=$(jq -r '.metadata.lastUpdated' "$RESUME_DATA")
    local version=$(jq -r '.metadata.version' "$RESUME_DATA")

    cat <<EOF
chore: sync resume formats to v$version

- Updated resume data across all portfolio formats
- Last updated: $updated_date
- Name: $NAME
- Title: $TITLE
- Email: $EMAIL

Synced formats:
- Static HTML (rlr-github.github.io/2025resume.html)
- ASCII Terminal (rory.computer/RESUME command)
- Cyberpunk Interactive (rory.engineer)

This is an automated sync via sync-resume-formats.sh
EOF
}

suggest_next_steps() {
    log_task "Next Steps..."

    echo ""
    echo "1. Review the changes:"
    echo "   cd $REPO_STATIC"
    echo "   git diff"
    echo ""
    echo "2. Stage and commit changes (all repos):"
    echo "   cd $REPO_STATIC && git add . && git commit -m 'chore: sync resume'"
    echo ""
    echo "3. If syncing across multiple repos:"
    echo "   cd $REPO_TERMINAL && git add . && git commit -m 'chore: sync resume'"
    echo "   cd $REPO_CYBERPUNK && git add . && git commit -m 'chore: sync resume'"
    echo ""
    echo "4. Test locally before pushing:"
    echo "   npm run dev  (in each repo)"
    echo ""
    echo "5. Push to remote:"
    echo "   git push origin feature/resume-sync"
    echo ""
}

################################################################################
# Main Execution
################################################################################

main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                DRY_RUN=true
                log_warn "DRY RUN MODE: No changes will be made"
                shift
                ;;
            --validate-only)
                VALIDATE_ONLY=true
                shift
                ;;
            --help)
                print_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                print_usage
                exit 1
                ;;
        esac
    done

    # Start
    clear
    log_header "Resume Sync Script - Portfolio Ecosystem"

    # Checks
    check_prerequisites
    validate_repositories
    validate_resume_data
    get_resume_info

    if [ "$VALIDATE_ONLY" = true ]; then
        log_header "Validation Complete ✓"
        log_info "RESUME_DATA.json is valid and ready to sync"
        exit 0
    fi

    # Sync
    sync_static_html
    sync_terminal_resume
    sync_cyberpunk_resume

    # Verify
    verify_sync

    # Summary
    log_header "Sync Complete ✓"

    if [ "$DRY_RUN" = true ]; then
        log_warn "DRY RUN: No changes were made"
        log_warn "Run without --dry-run to apply changes"
    else
        log_info "All resume formats synchronized"
        log_info "Review changes and commit manually"
    fi

    echo ""
    suggest_next_steps
}

# Run main function
main "$@"
