@echo off
REM Thin wrapper - delegates to PowerShell implementation
setlocal
set "SCRIPT_DIR=%~dp0"
pwsh -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%deploy-early-access.ps1" %*
set "EXITCODE=%ERRORLEVEL%"
endlocal & exit /B %EXITCODE%