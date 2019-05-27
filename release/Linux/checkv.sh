#!/bin/bash


# Check Verilog Syntax using Icarus Verilog
# (c) Miguel Risco-Castillo
# v1.4 2015-09-09

if [ -e a.out ]; then
  echo Cleaning previous check...
  rm a.out
fi

dir=$(dirname $(readlink -m $BASH_SOURCE))
PATH=$dir/iverilog/bin:$PATH

:chech_syntax
echo Checking syntax of: $1
$dir/iverilog/bin/iverilog $1

if [ $? -eq 0 ]; then
  echo No found verificable errors in this scope.
  exit 0
else
  echo There are some errors in your hdl files.
  exit $?
fi  

