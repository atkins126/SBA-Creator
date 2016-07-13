unit LibraryFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ListViewFilterEdit, Forms,
  Controls, Graphics, Dialogs, ComCtrls, Buttons, ExtCtrls,
  FileUtil, LazFileUtils,
  AsyncProcess, lclintf, StdCtrls, EditBtn, IniPropStorage,
  SBASnippetU, SBAProgramU, IniFilesUTF8, StringListUTF8;

type

  { TLibraryForm }
  TLibraryForm = class(TForm)
    B_AddtoLibrary: TBitBtn;
    B_AddtoPrograms: TBitBtn;
    B_AddtoSnippets: TBitBtn;
    B_SBAbaseGet: TBitBtn;
    B_SBAbaseSurf: TBitBtn;
    B_SBAlibraryGet: TBitBtn;
    B_SBAlibrarySurf: TBitBtn;
    B_SBAprogramsGet: TBitBtn;
    B_SBAprogramsSurf: TBitBtn;
    B_SBAsnippetsGet: TBitBtn;
    B_SBAsnippetsSurf: TBitBtn;
    Ed_SBAbase: TEditButton;
    Ed_SBAlibrary: TEditButton;
    Ed_SBAprograms: TEditButton;
    Ed_SBARepoZipFile: TComboBox;
    Ed_SBAsnippets: TEditButton;
    GB_SBAbase: TGroupBox;
    GB_SBAlibrary: TGroupBox;
    GB_SBAprograms: TGroupBox;
    GB_SBAsnippets: TGroupBox;
    IdleTimer1: TIdleTimer;
    IniPS: TIniPropStorage;
    IPCoreImage: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    L_TitleIPCore: TLabel;
    Panel7: TPanel;
    ProgramDescription: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    LibraryPages: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    PB_SBAbase: TProgressBar;
    PB_SBAlibrary: TProgressBar;
    PB_SBAprograms: TProgressBar;
    PB_SBAsnippets: TProgressBar;
    Process1: TAsyncProcess;
    IpCoreDescription: TMemo;
    SnippetDescription: TMemo;
    SnippetsFilter: TListViewFilterEdit;
    IPCoresFilter: TListViewFilterEdit;
    ProgramsFilter: TListViewFilterEdit;
    LV_Snippets: TListView;
    IPCores: TTabSheet;
    Programs: TTabSheet;
    Snippets: TTabSheet;
    LV_IPCores: TListView;
    LV_Programs: TListView;
    SB: TStatusBar;
    UpdateRep: TTabSheet;
    URL_IpCore: TStaticText;
    procedure B_AddtoSnippetsClick(Sender: TObject);
    procedure B_AddtoProgramsClick(Sender: TObject);
    procedure B_AddtoLibraryClick(Sender: TObject);
    procedure B_SBAbaseGetClick(Sender: TObject);
    procedure B_SBAbaseSurfClick(Sender: TObject);
    procedure B_SBAlibraryGetClick(Sender: TObject);
    procedure B_SBAlibrarySurfClick(Sender: TObject);
    procedure B_SBAprogramsGetClick(Sender: TObject);
    procedure B_SBAprogramsSurfClick(Sender: TObject);
    procedure B_SBAsnippetsGetClick(Sender: TObject);
    procedure B_SBAsnippetsSurfClick(Sender: TObject);
    procedure Ed_SBAlibraryButtonClick(Sender: TObject);
    procedure Ed_SBAprogramsButtonClick(Sender: TObject);
    procedure Ed_SBAsnippetsButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure LV_IPCoresClick(Sender: TObject);
    procedure LV_IPCoresCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure LV_ProgramsClick(Sender: TObject);
    procedure Process1ReadData(Sender: TObject);
    procedure Process1Terminate(Sender: TObject);
    procedure LV_ProgramsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure LV_SnippetsClick(Sender: TObject);
    procedure LV_SnippetsCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure URL_IpCoreClick(Sender: TObject);
  private
    procedure AddItemToIPCoresFilter(FileIterator: TFileIterator);
    procedure AddItemToProgramsFilter(FileIterator: TFileIterator);
    procedure AddItemToSnippetsFilter(FileIterator: TFileIterator);
    function EndGet(zfile, defdir: string): boolean;
    function EndGetBase: boolean;
    procedure EndGetLibrary;
    procedure EndGetPrograms;
    procedure EndGetSnippets;
    function GetVersion(f: string): string;
    function LookupFilterItem(S: string; LV: TListViewDataList): integer;
    { private declarations }
  public
    { public declarations }
    SBASnippet:TSBASnippet;
    SBAProgram:TSBAProgram;
    procedure UpdateLists;
  end;

