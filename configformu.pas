unit ConfigFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, EditBtn, ButtonPanel, SBAProgContrlrU;

type

  { TConfigForm }

  TConfigForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    Ed_LibraryDir: TDirectoryEdit;
    Ed_SnippetDir: TDirectoryEdit;
    Ed_ProjectsDir: TDirectoryEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    L_ConfigDir: TStaticText;
    procedure FormShow(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ConfigForm: TConfigForm;
  ConfigDir,LibraryDir,SnippetDir,ProjectsDir:string;

function GetConfigValues:boolean;
function SetConfigValues:boolean;

implementation

uses MainFormU;

{$R *.lfm}

function GetConfigValues: boolean;
begin
  result:=false;
  MainForm.IniStor.IniFileName:=GetAppConfigFile(false);
  With MainForm.IniStor do
  begin
    ConfigDir:=ReadString('ConfigDir',GetAppConfigDir(false));
    LibraryDir:=ReadString('LibraryDir',ConfigDir+'sbalibrary'+PathDelim);
    SnippetDir:=ReadString('SnippetDir',ConfigDir+'snippets'+PathDelim);
    ProjectsDir:=ReadString('ProjectsDir',GetUserDir+'sbaprojects'+PathDelim);
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
  if not FileExistsUTF8(ConfigDir+cSBADefaultPrgTemplate) then CopyFile(Application.location+cSBADefaultPrgTemplate,ConfigDir+cSBADefaultPrgTemplate);
  if not FileExistsUTF8(ConfigDir+'banner.gif') then CopyFile(Application.location+cSBADefaultPrgTemplate,ConfigDir+'banner.gif');
  result:=true;
end;

function SetConfigValues:boolean;
begin
  result:=false;
  with ConfigForm, MainForm.IniStor do
  begin
    if DirectoryExistsUTF8(Ed_LibraryDir.text) then LibraryDir:=Ed_LibraryDir.text
    else raise exception.create('Library folder could not be changed');
    WriteString('LibraryDir',LibraryDir);
    if DirectoryExistsUTF8(Ed_SnippetDir.text) then SnippetDir:=Ed_SnippetDir.text
    else raise exception.create('Snippet folder could not be changed');
    WriteString('SnippetDir',SnippetDir);
    if DirectoryExistsUTF8(Ed_ProjectsDir.text) then ProjectsDir:=Ed_ProjectsDir.text
    else raise exception.create('SBA Projects folder could not be changed');
    WriteString('ProjectsDir',ProjectsDir);
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
end;

procedure TConfigForm.Label4Click(Sender: TObject);
begin

end;

end.

