unit LibraryFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ListViewFilterEdit, Forms,
  Controls, Graphics, Dialogs, ComCtrls, Buttons, ExtCtrls,
  ActnList, AsyncProcess, lclintf, StdCtrls, EditBtn,
  IniFiles, SBASnippetU, SBAProgramU;

type
  tProcessStatus=(Idle,GetBase, GetLibrary, GetPrograms, GetSnippets);

  { TLibraryForm }

  TLibraryForm = class(TForm)
    B_AddtoLibrary: TBitBtn;
    B_AddtoPrograms: TBitBtn;
    B_AddtoSnippets: TBitBtn;
    B_SBAlibraryGet: TSpeedButton;
    B_SBAprogramsGet: TSpeedButton;
    B_SBAsnippetsGet: TSpeedButton;
    B_SBAlibrarySurf: TSpeedButton;
    B_SBAprogramsSurf: TSpeedButton;
    B_SBAsnippetsSurf: TSpeedButton;
    Ed_SBAbase: TEditButton;
    Ed_SBAlibrary: TEditButton;
    Ed_SBAprograms: TEditButton;
    Ed_SBAsnippets: TEditButton;
    GB_SBAbase: TGroupBox;
    GB_SBAlibrary: TGroupBox;
    GB_SBAprograms: TGroupBox;
    GB_SBAsnippets: TGroupBox;
    IPCoreImage: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    L_TitleIPCore: TLabel;
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
    B_SBAbaseSurf: TSpeedButton;
    B_SBAbaseGet: TSpeedButton;
    SB: TStatusBar;
    URL_IpCore: TStaticText;
    UpdateRep: TTabSheet;
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
    function EndGetBase: boolean;
    procedure EndGetLibrary;
    procedure EndGetPrograms;
    procedure EndGetSnippets;
    procedure ProcessWGET(url, f: string; Status: TProcessStatus);
    { private declarations }
  public
    { public declarations }
    SBASnippet:TSBASnippet;
    SBAProgram:TSBAProgram;
    procedure UpdateLists;
  end;

var
  LibraryForm: TLibraryForm;
  ProcessStatus:TProcessStatus=Idle;

const
  cSBAbaseZipFile='sbamaster.zip';
  cSBAlibraryZipFile='sbalibrary.zip';
  cSBAprogramsZipFile='sbaprograms.zip';
  cSBAsnippetsZipFile='sbasnippets.zip';


function ShowLibraryForm:TModalResult;

implementation

{$R *.lfm}

uses ConfigFormU, UtilsU, DebugFormU;

function ShowLibraryForm: TModalResult;
begin
  LibraryForm.UpdateLists;
  result:=LibraryForm.ShowModal;
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
  if SnippetsList.IndexOf(Item.Caption)<>-1 then Icolor:=clGreen else Icolor:=clBlack;
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
  ProcessWGET(Ed_SBAlibrary.Text+'/archive/master.zip',ConfigDir+cSBAlibraryZipFile,GetLibrary);
end;

procedure TLibraryForm.B_SBAlibrarySurfClick(Sender: TObject);
begin
  OpenURL(Ed_SBAlibrary.Text);
end;

procedure TLibraryForm.B_SBAprogramsGetClick(Sender: TObject);
begin
  PB_SBAprograms.Style:=pbstMarquee;
  SB.SimpleText:='Downloading file '+cSBAprogramsZipFile;
  ProcessWGET(Ed_SBAprograms.Text+'/archive/master.zip',ConfigDir+cSBAprogramsZipFile,Getprograms);
end;

procedure TLibraryForm.B_SBAprogramsSurfClick(Sender: TObject);
begin
  OpenURL(Ed_SBAprograms.Text);
end;

procedure TLibraryForm.B_SBAsnippetsGetClick(Sender: TObject);
begin
  PB_SBAsnippets.Style:=pbstMarquee;
  SB.SimpleText:='Downloading file '+cSBAsnippetsZipFile;
  ProcessWGET(Ed_SBAsnippets.Text+'/archive/master.zip',ConfigDir+cSBAsnippetsZipFile,Getsnippets);
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
  SBASnippet:=TSBASnippet.Create;
  SBAProgram:=TSBAProgram.Create;
end;

procedure TLibraryForm.FormDestroy(Sender: TObject);
begin
  if assigned(SBASnippet) then FreeAndNil(SBASnippet);
  if assigned(SBAProgram) then FreeAndNil(SBAProgram);
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
  B_AddtoLibrary.Enabled:=IpCoreList.IndexOf(L.Caption)=-1;
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
  if IpCoreList.IndexOf(Item.Caption)<>-1 then Icolor:=clGreen else Icolor:=clBlack;
  Sender.Canvas.Font.Color:=Icolor;
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
var s:TMemoryStream;
    t:TStringList;
    b:DWord;
    l:string;
begin
   s:=TMemoryStream.Create;
   t:=TStringList.Create;
   b:=Process1.NumBytesAvailable;
   if b>0 then
   begin
     s.SetSize(b);
     Process1.Output.Read(s.memory^, b);
     t.LoadFromStream(s)
   end;
   For l in t do infoln(l);
   s.free;
   t.free;
