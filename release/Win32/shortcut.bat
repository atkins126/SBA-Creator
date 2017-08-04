@echo off
REM Generate Shorcut in user desktop
REM (c) Miguel Risco-Castillo
REM v1.0 2017/08/04

SETLOCAL

set _=%CD%

IF EXIST "%_%\tools\Shortcut.exe" GOTO D0

echo No se encuentra el programa en la ruta especificada
echo Ruta: %_%\tools
echo por favor use la ruta de instalación que el
echo programa sugiere por defecto
echo .
pause
GOTO EXIT

:D0
FOR /F "usebackq" %%f IN (`PowerShell -NoProfile -Command "Write-Host([Environment]::GetFolderPath('Desktop'))"`) DO (
  SET "DESKTOP=%%f"
  )
IF NOT EXIST %DESKTOP% GOTO D1
@"%_%\tools\Shortcut.exe" /f:"%DESKTOP%\SBACreator.lnk" /a:c /t:"%_%\SBACreator.exe" /w:"%_%"
GOTO EXIT

:D1
echo No se pudo encontrar la ruta hacia el escritorio del usuario: %DESKTOP%
pause

:EXIT

