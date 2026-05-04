#!/usr/bin/env node

import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import { execFile } from 'child_process';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const RELEASE_DIR = 'githubrelease';
const SRC_GAMES_DIR = 'src/games';
const DEFAULT_ARCHITECTURES = ['x64'];
const ARCHITECTURE_ORDER = ['x86', 'x64', 'arm64'];
const KNOWN_ARCHITECTURES = new Set(ARCHITECTURE_ORDER);

const GAME_TARGET_DEPLOY_FIELDS = new Set([
  'steam_appid',
  'gog_product_id',
  'microsoft_store_id',
  'nexus_mods_game_id',
  'nexus_mods',
  'xbox_game',
  'platform',
  'game_exe',
  'process_name',
  'detection',
]);

function isGenericTitle(title) {
  return title === '(Generic)' || !title || title.trim() === '';
}

function slugify(value) {
  return String(value ?? '')
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
}

function getNexusGameId(deploy) {
  return deploy?.nexus_mods_game_id ?? deploy?.nexus_mods?.game_id ?? null;
}

function getDeployArchitectures(deploy = {}) {
  const configured = Array.isArray(deploy.architecture) && deploy.architecture.length > 0
    ? deploy.architecture
    : DEFAULT_ARCHITECTURES;
  const architectures = configured
    .map((architecture) => String(architecture).toLowerCase())
    .filter((architecture) => KNOWN_ARCHITECTURES.has(architecture));
  return new Set(architectures.length > 0 ? architectures : DEFAULT_ARCHITECTURES);
}

function formatArchitectures(architectures) {
  return ARCHITECTURE_ORDER
    .filter((architecture) => architectures.has(architecture))
    .join(', ');
}

function isDeployArchitectureSupported(deploy, arch) {
  return getDeployArchitectures(deploy).has(arch);
}

function getGameKey(game, mod) {
  const deploy = game.deploy ?? {};
  if (deploy.steam_appid != null) return `steam:${deploy.steam_appid}`;
  if (deploy.gog_product_id != null) return `gog:${deploy.gog_product_id}`;
  if (deploy.microsoft_store_id) return `microsoft:${deploy.microsoft_store_id}`;
  const nexusGameId = getNexusGameId(deploy);
  if (nexusGameId != null) return `nexus:${nexusGameId}`;
  if (game.id) return `id:${game.id}`;
  if (!isGenericTitle(game.title)) return `title:${slugify(game.title)}`;
  return `addon:${mod.id}`;
}

function hasDeployField(deploy, field) {
  return Object.prototype.hasOwnProperty.call(deploy ?? {}, field);
}

function mergeDeploy(existing = {}, incoming = {}) {
  const merged = { ...existing };
  for (const [key, value] of Object.entries(incoming)) {
    if (value === undefined) continue;
    if (value === null) {
      if (merged[key] === undefined) {
        merged[key] = null;
      }
      continue;
    }
    if (merged[key] === undefined || merged[key] === null) {
      merged[key] = value;
    }
  }
  return merged;
}

function mergeStringArrays(existing = [], incoming = []) {
  const merged = Array.isArray(existing) ? [...existing] : [];
  if (!Array.isArray(incoming)) return merged;
  for (const value of incoming) {
    if (typeof value !== 'string' || value === '') continue;
    if (!merged.includes(value)) merged.push(value);
  }
  return merged;
}

function getSharedDeploy(deploy = {}) {
  const shared = {};
  for (const [key, value] of Object.entries(deploy)) {
    if (GAME_TARGET_DEPLOY_FIELDS.has(key)) continue;
    shared[key] = value;
  }
  return shared;
}

function getGameTargets(mod) {
  if (Array.isArray(mod.games) && mod.games.length > 0) {
    const sharedDeploy = getSharedDeploy(mod.deploy);
    return mod.games.map((game) => ({
      ...game,
      header: game.header ?? mod.header,
      images: game.images ?? mod.images,
      deploy: mergeDeploy(game.deploy, sharedDeploy),
    }));
  }

  return [{
    title: mod.title,
    variant: mod.variant,
    support: mod.support,
    header: mod.header,
    images: mod.images,
    deploy: mod.deploy,
  }];
}

