@echo off

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
for /f "usebackq tokens=3*" %%D IN (`reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Desktop`) do set DESKTOP=%%D
IF NOT EXIST %DESKTOP% GOTO D1
@"%_%\tools\Shortcut.exe" /f:"%DESKTOP%\SBACreator.lnk" /a:c /t:"%_%\SBACreator.exe" /w:"%_%"
GOTO EXIT

:D1
echo No se pudo encontrar la ruta hacia el escritorio del usuario: %DESKTOP%

:EXIT
