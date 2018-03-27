unit DwFileU;
{
 Author: Miguel A. Risco-Castillo
 Version 4.0
 Use of Synapse
}
{$mode objfpc}{$H+}
{$DEFINE USE_SOROKINS_REGEX}

interface

uses
  Classes, Forms, Dialogs, SysUtils,
  ssl_openssl, httpsend, blcksock, typinfo,
  LazFileUtils;

Type

  tDwStatus=(dwStart,dwIdle,dwDownloading,dwTimeOut,dwError);

  IProgress = interface
    procedure ProgressNotification(Text: String; CurrentProgress : integer; MaxProgress : integer);
  end;

  { THttpDownloader }

  THttpDownloader = class
  public
    function DownloadHTTP(URL, TargetFile: string; ProgressMonitor : IProgress): Boolean;
  private
    Bytes : Integer;
    MaxBytes : Integer;
    Redirections : Integer;
    HTTPSender: THTTPSend;
    ProgressMonitor : IProgress;
    function HttpGet(url, TargetFile: string): boolean;
    procedure Status(Sender: TObject; Reason: THookSocketReason; const Value: String);
    function GetSizeFromHeader(Header: String):integer;
  end;

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

function DownloadFile(UrlSource,FileDestiny:string):boolean;

implementation

uses DebugFormU;

function THttpDownloader.DownloadHTTP(URL, TargetFile: string; ProgressMonitor : IProgress): Boolean;
begin
  Result:=False;
  Bytes:=0;
  MaxBytes:=-1;
  Redirections:=0;
  Self.ProgressMonitor:= ProgressMonitor;
  HTTPSender := THTTPSend.Create;
  try
    try
      // add callback function for status updates
      HTTPSender.Sock.OnStatus:= @Status;
      HTTPSender.UserAgent:='curl/7.21.0 (i686-pc-linux-gnu) libcurl/7.21.0 OpenSSL/0.9.8o zlib/1.2.3.4 libidn/1.18';
      Result:=HttpGet(URL,TargetFile);
    except
      // We don't care for the reason for this error; the download failed.
      Result := False;
    end;
  finally
    HTTPSender.Free;
  end;
end;

function THttpDownloader.HttpGet(url,TargetFile:string):boolean;
const
  MaxRetries = 3;
var
  HTTPGetResult: Boolean;
  RetryAttempt: Integer;
  i:integer;
begin
  if Redirections>9 then
  begin
    Info('THttpDownloader.HttpGet','Too many redirections');
    exit(false);
  end;
  RetryAttempt := 1;
  Info('THttpDownloader.HttpGet URL','"'+URL+'"');
  Info('THttpDownloader.HttpGet TargetFile',TargetFile);
  // Try to get the file
  HTTPSender.Clear;
  HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
  while (HTTPGetResult = False) and (RetryAttempt < MaxRetries) do
  begin
    Sleep(500 * RetryAttempt);
    HTTPSender.Clear;
    HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
    RetryAttempt := RetryAttempt + 1;
  end;
  // If we have an answer from the server, check if the file was sent to us.
  Info('THttpDownloader.HttpGet Result',HTTPSender.ResultString);
  Info('THttpDownloader.HttpGet Result Code',HTTPSender.Resultcode);
  case HTTPSender.Resultcode of
    100..299:
      begin
        HTTPSender.Document.SaveToFile(TargetFile);
        Result := True;
      end; //informational, success
    
    301, 302, 307: //simple redirection
      begin
        { TODO : Verificar mejor los Headers, no funciona para la descarga de SBALibrary por ejemplo }
        Info('Redirection found',HTTPSender.Headers);
        Inc(Redirections);
        for i := 0 to HTTPSender.Headers.Count - 1 do
          if (Pos('location: ', lowercase(HTTPSender.Headers.Strings[i])) = 1) then
          begin
            URL := StringReplace(HTTPSender.Headers.Strings[i], 'location: ', '', [rfIgnoreCase]);
	    if Length(URL)>1 then Result := HttpGet(URL,TargetFile);
          end;
      end;    
    303..306,308..399: Result := False; // other redirection. Not implemented, but could be.
    400..499: Result := False; // client error; 404 not found etc
    500..599: Result := False; // internal server error
    else Result := False; // unknown code
  end;
end;

//Callback function for status events
procedure THttpDownloader.Status(Sender: TObject; Reason: THookSocketReason; const Value: String);
var
  V, currentHeader: String;
  i: integer;
begin
  //try to get filesize from headers
  if (MaxBytes = -1) then
  begin
    for i:= 0 to HTTPSender.Headers.Count - 1 do
    begin
      currentHeader:= HTTPSender.Headers[i];
      MaxBytes:= GetSizeFromHeader(currentHeader);
      if MaxBytes <> -1 then break;
    end;
  end;

  V := GetEnumName(TypeInfo(THookSocketReason), Integer(Reason)) + ' ' + Value;

  //HR_ReadCount contains the number of bytes since the last event
  if Reason = THookSocketReason.HR_ReadCount then
  begin
    Bytes:= Bytes + StrToInt(Value);
    if ProgressMonitor<>nil then
      ProgressMonitor.ProgressNotification(V, Bytes, MaxBytes);
  end;
end;

function THttpDownloader.GetSizeFromHeader(Header: String): integer;
var
  item : TStringList;
begin
  //the download size is contained in the header (e.g.: Content-Length: 3737722)
  Result:= -1;

  if Pos('Content-Length:', Header) <> 0 then
  begin
    item:= TStringList.Create();
    try
      item.Delimiter:= ':';
      item.StrictDelimiter:=true;
      item.DelimitedText:=Header;
      if item.Count = 2 then
      begin
        Result:= StrToInt(Trim(item[1]));
      end;
    finally
      item.Free;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////

function DownloadFile(UrlSource,FileDestiny:string):boolean;
var Dwt:THttpDownloader;
begin
  Dwt:=THttpDownloader.Create;
  result:=DwT.DownloadHTTP(UrlSource,FileDestiny,nil) ;
  Dwt.Free;
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
var Dwt:THttpDownloader;
begin
  FStatus:=dwStart;
  Synchronize(@Showstatus);
  FStatus:=dwDownloading;
  Synchronize(@Showstatus);
  if (not Terminated) then
  begin
    Dwt:=THttpDownloader.Create;
    DwT.DownloadHTTP(UrlSource,FFileDestiny,nil) ;
    Dwt.Free;
    FStatus:=dwIdle;
  end;
  Synchronize(@Showstatus);
  Synchronize(@Downloaded);
end;

end.

