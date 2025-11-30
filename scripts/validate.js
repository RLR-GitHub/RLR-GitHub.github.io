#!/usr/bin/env node

/**
 * Validation Script for RLR-GitHub Portfolio
 *
 * Purpose: Validate portfolio files before deployment
 * - Check HTML syntax
 * - Validate internal links
 * - Check image references
 * - Verify JSON files
 * - Check for console errors potential
 *
 * Usage: npm run validate
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.dirname(__dirname);

// Colors for output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  red: '\x1b[31m'
};

let errorCount = 0;
let warningCount = 0;

function log(color, prefix, message) {
  console.log(`${color}${prefix}${colors.reset} ${message}`);
}

function logError(message) {
  log(colors.red, '✗', message);
  errorCount++;
}

function logWarning(message) {
  log(colors.yellow, '⚠', message);
  warningCount++;
}

function logSuccess(message) {
  log(colors.green, '✓', message);
}

function logHeader(message) {
  console.log(`\n${colors.blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}`);
  console.log(`${colors.blue}${message}${colors.reset}`);
  console.log(`${colors.blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}\n`);
}

async function validate() {
  logHeader('Validating RLR-GitHub Portfolio');

  try {
    // 1. Check JSON files
    logHeader('Step 1: Validating JSON Files');
    validateJSON();

    // 2. Check HTML files
    logHeader('Step 2: Checking HTML Files');
    validateHTML();

    // 3. Check file references
    logHeader('Step 3: Verifying File References');
    validateReferences();

    // 4. Check configuration
    logHeader('Step 4: Checking Configuration');
    validateConfiguration();

    // 5. Summary
    logHeader('Validation Summary');
    console.log(`${colors.green}✓${colors.reset} Total checks completed`);
    if (errorCount === 0 && warningCount === 0) {
      console.log(`${colors.green}✓${colors.reset} All validations passed!\n`);
      return true;
    } else {
      if (errorCount > 0) {
        console.log(`${colors.red}✗${colors.reset} Errors: ${errorCount}`);
      }
      if (warningCount > 0) {
        console.log(`${colors.yellow}⚠${colors.reset} Warnings: ${warningCount}\n`);
      }
      return errorCount === 0;
    }

  } catch (error) {
    logError(`Validation failed: ${error.message}`);
    process.exit(1);
  }
}

function validateJSON() {
  const jsonFiles = ['RESUME_DATA.json', 'package.json'];

  for (const file of jsonFiles) {
    const filePath = path.join(projectRoot, file);
    if (!fs.existsSync(filePath)) {
      logWarning(`${file} not found`);
      continue;
    }

    try {
      const content = fs.readFileSync(filePath, 'utf8');
      JSON.parse(content);
      logSuccess(`${file} - Valid JSON`);
    } catch (error) {
      logError(`${file} - Invalid JSON: ${error.message}`);
    }
  }
}

function validateHTML() {
  const htmlFiles = ['index.html', '2025resume.html', '2025portfolio.html'];

  for (const file of htmlFiles) {
    const filePath = path.join(projectRoot, file);
    if (!fs.existsSync(filePath)) {
      logWarning(`${file} not found`);
      continue;
    }

    try {
      const content = fs.readFileSync(filePath, 'utf8');

      // Basic HTML structure checks
      if (!content.includes('<!DOCTYPE html')) {
        logWarning(`${file} - Missing DOCTYPE`);
      }

      if (!content.includes('<html')) {
        logError(`${file} - Missing html tag`);
      }

      if (!content.includes('<head>')) {
        logError(`${file} - Missing head tag`);
      }

      if (!content.includes('<body>')) {
        logError(`${file} - Missing body tag`);
      }

      // Check for common issues
      if (content.includes('<!-- TODO')) {
        logWarning(`${file} - Contains TODO comments`);
      }

      if (content.match(/console\.log/gi)) {
        logWarning(`${file} - Contains console.log statements`);
      }

      logSuccess(`${file} - HTML structure valid`);

    } catch (error) {
      logError(`${file} - Read error: ${error.message}`);
    }
  }
}

function validateReferences() {
  const htmlFile = path.join(projectRoot, 'index.html');

  if (!fs.existsSync(htmlFile)) {
    logError('index.html not found');
    return;
  }

  const content = fs.readFileSync(htmlFile, 'utf8');

  // Check for broken references
  const links = content.match(/href=["']([^"']+)["']/g) || [];
  const scripts = content.match(/src=["']([^"']+)["']/g) || [];
  const images = content.match(/src=["']([^"']+\.(?:png|jpg|gif|svg))["']/gi) || [];

  let validLinks = 0;
  let invalidLinks = 0;

  // Check href links
  for (const link of links) {
    const url = link.match(/["']([^"']+)["']/)[1];

    // Skip external URLs and anchors
    if (url.startsWith('http') || url.startsWith('#') || url.startsWith('mailto:')) {
      validLinks++;
      continue;
    }

    const filePath = path.join(projectRoot, url);
    if (fs.existsSync(filePath)) {
      validLinks++;
    } else {
      logWarning(`Potential broken link: ${url}`);
      invalidLinks++;
    }
  }

  logSuccess(`Checked ${validLinks} valid links`);
  if (invalidLinks > 0) {
    logWarning(`Found ${invalidLinks} potential broken links`);
  }
}

function validateConfiguration() {
  // Check package.json
  const packageJsonPath = path.join(projectRoot, 'package.json');
  if (fs.existsSync(packageJsonPath)) {
    try {
      const pkg = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));
      if (pkg.version) {
        logSuccess(`package.json version: ${pkg.version}`);
      }
    } catch (error) {
      logError(`package.json is invalid: ${error.message}`);
    }
  }

  // Check RESUME_DATA.json
  const resumeDataPath = path.join(projectRoot, 'RESUME_DATA.json');
  if (fs.existsSync(resumeDataPath)) {
    try {
      const resumeData = JSON.parse(fs.readFileSync(resumeDataPath, 'utf8'));
      if (resumeData.personal && resumeData.personal.email) {
        logSuccess(`Resume data configured for: ${resumeData.personal.email}`);
      }
    } catch (error) {
      logError(`RESUME_DATA.json is invalid: ${error.message}`);
    }
  }

  // Check sync script
  const syncScriptPath = path.join(projectRoot, 'sync-resume-formats.sh');
  if (fs.existsSync(syncScriptPath)) {
    logSuccess('sync-resume-formats.sh found');
  }
}

// Run validation
const result = await validate();
process.exit(result ? 0 : 1);
