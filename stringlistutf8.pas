unit StringListUTF8;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil;

type
  ParentClass = TStringList;

  { TStringList }

  TStringList = class(ParentClass)
    procedure SaveToFile(const FileName: string); override;
    procedure LoadFromFile(const FileName: string); override;
  end;

implementation

{ TStringList }

procedure TStringList.SaveToFile(const FileName: string);
begin
  inherited SaveToFile(UTF8toSys(FileName));
end;

procedure TStringList.LoadFromFile(const FileName: string);
begin
  inherited LoadFromFile(UTF8toSys(FileName));
end;

end.

