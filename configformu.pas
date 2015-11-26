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
    Ed_EditorFontSize: TComboBox;
    Ed_EditorFontName: TComboBox;
    Ed_LibraryDir: TDirectoryEdit;
    Ed_SnippetsDir: TDirectoryEdit;
    Ed_ProjectsDir: TDirectoryEdit;
    Ed_ProgramsDir: TDirectoryEdit;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Ed_DefAuthor: TLabeledEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    L_ConfigDir: TStaticText;
    B_FontSelect: TSpeedButton;
    procedure B_FontSelectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

const  //based in sub dirs in zip file from Github
  DefSBAbaseDir='SBA-master';
  DefLibraryDir='SBA-Library-master';
  DefSnippetsDir='SBA-Snippets-master';
  DefProgramsDir='SBA-Programs-master';

  DefProjectsDir='sbaprojects';

  cSBAbaseZipFile='sbamaster.zip';
  cSBAlibraryZipFile='sbalibrary.zip';
  cSBAprogramsZipFile='sbaprograms.zip';
  cSBAsnippetsZipFile='sbasnippets.zip';
  cSBARepoZipFile='/archive/master.zip';

var
  ConfigForm: TConfigForm;
  ConfigDir,LibraryDir,SnippetsDir,ProgramsDir,ProjectsDir,SBAbaseDir:string;
  DefAuthor,EditorFontName:string;
  EditorFontSize:integer;
  LibAsReadOnly:Boolean;
  AutoOpenPrjF:Boolean;
  IpCoreList,SnippetsList,ProgramsList:Tstringlist;

function GetConfigValues:boolean;
function SetConfigValues:boolean;
procedure UpdateLists;

implementation

