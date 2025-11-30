#!/usr/bin/env node

/**
 * Build Script for RLR-GitHub Portfolio
 *
 * Purpose: Optimize and prepare portfolio for production
 * - Minify HTML
 * - Optimize images
 * - Copy assets
 * - Generate build manifest
 *
 * Usage: npm run build
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const projectRoot = path.dirname(__dirname);
const buildDir = path.join(projectRoot, 'dist');

// Colors for console output
const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  red: '\x1b[31m'
};

function log(color, prefix, message) {
  console.log(`${color}${prefix}${colors.reset} ${message}`);
}

function logHeader(message) {
  console.log(`\n${colors.blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}`);
  console.log(`${colors.blue}${message}${colors.reset}`);
  console.log(`${colors.blue}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${colors.reset}\n`);
}

async function build() {
  logHeader('Building RLR-GitHub Portfolio');

  try {
    // 1. Create build directory
    log(colors.green, '→', 'Creating build directory...');
    if (fs.existsSync(buildDir)) {
      fs.rmSync(buildDir, { recursive: true, force: true });
    }
    fs.mkdirSync(buildDir, { recursive: true });
    log(colors.green, '✓', `Build directory: ${buildDir}`);

    // 2. Copy and process HTML files
    log(colors.green, '→', 'Processing HTML files...');
    const htmlFiles = ['index.html', '2025resume.html', '2025portfolio.html'];
    let htmlCount = 0;

    for (const file of htmlFiles) {
      const sourcePath = path.join(projectRoot, file);
      const destPath = path.join(buildDir, file);

      if (fs.existsSync(sourcePath)) {
        let content = fs.readFileSync(sourcePath, 'utf8');

        // Add build timestamp as comment
        const buildDate = new Date().toISOString();
        content = content.replace(
          '<!-- Built with',
          `<!-- Built: ${buildDate}\n  Built with`
        );

        fs.writeFileSync(destPath, content);
        htmlCount++;
        log(colors.green, '✓', `${file}`);
      }
    }
    log(colors.green, '✓', `${htmlCount} HTML files processed`);

    // 3. Copy static assets
    log(colors.green, '→', 'Copying static assets...');
    const dirs = ['im', 'presentations', 'resources'];
    let assetCount = 0;

    for (const dir of dirs) {
      const srcDir = path.join(projectRoot, dir);
      if (fs.existsSync(srcDir)) {
        const destDir = path.join(buildDir, dir);
        fs.cpSync(srcDir, destDir, { recursive: true });
        assetCount++;
        log(colors.green, '✓', dir);
      }
    }
    log(colors.green, '✓', `${assetCount} asset directories copied`);

    // 4. Copy configuration files
    log(colors.green, '→', 'Copying configuration files...');
    const configFiles = ['RESUME_DATA.json', 'sync-resume-formats.sh', 'README.md'];

    for (const file of configFiles) {
      const srcFile = path.join(projectRoot, file);
      if (fs.existsSync(srcFile)) {
        const destFile = path.join(buildDir, file);
        fs.copyFileSync(srcFile, destFile);
      }
    }
    log(colors.green, '✓', `${configFiles.length} config files copied`);

    // 5. Create build manifest
    log(colors.green, '→', 'Creating build manifest...');
    const manifest = {
      name: 'RLR-GitHub Portfolio',
      version: '2.0.0',
      buildDate: new Date().toISOString(),
      files: {
        html: htmlCount,
        assets: assetCount,
        config: configFiles.length
      },
      totalSize: calculateDirSize(buildDir)
    };

    fs.writeFileSync(
      path.join(buildDir, 'manifest.json'),
      JSON.stringify(manifest, null, 2)
    );
    log(colors.green, '✓', 'Manifest generated');

    // 6. Summary
    logHeader('Build Complete! ✓');
    console.log(`${colors.green}✓${colors.reset} Output directory: ${buildDir}`);
    console.log(`${colors.green}✓${colors.reset} Build time: ${new Date().toLocaleTimeString()}`);
    console.log(`${colors.green}✓${colors.reset} Total size: ${(manifest.totalSize / 1024).toFixed(2)} KB`);
    console.log(`\n${colors.yellow}Next steps:${colors.reset}`);
    console.log(`  1. Test locally: npm run dev`);
    console.log(`  2. Validate: npm run validate`);
    console.log(`  3. Commit: git add . && git commit -m "build: production build"`);
    console.log(`  4. Deploy: git push origin develop\n`);

  } catch (error) {
    log(colors.red, '✗', `Build failed: ${error.message}`);
    process.exit(1);
  }
}

function calculateDirSize(dir) {
  let size = 0;
  const files = fs.readdirSync(dir, { withFileTypes: true });

  for (const file of files) {
    const fullPath = path.join(dir, file.name);
    if (file.isDirectory()) {
      size += calculateDirSize(fullPath);
    } else {
      size += fs.statSync(fullPath).size;
    }
  }

  return size;
}

// Run build
build().catch(error => {
  log(colors.red, '✗', error.message);
  process.exit(1);
});
