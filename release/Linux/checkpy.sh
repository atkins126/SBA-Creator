#!/bin/bash

# Check Python Syntax without executing
# (c) Miguel Risco-Castillo
# v1.0 2019/05/24

# Looking for a Python installation
python -V
if [ $? -eq 0 ]; then
else
  echo Sorry Python not found.
  exit 1
fi

echo Checking syntax of: $1
$ python -m py_compile $1

if [ $? -eq 0 ]; then
  echo No errors found.
  exit 0
else
  echo There are some errors in your source files.
  exit 1
fi
