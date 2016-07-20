unit AutoUpdateU;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, SysUtils, IniFilesUTF8, LazFileUtils,
  Process, AsyncProcess, versionsupportu;

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
{$ELSE}
  VersionFile='sbamaingtk2.ini';
  UpdaterZipfile='sbamaingtk2.zip';
  WhatsNewFile='whatsnewgtk2.txt';
  C_LOCALUPDATER = 'updatehm';
{$ENDIF}
{$ENDIF}

function NewVersionAvailable:boolean;
function GetWhatsNew:boolean;
function DownloadNewVersion:boolean;
function UpdateToNewVersion:boolean;
function GetNewVersion:string;
function DownloadInProgress:boolean;

implementation

uses
  UtilsU, DwFileU, DebugFormU, ConfigFormU;


var
  VersionStr:string;

function NewVersionAvailable: boolean;
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

function GetWhatsNew:boolean;
var
  f:String;
begin
  result:=false;
  f:=ConfigDir+WhatsNewFile;
  DwProcess.WGET(Format(SBADwUrl,[WhatsNewFile]),f);
  DwProcess.WaitforIdle;
  if not fileexistsUTF8(f) then exit;
  result:=true;
end;

function DownloadNewVersion: boolean;
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
  FUpdateHMProcess: TAsyncProcess;
  cCount: cardinal;
begin
  DeleteFileUTF8(AppDir+WhatsNewFile); //Flag File
  // Update and re-start the app
  FUpdateHMProcess := TAsyncProcess.Create(nil);
  try
    FUpdateHMProcess.Executable := AppDir + C_LOCALUPDATER;
    FUpdateHMProcess.CurrentDirectory := AppDir;
    FUpdateHMProcess.Parameters.Clear;
    FUpdateHMProcess.Parameters.Add(ExtractFileName(Application.ExeName)); //Param 1 = EXEname
    FUpdateHMProcess.Parameters.Add('updates'); // Param 2 = updates
    FUpdateHMProcess.Parameters.Add(WhatsNewFile); // Param 3 = whatsnew.txt
    FUpdateHMProcess.Parameters.Add(Application.Title); // Param 4 = Prettyname
    FUpdateHMProcess.Parameters.Add('copytree');
   // Param 5 = Copy the whole of /updates to the App Folder
    InfoLn(FUpdateHMProcess.Executable);
    InfoLn(FUpdateHMProcess.Parameters);
    FUpdateHMProcess.Execute;
    // Check for WhatsNewFile in the app directory in a LOOP
    cCount:=0;
    while not FileExistsUTF8(AppDir+WhatsNewFile) do
    begin
      Application.ProcessMessages;
      Inc(CCount);
      if cCount > 10000000 then
        Break; // Get out of jail in case updatehm.exe fails to copy file
    end;
    //Shut down the Main app?
    Application.Terminate;
  finally
    FUpdateHMProcess.Free;
  end;
  Result := True;
end;

function GetNewVersion: string;
begin
  result:=VersionStr;
end;

function DownloadInProgress: boolean;
begin
  result:=DwProcess.Status=dwDownloading;
end;

end.

