unit MainFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ComCtrls, AsyncProcess, ExtCtrls, Menus, ActnList,
  SynHighlighterSBA, SynHighlighterVerilog, SynHighlighterJSON, SynEditMarkupHighAll,
  SynEdit, SynEditTypes,SynEditKeyCmds, SynPluginSyncroEdit, SynHighlighterIni,
  FileUtil, LazUTF8, LazFileUtils,
  dateutils, ListViewFilterEdit, strutils, Clipbrd, IniPropStorage, StdActns,
  BGRASpriteAnimation, uebutton, uETilePanel, versionsupportu,
  types, lclintf, LCLType, HistoryFiles, IniFilesUTF8, StringListUTF8;

type
  thdltype=(vhdl, prg, verilog, systemverilog, ini, json, other);
  tProcessStatus=(Idle,SyntaxChk,Obfusct,exePlugIn);

  { TMainForm }

  TMainForm = class(TForm)
    EditInsertTemplate: TAction;
    EditBlkUncomment: TAction;
    EditBlkComment: TAction;
    EditBlkUnindent: TAction;
    EditBlkIndent: TAction;
    B_SBAAdress: TBitBtn;
    IdleTimer1: TIdleTimer;
    header_text: TImage;
    L_SBAAddress: TListBox;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem62: TMenuItem;
    MenuItem63: TMenuItem;
    MenuItem64: TMenuItem;
    MenuItem65: TMenuItem;
    MenuItem66: TMenuItem;
    MenuItem67: TMenuItem;
    MenuItem68: TMenuItem;
    MenuItem69: TMenuItem;
    MI_RemUserFile: TMenuItem;
    MI_AddUserFile: TMenuItem;
    MI_RemCore: TMenuItem;
    EditorPopUp: TPopupMenu;
    EdTemplates: TPopupMenu;
    ProjectRemUserFile: TAction;
    ProjectAddUserFiles: TAction;
    ProjectRemCore: TAction;
    BitBtn5: TBitBtn;
    Button1: TButton;
    Panel1: TPanel;
    PrjTreeMenu: TPopupMenu;
    ProjectCoresAddInst: TAction;
    MenuItem29: TMenuItem;
    MenuItem55: TMenuItem;
    MI_AddInstance: TMenuItem;
    ProjectEditCoreList: TAction;
    EditInsertDate: TAction;
    btn_new_project: TuEButton;
    btn_open_project: TuEButton;
    btn_prj_editor: TuEButton;
    btn_prj_prgeditor: TuEButton;
    btn_sba_forum: TuEButton;
    btn_sba_website: TuEButton;
    btn_sba_library: TuEButton;
    EditorHistory: THistoryFiles;
    CoreImage: TImage;
    MenuItem26: TMenuItem;
    FileHistoryEd: TMenuItem;
    MI_AddCore: TMenuItem;
    MenuItem929: TMenuItem;
    MenuItem956: TMenuItem;
    MenuItem957: TMenuItem;
    MenuItem958: TMenuItem;
    MenuItem962: TMenuItem;
    MenuItem963: TMenuItem;
    M_EdPrjCores: TPopupMenu;
    ProjectMenuEd: TMenuItem;
    PrjHistory: THistoryFiles;
    MarkImages: TImageList;
    MainPanel: TuETilePanel;
    MenuItem14: TMenuItem;
    ProjectsHistory: TMenuItem;
    P_ProgAddress: TGroupBox;
    SBA_InsertTemplate: TAction;
    MenuItem13: TMenuItem;
    PrgTemplates: TPopupMenu;
    SBA_NewPrg: TAction;
    ProjectExport: TAction;
    GroupBox1: TGroupBox;
    ProjectClose: TAction;
    ProjectSave: TAction;
    MenuItem12: TMenuItem;
    ProjectGotoPrg: TAction;
    B_InsertSnipped: TBitBtn;
    B_Obf: TBitBtn;
    B_SBALabels: TBitBtn;
    EditorPages: TPageControl;
    Label3: TLabel;
    Label5: TLabel;
    Log: TListBox;
    L_RsvWord: TListBox;
    L_SBALabels: TListBox;
    SnippetDescription: TMemo;
    EdTabMenu: TPopupMenu;
    MenuItem10: TMenuItem;
    MenuItem4: TMenuItem;
    P_Project: TPanel;
    P_Editors: TPanel;
    P_AuxEditor: TPanel;
    P_CodeSnippets: TGroupBox;
    MenuItem36: TMenuItem;
    ProjectGotoEditor: TAction;
    ProjectNew: TAction;
    ProjectOpen: TAction;
    AnnouncementPanel: TPanel;
    AnnouncementImage: TBGRASpriteAnimation;
    MainMenu: TMainMenu;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem60: TMenuItem;
    MenuItem61: TMenuItem;
    MenuItem79: TMenuItem;
    ProgMenu: TMainMenu;
    MenuItem32: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem59: TMenuItem;
    SnippetsFilter: TListViewFilterEdit;
    LV_Snippets: TListView;
    Splitter3: TSplitter;
    Splitter4: TSplitter;
    Splitter5: TSplitter;
    Splitter6: TSplitter;
    SynEdit1: TSynEdit;
    SynIniSyn: TSynIniSyn;
    HidenPage: TTabSheet;
    ToolButton48: TToolButton;
    ToolButton49: TToolButton;
    ToolButton50: TToolButton;
    TreeImg: TImageList;
    EditRedo: TAction;
    EditCopy: TEditCopy;
    EditCut: TEditCut;
    EditPaste: TEditPaste;
    EditSelectAll: TEditSelectAll;
    EditUndo: TEditUndo;
    header_bg: TImage;
    LogoImage: TImage;
    MenuItem18: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    SearchMenu: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    AboutMenuItem: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    P_Obf: TPanel;
    P_ProgLabels: TGroupBox;
    SBA_SaveAs: TAction;
    SBA_Open: TAction;
    SBA_Save: TAction;
    SBA_cancel: TAction;
    SBA_ReturnToEditor: TAction;
    FileSaveAs: TAction;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    P_AuxProg: TPanel;
    SBA_EditProgram: TAction;
    Splitter_ProgAddress: TSplitter;
    ToolBar4: TToolBar;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton27: TToolButton;
    ToolButton33: TToolButton;
    ToolButton43: TToolButton;
    ToolButton46: TToolButton;
    ToolButton47: TToolButton;
    ToolButton8: TToolButton;
    ToolsFileSyntaxCheck: TAction;
    ToolsFileReformat: TAction;
    ToolsFileObf: TAction;
    FileRevert: TAction;
    FileClose: TAction;
    FileSave: TAction;
    HelpAbout: THelpAction;
    ToolsMenu: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    FileNew: TAction;
    FileOpen: TAction;
    FileExit: TFileExit;
    IniStor: TIniPropStorage;
    EditorMenu: TMainMenu;
    MenuItem11: TMenuItem;
    EditMenu: TMenuItem;
    MenuItem3: TMenuItem;
    FileMenu: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MainPages: TPageControl;
    RW_AddfromCB: TAction;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    OpenDialog: TOpenDialog;
    RW_OpenList: TAction;
    RW_Savelist: TAction;
    RW_Remove: TAction;
    RW_AddWord: TAction;
    ActionList: TActionList;
    ImageList: TImageList;
    MI_Addnew: TMenuItem;
    MI_Remove: TMenuItem;
    ObfRsvMenu: TPopupMenu;
    ToolProcess: TAsyncProcess;
    SaveDialog: TSaveDialog;
    SearchFind: TSearchFind;
    SearchFindNext: TSearchFindNext;
    SearchReplace: TSearchReplace;
    Shape1: TShape;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    SyncroEdit: TSynPluginSyncroEdit;
    SynEdit_X: TSynEdit;
    SynSBASyn:TSynSBASyn;
    SynVerilogSyn:TSynVerilogSyn;
    SynJSONSyn:TSynJSONSyn;
    SystemTab: TTabSheet;
    EditorsTab: TTabSheet;
    ProgEditTab: TTabSheet;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton2: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton3: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    ToolButton34: TToolButton;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton37: TToolButton;
    ToolButton38: TToolButton;
    ToolButton39: TToolButton;
    ToolButton4: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton42: TToolButton;
    ToolButton44: TToolButton;
    ToolButton45: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton9: TToolButton;
    btn_config: TuEButton;
    PrjTree: TTreeView;
    procedure btn_plgClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure B_SBAAdressClick(Sender: TObject);
    procedure btn_sba_forumClick(Sender: TObject);
    procedure btn_configClick(Sender: TObject);
    procedure btn_sba_libraryClick(Sender: TObject);
    procedure B_InsertSnippedClick(Sender: TObject);
    procedure B_SBALabelsClick(Sender: TObject);
    procedure btn_sba_websiteClick(Sender: TObject);
    procedure EditBlkCommentExecute(Sender: TObject);
    procedure EditBlkIndentExecute(Sender: TObject);
    procedure EditBlkUncommentExecute(Sender: TObject);
    procedure EditBlkUnindentExecute(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure EditCutExecute(Sender: TObject);
    procedure EditInsertDateExecute(Sender: TObject);
    procedure EditInsertTemplateExecute(Sender: TObject);
    procedure EditorHistoryClickHistoryItem(Sender: TObject; Item: TMenuItem;
      const Filename: string);
    procedure EditorsTabContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure EditPasteExecute(Sender: TObject);
    procedure EditRedoExecute(Sender: TObject);
    procedure EditSelectAllExecute(Sender: TObject);
    procedure EditUndoExecute(Sender: TObject);
    procedure FileSaveAsExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure LogoImageDblClick(Sender: TObject);
    procedure L_SBALabelsDblClick(Sender: TObject);
    procedure MainPanelResize(Sender: TObject);
    procedure PrjHistoryClickHistoryItem(Sender: TObject; Item: TMenuItem;
      const Filename: string);
    procedure PrjTreeClick(Sender: TObject);
    procedure PrjTreeContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure PrjTreeDblClick(Sender: TObject);
    procedure PrjTreeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PrjTreeMouseLeave(Sender: TObject);
    procedure PrjTreeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ProjectAddUserFilesExecute(Sender: TObject);
    procedure ProjectCoresAddInstExecute(Sender: TObject);
    procedure ProjectCloseExecute(Sender: TObject);
    procedure ProjectEditCoreListExecute(Sender: TObject);
    procedure ProjectExportExecute(Sender: TObject);
    procedure ProjectGotoEditorExecute(Sender: TObject);
    procedure ProjectGotoPrgExecute(Sender: TObject);
    procedure ProjectNewExecute(Sender: TObject);
    procedure ProjectOpenExecute(Sender: TObject);
    procedure MainPagesChange(Sender: TObject);
    procedure ProjectRemUserFileExecute(Sender: TObject);
    procedure ProjectSaveExecute(Sender: TObject);
    procedure SBA_cancelExecute(Sender: TObject);
    procedure SBA_EditProgramExecute(Sender: TObject);
    procedure B_ObfClick(Sender: TObject);
    procedure EditorPagesChange(Sender: TObject);
    procedure FileCloseExecute(Sender: TObject);
    procedure SBA_InsertTemplateExecute(Sender: TObject);
    procedure SBA_NewPrgExecute(Sender: TObject);
    procedure LV_SnippetsClick(Sender: TObject);
    procedure TFindDialogFind(Sender: TObject);
    procedure ToolsFileObfExecute(Sender: TObject);
    procedure ToolsFileReformatExecute(Sender: TObject);
    procedure FileRevertExecute(Sender: TObject);
    procedure FileSaveExecute(Sender: TObject);
    procedure ToolsFileSyntaxCheckExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure HelpAboutExecute(Sender: TObject);
    procedure LogDblClick(Sender: TObject);
    procedure LogMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SBA_OpenExecute(Sender: TObject);
    procedure SBA_ReturnToEditorExecute(Sender: TObject);
    procedure SBA_SaveAsExecute(Sender: TObject);
    procedure SBA_SaveExecute(Sender: TObject);
    procedure TReplaceDialogReplace(Sender: TObject);
    procedure WordMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure WordSelectionChange(Sender: TObject);
    procedure FileNewExecute(Sender: TObject);
    procedure FileOpenExecute(Sender: TObject);
    procedure ToolProcessReadData(Sender: TObject);
    procedure ToolProcessTerminate(Sender: TObject);
    procedure RW_AddfromCBExecute(Sender: TObject);
    procedure RW_AddWordExecute(Sender: TObject);
    procedure RW_OpenListExecute(Sender: TObject);
    procedure RW_RemoveExecute(Sender: TObject);
    procedure RW_SavelistExecute(Sender: TObject);
    procedure SynEditStatusChange(Sender: TObject; Changes: TSynStatusChanges);
  private
    procedure AddIPCoresToTree(t: TTreeNode; cl: TStrings);
    { private declarations }
    procedure ChangeEditorButtons(editor: TSynEdit);
    procedure Check;
    function CloseProg: boolean;
    function CloseEditor(T: TTabSheet): boolean;
    function CloseProject: boolean;
    procedure CreateEditor(var ActiveTab: TTabSheet);
    procedure CreatePlugInsBtns;
    function CreateTempFile(fn:string): boolean;
    procedure DetectSBAController;
    procedure dwTerminate(Sender: TObject);
    function EditorEmpty(Editor: TSynEdit): boolean;
    procedure ExtractSBACnfgCnst;
    function GetFile(filename:string): boolean;
    procedure GotoEditor;
    procedure hdltypeselect(const ts: string);
    procedure HighLightReservedWords(List:TStrings);
    function LoadTheme(thmdir: string): boolean;
    procedure NewEditorPage;
    procedure Ofuscate(f: string; hdl: thdltype);
    function Open(f: String): boolean;
    procedure OpenInEditor(const f: string);
    procedure OpenProject(const f:string);
    procedure Reformat(osl,nsl: Tstrings);
    function  SaveFile(f:String; Src:TStrings):Boolean;
    procedure SetupEditorPopupMenu;
    procedure SetupEdTmplMenu;
    procedure SetupPrgTmplMenu;
    procedure SetupSynMarkup;
    procedure SyntaxCheck(f,path: string; hdl: Thdltype);
    procedure ExtractSBALabels;
    procedure LoadRsvWordsFile;
    procedure LoadAnnouncement;
  protected
  public
    { public declarations }
    procedure UpdatePrjTree;
    procedure AutoUpdate;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses DebugFormU, SBAProgContrlrU, SBAProjectU, ConfigFormU, AboutFormU, sbasnippetu, PrjWizU,
     DwFileU, FloatFormU, LibraryFormU, ExportPrjFormU, UtilsU, AutoUpdateU;

var
  SynMarkup: TSynEditMarkupHighlightAllCaret;
  SBAContrlrProg:TSBAContrlrProg;
  SBASnippet:TSBASnippet;
  fOldIndex: integer = -1;
  wdir:string;
  hdltype:thdltype;
  commentstr:string='--';
  hdlext:string='.vhd';
  mapfile:string='vhdl_map.dat';
  ActiveEditor:TSynEdit;
  EditorCnt:integer=1;
  PrgReturnTab:TTabSheet=nil;
  ProcessStatus:TProcessStatus=Idle;
  UpdtFlag:boolean=false;

{ TMainForm }

function TMainForm.CloseEditor(T:TTabSheet):boolean;
var
  r:integer;
  f:string;
begin
  result:=true;
  if T=nil then exit;
  EditorPages.ActivePage:=T;
  EditorPagesChange(nil);
  if ActiveEditor.Modified then
  begin
    f:=T.Hint;
    r:=MessageDlg('File was modified', 'Save File? '+f, mtConfirmation, [mbYes, mbNo, mbCancel],0);
    case r of
      mrCancel: result:=false;
      mrYes: result:=SaveFile(f, ActiveEditor.Lines);
      mrNo: result:=true;
    end;
  end;
  if result then
  begin
    FreeAndNil(ActiveEditor);
    FreeAndNil(T);
  end;
end;

function TMainForm.LoadTheme(thmdir:string):boolean;
var
  i:integer;
  b:TuEButton;
begin
  result:=false;
  try
    header_bg.Picture.LoadFromFile(thmdir+'header_bg.jpg');
    MainPanel.LoadFromFile(thmdir+'background.jpg');
  except
    ShowMessage('There was an error loading theme in: '+thmdir);
    exit;
  end;
  for i:=0 to MainPanel.ControlCount-1 do if MainPanel.Controls[i].ClassNameIs('TuEButton') then
  begin
    b:=TuEButton(MainPanel.Controls[i]);
    b.LoadImageFromFile(thmdir+'btn_bg.png');
    if FileExistsUtf8(thmdir+b.Name+'.png') then b.LoadGlyphFromFile(thmdir+b.Name+'.png');
  end;
  result:=true;
end;

procedure TMainForm.CreatePlugInsBtns;
var
  PlugBtn:TuEButton;
  PlgDir:String;
  PlgIni:TIniFile;
  i:Integer;

  procedure createbtn(n:integer);
  var s:string;
  begin
    s:=inttostr(n);
    PlugBtn:=TuEButton.Create(MainForm);
    PlugBtn.Parent:=MainPanel;
    PlugBtn.Name:='btn_plg_'+s;
    PlugBtn.Constraints.MinHeight:=btn_new_project.Constraints.MinHeight;
    PlugBtn.Constraints.MinWidth:=btn_new_project.Constraints.MinWidth;
    PlugBtn.TextShadowColor:=btn_new_project.TextShadowColor;
    PlugBtn.Layout:=blGlyphTop;
    PLugBtn.ParentColor:=false;
    PLugBtn.Color:=btn_new_project.Color;
    PlugBtn.Caption:=PlgIni.ReadString('MAIN','Name','PlugIn #'+s);
    if FileExistsUtf8(PlgDir+PlgIni.ReadString('MAIN','Glyph','')) then PlugBtn.LoadGlyphFromFile(PlgDir+PlgIni.ReadString('MAIN','Glyph',''));
    PlugBtn.Tag:=n;
    PlugBtn.OnClick:=@btn_plgClick;
  end;

begin
  if PlugInsList.Count=0 then exit;
  for i:=0 to PlugInsList.Count-1 do
  begin
    try
      PlgIni:=TIniFile.Create(PlugInsList.ValueFromIndex[i]);
      PlgDir:=ExtractFilePath(PlugInsList.ValueFromIndex[i]);
      createbtn(i);
    finally
      If assigned(PlgIni) then FreeAndNil(PlgIni);
    end;
  end;
end;

procedure TMainForm.CreateEditor(var ActiveTab: TTabSheet);
var
  OldName: String;
  E: TSynEdit;
  memStrm: TMemoryStream;
begin
  memStrm:=TMemoryStream.Create;
  memStrm.WriteComponent(SynEdit_X);
  ActiveEditor:=SynEdit_X;
  OldName:=ActiveEditor.Name;
  SynEdit_X.Name:='SynEdit_tmpl';
  E:= TSynEdit.Create(self);
  memStrm.Position:=0;
  memStrm.ReadComponent(E);
  memStrm.Free;
  E.Name:='SynEdit_'+inttostr(ActiveTab.Tag);
  ActiveEditor.Name:=OldName;
  E.ClearAll;
  E.Parent:=ActiveTab;
  E.OnStatusChange:=@SynEditStatusChange;
  SynMarkup:=TSynEditMarkupHighlightAllCaret(E.MarkupByClass[
    TSynEditMarkupHighlightAllCaret]);
  SynMarkup.MarkupInfo.Background := clBtnFace;
  SynMarkup.WaitTime := 500; // tiempo en millisegundos
  SynMarkup.Trim := True;
  SynMarkup.FullWord:= True;
  ActiveEditor:=E;
  SyncroEdit.Editor:=ActiveEditor;
  ActiveEditor.Modified:=false;
end;

function TMainForm.CreateTempFile(fn: string): boolean;
var
  f: TStringList;
begin
  result:=true;
  f:=TStringList.Create;
  f.Assign(ActiveEditor.Lines);
  try
    f.SaveToFile(fn);
  finally
    FreeAndNil(f);
    if not fileexistsUTF8(fn) then
    begin
      ShowMessage('Temporal file: '+wdir+'source_file'+hdlext+' not could be '
        +'created.');
      result:=false;
    end;
  end;
end;

procedure TMainForm.EditorPagesChange(Sender: TObject);
var ActiveTab:TTabSheet;
begin
  ActiveTab:=EditorPages.ActivePage;
  StatusBar1.Panels[1].Text:=ActiveTab.Hint;
  ActiveEditor:=TSynEdit(MainForm.FindComponent('SynEdit_'+inttostr(ActiveTab.Tag)));
  If assigned(ActiveEditor) then
  begin
    SyncroEdit.Editor:=ActiveEditor;
    wdir:=extractfilepath(ActiveTab.hint);
    if wdir='' then wdir:='.\';
    hdltypeselect(extractfileext(ActiveTab.hint));
    DetectSBAController;
    if ToolsFileObf.Checked then ToolsFileObfExecute(Sender);
    ChangeEditorButtons(ActiveEditor);
  end;
end;

procedure TMainForm.B_ObfClick(Sender: TObject);
var
  i:integer;
  s:string;
  sl,om:TStringList;
  f:boolean;
begin
  s:=EditorPages.ActivePage.Hint;
  if ActiveEditor.Modified then
  case MessageDlg('File must be saved', 'Save File? '+s, mtConfirmation, [mbYes, mbNo],0) of
    mrYes: if not SaveFile(s,ActiveEditor.Lines) then exit;
  else exit;
  end;
  ActiveEditor.Modified:=false;
  ChangeEditorButtons(ActiveEditor);
  ToolsFileObf.Enabled:=false;
  if not fileexistsUTF8(wdir+mapfile) then copyfile(AppDir+mapfile,wdir+mapfile);
  sl:=TStringList.Create;
  om:=TStringList.Create;
  om.LoadFromFile(wdir+mapfile);
  f:=true;
  for i:=0 to om.Count-1 do
  begin
    if pos('//LR_Start',om[i])<>0 then f:=false;
    if f then sl.Add(om[i]);
    if pos('//LR_End',om[i])<>0 then f:=true;
  end;
  sl.Add('');
  sl.Add('//LR_Start');
  for i:=0 to L_RsvWord.Count-1 do
  begin
    s:=lowercase(L_RsvWord.Items[i]);
    if s<>'' then sl.Add(s+'='+s);
  end;
  sl.Add('//LR_End');
  sl.SaveToFile(wdir+mapfile);
  freeandnil(sl);
  freeandnil(om);
  Ofuscate(EditorPages.ActivePage.Hint,hdltype);
  ToolsFileObf.Enabled:=true;
end;

procedure TMainForm.SBA_EditProgramExecute(Sender: TObject);
begin
  SynEdit_X.BeginUpdate(false);
  SynEdit_X.ClearAll;
  if SBAContrlrProg.CpySrc2Prog(ActiveEditor.Lines,SynEdit_X.Lines) then
  begin
    PrgReturnTab:=EditorsTab;
    SBA_ReturnToEditor.Enabled:=true;
    MainPages.ActivePage:=ProgEditTab;
    ExtractSBALabels;
    ExtractSBACnfgCnst;
  end else ShowMessage('Format error in controller, please verify "/SBA:" block signatures.');
  SynEdit_X.EndUpdate;
  SynEdit_X.Modified:=false;
end;

procedure TMainForm.B_SBALabelsClick(Sender: TObject);
begin
  ExtractSBALabels;
end;

procedure TMainForm.btn_sba_websiteClick(Sender: TObject);
begin
  OpenUrl('http://sba.accesus.com');
end;

procedure TMainForm.EditBlkCommentExecute(Sender: TObject);
Var
  C:TPoint;
  L:integer;
begin
  if ActiveEditor<>nil then With ActiveEditor do
  begin
    ActiveEditor.BeginUpdate(true);
    C:=CaretXY;
    if SelAvail then
    begin
      for L:=BlockBegin.y to BlockEnd.y do
      begin
        CaretY:=L;
        CaretX:=0;
        InsertTextAtCaret(commentstr);
      end;
      CaretY:=C.Y;
    end else
    begin
      CaretX:=0;
      InsertTextAtCaret(commentstr);
    end;
    CaretX:=C.X+length(commentstr);
    ActiveEditor.EndUpdate;
  end;
end;

procedure TMainForm.EditBlkIndentExecute(Sender: TObject);
begin
  if ActiveEditor<>nil then ActiveEditor.ExecuteCommand(ecBlockIndent,'',nil);
end;

procedure TMainForm.EditBlkUncommentExecute(Sender: TObject);
Var
  C:TPoint;
  L:Integer;
begin
  if (ActiveEditor<>nil) then With ActiveEditor do
  begin
    ActiveEditor.BeginUpdate(true);
    C:=CaretXY;
    if SelAvail then
    begin
      for L:=BlockBegin.y to BlockEnd.y do
      begin
       CaretY:=L;
       if (Pos(commentstr,ActiveEditor.LineText)=1) then
       begin
         CaretX:=length(commentstr)+1;
         ExecuteCommand(ecDeleteBOL,'',nil);
       end;
      end;
      CaretY:=C.Y;
    end else if (Pos(commentstr,ActiveEditor.LineText)=1) then
    begin
      CaretX:=length(commentstr)+1;
      ExecuteCommand(ecDeleteBOL,'',nil);
    end;
    CaretX:=C.X-length(commentstr);
    ActiveEditor.EndUpdate;
  end;
end;

//procedure TMainForm.EditBlkIndentUpdate(Sender: TObject);
//begin
//  TAction(Sender).Enabled :=ActiveEditor.SelAvail and not ActiveEditor.ReadOnly;
//end;

procedure TMainForm.EditBlkUnindentExecute(Sender: TObject);
begin
  if ActiveEditor<>nil then ActiveEditor.ExecuteCommand(ecBlockUnindent,'',nil);
end;

procedure TMainForm.B_InsertSnippedClick(Sender: TObject);
var
  sblk,eblk,y:integer;
  success:boolean;

  function InsertSnp(BStart,BEnd,t:String):boolean;
  begin
    result:=false;
    sblk:=GetPosList(BStart,ActiveEditor.Lines)+1;
    eblk:=GetPosList(BEnd,ActiveEditor.Lines,sblk);
    if (sblk<>-1) and (eblk<>-1) then
    begin
      if (ActiveEditor.CaretY<sblk+1) or (ActiveEditor.CaretY>eblk+1) then
      begin
        while ActiveEditor.Lines[eblk-1]='' do dec(eblk);
        ActiveEditor.CaretY:=eblk+1;
        ActiveEditor.InsertTextAtCaret(LineEnding);
      end;
      ActiveEditor.InsertTextAtCaret(t);
      result:=true;
    end else ShowMessage('Error in User block definitions, check "-- /SBA:" keywords');
    success:=success and result;
  end;

begin
  ActiveEditor.BeginUpdate(true);
  ActiveEditor.BeginUndoBlock;
  ActiveEditor.CaretX:=0;
  success:=true;
  Y:=ActiveEditor.CaretY;
  try
    InsertSnp(cSBAStartUserProg,cSBAEndUserProg,SBASnippet.code.Text);
    ActiveEditor.CaretY:=Y;
    InsertSnp(cSBAStartProgUReg,cSBAEndProgUReg,SBASnippet.registers.Text);
    ActiveEditor.CaretY:=Y;
    InsertSnp(cSBAStartUSignals,cSBAEndUSignals,SBASnippet.USignals.Text);
    ActiveEditor.CaretY:=Y;
    InsertSnp(cSBAStartUProc,cSBAEndUProc,SBASnippet.UProc.Text);
    ActiveEditor.CaretY:=Y;
    InsertSnp(cSBAStartUStatements,cSBAEndUStatements,SBASnippet.UStatements.Text);
    ActiveEditor.EndUndoBlock;
  finally
    If success then ExtractSBALabels else ActiveEditor.Undo;
    ActiveEditor.EndUpdate;
  end;
end;

procedure TMainForm.btn_sba_libraryClick(Sender: TObject);
begin
  ShowLibraryForm;
  SBASnippet.UpdateSnippetsFilter(SnippetsFilter);
end;

procedure TMainForm.btn_configClick(Sender: TObject);
begin
  if ConfigForm.ShowModal=mrOk then SetConfigValues;
end;

procedure TMainForm.btn_sba_forumClick(Sender: TObject);
begin
  OpenURL('http://sbaforum.accesus.com/');
end;

procedure TMainForm.btn_plgClick(Sender: TObject);
var
  PlgIni:TIniFile;
  b:TuEButton;
begin
  if Sender.ClassName<>'TuEButton' then exit;
  b:=TuEButton(Sender);
  try
    PlgIni:=TIniFile.Create(PlugInsList.ValueFromIndex[b.Tag]);
    while ProcessStatus<>Idle do begin sleep(300); application.ProcessMessages; end;
    ProcessStatus:=exePlugIn;
    ToolProcess.Parameters.Clear;
    ToolProcess.Executable:=ExtractFilePath(PlugInsList.ValueFromIndex[b.Tag])+PlgIni.ReadString('MAIN','Cmd','');
    ToolProcess.Parameters.Add(PlgIni.ReadString('MAIN','Param',''));
    If FileExistsUTF8(ToolProcess.Executable) then ToolProcess.Execute;
  finally
    If assigned(PlgIni) then FreeAndNil(PlgIni);
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  MainPages.ActivePage:=SystemTab;
end;

procedure TMainForm.B_SBAAdressClick(Sender: TObject);
begin
  if SBAPrj.name<>'' then ExtractSBACnfgCnst else ShowMessage('There is no an open project');
end;

procedure TMainForm.ExtractSBACnfgCnst;
var
  sl:TStringList;
  f:string;
  i:integer;
begin
  if SBAPrj.name<>'' then
  try
    sl:=TStringList.Create;
    f:=SBAPrj.location+SBAPrj.name+'_'+cSBAcfg;
    if (EditorPages.PageCount>0) then
      for i:=0 to EditorPages.PageCount-1 do if EditorPages.Pages[i].Hint=f then
      begin
        L_SBAAddress.Items.Text:=
           SBAPrj.GetConfigConst(TSynEdit(MainForm.FindComponent('SynEdit_'+inttostr(EditorPages.Pages[i].Tag))).lines);
        exit;
      end;
    sl.LoadFromFile(f);
    L_SBAAddress.Items.Text:=SBAPrj.GetConfigConst(sl);
  finally
    if assigned(sl) then freeandnil(sl);
  end;
end;

procedure TMainForm.EditCopyExecute(Sender: TObject);
begin
  ActiveEditor.CopyToClipboard;
end;

procedure TMainForm.EditCutExecute(Sender: TObject);
begin
  ActiveEditor.CutToClipboard;
end;

procedure TMainForm.EditInsertDateExecute(Sender: TObject);
begin
  If assigned(ActiveEditor) then ActiveEditor.InsertTextAtCaret(FormatDateTime('yyyy/mm/dd',date));
end;

procedure TMainForm.EditInsertTemplateExecute(Sender: TObject);
var
  Ini:TIniFile;
  SL:TStringList;
  j,n:integer;
begin
  Infoln('Menu: '+TMenuItem(Sender).Caption);
  if (Sender.ClassName='TMenuItem') and assigned(ActiveEditor) then
  begin
    ActiveEditor.CaretX:=0;
    try
      SL:=TStringList.Create;
      SL.Clear;
      Ini:=TInifile.Create(ConfigDir+'templates.ini');
      j:=Ini.ReadInteger(TMenuItem(Sender).Caption,'Lines',0);
      for n:=0 to j-1 do SL.Add(Ini.ReadString(TMenuItem(Sender).Caption,'L'+inttostr(n),''));
      if SL.Count>0 then ActiveEditor.InsertTextAtCaret(SL.Text);
    finally
      if assigned(Ini) then freeAndNil(Ini);
      if assigned(SL) then freeAndNil(SL);
    end;
  end;
end;

procedure TMainForm.EditorHistoryClickHistoryItem(Sender: TObject;
  Item: TMenuItem; const Filename: string);
begin
  OpenInEditor(Filename);
end;

procedure TMainForm.EditorsTabContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
Var
  I:Integer;
begin
  MousePos:=EditorPages.ParentToClient(MousePos,EditorsTab);
  I:=EditorPages.IndexOfTabAt(MousePos.X,MousePos.Y);
//  StatusBar1.Panels[1].Text:=InttoStr(MousePos.X)+','+InttoStr(MousePos.Y)+':'+InttoStr(I);
  if I>=0 then
  begin
    EditorPages.ActivePageIndex:=I;
    EdTabMenu.PopUp;
  end;
end;

procedure TMainForm.EditPasteExecute(Sender: TObject);
begin
  ActiveEditor.PasteFromClipboard;
end;

procedure TMainForm.EditRedoExecute(Sender: TObject);
begin
  ActiveEditor.Redo;
end;

procedure TMainForm.EditSelectAllExecute(Sender: TObject);
begin
  ActiveEditor.SelectAll;
end;

procedure TMainForm.EditUndoExecute(Sender: TObject);
begin
  ActiveEditor.Undo;
end;

procedure TMainForm.FileSaveAsExecute(Sender: TObject);
begin
  If EditorPages.PageCount>0 then
  begin
    SaveDialog.FileName:=EditorPages.ActivePage.Hint;
    SaveDialog.InitialDir:=ExtractFilePath(EditorPages.ActivePage.Hint);
    SaveDialog.DefaultExt:=hdlext;
    SaveDialog.Filter:='VHDL file|*.vhd;*.vhdl|Verilog file|*.v;*.vl|System Verilog|*.sv|Ini files|*.ini|Text files|*.txt|All files|*.*';
    if SaveDialog.Execute and SaveFile(SaveDialog.FileName, ActiveEditor.Lines) then
    begin
      EditorPages.ActivePage.Hint:=SaveDialog.FileName;
      EditorPages.ActivePage.Caption:=ExtractFilename(SaveDialog.FileName);
      ActiveEditor.Modified:=false;
      ChangeEditorButtons(ActiveEditor);
      DetectSBAController;
      StatusBar1.Panels[1].Text:=SaveDialog.FileName;
    end;
  end;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  if not UpdtFlag then AutoUpdate;
end;

procedure TMainForm.AutoUpdate;
var
  wn:TStringList;
  s:string;
begin
  infoln('Search for new version');
  s:='';
  If NewVersionAvailable Then
  begin
    infoln('A new version is available, getting what is new file.');
    if GetWhatsNew then
    try
      infoln('What is new file was downloaded.');
      wn:=TStringList.Create;
      wn.LoadFromFile(ConfigDir+'whatsnew.txt');
      s:=wn.text;
      infoln(wn);
    finally
      if assigned(wn) then FreeAndNil(wn);
    end;
    if MessageDlg(Application.Title, Format('A new version %s is available.  Would you like to download it?'#10'%s',[GetNewVersion,s]), mtConfirmation, [mbYes, mbNo], 0, mbYes) = mryes then
      If DownloadNewVersion Then
        If MessageDlg(Application.Title, 'Download Succeeded.  Click OK to update',
          mtInformation, [mbOK], 0) = mrOK Then UpdateToNewVersion
        Else
          ShowMessage('Sorry, download of new version failed');
  end else infoln('A new version is not available or no detected.');
  UpdtFlag:=true;
  infoln('End of search for new version');
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  LogoImage.Visible:=Self.Width>575;
end;

procedure TMainForm.IdleTimer1Timer(Sender: TObject);
begin
  if (not ToolProcess.Running) and (ProcessStatus<>Idle) then
    ToolProcessTerminate(Sender);
  if (not DwProcess.Running) and (DwProcess.Status<>dwIdle) then
    DwProcess.OnTerminate(Sender);
end;

procedure TMainForm.LogoImageDblClick(Sender: TObject);
begin
  MainPages.ActivePage:=HidenPage;
  ActiveEditor:=SynEdit1;
end;

procedure TMainForm.L_SBALabelsDblClick(Sender: TObject);
begin
  ActiveEditor.SearchReplace(cSBALblSignatr+TListBox(Sender).GetSelectedText, '', [ssoEntireScope,ssoWholeWord])
end;

procedure TMainForm.MainPanelResize(Sender: TObject);
var v:integer;
begin
  //v:=max(128,max((MainPanel.Width-(50*5)) div 4,(MainPanel.Height-(50*3)) div 4));
  //btn_new_project.Constraints.MinHeight:=v;
  //btn_new_project.Constraints.MinWidth:=v;
end;

procedure TMainForm.PrjHistoryClickHistoryItem(Sender: TObject;
  Item: TMenuItem; const Filename: string);
begin
  if CompareText(Filename,(SBAPrj.location+SBAPrj.name+cSBAPrjExt))=0 then exit;
  if CloseProject then OpenProject(Filename);
end;

procedure TMainForm.PrjTreeClick(Sender: TObject);
var
  TN:TTreeNode;
begin
  TN:=PrjTree.Selected;
  if (TN<>nil) and (TN.Parent<>nil) and (TN.GetParentNodeOfAbsoluteLevel(0).Text='Lib') then
  try
    CoreImage.Picture.LoadFromFile(LibraryDir+TN.Text+PathDelim+'image.png');
  except
    ON E:Exception do CoreImage.Picture.Clear;
  end
  else CoreImage.Picture.Clear;
end;

procedure TMainForm.PrjTreeContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
var
  TN:TTreeNode;
begin
  FloatForm.Hide;
  TN:=PrjTree.Selected;
  if TN=nil then
  begin
    Handled:=true;
    exit;
  end;
  MI_AddCore.Visible:=false;
  MI_RemCore.Visible:=false;
  MI_AddInstance.Visible:=false;
  MI_AddUserFile.Visible:=false;
  MI_RemUserFile.Visible:=false;
  if ((TN.Parent=nil) and (TN.Text='User')) or
     ((TN.Parent<>nil) and (TN.Parent.Text='User')) then
  begin
    MI_AddUserFile.Visible:=true;
    MI_RemUserFile.Visible:=true;
  end;
  if ((TN.Parent<>nil) and (TN.GetParentNodeOfAbsoluteLevel(0).text='Lib')) or
     ((TN.Parent=nil) and (TN.text='Lib')) then
  begin
    MI_AddCore.Visible:=true;
    //MI_RemCore.Visible:=true;
    MI_AddInstance.Visible:=true;
  end;
end;

procedure TMainForm.PrjTreeDblClick(Sender: TObject);
var
  TN:TTreeNode;
  S,P:String;
begin
  TN:=PrjTree.Selected;
  if TN.Parent<>nil then
  begin
    S:=TN.GetParentNodeOfAbsoluteLevel(0).Text;
    if S=SBAPrj.name then P:=SBAPrj.location+SBAPrj.name+'_'+TN.Text+'.vhd'
    else case S of
    'Aux' :P:=SBAPrj.loclib+TN.Text+'.vhd';
    'Lib' :P:=SBAPrj.loclib+TN.Text+'.vhd';
    'User':P:=SBAPrj.GetUserFilePath(TN.Text)+TN.Text;
    end;
    OpenInEditor(P);
  end;
end;

procedure TMainForm.PrjTreeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  TN:TTreeNode;
begin
  FloatForm.hide;
  TN := PrjTree.GetNodeAt(X, Y);
  if (TN<>nil) then TN.Selected:=true else PrjTree.Selected:=nil;
end;

procedure TMainForm.PrjTreeMouseLeave(Sender: TObject);
begin
  FloatForm.L_CoreName.caption:='';
  FloatForm.hide;
end;

procedure TMainForm.PrjTreeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  P: TPoint;
  TN: TTreeNode;
  HitTestInfo: THitTests;
begin
  P:=Mouse.CursorPos;
  FloatForm.Top:=P.Y+10;
  FloatForm.Left:=P.X+10;
  TN := PrjTree.GetNodeAt(X, Y);
  HitTestInfo := PrjTree.GetHitTestInfoAt(X, Y) ;
  if (htOnItem in HitTestInfo) and (TN<>nil) and
     (TN.Parent<>nil) and (TN.GetParentNodeOfAbsoluteLevel(0).text='Lib') then
  begin
    FloatForm.ShowCoreImage(TN.Text);
  end else begin
    FloatForm.L_CoreName.caption:='';
    FloatForm.hide;
  end;
end;

procedure TMainForm.ProjectAddUserFilesExecute(Sender: TObject);
begin
  OpenDialog.DefaultExt:='';
  OpenDialog.Filter:='';
  If OpenDialog.execute and SBAPrj.AddUserFile(OpenDialog.Filename) then UpdatePrjTree;
end;

procedure TMainForm.ProjectCoresAddInstExecute(Sender: TObject);
var
  TN:TTreeNode;
  IP,IPS,STL,AML,DCL:TStringList;
  iname:string;
begin
  TN:=PrjTree.Selected;
  if (TN<>nil) and (TN.Parent<>nil) and (TN.GetParentNodeOfAbsoluteLevel(0).Text='Lib') then
  try
    IP:=TStringList.Create;
    IPS:=TStringList.Create;
    STL:=TStringList.Create;
    AML:=TStringList.Create;
    DCL:=TStringList.Create;
    iname:=TN.Text+'_'+inttostr(random(99));
    if InputQuery ('Add IP Core instance', 'Please type the name of the new instance:',iname) then
    try
      SBAPrj.LoadIPData(TN.Text,iname,IP,IPS,STL,AML,DCL);
      ActiveEditor.CaretX:=0;
      ActiveEditor.InsertTextAtCaret(IP.Text);
    except
      ON E:Exception do ShowMessage(E.Message);
    end;
  finally
    if assigned(DCL) then FreeAndNil(DCL);
    if assigned(AML) then FreeAndNil(AML);
    if assigned(STL) then FreeAndNil(STL);
    if assigned(IPS) then FreeAndNil(IPS);
    if assigned(IP) then FreeAndNil(IP);
  end
  else ShowMessage('Please select an IP core first');
end;

procedure TMainForm.ProjectCloseExecute(Sender: TObject);
begin
  CloseProject;
end;

procedure TMainForm.ProjectEditCoreListExecute(Sender: TObject);
begin
  if SBAPrj.EditLib then UpdatePrjTree;
end;

function TMainForm.CloseProject:boolean;
var CanClose:boolean;
begin
  result:=false;
  CanClose:=true;
  while EditorPages.PageCount>0 do
  begin
    CanClose:=CloseEditor(EditorPages.ActivePage);
    If not CanClose then break;
  end;
  If SBAPrj.Modified then
  begin
    CanClose:=false;
    case MessageDlg('The Project was modified', 'Save Project? ', mtConfirmation, [mbYes, mbNo, mbCancel],0) of
      mrCancel:exit;
      mrYes:CanClose:=SBAPrj.Save;
      mrNo:CanClose:=True;
    end;
  end;
  if CanClose then
  begin
    SBAPrj.name:='';
    SBAPrj.Modified:=false;
    MainPages.ActivePage:=SystemTab;
    result:=true;
  end;
end;

procedure TMainForm.ProjectExportExecute(Sender: TObject);
begin
  ExportPrjForm.L_PrjDir.Caption:='Project folder: '+SBAPrj.location;
  ExportPrjForm.Ed_TargetDir.Directory:=SBAPrj.exportpath;
  ExportPrjForm.CB_ExpPrjMonolithic.Checked:=SBAPrj.expmonolithic;
  ExportPrjForm.CB_ExpPrjAllLib.Checked:=SBAPrj.explibfiles;
  if ExportPrjForm.Showmodal=mrOk then with ExportPrjForm, SBAPrj do
  begin
    exportpath:=AppendPathDelim(TrimFilename(Ed_TargetDir.Text));
    expmonolithic:=CB_ExpPrjMonolithic.Checked;
    explibfiles:=CB_ExpPrjAllLib.Checked;
    Modified:=true;
    SBAPrj.PrjExport;
  end;
end;

procedure TMainForm.ProjectGotoEditorExecute(Sender: TObject);
begin
  P_Project.Visible:=false;
  GotoEditor;
end;

procedure TMainForm.GotoEditor;
begin
  If EditorPages.PageCount=0 then
  begin
    EditorCnt:=1;
    NewEditorPage;
  end;
  MainPages.ActivePage:=EditorsTab;
end;

procedure TMainForm.ProjectGotoPrgExecute(Sender: TObject);
var tmp:TStringList;
begin
  PrgReturnTab:=SystemTab;
  SBA_ReturnToEditor.Enabled:=false;
  MainPages.ActivePage:=ProgEditTab;
  if EditorEmpty(ActiveEditor) then
  begin
   SBAContrlrProg.Filename:=cSBADefaultPrgName;
   StatusBar1.Panels[1].Text:=cSBADefaultPrgName;
   try
     tmp:=tstringlist.Create;
     try
       tmp.LoadFromFile(ConfigDir+IFTHEN(CtrlAdvMode,cSBAAdvPrgTemplate,cSBADefPrgTemplate));
       ActiveEditor.Lines.Assign(tmp);
     except
       On E:Exception do ShowMessage(E.Message);
     end;
   finally
     if assigned(tmp) then freeandnil(tmp);
   end;
   ExtractSBALabels;
  end;
end;

procedure TMainForm.ProjectNewExecute(Sender: TObject);
var TmpPrj:TSBAPrj;
begin
  if CloseProject then
  begin
    TmpPrj:=TSBAPrj.Create;
    if (PrjWizForm.NewPrj(TmpPrj)=mrOk) and TmpPrj.PrepareNewFolder then
    begin
      if assigned(SBAPrj) then freeAndNil(SBAPrj);
      SBAPrj:=TmpPrj;
      OpenProject(SBAPrj.location+SBAPrj.name+cSBAPrjExt);
    end else FreeAndNil(TmpPrj);
  end;
end;

procedure TMainForm.ProjectOpenExecute(Sender: TObject);
begin
  OpenDialog.FileName:='';
  OpenDialog.DefaultExt:='.sba';
  OpenDialog.Filter:='SBA project|*.sba';
  if OpenDialog.Execute then OpenProject(OpenDialog.FileName);
end;

procedure TMainForm.OpenProject(const f: string);
var
  SL:TStringList;
  s:string;
begin
  if not FileExistsUTF8(f) then
  begin
    showmessage('The project '+f+' does not exist');
    exit;
  end;
  try
    SL:=TStringList.create;
    SL.LoadFromFile(f);
    if not SBAPrj.Fill(SL.Text) then exit;
    SBAPrj.Modified:=false;
    // Detecta que el path del archivo es diferente a SBAPrj.location lo cual significa que el proyecto fue movido o copiado e intenta corregir location.
    if CompareText(TrimFileName(SBAPrj.location),TrimFileName(ExtractFilePath(f)))<>0 then
    begin
      if (MessageDlg('The project has been copied or moved', 'Do you want to update the references? ', mtConfirmation, [mbYes, mbNo],0)=mrYes) and
          fileexistsUTF8(ExtractFilePath(f)+SBAPrj.name+'_'+cSBATop) then
      begin
        SBAPrj.location:=ExtractFilePath(f);
        SBAPrj.loclib:=SBAPrj.location+'lib'+PathDelim;
        SBAPrj.Modified:=true;
      end else ShowMessage('The project files can not be found');
    end;
    //
    UpdatePrjTree;
    PrjHistory.UpdateList(f);
    P_Project.Visible:=true;
    If MainPages.ActivePage=SystemTab then GotoEditor;
    S:=SBAPrj.location+SBAPrj.name+'_Top.vhd';
    OpenInEditor(S);
    if AutoOpenPrjF then
    begin
     S:=SBAPrj.location+SBAPrj.name+'_SBAcfg.vhd';
     OpenInEditor(S);
     S:=SBAPrj.location+SBAPrj.name+'_SBAdcdr.vhd';
     OpenInEditor(S);
     S:=SBAPrj.location+SBAPrj.name+'_SBActrlr.vhd';
     OpenInEditor(S);
    end;
    Log.clear;
  finally
    if assigned(SL) then FreeAndNil(SL);
  end;
end;

procedure TMainForm.MainPagesChange(Sender: TObject);
begin
  If MainPages.ActivePage=EditorsTab then
  begin
    if P_Project.visible then
    begin
      MainForm.Menu := EditorMenu;
      ProjectMenuEd.Visible:=true;
    end else
    begin
      MainForm.Menu := EditorMenu;
      ProjectMenuEd.Visible:=false;
    end;
    EditorPagesChange(Self);
  end else if MainPages.ActivePage=ProgEditTab then
  begin
    MainForm.Menu := ProgMenu;
    ActiveEditor:= SynEdit_X;
    SyncroEdit.Editor:=ActiveEditor;
    hdltypeselect('.prg');
  end else if MainPages.ActivePage=SystemTab then
  begin
    MainForm.Menu := MainMenu;
    StatusBar1.Panels[0].Text:='';
    StatusBar1.Panels[1].Text:='';
    Log.Clear;
  end else MainForm.Menu := nil;
end;

procedure TMainForm.ProjectRemUserFileExecute(Sender: TObject);
var
  TN:TTreeNode;
begin
  TN:=PrjTree.Selected;
  if (TN<>nil) and (TN.Parent<>nil) and (TN.Parent.Text='User') and
     SBAPrj.RemUserFile(TN.Text) then
  UpdatePrjTree;
end;

procedure TMainForm.ProjectSaveExecute(Sender: TObject);
var
  i:integer;
  CurrentEditor:TSynEdit;
begin
  if EditorPages.PageCount>0 then For i:=0 to EditorPages.PageCount-1 do
  begin
    CurrentEditor:=TSynEdit(MainForm.FindComponent('SynEdit_'+inttostr(EditorPages.Pages[i].Tag)));
    if CurrentEditor.Modified then
    begin
      SaveFile(EditorPages.Pages[i].Hint, CurrentEditor.Lines);
      CurrentEditor.Modified:=false;
      EditorPages.Pages[i].Caption:=ExtractFileName(EditorPages.Pages[i].Hint);
    end;
  end;
  SBAPrj.Save;
end;

procedure TMainForm.SBA_cancelExecute(Sender: TObject);
begin
  if SynEdit_X.Modified then
  case MessageDlg('File was modified', 'Save File? ', mtConfirmation, [mbYes, mbNo, mbCancel],0) of
    mrCancel: exit;
    mrYes: SBA_SaveExecute(nil);
    mrNo: begin SynEdit_X.ClearAll; SynEdit_X.Modified:=false; end;
  end;
  if not SynEdit_X.Modified then
  begin
    MainPages.ActivePage:=PrgReturnTab;
    SynEdit_X.ClearAll;
    SynEdit_X.Modified:=false;
  end;
end;

procedure TMainForm.FileCloseExecute(Sender: TObject);
begin
  CloseEditor(EditorPages.ActivePage);
  If EditorPages.PageCount=0 then
  begin
    if not P_Project.Visible then MainPages.ActivePage:=SystemTab
    else begin
      EditorCnt:=1;
      NewEditorPage;
    end;
  end;
end;

procedure TMainForm.SBA_InsertTemplateExecute(Sender: TObject);
var
  S:String;
begin
  if Sender.ClassName='TMenuItem' then
  begin
    ActiveEditor.CaretX:=0;
    S:=TMenuItem(Sender).Caption;
    If Pos('/SBA',S)<>0 then S:=S+' '+StringOfChar('-',79-length(S))+sLineBreak;
    ActiveEditor.InsertTextAtCaret(S);
  end;
end;

procedure TMainForm.SBA_NewPrgExecute(Sender: TObject);
var
  tmp:TstringList;
begin
  if ActiveEditor.Modified then
  case MessageDlg('File was modified', 'Save File? ', mtConfirmation, [mbYes, mbNo, mbCancel],0) of
    mrCancel: exit;
    mrYes: SBA_SaveExecute(nil);
  end;
  ActiveEditor.Modified:=false;
  SBAContrlrProg.Filename:=cSBADefaultPrgName;
  hdltypeselect('.prg');
  StatusBar1.Panels[1].Text:=cSBADefaultPrgName;
  tmp:=tstringlist.Create;
  tmp.LoadFromFile(ConfigDir+IFTHEN(CtrlAdvMode,cSBAAdvPrgTemplate,cSBADefPrgTemplate));
  ActiveEditor.Lines.Assign(tmp);
  if assigned(tmp) then freeandnil(tmp);
  ExtractSBALabels;
end;

procedure TMainForm.LV_SnippetsClick(Sender: TObject);
var
  f:string;
  l:TListItem;
begin
  L:=LV_Snippets.Selected;
  if (L=nil) or (LV_Snippets.Items.Count=0) then exit;
  f:=L.SubItems[0];
  if f<>'' then
  begin
    SBASnippet.filename:=f;
    if SBASnippet.description.count>0 then SnippetDescription.Lines.Assign(SBASnippet.description);
  end;
end;

procedure TMainForm.TFindDialogFind(Sender: TObject);
var
  encon : integer;
  buscado : string;
  opciones: TSynSearchOptions;
  Dialog: TFindDialog;
begin
  Dialog:=TFindDialog(Sender);
  buscado := Dialog.FindText;
  opciones := [];
  if not(frDown in Dialog.Options) then opciones += [ssoBackwards];
  if frMatchCase in Dialog.Options then opciones += [ssoMatchCase];
  if frWholeWord in Dialog.Options then opciones += [ssoWholeWord];
  if frEntireScope in Dialog.Options then opciones += [ssoEntireScope];
  encon := ActiveEditor.SearchReplace(buscado,'',opciones);
  if encon = 0 then
  ShowMessage('Not found: ' + buscado);
end;

procedure TMainForm.ToolsFileObfExecute(Sender: TObject);
begin
  If ToolsFileObf.Checked then
  begin
    P_Obf.Visible:=true;
    LoadRsvWordsFile;
    WordSelectionChange(L_RsvWord);
    HighLightReservedWords(L_RsvWord.Items);
  end else
  begin
    P_Obf.Visible:=false;
    ActiveEditor.SetHighlightSearch('',[ssoSelectedOnly,ssoWholeWord]);
    HighLightReservedWords(nil);
  end;
end;

procedure TMainForm.ToolsFileReformatExecute(Sender: TObject);
var OSL,NSL:TStrings;
begin
  ToolsFileReformat.Enabled:=false;
  OSL:=ActiveEditor.Lines;
  NewEditorPage;
  NSL:=ActiveEditor.Lines;
  ActiveEditor.BeginUpdate(false);
  Reformat(OSL,NSL);
  ActiveEditor.EndUpdate;
  ActiveEditor.Modified:=true;
  ToolsFileReformat.Enabled:=true;
end;

procedure TMainForm.FileRevertExecute(Sender: TObject);
begin
  if Open(EditorPages.ActivePage.Hint) then
  begin
    ChangeEditorButtons(ActiveEditor);
    DetectSBAController;
  end;
end;

procedure TMainForm.FileSaveExecute(Sender: TObject);
begin
  If Pos('FileNew',EditorPages.ActivePage.Hint)=0 then
  begin
    SaveFile(EditorPages.ActivePage.Hint, ActiveEditor.Lines);
    ActiveEditor.Modified:=false;
    ChangeEditorButtons(ActiveEditor);
    DetectSBAController;
  end else FileSaveAsExecute(Sender);
end;

procedure TMainForm.ToolsFileSyntaxCheckExecute(Sender: TObject);
var s:string;
begin
  {$IFDEF WINDOWS}
  { TODO : Completar la verificación en el caso de LINUX }
  case hdltype of
    vhdl : begin
      if not fileexistsUTF8(AppDir+'ghdl\bin\ghdl.exe') then
      begin
       showmessage('GHDL tool not found');
       exit;
      end;
    end;
    verilog,systemverilog : begin
      if not fileexistsUTF8(AppDir+'iverilog\bin\iverilog.exe') then
      begin
       showmessage('Icarus Verilog tool not found');
       exit;
      end;
    end;
    else begin
      showmessage('Sorry, Syntax check is not yet implemented for this kind of file.');
      exit;
    end;
  end;
  {$ENDIF}
  s:=EditorPages.ActivePage.Hint;
  if ActiveEditor.Modified then
  case MessageDlg('File must be saved', 'Save File? '+s, mtConfirmation, [mbYes, mbNo],0) of
    mrYes: if not SaveFile(s,ActiveEditor.Lines) then exit else ActiveEditor.Modified:=false;
  else exit;
  end;
  ToolsFileSyntaxCheck.Enabled:=false;
  if SBAPrj.name='' then SyntaxCheck(s,'',hdltype) else SyntaxCheck(s,SBAPrj.GetAllFileNames,hdltype);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=false;
  If DownloadInProgress Then
  Begin
    ShowMessage('Please wait. Download is still in progress.');
    exit;
  End;
  if not CloseProg then exit else CanClose:=true;
  while EditorPages.PageCount>0 do
  begin
    CanClose:=CloseEditor(EditorPages.ActivePage);
    If not CanClose then break;
  end;
  if SBAPrj.Modified then CanClose:=CloseProject;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var Success:Boolean;
begin
  Check;
  DebugForm:=TDebugForm.Create(Self);
  infoln('Start of create method');
  Success:=false;
  try
    Success:=GetConfigValues;
    Success:=Success and SetupConfig;
  finally
    if not Success then
    begin
     infoln('There was an error in Create Method');
     ShowMessage('Sorry, an unrecoverable error has occurred, the application is going to exit now');
     Halt;
    end else begin
      infoln('Config values OK '+ConfigDir);
      caption:='SBA Creator v'+GetFileVersion;
      infoln(caption);
      wdir:='.\';
      DwProcess:=TDwProcess.Create(Self);
      LoadAnnouncement;
      GetFile('newbanner.gif');
      MainPages.ShowTabs:=false;
      MainPages.ActivePage:=SystemTab;
      SBAPrj:=TSBAPrj.Create;
      SBAContrlrProg:=TSBAContrlrProg.Create;
      SBASnippet:=TSBASnippet.Create;
      SBASnippet.UpdateSnippetsFilter(SnippetsFilter);
      IpCoreList:=TStringList.Create;
      SnippetsList:=TStringList.Create;
      ProgramsList:=TStringList.Create;
      PlugInsList:=TStringList.Create;
      UpdateLists;
      SetupPrgTmplMenu;
      SetupEdTmplMenu;
      SynSBASyn:= TSynSBASyn.Create(Self);
      SynVerilogSyn:= TSynVerilogSyn.Create(Self);
      SynJSONSyn:=TSynJSONSyn.create(Self);
      SetupSynMarkup;
      SetupEditorPopupMenu;
      SynEdit_X.Font.Name:=EditorFontName;
      SynEdit_X.Font.Size:=EditorFontSize;
      EditorHistory.IniFile:=ConfigDir+'FileHistory.ini';
      PrjHistory.IniFile:=ConfigDir+'FileHistory.ini';
      EditorHistory.UpdateParentMenu;
      CreatePlugInsBtns;
      LoadTheme(ConfigDir+'theme'+PathDelim);
      infoln('All FormCreate tasks finished');
    end;
  end;
end;

procedure TMainForm.SetupEditorPopupMenu;
var
  i:integer;
  M:TMenuItem;
begin
  EditorPopUp.Items.Clear;
  for i:=0 to EditMenu.Count-1 do
  begin
    M:=TMenuItem.Create(SynEdit_X.PopupMenu);
    M.Caption:=EditMenu[i].Caption;
    M.Action:=EditMenu[i].Action;
    EditorPopUp.Items.Add(M);
  end;
end;

procedure TMainForm.SetupSynMarkup;
begin
  SynMarkup:=TSynEditMarkupHighlightAllCaret(SynEdit_X.MarkupByClass[
    TSynEditMarkupHighlightAllCaret]);
  SynMarkup.MarkupInfo.Background := clBtnFace;
  SynMarkup.MarkupInfo.FrameColor:= clGray;
  SynMarkup.WaitTime := 500; // tiempo en millisegundos
  SynMarkup.Trim := True;
  SynMarkup.FullWord:= True;
end;

procedure TMainForm.SetupPrgTmplMenu;
var
  M:TMenuItem;
begin
  If Assigned(PrgTemplates) then with PrgTemplates do
  begin
    PrgTemplates.Items.Clear;
    //
    M:=TMenuItem.Create(PrgTemplates);
    M.OnClick:=@SBA_InsertTemplateExecute;
    M.Caption:=cSBAStartProgDetails;
    PrgTemplates.Items.Add(M);
    //
    M:=TMenuItem.Create(PrgTemplates);
    M.OnClick:=@SBA_InsertTemplateExecute;
    M.Caption:=cSBAStartUSignals;
    PrgTemplates.Items.Add(M);
    //
    M:=TMenuItem.Create(PrgTemplates);
    M.OnClick:=@SBA_InsertTemplateExecute;
    M.Caption:=cSBAStartUProc;
    PrgTemplates.Items.Add(M);
    //
    M:=TMenuItem.Create(PrgTemplates);
    M.OnClick:=@SBA_InsertTemplateExecute;
    M.Caption:=cSBAStartProgUReg;
    PrgTemplates.Items.Add(M);
    //
    M:=TMenuItem.Create(PrgTemplates);
    M.OnClick:=@SBA_InsertTemplateExecute;
    M.Caption:=cSBAStartUserProg;
    PrgTemplates.Items.Add(M);
    //
    M:=TMenuItem.Create(PrgTemplates);
    M.OnClick:=@SBA_InsertTemplateExecute;
    M.Caption:=cSBAStartUStatements;
    PrgTemplates.Items.Add(M);
    //
    M:=TMenuItem.Create(PrgTemplates);
    M.OnClick:=@SBA_InsertTemplateExecute;
    M.Caption:=cSBAEndProgDetails;
    PrgTemplates.Items.Add(M);
    //
    M:=TMenuItem.Create(PrgTemplates);
    M.OnClick:=@SBA_InsertTemplateExecute;
    M.Caption:=cSBALblSignatr;
    PrgTemplates.Items.Add(M);
    //
  end;
end;

procedure TMainForm.SetupEdTmplMenu;
var
  Ini:TIniFile;
  M:TMenuItem;
  S:String;
  i,j:integer;

  procedure CreateSubMenu(N:TMenuItem);
  var
    M:TMenuItem;
    S:String;
    i,j:integer;
  begin
    If not assigned(N) then exit;
    if Ini.ValueExists(N.Caption,'NumItems') then
    begin
      j:=Ini.ReadInteger(N.Caption,'NumItems',0);
      for i:=0 to j-1 do
      begin
        S:=Ini.ReadString(N.Caption,'I'+inttostr(i),'');
        M:=TMenuItem.Create(N);
        M.Caption:=S;
        CreateSubMenu(M);
        N.Add(M);
      end;
    end else N.OnClick:=@EditInsertTemplateExecute;
  end;

begin
  If Assigned(EdTemplates) then with EdTemplates do
  begin
    EdTemplates.Items.Clear;
    Try
      Ini:=TIniFile.Create(ConfigDir+'templates.ini');
      j:=Ini.ReadInteger('MAIN','NumItems',0);
      for i:=0 to j-1 do
      begin
        S:=Ini.ReadString('MAIN','I'+inttostr(i),'');
        M:=TMenuItem.Create(EdTemplates);
        M.Caption:=S;
        EdTemplates.Items.Add(M);
        CreateSubMenu(M);
      end;
    finally
      If Assigned(Ini) then FreeAndNil(Ini);
    end;
  end;
end;

procedure TMainForm.NewEditorPage;
var
  ActiveTab:TTabSheet;
begin
  ActiveTab:=EditorPages.AddTabSheet;
  ActiveTab.Caption:='NewFile'+inttostr(EditorCnt)+'.vhd';
  ActiveTab.Hint:=AppendPathDelim(GetCurrentDirUTF8)+ActiveTab.Caption;
  ActiveTab.Tag:=EditorCnt;
  Inc(EditorCnt);
  CreateEditor(ActiveTab);
  EditorPages.ActivePage:=ActiveTab;
  ChangeEditorButtons(ActiveEditor);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(PlugInsList) then FreeandNil(PlugInsList);
  if Assigned(ProgramsList) then FreeandNil(ProgramsList);
  if Assigned(SnippetsList) then FreeandNil(SnippetsList);
  if Assigned(IPCoreList) then FreeandNil(IPCoreList);
  If Assigned(SynSBASyn) then FreeandNil(SynSBASyn);
  If Assigned(SynVerilogSyn) then FreeandNil(SynVerilogSyn);
  If Assigned(SynJSONSyn) then FreeandNil(SynJSONSyn);
  if Assigned(SBASnippet) then FreeandNil(SBASnippet);
  If Assigned(SBAContrlrProg) then FreeandNil(SBAContrlrProg);
  if assigned(SBAPrj) then FreeAndNil(SBAPrj);
  if Assigned(DebugForm) then FreeandNil(DebugForm);
end;

procedure TMainForm.FormDropFiles(Sender: TObject;
const FileNames: array of String);
var
  f:string;
  i:integer;
begin
  If MainPages.ActivePage=SystemTab then ProjectGotoEditorExecute(nil);
  For i:=0 to Length(FileNames)-1 do
  begin
    f:=FileNames[i];
    if fileexistsUTF8(f) then
    begin
      if not EditorEmpty(ActiveEditor) then NewEditorPage;
      if Open(f) then
      begin
        EditorPages.ActivePage.Hint:=f;
        EditorPages.ActivePage.Caption:=ExtractFilename(f);
      end;
    end;
  end;
  ChangeEditorButtons(ActiveEditor);
  DetectSBAController;
  if ToolsFileObf.Checked then ToolsFileObfExecute(Sender);
end;

procedure TMainForm.HelpAboutExecute(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.LogDblClick(Sender: TObject);
var
  p:tpoint;
  s:string;
begin
  s:=Log.GetSelectedText; if s='' then exit;
  if s[2]=':' then s[2]:=' '; //to remove ':' in drive letter
  if pos('line ',s)=1 then s[5]:=':';  // for catch hdlobf result errors
  p.y:=strtointdef(ExtractDelimited(2,s,[':']),0);
  p.x:=strtointdef(ExtractDelimited(3,s,[':']),0);
  if (p.y<>0) then ActiveEditor.CaretXY:=p;
  ActiveEditor.SetFocus;
end;

procedure TMainForm.LogMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  k: integer;
  s: string;
begin
  k := Log.ItemAtPos(Point(X,Y),true);
  if fOldIndex <> k then Application.CancelHint;
  fOldIndex:= k;
  if k = -1 then begin
    Log.ShowHint:=false;
  end else begin
    s := Log.Items[k];
    if Log.Canvas.TextWidth(s)>Log.Width-10 then begin
      Log.ShowHint := true;
      Log.Hint := Log.Items[k];
    end else begin
      Log.ShowHint := false;
    end;
  end;
end;

procedure TMainForm.SBA_OpenExecute(Sender: TObject);
begin
  if ActiveEditor.Modified then
  case MessageDlg('File was modified', 'Save File? ', mtConfirmation, [mbYes, mbNo, mbCancel],0) of
    mrCancel: exit;
    mrYes: SBA_SaveExecute(nil);
  end;
  SynEdit_X.Modified:=false;
  OpenDialog.FileName:='';
  OpenDialog.DefaultExt:='.prg';
  OpenDialog.Filter:='PRG and SNP files|*.prg;*.snp|PRG file|*.prg|SNP file|*.snp';
  if OpenDialog.Execute and Open(OpenDialog.FileName) then
  begin
    SBAContrlrProg.FileName:=OpenDialog.FileName;
    ExtractSBALabels;
  end;
end;

procedure TMainForm.SBA_ReturnToEditorExecute(Sender: TObject);
var
  SourceEditor:TSynEdit;
  undostrings:TStrings;
begin
  if PrgReturnTab<>EditorsTab then exit;
  SourceEditor:=TSynEdit(MainForm.FindComponent('SynEdit_'+inttostr(EditorPages.ActivePage.Tag)));
  If assigned(SourceEditor) then
  try
    undostrings:=TStringList.Create;
    SourceEditor.BeginUpdate(false);
    SynEdit_X.BeginUpdate(false);

    undostrings.Assign(SourceEditor.Lines);
    if not SBAContrlrProg.CpyProgDetails(SynEdit_X.Lines, SourceEditor.Lines) then
    begin
      SourceEditor.ClearAll;
      SourceEditor.Lines.Assign(undostrings);
      ShowMessage('Error Copying program details: Please verify "'+cSBAStartProgDetails+'" signatures.');
      Exit;
    end;

    undostrings.Assign(SourceEditor.Lines);
    if not SBAContrlrProg.CpyUSignals(SynEdit_X.Lines, SourceEditor.Lines) and CtrlAdvMode then
    begin
      SourceEditor.ClearAll;
      SourceEditor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User signals and type definitions: Please verify "'+cSBAStartUSignals+'" signatures.');
      Exit;
    end;

    undostrings.Assign(SourceEditor.Lines);
    if not SBAContrlrProg.CpyUProcedures(SynEdit_X.Lines, SourceEditor.Lines) and CtrlAdvMode then
    begin
      SourceEditor.ClearAll;
      SourceEditor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User Procedures and Functions: Please verify "'+cSBAStartUProc+'" signatures.');
      Exit;
    end;

    undostrings.Assign(SourceEditor.Lines);
    if not SBAContrlrProg.CpyProgUReg(SynEdit_X.Lines, SourceEditor.Lines) then
    begin
      SourceEditor.ClearAll;
      SourceEditor.Lines.Assign(undostrings);
      ShowMessage('Error Copying user registers and constants: Please verify "'+cSBAStartProgUReg+'" signatures.');
      Exit;
    end;

    undostrings.Assign(SynEdit_X.Lines);
    if not SBAContrlrProg.GenLblandProgFormat(SynEdit_X.Lines,L_SBALabels.Items) then
    begin
      SynEdit_X.Lines.Assign(undostrings);
      ExtractSBALabels;
      ShowMessage('Error Generating Labels constants and formating user program: Program format error, please verify "/SBA:" signatures.');
      Exit;
    end;

    undostrings.Assign(SourceEditor.Lines);
    if not SBAContrlrProg.CpyProgLabels(L_SBALabels.Items, SourceEditor.Lines) then
    begin
      SourceEditor.ClearAll;
      SourceEditor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User generated labels to controller: Please verify "'+cSBAStartProgLabels+'" signature in the controller.');
      Exit;
    end;

    undostrings.Assign(SourceEditor.Lines);
    if not SBAContrlrProg.CpyUserProg(SynEdit_X.Lines, SourceEditor.Lines) then
    begin
      SourceEditor.ClearAll;
      SourceEditor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User program to controller: Please verify "'+cSBAStartUserProg+'" signatures.');
      Exit;
    end;

    undostrings.Assign(SourceEditor.Lines);
    if not SBAContrlrProg.CpyUStatements(SynEdit_X.Lines, SourceEditor.Lines) and CtrlAdvMode then
    begin
      SourceEditor.ClearAll;
      SourceEditor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User Statements: Please verify "'+cSBAStartUStatements+'" signatures.');
      Exit;
    end;

    SynEdit_X.Modified:=false;
    MainPages.ActivePage:=EditorsTab;
    EditorPagesChange(nil);

  finally
    SynEdit_X.EndUpdate;
    SourceEditor.EndUpdate;
    SourceEditor.Modified:=true;
    If assigned(undostrings) then FreeAndNil(undostrings);
  end;
end;

procedure TMainForm.SBA_SaveAsExecute(Sender: TObject);
begin
  SaveDialog.FileName:=SBAContrlrProg.FileName;
  If EditorPages.ActivePage<>nil then SaveDialog.InitialDir:=ExtractFilePath(EditorPages.ActivePage.Hint);
  SaveDialog.DefaultExt:='.prg';
  SaveDialog.Filter:='PRG and SNP files|*.prg;*.snp|PRG file|*.prg|SNP file|*.snp';
  if SaveDialog.Execute and SaveFile(SaveDialog.FileName, SynEdit_X.Lines) then
  begin
    SBAContrlrProg.FileName:=SaveDialog.FileName;
    SynEdit_X.Modified:=false;
    ExtractSBALabels;
    StatusBar1.Panels[1].Text:=SaveDialog.FileName;
  end;
end;

procedure TMainForm.SBA_SaveExecute(Sender: TObject);
begin
  If SBAContrlrProg.FileName<>cSBADefaultPrgName then
  begin
    SaveFile(SBAContrlrProg.FileName,SynEdit_X.Lines);
    SynEdit_X.Modified:=false;
    ExtractSBALabels;
  end
  else SBA_SaveAsExecute(Sender);
end;

procedure TMainForm.TReplaceDialogReplace(Sender: TObject);
var
  encon, r : integer;
  buscado : string;
  opciones: TSynSearchOptions;
begin
  if ActiveEditor.ReadOnly then
  begin
   ShowMessage('The file in the editor is read only');
   exit;
  end;
  buscado := SearchReplace.Dialog.FindText;
  opciones := [ssoFindContinue];
  if not(frDown in SearchReplace.Dialog.Options) then opciones += [ssoBackwards];
  if frMatchCase in SearchReplace.Dialog.Options then opciones += [ssoMatchCase];
  if frWholeWord in SearchReplace.Dialog.Options then opciones += [ssoWholeWord];
  if frEntireScope in SearchReplace.Dialog.Options then opciones +=
  [ssoEntireScope];
  if frReplaceAll in SearchReplace.Dialog.Options then
  begin
    //se ha pedido reemplazar todo
    encon := ActiveEditor.SearchReplace(buscado,SearchReplace.Dialog.ReplaceText,
    opciones+[ssoReplaceAll]); //reemplaza
    ShowMessage('Se reemplazaron ' + IntToStr(encon) + ' ocurrencias.');
    exit;
  end;
  //reemplazo con confirmación
  SearchReplace.Dialog.CloseDialog;
  encon := ActiveEditor.SearchReplace(buscado,'',opciones); //búsqueda
  while encon <> 0 do
  begin
    //pregunta
    r := Application.MessageBox('¿Reemplazar esta ocurrencia?','Reemplazo',MB_YESNOCANCEL);
    if r = IDCANCEL then exit;
    if r = IDYES then
    begin
     ActiveEditor.TextBetweenPoints[ActiveEditor.BlockBegin,ActiveEditor.BlockEnd] :=
     SearchReplace.Dialog.ReplaceText;
    end;
    //busca siguiente
    encon := ActiveEditor.SearchReplace(buscado,'',opciones); //búsca siguiente
  end;
  ShowMessage('No se encuentra: ' + buscado);
end;

procedure TMainForm.WordMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  k: integer;
  s: string;
begin
  k := TListBox(Sender).ItemAtPos(Point(X,Y),true);
  if fOldIndex <> k then Application.CancelHint;
  fOldIndex:= k;
  if k = -1 then begin
    TListBox(Sender).ShowHint:=false;
  end else begin
    s := TListBox(Sender).Items[k];
    if TListBox(Sender).Canvas.TextWidth(s)>TListBox(Sender).Width-10 then begin
      TListBox(Sender).ShowHint := true;
      TListBox(Sender).Hint := TListBox(Sender).Items[k];
    end else begin
      TListBox(Sender).ShowHint := false;
    end;
  end;
end;

procedure TMainForm.WordSelectionChange(Sender: TObject);
Var S:String;
begin
  s:=TListBox(Sender).GetSelectedText;
  if hdltype in [vhdl,ini,prg,other] then ActiveEditor.SetHighlightSearch(S,[ssoSelectedOnly,ssoWholeWord])
    else ActiveEditor.SetHighlightSearch(S,[ssoMatchCase,ssoSelectedOnly,ssoWholeWord]);
end;

procedure TMainForm.FileNewExecute(Sender: TObject);
begin
  NewEditorPage;
end;

procedure TMainForm.FileOpenExecute(Sender: TObject);
begin
  OpenDialog.FileName:='';
  OpenDialog.InitialDir:=wdir;
  OpenDialog.DefaultExt:='.vhd';
  OpenDialog.Filter:='VHDL file|*.vhd;*.vhdl|Verilog file|*.v;*.vl;*.ver|System Verilog|*.sv|Ini files|*.ini|Text files|*.txt|All files|*.*';
  if OpenDialog.Execute then OpenInEditor(OpenDialog.FileName);
end;

procedure TMainForm.DetectSBAController;
begin
  SBA_EditProgram.Enabled:=SBAContrlrProg.DetectSBAContrlr(ActiveEditor.Lines);
end;

function TMainForm.EditorEmpty(Editor:TSynEdit):boolean;
begin
  Result:=(Editor.Lines.Count=0) or ((Editor.Lines.Count=1) and (Editor.Lines[1]=''));
end;

procedure TMainForm.ToolProcessReadData(Sender: TObject);
var
  t:TStringList;
begin
   t:=TStringList.Create;
   t.LoadFromStream(ToolProcess.Output);
   Log.Items.AddStrings(t);
infoln(t.Text);
   t.free;
end;

procedure TMainForm.ToolProcessTerminate(Sender: TObject);
var
  PS:TProcessStatus;
  PStr:String;
begin
  PStr:='';
  PS:=ProcessStatus;
  ProcessStatus:=Idle;
  if ToolProcess.NumBytesAvailable>0 then ToolProcessReadData(Sender);
  Log.ItemIndex:=Log.Count-1;
  case PS of
    SyntaxChk: ToolsFileSyntaxCheck.Enabled:=true;
  end;
{IFDEF Debug}
  case PS of
    Idle:PStr:='Idle';
    SyntaxChk:PStr:='SyntaxChk';
    Obfusct:PStr:='Obfusct';
  end;
  infoln('End of process: '+PStr);
{ENDIF}
end;

procedure TMainForm.RW_AddfromCBExecute(Sender: TObject);
begin
  L_RsvWord.Items.Add(Clipboard.AsText);
  HighLightReservedWords(L_RsvWord.Items);
end;

procedure TMainForm.RW_AddWordExecute(Sender: TObject);
var UserString:string='';
begin
  if InputQuery('Reserved Words', 'type the new word', UserString) then
  begin
    L_RsvWord.Items.Add(UserString);
    HighLightReservedWords(L_RsvWord.Items);
  end;
end;

procedure TMainForm.RW_OpenListExecute(Sender: TObject);
begin
  OpenDialog.FileName:=wdir+'rsvwords.txt';
  OpenDialog.DefaultExt:='.txt';
  OpenDialog.Filter:='Text files|*.txt';
  OpenDialog.InitialDir:=wdir;
  if OpenDialog.Execute then
  begin
    L_RsvWord.Items.LoadFromFile(UTF8toSys(OpenDialog.FileName));
    HighLightReservedWords(L_RsvWord.Items);
  end;
end;

procedure TMainForm.HighLightReservedWords(List:TStrings);
begin
  if List<>nil then
  begin
    SynSBASyn.HLWordsList.Assign(List);
    SynVerilogSyn.HLWordsList.Assign(List);
  end else
  begin
    SynSBASyn.HLWordsList.Clear;
    SynVerilogSyn.HLWordsList.Clear;
  end;
  ActiveEditor.Invalidate;
end;

procedure TMainForm.RW_RemoveExecute(Sender: TObject);
var
  i: integer;
begin
  if L_RsvWord.SelCount > 0 then
  begin
    L_RsvWord.Items.BeginUpdate;
    For i:=L_RsvWord.Items.Count-1 downto 0 do
      if L_RsvWord.Selected[i] then L_RsvWord.Items.Delete(i);
    L_RsvWord.Items.EndUpdate;
    HighLightReservedWords(L_RsvWord.Items);
  end else
  begin
      ShowMessage('Please select an item first!');
  end;
end;

procedure TMainForm.RW_SavelistExecute(Sender: TObject);
begin
  if fileexistsUTF8(wdir+'rsvwords.txt') and (MessageDlg('File of reserved words found', 'Replace File?', mtConfirmation, [mbYes, mbNo],0)<>mrYes) then exit;
  L_RsvWord.Items.SaveToFile(wdir+'rsvwords.txt');
end;

procedure TMainForm.SynEditStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  if ([scCaretX, scCaretY] * Changes) <> [] then
    StatusBar1.Panels[0].Text:=Format('%4d:%-4d',[TSynEdit(Sender).CaretY,TSynEdit(Sender).CaretX]);
  if scModified in Changes then ChangeEditorButtons(TSynEdit(Sender));
end;

procedure TMainForm.Ofuscate(f:string; hdl:thdltype);
var
  s,wpath,wfile:string;

begin
  case hdl of
    vhdl:s:='vhd';
    verilog:s:='ver';
    systemverilog:s:='sv';
  else
    s:=extractfileext(f);
  end;
  wpath:=extractfilepath(f);
  wfile:=extractfilename(f);
  while ProcessStatus<>Idle do begin sleep(300); application.ProcessMessages; end;
  ProcessStatus:=Obfusct;
  ToolProcess.Parameters.Clear;
  ToolProcess.CurrentDirectory:=wpath;

  {$IFDEF WINDOWS}
  ToolProcess.Executable:='cmd.exe';
  ToolProcess.Parameters.Add('/c');
  // Hay un bug en el CMD /C que no interpreta adecuadamente las rutas con paréntesis
  // La inclusión de los dobles "" ayuda en la solución temporal del bug
  ToolProcess.Parameters.Add('""'+AppDir+'obfuscator.bat" '+wfile+' obfuscated_file.'+s+' '+s+' '+mapfile+'"');
  {$ENDIF}
  {$IFDEF LINUX}
  ToolProcess.Executable:='/bin/bash';
  ToolProcess.Parameters.Add('-c');
  ToolProcess.Parameters.Add(AppDir+'obfuscator.sh '+wfile+' obfuscated_file.'+s+' '+s+' '+mapfile);
  {$ENDIF}
  {$IFDEF DARWIN}
  ShowMessage('Ofuscation is not yet implemented in Darwin');
  {$ENDIF}
  Log.Clear;
  ToolProcess.Execute;
  while ToolProcess.Running do begin sleep(300); application.ProcessMessages; end;
  if not fileexistsUTF8(wpath+'obfuscated_file.'+s) then
  begin
    showmessage('The obfuscated file not was created');
    exit;
  end else
  begin
    NewEditorPage;
    if Open(wpath+'obfuscated_file.'+s) then
    begin
      EditorPages.ActivePage.Hint:=wpath+'obfuscated_file.'+s;
      EditorPages.ActivePage.Caption:='obfuscated_file.'+s;
      ChangeEditorButtons(ActiveEditor);
      DetectSBAController;
    end;
  end;
end;

function TMainForm.Open(f:String):boolean;
begin
  result:=false;
  if FileExistsUTF8(f) then
  begin
    ActiveEditor.Lines.LoadFromFile(f);
    ActiveEditor.ReadOnly:=(FileGetAttrUTF8(f) and faReadOnly)<>0;
    wdir:=extractfilepath(f);
    if wdir='' then wdir:='.\';
    hdltypeselect(extractfileext(f));
    StatusBar1.Panels[1].Text:=f;
    EditorHistory.UpdateList(f);
    ActiveEditor.Modified:=false;
    result:=true;
  end else showmessage('The file: '+f+' was not found.');
end;

procedure TMainForm.OpenInEditor(const f: string);
var i:integer;
begin
  if (EditorPages.PageCount=0) then NewEditorPage else
    for i:=0 to EditorPages.PageCount-1 do
      if EditorPages.Pages[i].Hint=f then
      begin
        EditorPages.ActivePageIndex:=i;
        break;
      end;

  if EditorPages.ActivePage.Hint<>f then
  begin
    if not EditorEmpty(ActiveEditor) then NewEditorPage;
    if Open(f) then
    begin
      EditorPages.ActivePage.Hint:=f;
      EditorPages.ActivePage.Caption:=ExtractFilename(f);
    end;
  end;

  ChangeEditorButtons(ActiveEditor);
  DetectSBAController;
  if ToolsFileObf.Checked then ToolsFileObfExecute(nil);
end;

procedure TMainForm.Reformat(osl, nsl: Tstrings);
var
  s: string;
  c: char;
  j: Integer;
  i: Integer;
  ostr: TStringList;
  f,sp:boolean;

  function RandomCase(c:char):char;
  begin
    if Random(2)=1 then result:=upcase(c) else result:=lowercase(c);
  end;

begin
  ostr:=TStringList.Create;
  ostr.Assign(osl);

  //Delete comments
  for i:=ostr.Count-1 downto 0 do
  begin
    s:=ostr[i];
    j:=pos(commentstr,s);
    if j>0 then ostr[i]:=LeftStr(s,j-1);
  end;

  nsl.clear;
  s:=''; j:=1; f:=false; sp:=false;

  //Delete Tabs, Double spaces and CR LF, reformat to random case and 80 cols
  for i:=1 to length(ostr.Text) do
  begin
    c:=ostr.Text[i];
    case c of
      '"' : f:=not f;
      #09,#10,#13 : c:=' ';
      'a'..'z', 'A'..'Z': if (hdltype=vhdl) then c:=RandomCase(c);
    end;
    if (c=' ') then if sp then Continue else sp:=true else sp:=false;
    s:=s+c;
    if (j>80) and (c in [' ', ';', '+', '-', '(', ')']) and not f then
    begin
      nsl.Add(s);
      s:='';
      j:=1;
    end else inc(j);
  end;
  if s<>'' then nsl.Add(s);

  // Add last comments
  nsl.Add(commentstr+'------------------------------------------------------------------------------');
  nsl.Add(commentstr+' This file was obfuscated and reformated using SBA Creator                  --');
  nsl.Add(commentstr+' (c) Miguel Risco-Castillo                                                  --');
  nsl.Add(commentstr+'------------------------------------------------------------------------------');
  ostr.Free;
end;

function TMainForm.SaveFile(f:String; Src:TStrings):Boolean;
begin
  result:=false;
  if FileExistsUTF8(f) then RenameFile(f,f+'.bak');
  try
    Src.SaveToFile(f);
  except
    showmessage('Can not write '+f);
    exit;
  end;
  result:=true;
end;

procedure TMainForm.ChangeEditorButtons(editor:TSynEdit);
var f1,f2,f3:boolean;
begin
  f1:=editor.Modified;
  f2:=(editor.Lines.Count>0);
  f3:=not editor.ReadOnly;
  if MainPages.ActivePage=EditorsTab then
  begin
   FileRevert.Enabled:=f1;
   FileSave.Enabled:=f1 and f2;
   FileSaveAs.Enabled:=f2;
   ToolsFileObf.Enabled:=f2;
   ToolsFileReformat.Enabled:=f2 and f3;
   ToolsFileSyntaxCheck.Enabled:=f2;
   SearchReplace.Enabled:=f2 and f3;

   if (EditorPages.ActivePage.Caption='') then exit;
   if (MainPages.ActivePage=EditorsTab) then
     if (EditorPages.ActivePage.Caption[1]<>'*') then
     begin
       if f1 then EditorPages.ActivePage.Caption:='*'+ExtractFileName(EditorPages.ActivePage.Hint);
     end else if not f1 then EditorPages.ActivePage.Caption:=ExtractFileName(EditorPages.ActivePage.Hint);
  end;
end;

procedure TMainForm.SyntaxCheck(f, path: string; hdl: Thdltype);
var
  wpath,fname,checkbat:string;
begin
  {$IFDEF WINDOWS}
  case hdl of
    vhdl : checkbat:='checkvhdl.bat';
    systemverilog,verilog : checkbat:='checkver.bat';
  end;
  {$ENDIF}
  {$IFDEF LINUX}
  case hdl of
    vhdl : checkbat:='checkvhdl.sh';
    systemverilog,verilog : checkbat:='checkver.sh';
  end;
  {$ENDIF}
  {$IFDEF DARWIN}
  case hdl of
    vhdl : checkbat:='checkvhdl.sh';
    systemverilog,verilog : checkbat:='checkver.sh';
  end;
  {$ENDIF}
  wpath:=extractfilepath(f);
  fname:=extractfilename(f);
  while ProcessStatus<>Idle do begin sleep(300); application.ProcessMessages; end;
  ProcessStatus:=SyntaxChk;
  ToolProcess.Parameters.Clear;
  ToolProcess.CurrentDirectory:=wpath;
  {$IFDEF WINDOWS}
  ToolProcess.Executable:='cmd.exe';
  ToolProcess.Parameters.Add('/c');
  // Hay un bug en el CMD /C que no interpreta adecuadamente las rutas con paréntesis
  // La inclusión de los dobles "" ayuda en la solución temporal del bug
  if path<>'' then ToolProcess.Parameters.Add('""'+AppDir+checkbat+'" '+fname+' "'+path+'""')
  else ToolProcess.Parameters.Add('""'+AppDir+checkbat+'" '+fname+'"');
  {$ENDIF}
  {$IFDEF LINUX}
  ToolProcess.Executable:='/bin/bash';
  ToolProcess.Parameters.Add('-c');
  ToolProcess.Parameters.Add(AppDir+checkbat+' '+fname+' "'+path+'"');
  {$ENDIF}
  {$IFDEF DARWIN}
  ToolProcess.Executable:='sh';
  ToolProcess.Parameters.Add('-c');
  ToolProcess.Parameters.Add(AppDir+checkbat+' '+fname+' "'+path+'"');
  {$ENDIF}
  Log.Clear;
  ToolProcess.Execute;
  { TODO : Pensar en eliminar el .bat y usar una lista para crear los parámetros debido a las posibles rutas con espacios. }
end;

procedure TMainForm.ExtractSBALabels;
begin
  ActiveEditor.BeginUpdate(false);
  if SBAContrlrProg.ExtractSBALbls(ActiveEditor.Lines, L_SBALabels.Items) then HighLightReservedWords(L_SBALabels.Items);
  ActiveEditor.EndUpdate;
end;

procedure TMainForm.LoadRsvWordsFile;
begin
  if not fileexistsutf8(wdir+'rsvwords.txt') then copyfile(AppDir+'rsvwords.txt', wdir+'rsvwords.txt');
  L_RsvWord.Clear;
  L_RsvWord.Items.LoadFromFile(UTF8toSys(wdir+'rsvwords.txt'));
  HighLightReservedWords(L_RsvWord.Items);
end;

procedure TMainForm.UpdatePrjTree;
var
  t: TTreeNode;
  i: integer;
begin
  PrjTree.BeginUpdate;
  PrjTree.Items.Clear;

  t:=PrjTree.Items.AddChild(nil, SBAPrj.name);
  PrjTree.Items.AddChild(t, 'Top').StateIndex:=2;
  PrjTree.Items.AddChild(t, 'SBAcfg').StateIndex:=2;
  PrjTree.Items.AddChild(t, 'SBActrlr').StateIndex:=2;
  PrjTree.Items.AddChild(t, 'SBAdcdr').StateIndex:=2;

  t:=PrjTree.Items.AddChild(nil, 'Aux');
  PrjTree.Items.AddChild(t, 'SBApkg').StateIndex:=3;
  PrjTree.Items.AddChild(t, 'Syscon').StateIndex:=3;
  PrjTree.Items.AddChild(t, 'DataIntf').StateIndex:=3;

  t:=PrjTree.Items.AddChild(nil, 'Lib');
  AddIPCoresToTree(t,SBAPrj.libcores);

  t:=PrjTree.Items.AddChild(nil, 'User');
  if SBAPrj.userfiles.Count>0 then
  begin
   for i:=0 to SBAPrj.userfiles.Count-1 do
     PrjTree.Items.AddChild(t, SBAPrj.userfiles.names[i]).StateIndex:=5;
  end;

  PrjTree.FullExpand;
  PrjTree.EndUpdate;
end;

procedure TMainForm.AddIPCoresToTree(t:TTreeNode;cl:TStrings);
var
  c:TTreeNode;
  s:string;
  l:TStringList;
begin
  if cl.Count=0 then exit;
  if t.Level>5 then
  begin
    PrjTree.Items.AddChild(t,'...');
    exit;
  end;
  for s in cl do
  begin
    c:=PrjTree.Items.AddChild(t,s);
    c.StateIndex:=4;
    l:=SBAPrj.CoreGetReq(LibraryDir+s+PathDelim+s+'.ini');
    AddIPCoresToTree(c,l);
    if assigned(l) then freeandnil(l);
  end;
end;

procedure TMainForm.LoadAnnouncement;
begin
  if FileexistsUtf8(ConfigDir+'newbanner.gif') then
  try
    AnnouncementImage.AnimatedGifToSprite(ConfigDir+'newbanner.gif');
    infoln('Banner loaded');
  except
    ON E:Exception do
    begin
      DeleteFileUTF8(ConfigDir+'newbanner.gif');
      Infoln('Error loading new banner:'+E.Message);
    end;
  end;
end;

function TMainForm.CloseProg: boolean;
begin
  if SynEdit_X.Modified then
  begin
    MainPages.ActivePage:=ProgEditTab;
    ActiveEditor:=SynEdit_X;
    SyncroEdit.Editor:=ActiveEditor;
    case MessageDlg('Prg was modified', 'Save File? '+SBAContrlrProg.FileName,
       mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
       mrYes: Result:=SaveFile(SBAContrlrProg.FileName,SynEdit_X.Lines);
       mrNo: Result:=true;
    else Result:=false;
    end;
  end else Result:=true;
end;

procedure TMainForm.Check;
Var ExpDate : TDateTime;
begin
  ExpDate:=EncodeDate(2016,12,31);
  if CompareDate(Today,ExpDate)>0 then
  begin
    ShowMessage('Sorry, the beta period has expired. You can download the new version from http://sba.accesus.com, thanks you for your help!');
//    DeleteFile(Application.ExeName);
    halt;
  end;
end;

procedure TMainForm.hdltypeselect(const ts: string);
begin
  hdlext:=lowercase(ts);
  if (hdlext='.vhd') or (hdlext='.vhdl') then hdltype:=vhdl else
    if (hdlext='.prg') or (hdlext='.snp') then hdltype:=prg else
      if (hdlext='.v') or (hdlext='.vl') or (hdlext='.ver') then hdltype:=verilog else
        if (hdlext='.sv') then hdltype:=systemverilog else
          if (hdlext='.ini') then hdltype:=ini else
            if (hdlext='.sba') then hdltype:=json else
            hdltype:=other;
  case hdltype of
    vhdl,prg : begin
      commentstr:='--';
      ActiveEditor.Highlighter:=SynSBASyn;
      mapfile:='vhdl_map.dat'
    end;
    verilog,systemverilog : begin
      commentstr:='//';
      ActiveEditor.Highlighter:=SynVerilogSyn;
      mapfile:='verilog_map.dat'
    end;
    ini: begin
      commentstr:=';';
      ActiveEditor.Highlighter:=SynIniSyn;
      mapfile:='vhdl_map.dat'
    end;
    json: begin
      commentstr:='__comment';
      ActiveEditor.Highlighter:=SynJSONSyn;
      mapfile:='vhdl_map.dat'
    end;
    other : begin
      commentstr:='--';
      ActiveEditor.Highlighter:=nil;
      mapfile:='vhdl_map.dat'
    end;
  end;
end;

function TMainForm.GetFile(filename: string): boolean;
var
  f:String;
begin
  f:=ConfigDir+filename;
  result:=DwProcess.WGET(Format(SBADwUrl,[filename]),f);
  { TODO : WARNING: DwProcess también es usado en AutoUpdate, debería tenerse cuidado cuando se cambia el evento }
  if result then DwProcess.OnTerminate:=@dwTerminate;
end;

procedure TMainForm.dwTerminate(Sender: TObject);
begin
{ TODO : WARNING: DwProcess también es usado en AutoUpdate, debería tenerse cuidado cuando se cambia el evento }
  DwProcess.OnTerminate:=@DwProcess.dwTerminate;
  DwProcess.dwTerminate(Sender);
  LoadAnnouncement;
end;

end.

