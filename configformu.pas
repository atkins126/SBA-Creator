unit ConfigFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LazFileUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, EditBtn, ButtonPanel, ComCtrls;

type

  { TConfigForm }

  TConfigForm = class(TForm)
    B_LoadTheme: TBitBtn;
    ButtonPanel1: TButtonPanel;
    B_FontSelect: TSpeedButton;
    CB_AutoOpenEdfiles: TCheckBox;
    CB_AutoOpenPrjF: TCheckBox;
    CB_CtrlAdvMode: TCheckBox;
    CB_LibAsReadOnly: TCheckBox;
    Ed_DefAuthor: TLabeledEdit;
    Ed_EditorFontName: TComboBox;
    Ed_EditorFontSize: TComboBox;
    Ed_LibraryDir: TDirectoryEdit;
    Ed_ProgramsDir: TDirectoryEdit;
    Ed_ProjectsDir: TDirectoryEdit;
    Ed_SnippetsDir: TDirectoryEdit;
    FontDialog1: TFontDialog;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    L_ConfigDir: TLabel;
    Notebook1: TNotebook;
    ed_SelTheme: TRadioGroup;
    Theme: TPage;
    Paths: TPage;
    Parameters: TPage;
    Editor: TPage;
    Panel2: TPanel;
    Ed_SBAversion: TRadioGroup;
    Splitter1: TSplitter;
    TreeView1: TTreeView;
    procedure B_FontSelectClick(Sender: TObject);
    procedure B_LoadThemeClick(Sender: TObject);
    procedure ed_SelThemeSelectionChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
  private
    { private declarations }
  public
    { public declarations }
  end;

const  //based in sub dirs in zip file from Github
  DefSBAbaseDir='SBA-master';
  DefLibraryDir='SBA-Library';
  DefSnippetsDir='SBA-Snippets';
  DefProgramsDir='SBA-Programs';

  DefProjectsDir='sbaprojects';

  cSBAbaseZipFile='sbamaster.zip';
  cSBAlibraryZipFile='sbalibrary.zip';
  cSBAprogramsZipFile='sbaprograms.zip';
  cSBAsnippetsZipFile='sbasnippets.zip';
  cSBARepoZipFile='/archive/master.zip';
  cSBAthemeZipFile='theme.zip';
  cLocSBAprjparams='lprjparams.ini'; // Save the local parameters for each project file
  cSBApluginsZipFile='plugins.zip';

var
  ConfigForm: TConfigForm;
  AppDir,ConfigDir,LibraryDir,SnippetsDir,ProgramsDir,ProjectsDir,SBAbaseDir:string;
  LocSBAPrjParams:string;  //Local associated Prj parameters ini file
  DefAuthor,EditorFontName:string;
  EditorFontSize:integer;
  LibAsReadOnly:Boolean;
  AutoOpenPrjF:Boolean;
  AutoOpenEdFiles:Boolean;
  CtrlAdvMode:Boolean;
  IpCoreList,SnippetsList,ProgramsList,PlugInsList:Tstringlist;
  SBAversion:integer;
  SelTheme:integer;

function GetConfigValues:boolean;
function SetConfigValues:boolean;
function SetUpConfig:boolean;
function SBAVersionToStr(v:integer):string;
function StrToSBAVersion(s:string):integer;
procedure UpdateLists;

implementation

uses MainFormU, SBAProgContrlrU, UtilsU, DebugFormU;

{$R *.lfm}

function SBAVersionToStr(v: integer): string;
begin
  case v of
    0: Result:='1.1';
    1: Result:='1.2';
    else Result:='1.1';
  end;
end;

function StrToSBAVersion(s:string): integer;
begin
  case s of
    '1.1' : Exit(0);
    '1.2' : Exit(1);
    else Exit(0);
  end;
end;

procedure UpdateLists;
begin
  GetAllFileNames(LibraryDir,'*.ini',IpCoreList);
  GetAllFileNames(SnippetsDir,'*.snp',SnippetsList);
  GetAllFileNames(ProgramsDir,'*.prg',ProgramsList);
  GetAllFileNamesAndPaths(ConfigDir+'plugins','*.ini',PlugInsList);
end;

