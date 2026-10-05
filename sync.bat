@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem ==========================================================
rem  readpage 文章同步工具
rem  用途：雙擊此檔，自動把本機最新的 md 文章同步到 GitHub
rem        推送後 GitHub Actions 會自動重新建置網站。
rem ==========================================================

rem 切換到這個 bat 檔案所在的專案目錄（不管從哪裡雙擊都能運作）
cd /d "%~dp0"

echo ==========================================================
echo   讀頁文章同步工具  readpage sync
echo   專案：%~dp0
echo ==========================================================
echo.

rem 檢查是否為 git 專案
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
  echo [錯誤] 這裡不是 git 專案，找不到 .git 資料夾。
  goto :fail
)

rem 取得今天的日期，格式為 YYYY-MM-DD
rem 注意：不要用 %date%，因為不同地區設定或 chcp 會改變它的格式。
rem 改用 PowerShell 取得，與系統地區設定無關。
set "TODAY="
for /f "delims=" %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set "TODAY=%%i"
if not defined TODAY set "TODAY=update"

echo [1/4] 掃描本機變更...
git add -A

set "HASCHANGE=0"
git diff --cached --quiet
if errorlevel 1 set "HASCHANGE=1"

if "!HASCHANGE!"=="1" (
  echo.
  echo [2/4] 提交變更 ^(sync !TODAY!^)...
  git commit -m "sync !TODAY!"
  if errorlevel 1 (
    echo [錯誤] 提交失敗。
    goto :fail
  )
) else (
  echo.
  echo [2/4] 沒有新的變更，跳過提交。
)

echo.
echo [3/4] 同步遠端最新版本 ^(git pull --rebase^)...
git pull --rebase origin main
if errorlevel 1 (
  echo.
  echo [錯誤] 無法同步遠端版本，可能有衝突。已嘗試中止 rebase。
  echo        請手動檢查後再試一次。
  git rebase --abort >nul 2>&1
  goto :fail
)

echo.
echo [4/4] 推送到 GitHub...
git push origin main
if errorlevel 1 (
  echo.
  echo [錯誤] 推送失敗，請確認網路連線與 GitHub 登入狀態。
  goto :fail
)

echo.
echo ==========================================================
echo   同步完成！
echo.
echo   網站：https://stone-bar.github.io/readpage/
echo   GitHub Actions 約需 1-2 分鐘才會更新線上的文章。
echo ==========================================================
echo.
pause
exit /b 0

:fail
echo.
echo ==========================================================
echo   同步失敗，請看上面的錯誤訊息。
echo ==========================================================
echo.
pause
exit /b 1
