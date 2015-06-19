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
    Ed_SnippetsDir: TDirectoryEdit;
    Ed_ProjectsDir: TDirectoryEdit;
    Ed_ProgramsDir: TDirectoryEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Ed_DefAuthor: TLabeledEdit;
    Label4: TLabel;
    L_ConfigDir: TStaticText;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

const
  DefSBAbaseDir='SBA-master';
  DefLibraryDir='SBA-Library-master';
  DefSnippetsDir='SBA-Snippets-master';
  DefProgramsDir='SBA-Programs-master';
  DefProjectsDir='sbaprojects';

var
  ConfigForm: TConfigForm;
  ConfigDir,LibraryDir,SnippetsDir,ProgramsDir,ProjectsDir,SBAbaseDir:string;
  DefAuthor:string;
  LibAsReadOnly:Boolean;
  AutoOpenPrjF:Boolean;
  IpCoreList,SnippetsList,ProgramsList:Tstringlist;

function GetConfigValues:boolean;
function SetConfigValues:boolean;
procedure UpdateLists;

implementation

uses MainFormU, SBAProgContrlrU, UtilsU, LibraryFormU;

{$R *.lfm}

procedure UpdateLists;
begin
  GetAllFileNames(LibraryDir,'*.ini',IpCoreList);
  GetAllFileNames(SnippetsDir,'*.snp',SnippetsList);
  GetAllFileNames(ProgramsDir,'*.prg',ProgramsList);
end;

function GetConfigValues: boolean;
begin
  result:=false;
  MainForm.IniStor.IniFileName:=GetAppConfigFile(false);
  With MainForm.IniStor do
  begin
    ConfigDir:=ReadString('ConfigDir',GetAppConfigDir(false));
    SBAbaseDir:=ReadString('SBAbaseDir',ConfigDir+DefSBAbaseDir+PathDelim);
    LibraryDir:=ReadString('LibraryDir',ConfigDir+DefLibraryDir+PathDelim);
    SnippetsDir:=ReadString('SnippetsDir',ConfigDir+DefSnippetsDir+PathDelim);
    ProgramsDir:=ReadString('ProgramsDir',ConfigDir+DefProgramsDir+PathDelim);
    ProjectsDir:=ReadString('ProjectsDir',GetUserDir+DefProjectsDir+PathDelim);
    DefAuthor:=ReadString('DefAuthor','Author');
    LibAsReadOnly:=ReadBoolean('LibAsReadOnly',true);
    AutoOpenPrjF:=ReadBoolean('AutoOpenPrjF',true);
  end;
  If Not DirectoryExistsUTF8(ConfigDir) then
    If Not CreateDirUTF8(ConfigDir) Then
      raise exception.create('Failed to create config folder!');

  If Not DirectoryExistsUTF8(ProjectsDir) then
    If Not CreateDirUTF8(ProjectsDir) Then
      raise exception.create('Failed to create SBA projects folder!');

  If Not DirectoryExistsUTF8(LibraryDir) then
  begin
    CopyFile(Application.location+cSBAlibraryZipFile,ConfigDir+cSBAlibraryZipFile);
    if not Unzip(ConfigDir+cSBAlibraryZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create SBA library folder!');
      halt(1);
    end;
  end;

  If Not DirectoryExistsUTF8(SnippetsDir) then
  begin
    CopyFile(Application.location+cSBAsnippetsZipFile,ConfigDir+cSBAsnippetsZipFile);
    if not Unzip(ConfigDir+cSBAsnippetsZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create code snippets folder!');
      halt(1);
    end;
  end;

  If Not DirectoryExistsUTF8(ProgramsDir) then
  begin
    CopyFile(Application.location+cSBAprogramsZipFile,ConfigDir+cSBAprogramsZipFile);
    if not Unzip(ConfigDir+cSBAprogramsZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create code programs folder!');
      halt(1);
    end;
  end;

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
    if DirectoryExistsUTF8(Ed_SnippetsDir.text) then SnippetsDir:=AppendPathDelim(TrimFilename(Ed_SnippetsDir.text))
    else raise exception.create('Snippet folder could not be changed');
    WriteString('SnippetsDir',SnippetsDir);
    //
    if DirectoryExistsUTF8(Ed_ProgramsDir.text) then ProgramsDir:=AppendPathDelim(TrimFilename(Ed_ProgramsDir.text))
    else raise exception.create('Snippet folder could not be changed');
    WriteString('ProgramsDir',ProgramsDir);
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
  Ed_SnippetsDir.Text:=SnippetsDir;
  Ed_ProgramsDir.Text:=ProgramsDir;
  Ed_ProjectsDir.Text:=ProjectsDir;
  Ed_DefAuthor.Text:=DefAuthor;
  CB_LibAsReadOnly.checked:=LibAsReadOnly;
end;


end.

