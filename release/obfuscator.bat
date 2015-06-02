@echo off
@echo off
REM HDL obfuscator using HDLObf
REM (c) Miguel Risco-Castillo
REM v1.5 2015-05-03

if exist "%2" (
  @echo removing previous obfuscated file: %2
  del "%2"
)

@echo creating obfuscated file from: %1 result: %2
java -cp "%~dp0hdlobf\antlr.jar";"%~dp0hdlobf\bin" Obfuscate %3 %4 %1 %2
@echo End of Obfuscation process
