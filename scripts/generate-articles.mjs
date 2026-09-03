import { mkdir, readdir, readFile, writeFile } from 'node:fs/promises'
import { basename, dirname, join, relative, sep } from 'node:path'

const root = process.cwd()
const articlesDir = join(root, 'docs', 'articles')
const configDir = join(root, 'docs', '.vitepress')

function getTitle(source, filename) {
  const frontmatterTitle = source.match(/^---[\s\S]*?^title:\s*["']?(.+?)["']?\s*$/m)?.[1]
  const heading = source.match(/^#\s+(.+)$/m)?.[1]
  return frontmatterTitle?.trim() || heading?.trim() || basename(filename, '.md')
}

const files = (await readdir(articlesDir, { withFileTypes: true }))
  .filter((entry) => entry.isFile() && entry.name.endsWith('.md') && entry.name !== 'index.md')
  .sort((a, b) => a.name.localeCompare(b.name, 'zh-Hant'))

const articles = await Promise.all(files.map(async (file) => {
  const source = await readFile(join(articlesDir, file.name), 'utf8')
  const slug = file.name.slice(0, -3)
  return { title: getTitle(source, file.name), slug }
}))

const links = articles
  .map(({ title, slug }) => `- [${title}](/articles/${encodeURIComponent(slug)})`)
  .join('\n')

await writeFile(
  join(articlesDir, 'index.md'),
  `# 文章\n\n${articles.length ? links : '目前還沒有文章。'}\n`,
  'utf8'
)

const sidebar = articles
  .map(({ title, slug }) => `    { text: ${JSON.stringify(title)}, link: '/articles/${slug}' },`)
  .join('\n')

await mkdir(dirname(join(configDir, 'generated-sidebar.ts')), { recursive: true })
await writeFile(
  join(configDir, 'generated-sidebar.ts'),
  `export const articleSidebar = [\n${sidebar}\n]\n`,
  'utf8'
)

console.log(`已產生文章索引：${articles.length} 篇`)