var
  LibraryForm: TLibraryForm;

function ShowLibraryForm:TModalResult;

implementation

{$R *.lfm}

uses ConfigFormU, UtilsU, DebugFormU;

type
  tProcessStatus=(Idle,GetBase, GetLibrary, GetPrograms, GetSnippets);

var
  ProcessStatus:TProcessStatus=Idle;

function ShowLibraryForm: TModalResult;
begin
  LibraryForm.UpdateLists;
  result:=LibraryForm.ShowModal;
end;

function ProcessWGET(url,f:string;status:TProcessStatus):boolean;
begin
  { TODO : Encapsular el process en forma programática y enviar todo el procedimiento hacia la unidad de herramientas }
  result:=false;
  While ProcessStatus<>idle do
  begin
    sleep(300);
    application.ProcessMessages;
  end;
  infoln('');
  infoln('');
  infoln('source: '+url);
  infoln('destination: '+f);
  infoln('--------------------------------------');
  infoln('');
  With LibraryForm do
  begin
    process1.Parameters.Clear;
    process1.CurrentDirectory:=ConfigDir;
    {$IFDEF WINDOWS}
    process1.Executable:=AppDir+'tools'+PathDelim+'wget.exe';
    {$ENDIF}
    {$IFDEF LINUX}
    process1.Executable:='wget';
    {$ENDIF}
    {$IFDEF DARWIN}
    process1.Executable:='curl';
    {$ENDIF}
    {$IFNDEF DEBUG}
    {$IFDEF DARWIN}
    process1.Parameters.Add('-s');
    {$ELSE}
    process1.Parameters.Add('-q');
    {$ENDIF}
    {$ENDIF}
    {$IFDEF WINDOWS}
    process1.Parameters.Add('-O');
    process1.Parameters.Add('"'+f+'"');
    process1.Parameters.Add('--no-check-certificate');
    process1.Parameters.Add(url);
    {$ENDIF}
    {$IFDEF LINUX}
    process1.Parameters.Add('-O');
    process1.Parameters.Add(f);
    process1.Parameters.Add('--no-check-certificate');
    process1.Parameters.Add(url);
    {$ENDIF}
    {$IFDEF DARWIN}
    process1.Parameters.Add('-L');
    process1.Parameters.Add(url);
    process1.Parameters.Add('-o');
    process1.Parameters.Add(f);
    {$ENDIF}
    ProcessStatus:=status;
    try
      process1.Execute;
      result:=true;
    except
      On E:Exception do ShowMessage('The web download tool can not be used: '+E.Message);
    end;
  end;
end;


{ TLibraryForm }

procedure TLibraryForm.LV_SnippetsClick(Sender: TObject);
var
  f:string;
  l:TListItem;
begin
  SnippetDescription.Clear;
  L:=LV_Snippets.Selected;
  if (L=nil) or (LV_Snippets.Items.Count=0) then exit;
  B_AddtoSnippets.Enabled:=SnippetsList.IndexOf(L.Caption)=-1;
  f:=L.SubItems[0];
  if f<>'' then
  begin
    SBASnippet.filename:=f;
    if SBASnippet.description.count>0 then SnippetDescription.Lines.Assign(SBASnippet.description);
  end;
end;

procedure TLibraryForm.LV_SnippetsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var Icolor:TColor;
begin
  if SnippetsList.IndexOf(Item.Caption)=-1 then Icolor:=clGreen else Icolor:=clBlack;
  Sender.Canvas.Font.Color:=Icolor;
end;

procedure TLibraryForm.URL_IpCoreClick(Sender: TObject);
begin
  OpenURL(URL_IpCore.Caption);
end;

procedure TLibraryForm.B_SBAbaseSurfClick(Sender: TObject);
begin
  OpenURL(Ed_SBAbase.Text);
