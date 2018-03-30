@echo off
REM Generate Shorcut in user desktop
REM (c) Miguel Risco-Castillo
REM v2.0 2018/03/26

SETLOCAL EnableDelayedExpansion

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
for /f "usebackq tokens=1,2,*" %%B IN (`reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop`) do call set "DESKTOP=%%D"

IF NOT EXIST !DESKTOP! GOTO DESKTOPNOTFOUND

:CREATESHORTCUT
@"%_%\tools\Shortcut.exe" /f:"%DESKTOP%\SBACreator.lnk" /a:c /t:"%_%\SBACreator.exe" /w:"%_%"
GOTO EXIT

:DESKTOPNOTFOUND
echo No se pudo encontrar la ruta hacia el escritorio del usuario: !DESKTOP!
pause

:EXIT
