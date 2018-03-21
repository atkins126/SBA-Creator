unit DwFileU;
{
 Author: Miguel A. Risco-Castillo
 Version 2.0
 Added TDownloadThread without WGET with use of Internet Tools
}
{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Dialogs, SysUtils, Strutils, LazFileUtils,
  Process, AsyncProcess, bbutils, simpleinternet;

function DownloadFile(UrlSource,FileDestiny:string):boolean;

Type

 tDwStatus=(dwStart,dwIdle,dwDownloading,dwTimeOut,dwError);

 { TDownloadThread }

 TOnDownloaded = procedure of Object;
 TDownloadThread = class(TThread)
 private
   FFileDestiny: String;
   FStatus: tDwStatus;
   fStatusText : string;
   FUrlSource: String;
   FOnDownloaded: TOnDownloaded;
   procedure SetFileDestiny(AValue: String);
   procedure SetStatus(AValue: tDwStatus);
   procedure SetUrlSource(AValue: String);
   procedure ShowStatus;
   procedure Downloaded;
 protected
   procedure Execute; override;
 public
   Constructor Create(UrlSource,FileDestiny:string);
 published
   property Status:tDwStatus read FStatus write SetStatus;
   property UrlSource:String read FUrlSource write SetUrlSource;
   property FileDestiny:String read FFileDestiny write SetFileDestiny;
   property OnDownloaded:TOnDownloaded read FOnDownloaded write FOnDownloaded;
 end;

 { TDwProcess }

 TDwProcess = class(TAsyncProcess)
 private
   FFileDestiny: String;
   FStatus: tDwStatus;
   FUrlSource: String;
   WaitingforIdle:Boolean;
   procedure SetFileDestiny(AValue: String);
   procedure SetStatus(AValue: tDwStatus);
   procedure SetUrlSource(AValue: String);
   procedure DwTerminate(Sender: TObject);
   procedure DwReadData(Sender: TObject);
public
   Constructor Create (AOwner : TComponent);override;
   function WGET(url, f: string): boolean;
   function WaitforIdle(waitsec:integer):boolean;
published
   property Status:tDwStatus read FStatus write SetStatus;
   property UrlSource:String read FUrlSource write SetUrlSource;
   property FileDestiny:String read FFileDestiny write SetFileDestiny;
 end;

implementation

uses DebugFormU;

function DownloadFile(UrlSource,FileDestiny:string):boolean;
begin
  result:=false;
  strSaveToFileUTF8(FileDestiny, retrieve(UrlSource));
  result:=true;
end;

{ TDwProcess }

constructor TDwProcess.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Options:=[poUsePipes,poStderrToOutPut];
  PipeBufferSize:=4096;
  ShowWindow:=swoMinimize;
  WaitingforIdle:=false;
  FStatus:=dwIdle;
  OnTerminate:=@DwTerminate;
  OnReadData:=@DwReadData;
end;

function TDwProcess.WGET(url, f: string): boolean;
begin
  result:=false;
  if not WaitforIdle(5) then exit;
  FUrlSource:=url;
  FFileDestiny:=f;
  Info('DwProcess.WGET','WGET started');
  Info('DwProcess.WGET','Url= '+FUrlSource);
  Info('DwProcess.WGET','file destiny= '+FFileDestiny);
  DeleteFileUTF8(FFileDestiny);
  Parameters.Clear;
  Info('DwProcess.WGET','Current folder: '+CurrentDirectory);
  {$IFDEF WINDOWS}
  Executable:=Application.location+'tools'+PathDelim+'wget.exe';
  {$ENDIF}
  {$IFDEF LINUX}
  Executable:='wget';
  {$ENDIF}
  {$IFDEF DARWIN}
  Executable:='curl';
  {$ENDIF}
  {$IFNDEF DEBUG}
  {$IFDEF DARWIN}
  Parameters.Add('-s');
  {$ELSE}
  Parameters.Add('-q');
  {$ENDIF}
  {$ENDIF}
  {$IFDEF WINDOWS}
  Parameters.Add('-O');
  Parameters.Add('"'+FFileDestiny+'"');
  Parameters.Add('--no-check-certificate');
  Parameters.Add(FUrlSource);
  {$ENDIF}
  {$IFDEF LINUX}
  Parameters.Add('-O');
  Parameters.Add(FFileDestiny);
  Parameters.Add('--no-check-certificate');
  Parameters.Add(FUrlSource);
  {$ENDIF}
  {$IFDEF DARWIN}
  Parameters.Add('-L');
  Parameters.Add(FUrlSource);
  Parameters.Add('-o');
  Parameters.Add(FFileDestiny);
  {$ENDIF}
  info('DwProcess.WGET',Parameters);
  FStatus:=dwDownloading;
  try
    Execute;
    result:=true;
  except
    On E:Exception do ShowMessage('The web download tool can not be used: '+E.Message);
  end;
end;

function TDwProcess.WaitforIdle(waitsec:integer):boolean;
var
  TiO:integer;
  PStr:String;
begin
  result:=false;
  if WaitingforIdle then exit;
  WaitingforIdle:=true;
  WriteStr(PStr,FStatus);
  info('TDwProcess.WaitforIdle','Status='+PStr);
  TiO:=waitsec*10; // Wait for 20 seconds
  {$IFDEF UNIX}
  While (TiO>0) and (FStatus<>dwIdle) and Running do
  {$ELSE}
  While (TiO>0) and (FStatus<>dwIdle) do // LLamar a Running en el loop en Windows da Error
  {$ENDIF}
  begin
    Dec(TiO);
    Application.ProcessMessages;
    Sleep(100);
  end;
//
  if (FStatus<>dwIdle) and not Running then
  begin
    info('TDwProcess.WaitforIdle','el proceso ya no está en ejecución, forzando un Onterminate');
    if OnTerminate<>nil then OnTerminate(Self);
    info('TDwProcess.WaitforIdle','---- Terminate forzado----');
  end;
//
  result:=FStatus=dwIdle;
  Info('TDwProcess.WaitforIdle',IFTHEN(result,'is Idle','can not terminate: Time Out'));
  if not result then
  begin
    Info('TDwProcess.WaitforIdle','timeout in Url: '+FUrlSource);
    //Terminar el proceso que ejecuta WGet si este falla
    Terminate(0);
    FStatus:=dwTimeOut;
  end;
  WriteStr(PStr,FStatus);
  info('TDwProcess.WaitforIdle','Exit Status='+PStr);
  WaitingforIdle:=false;
end;

procedure TDwProcess.DwTerminate(Sender: TObject);
begin
  Info('TDWProcess.DWterminate: NumBytesAvailable',NumBytesAvailable);
  if NumBytesAvailable>0 then OnReadData(Sender);
  info('TDwProcess.DWterminate',FFileDestiny);
  FStatus:=dwIdle;
end;

procedure TDwProcess.DwReadData(Sender: TObject);
var
  t:TStringList;
begin
  t:=TStringList.Create;
  t.LoadFromStream(Output);
  infoln(t.Text);
  t.free;
end;

procedure TDwProcess.SetStatus(AValue: tDwStatus);
begin
  if FStatus=AValue then Exit;
  FStatus:=AValue;
end;

procedure TDwProcess.SetFileDestiny(AValue: String);
begin
  if FFileDestiny=AValue then Exit;
  FFileDestiny:=AValue;
end;

procedure TDwProcess.SetUrlSource(AValue: String);
begin
  if FUrlSource=AValue then Exit;
  FUrlSource:=AValue;
end;

{ TDownloadThread }

constructor TDownloadThread.Create(UrlSource, FileDestiny: string);
begin
  FreeOnTerminate := True;
  FUrlSource:=UrlSource;
  FFileDestiny:=FileDestiny;
  FOnDownloaded:=nil;
  inherited Create(true);
end;

procedure TDownloadThread.ShowStatus;
// this method is executed by the mainthread and can therefore access all GUI elements.
begin
  case FStatus of
    dwStart: fStatusText := 'Url:'+FUrlSource+' Starting...';
    dwDownloading  :fStatusText := 'Downloading '+FFileDestiny+'...';
    dwIdle: fStatusText := 'Idle.';
  end;
  Info('TDownloadThread Status',fStatusText);
end;

procedure TDownloadThread.Downloaded;
begin
  if assigned(FOnDownloaded) then FOnDownloaded;
end;

procedure TDownloadThread.SetFileDestiny(AValue: String);
begin
  if FFileDestiny=AValue then Exit;
  FFileDestiny:=AValue;
end;

procedure TDownloadThread.SetStatus(AValue: tDwStatus);
begin
  if FStatus=AValue then Exit;
  FStatus:=AValue;
end;

procedure TDownloadThread.SetUrlSource(AValue: String);
begin
  if FUrlSource=AValue then Exit;
  FUrlSource:=AValue;
end;

procedure TDownloadThread.Execute;
begin
  FStatus:=dwStart;
  Synchronize(@Showstatus);
  FStatus:=dwDownloading;
  Synchronize(@Showstatus);
  if (not Terminated) then
  begin
    strSaveToFileUTF8(FFileDestiny, retrieve(FUrlSource));
    FStatus:=dwIdle;
  end;
  Synchronize(@Showstatus);
  Synchronize(@Downloaded);
  Info('TDownloadThread','Terminated.');
end;

end.

