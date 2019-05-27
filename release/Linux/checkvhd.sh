#!/bin/bash

# Check VHDL Syntax using GHDL
# (c) Miguel Risco-Castillo
# v2.0 2018-03-28

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )/ghdl/bin/"

# Looking for a GHDL installation
$DIR"ghdl" -v &>/dev/null
if [ $? -eq 0 ]; then
  echo GHDL found on: $DIR
else
  DIR=""
  $DIR"ghdl" -v &>/dev/null
  if [ $? -eq 0 ]; then
    echo GHDL found
  else
    echo Sorry GHDL not found.
    exit 1
  fi
fi

echo Cleaning previous check...
$DIR"ghdl" --remove
if [ -e work-*.cf ]; then
  rm -f work-*.cf
fi

echo Importing sources from vhdl files...
if [ -z "$2" ]; then
  $DIR"ghdl" -i *.vhd $1
else
  $DIR"ghdl" -i $2 $1
fi

if [ $? -eq 0 ]; then
  echo Checking syntax of: $1
  $DIR"ghdl" -s -g $1
else
  echo No valid sources found
  exit 1
fi

if [ $? -eq 0 ]; then
  echo No errors found.
  exit 0
else
  echo There are some errors in your vhdl files.
  exit 1
fi
