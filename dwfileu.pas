unit DwFileU;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, Dialogs, SysUtils, Strutils, httpsend, LazFileUtils,
  Process, AsyncProcess;

Type

 tDWProcessStatus=(dwIdle,dwDownloading,dwTimeOut);

{ TDownloadThread }

 TDownloadThread = class(TThread)
 private
   fStatusText : string;
   procedure ShowStatus;
 protected
   procedure Execute; override;
 public
   Constructor Create(CreateSuspended : boolean);
 end;

 { TDwProcess }

 TDwProcess = class(TAsyncProcess)
 private
   FFileDestiny: String;
   FStatus: tDWProcessStatus;
   FUrlSource: String;
   procedure SetFileDestiny(AValue: String);
   procedure SetStatus(AValue: tDWProcessStatus);
   procedure SetUrlSource(AValue: String);
 public
   Constructor Create (AOwner : TComponent);override;
   function WGET(url, f: string): boolean;
   function WaitforIdle: boolean;
   procedure DwTerminate(Sender: TObject);
   procedure DwReadData(Sender: TObject);
published
   property Status:tDWProcessStatus read FStatus write SetStatus;
   property UrlSource:String read FUrlSource write SetUrlSource;
   property FileDestiny:String read FFileDestiny write SetFileDestiny;
 end;

var
  DwProcess:TDwProcess=nil;

function DownloadHTTP(URL, TargetFile: string): boolean;
function DownloadHTTPEx(URL, TargetFile: string; var ReturnCode, DownloadSize: integer):boolean;
function DownloadHTTPStream(URL: string; Buffer: TStream): boolean;
function SFDirectLinkURL(URL: string; Document: TMemoryStream): string;
function SourceForgeURL(URL: string): string;

implementation

uses DebugFormU, UtilsU, ConfigFormU;

function DownloadHTTP(URL, TargetFile: string): boolean;
// Download file; retry if necessary.
// Deals with SourceForge download links
var
  Buffer: TMemoryStream;
begin
  result:=false;
  URL:=SourceForgeURL(URL); //Deal with sourceforge URLs
  try
    Buffer := TMemoryStream.Create;
    DownloadHTTPStream(URL, Buffer);
    Buffer.SaveToFile(TargetFile);
    result:=true;
  finally
    FreeAndNil(Buffer);
  end;
end;

function DownloadHTTPEx(URL, TargetFile: string;var ReturnCode, DownloadSize: integer): boolean;
  // Download file; retry if necessary.
  // Deals with SourceForge download links
  // Could use Synapse HttpGetBinary, but that doesn't deal
  // with result codes (i.e. it happily downloads a 404 error document)
const
  MaxRetries = 3;
var
  HTTPGetResult: boolean;
  HTTPSender: THTTPSend;
  RetryAttempt: integer;
begin
  Result := False;
  RetryAttempt := 1;
  URL := SourceForgeURL(URL); //Deal with sourceforge URLs
  HTTPSender := THTTPSend.Create;
  try
    try
      // Try to get the file
      HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
      while (HTTPGetResult = False) and (RetryAttempt < MaxRetries) do
      begin
        PauseXms(500 * RetryAttempt);
        HTTPGetResult := HTTPSender.HTTPMethod('GET', URL);
        RetryAttempt := RetryAttempt + 1;
      end;
      // If we have an answer from the server, check if the file
      // was sent to us
      ReturnCode := HTTPSender.Resultcode;
      DownloadSize := HTTPSender.DownloadSize;
      case HTTPSender.Resultcode of
        100..299:
        begin
          with TFileStream.Create(TargetFile, fmCreate or fmOpenWrite) do
            try
              Seek(0, soFromBeginning);
              CopyFrom(HTTPSender.Document, 0);
            finally
              Free;
            end;
          Result := True;
        end; //informational, success
        300..399: Result := False; //redirection. Not implemented, but could be.
        400..499: Result := False; //client error; 404 not found etc
        500..599: Result := False; //internal server error
        else
          Result := False; //unknown code
      end;
    except
      // We don't care for the reason for this error; the download failed.
      Result := False;
    end;
  finally
    HTTPSender.Free;
  end;
end;

function DownloadHTTPStream(URL: string; Buffer: TStream): boolean;
  // Download file; retry if necessary.
const
  MaxRetries = 3;
var
  RetryAttempt: integer;
  HTTPGetResult: boolean;
begin
  Result:=false;
  RetryAttempt := 1;
  HTTPGetResult := False;
  while ((HTTPGetResult = False) and (RetryAttempt < MaxRetries)) do
  begin
    HTTPGetResult := HttpGetBinary(URL, Buffer);
    //Application.ProcessMessages;
    Sleep(100 * RetryAttempt);
    RetryAttempt := RetryAttempt + 1;
  end;
  if HTTPGetResult = False then
    raise Exception.Create('Cannot load document from remote server');
  Buffer.Position := 0;
  if Buffer.Size = 0 then
    raise Exception.Create('Downloaded document is empty.');
  Result := True;
