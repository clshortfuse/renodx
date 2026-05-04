#!/usr/bin/env node
/**
 * Clean build artifacts
 */
import { rmSync, existsSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const outDir = join(__dirname, '../../../githubrelease');

console.log('Cleaning web build artifacts...');

const itemsToRemove = [
  join(outDir, 'index.html'),
  join(outDir, 'app.mjs'),
  join(outDir, 'favicon.ico')
];

for (const item of itemsToRemove) {
  if (existsSync(item)) {
    rmSync(item, { recursive: true, force: true });
    console.log(`  ✓ Removed ${item}`);
  }
}

console.log('✅ Clean complete!');
