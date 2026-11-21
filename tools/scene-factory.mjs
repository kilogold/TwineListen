import { randomUUID } from 'node:crypto';
import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, readFileSync, renameSync, rmdirSync, writeFileSync } from 'node:fs';
import { basename, dirname, join } from 'node:path';
import { parseArgs } from 'node:util';

const scenePattern = /^c\d{2}\.s\d{2}$/;
const sharedTwee = 'src/main.twee';
const roles = ['brief', 'graph', 'twee'].flatMap(stage =>
  ['author', 'reviewer'].map(role => `twine-${stage}-${role}`));
const optionsByCommand = {
  start: { base: { type: 'string' }, revise: { type: 'boolean' } },
  revise: { rewrite: { type: 'boolean' }, audit: { type: 'boolean' } },
  continue: { approve: { type: 'string' } },
  finish: { 'approve-shared': { type: 'string' } },
  status: {}, resume: {}, checkpoint: {}, close: {},
};

function run(command, args, cwd = process.cwd()) {
  const result = spawnSync(command, args, { cwd, encoding: 'utf8', maxBuffer: 8 * 1024 * 1024 });
  if (result.error) throw result.error;
  if (result.status !== 0) {
    const diagnostic = [result.stdout, result.stderr].filter(Boolean).join('\n').trim();
    throw new Error(`${command} ${args[0]} failed (${result.signal ?? result.status})${diagnostic ? `\n${diagnostic}` : ''}`);
  }
  return result.stdout;
}

const git = (args, cwd) => run('git', args, cwd);
const head = cwd => git(['rev-parse', 'HEAD'], cwd).trim();
const dirtyPaths = cwd => git(['status', '--porcelain=v1', '-z', '--no-renames', '--untracked-files=all'], cwd)
  .split('\0').filter(Boolean).map(entry => entry.slice(3));

function attachedWorktree(state) {
  const cwd = state.worktree;
  const top = git(['rev-parse', '--show-toplevel'], cwd).trim();
  const branch = git(['symbolic-ref', '--short', 'HEAD'], cwd).trim();
  if (top !== cwd || branch !== state.branch) {
    throw new Error(`Expected ${state.branch} in ${cwd}. Restore that checkout before continuing.`);
  }
  return cwd;
}

function setup(state, save) {
  if (!existsSync(state.worktree)) {
    git(['worktree', 'add', '-b', state.branch, state.worktree, state.base], state.source);
  }
  const cwd = attachedWorktree(state);
  if (head(cwd) !== state.base || dirtyPaths(cwd).length) {
    throw new Error('Setup requires the selected base commit and a clean candidate checkout.');
  }
  run('rulesync', ['generate'], cwd);
  const missing = roles.filter(role => !existsSync(join(cwd, '.codex', 'agents', `${role}.toml`)));
  if (missing.length) throw new Error(`RuleSync did not install these roles: ${missing.join(', ')}`);
  if (dirtyPaths(cwd).length) throw new Error('RuleSync changed versioned or unignored files. Inspect the candidate before resuming.');
  state.phase = 'graph';
  save(state);
}

function graphChanges(state, paths) {
  const allowed = [`docs/briefs/${state.scene}.json`, 'docs/workspace.dsl'];
  const unexpected = paths.filter(path => !allowed.includes(path));
  if (unexpected.length) throw new Error(`Outside the brief and graph scope: ${unexpected.join(', ')}`);
}