end;

procedure TLibraryForm.B_SBAlibraryGetClick(Sender: TObject);
begin
  PB_SBALibrary.Style:=pbstMarquee;
  SB.SimpleText:='Downloading file '+cSBAlibraryZipFile;
  ProcessWGET(Ed_SBAlibrary.Text+Ed_SBARepoZipFile.Text,ConfigDir+cSBAlibraryZipFile,GetLibrary);
end;

procedure TLibraryForm.B_SBAlibrarySurfClick(Sender: TObject);
begin
  OpenURL(Ed_SBAlibrary.Text);
end;

procedure TLibraryForm.B_SBAprogramsGetClick(Sender: TObject);
begin
  PB_SBAprograms.Style:=pbstMarquee;
  SB.SimpleText:='Downloading file '+cSBAprogramsZipFile;
  ProcessWGET(Ed_SBAprograms.Text+Ed_SBARepoZipFile.Text,ConfigDir+cSBAprogramsZipFile,Getprograms);
end;

procedure TLibraryForm.B_SBAprogramsSurfClick(Sender: TObject);
begin
  OpenURL(Ed_SBAprograms.Text);
end;

procedure TLibraryForm.B_SBAsnippetsGetClick(Sender: TObject);
begin
  PB_SBAsnippets.Style:=pbstMarquee;
  SB.SimpleText:='Downloading file '+cSBAsnippetsZipFile;
  ProcessWGET(Ed_SBAsnippets.Text+Ed_SBARepoZipFile.Text,ConfigDir+cSBAsnippetsZipFile,Getsnippets);
end;

procedure TLibraryForm.B_SBAsnippetsSurfClick(Sender: TObject);
begin
  OpenURL(Ed_SBAsnippets.Text);
end;

procedure TLibraryForm.Ed_SBAlibraryButtonClick(Sender: TObject);
begin
  Ed_SBAlibrary.text:='http://sbalibrary.accesus.com';
end;

procedure TLibraryForm.Ed_SBAprogramsButtonClick(Sender: TObject);
begin
  Ed_SBAprograms.Text:='http://sbaprograms.accesus.com';
end;

procedure TLibraryForm.Ed_SBAsnippetsButtonClick(Sender: TObject);
begin
  Ed_SBAsnippets.Text:='http://sbasnippets.accesus.com'
end;

procedure TLibraryForm.FormCreate(Sender: TObject);
begin
  IniPS.IniFileName:=GetAppConfigFile(false);
  SBASnippet:=TSBASnippet.Create;
  SBAProgram:=TSBAProgram.Create;
  {$IFDEF LINUX}
  //BUG:Workaround to correct an exception when the focus return to "update repositories" page-
  Ed_SBAbase.Enabled:=false;
  {$ENDIF}
end;

procedure TLibraryForm.FormDestroy(Sender: TObject);
begin
  if assigned(SBASnippet) then FreeAndNil(SBASnippet);
  if assigned(SBAProgram) then FreeAndNil(SBAProgram);
end;

procedure TLibraryForm.IdleTimer1Timer(Sender: TObject);
begin
  if (not Process1.Running) and (ProcessStatus<>Idle) then
    Process1Terminate(Sender);
end;

procedure TLibraryForm.LV_IPCoresClick(Sender: TObject);
var
  f:string;
  l:TListItem;
  Ini:TIniFile;
begin
  IpCoreDescription.Clear;
  L:=LV_IPCores.Selected;
  if (L=nil) or (LV_IPCores.Items.Count=0) then exit;
  B_AddtoLibrary.Enabled:=(L.SubItems[1]='N') or (L.SubItems[1]='U');
  f:=L.SubItems[0];
  if f<>'' then
  try
    Ini:=TINIFile.Create(f);
    IpCoreDescription.Caption:=Ini.ReadString('MAIN','Description','');
    L_TitleIpCore.Caption:=Ini.ReadString('MAIN','Title','');
    URL_IpCore.Caption:=Ini.ReadString('MAIN','DataSheetURL','');
  finally
    Ini.free;
  end;
  try
    IPCoreImage.Picture.LoadFromFile(ExtractFilePath(f)+'image.png');
  except
    ON E:Exception do IPCoreImage.Picture.Clear;
  end;
