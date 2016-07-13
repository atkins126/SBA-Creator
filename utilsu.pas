unit UtilsU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, FileUtil, LazFileUtils, StrUtils, DateUtils,
  Zipper, DebugFormU;

function SearchForFiles(const dir,mask: string; Onfind:TFileFoundEvent):boolean;
function PopulateDirList(const directory : string; list : TStrings): boolean;
function PopulateFileList(const directory,mask : string; list : TStrings): boolean;
procedure GetAllFileNames(const dir,mask:string; list:TStrings);
procedure GetAllFileNamesAndPaths(const dir,mask:string; list:TStrings);
function UnZip(f,p:string):boolean;
function GetZipMainFolder(f:string):string;
function IsDirectoryEmpty(const directory : string) : boolean;
function GetPosList(s: string; list: Tstrings; start:integer=0): integer;
function DirReplace(s,d:string): boolean;
function DeleteDirectoryEx(DirectoryName: string): boolean;
function DirDelete(d:string):boolean;
function VCmpr(v1,v2:string):integer;
procedure PauseXms(const Milliseconds: longword);

implementation

procedure GetAllFileNames(const dir,mask:string; list:TStrings);
var
  L:TStringList;
  s:String;
begin
  list.Clear;
  L:=FindAllFiles(dir,mask);
  For s in L do list.Add(ExtractFileNameOnly(S));
  L.Free;
end;

procedure GetAllFileNamesAndPaths(const dir,mask:string; list:TStrings);
var
  L:TStringList;
  s:String;
begin
  list.Clear;
  L:=FindAllFiles(dir,mask);
  For s in L do list.Add(ExtractFileNameOnly(s)+'='+s);
  L.Free;
end;

function SearchForFiles(const dir,mask: string; Onfind:TFileFoundEvent):boolean;
var
  FS:TFileSearcher;
begin
  result:=false;
  try
    FS:=TFileSearcher.Create;
    FS.OnFileFound:=OnFind;
    FS.Search(dir,mask,true,true);
    result:=true;
  finally
    FS.Free;
  end;
end;

function PopulateFileList(const directory,mask: string; list: TStrings): boolean;
var
  sr : TSearchRec;
begin
  result:=false;
  list.Clear;
  try
    if FindFirstUTF8(IncludeTrailingPathDelimiter(directory) + mask, faAnyFile, sr) < 0 then Exit
    else
    repeat
      if (sr.Attr and faDirectory = 0) then List.Add(sr.Name+'='+directory);
    until FindNextUTF8(sr) <> 0;
  finally
    FindCloseUTF8(sr);
  end;
  result:=true;
end;

function UnZip(f,p:string):boolean;
var
  UnZipper: TUnZipper;
{$ifdef debug}
  i:integer;
{$endif}
begin
  result:=false;
  UnZipper := TUnZipper.Create;
  try
    UnZipper.FileName := Utf8ToAnsi(f);
    UnZipper.OutputPath := Utf8ToAnsi(p);
    try
      UnZipper.Examine;
{$ifdef debug}
      for i:=0 to UnZipper.Entries.Count-1 do infoln(UnZipper.Entries.Entries[i].ArchiveFileName);
{$endif}
      UnZipper.UnZipAllFiles;
    except
      ON E:Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    end;
  finally
    UnZipper.Free;
  end;
  Result:=true;
end;

function GetZipMainFolder(f:string):string;
var
  UnZipper: TUnZipper;
begin
  result:='';
  UnZipper := TUnZipper.Create;
  try
    UnZipper.FileName := Utf8ToAnsi(f);
    try
      UnZipper.Examine;
      Result:=UnZipper.Entries.Entries[0].ArchiveFileName;
    except
      ON E:Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    end;
  finally
    UnZipper.Free;
  end;
end;

function PopulateDirList(const directory : string; list : TStrings): boolean;
var
  sr : TSearchRec;
