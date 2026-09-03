import { defineConfig } from 'vitepress'

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
          items: [{ text: '第一篇文章', link: '/articles/welcome' }]
        }
      ]
    },
    outline: false,
    socialLinks: []
  }
})