end;

procedure TLibraryForm.LV_IPCoresCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var Icolor:TColor;
begin
  case Item.SubItems[1] of
    'U': Icolor:=clBlue;
    '=': Icolor:=clBlack;
    'N': Icolor:=clGreen;
  else Icolor:=clRed;
  end;
  Sender.Canvas.Font.Color:=Icolor;
{$IFDEF LINUX}
//Workaround to ListView.Canvas.Font in GTK
  if Item.SubItems[1]<>'=' then
  begin
    DefaultDraw:=False;
    Sender.Canvas.Brush.Style:=bsClear;
    Sender.Canvas.TextOut(Item.Left+5, Item.Top+3, Item.Caption);
  end;
{$ENDIF}
end;

procedure TLibraryForm.LV_ProgramsClick(Sender: TObject);
var
  f:string;
  l:TListItem;
begin
  ProgramDescription.Clear;
  L:=LV_Programs.Selected;
  if (L=nil) or (LV_Programs.Items.Count=0) then exit;
  B_AddtoPrograms.Enabled:=ProgramsList.IndexOf(L.Caption)=-1;
  f:=L.SubItems[0];
  if f<>'' then
  begin
    SBAProgram.filename:=f;
    if SBAProgram.description.count>0 then ProgramDescription.Lines.Assign(SBAProgram.description);
  end;
end;

procedure TLibraryForm.Process1ReadData(Sender: TObject);
var
  t:TStringList;
begin
   t:=TStringList.Create;
   t.LoadFromStream(Process1.Output);
   infoln(t.Text);
   t.free;
end;

procedure TLibraryForm.Process1Terminate(Sender: TObject);
var PS:TProcessStatus;
begin
  PS:=ProcessStatus;
  ProcessStatus:=Idle;
  if Process1.NumBytesAvailable>0 then Process1ReadData(Sender);
  case PS of
    GetBase: EndGetBase;
    GetLibrary: EndGetLibrary;
    GetPrograms: EndGetPrograms;
    GetSnippets: EndGetSnippets;
  end;
  infoln('');
  infoln('End of process');
end;

procedure TLibraryForm.LV_ProgramsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var Icolor:TColor;
begin
  if ProgramsList.IndexOf(Item.Caption)=-1 then Icolor:=clGreen else Icolor:=clBlack;
  Sender.Canvas.Font.Color:=Icolor;
end;

procedure TLibraryForm.B_SBAbaseGetClick(Sender: TObject);
begin
  PB_SBABase.Style:=pbstMarquee;
  SB.SimpleText:='Downloading file '+cSBABaseZipFile;
  ProcessWGET(Ed_SBAbase.Text+Ed_SBARepoZipFile.Text,ConfigDir+cSBABaseZipFile,GetBase);
end;

procedure TLibraryForm.B_AddtoLibraryClick(Sender: TObject);
var
  L:TListItem;
  f,d:string;
begin
  L:=LV_IPCores.Selected;
  if (L=nil) or (LV_IPCores.Items.Count=0) then exit;
  f:=ExtractFilePath(L.SubItems[0]);
  d:=AppendPathDelim(LibraryDir+L.Caption);
  try
    if DirectoryExistsUTF8(d) then DirDelete(d);
    if not CopyDirTree(f,d,[cffCreateDestDirectory,cffPreserveTime]) then
      ShowMessage('The IPCore folder could not be copied to the local library.');
  except
    on E:Exception do ShowMessage(E.Message);
  end;
  GetAllFileNames(LibraryDir,'*.ini',IpCoreList);
  LV_IPCores.Invalidate;
  B_AddtoLibrary.Enabled:=IpCoreList.IndexOf(L.Caption)=-1;
end;

procedure TLibraryForm.B_AddtoProgramsClick(Sender: TObject);
var
  L:TListItem;
  f,d:string;
