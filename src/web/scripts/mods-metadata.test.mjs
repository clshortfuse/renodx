import test from 'node:test';
import assert from 'node:assert/strict';
import { buildGamesIndex } from '../../../scripts/generate-release-manifest.mjs';

test('external downloads and discussions do not require a local artifact', () => {
  const urls = [{ kind: 'discussion', url: 'https://github.com/example/repo/discussions/1' }];
  const { games } = buildGamesIndex([{ id: 'engine', title: 'Engine', category: 'engine', urls }]);
  assert.equal(games.length, 1);
  assert.deepEqual(games[0].mods[0].urls, urls);
  assert.deepEqual(games[0].mods[0].artifacts, []);
  assert.equal(games[0].mods[0].compatibility, 'unknown');
  assert.equal(games[0].mods[0].category, 'engine');
});

test('target metadata overrides status and combines notes and links', () => {
  const common = { kind: 'nexus', url: 'https://example.com/download' };
  const target = { kind: 'support', url: 'https://example.com/help' };
  const { games } = buildGamesIndex([{
    id: 'package', title: 'Package', compatibility: 'working', status: 'stable',
    maintainers: ['Contributor'], summary: 'Description', notes: ['Shared note'], urls: [common],
    games: [{ title: 'Game', compatibility: 'in-progress', status: 'beta', notes: ['Shared note', 'Issue'], urls: [common, target] }],
  }]);
  const mod = games[0].mods[0];
  assert.equal(mod.compatibility, 'in-progress');
  assert.equal(mod.status, 'beta');
  assert.deepEqual(mod.notes, ['Shared note', 'Issue']);
  assert.deepEqual(mod.urls, [common, target]);
  assert.deepEqual(mod.maintainers, ['Contributor']);
  assert.equal(mod.summary, 'Description');
});

test('unpublished entries without any downloads or links remain excluded', () => {
  assert.deepEqual(buildGamesIndex([{ id: 'unfinished', title: 'Unfinished' }]).games, []);
});

test('artifact architecture filtering remains intact', () => {
  const artifact = { arch: 'x86', url: './test.addon32' };
  const { games } = buildGamesIndex([{
    id: 'test', title: 'Test', deploy: { architecture: ['x86'] }, artifacts: [artifact, { arch: 'x64' }],
  }]);
  assert.deepEqual(games[0].mods[0].artifacts, [artifact]);
});