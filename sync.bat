@echo off
chcp 65001 >nul
setlocal

rem ==========================================================
rem  readpage sync tool
rem  Double-click this file to push local md articles to GitHub.
rem  GitHub Actions rebuilds and deploys the site after the push.
rem
rem  NOTE: keep this file ASCII-only. Chinese characters inside a
rem  UTF-8 .bat file can break cmd parsing on non-UTF-8 consoles.
rem ==========================================================

rem Move to the folder where this .bat file lives.
cd /d "%~dp0"

echo ==========================================================
echo   readpage sync
echo   Project: %~dp0
echo ==========================================================
echo.

rem Make sure we are inside a git repository.
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
  echo [ERROR] This folder is not a git repository ^(.git not found^).
  goto :fail
)

rem Get today's date as YYYY-MM-DD.
rem Do NOT use %date%: its format changes with locale and chcp.
rem PowerShell output is locale-independent.
set "TODAY="
for /f "delims=" %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd"') do set "TODAY=%%i"
if not defined TODAY set "TODAY=update"

echo [1/4] Scanning local changes...
git add -A

set "HASCHANGE=0"
git diff --cached --quiet
if errorlevel 1 set "HASCHANGE=1"

if "%HASCHANGE%"=="1" (
  echo.
  echo [2/4] Committing changes ^(sync %TODAY%^)...
  git commit -m "sync %TODAY%"
  if errorlevel 1 (
    echo [ERROR] Commit failed.
    goto :fail
  )
) else (
  echo.
  echo [2/4] No new changes to commit.
)

echo.
echo [3/4] Syncing with remote ^(git pull --rebase^)...
git pull --rebase origin main
if errorlevel 1 (
  echo.
  echo [ERROR] Could not sync with remote. Aborting rebase...
  echo         Please check for conflicts and try again.
  git rebase --abort >nul 2>&1
  goto :fail
)

echo.
echo [4/4] Pushing to GitHub...
git push origin main
if errorlevel 1 (
  echo.
  echo [ERROR] Push failed. Check network and GitHub login.
  goto :fail
)

echo.
echo ==========================================================
echo   Sync complete!
echo.
echo   Site: https://stone-bar.github.io/readpage/
echo   GitHub Actions needs about 1-2 minutes to go live.
echo ==========================================================
echo.
pause
exit /b 0

:fail
echo.
echo ==========================================================
echo   Sync failed. See the error message above.
echo ==========================================================
echo.
pause
exit /b 1