begin
  L:=LV_Programs.Selected;
  if (L=nil) or (LV_Programs.Items.Count=0) then exit;
  f:=L.SubItems[0];
  d:=ProgramsDir+L.Caption+'.prg';
  try
    if FileExistsUTF8(d) or not CopyFile(f,d) then
      ShowMessage('The Program could not be copied to the local library.');
  except
    on E:Exception do Infoln(E.Message);
  end;
  GetAllFileNames(ProgramsDir,'*.prg',ProgramsList);
  LV_Programs.Invalidate;
  B_AddtoPrograms.Enabled:=ProgramsList.IndexOf(L.Caption)=-1;
end;

procedure TLibraryForm.B_AddtoSnippetsClick(Sender: TObject);
var
  L:TListItem;
  f,d:string;
begin
  L:=LV_Snippets.Selected;
  if (L=nil) or (LV_Snippets.Items.Count=0) then exit;
  f:=L.SubItems[0];
  d:=SnippetsDir+L.Caption+'.snp';
  try
    if FileExistsUTF8(d) or not CopyFile(f,d) then
      ShowMessage('The Snippet could not be copied to the local library.');
  except
    on E:Exception do Infoln(E.Message);
  end;
  GetAllFileNames(SnippetsDir,'*.snp',SnippetsList);
  LV_Snippets.Invalidate;
  B_AddtoSnippets.Enabled:=SnippetsList.IndexOf(L.Caption)=-1;
end;

function TLibraryForm.EndGetBase:boolean;
begin
  result:=true;
  SB.SimpleText:='Unziping file '+cSBABaseZipFile;
  if UnZip(ConfigDir+cSBABaseZipFile,ConfigDir+'temp') then
  begin
    infoln('Unziping file and copy '+cSBABaseZipFile);
    SB.SimpleText:='';
    DirDelete(SBAbaseDir);
    result:=(not DirectoryExistsUTF8(SBAbaseDir)) and
            RenameFile(ConfigDir+'temp'+PathDelim+DefSBAbaseDir+PathDelim,SBAbaseDir);
  end;
  PB_SBABase.Style:=pbstNormal;
  if result then ShowMessage('The new main base files are ready.')
  else ShowMessage('There was an error trying to copy base folder.');
end;

procedure TLibraryForm.EndGetLibrary;
begin
  if EndGet(cSBAlibraryZipFile,DefLibraryDir) then
  begin
    ShowMessage('The new IPCore library files are ready.');
  end;
  PB_SBAlibrary.Style:=pbstNormal;
end;

procedure TLibraryForm.EndGetPrograms;
begin
  if EndGet(cSBAprogramsZipFile,DefProgramsDir) then
  begin
    ShowMessage('The new programs files are ready.');
  end;
  PB_SBAprograms.Style:=pbstNormal;
end;

procedure TLibraryForm.EndGetSnippets;
begin
  if EndGet(cSBAsnippetsZipFile,DefSnippetsDir) then
  begin
    ShowMessage('The new Snippets library files are ready.');
  end;
  PB_SBAsnippets.Style:=pbstNormal;
end;

function TLibraryForm.EndGet(zfile,defdir:string):boolean;
var ZipMainFolder:String;
begin
  result:=false;
  SB.SimpleText:='Unziping file '+zfile;
{ TODO : Extraer la ruta principal del zip para ser usado al extraer librerías de diferentes fuentes o ramas (branchs) establecer un criterio: Siempre las librerías deben empaquetarse en el zip dentro de un directorio.}
  ZipMainFolder:=GetZipMainFolder(ConfigDir+zfile);
  if UnZip(ConfigDir+zFile,ConfigDir+'temp') then
  begin
    SB.SimpleText:='Unziping successful';
    if DirReplace(ConfigDir+'temp'+PathDelim+ZipMainFolder,ConfigDir+'temp'+PathDelim+DefDir) then
    begin
      UpdateLists;
      SB.SimpleText:='New items loaded from remote repository';
      if (Trim(Ed_SBARepoZipFile.Text)<>'') and (Ed_SBARepoZipFile.Items.IndexOf(Ed_SBARepoZipFile.Text)=-1) then
      begin
        if Ed_SBARepoZipFile.Items.Count=10 then
        Ed_SBARepoZipFile.Items.Delete(Ed_SBARepoZipFile.Items.Count-1);
        Ed_SBARepoZipFile.Items.Insert(0,Ed_SBARepoZipFile.Text);
      end;
      result:=true;
    end else SB.SimpleText:='There was an error updating folders';
  end else SB.SimpleText:='There was an error unziping';