uses MainFormU, SBAProgContrlrU, UtilsU, DebugFormU;

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
  With MainForm.IniStor do
  begin
    IniFileName:=GetAppConfigFile(false);
    ConfigDir:=ReadString('ConfigDir',GetAppConfigDirUTF8(false));
    SBAbaseDir:=ReadString('SBAbaseDir',ConfigDir+DefSBAbaseDir+PathDelim);
    LibraryDir:=ReadString('LibraryDir',ConfigDir+DefLibraryDir+PathDelim);
    SnippetsDir:=ReadString('SnippetsDir',ConfigDir+DefSnippetsDir+PathDelim);
    ProgramsDir:=ReadString('ProgramsDir',ConfigDir+DefProgramsDir+PathDelim);
    ProjectsDir:=ReadString('ProjectsDir',GetUserDir+DefProjectsDir+PathDelim);
    DefAuthor:=ReadString('DefAuthor','Author');
    EditorFontName:=ReadString('EditorFontName','Courier New');
    EditorFontSize:=ReadInteger('EditorFontSize',10);
    if Screen.Fonts.IndexOf(EditorFontName)=-1 then EditorFontName:='Courier New';
    LibAsReadOnly:=ReadBoolean('LibAsReadOnly',true);
    AutoOpenPrjF:=ReadBoolean('AutoOpenPrjF',true);
  end;

  InfoLn('ConfigDir: '+ConfigDir);
  If Not DirectoryExistsUTF8(ConfigDir) then
    If Not ForceDirectoriesUTF8(ConfigDir) Then
    begin
      ShowMessage('Failed to create config folder!: '+ConfigDir);
      MainForm.Close;
      Exit;
    end;

  InfoLn('ProjectsDir: '+ProjectsDir);
  If Not DirectoryExistsUTF8(ProjectsDir) then
    If Not ForceDirectoriesUTF8(ProjectsDir) Then
    begin
      ShowMessage('Failed to create SBA projects folder: '+ProjectsDir+#13#10' the system is going to try with the default path: '+GetUserDir+DefProjectsDir+PathDelim);
      ProjectsDir:=GetUserDir+DefProjectsDir+PathDelim;
      If Not ForceDirectoriesUTF8(ProjectsDir) Then Exit;
    end;

  InfoLn('LibraryDir: '+LibraryDir);
  If Not DirectoryExistsUTF8(LibraryDir) then
  begin
    CopyFile(Application.location+cSBAlibraryZipFile,ConfigDir+cSBAlibraryZipFile);
    if not Unzip(ConfigDir+cSBAlibraryZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create SBA library folder: '+LibraryDir);
      MainForm.Close;
      Exit;
    end;
  end;

  InfoLn('SnippetsDir: '+SnippetsDir);
  If Not DirectoryExistsUTF8(SnippetsDir) then
  begin
    CopyFile(Application.location+cSBAsnippetsZipFile,ConfigDir+cSBAsnippetsZipFile);
    if not Unzip(ConfigDir+cSBAsnippetsZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create code snippets folder: '+SnippetsDir);
      MainForm.Close;
      Exit;
    end;
  end;

  InfoLn('ProgramsDir: '+ProgramsDir);
  If Not DirectoryExistsUTF8(ProgramsDir) then
  begin
    CopyFile(Application.location+cSBAprogramsZipFile,ConfigDir+cSBAprogramsZipFile);
    if not Unzip(ConfigDir+cSBAprogramsZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create code programs folder: '+ProgramsDir);
      MainForm.Close;
      Exit;
    end;
  end;

  InfoLn('SBAbaseDir: '+SBAbaseDir);
  If Not DirectoryExistsUTF8(SBAbaseDir) then
  begin
    CopyFile(Application.location+cSBABaseZipFile,ConfigDir+cSBABaseZipFile);
    if not Unzip(ConfigDir+cSBABaseZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create SBA base folder: '+SBAbaseDir);
      MainForm.Close;
      Exit;
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
    { TODO : Forzar la creación de directorios}
    Ed_LibraryDir.text:=AppendPathDelim(TrimFilename(Ed_LibraryDir.text));
    if LibraryDir<>Ed_LibraryDir.text then
    begin
      if DirectoryExistsUTF8(Ed_LibraryDir.text) then LibraryDir:=Ed_LibraryDir.text
      else begin
        showmessage('Library folder could not be changed');
        exit;
      end;
      WriteString('LibraryDir',LibraryDir);
    end;
    Ed_SnippetsDir.text:=AppendPathDelim(TrimFilename(Ed_SnippetsDir.text));
    if SnippetsDir<>Ed_SnippetsDir.text then
    begin
      if DirectoryExistsUTF8(Ed_SnippetsDir.text) then SnippetsDir:=Ed_SnippetsDir.text
      else begin
        showmessage('Snippet folder could not be changed');
        exit;
      end;
      WriteString('SnippetsDir',SnippetsDir);
    end;
    //
    Ed_ProgramsDir.text:=AppendPathDelim(TrimFilename(Ed_ProgramsDir.text));
    if ProgramsDir<>Ed_ProgramsDir.text then
    begin
      if DirectoryExistsUTF8(Ed_ProgramsDir.text) then ProgramsDir:=Ed_ProgramsDir.text
      else begin
        showmessage('Snippet folder could not be changed');
        exit;
      end;
      WriteString('ProgramsDir',ProgramsDir);
    end;
    //
    Ed_ProjectsDir.text:=AppendPathDelim(TrimFilename(Ed_ProjectsDir.text));
    if ProjectsDir<>Ed_ProjectsDir.text then
    begin
      if ForceDirectoriesUTF8(Ed_ProjectsDir.text) then ProjectsDir:=Ed_ProjectsDir.text
      else begin
        showmessage('SBA Projects folder could not be changed');
        exit;
      end;
      WriteString('ProjectsDir',ProjectsDir);
    end;
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
    EditorFontName:=Ed_EditorFontName.Text;
    WriteString('EditorFontName',EditorFontName);
    MainForm.SynEdit_X.Font.Name:=EditorFontName;
    //
    EditorFontSize:=StrToIntDef(Ed_EditorFontSize.Text,10);
    WriteInteger('EditorFontSize',EditorFontSize);
    MainForm.SynEdit_X.Font.Size:=EditorFontSize;
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
  CB_AutoOpenPrjF.Checked:=AutoOpenPrjF;
  Ed_EditorFontName.Text:=EditorFontName;
end;

procedure TConfigForm.FormCreate(Sender: TObject);
begin
  Ed_EditorFontName.items.assign(screen.fonts);
end;

procedure TConfigForm.B_FontSelectClick(Sender: TObject);
begin
  FontDialog1.Font.Name:=EditorFontName;
  FontDialog1.Font.Size:=EditorFontSize;
  if FontDialog1.Execute then
  begin
    Ed_EditorFontName.Text:=FontDialog1.Font.Name;
    Ed_EditorFontSize.Text:=IntToStr(FontDialog1.Font.Size);
  end;
end;

end.

