#!/usr/bin/env node
/**
 * Development mode for RenoDX web UI
 * Builds, watches for changes, and serves on http://localhost:8080
 */
import { watch } from 'fs';
import { spawn } from 'child_process';
import { createServer } from 'http';
import { readFile } from 'fs/promises';
import { join, dirname, extname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const srcDir = join(__dirname, '../static');
const outDir = join(__dirname, '../../../githubrelease');
const port = process.env.PORT || 8080;

let building = false;
let pendingBuild = false;

const mimeTypes = {
  '.html': 'text/html',
  '.mjs': 'text/javascript',
  '.js': 'text/javascript',
  '.json': 'application/json',
  '.css': 'text/css',
  '.ico': 'image/x-icon',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
};

function getRequestPath(req) {
  const requestPath = req.url.split('?')[0];
  return requestPath === '/' ? '/index.html' : requestPath;
}

function build() {
  if (building) {
    pendingBuild = true;
    return;
  }
  
  building = true;
  console.log('\n🔨 Building...');
  
  const proc = spawn(process.execPath, [join(__dirname, 'build.mjs')], {
    cwd: __dirname,
    stdio: 'inherit',
  });
  
  proc.on('close', (code) => {
    building = false;
    if (code === 0) {
      console.log('✓ Build complete at', new Date().toLocaleTimeString());
    }
    if (pendingBuild) {
      pendingBuild = false;
      build();
    }
  });
}

// Simple static file server
const server = createServer(async (req, res) => {
  let filePath = getRequestPath(req);
  filePath = join(outDir, filePath);
  
  const ext = extname(filePath);
  const contentType = mimeTypes[ext] || 'application/octet-stream';
  
  try {
    const content = await readFile(filePath);
    res.writeHead(200, { 'Content-Type': contentType });
    res.end(content);
  } catch (err) {
    if (err.code === 'ENOENT') {
      res.writeHead(404);
      res.end('Not Found');
    } else {
      res.writeHead(500);
      res.end('Server Error');
    }
  }
});

// Initial build
console.log('🚀 Starting dev mode...');
build();

// Start server
server.listen(port, () => {
  console.log(`\n🌐 Server running at http://localhost:${port}/`);
  console.log('👀 Watching for changes...\n');
});

// Watch for changes
const watcher = watch(srcDir, { recursive: true }, (eventType, filename) => {
  if (!filename) return;
  
  // Ignore node_modules and build outputs
  if (filename.includes('node_modules') || filename.includes('githubrelease')) {
    return;
  }
  
  // Only watch relevant files
  if (filename.endsWith('.html') || 
      filename.endsWith('.mjs') || 
      filename.endsWith('.js') ||
      filename.endsWith('.css') ||
      filename.startsWith('static')) {
    console.log(`📝 Changed: ${filename}`);
    build();
  }
});

// Handle cleanup
process.on('SIGINT', () => {
  console.log('\n👋 Stopping dev server...');
  watcher.close();
  server.close();
  process.exit(0);
});
