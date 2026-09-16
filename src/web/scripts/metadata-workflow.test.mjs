import test from 'node:test';
import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import path from 'node:path';

const workflow = readFileSync(new URL('../../../.github/workflows/auto-merge-metadata.yml', import.meta.url), 'utf8');
const script = workflow.replaceAll('\r\n', '\n').split('          script: |\n')[1].split('\n').map(line => line.slice(12)).join('\n');
const execute = new (Object.getPrototypeOf(async function () {}).constructor)('require', 'process', 'context', 'github', 'core', script);

async function simulate({ approved = ['trusted'], files, metadata, draft = false, changedHead = false, valid = true } = {}) {
  const pr = { number: 1, state: 'open', draft, user: { login: 'Trusted' }, base: { sha: 'base' }, head: { sha: 'head' }, changed_files: files?.length ?? 1 };
  const merges = [];
  let gets = 0;
  await execute(name => {
    if (name === 'node:fs') return { readFileSync: () => '{}' };
    if (name === 'node:path') return path;
    if (name.endsWith('ajv-formats')) return () => {};
    return class { compile() { return () => valid; } errorsText() { return 'invalid metadata'; } };
  }, { env: { RUNNER_TEMP: '/tmp', APPROVED_CONTRIBUTORS: JSON.stringify(approved) } }, {
    repo: { owner: 'owner', repo: 'repo' }, payload: { pull_request: pr },
  }, {
    paginate: async () => files ?? [{ filename: 'src/games/test/metadata.json', status: 'modified', sha: 'blob' }],
    rest: {
      pulls: {
        listFiles() {},
        get: async () => ({ data: { ...pr, head: { sha: changedHead && gets++ ? 'new-head' : 'head' } } }),
        merge: async params => { merges.push(params); return { data: { merged: true } }; },
      },
      git: { getBlob: async () => ({ data: { size: 100, encoding: 'base64', content: Buffer.from(JSON.stringify(metadata ?? { id: 'test', title: 'Test' })).toString('base64') } }) },
    },
  }, { info() {}, setFailed(message) { throw new Error(message); } });
  return merges;
}

test('approved metadata merges only the validated SHA', async () => {
  assert.equal((await simulate())[0].sha, 'head');
});
test('empty allowlist and draft PRs never merge', async () => {
  assert.deepEqual(await simulate({ approved: [] }), []);
  assert.deepEqual(await simulate({ draft: true }), []);
});
test('mixed paths, deletions and renames never merge', async () => {
  for (const file of [
    { filename: 'src/games/test/addon.cpp', status: 'modified' },
    { filename: 'src/games/test/metadata.json', status: 'removed' },
    { filename: 'src/games/test/metadata.json', status: 'renamed' },
  ]) assert.deepEqual(await simulate({ files: [file] }), []);
});
test('invalid schema, mismatched ID and unsafe links fail closed', async () => {
  await assert.rejects(simulate({ valid: false }));
  await assert.rejects(simulate({ metadata: { id: 'other' } }));
  await assert.rejects(simulate({ metadata: { id: 'test', urls: [{ url: 'javascript:alert(1)' }] } }));
});
test('head changes during validation prevent merging', async () => {
  await assert.rejects(simulate({ changedHead: true }), /PR changed/);
});