function tweeChanges(state, paths, cwd, approvedShared) {
  const target = `src/${state.scene}.twee`;
  for (const path of paths) {
    if (path === target) continue;
    if (path === sharedTwee) {
      if (!approvedShared) throw new Error(`${sharedTwee} requires explicit approval via --approve-shared <blob-sha>.`);
      if (git(['diff', '--summary', 'HEAD', '--', path], cwd).trim()) {
        throw new Error(`Only content edits to ${sharedTwee} are allowed.`);
      }
      if (git(['hash-object', '--', path], cwd).trim() !== approvedShared) {
        throw new Error(`The approved hash does not match ${sharedTwee}. Review the current changes before approving again.`);
      }
      continue;
    }
    if (!/^src\/c\d{2}\.s\d{2}\.twee$/.test(path)) throw new Error(`Outside the Twee scope: ${path}`);

    // A neighboring scene can lose whole tagged stubs while its remaining bytes stay intact.
    const before = git(['show', `HEAD:${path}`], cwd);
    const file = join(cwd, path);
    const after = existsSync(file) ? readFileSync(file, 'utf8') : '';
    const passages = before.split(/(?=^::[ \t])/m);
    let offset = 0;
    for (const passage of passages) {
      if (after.startsWith(passage, offset)) {
        offset += passage.length;
      } else {
        const tags = /^::[ \t]+[^\[\r\n]+\[([^\]\r\n]*)\]/.exec(passage)?.[1];
        if (!tags?.split(/\s+/).includes('stub')) {
          throw new Error(`Only tagged stub removal is allowed in ${path}.`);
        }
      }
    }
    if (offset !== after.length) throw new Error(`Only tagged stub removal is allowed in ${path}.`);
  }
}

function recordCommit(state, cwd, phase, save) {
  const { from, tree, message } = state.pendingCommit;
  let commit = head(cwd);
  if (commit === from) {
    if (git(['write-tree'], cwd).trim() !== tree || git(['diff', '--name-only'], cwd) ||
        dirtyPaths(cwd).some(path => !state.pendingCommit.paths.includes(path))) {
      throw new Error('Files changed during the pending commit. Inspect the staged changes before resuming.');
    }
    if (state.pendingCommit.paths.length) {
      git(['commit', '-m', message], cwd);
      commit = head(cwd);
    }
  }
  if (dirtyPaths(cwd).length || git(['rev-parse', 'HEAD^{tree}'], cwd).trim() !== tree ||
      (commit !== from && git(['rev-parse', 'HEAD^'], cwd).trim() !== from)) {
    throw new Error('The candidate HEAD differs from the pending commit. Inspect it before resuming.');
  }
  state.head = commit;
  if (phase === 'checkpoint') state.checkpoint = commit;
  state.phase = phase === 'checkpoint' ? 'approval' : 'complete';
  delete state.pendingCommit;
  save(state);
}

function commitCandidate(state, cwd, command, save, approvedShared) {
  const paths = dirtyPaths(cwd);
  if (command === 'checkpoint') graphChanges(state, paths);
  else tweeChanges(state, paths, cwd, approvedShared);
  if (paths.length) git(['add', '-A', '--', ...paths], cwd);
  const tree = git(['write-tree'], cwd).trim();
  if (git(['diff', '--name-only', 'HEAD', tree, '--', sharedTwee], cwd).trim()) {
    const stagedHash = git(['rev-parse', '--verify', `${tree}:${sharedTwee}`], cwd).trim();
    const stagedMetadata = git(['diff', '--summary', 'HEAD', tree, '--', sharedTwee], cwd).trim();
    if (stagedHash !== approvedShared || stagedMetadata) {
      throw new Error(`${sharedTwee} changed while staging. Review the current changes before approving again.`);
    }
  }
  const message = command === 'checkpoint' ? `Review ${state.scene} graph` : `Implement ${state.scene} in Twee`;
  state.pendingCommit = { from: state.head, paths, tree, message, command };
  save(state);
  recordCommit(state, cwd, command, save);
}

