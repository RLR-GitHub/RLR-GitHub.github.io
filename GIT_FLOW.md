# Git Flow Strategy - Portfolio Ecosystem

Complete reference for the Git Flow branching strategy used across the portfolio ecosystem.

## Overview

This repository uses **Git Flow**, a branching strategy that maintains separate branches for development, releases, and production. This enables parallel feature development, stable production releases, and hot-fixing of critical issues.

## Branch Architecture

```
main (production)
  └─ release/v2.1.0 ───┐
       │                 │
develop (integration)   │
  ├─ feature/resume     │
  ├─ feature/dark-mode  │
  ├─ bugfix/mobile-menu │
  ├─ chore/deps         │
       │                 │
       └─ hotfix/security-patch
           │
           └──→ merge both to develop and main
```

## Branch Types

### 1. **main** - Production Branch
- **Purpose**: Release-ready code deployed to production
- **Protection**: Requires pull request reviews, passes all checks
- **Who merges**: Release manager, team lead
- **Trigger**: Releases only (via release branches)
- **Deployment**: Auto-deploys to GitHub Pages (RLR-GitHub.github.io)

```bash
# View current main
git log main --oneline | head

# Create release from develop
git checkout -b release/v2.1.0 develop
```

### 2. **develop** - Integration Branch
- **Purpose**: Latest development version, feature integration
- **Protection**: Requires pull request reviews
- **Who merges**: Team members (via feature branch PRs)
- **Trigger**: Feature branches, bugfix branches
- **Deployment**: Can be pushed to staging/preview environment

```bash
# Sync develop locally
git checkout develop
git pull origin develop

# Create feature from develop
git checkout -b feature/my-feature develop
```

### 3. **feature/** - Feature Branches
- **Naming**: `feature/descriptive-name`
- **Created from**: develop
- **Merge back to**: develop (via pull request)
- **Lifetime**: Typically 1-2 weeks
- **Examples**:
  - `feature/resume-sync`
  - `feature/dark-mode`
  - `feature/mobile-optimization`
  - `feature/ecosystem-links`

```bash
# Create feature branch
git checkout develop
git pull origin develop
git checkout -b feature/resume-sync

# Work on feature...
git add .
git commit -m "feat: Add resume sync functionality"
git push -u origin feature/resume-sync

# Create pull request on GitHub
# After review and approval:
git checkout develop
git pull origin develop
git merge --no-ff feature/resume-sync
git push origin develop

# Cleanup
git branch -d feature/resume-sync
git push origin --delete feature/resume-sync
```

### 4. **bugfix/** - Bug Fix Branches
- **Naming**: `bugfix/descriptive-name`
- **Created from**: develop
- **Merge back to**: develop (via pull request)
- **Examples**:
  - `bugfix/mobile-menu`
  - `bugfix/footer-alignment`
  - `bugfix/form-validation`

```bash
# Create bugfix branch
git checkout develop
git pull origin develop
git checkout -b bugfix/mobile-menu

# Fix the bug...
git add .
git commit -m "fix: Mobile menu accessibility"
git push -u origin bugfix/mobile-menu

# Create pull request and merge when ready
```

### 5. **hotfix/** - Production Hotfix Branches
- **Naming**: `hotfix/descriptive-name`
- **Created from**: main
- **Merge to**: Both main AND develop
- **Tagging**: Create version tag (v2.0.1)
- **Examples**:
  - `hotfix/security-patch`
  - `hotfix/critical-bug`

```bash
# Create hotfix branch from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-bug

# Fix the critical issue...
git add .
git commit -m "fix: Critical security issue"

# Merge to main
git checkout main
git merge --no-ff hotfix/critical-bug
git tag -a v2.0.1 -m "Hotfix v2.0.1"
git push origin main --tags

# Merge back to develop to keep it updated
git checkout develop
git merge --no-ff hotfix/critical-bug
git push origin develop

# Cleanup
git branch -d hotfix/critical-bug
git push origin --delete hotfix/critical-bug
```

### 6. **release/** - Release Preparation Branches
- **Naming**: `release/v2.1.0`
- **Created from**: develop
- **Merge to**: Both main AND develop
- **Tagging**: Create version tag (v2.1.0)
- **Lifetime**: 1-2 days (final testing and minor fixes)

