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
IF NOT EXIST "%USERPROFILE%\Desktop" GOTO D1
@Shortcut.exe /f:"%USERPROFILE%\Desktop\SBACreator.lnk" /a:c /t:"%_%\SBACreator.exe" /w:"%_%"
GOTO EXIT

:D1
@Shortcut.exe /f:"%USERPROFILE%\Escritorio\SBACreator.lnk" /a:c /t:"%_%\SBACreator.exe" /w:"%_%"

:EXIT