end;

procedure TLibraryForm.Process1Terminate(Sender: TObject);
begin
  Process1ReadData(Sender);
  case ProcessStatus of
    GetBase: EndGetBase;
    GetLibrary: EndGetLibrary;
    GetPrograms: EndGetPrograms;
    GetSnippets: EndGetSnippets;
  end;
  ProcessStatus:=Idle;

infoln('');
infoln('');
infoln('-----------------------------');
infoln('');
infoln('');

end;

procedure TLibraryForm.LV_ProgramsCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var Icolor:TColor;
begin
  if ProgramsList.IndexOf(Item.Caption)<>-1 then Icolor:=clGreen else Icolor:=clBlack;
  Sender.Canvas.Font.Color:=Icolor;
end;

procedure TLibraryForm.B_SBAbaseGetClick(Sender: TObject);
begin
  PB_SBABase.Style:=pbstMarquee;
  SB.SimpleText:='Downloading file '+cSBABaseZipFile;
  ProcessWGET(Ed_SBAbase.Text+'/archive/master.zip',ConfigDir+cSBABaseZipFile,GetBase);
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
    if DirectoryExistsUTF8(d) or not CopyDirTree(f,d,[cffCreateDestDirectory,cffPreserveTime]) then
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
    SB.SimpleText:='';
    DirDelete(SBAbaseDir);
    Sleep(300);
    result:=(not DirectoryExistsUTF8(SBAbaseDir)) and
            RenameFile(ConfigDir+'temp'+PathDelim+'SBA-master'+PathDelim,SBAbaseDir);
  end;
  if result then ShowMessage('The new main base files are ready.')
  else ShowMessage('There was an error trying to copy base folder.');
  PB_SBABase.Style:=pbstNormal;
end;

procedure TLibraryForm.EndGetLibrary;
begin
  SB.SimpleText:='Unziping file '+cSBAlibraryZipFile;
  if UnZip(ConfigDir+cSBAlibraryZipFile,ConfigDir+'temp') then
  begin
    SB.SimpleText:='';
    ShowMessage('The new IPCore library files are ready.');
  end;
  PB_SBAlibrary.Style:=pbstNormal;
end;

procedure TLibraryForm.EndGetPrograms;
begin
  SB.SimpleText:='Unziping file '+cSBAprogramsZipFile;
  if UnZip(ConfigDir+cSBAprogramsZipFile,ConfigDir+'temp') then
  begin
    SB.SimpleText:='';
    ShowMessage('The new programs files are ready.');
  end;
  PB_SBAprograms.Style:=pbstNormal;
end;

procedure TLibraryForm.EndGetSnippets;
begin
  SB.SimpleText:='Unziping file '+cSBAsnippetsZipFile;
  if UnZip(ConfigDir+cSBAsnippetsZipFile,ConfigDir+'temp') then
  begin
    SB.SimpleText:='';
    ShowMessage('The new Snippets library files are ready.');
  end;
  PB_SBAsnippets.Style:=pbstNormal;
end;

procedure TLibraryForm.ProcessWGET(url,f:string;Status:TProcessStatus);
begin
  While ProcessStatus<>idle do
  begin
    sleep(300);
    application.ProcessMessages;
  end;

infoln('');
infoln('');
infoln(url);
infoln(f);
infoln('-----------------------------');
infoln('');
infoln('');

  process1.Parameters.Clear;
  process1.Executable:=Application.Location+'tools'+PathDelim+'wget.exe';
  process1.CurrentDirectory:=ConfigDir;
  {$IFNDEF DEBUG}
  process1.Parameters.Add('-q');
  {$ENDIF}
  process1.Parameters.Add('-O');
  process1.Parameters.Add('"'+f+'"');
  process1.Parameters.Add('--no-check-certificate');
  process1.Parameters.Add(url);
  ProcessStatus:=Status;
  process1.Execute;
end;

procedure TLibraryForm.AddItemToIPCoresFilter(FileIterator: TFileIterator);
var
  Data:TStringArray;
begin
  SetLength(Data,2);
  Data[0]:=ExtractFileNameWithoutExt(FileIterator.FileInfo.Name);
  Data[1]:=FileIterator.FileName;
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

procedure TLibraryForm.UpdateLists;
begin
  IpCoresFilter.Items.Clear;
  SearchForFiles(ConfigDir+'temp'+PathDelim+'SBA-Library-master', '*.ini',@AddItemToIpCoresFilter);
  IpCoresFilter.InvalidateFilter;
//
  ProgramsFilter.Items.Clear;
  SearchForFiles(ConfigDir+'temp'+PathDelim+'SBA-Programs-master', '*.prg',@AddItemToProgramsFilter);
  ProgramsFilter.InvalidateFilter;
//
  SnippetsFilter.Items.Clear;
  SearchForFiles(ConfigDir+'temp'+PathDelim+'SBA-Snippets-master', '*.snp',@AddItemToSnippetsFilter);
  SnippetsFilter.InvalidateFilter;
end;

end.

