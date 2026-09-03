# 大字體文章閱讀器

使用 VitePress + GitHub Pages 建立的手機優先 Markdown 閱讀器。

## 本機開發

```bash
npm install
npm run docs:dev
```

開啟終端機顯示的網址即可預覽。

## 新增文章

把 `.md` 檔案放到 `docs/articles/`，或把純文字檔放到 `inbox/` 後執行：

```bash
npm run convert:txt
```

接著提交並推送：

```bash
git add .
git commit -m "add article"
git push
```

## GitHub Pages 設定

1. 將本資料夾建立成 GitHub repository。
2. 到 **Settings → Pages**，將 Source 設為 **GitHub Actions**。
3. 本專案會在 GitHub Actions 中自動從 `GITHUB_REPOSITORY` 設定 repository pages 的 base path。
   若使用自訂網域，可以在 workflow 的 build step 加上 `VITEPRESS_BASE=/`，或在設定中固定使用 `/`。

```ts
base: '/'
```

workflow 會在推送到 `main` 時自動建置並部署。