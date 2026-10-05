@echo off
rem Back up this folder and the OSRSCN fork to their private GitHub repositories.
rem Also copies in the AI Chinese definitions (hours of GPU work) from RuneLite's folder.
rem Safe to run any time; nothing happens if nothing changed.
title Back up Chinese study folder
cd /d "%~dp0"

if not exist data mkdir data
if exist "%USERPROFILE%\.runelite\osrscn\dict\zh-defs.jsonl" copy /y "%USERPROFILE%\.runelite\osrscn\dict\zh-defs.jsonl" data\zh-defs.jsonl >nul

echo Study folder:
git add -A
git commit -q -m "Backup %date% %time:~0,5%" && echo   committed. || echo   nothing new to commit.
git push -q && echo   pushed. || echo   PUSH FAILED - see the message above.

echo.
echo OSRSCN fork:
cd tools\osrscn-tts
set DIRTY=
for /f %%i in ('git status --porcelain') do set DIRTY=1
if defined DIRTY echo   WARNING: the fork has uncommitted changes; they are NOT backed up until committed.
git push -q && echo   pushed. || echo   PUSH FAILED - see the message above.

echo.
pause
