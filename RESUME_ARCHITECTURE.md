# Resume Architecture Documentation
**Last Updated:** November 30, 2025
**Status:** Single Source of Truth Implementation ✅

---

## Overview

The portfolio ecosystem now uses a **centralized resume architecture** with a single master resume and automatic redirects from all legacy URLs.

## Master Resume (Single Source of Truth)

**Location:** `https://rory.engineer/__A1__HACKER_TERMINAL_RESUME.html`

**Repository:** `rory.engineer/__A1__HACKER_TERMINAL_RESUME.html`

This is the **ONLY** resume file that should be edited. All changes propagate automatically through AWS Amplify CI/CD.

---

## URL Mapping & Redirects

All resume URLs across the portfolio ecosystem redirect to the master resume:

### Active Redirects

| Legacy URL | Redirect Target | Status |
|------------|----------------|--------|
| `rodericklrenwick.com/__RLR_RESUME2025-v3.html` | `rory.engineer/__A1__HACKER_TERMINAL_RESUME.html` | ✅ Active |
| `rlr-github.github.io/__RLR_RESUME2025-v3.html` | `rory.engineer/__A1__HACKER_TERMINAL_RESUME.html` | ✅ Active |
| `rlr-github.github.io/2025resume.html` | `rory.engineer/__A1__HACKER_TERMINAL_RESUME.html` | ✅ Active |

### Redirect Implementation

Each redirect file (`__RLR_RESUME2025-v3.html`, `2025resume.html`) contains:
- **Meta refresh:** `<meta http-equiv="refresh" content="0;url=...">` (instant redirect)
- **JavaScript fallback:** `setTimeout()` redirect after 1 second
- **Manual link:** Clickable link for users if auto-redirect fails
- **Informational page:** Styled terminal-themed page explaining the redirect

---

## Benefits of This Architecture

### ✅ **Single Source of Truth**
- Only one file to update (`rory.engineer/__A1__HACKER_TERMINAL_RESUME.html`)
- No duplicate resume maintenance
- No synchronization issues

### ✅ **Automatic Updates**
- Edit master resume → Push to GitHub → AWS Amplify deploys → All URLs instantly show new content
- No need to update multiple copies across platforms

### ✅ **Consistent Data**
- Resume verification script passes 100% (19/19 tests)
- Graduation status, employment dates, experience descriptions always match
- No stale data on mirror sites

### ✅ **Backward Compatibility**
- All legacy resume URLs continue to work
- Old bookmarks/links automatically redirect
- SEO-friendly redirects (meta refresh + 200 status)

---

## Editing the Master Resume

### Quick Edit Process

1. **Navigate to repository:**
   ```bash
   cd /Users/rory/Projects/rory.engineer
   ```

2. **Edit the master resume:**
   ```bash
   # Edit __A1__HACKER_TERMINAL_RESUME.html
   ```

3. **Commit and push:**
   ```bash
   git add __A1__HACKER_TERMINAL_RESUME.html
   git commit -m "Update resume: [description]"
   git push
   ```

4. **AWS Amplify auto-deploys:**
   - Build takes ~5-10 minutes
   - Changes go live automatically
   - All redirect URLs instantly show new content

### What to Update

**Education Section:**
- Purdue M.S. graduation status
- UM-Dearborn B.S. information
- Focus areas and specializations

**Experience Section:**
- Employment dates (Summer 2023, Summer 2017, Summer 2018)
- Job titles and descriptions
- Company names

**Skills Section:**
- Technical skills
- Programming languages
- Tools and frameworks

**Projects Section:**
- Project descriptions
- Technologies used
- Links to demos

---

## Verification & Testing

### Resume Consistency Verification Script

**Location:** `/Users/rory/Projects/RLR-GitHub.github.io/verify-resume-consistency.sh`

**Run:**
```bash
cd /Users/rory/Projects/RLR-GitHub.github.io
./verify-resume-consistency.sh
```

**Expected Result:**
```
✓ ALL TESTS PASSED - Resume consistency verified!
Total Tests: 19
Passed: 19
Failed: 0
Pass Rate: 100%
```

### Tests Performed

1. **URL Accessibility (5 tests)**
   - rory.engineer (master)
   - rodericklrenwick.com (redirect)
   - rlr-github.github.io (redirect)
   - rory.computer (terminal CV)
   - GitHub profile

