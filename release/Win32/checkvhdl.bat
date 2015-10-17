@echo off
REM Check VHDL Syntax using GHDL
REM (c) Miguel Risco-Castillo
REM v1.4 2015-06-15

echo Cleaning previous check...
"%~dp0ghdl\bin\ghdl.exe" --remove

echo Importing sources from vhdl files...
if [%2]==[] goto nouse_path 

"%~dp0ghdl\bin\ghdl.exe" -i "%2" "%1"
if %ERRORLEVEL% NEQ 0 goto error
goto chech_syntax

:nouse_path
"%~dp0ghdl\bin\ghdl.exe" -i *.vhd "%1"
if %ERRORLEVEL% NEQ 0 goto error
goto chech_syntax

:chech_syntax
echo Checking syntax of: %1
"%~dp0ghdl\bin\ghdl.exe" -s -g "%1"
if %ERRORLEVEL% NEQ 0 goto error
echo No errors found.
exit 0

:error
echo There are some errors in your vhdl files.
exit %ERRORLEVEL%