function main() {
  const [command, ...args] = process.argv.slice(2);
  if (!Object.hasOwn(optionsByCommand, command)) {
    throw new Error('Usage: node tools/scene-factory.mjs <start|status|resume|revise|checkpoint|continue|finish|close> [scene]');
  }
  const { values, positionals } = parseArgs({ args, options: optionsByCommand[command], allowPositionals: true });
  const [scene] = positionals;
  if (command === 'status' ? positionals.length !== 0 : positionals.length !== 1 || !scenePattern.test(scene)) {
    throw new Error(command === 'status' ? 'Status takes no scene argument.' : 'Provide one scene ID in cNN.sNN format.');
  }
  if (command === 'start' && !values.base) throw new Error('Start requires --base <git-ref>.');
  if (command === 'continue' && !values.approve) throw new Error('Continue requires --approve <checkpoint-sha>.');
  if (values.audit && values.rewrite) throw new Error('Choose one of --audit or --rewrite.');

  const directory = join(git(['rev-parse', '--path-format=absolute', '--git-common-dir']).trim(), 'scene-factory');
  const active = join(directory, 'active.json');
  const lock = join(directory, 'lock');
  const read = () => {
    try {
      return JSON.parse(readFileSync(active, 'utf8'));
    } catch (error) {
      if (error.code === 'ENOENT') return null;
      throw error;
    }
  };
  const output = state => console.log(JSON.stringify(state ?? { phase: 'idle' }, null, 2));
  const save = state => {
    const temp = join(directory, `${randomUUID()}.json`);
    writeFileSync(temp, `${JSON.stringify(state, null, 2)}\n`, { flag: 'wx' });
    renameSync(temp, active);
  };
  if (command === 'status') return output(read());

  mkdirSync(directory, { recursive: true });
  try {
    mkdirSync(lock);
  } catch (error) {
    if (error.code !== 'EEXIST') throw error;
    throw new Error(`A factory command owns ${lock}. If interrupted, confirm it has exited before removing the empty lock directory.`);
  }
  try {
    let state = read();
    if (command === 'start') {
      if (state) throw new Error(`A run for ${state.scene} is already open in ${state.worktree}. Use $twine-factory status.`);
      const base = git(['rev-parse', '--verify', '--end-of-options', `${values.base}^{commit}`]).trim();
      git(['cat-file', '-e', `${base}:.rulesync/skills/twine-workflow/SKILL.md`]);
      const source = git(['worktree', 'list', '--porcelain', '-z']).split('\0')[0].slice('worktree '.length);
      const id = `${scene}-${randomUUID().slice(0, 8)}`;
      const record = join(directory, id);
      mkdirSync(record);
      state = {
        scene, base, source, branch: `codex/scene-${id}`,
        worktree: join(dirname(source), `${basename(source)}-${id}`),
        report: join(record, 'report.md'), phase: 'setup',
        operation: values.revise ? 'revise' : 'generate', head: base,
      };
      save(state);
      setup(state, save);
      return output(state);
    }

    if (!state || state.scene !== scene) throw new Error(`No open factory run for ${scene}. Use $twine-factory status.`);
    if (command === 'close') {
      renameSync(active, join(dirname(state.report), 'closed.json'));
      return output({ ...state, phase: 'closed' });
    }
    if (command === 'resume' && state.phase === 'setup') {
      setup(state, save);
      return output(state);
    }
    const cwd = attachedWorktree(state);
    if (state.pendingCommit) {
      if (command !== 'resume') throw new Error(`A factory commit is pending. Use $twine-factory resume ${scene}.`);
      recordCommit(state, cwd, state.pendingCommit.command, save);
    }
    if (head(cwd) !== state.head) throw new Error('The candidate branch moved outside the factory. Inspect it before proceeding.');
    if (command === 'resume') return output(state);

    if (command === 'revise') {
      if (!['approval', 'twee'].includes(state.phase)) throw new Error('Resume the current phase before starting a revision.');
      graphChanges(state, dirtyPaths(cwd));
      state.phase = 'graph';
      state.operation = values.rewrite ? 'generate' : values.audit ? 'audit' : 'revise';
      delete state.checkpoint;
      save(state);
    } else if (command === 'continue') {
      if (state.phase !== 'approval' || values.approve !== state.checkpoint) throw new Error('Approve the current graph checkpoint SHA.');
      if (dirtyPaths(cwd).length) throw new Error('The candidate changed after graph review. Inspect it and re-audit changed graph content before approval.');
      state.phase = 'twee';
      save(state);
    } else {
      const required = command === 'checkpoint' ? 'graph' : 'twee';
      if (state.phase !== required) throw new Error(`${command} requires the ${required} phase.`);
      commitCandidate(state, cwd, command, save, values['approve-shared']);
    }
    return output(state);
  } finally {
    rmdirSync(lock);
  }
}

try {
  main();
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}
