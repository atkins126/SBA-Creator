unit AutoUpdateU;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, SysUtils, IniFilesUTF8, LazFileUtils, StrUtils,
  Process, AsyncProcess, versionsupportu, DwFileU;

Const
  SBADwUrl='http://sba.accesus.com/%s?attredirects=0';
{$IFDEF WINDOWS}
  VersionFile='sbamainexe.ini';
  UpdaterZipfile='sbamainexe.zip';
  WhatsNewFile='whatsnew.txt';
  C_LOCALUPDATER = 'updatehm.exe';
{$ENDIF}
{$IFDEF LCLGTK2}
  {$IFDEF CPUARM}
  VersionFile='sbamainarmgtk2.ini';
  UpdaterZipfile='sbamainarmgtk2.zip';
  WhatsNewFile='whatsnewarmgtk2.txt';
  C_LOCALUPDATER = 'updatehm';
  {$ENDIF}
  {$IFDEF CPU386}
  VersionFile='sbamainx86gtk2.ini';
  UpdaterZipfile='sbamainx86gtk2.zip';
  WhatsNewFile='whatsnewx86gtk2.txt';
  C_LOCALUPDATER = 'updatehm';
  {$ENDIF}
  {$IFDEF CPUX86_64}
  VersionFile='sbamaingtk2.ini';
  UpdaterZipfile='sbamaingtk2.zip';
  WhatsNewFile='whatsnewgtk2.txt';
  C_LOCALUPDATER = 'updatehm';
  {$ENDIF}
{$ENDIF}
{$IFDEF LCLGTK3}
  {$IFDEF CPUX86_64}
  VersionFile='sbamaingtk3.ini';
  UpdaterZipfile='sbamaingtk3.zip';
  WhatsNewFile='whatsnewgtk3.txt';
  C_LOCALUPDATER = 'updatehm';
  {$ENDIF}
{$ENDIF}

function NewVersionAvailable(DwProcess:TDwProcess):boolean;
function GetWhatsNew(DwProcess:TDwProcess):boolean;
function DownloadNewVersion(DwProcess:TDwProcess):boolean;
function UpdateToNewVersion:boolean;
function GetNewVersion:string;
function DownloadInProgress(DwProcess:TDwProcess):boolean;

implementation

uses
  UtilsU, DebugFormU, ConfigFormU;


var
  VersionStr:string;

function NewVersionAvailable(DwProcess:TDwProcess): boolean;
var
  f:string;
  ini:TiniFile;
begin
  result:=false;
  f:=ConfigDir+VersionFile;
  DwProcess.WGET(Format(SBADwUrl,[VersionFile]),f);
  DwProcess.WaitforIdle;
  if not fileexistsUTF8(f) then exit;
  ini:=TIniFile.Create(ConfigDir+VersionFile);
  VersionStr:=Ini.ReadString('versions','GUI','0.0.0.1');
  if assigned(ini) then FreeAndNil(ini);
  result:=VCmpr(GetFileVersion,VersionStr)<0;
  InfoLn('Online version: '+VersionStr);
  InfoLn(result);
end;

function GetWhatsNew(DwProcess:TDwProcess):boolean;
var
  f:String;
begin
  f:=ConfigDir+WhatsNewFile;
  DwProcess.WGET(Format(SBADwUrl,[WhatsNewFile]),f);
  DwProcess.WaitforIdle;
  result:=fileexistsUTF8(f)
end;

function DownloadNewVersion(DwProcess:TDwProcess): boolean;
var
  f:String;
begin
  result:=false;
  f:=ConfigDir+UpdaterZipfile;
  DwProcess.WGET(Format(SBADwUrl,[UpdaterZipfile]),f);
  DwProcess.WaitforIdle;
  if not fileexistsUTF8(f) then exit;
  Unzip(f,AppDir+'updates');
  DeleteFileUTF8(f);
  result:=true;
end;

function UpdateToNewVersion: boolean;
var
  UpdateProcess: TAsyncProcess;
  cCount: cardinal;
begin
  DeleteFileUTF8(AppDir+WhatsNewFile); //Flag File
  // Update and re-start the app
  UpdateProcess := TAsyncProcess.Create(nil);
  try
    UpdateProcess.Executable := AppDir + C_LOCALUPDATER;
    UpdateProcess.CurrentDirectory := AppDir;
    UpdateProcess.Parameters.Clear;
    UpdateProcess.Parameters.Add(ExtractFileName(Application.ExeName)); //Param 1 = EXEname
    UpdateProcess.Parameters.Add('updates'); // Param 2 = updates
    UpdateProcess.Parameters.Add(WhatsNewFile); // Param 3 = whatsnew.txt
    UpdateProcess.Parameters.Add(Application.Title); // Param 4 = Prettyname
    UpdateProcess.Parameters.Add('copytree');
   // Param 5 = Copy the whole of /updates to the App Folder
    InfoLn(UpdateProcess.Executable);
    InfoLn(UpdateProcess.Parameters);
    UpdateProcess.Execute;
    // Check for WhatsNewFile in the app directory in a LOOP
    cCount:=0;
    while not FileExistsUTF8(AppDir+WhatsNewFile) do
    begin
      Application.ProcessMessages;
      sleep(100);
      Inc(CCount);
      if cCount > 100000 then
        Break; // Get out of jail in case updatehm.exe fails to copy file
    end;
    //Shut down the Main app?
    Application.Terminate;
  finally
    UpdateProcess.Free;
  end;
  Result := True;
end;

function GetNewVersion: string;
begin
  result:=VersionStr;
end;

function DownloadInProgress(DwProcess:TDwProcess): boolean;
begin
  result:=(DwProcess.Status=dwDownloading) and DwProcess.Running;
  Info('DownloadInProgress',IFTHEN(result,'Is','Is not')+' downloading');
end;

end.

