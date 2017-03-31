unit IniFilesUTF8;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles;

type

  { TIniFileUTF8 }
  ParentClass = TIniFile;
  TIniFile = class(ParentClass)
    constructor Create(const AFileName: string; AOptions : TIniFileOptions = []); override;
  end;

implementation

{ TIniFileUTF8 }

constructor TIniFile.Create(const AFileName: string; AOptions : TIniFileOptions);
begin
  inherited Create(Utf8ToAnsi(AFileName),AOptions);
end;


end.

