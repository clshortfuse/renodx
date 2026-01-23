#!/usr/bin/env node

import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { execFile } from 'child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const RELEASE_DIR = 'githubrelease';
const SRC_GAMES_DIR = 'src/games';

function execGit(args, cwd) {
  return new Promise((resolve) => {
    execFile('git', args, { cwd }, (err, stdout) => {
      if (err) return resolve(null);
      resolve(stdout.trim());
    });
  });
}

async function getCommit(cwd) {
  const fmt = '%H\n%h\n%an\n%ae\n%ad\n%s';
  const out = await execGit(['log', '-1', '--date=iso-strict', `--pretty=format:${fmt}`], cwd);
  if (!out) return {};
  const [sha, short_sha, author_name, author_email, date, message] = out.split('\n');
  return {
    sha,
    short_sha,
    author: { name: author_name, email: author_email },
    date,
    message,
  };
}

async function getBranch(cwd) {
  const branch = await execGit(['rev-parse', '--abbrev-ref', 'HEAD'], cwd);
  return (branch && branch !== 'HEAD') ? branch : process.env.GITHUB_REF || null;
}

async function readJson(filepath) {
  try {
    return JSON.parse(await fs.readFile(filepath, 'utf8'));
  } catch {
    return null;
  }
}

async function main() {
  const start = Date.now();
  const releaseDir = path.resolve(RELEASE_DIR);
  const srcGamesDir = path.resolve(SRC_GAMES_DIR);
  const outputPath = path.join(releaseDir, 'generated-metadata.json');

  // Scan for addon files
  const files = await fs.readdir(releaseDir, { withFileTypes: true });
  const addonFiles = files
    .filter(f => f.isFile() && /^renodx-.+\.addon(32|64)$/i.test(f.name))
    .map(f => f.name);

  // Build artifacts and group by mod
  const mods = new Map();
  const artifacts = [];

  for (const name of addonFiles) {
    const match = name.match(/^renodx-(.+)\.(addon(64|32))$/i);
    if (!match) continue;

    const modId = match[1];
    const arch = match[2].toLowerCase() === 'addon64' ? 'x64' : 'x86';
    const stat = await fs.stat(path.join(releaseDir, name));

    const artifact = {
      name,
      mod: modId,
      arch,
      size: stat.size,
      url: `./${name}`,
      path: `./${name}`,
    };
    artifacts.push(artifact);

    if (!mods.has(modId)) {
      const metadataPath = path.join(srcGamesDir, modId, 'metadata.json');
      const metadata = await readJson(metadataPath);
      mods.set(modId, {
        id: modId,
        ...metadata,
        artifacts: [],
      });
    }
    mods.get(modId).artifacts.push(artifact);
  }

  // Compute stats
  const stats = {
    mods_count: mods.size,
    artifacts_count: artifacts.length,
    total_size: artifacts.reduce((sum, a) => sum + a.size, 0),
    x64_count: artifacts.filter(a => a.arch === 'x64').length,
    x86_count: artifacts.filter(a => a.arch === 'x86').length,
  };

  // Git info
  const commit = await getCommit(path.resolve('.'));
  const branch = await getBranch(path.resolve('.'));

  const output = {
    $schema: './renodx-metadata-schema.json',
    schema_version: '1.0.0',
    generated_at: new Date().toISOString(),
    source: {
      repo: process.env.GITHUB_REPOSITORY || null,
      branch,
      commit,
    },
    build: {
      tool_version: 'generate-release-manifest.mjs',
      host: process.env.COMPUTERNAME || null,
      duration_ms: Date.now() - start,
    },
    mods: Array.from(mods.values()),
    artifacts,
    stats,
  };

  await fs.writeFile(outputPath, JSON.stringify(output, null, 2));
  console.log(`✅ Generated: ${outputPath}`);
  console.log(`   ${stats.mods_count} mods, ${stats.artifacts_count} artifacts, ${(stats.total_size / 1024 / 1024).toFixed(2)} MB`);
}

main().catch((err) => {
  console.error('Error:', err);
  process.exit(1);
});
