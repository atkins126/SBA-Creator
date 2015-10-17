#!/bin/bash
# HDL obfuscator using HDLObf
# (c) Miguel Risco-Castillo
# v1.6 2015-09-09

dir=$(dirname $(readlink -m $BASH_SOURCE))

if [ -e "$2" ]; then
  echo removing previous obfuscated file: $2
  rm $2
fi

echo creating obfuscated file from: $1 result: $2
#java -cp "$dir/hdlobf/antlr.jar","$dir/hdlobf/bin" Obfuscate $3 $4 $1 $2
java -cp $dir/hdlobf/antlr.jar:$dir/hdlobf/bin Obfuscate $3 $4 $1 $2
echo End of Obfuscation process