```bash
# Create release branch
git checkout develop
git pull origin develop
git checkout -b release/v2.1.0

# Make final adjustments, version bumps, etc.
# DO NOT add new features here

git add .
git commit -m "chore: Prepare v2.1.0 release"

# Merge to main
git checkout main
git pull origin main
git merge --no-ff release/v2.1.0
git tag -a v2.1.0 -m "Version 2.1.0"
git push origin main --tags

# Merge back to develop
git checkout develop
git merge --no-ff release/v2.1.0
git push origin develop

# Cleanup
git branch -d release/v2.1.0
git push origin --delete release/v2.1.0
```

### 7. **docs/** - Documentation Branches (Optional)
- **Naming**: `docs/descriptive-name`
- **Created from**: develop
- **Examples**:
  - `docs/api-documentation`
  - `docs/setup-guide`

## Version Numbering (Semantic Versioning)

Follow [Semantic Versioning](https://semver.org/) for release tags:

```
v<MAJOR>.<MINOR>.<PATCH>
v2.1.0 = Major.Minor.Patch

- MAJOR: Breaking changes (v2.0.0 → v3.0.0)
- MINOR: New features, backward compatible (v2.0.0 → v2.1.0)
- PATCH: Bug fixes, no new features (v2.0.0 → v2.0.1)
```

**Examples**:
- v2.0.0 - Initial v2 release (from v1.x)
- v2.0.1 - Hotfix after v2.0.0
- v2.1.0 - New features added to v2
- v2.1.1 - Bugfix in v2.1

## Commit Message Format

All commits should follow this format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation
- **style**: Code style (no logic change)
- **refactor**: Code refactoring
- **perf**: Performance improvement
- **test**: Test addition/modification
- **chore**: Build, dependencies, tooling

### Scope
Brief scope of the change:
- `resume`
- `accessibility`
- `mobile`
- `footer`
- `build`

### Examples

```
feat(resume): Add ecosystem navigation footer

Adds links to all portfolio sites (rory.computer, rory.engineer,
rory.software) in footer for better cross-domain navigation.

Closes #42
```

```
fix(accessibility): Mobile menu Escape key handling

Mobile menu now closes when user presses Escape key, improving
keyboard navigation accessibility.
```

```
chore(deps): Update tailwindcss to v3.4.1

Updates tailwindcss dependency to latest stable version.
```

## Workflow Examples

### Example 1: Adding a Feature

```bash
# 1. Start feature
git checkout develop
git pull origin develop
git checkout -b feature/dark-mode

# 2. Work on feature (multiple commits)
# ... edit files ...
git add .
git commit -m "feat(theme): Add dark mode toggle"

# ... more work ...
git add .
git commit -m "feat(theme): Update colors for dark mode"

# 3. Push to remote
git push -u origin feature/dark-mode

# 4. Create PR on GitHub
# (Wait for review and approval)

# 5. Merge to develop
git checkout develop
git pull origin develop
git merge --no-ff feature/dark-mode
git push origin develop

# 6. Cleanup
git branch -d feature/dark-mode
git push origin --delete feature/dark-mode
```

### Example 2: Releasing a Version

```bash
# 1. Create release branch
git checkout develop
git pull origin develop
git checkout -b release/v2.1.0

# 2. Update version numbers (if applicable)
# ... update package.json, README.md, etc. ...
git add .
git commit -m "chore: Bump version to v2.1.0"

# 3. Make any last-minute fixes
git add .
git commit -m "fix: Minor issue found during testing"

# 4. Merge to main
git checkout main
git pull origin main
git merge --no-ff release/v2.1.0 -m "Release v2.1.0"
git tag -a v2.1.0 -m "Version 2.1.0"
git push origin main --tags

# 5. Merge back to develop
git checkout develop
git merge --no-ff release/v2.1.0
git push origin develop

# 6. Cleanup
git branch -d release/v2.1.0
git push origin --delete release/v2.1.0

# 7. Deploy (if not automatic)
# GitHub Actions auto-deploys RLR-GitHub.github.io from main
```

### Example 3: Critical Hotfix

```bash
# 1. Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/security-issue

# 2. Fix the critical issue
# ... edit files ...
git add .
git commit -m "fix(security): Patch XSS vulnerability"

# 3. Merge to main with tag
git checkout main
git merge --no-ff hotfix/security-issue
git tag -a v2.0.1 -m "Hotfix v2.0.1"
git push origin main --tags

# 4. Merge to develop to keep updated
git checkout develop
git merge --no-ff hotfix/security-issue
git push origin develop

# 5. Cleanup
git branch -d hotfix/security-issue
git push origin --delete hotfix/security-issue
```

## Common Git Commands

### Update your local repository
```bash
# Fetch all changes from remote
git fetch origin

# Update develop branch
git checkout develop
git pull origin develop

# Update main branch
git checkout main
git pull origin main
```

### Check status
```bash
# Current branch and changes
git status

# See commit history
git log --oneline -10

# Compare branches
git log --oneline main..feature/my-feature
```

### Clean up
```bash
# Delete local branch
git branch -d feature/my-feature

# Delete remote branch
git push origin --delete feature/my-feature

# Clean up deleted remote branches locally
git fetch --prune origin
```

### Undo changes
```bash
# Unstage a file
git restore --staged file.txt

# Discard changes in a file
git restore file.txt

# View commit history
git log --oneline -5

# Revert a commit
git revert <commit-hash>

# Reset to previous commit (be careful!)
git reset --hard <commit-hash>
```

## Branch Naming Rules

✅ **DO:**
- Use lowercase: `feature/dark-mode` (not `Feature/Dark-Mode`)
- Use hyphens: `feature/add-dark-mode` (not `feature/add_dark_mode`)
- Be descriptive: `feature/ecosystem-nav` (not `feature/update`)
- Keep it concise: Max 50 characters
- Include scope: `feature/mobile-menu-fix` (not just `fix`)

❌ **DON'T:**
- Use uppercase or special characters
- Use underscores (use hyphens instead)
- Create branches with non-standard prefixes
- Use vague names like `feature/fix` or `feature/update`
- Create branches directly from main (use develop → release)

## Review Process

Before merging any branch to develop or main:

1. **Create Pull Request** on GitHub
2. **Request Reviewers** (at least 1 person)
3. **Await Review** - Reviewers check:
   - Code quality and style
   - No breaking changes
   - Tests pass
   - Documentation updated
   - Accessibility verified
4. **Address Feedback** - Add new commits, don't amend
5. **Get Approval** - All reviewers must approve
6. **Merge** - Use "Create a merge commit" (--no-ff)
7. **Delete Branch** - Remove feature branch

## GitHub Actions CI/CD

All pushes and PRs trigger automated checks:

- ✓ Validate (JSON, HTML, links)
- ✓ Build (create dist/ directory)
- ✓ Accessibility checks (ARIA labels, semantic HTML)
- ✓ Link verification (all links valid)

If any check fails:
1. Review the GitHub Actions output
2. Fix the issue locally
3. Commit the fix: `git add . && git commit --amend --no-edit`
4. Force push: `git push --force-with-lease origin feature/name`

## Synchronizing Across Repositories

For coordinated updates across multiple portfolio repositories:

```bash
# Create feature branches in all repos
./start-portfolio-dev.sh sync resume-update

# Make changes in each repo
cd /Users/rory/Projects/RLR-GitHub.github.io
git add . && git commit -m "feat: Update resume"
git push -u origin feature/resume-update

cd /Users/rory/Projects/rory.computer
git add . && git commit -m "feat: Update resume"
git push -u origin feature/resume-update

# Create PRs in each repo and merge together
# When all are approved, merge them together for consistency
```

## Troubleshooting

### Merge Conflicts

When merging causes conflicts:

```bash
# Check conflict status
git status

# Edit the conflicted files
# Look for <<<<<<< and >>>>>>>

# After resolving
git add .
git commit -m "Merge: Resolve conflicts with develop"
git push origin feature/name
```

### Accidentally Committed to Wrong Branch

```bash
# Check recent commits
git log --oneline -5

# Reset last commit (keep changes)
git reset --soft HEAD~1

# Switch to correct branch
git checkout feature/correct-name

# Re-commit
git add .
git commit -m "your message"
```

### Need to Update Feature Branch from Develop

```bash
# While on feature branch
git fetch origin
git rebase origin/develop

# Or merge (creates merge commit)
git merge --no-ff origin/develop

# Then push
git push --force-with-lease origin feature/name
```

## Resources

- [Atlassian Git Flow Tutorial](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub Flow (alternative)](https://guides.github.com/introduction/flow/)

---

**Last Updated:** December 2025
**Version:** 1.0.0