end;

function SFDirectLinkURL(URL: string; Document: TMemoryStream): string;
{
Transform this part of the body:
<noscript>
<meta http-equiv="refresh" content="5; url=http://downloads.sourceforge.net/project/base64decoder/base64decoder/version%202.0/b64util.zip?r=&amp;ts=1329648745&amp;use_mirror=kent">
</noscript>
into a valid URL:
http://downloads.sourceforge.net/project/base64decoder/base64decoder/version%202.0/b64util.zip?r=&amp;ts=1329648745&amp;use_mirror=kent
}
const
  Refresh='<meta http-equiv="refresh"';
  URLMarker='url=';
var
  Counter: integer;
  HTMLBody: TStringList;
  RefreshStart: integer;
  URLStart: integer;
begin
  HTMLBody:=TStringList.Create;
  try
    HTMLBody.LoadFromStream(Document);
    for Counter:=0 to HTMLBody.Count-1 do
    begin
      // This line should be between noscript tags and give the direct download locations:
      RefreshStart:=Ansipos(Refresh, HTMLBody[Counter]);
      if RefreshStart>0 then
      begin
        URLStart:=AnsiPos(URLMarker, HTMLBody[Counter])+Length(URLMarker);
        if URLStart>RefreshStart then
        begin
          // Look for closing "
          URL:=Copy(HTMLBody[Counter],
            URLStart,
            PosEx('"',HTMLBody[Counter],URLStart+1)-URLStart);
          infoln('debug: new url after sf noscript:');
          infoln(URL);
          break;
        end;
      end;
    end;
  finally
    HTMLBody.Free;
  end;
  result:=URL;
end;

function SourceForgeURL(URL: string): string;
// Detects sourceforge download and tries to deal with
// redirection, and extracting direct download link.
// Thanks to
// Ocye: http://lazarus.freepascal.org/index.php/topic,13425.msg70575.html#msg70575
const
  SFProjectPart = '//sourceforge.net/projects/';
  SFFilesPart = '/files/';
  SFDownloadPart ='/download';
var
  HTTPSender: THTTPSend;
  i, j: integer;
  FoundCorrectURL: boolean;
  SFDirectory: string; //Sourceforge directory
  SFDirectoryBegin: integer;
  SFFileBegin: integer;
  SFFilename: string; //Sourceforge name of file
  SFProject: string;
  SFProjectBegin: integer;
begin
  // Detect SourceForge download; e.g. from URL
  //          1         2         3         4         5         6         7         8         9
  // 1234557890123456789012345578901234567890123455789012345678901234557890123456789012345578901234567890
  // http://sourceforge.net/projects/base64decoder/files/base64decoder/version%202.0/b64util.zip/download
  //                                 ^^^project^^^       ^^^directory............^^^ ^^^file^^^
  FoundCorrectURL:=true; //Assume not a SF download
  i:=Pos(SFProjectPart, URL);
  if i>0 then
  begin
    // Possibly found project; now extract project, directory and filename parts.
    SFProjectBegin:=i+Length(SFProjectPart);
    j := PosEx(SFFilesPart, URL, SFProjectBegin);
    if (j>0) then
    begin
      SFProject:=Copy(URL, SFProjectBegin, j-SFProjectBegin);
      SFDirectoryBegin:=PosEx(SFFilesPart, URL, SFProjectBegin)+Length(SFFilesPart);
      if SFDirectoryBegin>0 then
      begin
        // Find file
        // URL might have trailing arguments... so: search for first
        // /download coming up from the right, but it should be after
        // /files/
        i:=RPos(SFDownloadPart, URL);
        // Now look for previous / so we can make out the file
        // This might perhaps be the trailing / in /files/
        SFFileBegin:=RPosEx('/',URL,i-1)+1;

        if SFFileBegin>0 then
        begin
          SFFilename:=Copy(URL,SFFileBegin, i-SFFileBegin);
          //Include trailing /
          SFDirectory:=Copy(URL, SFDirectoryBegin, SFFileBegin-SFDirectoryBegin);
          FoundCorrectURL:=false;
        end;
      end;
    end;
  end;

  if not FoundCorrectURL then
  begin
    try
      // Rewrite URL if needed for Sourceforge download redirection
      // Detect direct link in HTML body and get URL from that
      HTTPSender := THTTPSend.Create;
      //Who knows, this might help:
      HTTPSender.UserAgent:='curl/7.21.0 (i686-pc-linux-gnu) libcurl/7.21.0 OpenSSL/0.9.8o zlib/1.2.3.4 libidn/1.18';
      while not FoundCorrectURL do
      begin
        HTTPSender.HTTPMethod('GET', URL);
        infoln('debug: headers:');
        infoln(HTTPSender.Headers.Text);
        case HTTPSender.Resultcode of
          301, 302, 307:
            begin
              for i := 0 to HTTPSender.Headers.Count - 1 do
                if (Pos('Location: ', HTTPSender.Headers.Strings[i]) > 0) or
                  (Pos('location: ', HTTPSender.Headers.Strings[i]) > 0) then
                begin
                  j := Pos('use_mirror=', HTTPSender.Headers.Strings[i]);
                  if j > 0 then
                    URL :=
                      'http://' + RightStr(HTTPSender.Headers.Strings[i],
                      length(HTTPSender.Headers.Strings[i]) - j - 10) +
                      '.dl.sourceforge.net/project/' +
                      SFProject + '/' + SFDirectory + SFFilename
                  else
                    URL:=StringReplace(
                      HTTPSender.Headers.Strings[i], 'Location: ', '', []);
                  HTTPSender.Clear;//httpsend
                  FoundCorrectURL:=true;
                  break; //out of rewriting loop
              end;
            end;
          100..200:
            begin
              //Assume a sourceforge timer/direct link page
              URL:=SFDirectLinkURL(URL, HTTPSender.Document); //Find out
              FoundCorrectURL:=true; //We're done by now
            end;
          500: raise Exception.Create('No internet connection available');
            //Internal Server Error ('+aURL+')');
          else
            raise Exception.Create('Download failed with error code ' +
              IntToStr(HTTPSender.ResultCode) + ' (' + HTTPSender.ResultString + ')');
        end;//case
      end;//while
      infoln('debug: resulting url after sf redir: *' + URL + '*');
    finally
      HTTPSender.Free;
    end;
  end;
  result:=URL;
