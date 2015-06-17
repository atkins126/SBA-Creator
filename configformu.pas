unit ConfigFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, EditBtn, ButtonPanel;

type

  { TConfigForm }

  TConfigForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CB_LibAsReadOnly: TCheckBox;
    CB_AutoOpenPrjF: TCheckBox;
    Ed_LibraryDir: TDirectoryEdit;
    Ed_SnippetDir: TDirectoryEdit;
    Ed_ProjectsDir: TDirectoryEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Ed_DefAuthor: TLabeledEdit;
    L_ConfigDir: TStaticText;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ConfigForm: TConfigForm;
  ConfigDir,LibraryDir,SnippetDir,ProjectsDir,SBAbaseDir:string;
  DefAuthor:string;
  LibAsReadOnly:Boolean;
  AutoOpenPrjF:Boolean;
  IpCoreList:Tstringlist;

function GetConfigValues:boolean;
function SetConfigValues:boolean;

implementation

uses MainFormU, SBAProgContrlrU, SBAProjectU, UtilsU;

{$R *.lfm}

function GetConfigValues: boolean;
begin
  result:=false;
  MainForm.IniStor.IniFileName:=GetAppConfigFile(false);
  With MainForm.IniStor do
  begin
    ConfigDir:=ReadString('ConfigDir',GetAppConfigDir(false));
    SBAbaseDir:=ReadString('SBAbaseDir',ConfigDir+'SBA-master'+PathDelim);
    LibraryDir:=ReadString('LibraryDir',ConfigDir+'sbalibrary'+PathDelim);
    SnippetDir:=ReadString('SnippetDir',ConfigDir+'snippets'+PathDelim);
    ProjectsDir:=ReadString('ProjectsDir',GetUserDir+'sbaprojects'+PathDelim);
    DefAuthor:=ReadString('DefAuthor','Author');
    LibAsReadOnly:=ReadBoolean('LibAsReadOnly',true);
    AutoOpenPrjF:=ReadBoolean('AutoOpenPrjF',true);
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

function SetConfigValues:boolean;
begin
  result:=false;
  with ConfigForm, MainForm.IniStor do
  begin
    WriteString('ConfigDir',ConfigDir);
    //
    if DirectoryExistsUTF8(Ed_LibraryDir.text) then LibraryDir:=AppendPathDelim(TrimFilename(Ed_LibraryDir.text))
    else raise exception.create('Library folder could not be changed');
    WriteString('LibraryDir',LibraryDir);
    //
    if DirectoryExistsUTF8(Ed_SnippetDir.text) then SnippetDir:=AppendPathDelim(TrimFilename(Ed_SnippetDir.text))
    else raise exception.create('Snippet folder could not be changed');
    WriteString('SnippetDir',SnippetDir);
    //
    if DirectoryExistsUTF8(Ed_ProjectsDir.text) then ProjectsDir:=AppendPathDelim(TrimFilename(Ed_ProjectsDir.text))
    else raise exception.create('SBA Projects folder could not be changed');
    WriteString('ProjectsDir',ProjectsDir);
    //
    DefAuthor:=Ed_DefAuthor.Text;
    WriteString('DefAuthor',DefAuthor);
    //
    LibAsReadOnly:=CB_LibAsReadOnly.Checked;
    WriteBoolean('LibAsReadOnly',LibAsReadOnly);
    //
    AutoOpenPrjF:=CB_AutoOpenPrjF.Checked;
    WriteBoolean('AutoOpenPrjF',AutoOpenPrjF);
    //
    WriteString('SBAbaseDir',SBAbaseDir);
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
  Ed_DefAuthor.Text:=DefAuthor;
  CB_LibAsReadOnly.checked:=LibAsReadOnly;
end;


end.

