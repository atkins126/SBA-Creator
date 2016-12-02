@echo off
REM Check VHDL Syntax using GHDL
REM (c) Miguel Risco-Castillo
REM v1.6 2016-11-17

echo Cleaning previous check...
"%~dp0ghdl\bin\ghdl.exe" --remove
if exist work-*.cf del work-*.cf

echo Importing sources from vhdl files...
if [%2]==[] goto nouse_path 

"%~dp0ghdl\bin\ghdl.exe" -i --std=02 "%2" "%1"
if %ERRORLEVEL% NEQ 0 goto error
goto chech_syntax

:nouse_path
"%~dp0ghdl\bin\ghdl.exe" -i --std=02 *.vhd "%1"
if %ERRORLEVEL% NEQ 0 goto error
goto chech_syntax

:chech_syntax
echo Checking syntax of: %1
"%~dp0ghdl\bin\ghdl.exe" -s -g --std=02 "%1"
if %ERRORLEVEL% NEQ 0 goto error
echo No errors found.
exit 0

:error
echo There are some errors in your vhdl files.
exit %ERRORLEVEL%
