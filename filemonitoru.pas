unit FileMonitorU;
{
 Thread file monitoring
 (c) Miguel A. Risco Castillo
 Version: 0.1
 Date: 2018/04/22
 Based on ATFileNotif by Alexey Torgashin
}

{$mode objfpc}{$H+}
{$BOOLEVAL OFF}


interface

uses
  Forms, Dialogs, SysUtils, Classes, ExtCtrls, LazFileUtils,
  DebugFormU;

type
  TFileSRec = record
    FExist: Boolean;
    FSize: Int64;
    FAge: Longint;
  end;

type

  { TFileMon }

  TFileMon = class(TThread)
  private
    FEnabled: Boolean;
    FFileName: string;
    FFileRec: TFileSRec;
    FInterval: Integer;
    FOnChanged: TNotifyEvent;
    procedure SetEnabled(AValue: Boolean);
    procedure SetFileName(const AValue: string);
    procedure DoChanged;
    procedure SetInterval(AValue: Integer);
  protected
    procedure Execute; override;
  public
    constructor Create(AFileName: String=''; AInterval: Integer=1000);
    procedure Terminate;
  published
    property FileName: string read FFileName write SetFileName;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property Enabled:Boolean read FEnabled write SetEnabled;
    property Interval:Integer read FInterval write SetInterval;
  end;

implementation

{ Helper functions }

procedure FGetFileRec(const FileName: string; var Rec: TFileSRec);
begin
  FillChar(Rec, SizeOf(Rec), 0);
  Rec.FExist:= FileExistsUTF8(FileName);
  Rec.FSize:= FileSizeUtf8(FileName);
  Rec.FAge:= FileAgeUTF8(FileName);
end;

function FFileChanged(const FileName: string; var OldRec: TFileSRec): Boolean;
var
  NewRec: TFileSRec;
begin
  FGetFileRec(FileName, NewRec);

  Result:=
    (OldRec.FExist <> NewRec.FExist) or
    (OldRec.FSize <> NewRec.FSize) or
    (OldRec.FAge <> NewRec.FAge);

  if Result then
    Move(NewRec, OldRec, SizeOf(NewRec));
end;


{ TFileMon }

constructor TFileMon.Create(AFileName:String; AInterval:Integer=1000);
begin
  FFileName:= AFileName;
  FInterval:= AInterval;
  FEnabled:= False;
  FillChar(FFileRec, SizeOf(FFileRec), 0);
  inherited Create(true);
  FreeOnTerminate := True;
end;

procedure TFileMon.Terminate;
begin
  Info('TFileMon.Terminate',FEnabled);
  FEnabled:=false;
  Start;
  inherited Terminate;
end;

procedure TFileMon.SetFileName(const AValue: string);
var
  En: Boolean;
begin
  En:= FEnabled;
  FEnabled:= False;

  FFileName:= AValue;
  FGetFileRec(FFileName, FFileRec);
  if (FFileName <> '') and (not FFileRec.FExist) then
    raise Exception.Create('File to watch doesn''t exist');

  FEnabled:= En;
end;

procedure TFileMon.SetEnabled(AValue: Boolean);
begin
  if FEnabled=AValue then Exit;
  FEnabled:=AValue;
  if AValue then Start;
end;

procedure TFileMon.Execute;
begin
  While not Terminated do
  begin
    if FEnabled and FFileChanged(FFileName, FFileRec) then Synchronize(@DoChanged);
    Sleep(FInterval);
  end;
end;

procedure TFileMon.DoChanged;
begin
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TFileMon.SetInterval(AValue: Integer);
begin
  if FInterval=AValue then Exit;
  FInterval:=AValue;
end;

end.

