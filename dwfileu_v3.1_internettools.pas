unit DwFileU;
{
 Author: Miguel A. Risco-Castillo
 Version 3.1
 Use of InternetTools
}
{$mode objfpc}{$H+}
{$DEFINE USE_SOROKINS_REGEX}

interface

uses
  Classes, Forms, Dialogs, SysUtils,
  bbutils, simpleinternet,
  LazFileUtils;

function DownloadFile(UrlSource,FileDestiny:string):boolean;
function CheckNetworkConnection:boolean;

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

implementation

uses DebugFormU;

var
  NetworkEnabled:boolean=false;

function DownloadFile(UrlSource,FileDestiny:string):boolean;
begin
  result:=false;
  if NetworkEnabled then try
    strSaveToFile(FileDestiny, retrieve(UrlSource));
  finally
    freeThreadVars;
  end;
  result:=true;
end;

function CheckNetworkConnection:boolean;
var Ip:String;
begin
  Ip:='';
  try
    Ip:=process('http://checkip.dyndns.org', 'extract(//body, "[0-9.]+")').toString;
    Info('CheckNetworkConnection IP',Ip);
  except
    On E :Exception do Info('CheckNetworkConnection error',E.Message);
  end;
  NetworkEnabled:=Ip<>'';
  exit(NetworkEnabled);
end;

{ TDownloadThread }

constructor TDownloadThread.Create(UrlSource, FileDestiny: string);
begin
  FreeOnTerminate := True;
  FUrlSource:=UrlSource;
  FFileDestiny:=FileDestiny;
  FOnDownloaded:=nil;
  inherited Create(true);
  FStatus:=dwStart;
  Synchronize(@Showstatus);
end;

procedure TDownloadThread.ShowStatus;
// this method is executed by the mainthread and can therefore access all GUI elements.
begin
  case FStatus of
    dwStart: fStatusText := 'Url:'+FUrlSource+' Starting...';
    dwDownloading  :fStatusText := 'Downloading '+FFileDestiny+'...';
    dwIdle: fStatusText := 'Idle.';
  end;
  Info('TDownloadThread.ShowStatus',fStatusText);
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
  FStatus:=dwDownloading;
  Synchronize(@Showstatus);
  if (not Terminated) and NetworkEnabled then
    try
      strSaveToFile(FFileDestiny, retrieve(FUrlSource));
    finally
      // Free Memory from InternetTools
      freeThreadVars;
    end;
  FStatus:=dwIdle;
  Synchronize(@Showstatus);
  Synchronize(@Downloaded);
end;

end.

