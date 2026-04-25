#!/usr/bin/env node
/**
 * Build script for RenoDX web UI
 * Copies source files to githubrelease/ for deployment
 */
import { copyFileSync, mkdirSync, readdirSync, statSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const srcDir = join(__dirname, '../static');
const outDir = join(__dirname, '../../../githubrelease');

console.log('Building RenoDX web UI...');
console.log('Source:', srcDir);
console.log('Output:', outDir);

// Ensure output directory exists
mkdirSync(outDir, { recursive: true });

console.log('Copying index.html...');
copyFileSync(join(srcDir, 'index.html'), join(outDir, 'index.html'));

console.log('Copying script.mjs as app.mjs...');
copyFileSync(join(srcDir, 'script.mjs'), join(outDir, 'app.mjs'));

// Copy static assets
console.log('Copying static assets...');
const staticFiles = readdirSync(srcDir);
for (const file of staticFiles) {
  if (file === 'index.html' || file === 'script.mjs') continue; // Already copied
  const srcPath = join(srcDir, file);
  if (statSync(srcPath).isFile()) {
    copyFileSync(srcPath, join(outDir, file));
    console.log(`  ✓ ${file}`);
  }
}

console.log('\n✅ Build complete!');
