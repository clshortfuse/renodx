#!/usr/bin/env node
/**
 * Serve built files without watching (for production-like testing)
 */
import { createServer } from 'http';
import { readFile } from 'fs/promises';
import { join, dirname, extname } from 'path';
import { fileURLToPath } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const outDir = join(__dirname, '../../../githubrelease');
const port = process.env.PORT || 8080;

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
  '.addon64': 'application/octet-stream',
  '.addon32': 'application/octet-stream',
};

function getRequestPath(req) {
  const requestPath = req.url.split('?')[0];
  return requestPath === '/' ? '/index.html' : requestPath;
}

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

server.listen(port, () => {
  console.log(`🌐 Server running at http://localhost:${port}/`);
  console.log('Press Ctrl+C to stop');
});
