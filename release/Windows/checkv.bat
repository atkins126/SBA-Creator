@echo off
REM Check Verilog Syntax using Icarus Verilog
REM (c) Miguel Risco-Castillo
REM v1.3 2015-04-27

if exist a.out (
echo Cleaning previous check...
del a.out
)

set PATH=%~dp0iverilog\bin;%PATH%

:chech_syntax
echo Checking syntax of: %1
"%~dp0iverilog\bin\iverilog" "%1"
if %ERRORLEVEL% NEQ 0 goto error
echo No found verificable errors in this scope.
exit 0

:error
echo There are some errors in your hdl files.
exit %ERRORLEVEL%
