@echo off
REM Check VHDL Syntax using GHDL
REM (c) Miguel Risco-Castillo
REM v1.3 2015-04-27

echo Cleaning previous check...
"%~dp0ghdl\bin\ghdl.exe" --remove

echo Importing sources from vhdl files in: %cd% ...
if exist lib\ goto use_lib 
"%~dp0ghdl\bin\ghdl.exe" -i *.vhd "%1"
if %ERRORLEVEL% NEQ 0 goto error
goto chech_syntax

:use_lib
"%~dp0ghdl\bin\ghdl.exe" -i lib\*.vhd *.vhd "%1"
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
