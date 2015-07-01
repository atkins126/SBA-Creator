unit IniFilesUTF8;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles;

type

  { TIniFileUTF8 }
  ParentClass = TIniFile;
  TIniFile = class(ParentClass)
    constructor Create(f:string);
  end;

implementation

{ TIniFileUTF8 }

constructor TIniFile.Create(f: string);
begin
  inherited Create(Utf8ToAnsi(f));
end;

end.