function SetUpConfig: boolean;
begin
  result:=false;
  Info('SetUpConfig','ConfigDir= '+ConfigDir);
  If Not DirectoryExistsUTF8(ConfigDir) then
    If Not ForceDirectoriesUTF8(ConfigDir) Then
    begin
      ShowMessage('Failed to create config folder!: '+ConfigDir);
      Exit;
    end;

  Info('SetUpConfig','ProjectsDir= '+ProjectsDir);
  If Not DirectoryExistsUTF8(ProjectsDir) then
    If Not ForceDirectoriesUTF8(ProjectsDir) Then
    begin
      ShowMessage('Failed to create SBA projects folder: '+ProjectsDir+#13#10' the system is going to try with the default path: '+GetUserDir+DefProjectsDir+PathDelim);
      ProjectsDir:=GetUserDir+DefProjectsDir+PathDelim;
      If Not ForceDirectoriesUTF8(ProjectsDir) Then Exit;
    end;

  Info('SetUpConfig','LibraryDir= '+LibraryDir);
  If Not DirectoryExistsUTF8(LibraryDir) then
    If not Unzip(AppDir+cSBAlibraryZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create SBA library folder: '+LibraryDir);
      Exit;
    end;

  Info('SetUpConfig','SnippetsDir= '+SnippetsDir);
  If Not DirectoryExistsUTF8(SnippetsDir) then
    If not Unzip(AppDir+cSBAsnippetsZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create code snippets folder: '+SnippetsDir);
      Exit;
    end;

  Info('SetUpConfig','ProgramsDir= '+ProgramsDir);
  If Not DirectoryExistsUTF8(ProgramsDir) then
    If not Unzip(AppDir+cSBAprogramsZipFile,ConfigDir) then
    begin
      ShowMessage('Failed to create code programs folder: '+ProgramsDir);
      Exit;
    end;

  Info('SetUpConfig','SBAbaseDir= '+SBAbaseDir);
  If FileExists(AppDir+cSBABaseZipFile) then
    If Unzip(AppDir+cSBABaseZipFile,ConfigDir) then DeleteFile(AppDir+cSBABaseZipFile)
    else begin
      ShowMessage('Failed to create SBA base folder: '+SBAbaseDir);
      Exit;
    end;

  Info('SetUpConfig','ThemeDir= '+ConfigDir+'theme');
  If FileExists(AppDir+cSBAthemeZipFile) then
    If Unzip(AppDir+cSBAthemeZipFile,ConfigDir+'theme') then DeleteFile(AppDir+cSBAthemeZipFile)
    else begin
      ShowMessage('Failed to create theme folder: '+ConfigDir+'theme');
      Exit;
    end;

  Info('SetUpConfig','PlugInsDir= '+ConfigDir+'plugins');
  If FileExists(AppDir+cSBApluginsZipFile) then
    If Unzip(AppDir+cSBApluginsZipFile,ConfigDir+'plugins') then DeleteFile(AppDir+cSBApluginsZipFile)
    else begin
      ShowMessage('Failed to create plugins folder: '+ConfigDir+'plugins');
      Exit;
    end;

  if FileExists(AppDir+cSBADefPrgTemplate) then if CopyFile(AppDir+cSBADefPrgTemplate,ConfigDir+cSBADefPrgTemplate) then DeleteFile(AppDir+cSBADefPrgTemplate);
  if FileExists(AppDir+cSBAAdvPrgTemplate) then if CopyFile(AppDir+cSBAAdvPrgTemplate,ConfigDir+cSBAAdvPrgTemplate) then DeleteFile(AppDir+cSBAAdvPrgTemplate);
  if FileExists(AppDir+'newbanner.gif') then if CopyFile(AppDir+'banner.gif',ConfigDir+'newbanner.gif') then DeleteFile(AppDir+'newbanner.gif');
  if FileExists(AppDir+'templates.ini') then if CopyFile(AppDir+'templates.ini',ConfigDir+'templates.ini') then DeleteFile(AppDir+'templates.ini');
  if FileExists(AppDir+'autocomplete.txt') then if CopyFile(AppDir+'autocomplete.txt',ConfigDir+'autocomplete.txt')then DeleteFile(AppDir+'autocomplete.txt');

  result:=true;
end;

function GetConfigValues: boolean;
begin
  result:=false;
  AppDir:=Application.location;
  Info('GetConfigValues','Application folder: '+AppDir);
  {$IFDEF Darwin}
  AppDir := AppendPathDelim(copy(AppDir,1,Pos('/SBAcreator.app',AppDir)-1));
  {$ENDIF}
  If not FileExistsUTF8(GetAppConfigFile(false)) then
  begin
    MainForm.Top:=0;
    MainForm.Left:=0;
  end;
  With MainForm.IniStor do
  begin
    IniFileName:=GetAppConfigFile(false);
    Info('GetConfigValues','Config File: '+IniFileName);
    ConfigDir:=ReadString('ConfigDir',GetAppConfigDirUTF8(false));
    SBAbaseDir:=ReadString('SBAbaseDir',ConfigDir+DefSBAbaseDir+PathDelim);
    LibraryDir:=ReadString('LibraryDir',ConfigDir+DefLibraryDir+PathDelim);
    SnippetsDir:=ReadString('SnippetsDir',ConfigDir+DefSnippetsDir+PathDelim);
    ProgramsDir:=ReadString('ProgramsDir',ConfigDir+DefProgramsDir+PathDelim);
    ProjectsDir:=ReadString('ProjectsDir',GetUserDir+DefProjectsDir+PathDelim);
    LocSBAPrjParams:=ConfigDir+cLocSBAprjparams;
    DefAuthor:=ReadString('DefAuthor','Author');
    EditorFontName:=ReadString('EditorFontName','Courier New');
    EditorFontSize:=ReadInteger('EditorFontSize',10);
    if Screen.Fonts.IndexOf(EditorFontName)=-1 then EditorFontName:='Courier New';
    LibAsReadOnly:=ReadBoolean('LibAsReadOnly',true);
    AutoOpenPrjF:=ReadBoolean('AutoOpenPrjF',true);
    AutoOpenEdFiles:=ReadBoolean('AutoOpenEdFiles',true);
    CtrlAdvMode:=ReadBoolean('CtrlAdvMode',false);
    SBAversion:=ReadInteger('SBAversion',1);
    SelTheme:=ReadInteger('SelTheme',0);
  end;
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
        showmessage('Programs folder could not be changed');
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
    AutoOpenEdfiles:=CB_AutoOpenEdfiles.Checked;
    WriteBoolean('AutoOpenEdfiles',AutoOpenEdfiles);
    //
    CtrlAdvMode:=CB_CtrlAdvMode.Checked;
    WriteBoolean('CtrlAdvMode',CtrlAdvMode);
    //
    EditorFontName:=Ed_EditorFontName.Text;
    WriteString('EditorFontName',EditorFontName);
    //
    EditorFontSize:=StrToIntDef(Ed_EditorFontSize.Text,10);
    WriteInteger('EditorFontSize',EditorFontSize);
    //
    WriteString('SBAbaseDir',SBAbaseDir);
    //
    SBAversion:=Ed_SBAversion.ItemIndex;
    WriteInteger('SBAversion',SBAversion);
    //
    SelTheme:=Ed_SelTheme.ItemIndex;
    WriteInteger('SelTheme',SelTheme);
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
  CB_AutoOpenEdfiles.Checked:=AutoOpenEdfiles;
  CB_CtrlAdvMode.Checked:=CtrlAdvMode;
  Ed_EditorFontName.Text:=EditorFontName;
  Ed_SBAversion.ItemIndex:=SBAversion;
  Ed_SelTheme.ItemIndex:=SelTheme;
end;

procedure TConfigForm.TreeView1Change(Sender: TObject; Node: TTreeNode);
var index:Integer;
begin
  index:=Notebook1.Pages.IndexOf(Node.Text);
  if index>=0 then Notebook1.PageIndex:=Index;
end;

procedure TConfigForm.FormCreate(Sender: TObject);
begin
  Ed_EditorFontName.items.assign(screen.fonts);
  TreeView1.Selected:=TreeView1.Items[0];
end;

procedure TConfigForm.FormDestroy(Sender: TObject);
begin
  Info('TConfigForm','FormDestroy');
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

procedure TConfigForm.B_LoadThemeClick(Sender: TObject);
begin
  MainForm.LoadTheme(ConfigDir+'theme'+PathDelim);
end;

procedure TConfigForm.ed_SelThemeSelectionChanged(Sender: TObject);
begin
  SelTheme:=Ed_SelTheme.ItemIndex;
end;

end.

