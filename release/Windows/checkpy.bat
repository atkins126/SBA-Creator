@echo off
REM Check Python Syntax
REM (c) Miguel Risco-Castillo
REM v1.0 2019/05/24

REM Verify Python installation
python -V
if %ERRORLEVEL% NEQ 0 goto nopython

:chech_syntax
echo Checking syntax of: %1
python -m py_compile "%1"
if %ERRORLEVEL% NEQ 0 goto error
echo No errors found.
exit 0

:nopython
echo Can't find Python in the path
exit 0

:error
echo There are some errors in your source files.
exit %ERRORLEVEL%