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

## 一鍵同步（sync.bat）

不想開 VS Code 時，直接雙擊專案根目錄的 `sync.bat`，就會自動完成同步。

它會依序執行：

1. 掃描並加入所有本機變更（`git add -A`）
2. 有變更才提交，訊息自動帶當天日期（例如 `sync 2026-10-05`）；沒有變更就跳過
3. `git pull --rebase origin main` 先同步遠端
4. `git push origin main` 推送
5. 顯示結果，視窗會停住讓你確認

推送後 GitHub Actions 會自動重新建置並部署，約 1～2 分鐘後網站更新。

### 日常使用方式

1. 把新的 `.md` 檔案放進 `docs/articles/`
2. 雙擊 `sync.bat`
3. 看到 `Sync complete!` 即完成，不用開 VS Code

> 若要用純文字檔流程，需先建立 `inbox/` 並執行 `npm run convert:txt`，再執行 `sync.bat`。

## 注意事項與限制

- **`sync.bat` 請保持純 ASCII（英文訊息）**：UTF-8 的 `.bat` 檔若含中文，在非 UTF-8 主控台會造成 cmd 解析錯誤（實測出現 `'…' is not recognized as an internal or external command`）。畫面上顯示英文是刻意設計，請不要改成中文。
- **日期不使用 `%date%`**：執行 `chcp 65001` 後，`%date%` 的格式會變成「週一 2026/10/05」，直接解析會產生錯誤的 commit 訊息。腳本改用 `powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"`，與系統地區設定無關。
- **同步前會先 `git pull --rebase`**：若你在 GitHub 網頁上直接編輯檔案，且與本機變更衝突，腳本會中止 rebase 並提示你手動處理。
- **GitHub Actions 建置結果需自行確認**：`sync.bat` 只負責推送，不保證線上建置成功。請至 repository 的 **Actions** 頁面確認最新一次 workflow 狀態。
- **建置部署有延遲**：推送後約需 1～2 分鐘才會在網站看到更新。
- **`.gitignore` 已忽略的產物不會被同步**：`node_modules/`、`docs/.vitepress/dist/`、`docs/.vitepress/cache/` 不會進入版控。
- **文章索引與側邊欄由 CI 自動產生**：`docs:build` 會先執行 `generate:articles`，因此本機不需要手動執行 `npm run generate:articles`。
- **`sync.bat` 固定以 `main` 分支為目標**：腳本固定使用 `origin main`，若日後更換分支名稱需一併修改。
- **執行環境限制**：`sync.bat` 僅適用於 Windows（cmd / PowerShell）；其他作業系統請直接使用 git 指令。

## GitHub Pages 設定

1. 將本資料夾建立成 GitHub repository。
2. 到 **Settings → Pages**，將 Source 設為 **GitHub Actions**。
3. 本專案會在 GitHub Actions 中自動從 `GITHUB_REPOSITORY` 設定 repository pages 的 base path。
   若使用自訂網域，可以在 workflow 的 build step 加上 `VITEPRESS_BASE=/`，或在設定中固定使用 `/`。

```ts
base: '/'
```

workflow 會在推送到 `main` 時自動建置並部署。