end;

function TLibraryForm.GetVersion(f:string):string;
var ini:TIniFile;
begin
  if FileExistsUTF8(f) then
  try
    ini:=TIniFile.Create(f);
    result:=ini.ReadString('MAIN', 'Version', '0.0.1');
  finally
    if assigned(ini) then FreeAndNil(ini);
  end else result:='0.0.0';
end;

procedure TLibraryForm.AddItemToIPCoresFilter(FileIterator: TFileIterator);
var
  Data:TStringArray;
  v:integer;
begin
  SetLength(Data,3);
  Data[0]:=ExtractFileNameWithoutExt(FileIterator.FileInfo.Name);
  Data[1]:=FileIterator.FileName;
  v:=VCmpr(GetVersion(FileIterator.FileName),GetVersion(LibraryDir+Data[0]+PathDelim+Data[0]+'.ini'));
  if IpCoreList.IndexOf(Data[0])=-1 then
    Data[2]:='N'  // The item is new do not exists in local library
  else if v>0 then Data[2]:='U' // the item is a new version of the one in the local library
    else if v=0 then Data[2]:='=';  // the item is the same as local library
  IPCoresFilter.Items.Add(Data);
end;

procedure TLibraryForm.AddItemToProgramsFilter(FileIterator: TFileIterator);
var
  Data:TStringArray;
begin
  SetLength(Data,2);
  Data[0]:=ExtractFileNameWithoutExt(FileIterator.FileInfo.Name);
  Data[1]:=FileIterator.FileName;
  ProgramsFilter.Items.Add(Data);
end;

procedure TLibraryForm.AddItemToSnippetsFilter(FileIterator: TFileIterator);
var
  Data:TStringArray;
begin
  SetLength(Data,2);
  Data[0]:=ExtractFileNameWithoutExt(FileIterator.FileInfo.Name);
  Data[1]:=FileIterator.FileName;
  SnippetsFilter.Items.Add(Data);
end;

function TLibraryForm.LookupFilterItem(S:string; LV:TListViewDataList):integer;
Var
  i:Integer;
  Data:TStringArray;
begin
  result:=-1; i:=0;
  while (result=-1) and (i<LV.Count) do
  begin
    Data:=LV[i];
    if Data[0]=S then result:=i else inc(i);
  end;
end;

procedure TLibraryForm.UpdateLists;
var
  S:String;
  Data:TStringArray;
begin
  IpCoresFilter.Items.Clear;
  SearchForFiles(ConfigDir+'temp'+PathDelim+DefLibraryDir, '*.ini',@AddItemToIpCoresFilter);
  For S in IpCoreList do if LookupFilterItem(S,IPCoresFilter.Items)=-1 then
  begin
    SetLength(Data,3);
    Data[0]:=S;
    Data[1]:=LibraryDir+S+PathDelim+S+'.ini';
    Data[2]:='L'; //The item in library is local and do not exist into the repository
    IPCoresFilter.Items.Add(Data);
  end;
  IpCoresFilter.InvalidateFilter;
//
  ProgramsFilter.Items.Clear;
  SearchForFiles(ConfigDir+'temp'+PathDelim+DefProgramsDir, '*.prg',@AddItemToProgramsFilter);
  For S in ProgramsList do if LookupFilterItem(S,ProgramsFilter.Items)=-1 then
  begin
    SetLength(Data,2);
    Data[0]:=S;
    Data[1]:=ProgramsDir+S+'.vhd';
    ProgramsFilter.Items.Add(Data);
  end;
  ProgramsFilter.InvalidateFilter;
//
  SnippetsFilter.Items.Clear;
  SearchForFiles(ConfigDir+'temp'+PathDelim+DefSnippetsDir, '*.snp',@AddItemToSnippetsFilter);
  For S in SnippetsList do if LookupFilterItem(S,SnippetsFilter.Items)=-1 then
  begin
    SetLength(Data,2);
    Data[0]:=S;
    Data[1]:=SnippetsDir+S+'.vhd';
    SnippetsFilter.Items.Add(Data);
  end;
  SnippetsFilter.InvalidateFilter;
end;

end.

