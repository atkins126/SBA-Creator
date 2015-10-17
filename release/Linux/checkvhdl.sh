#!/bin/bash

# Check VHDL Syntax using GHDL
# (c) Miguel Risco-Castillo
# v1.5 2015-09-09

echo Cleaning previous check...
ghdl --remove

echo Importing sources from vhdl files...
if [ -z "$2" ]; then
  ghdl -i *.vhd $1
else
  ghdl -i $2 $1
fi

if [ $? -eq 0 ]; then
  echo Checking syntax of: $1
  ghdl -s -g $1
fi

if [ $? -eq 0 ]; then
  echo No errors found.
  exit 0
else
  echo There are some errors in your vhdl files.
  exit 1
fi
