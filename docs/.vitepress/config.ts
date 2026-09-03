import { defineConfig } from 'vitepress'
import { articleSidebar } from './generated-sidebar'

const repository = process.env.GITHUB_REPOSITORY?.split('/')[1]
const base = process.env.VITEPRESS_BASE || (repository ? `/${repository}/` : '/')

export default defineConfig({
  lang: 'zh-Hant-TW',
  title: '大字體閱讀器',
  description: '舒服閱讀 Markdown 文章的個人網站',
  base,
  cleanUrls: true,
  themeConfig: {
    nav: [
      { text: '文章', link: '/articles/' },
      { text: '關於', link: '/about' }
    ],
    sidebar: {
      '/articles/': [
        {
          text: '文章',
          items: articleSidebar
        }
      ]
    },
    outline: false,
    socialLinks: []
  }
})