2. **Graduation Status (3 tests)**
   - Purdue "Graduated: December 2025"

3. **UM-Dearborn Graduation (3 tests)**
   - "Winter 2020"

4. **Experience Timelines (6 tests)**
   - Raytheon: Summer 2023
   - Ford: Summer 2017
   - MDAS.ai: Summer 2018

5. **Deprecated Language Check (2 tests)**
   - No "Expected 2025"
   - No "M.S. Candidate"

---

## Portfolio Ecosystem Map

```
┌─────────────────────────────────────────────────────────────┐
│ PORTFOLIO ECOSYSTEM - RESUME ARCHITECTURE                   │
└─────────────────────────────────────────────────────────────┘

MASTER RESUME (Source of Truth):
  ├─ rory.engineer/__A1__HACKER_TERMINAL_RESUME.html
  │  └─ AWS Amplify (auto-deployment)
  │     └─ GitHub: RLR-GitHub/rory.engineer

REDIRECT SITES (Point to Master):
  ├─ rodericklrenwick.com/__RLR_RESUME2025-v3.html → REDIRECT
  ├─ rlr-github.github.io/__RLR_RESUME2025-v3.html → REDIRECT
  └─ rlr-github.github.io/2025resume.html → REDIRECT

ALTERNATIVE CV FORMATS:
  ├─ rory.computer (Terminal CV - standalone format)
  └─ GitHub Profile README (embedded resume summary)
```

---

## Deployment Timeline

**Phase 1: Resume Updates (November 30, 2025)**
- ✅ Updated graduation status: "Graduated: December 2025"
- ✅ Added employment dates to master resume
- ✅ Fixed resume consistency issues

**Phase 2: Redirect Implementation (November 30, 2025)**
- ✅ Replaced `__RLR_RESUME2025-v3.html` with redirect
- ✅ Replaced `2025resume.html` with redirect
- ✅ Documented architecture (this file)

**Phase 3: Verification (November 30, 2025)**
- ✅ Created automated verification script
- ✅ All 19 tests passing (100%)
- ✅ Cross-platform consistency confirmed

---

## Troubleshooting

### Issue: Old Resume Content Showing After Update

**Cause:** CDN/browser cache
**Solution:** Wait 5-10 minutes for AWS Amplify deployment + CDN propagation
**Force refresh:** Ctrl+Shift+R (Windows/Linux) or Cmd+Shift+R (Mac)

### Issue: Redirect Not Working

**Cause:** JavaScript disabled or meta refresh blocked
**Solution:** Manual link provided on redirect page
**Fallback:** Direct link to master resume

### Issue: Resume Verification Script Fails

**Cause:** Recent update not yet deployed
**Solution:** Wait for AWS Amplify deployment (~10 minutes)
**Check:** View deployment status in AWS Amplify console

---

## Future Enhancements

### Potential Improvements

1. **PDF Generation:**
   - Add "Download PDF" button to master resume
   - Auto-generate PDF from HTML using html2pdf.js

2. **Version History:**
   - Track resume changes in git history
   - Add changelog to document major updates

3. **Analytics:**
   - Track which redirect URLs are most frequently accessed
   - Monitor resume page views across platforms

4. **SEO Optimization:**
   - Add structured data (JSON-LD) to master resume
   - Implement 301 permanent redirects (requires server config)

---

## Commit History

**Latest Resume Infrastructure Changes:**

```bash
# View recent commits
cd /Users/rory/Projects/RLR-GitHub.github.io
git log --oneline --grep="resume" -10

# Notable commits:
# 00e0468 - Replace resume copies with redirects to master resume
# eb4879f - Add automated resume consistency verification script
# [rory.engineer repo]
# 8304466 - Add employment dates to experience section
# ed1de52 - Update MASTER hacker terminal resume: Graduated December 2025
```

---

## Contact & Support

For questions about resume architecture or update procedures, see:
- **Deployment Guide:** `/Users/rory/Projects/rory.software/DEPLOYMENT_GUIDE.md`
- **Testing Checklist:** `/Users/rory/Projects/rory.software/TESTING_CHECKLIST.md`
- **This Document:** `/Users/rory/Projects/RLR-GitHub.github.io/RESUME_ARCHITECTURE.md`

---

**Generated:** November 30, 2025
**Author:** Roderick L. Renwick
**Maintained:** Automated via Claude Code
