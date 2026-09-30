import { build } from 'esbuild';
import { mkdir, readFile, writeFile, copyFile } from 'node:fs/promises';
const out = 'build/web';
await mkdir(out, { recursive: true });
await build({
  entryPoints: ['src/main.js'], outfile: `${out}/game.js`,
  bundle: true, format: 'iife', platform: 'browser', target: 'safari16',
  minify: true, legalComments: 'eof',
});
let html = await readFile('index.html', 'utf8');
html = html.replace(/<script type="importmap">[\s\S]*?<\/script>/, '')
  .replace('<script type="module" src="./src/main.js"></script>', '<script src="./game.js"></script>');
await writeFile(`${out}/index.html`, html);
await copyFile('LICENSE', `${out}/LICENSE.txt`);
for (const [name, source] of [
  ['three', 'node_modules/three/LICENSE'],
  ['rapier', 'node_modules/@dimforge/rapier3d-compat/LICENSE'],
]) await copyFile(source, `${out}/${name}-LICENSE.txt`);
console.log('Bundled game and physics locally in build/web.');
