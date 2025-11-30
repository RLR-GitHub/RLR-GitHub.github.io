# Contributing to Portfolio Ecosystem

This document outlines the development workflow for the portfolio ecosystem, which spans multiple coordinated repositories.

## Overview

The portfolio ecosystem consists of specialized repositories that serve different audiences:

- **RLR-GitHub.github.io** - Main portfolio & resume hub (GitHub Pages hosted)
- **https_website_server3.0** - Core website (r0ry.com)
- **rory.computer** - Cyberpunk terminal easter egg (ASCII art resume)
- **rory.engineer** - Recruitment page (Interactive cyberpunk resume)
- **rory.software** - Software projects showcase

All repositories follow a coordinated Git Flow strategy with synchronized updates.

## Git Flow Strategy

### Branch Naming Conventions

- **main** - Production-ready code, deployed to live sites
- **develop** - Integration branch for features, tested before merging to main
- **feature/** - New features (`feature/resume-update`, `feature/dark-mode`)
- **bugfix/** - Bug fixes (`bugfix/mobile-menu`, `bugfix/link-validation`)
- **hotfix/** - Critical production fixes (`hotfix/security-patch`)
- **docs/** - Documentation updates (`docs/contributing-guide`)
- **chore/** - Maintenance tasks (`chore/update-dependencies`)

### Branch Naming Rules

- Use lowercase letters and hyphens (kebab-case)
- Be descriptive but concise (max 50 characters)
- Examples of good names:
  - `feature/resume-sync-automation`
  - `bugfix/footer-alignment`
  - `docs/git-flow-guide`
  - `chore/update-tailwind`

## Workflow

### 1. Starting a Feature

```bash
# Update develop branch
git checkout develop
git pull origin develop

# Create feature branch from develop
git checkout -b feature/your-feature-name

# Start developing...
```

### 2. Making Commits

- Keep commits atomic and focused
- Write clear, descriptive commit messages
- Use imperative mood ("Add X" not "Added X")

**Commit message format:**
```
<type>: <description>

<optional detailed explanation>

🤖 Generated with Claude Code (if AI-assisted)

Co-Authored-By: Claude <noreply@anthropic.com> (if AI-assisted)
```

**Commit types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring without feature changes
- `perf`: Performance improvements
- `test`: Test additions/modifications
- `chore`: Build, dependencies, tooling

**Examples:**
```
feat: Add ecosystem navigation footer

Adds links to all portfolio sites in footer for better cross-domain navigation.

Closes #42
```

```
fix: Mobile menu Escape key handling

Mobile menu now closes when user presses Escape key for better accessibility.
```

### 3. Pushing and Creating Pull Request

```bash
# Push feature branch to remote
git push -u origin feature/your-feature-name

# Create pull request on GitHub
# - Title: Use commit message format
# - Description: Explain what changed and why
# - Link related issues
```

### 4. Code Review and Merge

- Request review from team members
- Address feedback by adding new commits (don't amend)
- Once approved, merge to develop:
  ```bash
  git checkout develop
  git pull origin develop
  git merge --no-ff feature/your-feature-name
  git push origin develop
  ```

### 5. Release to Production

When ready to release:

```bash
# Create release branch
git checkout -b release/v2.1.0 develop

# Update version numbers if applicable
# Make final adjustments

# Merge to main
git checkout main
git pull origin main
git merge --no-ff release/v2.1.0 -m "Release v2.1.0"
git tag -a v2.1.0 -m "Version 2.1.0"
git push origin main --tags

# Merge back to develop to keep it updated
git checkout develop
git merge --no-ff release/v2.1.0
git push origin develop

# Delete release branch
git branch -d release/v2.1.0
git push origin --delete release/v2.1.0
```

### 6. Hotfixes for Production Issues

```bash
# Create hotfix branch from main
git checkout -b hotfix/critical-issue origin/main

# Fix the issue...

# Merge to main
git checkout main
git merge --no-ff hotfix/critical-issue
git tag -a v2.0.1 -m "Hotfix v2.0.1"
git push origin main --tags

# Merge back to develop
git checkout develop
git merge --no-ff hotfix/critical-issue
git push origin develop

# Delete hotfix branch
git branch -d hotfix/critical-issue
git push origin --delete hotfix/critical-issue
```

## Cross-Repository Updates

### Master Resume Data

Resume information is managed through **RESUME_DATA.json** in RLR-GitHub.github.io:

```json
{
  "personalInfo": { "name", "email", "phone", "location" },
  "education": [...],
  "experience": [...],
  "skills": [...],
  "projects": [...],
  "certifications": [...],
  "coursework": [...]
}
```

When resume data changes:

1. **Update RESUME_DATA.json** in RLR-GitHub.github.io
2. **Sync to other formats** (ASCII terminal, cyberpunk interactive) using sync script
3. **Update all affected repositories** with new resume content

### Coordinated Updates

When updating multiple repositories simultaneously:

```bash
# Create feature branches in each repo with the same name
for repo in RLR-GitHub.github.io rory.computer rory.engineer rory.software
do
  cd /Users/rory/Projects/$repo
  git checkout -b feature/resume-update
  # Make updates...
  git push -u origin feature/resume-update
done

# Create PRs in each repo and merge together
```

## Testing Before Commit

### Run Validation

```bash
npm run validate
```

This checks:
- JSON files for valid syntax
- HTML structure and required elements
- File references and links
- Configuration validity

### Run Build

```bash
npm run build
```

This creates optimized dist/ directory with:
- Minified HTML, CSS, JavaScript
- Image optimization
- Asset bundling

### Local Testing

```bash
npm run dev
# Visit http://localhost:8000
```

Test on:
- Desktop (Chrome, Firefox, Safari)
- Mobile (iPhone, Android)
- Keyboard navigation (Tab, Enter, Escape)
- Accessibility (ARIA labels, semantic HTML)

## Repository-Specific Guidelines

### RLR-GitHub.github.io

- Master resume source (RESUME_DATA.json)
- Portfolio hub and ecosystem navigation
- Build automation and CI/CD pipelines
- Shared documentation

**Update process:**
1. Create feature branch from develop
2. Update RESUME_DATA.json or other content
3. Run `npm run validate && npm run build`
4. Test locally
5. Create PR to develop
6. Merge and deploy

### rory.computer & rory.engineer

- Specialized resume formats (ASCII, cyberpunk)
- Separate Git Flow workflows
- Synced from RESUME_DATA.json in RLR-GitHub.github.io
- Can have independent feature branches

### https_website_server3.0 & rory.software

- Independent feature development
- Coordinated updates with portfolio ecosystem
- Can have specialized branches as needed

## Code Style & Standards

### HTML
- Use semantic HTML5 elements
- Include ARIA labels and roles where appropriate
- Ensure keyboard navigation support
- Test on screen readers

### CSS
- Use Tailwind CSS utility classes
- Avoid inline styles
- Follow existing design system
- Ensure responsive design (mobile-first)

### JavaScript
- Use modern ES6+ syntax
- Keep functions small and focused
- Add comments for complex logic
- Test keyboard interactions

### Commits
- One feature or fix per commit when possible
- Keep commits small and reviewable
- Reference related issues: `Closes #123`

## Code Review Checklist

Before approving a PR, verify:

- [ ] Code follows style guidelines
- [ ] Commits are atomic and well-documented
- [ ] Changes don't break existing functionality
- [ ] Tests pass (if applicable)
- [ ] Documentation is updated
- [ ] Accessibility standards are met
- [ ] Mobile responsive design is verified
- [ ] Performance hasn't degraded

## Merge Conflicts

When encountering merge conflicts:

```bash
# Resolve conflicts in your editor
git add .
git commit -m "Merge: Resolve conflicts with develop"
git push origin feature/your-feature
```

## Deployment

### Automatic Deployment (GitHub Pages)

RLR-GitHub.github.io auto-deploys to GitHub Pages from `main` branch.

### Manual Testing

Before merging to main:
1. Test on develop branch
2. Verify locally at http://localhost:8000
3. Run `npm run build` successfully
4. Check GitHub Actions build passes

## Questions & Support

- Check existing documentation in `CONTRIBUTING.md`, `README.md`
- Review past commits for examples: `git log --oneline`
- Check GitHub Issues for discussions
- Create detailed issue with steps to reproduce bugs

## License

All code in the portfolio ecosystem follows the existing LICENSE of each repository.

---

**Last Updated:** December 2025
**Version:** 1.0.0