function buildGamesIndex(mods) {
  const games = new Map();

  for (const mod of mods) {
    for (const game of getGameTargets(mod)) {
      const artifacts = (mod.artifacts ?? []).filter((artifact) => isDeployArchitectureSupported(game.deploy, artifact.arch));
      if (artifacts.length === 0) continue;

      const key = getGameKey(game, mod);
      const title = isGenericTitle(game.title) ? mod.id : game.title;
      if (!title) continue;
      const header = typeof game.header === 'string' && game.header !== '' ? game.header : null;
      const images = mergeStringArrays([], game.images);

      if (!games.has(key)) {
        const entry = {
          id: game.id || slugify(title) || mod.id,
          title,
          aliases: game.aliases ?? [],
          deploy: game.deploy ?? {},
          mods: [],
        };
        if (header) entry.header = header;
        if (images.length > 0) entry.images = images;
        games.set(key, entry);
        if (hasDeployField(game.deploy, 'steam_appid')) {
          games.get(key).steam_appid = game.deploy.steam_appid;
        }
      }

      const gameEntry = games.get(key);
      gameEntry.deploy = mergeDeploy(gameEntry.deploy, game.deploy);
      if (!gameEntry.header && header) gameEntry.header = header;
      const mergedImages = mergeStringArrays(gameEntry.images, game.images);
      if (mergedImages.length > 0) gameEntry.images = mergedImages;
      if (hasDeployField(game.deploy, 'steam_appid') && gameEntry.steam_appid == null) {
        gameEntry.steam_appid = game.deploy.steam_appid;
      }

      gameEntry.mods.push({
        id: mod.id,
        title: mod.title,
        variant: game.variant ?? mod.variant ?? null,
        support: game.support ?? mod.support ?? null,
        artifacts,
      });
    }
  }

  return {
    games: Array.from(games.values()).sort((a, b) => a.title.localeCompare(b.title)),
  };
}

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
  } catch (error) {
    if (error?.code === 'ENOENT') return null;
    throw new Error(`Failed to read JSON at ${filepath}: ${error.message}`);
  }
}

async function main() {
  const start = Date.now();
  const releaseDir = path.resolve(RELEASE_DIR);
  const srcGamesDir = path.resolve(SRC_GAMES_DIR);
  const outputPath = path.join(releaseDir, 'generated-metadata.json');
  const gamesIndexPath = path.join(releaseDir, 'games-index.json');
  const schemaPath = path.join(releaseDir, 'renodx-metadata-schema.json');

  // Scan for addon files
  const files = await fs.readdir(releaseDir, { withFileTypes: true });
  const addonFiles = files
    .filter(f => f.isFile() && /^renodx-.+\.addon(32|64)$/i.test(f.name))
    .map(f => f.name);

  // Build artifacts and group by mod
  const mods = new Map();
  const modMetadata = new Map();
  const artifacts = [];
  const skippedArtifacts = [];

  async function loadModMetadata(modId) {
    if (!modMetadata.has(modId)) {
      const metadataPath = path.join(srcGamesDir, modId, 'metadata.json');
      const metadata = await readJson(metadataPath);
      modMetadata.set(modId, metadata ? {
        id: modId,
        ...metadata,
        artifacts: [],
      } : null);
    }
    return modMetadata.get(modId);
  }

  for (const name of addonFiles) {
    const match = name.match(/^renodx-(.+)\.(addon(64|32))$/i);
    if (!match) continue;

    const modId = match[1];
    const arch = match[2].toLowerCase() === 'addon64' ? 'x64' : 'x86';
    const mod = await loadModMetadata(modId);

    if (!mod) {
      skippedArtifacts.push({
        name,
        mod: modId,
        arch,
        reason: 'missing metadata',
      });
      continue;
    }

    if (!isDeployArchitectureSupported(mod.deploy, arch)) {
      const supportedArchitectures = formatArchitectures(getDeployArchitectures(mod.deploy));
      skippedArtifacts.push({
        name,
        mod: mod.id,
        arch,
        reason: `metadata supports ${supportedArchitectures}`,
      });
      continue;
    }

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
      mods.set(modId, mod);
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

  await fs.copyFile(path.resolve('renodx-metadata-schema.json'), schemaPath);
  await fs.writeFile(outputPath, JSON.stringify(output, null, 2));
  await fs.writeFile(gamesIndexPath, JSON.stringify(buildGamesIndex(output.mods), null, 2));
  console.log(`✅ Synced: ${schemaPath}`);
  console.log(`✅ Generated: ${outputPath}`);
  console.log(`✅ Generated: ${gamesIndexPath}`);
  console.log(`   ${stats.mods_count} mods, ${stats.artifacts_count} artifacts, ${(stats.total_size / 1024 / 1024).toFixed(2)} MB`);
  for (const skippedArtifact of skippedArtifacts) {
    if (skippedArtifact.reason === 'missing metadata') {
      console.warn(`⚠ Skipped ${skippedArtifact.name}: missing metadata for ${skippedArtifact.mod}.`);
      continue;
    }
    console.warn(`⚠ Skipped ${skippedArtifact.name}: ${skippedArtifact.arch} is not listed in ${skippedArtifact.mod} metadata (${skippedArtifact.reason}).`);
  }
}

main().catch((err) => {
  console.error('Error:', err);
  process.exit(1);
});
