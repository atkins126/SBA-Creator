unit ConfigFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
<<<<<<< HEAD
  StdCtrls, Buttons, EditBtn, ButtonPanel, Zipper;
=======
  StdCtrls, Buttons, EditBtn, ButtonPanel, SBAProgContrlrU;
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5

type

  { TConfigForm }

  TConfigForm = class(TForm)
    ButtonPanel1: TButtonPanel;
<<<<<<< HEAD
    CB_LibAsReadOnly: TCheckBox;
=======
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5
    Ed_LibraryDir: TDirectoryEdit;
    Ed_SnippetDir: TDirectoryEdit;
    Ed_ProjectsDir: TDirectoryEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
<<<<<<< HEAD
    Ed_DefAuthor: TLabeledEdit;
    L_ConfigDir: TStaticText;
    procedure FormShow(Sender: TObject);
=======
    L_ConfigDir: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure Label4Click(Sender: TObject);
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ConfigForm: TConfigForm;
<<<<<<< HEAD
  ConfigDir,LibraryDir,SnippetDir,ProjectsDir,SBAbaseDir:string;
  DefAuthor:string;
  LibAsReadOnly:Boolean;
  IpCoreList:Tstringlist;

function GetConfigValues:boolean;
function SetConfigValues:boolean;
function PopulateDirList(const directory : string; list : TStrings): boolean;
function UnZip(f,p:string):boolean;
function IsDirectoryEmpty(const directory : string) : boolean;

implementation

uses MainFormU, SBAProgContrlrU, SBAProjectU;
=======
  ConfigDir,LibraryDir,SnippetDir,ProjectsDir:string;

function GetConfigValues:boolean;
function SetConfigValues:boolean;

implementation

uses MainFormU;
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5

{$R *.lfm}

function GetConfigValues: boolean;
begin
  result:=false;
  MainForm.IniStor.IniFileName:=GetAppConfigFile(false);
  With MainForm.IniStor do
  begin
    ConfigDir:=ReadString('ConfigDir',GetAppConfigDir(false));
<<<<<<< HEAD
    SBAbaseDir:=ReadString('SBAbaseDir',ConfigDir+'SBA-master'+PathDelim);
    LibraryDir:=ReadString('LibraryDir',ConfigDir+'sbalibrary'+PathDelim);
    SnippetDir:=ReadString('SnippetDir',ConfigDir+'snippets'+PathDelim);
    ProjectsDir:=ReadString('ProjectsDir',GetUserDir+'sbaprojects'+PathDelim);
    DefAuthor:=ReadString('DefAuthor','Author');
    LibAsReadOnly:=ReadBoolean('LibAsReadOnly',true);
=======
    LibraryDir:=ReadString('LibraryDir',ConfigDir+'sbalibrary'+PathDelim);
    SnippetDir:=ReadString('SnippetDir',ConfigDir+'snippets'+PathDelim);
    ProjectsDir:=ReadString('ProjectsDir',GetUserDir+'sbaprojects'+PathDelim);
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5
  end;
  If Not DirectoryExistsUTF8(ConfigDir) then
    If Not CreateDirUTF8(ConfigDir) Then
      raise exception.create('Failed to create config folder!');
  If Not DirectoryExistsUTF8(LibraryDir) then
    If Not CreateDirUTF8(LibraryDir) Then
      raise exception.create('Failed to create SBA library folder!');
  If Not DirectoryExistsUTF8(SnippetDir) then
    If Not CreateDirUTF8(SnippetDir) Then
      raise exception.create('Failed to create code snippets folder!');
  If Not DirectoryExistsUTF8(ProjectsDir) then
    If Not CreateDirUTF8(ProjectsDir) Then
      raise exception.create('Failed to create SBA projects folder!');
<<<<<<< HEAD

  If Not DirectoryExistsUTF8(SBAbaseDir) then
  begin
    CopyFile(Application.location+cSBABaseZipFile,ConfigDir+cSBABaseZipFile);
    if not Unzip(ConfigDir+cSBABaseZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create SBA base folder!');
      halt(1);
    end;
  end;

  if not FileExistsUTF8(ConfigDir+cSBADefaultPrgTemplate) then CopyFile(Application.location+cSBADefaultPrgTemplate,ConfigDir+cSBADefaultPrgTemplate);
  if not FileExistsUTF8(ConfigDir+'newbanner.gif') then CopyFile(Application.location+'banner.gif',ConfigDir+'newbanner.gif');
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

=======
  if not FileExistsUTF8(ConfigDir+cSBADefaultPrgTemplate) then CopyFile(Application.location+cSBADefaultPrgTemplate,ConfigDir+cSBADefaultPrgTemplate);
  if not FileExistsUTF8(ConfigDir+'banner.gif') then CopyFile(Application.location+cSBADefaultPrgTemplate,ConfigDir+'banner.gif');
  result:=true;
end;

>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5
function SetConfigValues:boolean;
begin
  result:=false;
  with ConfigForm, MainForm.IniStor do
  begin
<<<<<<< HEAD
    WriteString('ConfigDir',ConfigDir);
=======
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5
    if DirectoryExistsUTF8(Ed_LibraryDir.text) then LibraryDir:=Ed_LibraryDir.text
    else raise exception.create('Library folder could not be changed');
    WriteString('LibraryDir',LibraryDir);
    if DirectoryExistsUTF8(Ed_SnippetDir.text) then SnippetDir:=Ed_SnippetDir.text
    else raise exception.create('Snippet folder could not be changed');
    WriteString('SnippetDir',SnippetDir);
    if DirectoryExistsUTF8(Ed_ProjectsDir.text) then ProjectsDir:=Ed_ProjectsDir.text
    else raise exception.create('SBA Projects folder could not be changed');
<<<<<<< HEAD
    WriteString('SBAbaseDir',SBAbaseDir);
    WriteString('ProjectsDir',ProjectsDir);
    DefAuthor:=Ed_DefAuthor.Text;
    WriteString('DefAuthor',DefAuthor);
    WriteBoolean('LibAsReadOnly',LibAsReadOnly);
  end;
  result:=true;
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
//        List.Add(IncludeTrailingPathDelimiter(directory) + sr.Name);
        List.Add(sr.Name);
    until FindNextUTF8(sr) <> 0;
  finally
    FindCloseUTF8(sr);
=======
    WriteString('ProjectsDir',ProjectsDir);
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5
  end;
  result:=true;
end;

{ TConfigForm }

procedure TConfigForm.FormShow(Sender: TObject);
begin
  L_ConfigDir.caption:='Config Dir: '+ConfigDir;
  Ed_LibraryDir.Text:=LibraryDir;
  Ed_SnippetDir.Text:=SnippetDir;
  Ed_ProjectsDir.Text:=ProjectsDir;
<<<<<<< HEAD
  Ed_DefAuthor.Text:=DefAuthor;
  CB_LibAsReadOnly.checked:=LibAsReadOnly;
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

=======
end;

procedure TConfigForm.Label4Click(Sender: TObject);
begin

end;
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5

end.

