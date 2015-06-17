unit UtilsU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Zipper;

function SearchForFiles(const dir,mask: string; Onfind:TFileFoundEvent):boolean;
function PopulateDirList(const directory : string; list : TStrings): boolean;
function PopulateFileList(const directory,mask : string; list : TStrings): boolean;
function UnZip(f,p:string):boolean;
function IsDirectoryEmpty(const directory : string) : boolean;
function GetPosList(s: string; list: Tstrings; start:integer=0): integer;

implementation

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
begin
  result:=false;
  UnZipper := TUnZipper.Create;
  try
    UnZipper.FileName := f;
    UnZipper.OutputPath := p;
    UnZipper.Examine;
    UnZipper.UnZipAllFiles;
    result:=true;
  finally
    UnZipper.Free;
  end;
end;

function PopulateDirList(const directory : string; list : TStrings): boolean;
var
  sr : TSearchRec;
begin
  result:=false;
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


end.