begin
  result:=false;
  list.Clear;
  try
    if FindFirstUTF8(IncludeTrailingPathDelimiter(directory) + '*.*', faDirectory, sr) < 0 then Exit
    else
    repeat
      if ((sr.Attr and faDirectory <> 0) AND (sr.Name <> '.') AND (sr.Name <> '..')) then
        List.Add(sr.Name);
    until FindNextUTF8(sr) <> 0;
  finally
    FindCloseUTF8(sr);
  end;
  result:=true;
end;

function IsDirectoryEmpty(const directory : string) : boolean;
var
  searchRec :TSearchRec;
begin
  try
    result := (FindFirstUTF8(directory+'\*.*', faAnyFile, searchRec) = 0) AND
              (FindNextUTF8(searchRec) = 0) AND
              (FindNextUTF8(searchRec) <> 0);
  finally
    FindCloseUTF8(searchRec);
  end;
end;

function GetPosList(s: string; list: Tstrings; start: integer=0): integer;
var
  i: integer;
begin
  if start<0 then begin result:=-1; exit; end;
  For i:=start to list.Count-1 do if pos(s,list[i])<>0 then break;
  if pos(s,list[i])<>0 then Result:=i else Result:=-1;
end;

function DirReplace(s,d:string): boolean;
begin
  Result:= DirDelete(d) and RenameFileUTF8(s,d);
end;

function DirDelete(d: string): boolean;
var i:integer;
begin
  infoln('Deleting: '+d);
  if not DirectoryExistsUTF8(d) then
  begin
    infoln('The folder '+d+' do not exists.');
    Result:=true;
    exit;
  end;
  Result:=DeleteDirectoryEx(d);
  for i:=0 to 10 do if DirectoryExistsUTF8(d) then sleep(300) else break;
end;

function DeleteDirectoryEx(DirectoryName: string): boolean;
// Lazarus fileutil.DeleteDirectory on steroids, works like
// deltree <directory>, rmdir /s /q <directory> or rm -rf <directory>
// - removes read-only files/directories (DeleteDirectory doesn't)
// - removes directory itself
// Adapted from fileutil.DeleteDirectory, thanks to Paweł Dmitruk
var
  FileInfo: TSearchRec;
  CurSrcDir: String;
  CurFilename: String;
begin
  Result:=false;
  CurSrcDir:=CleanAndExpandDirectory(DirectoryName);
  if FindFirstUTF8(CurSrcDir+GetAllFilesMask,faAnyFile,FileInfo)=0 then
  begin
    repeat
      // Ignore directories and files without name:
      if (FileInfo.Name<>'.') and (FileInfo.Name<>'..') and (FileInfo.Name<>'') then
      begin
        // Remove all files and directories in this directory:
        CurFilename:=CurSrcDir+FileInfo.Name;
        // Remove read-only file attribute so we can delete it:
        if (FileInfo.Attr and faReadOnly)>0 then
          FileSetAttrUTF8(CurFilename, FileInfo.Attr-faReadOnly);
        if (FileInfo.Attr and faDirectory)>0 then
        begin
          // Directory; exit with failure on error
          if not DeleteDirectoryEx(CurFilename) then exit;
        end
        else
        begin
          // File; exit with failure on error
          if not DeleteFileUTF8(CurFilename) then exit;
        end;
      end;
    until FindNextUTF8(FileInfo)<>0;
  end;
  FindCloseUTF8(FileInfo);
  // Remove "root" directory; exit with failure on error:
  if (not RemoveDirUTF8(CurSrcDir)) then exit;
  Result:=true;
end;


function VCmpr(v1, v2: string): integer;
var i:integer;
  function nl(s:string;l:integer):integer;
  begin
    result:=StrtoIntDef(ExtractDelimited(l,s,['.']),0)
  end;

begin
  i:=nl(v1,1)-nl(v2,1);
  if i<>0 then result:=i else
  begin
    i:=nl(v1,2)-nl(v2,2);
    if i<>0 then result:=i else
    begin
      i:=nl(v1,3)-nl(v2,3);
      result:=i
    end;
  end;
end;

procedure PauseXms(const Milliseconds: longword);
var
  TimeGoal: longword;
begin
  TimeGoal := MilliSecondOfTheDay(Now)+Milliseconds;
  while MilliSecondOfTheDay(Now) < (TimeGoal) do ;
end;


end.