end;

{ TDwProcess }

constructor TDwProcess.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Options:=[poUsePipes,poStderrToOutPut];
  PipeBufferSize:=4096;
  ShowWindow:=swoMinimize;
  FStatus:=dwIdle;
  OnTerminate:=@DwTerminate;
  OnReadData:=@DwReadData;
end;

function TDwProcess.WGET(url, f: string): boolean;
begin
  result:=false;
  if not WaitforIdle then exit;
  FUrlSource:=url;
  FFileDestiny:=f;
  InfoLn('DwProcess WGET started');
  InfoLn('DWProcess Url: '+FUrlSource);
  InfoLn('DWProcess file destiny: '+FFileDestiny);
  DeleteFileUTF8(FFileDestiny);
  Parameters.Clear;
  CurrentDirectory:=ConfigDir;
  {$IFDEF WINDOWS}
  Executable:=AppDir+'tools'+PathDelim+'wget.exe';
  infoln(Executable);
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
  infoln(Parameters);
  FStatus:=dwDownloading;
  try
    Execute;
    result:=true;
  except
    On E:Exception do ShowMessage('The web download tool can not be used: '+E.Message);
  end;
end;

function TDwProcess.WaitforIdle:boolean;
var
  TiO:integer;
begin
  TiO:=300;
  While (TiO>0) and (FStatus<>dwIdle) do
  begin
    Dec(TiO);
    Application.ProcessMessages;
    Sleep(100);
  end;
  result:=FStatus=dwIdle;
  InfoLn('DwProcess WGET '+IFTHEN(result,'is Idle','can not terminate: Time Out'));
  if not result then
  begin
    InfoLn('DWProcess timeout in Url: '+FUrlSource);
    FStatus:=dwTimeOut;
  end;
end;

procedure TDwProcess.DwTerminate(Sender: TObject);
begin
  if NumBytesAvailable>0 then OnReadData(Sender);
  infoln('DwProcess terminated: '+FFileDestiny);
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

procedure TDwProcess.SetStatus(AValue: tDWProcessStatus);
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

constructor TDownloadThread.Create(CreateSuspended : boolean);
begin
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TDownloadThread.ShowStatus;
// this method is executed by the mainthread and can therefore access all GUI elements.
begin
  InfoLn(fStatusText);
end;

procedure TDownloadThread.Execute;
var
  newStatus : string;
begin
  fStatusText := 'TDownloadThread Starting...';
  Synchronize(@Showstatus);
  fStatusText := 'TDownloadThread Running...';
  while (not Terminated) do //and ([any condition required]) do
    begin
{
      ...
      [here goes the code of the main thread loop]
      ...
}
      if NewStatus <> fStatusText then
        begin
          fStatusText := newStatus;
          Synchronize(@Showstatus);
        end;
    end;
end;


end.

