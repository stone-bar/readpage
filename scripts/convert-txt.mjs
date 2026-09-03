import { mkdir, readdir, readFile, writeFile } from 'node:fs/promises'
import { basename, extname, join } from 'node:path'

const inputDir = join(process.cwd(), 'inbox')
const outputDir = join(process.cwd(), 'docs', 'articles')

await mkdir(outputDir, { recursive: true })
let files
try {
  files = await readdir(inputDir, { withFileTypes: true })
} catch {
  console.log('找不到 inbox/，已建立 docs/articles/；沒有需要轉換的檔案。')
  process.exit(0)
}

for (const file of files) {
  if (!file.isFile() || extname(file.name).toLowerCase() !== '.txt') continue
  const source = await readFile(join(inputDir, file.name), 'utf8')
  const title = basename(file.name, '.txt')
  const markdown = `---\ntitle: ${title}\n---\n\n# ${title}\n\n${source.trim()}\n`
  await writeFile(join(outputDir, `${title}.md`), markdown, 'utf8')
  console.log(`已轉換：${file.name} → docs/articles/${title}.md`)
}