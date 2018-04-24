unit FilesMonitorU;
{
 Thread files monitoring
 (c) Miguel A. Risco Castillo
 Version: 0.2
 Date: 2018/04/23
 Based on ATFileNotif by Alexey Torgashin
}

{$mode objfpc}{$H+}

interface

uses
  Forms, Dialogs, SysUtils, Classes, ExtCtrls, LazFileUtils,
  DebugFormU;

type

  { TFilesMon }

  TFilesMon = class(TThread)
  private
    FEnabled: Boolean;
    FFiles: TStringList;
    FInterval: Integer;
    FOnChanged: TNotifyEvent;
    fEvent:PRTLEvent;
    procedure SetEnabled(AValue: Boolean);
    procedure DoChanged;
    procedure SetInterval(AValue: Integer);
  protected
    procedure Execute; override;
  public
    FileChanged:String;
    constructor Create(AEnable:Boolean=false; AOnChanged:TNotifyEvent=nil; AInterval: Integer=1000);
    destructor Destroy; override;
    procedure Terminate;
    procedure AddFile(const AValue: string);
    procedure DelFile(const AValue: string);
    procedure UpdateFile(const AValue: string);
  published
    property Files: TStringList read FFiles;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property Enabled:Boolean read FEnabled write SetEnabled;
    property Interval:Integer read FInterval write SetInterval;
  end;

implementation

type
  TFileSRec = class(TObject)
    FExist: Boolean;
    FSize: Int64;
    FAge: Longint;
  end;

{ Helper functions }

procedure FGetFileRec(const FileName: string; var Rec: TFileSRec);
begin
  Rec.FExist:= FileExistsUTF8(FileName);
  Rec.FSize:= FileSizeUtf8(FileName);
  Rec.FAge:= FileAgeUTF8(FileName);
end;

function CheckFileChanged(const FileName: string; var OldRec: TFileSRec): Boolean;
var
  NewRec: TFileSRec;
begin
  NewRec:=TFileSRec.Create;
  try
    FGetFileRec(FileName, NewRec);
    Result:=
      (OldRec.FExist <> NewRec.FExist) or
      (OldRec.FSize <> NewRec.FSize) or
      (OldRec.FAge <> NewRec.FAge);
    if Result then
    begin
      OldRec.FExist:=NewRec.FExist;
      OldRec.FSize:=NewRec.FSize;
      OldRec.FAge:=NewRec.FAge;
    end;
  finally
    NewRec.Free;
  end;
end;


{ TFilesMon }

constructor TFilesMon.Create(AEnable: Boolean; AOnChanged: TNotifyEvent;
  AInterval: Integer);
begin
  FFiles:=TStringList.Create;
  FFiles.OwnsObjects:=true;
  FileChanged:='';
  FInterval:= AInterval;
  FEnabled:= AEnable;
  FOnChanged:=AOnChanged;
  fEvent := RTLEventCreate;
  inherited Create(true);
  FreeOnTerminate := True;
  Start;
end;

destructor TFilesMon.Destroy;
begin
  FEnabled:= False;
  Terminate;
  if assigned(FFiles) then FreeAndNil(FFiles);
  RTLeventdestroy(fEvent);
  inherited Destroy;
end;

procedure TFilesMon.Terminate;
begin
  FEnabled:=false;
  inherited Terminate;
  RTLeventSetEvent(fEvent);
end;

procedure TFilesMon.AddFile(const AValue: string);
var
  En: Boolean;
  FFileRec: TFileSRec;
begin
  Info('TFilesMon.AddFile',AValue);
  En:= FEnabled;
  FEnabled:= False;

  FFileRec:=TFileSRec.Create;
  FGetFileRec(AValue, FFileRec);
  if (AValue <> '') and (not FFileRec.FExist) then
  begin
    FFileRec.Free;
    raise Exception.Create('File to watch doesn''t exist')
  end else
    if FFiles.IndexOf(AValue)=-1 then
      FFiles.AddObject(AValue,FFileRec)
    else
      FFileRec.Free;
  FEnabled:= En;
end;

procedure TFilesMon.DelFile(const AValue: string);
var
  En: Boolean;
  i:integer;
begin
  Info('TFilesMon.DelFile',AValue);
  En:= FEnabled;
  FEnabled:= False;
  i:=FFiles.IndexOf(AValue);
  if i>=0 then FFiles.Delete(i);
  FEnabled:= En;
end;

procedure TFilesMon.UpdateFile(const AValue: string);
var
  En: Boolean;
  i:integer;
  FileRec:TFileSRec;
begin
  Info('TFilesMon.UpdateFile',AValue);
  En:= FEnabled;
  FEnabled:= False;
  i:=FFiles.IndexOf(AValue);
  if i>=0 then
  begin
    FileRec:=TFileSRec(FFiles.Objects[i]);
    FGetFileRec(AValue,FileRec);
  end;
  FEnabled:= En;
end;

procedure TFilesMon.SetEnabled(AValue: Boolean);
begin
  if FEnabled=AValue then Exit;
  FEnabled:=AValue;
end;

procedure TFilesMon.Execute;
var
  i:integer;
  FileSRec:TFileSRec;
begin
  While not Terminated do
  begin
    For i:=0 to FFiles.Count-1 do
    begin
      if Terminated or not FEnabled then break;
      FileSRec:=TFileSRec(FFiles.Objects[i]);
      if CheckFileChanged(FFiles[i],FileSRec) then
      begin
        FileChanged:=FFiles[i];
        Synchronize(@DoChanged);
      end;
    end;
    RTLeventWaitFor(fEvent,FInterval);
    RTLeventResetEvent(fEvent);
  end;
end;

procedure TFilesMon.DoChanged;
begin
  if Assigned(FOnChanged) then
    FOnChanged(Self);
end;

procedure TFilesMon.SetInterval(AValue: Integer);
begin
  if FInterval=AValue then Exit;
  FInterval:=AValue;
end;

end.

