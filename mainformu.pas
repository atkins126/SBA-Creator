unit MainFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ComCtrls, AsyncProcess, ExtCtrls, Menus, ActnList, SynHighlighterSBA,
  SynHighlighterVerilog, SynHighlighterJSON, SynEditMarkupHighAll, SynEdit,
  SynEditTypes, SynEditKeyCmds, SynPluginSyncroEdit, SynHighlighterIni,
  SynEditHighlighter, SynCompletion, SynPluginMulticaret, SynHighlighterHTML,
  SynExportHTML, SynHighlighterPas, SynHighlighterCpp, SynHighlighterPython,
  FileUtil, LazFileUtils, dateutils, ListViewFilterEdit,
  ExtendedNotebook, strutils, LazUTF8, Clipbrd, IniPropStorage, StdActns,
  BGRASpriteAnimation, uebutton, uETilePanel, versionsupportu, types, lclintf,
  LCLType, HistoryFiles, attabs, IniFiles, EditorU, FilesMonitorU;

type
  tProcessStatus=(Idle,TimeOut,SyntaxChk,Obfusct,exePlugIn);

  { TMainForm }

  TMainForm = class(TForm)
    HelpOpenHelp: TAction;
    MenuItem16: TMenuItem;
    MenuItem91: TMenuItem;
    MenuItem92: TMenuItem;
    MenuItem93: TMenuItem;
    MenuItem94: TMenuItem;
    SynPythonSyn: TSynPythonSyn;
    ToolButton13: TToolButton;
    ToolButton61: TToolButton;
    ToolsReloadPlugIns: TAction;
    EditCopyAsHtml: TAction;
    ATTabs1: TATTabs;
    MenuItem10: TMenuItem;
    MenuItem4: TMenuItem;
    SynCppSyn: TSynCppSyn;
    SynExporterHTML: TSynExporterHTML;
    SynFreePascalSyn: TSynFreePascalSyn;
    ToolsExporttoHtml: TAction;
    BitBtn1: TBitBtn;
    PlugInsMenu: TMenuItem;
    ProjectItemDataSheet: TAction;
    Bevel1: TBevel;
    B_InsertSnipped: TBitBtn;
    B_SBAAdress: TBitBtn;
    B_SBALabels: TBitBtn;
    FileOpenLoc: TAction;
    FileSaveAll: TAction;
    EditInsertAuthor: TAction;
    HelpSettings: TAction;
    EditorPages: TExtendedNotebook;
    HelpCheckUpdate: TAction;
    HelpGotoSBAWebsite: TAction;
    HelpGotoSBAForum: TAction;
    HelpAbout: TAction;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LV_Snippets: TListView;
    L_PrjInfo: TLabel;
    L_SBAAddress: TListView;
    L_SBALabels: TListView;
    MI_OpenDataSheet: TMenuItem;
    MenuItem71: TMenuItem;
    MenuItem72: TMenuItem;
    MenuItem73: TMenuItem;
    MenuItem74: TMenuItem;
    MenuItem75: TMenuItem;
    MenuItem76: TMenuItem;
    MenuItem77: TMenuItem;
    MenuItem78: TMenuItem;
    MenuItem80: TMenuItem;
    MenuItem81: TMenuItem;
    MenuItem82: TMenuItem;
    MenuItem83: TMenuItem;
    MenuItem84: TMenuItem;
    MenuItem85: TMenuItem;
    MenuItem86: TMenuItem;
    MenuItem87: TMenuItem;
    MenuItem88: TMenuItem;
    MenuItem89: TMenuItem;
    MenuItem90: TMenuItem;
    PrjTree: TTreeView;
    P_CodeSnippets: TPanel;
    P_ProgAddress: TPanel;
    P_ProgLabels: TPanel;
    SnippetDescription: TMemo;
    SnippetsFilter: TListViewFilterEdit;
    Splitter3: TSplitter;
    TabOpenLoc: TMenuItem;
    MI_OpenTreeItem: TMenuItem;
    ProjectOpenItem: TAction;
    ProjectUpdCore: TAction;
    EditInsertTemplate: TAction;
    EditBlkUncomment: TAction;
    EditBlkComment: TAction;
    EditBlkUnindent: TAction;
    EditBlkIndent: TAction;
    header_text: TImage;
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
    MenuItem70: TMenuItem;
    MI_UpdCore: TMenuItem;
    ProjectsHistory: TMenuItem;
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
    ProjectsHistory2: TMenuItem;
    SBA_InsertTemplate: TAction;
    MenuItem13: TMenuItem;
    PrgTemplates: TPopupMenu;
    SBA_NewPrg: TAction;
    ProjectExport: TAction;
    ProjectClose: TAction;
    ProjectSave: TAction;
    MenuItem12: TMenuItem;
    ProjectGotoPrg: TAction;
    B_Obf: TBitBtn;
    Label3: TLabel;
    Log: TListBox;
    L_RsvWord: TListBox;
    EdTabMenu: TPopupMenu;
    TabFileNew: TMenuItem;
    TabFileClose: TMenuItem;
    P_Project: TPanel;
    P_Editors: TPanel;
    P_AuxEditor: TPanel;
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
    Splitter2: TSplitter;
    Spl_Project: TSplitter;
    Splitter5: TSplitter;
    Splitter6: TSplitter;
    HiddenPage: TTabSheet;
    EndProcTimer: TTimer;
    DeferredTimer: TTimer;
    ToolBar4: TToolBar;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton27: TToolButton;
    ToolButton33: TToolButton;
    ToolButton48: TToolButton;
    ToolButton49: TToolButton;
    ToolButton60: TToolButton;
    ToolButton8: TToolButton;
    UpdGuiTimer: TTimer;
    ToolButton23: TToolButton;
    ToolButton46: TToolButton;
    EdTemplateButton: TToolButton;
    ToolButton50: TToolButton;
    ToolButton51: TToolButton;
    ToolButton52: TToolButton;
    ToolButton53: TToolButton;
    ToolButton54: TToolButton;
    ToolButton55: TToolButton;
    ToolButton56: TToolButton;
    ToolButton57: TToolButton;
    ToolButton58: TToolButton;
    ToolButton59: TToolButton;
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
    HelpMenuItem: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    P_Obf: TPanel;
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
    ToolButton43: TToolButton;
    PrgTemplateButton: TToolButton;
    ToolButton47: TToolButton;
    ToolsFileSyntaxCheck: TAction;
    ToolsFileReformat: TAction;
    ToolsFileObf: TAction;
    FileRevert: TAction;
    FileClose: TAction;
    FileSave: TAction;
    ToolsMenu: TMenuItem;
    MenuItem15: TMenuItem;
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
    SynEdit_Test: TSynEdit;
    SynCompletion: TSynCompletion;
    SynIniSyn: TSynIniSyn;
    SynHTMLSyn: TSynHTMLSyn;
    SynSBASyn:TSynSBASyn;
    SynVerilogSyn:TSynVerilogSyn;
    SynJSONSyn:TSynJSONSyn;
    SynMultiCaret:TSynPluginMulticaret;
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
    ToolButton14: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton2: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
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
    procedure ATTabs1TabPlusClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure B_SBAAdressClick(Sender: TObject);
    procedure btn_sba_libraryClick(Sender: TObject);
    procedure B_InsertSnippedClick(Sender: TObject);
    procedure B_SBALabelsClick(Sender: TObject);
    procedure DeferredTimerTimer(Sender: TObject);
    procedure EditBlkCommentExecute(Sender: TObject);
    procedure EditBlkIndentExecute(Sender: TObject);
    procedure EditBlkUncommentExecute(Sender: TObject);
    procedure EditBlkUnindentExecute(Sender: TObject);
    procedure EditCopyAsHtmlExecute(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure EditCutExecute(Sender: TObject);
    procedure EditInsertAuthorExecute(Sender: TObject);
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
    procedure FileOpenLocExecute(Sender: TObject);
    procedure FileSaveAllExecute(Sender: TObject);
    procedure FileSaveAsExecute(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure HelpCheckUpdateExecute(Sender: TObject);
    procedure HelpGotoSBAForumExecute(Sender: TObject);
    procedure HelpGotoSBAWebsiteExecute(Sender: TObject);
    procedure HelpOpenHelpExecute(Sender: TObject);
    procedure HelpSettingsExecute(Sender: TObject);
    procedure LogoImageDblClick(Sender: TObject);
    procedure L_SBALabelsClick(Sender: TObject);
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
    procedure EndProcTimerTimer(Sender: TObject);
    procedure PrjTreeSelectionChanged(Sender: TObject);
    procedure ProjectAddUserFilesExecute(Sender: TObject);
    procedure ProjectCoresAddInstExecute(Sender: TObject);
    procedure ProjectCloseExecute(Sender: TObject);
    procedure ProjectEditCoreListExecute(Sender: TObject);
    procedure ProjectExportExecute(Sender: TObject);
    procedure ProjectGotoEditorExecute(Sender: TObject);
    procedure ProjectGotoPrgExecute(Sender: TObject);
    procedure ProjectItemDataSheetExecute(Sender: TObject);
    procedure ProjectNewExecute(Sender: TObject);
    procedure ProjectOpenExecute(Sender: TObject);
    procedure MainPagesChange(Sender: TObject);
    procedure ProjectOpenItemExecute(Sender: TObject);
    procedure ProjectRemCoreExecute(Sender: TObject);
    procedure ProjectRemUserFileExecute(Sender: TObject);
    procedure ProjectSaveExecute(Sender: TObject);
    procedure ProjectsHistory2Click(Sender: TObject);
    procedure ProjectUpdCoreExecute(Sender: TObject);
    procedure SBA_cancelExecute(Sender: TObject);
    procedure SBA_EditProgramExecute(Sender: TObject);
    procedure B_ObfClick(Sender: TObject);
    procedure ForceEditorPagesChange;
    procedure EditorPagesChange(Sender: TObject);
    procedure FileCloseExecute(Sender: TObject);
    procedure SBA_InsertTemplateExecute(Sender: TObject);
    procedure SBA_NewPrgExecute(Sender: TObject);
    procedure LV_SnippetsClick(Sender: TObject);
    procedure TFindDialogFind(Sender: TObject);
    procedure ToolsExporttoHtmlExecute(Sender: TObject);
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
    procedure ToolsReloadPlugInsExecute(Sender: TObject);
    procedure TReplaceDialogReplace(Sender: TObject);
    procedure UpdGuiTimerTimer(Sender: TObject);
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
    procedure EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
  private
    FPrjVisible: boolean;
    FilesMon:TFilesMon;
    procedure AddIPCoresToTree(t: TTreeNode; cl: TStrings);
    procedure AddUserFilesToTree(const t: TTreeNode; cl:TStrings);
    procedure AsyncLoadPlugIns(Data: PtrInt);
    { private declarations }
    procedure ChangeEditorButtons(var EditorF: TEditorF);
    procedure Check;
    procedure CheckStartParams;
    function CloseProg: boolean;
    function CloseEditor(i:integer): boolean;
    function CloseProject: boolean;
    procedure Colorize(ini:string);
    procedure CopyPrjHistory;
    function SelectExportHighligther(var EditorF: TEditorF): TSynCustomHighlighter;
    procedure ExporttoHtmlFile(var EditorF: TEditorF);
    procedure CopyAsHtml(var EditorF: TEditorF);
    procedure LoadPlugIns;
    function CreateTempFile(fn:string): boolean;
    procedure DetectSBAController;
    procedure ExtractSBACnfgCnst;
    procedure FormatEditors;
    function GetActiveEditorPage: TEditorF;
    function GetEditorPage(i: integer): TEditorF;
    function GetEditorFile(f: string): TEditorF;
    procedure GetFile(filename: string);
    procedure GotoEditor;
    function selectHighlighter(var EditorF: TEditorF): TEdType;
    procedure HighLightReservedWords(List:TStrings);
    function NewEditorPage:TEditorF;
    procedure Obfuscate(var EditorF:TEditorF);
    function Open(f: String): boolean;
    procedure OpenInEditor(const f: string);
    procedure OpenProject(const f:string);
    procedure OpenTreeItem(TN: TTreeNode);
    procedure PlugInCmd(Sender: TObject);
    procedure ReOpenEditorFiles;
    function EditorSaveAs(var EditorF: TEditorF): boolean;
    function  SaveFile(f:String; Src:TStrings):Boolean;
    procedure SaveOpenEditor;
    procedure SetActiveEditor;
    procedure SetPrjVisible(AValue: boolean);
    procedure SetupEditorPopupMenu;
    procedure SetupEdTmplMenu;
    procedure SetupPrgTmplMenu;
    procedure ShowHintEvent(Sender: TObject; HintInfo: PHintInfo);
    procedure SyntaxCheck(f,path: string; hdl: TEdType);
    procedure ExtractSBALabels;
    procedure LoadRsvWordsFile;
    procedure LoadAnnouncement;
    procedure FileChanged(Sender: TObject);
    function ToolProcessWaitforIdle: boolean;
//    function IsShortCut(var Message: TLMKey): Boolean; override;
  public
    { public declarations }
    function LoadTheme(thmdir: string): boolean;
    procedure UpdatePrjTree;
    procedure CheckUpdate;
    property PrjVisible:boolean read FPrjVisible write SetPrjVisible;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

uses DebugU, SBAProgContrlrU, SBAProjectU, SBAProgramU, ConfigFormU, AboutFormU, sbasnippetu, PrjWizU,
     SBAIPCoresU, DwFileU, FloatFormU, LibraryFormU, ExportPrjFormU, AutoUpdateU,
     PlugInU;

var
  SBAContrlrProg:TSBAContrlrProg;
  SBASnippet:TSBASnippet;
  AutoUpdate:TAutoUpdate;
  fOldIndex:integer = -1;
  wdir:string;
  commentstr:string='--';
  fileext:string='.vhd';
  mapfile:string='vhdl_map.dat';
  PrgReturnTab:TTabSheet=nil;
  ProcessStatus:TProcessStatus=Idle;

{ TMainForm }

function TMainForm.CloseEditor(i: integer): boolean;
var
  r:integer;
  f:string;
  EditorF:TEditorF;
begin
  Info('TMainForm.CloseEditor Start',i);
  result:=true;
  EditorF:=GetEditorPage(i);
  if assigned(EditorF.Editor) then
  begin
    // Test if editor can be closed
    if EditorF.Editor.Modified then
    begin
      EditorPages.ActivePageIndex:=i;
      ForceEditorPagesChange;
      f:=EditorF.FileName;
      r:=MessageDlg('File was modified', 'Save File? '+f, mtConfirmation, [mbYes, mbNo, mbCancel],0);
      case r of
        mrCancel: result:=false;
        mrYes: result:=SaveFile(f, EditorF.Editor.Lines);
        mrNo: result:=true;
      end;
    end;
  end;

  if result then
  begin
    UpdGuiTimer.Enabled:=false;
    FilesMon.DelFile(EditorF.FileName);
    EditorF.Close;
  end;
  ForceEditorPagesChange;
  Info('TMainForm.CloseEditor End',i);
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
    ON E:Exception do
    begin
      InfoErr('TMainForm.LoadTheme Error',E.Message);
      ShowMessage('There was an error loading theme in: '+thmdir);
      exit;
    end;
  end;
  for i:=0 to MainPanel.ControlCount-1 do if MainPanel.Controls[i].ClassNameIs('TuEButton') then
  begin
    b:=TuEButton(MainPanel.Controls[i]);
    b.LoadImageFromFile(thmdir+'btn_bg.png');
    if FileExists(thmdir+b.Name+'.png') then b.LoadGlyphFromFile(thmdir+b.Name+'.png');
  end;
  case SelTheme of
    0:Colorize(thmdir+'guicolors_light.ini');
    1:Colorize(thmdir+'guicolors_dark.ini');
    2:Colorize(thmdir+'guicolors.ini');
    else Colorize(thmdir+'guicolors.ini');
  end;
  result:=true;
end;

procedure TMainForm.LoadPlugIns;
var
  PlugIn:TPlugIn;
  i:integer;
  c:TControl;
  M:TMenuItem;

  procedure createbtn(APlugIn:TPlugIn);
  var PlugBtn:TuEButton;
  begin
    if APlugIn.ButtonGlyph.IsEmpty then exit;
    PlugBtn:=TuEButton.Create(MainForm);
    PlugBtn.Parent:=MainPanel;
    PlugBtn.Tag:=1000;
    PlugBtn.Constraints.MinHeight:=btn_new_project.Constraints.MinHeight;
    PlugBtn.Constraints.MinWidth:=btn_new_project.Constraints.MinWidth;
    PlugBtn.TextShadowColor:=btn_new_project.TextShadowColor;
    PlugBtn.Layout:=blGlyphTop;
    PLugBtn.ParentColor:=false;
    PLugBtn.Color:=btn_new_project.Color;
    PlugBtn.Caption:=APlugIn.ButtonCaption;
    PlugBtn.LoadImageFromFile(ThemeDir+'btn_bg.png');
    PlugBtn.LoadGlyphFromFile(APlugIn.Path+APlugIn.ButtonGlyph);
    PlugBtn.OnClick:=@APlugIn.OnClick;
  end;

begin
  PlugInsMenu.Clear;
  for i:=MainPanel.ControlCount-1 downto 0 do
  begin
    c:=MainPanel.Controls[i];
    if c.Tag=1000 then
    begin
      MainPanel.RemoveControl(c);
      c.Free;
    end;
  end;
  GetPlugInList;
  PlugInsMenu.Visible:=(PlugInsList.Count<>0);
  if PlugInsList.Count=0 then exit;
  for PlugIn in PlugInsList do if PlugIn.Enabled then
  begin
    PlugIn.PlugInCmd:=@PlugInCmd;
    createbtn(PlugIn);
    PlugIn.CreateMenuItem(PlugInsMenu);
  end;
  PlugInsMenu.AddSeparator;
  M:=TMenuItem.Create(PlugInsMenu);
  M.Action:=ToolsReloadPlugins;
  PlugInsMenu.Add(M);
end;

function TMainForm.CreateTempFile(fn: string): boolean;
var
  f: TStringList;
begin
  result:=true;
  f:=TStringList.Create;
  f.Assign(ActEditorF.Editor.Lines);
  try
    f.SaveToFile(fn);
  finally
    FreeAndNil(f);
    if not fileexists(fn) then
    begin
      ShowMessage('Temporal file: '+wdir+'source_file'+fileext+' not could be '
        +'created.');
      result:=false;
    end;
  end;
end;

procedure TMainForm.ForceEditorPagesChange;
begin
  Info('TMainForm.ForceEditorPagesChange called by',BackTraceStrFunc(Get_caller_Addr(get_frame)));
  SetActiveEditor;
end;

procedure TMainForm.EditorPagesChange(Sender: TObject);
begin
  Info('TMainForm.EditorPagesChange','Called');
  SetActiveEditor;
end;

procedure TMainForm.SetActiveEditor;
var
  NewActiveF:TEditorF;
begin
  NewActiveF:=GetActiveEditorPage;
  StatusBar1.Panels[1].Text:=NewActiveF.FileName;
  If NewActiveF.Editor=ActEditorF.Editor then
    exit
  else
    ActEditorF:=NewActiveF;
  Info('TMainForm.SetActiveEditor FileName',ActEditorF.FileName);
  If assigned(ActEditorF.Editor) then
  try
    SyncroEdit.Enabled:=false;
    SyncroEdit.Editor:=ActEditorF.Editor;
    SyncroEdit.Enabled:=true;
    SynCompletion.Editor:=ActEditorF.Editor;
    SynMultiCaret.Editor:=ActEditorF.Editor;
    wdir:=extractfilepath(NewActiveF.FileName);
    if wdir='' then wdir:=IFTHEN(SBAPrj.name<>'',SBAPrj.location,ProjectsDir);
    if ToolsFileObf.Checked then ToolsFileObfExecute(Self);
    UpdGuiTimer.Enabled:=true;
  except
    ON E:Exception do InfoErr('TMainForm.SetActiveEditor Error',E.Message);
  end;
end;

procedure TMainForm.B_ObfClick(Sender: TObject);
var
  i:integer;
  s:string;
  sl,om:TStringList;
  f:boolean;
begin
  if mapfile='' then
  begin
    ShowMessage('There is not Mapfile for this kind of file');
    exit;
  end;
  s:=ActEditorF.FileName;
  Info('TMainForm.B_ObfClick',s);
  if ActEditorF.Editor.Modified then
  case MessageDlg('File must be saved', 'Save File? '+s, mtConfirmation, [mbYes, mbNo],0) of
    mrYes: if not SaveFile(s,ActEditorF.Editor.Lines) then exit;
  else exit;
  end;
  ActEditorF.Editor.Modified:=false;
  ToolsFileObf.Enabled:=false;
  if not fileexists(wdir+mapfile) then copyfile(AppDir+mapfile,wdir+mapfile);
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
  Obfuscate(ActEditorF);
  ToolsFileObf.Enabled:=true;
end;

procedure TMainForm.SBA_EditProgramExecute(Sender: TObject);
begin
  SynEdit_X.BeginUpdate(false);
  SynEdit_X.ClearUndo;
  if SBAContrlrProg.CpySrc2Prog(ActEditorF.Editor.Lines,SynEdit_X.Lines) then
  begin
    SBAContrlrProg.FileName:=IFTHEN(SBAprj.name='',cSBADefaultPrgName,SBAprj.location+SBAprj.name+'.prg');
    PrgReturnTab:=EditorsTab;
    SBA_ReturnToEditor.Enabled:=true;
    MainPages.ActivePage:=ProgEditTab;
    MainPagesChange(Sender);
    ExtractSBALabels;
    ExtractSBACnfgCnst;
  end else ShowMessage('Format error in controller, please verify "/SBA:" block signatures.');
  SynEdit_X.EndUpdate;
  SynEdit_X.Modified:=true;
end;

procedure TMainForm.B_SBALabelsClick(Sender: TObject);
begin
  ExtractSBALabels;
end;

procedure TMainForm.DeferredTimerTimer(Sender: TObject);
begin
  DeferredTimer.Enabled:=false;
  StatusBar1.Panels[1].Text:='Checking for secure internet connection...';
  if IsNetworkEnabled then
  begin
    GetFile('newbanner.gif');
    CheckUpdate;
  end else
  begin
    {$IFDEF WINDOWS}
    ShowMessage('The application does not have a secure active internet connection, some features could be disabled');
    StatusBar1.Panels[1].Text:='No secure internet connection detected';
    {$ELSE}
    ShowMessage('There is not a secure active internet connection or the SSL libraries (libssl-dev) are not installed, some features could be disabled');
    StatusBar1.Panels[1].Text:='No secure internet connection detected or the SSL libraries are not installed';
    {$ENDIF}
  end;
end;

procedure TMainForm.EditBlkCommentExecute(Sender: TObject);
Var
  C:TPoint;
  L:integer;
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
  With ActEditorF.Editor do
  begin
    ActEditorF.Editor.BeginUpdate(true);
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
    ActEditorF.Editor.EndUpdate;
  end;
end;

procedure TMainForm.EditBlkIndentExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.ExecuteCommand(ecBlockIndent,'',nil);
end;

procedure TMainForm.EditBlkUncommentExecute(Sender: TObject);
Var
  C:TPoint;
  L:Integer;
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
  With ActEditorF.Editor do
  begin
    ActEditorF.Editor.BeginUpdate(true);
    C:=CaretXY;
    if SelAvail then
    begin
      for L:=BlockBegin.y to BlockEnd.y do
      begin
       CaretY:=L;
       if (Pos(commentstr,ActEditorF.Editor.LineText)=1) then
       begin
         CaretX:=length(commentstr)+1;
         ExecuteCommand(ecDeleteBOL,'',nil);
       end;
      end;
      CaretY:=C.Y;
    end else if (Pos(commentstr,ActEditorF.Editor.LineText)=1) then
    begin
      CaretX:=length(commentstr)+1;
      ExecuteCommand(ecDeleteBOL,'',nil);
    end;
    CaretX:=C.X-length(commentstr);
    ActEditorF.Editor.EndUpdate;
  end;
end;

procedure TMainForm.EditBlkUnindentExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.ExecuteCommand(ecBlockUnindent,'',nil);
end;

procedure TMainForm.EditCopyAsHtmlExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) then CopyAsHtml(ActEditorF)
  else Info('TMainForm.ToolsExporttoHtmlExecute','Do not exists a default editor');
end;

procedure TMainForm.B_InsertSnippedClick(Sender: TObject);
var
  success:boolean;

  function InsertSnp:boolean;
  var EditorF:TEditorF;
  begin
    EditorF.Editor:=ActEditorF.Editor;
    if not EditorF.InsertBlock(cSBAStartUserProg,cSBAEndUserProg,SBASnippet.code) then exit(false);
    if not EditorF.InsertBlock(cSBAStartProgUReg,cSBAEndProgUReg,SBASnippet.registers) then exit(false);
    if not EditorF.InsertBlock(cSBAStartUSignals,cSBAEndUSignals,SBASnippet.USignals) then exit(false);
    if not EditorF.InsertBlock(cSBAStartUProc,cSBAEndUProc,SBASnippet.UProc) then exit(false);
    if not EditorF.InsertBlock(cSBAStartUStatements,cSBAEndUStatements,SBASnippet.UStatements) then exit(false);
    exit(true);
  end;

begin
  if ActEditorF.Editor=nil then exit;
  success:=true;
  try
    ActEditorF.Editor.BeginUpdate(true);
    ActEditorF.Editor.BeginUndoBlock;
    ActEditorF.Editor.CaretX:=0;
    success:=InsertSnp;
    ActEditorF.Editor.EndUndoBlock;
  finally
    If success then ExtractSBALabels else ActEditorF.Editor.Undo;
    ActEditorF.Editor.EndUpdate;
  end;
  ActEditorF.Editor.SetFocus;
end;

procedure TMainForm.btn_sba_libraryClick(Sender: TObject);
begin
  ShowLibraryForm;
  SBASnippet.UpdateSnippetsFilter(SnippetsFilter);
end;


procedure TMainForm.PlugInCmd(Sender: TObject);
var
  PlugIn:TPlugIn;
begin
  PlugIn:=TPlugIn(Sender);
  if (not assigned(PlugIn)) or (PlugIn.ClassName<>'TPlugIn') then exit;
  with PlugIn do
  begin
    if not ToolProcessWaitforIdle then
    begin
      ShowMessage('There was an error when executing external plugin');
      exit;
    end;
    ToolProcess.CurrentDirectory:=Path;
    ToolProcess.Executable:=Path+Cmd;
    ToolProcess.Parameters.Delimiter:=' ';
    ToolProcess.Parameters.DelimitedText:=ParseParameters;
    Info('TMainForm.PlugInCmd',ToolProcess.Executable);
    Info('TMainForm.PlugInCmd Parameters',ToolProcess.Parameters);
    try
      ProcessStatus:=exePlugIn;
      EndProcTimer.Enabled:=true;
      ToolProcess.Execute
    except
      ON E:exception do
      begin
        ProcessStatus:=Idle;
        InfoErr('TMainForm.PlugInCmd Error:',E.Message);
        ShowMessage('There was an error when executing: '+Path+Cmd);
      end;
    end;
  end;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  MainPages.ActivePage:=SystemTab;
  MainPagesChange(Sender);
end;

procedure TMainForm.ATTabs1TabPlusClick(Sender: TObject);
begin
  ATTabs1.AddTab(0,'Prueba');
end;

procedure TMainForm.B_SBAAdressClick(Sender: TObject);
begin
  if SBAPrj.name<>'' then ExtractSBACnfgCnst else ShowMessage('There is no an open project');
end;

procedure TMainForm.ExtractSBACnfgCnst;
var
  sl:TStringList;
  f,s:string;
  i:integer;
begin
  if SBAPrj.name<>'' then
  try
    L_SBAAddress.Items.Clear;
    sl:=TStringList.Create;
    f:=SBAPrj.location+SBAPrj.name+'_'+cSBAcfg;
    if (EditorPages.PageCount>0) then
      for i:=0 to EditorPages.PageCount-1 do if EditorPages.Pages[i].Hint=f then
      begin
        sl.Text:=SBAPrj.GetConfigConst(TSynEdit(MainForm.FindComponent('SynEdit_'+inttostr(EditorPages.Pages[i].Tag))).lines);
        for s in sl do L_SBAAddress.Items.Add.Caption:=s;
        exit;
      end;
    sl.LoadFromFile(f);
    sl.Text:=SBAPrj.GetConfigConst(sl);
    for s in sl do L_SBAAddress.Items.Add.Caption:=s;
  finally
    if assigned(sl) then freeandnil(sl);
  end;
end;

procedure TMainForm.EditCopyExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.CopyToClipboard;
end;

procedure TMainForm.EditCutExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.CutToClipboard;
end;

procedure TMainForm.EditInsertAuthorExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.InsertTextAtCaret(DefAuthor);
end;

procedure TMainForm.EditInsertDateExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.InsertTextAtCaret(FormatDateTime('yyyy/mm/dd',date));
end;

procedure TMainForm.EditInsertTemplateExecute(Sender: TObject);
var
  Ini:TIniFile;
  SL:TStringList;
  j,n:integer;
begin
  Info('TMainForm.EditInsertTemplateExecute','Menu: '+TMenuItem(Sender).Caption);
  if (Sender.ClassName='TMenuItem') and assigned(ActEditorF.Editor) then
  begin
    ActEditorF.Editor.CaretX:=0;
    try
      SL:=TStringList.Create;
      SL.Clear;
      Ini:=TInifile.Create(ConfigDir+'templates.ini',[ifoStripQuotes]);
      j:=Ini.ReadInteger(TMenuItem(Sender).Caption,'Lines',0);
      for n:=0 to j-1 do SL.Add(Ini.ReadString(TMenuItem(Sender).Caption,'L'+inttostr(n),''));
      if SL.Count>0 then ActEditorF.Editor.InsertTextAtCaret(SL.Text);
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
  if I>=0 then
  begin
    EditorPages.ActivePageIndex:=I;
    ForceEditorPagesChange;
    EdTabMenu.PopUp;
  end;
end;

procedure TMainForm.EditPasteExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.PasteFromClipboard;
end;

procedure TMainForm.EditRedoExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.Redo;
end;

procedure TMainForm.EditSelectAllExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.SelectAll;
end;

procedure TMainForm.EditUndoExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) and ActEditorF.Editor.Focused then
    ActEditorF.Editor.Undo;
end;

procedure TMainForm.FileOpenLocExecute(Sender: TObject);
var
  EditorF:TEditorF;
  d:string;
begin
  EditorF:=GetActiveEditorPage;
  d:=ExtractFilePath(EditorF.FileName);
  Info('TMainForm.FileOpenLocExecute','Try to open folder : '+d);
  if DirectoryExists(d) then OpenDocument(d);
end;

function TMainForm.SaveFile(f:String; Src:TStrings):Boolean;
begin
  FilesMon.Enabled:=false;
  try
    if FileExists(f) then
      RenameFile(f,f+IfThen(BakTimeStamp,FormatDateTime('"."yyyymmdd"-"hhnnsszzz".bak"',now),'.bak'));
    Src.SaveToFile(f);
  except
    ON E:Exception do
    begin
      InfoErr('TMainForm.SaveFile Error',E.Message);
      showmessage('Can not write '+f);
      FilesMon.Enabled:=EnableFilesMon;
      exit(false);
    end;
  end;
  FilesMon.UpdateFile(f);
  FilesMon.Enabled:=EnableFilesMon;
  result:=true;
end;

function TMainForm.EditorSaveAs(var EditorF:TEditorF):boolean;
begin
  result:=false;
  SaveDialog.FileName:=EditorF.FileName;
  SaveDialog.InitialDir:=ExtractFilePath(EditorF.FileName);
  SaveDialog.DefaultExt:=fileext;
  SaveDialog.Filter:=FileTypeStr;
  if SaveDialog.Execute and SaveFile(SaveDialog.FileName, EditorF.Editor.Lines) then
  begin
    FilesMon.DelFile(EditorF.FileName);
    EditorF.FileName:=SaveDialog.FileName;
    EditorF.Editor.Modified:=false;
    selectHighlighter(EditorF);
    FilesMon.AddFile(SaveDialog.FileName);
    result:=true;
  end;
end;

procedure TMainForm.FileSaveAllExecute(Sender: TObject);
var
  EditorF:TEditorF;
  i:integer;
begin
  if EditorPages.PageCount>0 then For i:=0 to EditorPages.PageCount-1 do
  begin
    EditorF:=GetEditorPage(i);
    if EditorF.Editor.Modified then
      If Pos('NewFile',EditorF.FileName)=0 then
      begin
        SaveFile(EditorF.FileName, EditorF.Editor.Lines);
        EditorF.Editor.Modified:=false;
        EditorF.Page.Caption:=ExtractFileName(EditorF.FileName);
      end else EditorSaveAs(EditorF);
  end;
end;

procedure TMainForm.FileSaveExecute(Sender: TObject);
var EditorF:TEditorF;
begin
  If EditorPages.PageCount>0 then
  begin
    EditorF:=GetActiveEditorPage;
    If Pos('NewFile',EditorF.FileName)=0 then
    begin
      SaveFile(EditorF.FileName, EditorF.Editor.Lines);
      EditorF.Editor.Modified:=false;
      UpdGuiTimer.Enabled:=true;
    end else FileSaveAsExecute(Sender);
  end;
end;

procedure TMainForm.FileSaveAsExecute(Sender: TObject);
begin
  If EditorPages.PageCount>0 then
  begin
    ActEditorF:=GetActiveEditorPage;
    if EditorSaveAs(ActEditorF) then
    begin
     StatusBar1.Panels[1].Text:=SaveDialog.FileName;
     UpdGuiTimer.Enabled:=true;
    end;
  end;
end;

procedure TMainForm.CheckUpdate;
var
  wn:TStringList;
  s:string;
  p:integer;
begin
  StatusBar1.Panels[1].Text:='Online check for updates...';
  s:='';
  If AutoUpdate.NewVersionAvailable Then
  begin
    StatusBar1.Panels[1].Text:='A new version is available, getting what is new file.';
    if AutoUpdate.GetWhatsNew then
    try
      info('TMainForm.CheckUpdate','What is new file was downloaded.');
      wn:=TStringList.Create;
      wn.LoadFromFile(ConfigDir+WhatsNewFile);
      p:=Pos('Old Releases',wn.text);
      s:=IFTHEN(p>1,Copy(wn.text,1,p-1),wn.text);
      info('TMainForm.CheckUpdate',wn);
    finally
      if assigned(wn) then FreeAndNil(wn);
    end;
    if MessageDlg(Application.Title, Format('A new version %s is available.  Would you like to download it?'#10'%s',[AutoUpdate.GetNewVersion,s]), mtConfirmation, [mbYes, mbNo], 0, mbYes) = mryes then
    begin
      StatusBar1.Panels[1].Text:='Downloading a new version of SBA Creator';
      if AutoUpdate.DownloadNewVersion Then
      begin
        If MessageDlg(Application.Title, 'Download Succeeded.  Click OK to update',
          mtInformation, [mbOK], 0) = mrOK Then
            If AutoUpdate.UpdateToNewVersion then StatusBar1.Panels[1].Text:='SBA Creator updated, restarting now...'
            else ShowMessage('There was an error when try to updating SBA Creator');
      end Else ShowMessage('Sorry, download of new version failed');
    end else StatusBar1.Panels[1].Text:='';
  end else StatusBar1.Panels[1].Text:='A new version is not available or not detected.';
  info('TMainForm.CheckUpdate','End of search for new version');
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  LogoImage.Visible:=Self.Width>575;
end;

procedure TMainForm.HelpCheckUpdateExecute(Sender: TObject);
begin
  MainForm.CheckUpdate;
end;

procedure TMainForm.HelpGotoSBAForumExecute(Sender: TObject);
begin
  OpenURL('http://sbaforum.accesus.com/');
end;

procedure TMainForm.HelpGotoSBAWebsiteExecute(Sender: TObject);
begin
  OpenUrl('http://sba.accesus.com');
end;

procedure TMainForm.HelpOpenHelpExecute(Sender: TObject);
begin
  OpenURL('file://'+ConfigDir+'doc'+PathDelim+'help.html');
end;

procedure TMainForm.HelpSettingsExecute(Sender: TObject);
begin
  if ConfigForm.ShowModal=mrOk then
  begin
    SetConfigValues(IniStor);
    FilesMon.Enabled:=EnableFilesMon;
    LoadPlugIns;
    FormatEditors;
  end;
end;

procedure TMainForm.FormatEditors;
var
  i:integer;
  EditorF:TEditorF;
begin
  SynEdit_X.Font.Name:=EditorFontName;
  SynEdit_X.Font.Size:=EditorFontSize;
  if EditorPages.PageCount>0 then For i:=0 to EditorPages.PageCount-1 do
  begin
    EditorF:=GetEditorPage(i);
    EditorF.Editor.Font.Name:=EditorFontName;
    EditorF.Editor.Font.Size:=EditorFontSize;
  end;
end;

procedure TMainForm.LogoImageDblClick(Sender: TObject);
begin
  {$IFDEF DEBUG}
  MainPages.ActivePage:=HiddenPage;
  MainPagesChange(Sender);
  ActEditorF.Editor:=SynEdit_Test;
  ActEditorF.Page:=nil;
  {$ENDIF}
end;

procedure TMainForm.L_SBALabelsClick(Sender: TObject);
var
  Item:TListItem;
  s:string;
begin
  Item:=TListView(Sender).Selected;
  if Item=nil then exit;
  s:=Item.Caption;
  Info('TMainForm.ListSelectItem',s);
  if ActEditorF.EdType in [vhdl,ini,prg,other] then ActEditorF.Editor.SetHighlightSearch(S,[ssoSelectedOnly,ssoWholeWord])
    else ActEditorF.Editor.SetHighlightSearch(S,[ssoMatchCase,ssoSelectedOnly,ssoWholeWord]);
end;

procedure TMainForm.L_SBALabelsDblClick(Sender: TObject);
var
  Item:TListItem;
begin
  Item:=TListView(Sender).Selected;
  If Item=nil then exit;
  ActEditorF.Editor.SearchReplace(cSBALblSignatr+Item.Caption, '', [ssoEntireScope,ssoWholeWord])
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
  // if the project is already open CheckUpdate the PrjTree, if not, close current
  // project and open the selected one
  if CompareText(Filename,(SBAPrj.location+SBAPrj.name+cSBAPrjExt))=0 then
  begin
    UpdatePrjTree;
    PrjVisible:=true;
    exit;
  end;
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
    ON E:Exception do
    begin
      InfoErr('TMainForm.PrjTreeClick Error',E.Message);
      CoreImage.Picture.Clear;
    end;
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
  MI_OpenDataSheet.Visible:=False;
  MI_UpdCore.Visible:=false;
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
    MI_OpenDataSheet.Visible:=True;
    //MI_UpdCore.Visible:=true;
    //MI_RemCore.Visible:=true;
    MI_AddInstance.Visible:=true;
  end;
end;

procedure TMainForm.PrjTreeDblClick(Sender: TObject);
var
  TN:TTreeNode;
begin
  TN:=PrjTree.Selected;
  OpenTreeItem(TN);
end;

procedure TMainForm.OpenTreeItem(TN:TTreeNode);
var
  S,P:String;
begin
  if TN.Parent=nil then exit;
  S:=TN.GetParentNodeOfAbsoluteLevel(0).Text;
  if S=SBAPrj.name then P:=SBAPrj.location+SBAPrj.name+'_'+TN.Text+'.vhd'
  else case S of
  'Aux' :P:=SBAPrj.loclib+TN.Text+'.vhd';
  'Lib' :P:=SBAPrj.loclib+TN.Text+'.vhd';
  'User':P:=SBAPrj.GetUserFilePath(TN.Text)+TN.Text;
  else P:='';
  end;
  OpenInEditor(P);
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
  TN := PrjTree.GetNodeAt(X, Y);
  HitTestInfo := PrjTree.GetHitTestInfoAt(X, Y) ;
  if (htOnItem in HitTestInfo) and (TN<>nil) and
     (TN.Parent<>nil) and (TN.GetParentNodeOfAbsoluteLevel(0).text='Lib') then
  begin
    P:=Mouse.CursorPos;
    FloatForm.Top:=P.Y+20;
    FloatForm.Left:=P.X+10;
    FloatForm.ShowCoreInfo(TN.Text);
  end else begin
    FloatForm.L_CoreName.caption:='';
    FloatForm.hide;
  end;
end;

procedure TMainForm.EndProcTimerTimer(Sender: TObject);
var PStr:String;
begin
  { TODO : WorkAround En Linux el método OnTerminate no es ejecutado por lo cual se incluye la condición Running para saber si continúa la ejecución del proceso. }
  //Si se corrije el comportamiento en Linux, se puede prescindir de la evaluación a Running
  if (not ToolProcess.Running) and (ProcessStatus<>Idle) then
  begin
    {IFDEF Debug}
      WriteStr(PStr,ProcessStatus);
      Info('TMainForm.EndProcTimerTimer','ProcessStatus is '+PStr);
    {ENDIF}
    ToolProcessTerminate(nil);
  end;
end;

procedure TMainForm.PrjTreeSelectionChanged(Sender: TObject);
begin
  PrjTreeClick(Sender);
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
  IP,IPS,STL,AML,DCL,MXL:TStringList;
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
    MXL:=TStringList.Create;
    iname:=TN.Text+'_'+inttostr(random(99));
    if InputQuery ('Add IP Core instance', 'Please type the name of the new instance:',iname) then
    try
      SBAIpCore.FormatData(TN.Text,iname,IP,IPS,STL,AML,DCL,MXL,0);
      ActEditorF.Editor.CaretX:=0;
      ActEditorF.Editor.InsertTextAtCaret(IP.Text);
    except
      ON E:Exception do
      begin
        ShowMessage(E.Message);
        InfoErr('TMainForm.ProjectCoresAddInstExecute',E.Message);
      end;
    end;
  finally
    if assigned(MXL) then FreeAndNil(MXL);
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
begin
  Info('TMainForm','Start CloseProject');
  result:=false;
  while (EditorPages.PageCount>0) do
    If not CloseEditor(EditorPages.ActivePageIndex) then exit(false);
  If SBAPrj.Close then
  begin
    MainPages.ActivePage:=SystemTab;
    MainPagesChange(nil);
    result:=true;
  end;
  Info('TMainForm','End CloseProject');
end;

procedure TMainForm.ProjectExportExecute(Sender: TObject);
Var
  exportpath:string;
  IniFile:TIniFile;
begin
  { TODO : Grabar también archivos de proyecto antes de exportar }
  If SBAPrj.Modified and (MessageDlg('The Project was modified', 'Save Project and its files? ', mtConfirmation, [mbYes, mbNo],0)=mrYes) then
    ProjectSaveExecute(Sender);
  try
    IniFile:=TIniFile.Create(LocSBAPrjParams);
    exportpath:=IniFile.ReadString('PrjExportPaths',SBAPrj.name,'');
  except
    ON E:Exception do InfoErr('TMainForm.ProjectExportExecute Error',E.Message);
  end;
  ExportPrjForm.L_PrjDir.Caption:='Project folder: '+SBAPrj.location;
  ExportPrjForm.Ed_TargetDir.Directory:=exportpath;
  ExportPrjForm.CB_ExpPrjMonolithic.Checked:=SBAPrj.expmonolithic;
  ExportPrjForm.CB_ExpPrjAllLib.Checked:=SBAPrj.explibfiles;
  ExportPrjForm.CB_ExpPrjUser.Checked:=SBAPrj.expuserfiles;
  if ExportPrjForm.Showmodal=mrOk then with ExportPrjForm, SBAPrj do
  begin
    exportpath:=AppendPathDelim(TrimFilename(Ed_TargetDir.Text));
    If assigned(IniFile) then
    begin
      IniFile.WriteString('PrjExportPaths',SBAPrj.name,exportpath);
      FreeAndNil(IniFile);
    end;
    expmonolithic:=CB_ExpPrjMonolithic.Checked;
    explibfiles:=CB_ExpPrjAllLib.Checked;
    expuserfiles:=CB_ExpPrjUser.Checked;
    If SBAPrj.PrjExport(exportpath) then StatusBar1.Panels[1].Text:='Project was export to: '+exportpath;
  end;
end;

procedure TMainForm.ProjectGotoEditorExecute(Sender: TObject);
begin
  PrjVisible:=false;
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
  MainPagesChange(nil);
end;

procedure TMainForm.ProjectGotoPrgExecute(Sender: TObject);
var tmp:TStringList;
begin
  PrgReturnTab:=SystemTab;
  SBA_ReturnToEditor.Enabled:=false;
  MainPages.ActivePage:=ProgEditTab;
  MainPagesChange(Sender);  // es automático sólo si el usuario hace clik en las pestañas
  if ActEditorF.EditorEmpty then
  begin
    SBAContrlrProg.Filename:=cSBADefaultPrgName;
    StatusBar1.Panels[1].Text:=cSBADefaultPrgName;
    ActEditorF.FileName:=cSBADefaultPrgName;
    selectHighlighter(ActEditorF);
    try
     tmp:=tstringlist.Create;
     try
       tmp.LoadFromFile(ConfigDir+IFTHEN(CtrlAdvMode,cSBAAdvPrgTemplate,cSBADefPrgTemplate));
       ActEditorF.Editor.Lines.Assign(tmp);
     except
       On E:Exception do ShowMessage(E.Message);
     end;
    finally
     if assigned(tmp) then freeandnil(tmp);
    end;
  end;
  { TODO : Genera Error cuando se carga un prg o un snp mediante el comando Open de windows }
//  if assigned(ActEditorF.Editor) then ActEditorF.Editor.SetFocus;
  ExtractSBALabels;
end;

procedure TMainForm.ProjectItemDataSheetExecute(Sender: TObject);
var
  TN:TTreeNode;
  dsname,f:string;
  Ini:TIniFile;
begin
  TN:=PrjTree.Selected;
  if (TN<>nil) and (TN.Parent<>nil) and (TN.GetParentNodeOfAbsoluteLevel(0).Text='Lib') then
  begin
    f:=LibraryDir+TN.Text+PathDelim;
    Ini:=TIniFile.Create(f+TN.Text+'.ini');
    try
      dsname:=f+Ini.ReadString('MAIN','DataSheet','readme.md');
      LibraryForm.OpenDataSheet(dsname);
    finally
      Ini.free;
    end;
  end else ShowMessage('Please select an IP core first');
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
  s:string;
begin
  if not SBAPrj.Open(f) then exit;
  UpdatePrjTree;
  PrjHistory.UpdateList(f);
  CopyPrjHistory;
  PrjVisible:=true;
  If MainPages.ActivePage=SystemTab then GotoEditor;
  S:=SBAPrj.location+SBAPrj.name+'_'+cSBATop;
  OpenInEditor(S);
  if AutoOpenPrjF then
  begin
    S:=SBAPrj.location+SBAPrj.name+'_'+cSBAcfg;
    OpenInEditor(S);
    case SBAPrj.SBAver of
      0:S:=SBAPrj.location+SBAPrj.name+'_'+cSBAdcdr;
      1:S:=SBAPrj.location+SBAPrj.name+'_'+cSBAmux;
    end;
    OpenInEditor(S);
    S:=SBAPrj.location+SBAPrj.name+'_'+cSBActrlr;
    OpenInEditor(S);
  end;
  Log.clear;
  ForceEditorPagesChange;
end;

procedure TMainForm.MainPagesChange(Sender: TObject);
begin
  Info('TMainForm.MainPagesChange',MainPages.ActivePage.Caption);
  If MainPages.ActivePage=EditorsTab then
  begin
    MainForm.Menu := EditorMenu;
    //ForceEditorPagesChange(Self); //Avoid double call
  end else if MainPages.ActivePage=ProgEditTab then
  begin
    MainForm.Menu := ProgMenu;
    ActEditorF.Editor:=SynEdit_X;
    ActEditorF.Page:=nil;
    ActEditorF.FileName:=SBAContrlrProg.FileName;
    ActEditorF.Edtypeselect;
    selectHighlighter(ActEditorF);
    SyncroEdit.Enabled:=false;
    SyncroEdit.Editor:=ActEditorF.Editor;
    SyncroEdit.Enabled:=true;
    SynCompletion.Editor:=ActEditorF.Editor;
    SynMultiCaret.Editor:=ActEditorF.Editor;
  end else if MainPages.ActivePage=SystemTab then
  begin
    MainForm.Menu := MainMenu;
    StatusBar1.Panels[0].Text:='';
    StatusBar1.Panels[1].Text:='';
    Log.Clear;
  end else if MainPages.ActivePage=HiddenPage then
  begin
    MainForm.Menu := EditorMenu;
    ActEditorF.Editor:=SynEdit_Test;
    ActEditorF.Page:=nil;
    ActEditorF.FileName:='test.vhd';
    selectHighlighter(ActEditorF);
    SyncroEdit.Enabled:=false;
    SyncroEdit.Editor:=ActEditorF.Editor;
    SyncroEdit.Enabled:=true;
    SynCompletion.Editor:=ActEditorF.Editor;
    SynMultiCaret.Editor:=ActEditorF.Editor;
  end else MainForm.Menu := nil;
end;

procedure TMainForm.ProjectOpenItemExecute(Sender: TObject);
var
  TN:TTreeNode;
begin
  TN:=PrjTree.Selected;
  if (TN<>nil) then OpenTreeItem(TN);
end;

procedure TMainForm.ProjectRemCoreExecute(Sender: TObject);
var
  TN:TTreeNode;
begin
  TN:=PrjTree.Selected;
  if (TN<>nil) and (TN.Parent<>nil) and (TN.GetParentNodeOfAbsoluteLevel(0).Text='Lib') then
    if SBAPrj.RemoveCore(TN.Text) then  UpdatePrjTree;
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

function TMainForm.GetEditorPage(i:integer):TEditorF;
var
  EditorF:TEditorF;
begin
  Info('TMainForm.GetEditorPage index',i);
  if i=-1 then
  begin
    EditorF.Editor:=nil;
    EditorF.Page:=nil;
    EditorF.FileName:='';
  end else
  try
    EditorF.Editor:=TSynEdit(MainForm.FindComponent('SynEdit_'+inttostr(EditorPages.Pages[i].Tag)));
    EditorF.Page:=EditorPages.Pages[i];
    EditorF.FileName:=EditorPages.Pages[i].Hint;
  except
    ON E:Exception do InfoErr('TMainForm.GetEditorPage Error',E.Message);
  end;
  Result:=EditorF;
end;

function TMainForm.GetEditorFile(f: string): TEditorF;
var
  EditorF:TEditorF;
  t:TTabSheet;
  i:integer;
begin
  Info('TMainForm.GetEditorFile',f);
  EditorF.Editor:=nil;
  EditorF.Page:=nil;
  EditorF.FileName:='';
  if f<>'' then For i:=0 to EditorPages.PageCount-1 do
    if (EditorPages.Pages[i].Hint=f) then
    begin
      EditorF:=GetEditorPage(i);
      Break;
    end;
  Result:=EditorF;
end;

function TMainForm.GetActiveEditorPage:TEditorF;
begin
  Result:=GetEditorPage(EditorPages.ActivePageIndex);
end;

procedure TMainForm.ProjectSaveExecute(Sender: TObject);
begin
  FileSaveAllExecute(Sender);
  SBAPrj.Save;
end;

procedure TMainForm.ProjectsHistory2Click(Sender: TObject);
Var FileName:String;
begin
  FileName:=PrjHistory.GetItemValue(TMenuItem(Sender).MenuIndex);
  if CompareText(Filename,(SBAPrj.location+SBAPrj.name+cSBAPrjExt))=0 then exit;
  if CloseProject then OpenProject(Filename);
end;

procedure TMainForm.ProjectUpdCoreExecute(Sender: TObject);
var
  TN:TTreeNode;
begin
  TN:=PrjTree.Selected;
  if (TN<>nil) and (TN.Parent<>nil) and (TN.GetParentNodeOfAbsoluteLevel(0).Text='Lib') then
      SBAPrj.UpdateCore(TN.Text);
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
    MainPagesChange(Sender);
    ForceEditorPagesChange;
    SynEdit_X.ClearAll;
    SynEdit_X.Modified:=false;
  end;
end;

procedure TMainForm.FileCloseExecute(Sender: TObject);
begin
  Info('TMainForm.FileCloseExecute Start',EditorPages.ActivePageIndex);
  CloseEditor(EditorPages.ActivePageIndex);
  If EditorPages.PageCount=0 then
  begin
    if not Prjvisible then
    begin
      MainPages.ActivePage:=SystemTab;
      MainPagesChange(Sender);
    end else
    begin
      EditorCnt:=1;
      NewEditorPage;
    end;
  end;
  Info('TMainForm.FileCloseExecute','End');
end;

procedure TMainForm.SBA_InsertTemplateExecute(Sender: TObject);
var
  S:String;
begin
  if Sender.ClassName='TMenuItem' then
  begin
    ActEditorF.Editor.CaretX:=0;
    S:=TMenuItem(Sender).Caption;
    If Pos('/SBA',S)<>0 then S:=S+' '+StringOfChar('-',79-length(S))+sLineBreak;
    ActEditorF.Editor.InsertTextAtCaret(S);
  end;
end;

procedure TMainForm.SBA_NewPrgExecute(Sender: TObject);
var
  tmp:TstringList;
begin
  if ActEditorF.Editor.Modified then
  case MessageDlg('File was modified', 'Save File? ', mtConfirmation, [mbYes, mbNo, mbCancel],0) of
    mrCancel: exit;
    mrYes: SBA_SaveExecute(nil);
  end;
  SBAContrlrProg.Filename:=cSBADefaultPrgName;
  StatusBar1.Panels[1].Text:=cSBADefaultPrgName;
  ActEditorF.Editor.Modified:=false;
  ActEditorF.FileName:=SBAContrlrProg.Filename;
  ActEditorF.Page:=nil;
  selectHighlighter(ActEditorF);
  tmp:=tstringlist.Create;
  tmp.LoadFromFile(ConfigDir+IFTHEN(CtrlAdvMode,cSBAAdvPrgTemplate,cSBADefPrgTemplate));
  ActEditorF.Editor.Lines.Assign(tmp);
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
{ TODO : No funciona Ctrl-X,C,V }
  Dialog:=TFindDialog(Sender);
  buscado := Dialog.FindText;
  opciones := [];
  if not(frDown in Dialog.Options) then opciones += [ssoBackwards];
  if frMatchCase in Dialog.Options then opciones += [ssoMatchCase];
  if frWholeWord in Dialog.Options then opciones += [ssoWholeWord];
  if frEntireScope in Dialog.Options then opciones += [ssoEntireScope];
  encon := ActEditorF.Editor.SearchReplace(buscado,'',opciones);
  if encon = 0 then
  ShowMessage('Not found: ' + buscado);
end;

procedure TMainForm.ToolsExporttoHtmlExecute(Sender: TObject);
begin
  If assigned(ActEditorF.Editor) then ExporttoHtmlFile(ActEditorF)
  else Info('TMainForm.ToolsExporttoHtmlExecute','Do not exists a default editor');
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
    ActEditorF.Editor.SetHighlightSearch('',[ssoSelectedOnly,ssoWholeWord]);
    HighLightReservedWords(nil);
  end;
end;

procedure TMainForm.ToolsFileReformatExecute(Sender: TObject);
var OSL,NSL:TStrings;
begin
  ToolsFileReformat.Enabled:=false;
  OSL:=ActEditorF.Editor.Lines;
  NewEditorPage;
  NSL:=ActEditorF.Editor.Lines;
  ActEditorF.Editor.BeginUpdate(false);
  ActEditorF.Reformat(OSL,NSL,ActEditorF.EdType,commentstr);
  ActEditorF.Editor.EndUpdate;
  ActEditorF.Editor.Modified:=true;
  ToolsFileReformat.Enabled:=true;
end;

procedure TMainForm.FileRevertExecute(Sender: TObject);
begin
  if MainPages.ActivePage=EditorsTab then
  begin
    if Open(ActEditorF.FileName) then UpdGuiTimer.Enabled:=true;
  end else if MainPages.ActivePage=ProgEditTab then
  begin
    if Open(ActEditorF.FileName) then ExtractSBALabels;
  end;
end;

procedure TMainForm.ToolsFileSyntaxCheckExecute(Sender: TObject);
var s:string;
begin
{ TODO : Colocar un botón sobre el arbol del proyecto para comprobar la sintaxis de todos los archivos que forman parte del proyecto. }
  {$IFDEF WINDOWS}
  case ActEditorF.EdType of
    vhdl : begin
      if not fileexists(AppDir+'ghdl\bin\ghdl.exe') then
      begin
       showmessage('GHDL tool not found');
       exit;
      end;
    end;
    verilog,systemverilog : begin
      if not fileexists(AppDir+'iverilog\bin\iverilog.exe') then
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
  { TODO : Completar la verificación en el caso de LINUX }
  {$IFDEF LINUX}
  case ActEditorF.EdType of
    vhdl : begin
      {
       if not fileexists(AppDir+'ghdl\bin\ghdl') then
       begin
        showmessage('GHDL tool not found');
        exit;
       end;
      }
    end;
    verilog,systemverilog : begin
      if not fileexists(AppDir+'iverilog\bin\iverilog') then
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
  s:=ActEditorF.FileName;
  if ActEditorF.Editor.Modified then
  case MessageDlg('File must be saved', 'Save File? '+s, mtConfirmation, [mbYes, mbNo],0) of
    mrYes: if not SaveFile(s,ActEditorF.Editor.Lines) then exit else ActEditorF.Editor.Modified:=false;
  else exit;
  end;
  ToolsFileSyntaxCheck.Enabled:=false;
  { TODO : Esta parte debe mejorarse para poder verificar sintaxis adecuadamente
de archivos individales, cores y requerimientos; y proyectos. }
  if SBAPrj.name<>'' then
    SyntaxCheck(s,SBAPrj.GetAllFileNames(extractfilepath(s)),ActEditorF.EdType)
  else if isIPCore(s) then
    SyntaxCheck(s,SBAIpCore.GetFiles(s),ActEditorF.EdType)
  else SyntaxCheck(s,'',ActEditorF.EdType);
end;

function TMainForm.SelectExportHighligther(var EditorF:TEditorF):TSynCustomHighlighter;
begin
  case EditorF.EdType of
    vhdl,prg:
      result:=TSynSBASyn.Create(MainForm);
    verilog,systemverilog:
      result:=TSynVerilogSyn.Create(MainForm);
    ini:
      result:=TSynIniSyn.Create(MainForm);
    json:
      result:=TSynJSONSyn.Create(MainForm);
    html:
      result:=TSynHTMLSyn.Create(MainForm);
    pas:
      result:=TSynFreePascalSyn.Create(MainForm);
    cpp:
      result:=TSynCppSyn.Create(MainForm);
    python:
      result:=TSynPythonSyn.Create(MainForm);
  else
    result:=nil;
  end;
  if result=nil then
  begin
    Info('TMainForm.ExporttoHtml','Highligther not found');
    Exit(nil);
  end else
    Info('TMainForm.ExporttoHtml ',result.ClassName);
end;

procedure TMainForm.ExporttoHtmlFile(var EditorF: TEditorF);
var f:string;
begin
  Info('TMainForm.ExporttoHtmlFile',EditorF.FileName);
  if EditorF.EdType=markdown then
  begin
    f:=LibraryForm.Md2Html(EditorF.Editor.Text,EditorF.FileName);
    if f='' then exit;
    OpenURL('file://'+f+'?time='+TimetoStr(now));
    Sleep(300);
    DeleteFile(f);
    exit;
  end;
  SynExporterHTML.Highlighter:=SelectExportHighligther(EditorF);
  if assigned(SynExporterHTML.Highlighter) then
  begin
    SynExporterHTML.Options:=SynExporterHTML.Options-[heoWinClipHeader];
    SynExporterHTML.ExportAll(EditorF.Editor.Lines);
    SaveDialog.Filter:=SynExporterHTML.DefaultFilter;
    Info('TMainForm.ExporttoHtml','Select File');
    if SaveDialog.Execute then
    begin
      SynExporterHTML.SaveToFile(SaveDialog.FileName);
      OpenUrl('file://'+SaveDialog.FileName+'?time='+TimetoStr(now));
    end;
    SynExporterHTML.Highlighter.Free;
  end;
end;

procedure TMainForm.CopyAsHtml(var EditorF: TEditorF);
begin
  if not EditorF.Editor.SelAvail then exit;
  SynExporterHTML.Highlighter:=SelectExportHighligther(EditorF);
  if assigned(SynExporterHTML.Highlighter) then with EditorF.Editor do
  begin
    SynExporterHTML.Options:=SynExporterHTML.Options+[heoWinClipHeader];
    SynExporterHTML.ExportRange(Lines,BlockBegin,BlockEnd);
    SynExporterHTML.CopyToClipboard;
    if assigned(SynExporterHTML.Highlighter) then SynExporterHTML.Highlighter.Free;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=false;
  if not CloseProg then exit else CanClose:=true;
  SaveOpenEditor;
  while CanClose and (EditorPages.PageCount>0) do
  begin
    CanClose:=CloseEditor(EditorPages.ActivePageIndex);
  end;
  if CanClose and assigned(SBAPrj) and SBAPrj.Modified then CanClose:=CloseProject;
//  CanClose:=CanClose and not AutoUpdate.DownloadInProgress;
  Info('TMainForm FormCloseQuery CanClose?',CanClose);
end;

procedure TMainForm.SaveOpenEditor;
var
  i,j:integer;
  inifile:TIniFile;
  EditorF:TEditorF;
begin
  Info('TMainForm','SaveOpenEditor');
  try
   IniFile:=TIniFile.Create(ConfigDir+'FileHistory.ini');
   IniFile.EraseSection('LastOpenEditor');
   if EditorPages.PageCount>0 then
   begin
     if Prjvisible then IniFile.WriteString('LastOpenEditor','Project',SBAPrj.location+SBAPrj.name+'.sba');
     j:=0;
     for i:=0 to EditorPages.PageCount-1 do
     begin
       EditorF:=GetEditorPage(i);
       if Assigned(EditorF.Editor) and not EditorF.EditorEmpty then
       begin
         Inc(j);
         IniFile.WriteString('LastOpenEditor',inttostr(j),EditorF.FileName);
       end;
     end;
     IniFile.WriteInteger('LastOpenEditor','Count',j);
   end;
  finally
    If Assigned(IniFile) then FreeAndNil(IniFile);
  end;
end;

procedure TMainForm.SetPrjVisible(AValue: boolean);
begin
  if FPrjVisible=AValue then Exit;
  FPrjVisible:=AValue;
  P_Project.Visible:=FPrjVisible;
  Spl_Project.Visible:=FPrjVisible;
  ProjectMenuEd.Visible:=FPrjVisible;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  Success:Boolean;
begin
  info('TMainForm','Start of create method');
  FPrjVisible:=false;
  Success:=false;
  try
    Success:=GetConfigValues;
    Success:=Success and SetupConfig;
  finally
    if not Success then
    begin
     info('TMainForm.FormCreate','There was an error loading config values');
     ShowMessage('Sorry, an unrecoverable error has occurred, the application is going to exit now');
     Halt;
    end
  end;
  info('TMainForm.FormCreate','Config values OK '+ConfigDir);
  {$IFDEF DEBUG}
  caption:='SBA Creator v'+GetFileVersion+' DEBUG mode';
  info('TMainForm.FormCreate',caption);
  {$ELSE}
  caption:='SBA Creator v'+GetFileVersion;
  {$ENDIF}
  CheckNetworkThread;
  wdir:=ProjectsDir;
  AutoUpdate:=TAutoUpdate.Create;
  Check;
  LoadAnnouncement;
  ActEditorF.Editor:=nil;
  MainPages.ShowTabs:=false;
  MainPages.ActivePage:=SystemTab;
  FilesMon:=TFilesMon.Create(EnableFilesMon,@FileChanged);
  SBAPrj:=TSBAPrj.Create;
  SBAContrlrProg:=TSBAContrlrProg.Create;
  SBASnippet:=TSBASnippet.Create;
  SBASnippet.UpdateSnippetsFilter(SnippetsFilter);
  IpCoreList:=TStringList.Create;
  SnippetsList:=TStringList.Create;
  ProgramsList:=TStringList.Create;
  UpdateLists;
  SynSBASyn:= TSynSBASyn.Create(Self);
  SynVerilogSyn:= TSynVerilogSyn.Create(Self);
  SynJSONSyn:=TSynJSONSyn.create(Self);
  SynMultiCaret:=TSynPluginMulticaret.Create(Self);
  if FileExists(ConfigDir+'autocomplete.txt') then SynCompletion.ItemList.LoadFromFile(ConfigDir+'autocomplete.txt');
  ActEditorF.Editor:=SynEdit_X;
  ActEditorF.FormatEditor;
  SynEdit_X.Font.Name:=EditorFontName;
  SynEdit_X.Font.Size:=EditorFontSize;
  SetupEditorPopupMenu;
  SetupPrgTmplMenu;
  SetupEdTmplMenu;
  PrjHistory.IniFile:=ConfigDir+'FileHistory.ini';
  PrjHistory.UpdateParentMenu;
  EditorHistory.IniFile:=ConfigDir+'FileHistory.ini';
  EditorHistory.UpdateParentMenu;
  CopyPrjHistory;
  LoadPlugIns;
  LoadTheme(ThemeDir);
  ReOpenEditorFiles;
  CheckStartParams;
  EditorPages.OnShowHint:=@ShowHintEvent;;
  DeferredTimer.Enabled:=true;
  info('TMainForm.FormCreate','All tasks finished');
end;

procedure TMainForm.ReOpenEditorFiles;
var
  i:integer;
  prj:string;
  IniFile:TIniFile;
begin
  if not AutoOpenEdFiles then exit;
  IniFile:=TIniFile.Create(ConfigDir+'FileHistory.ini');
  prj:=IniFile.ReadString('LastOpenEditor','Project','');
  if prj<>'' then OpenProject(prj);
  For i:=1 to IniFile.ReadInteger('LastOpenEditor','Count',0) do
    OpenInEditor(IniFile.ReadString('LastOpenEditor',InttoStr(i),''));
  If EditorPages.PageCount>0 then
  begin
    MainPages.ActivePage:=EditorsTab;
    MainPagesChange(nil);
    ForceEditorPagesChange;
  end;
  IniFile.Free;
end;

procedure TMainForm.CheckStartParams;
var
  i:Integer;
  f:String;
begin
  { TODO 1 : Verificar la opción -c ó /c para definir un archivo o carpeta de configuración diferente. }
  If (ParamCount=1) and FileExists(ParamStr(1)) and (CompareText(ExtractFileExt(ParamStr(1)),'.sba')=0) then
  begin
    OpenProject(ParamStr(1));
    exit;
  end;
//
  If (ParamCount=1) and FileExists(ParamStr(1)) and
     ((CompareText(ExtractFileExt(ParamStr(1)),'.snp')=0) or
     (CompareText(ExtractFileExt(ParamStr(1)),'.prg')=0)) then
  begin
    SynEdit_X.Lines.LoadFromFile(ParamStr(1));
    SBAContrlrProg.FileName:=ParamStr(1);
    ProjectGotoPrgExecute(nil);
    exit;
  end;
//
  If ParamCount>0 then
  begin
    GotoEditor;
    For i:=1 to ParamCount do
    begin
      f:=ParamStr(i);
      if fileexists(f) then OpenInEditor(f);
    end;
  end;
end;

procedure TMainForm.CopyPrjHistory;
Var i:Integer;
    m:TMenuItem;
begin
  if not (assigned(ProjectsHistory) or assigned(ProjectsHistory2)) then exit;
  ProjectsHistory2.Clear;
  for i:=0 to ProjectsHistory.Count-1 do
  begin
    m:=TMenuItem.Create(ProjectsHistory2);
    m.caption:=ProjectsHistory.Items[i].caption;
    m.OnClick:=@ProjectsHistory2Click;
    ProjectsHistory2.Add(m);
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

procedure TMainForm.SetupPrgTmplMenu;
var
  M:TMenuItem;
begin
  { TODO : Mover las plantillas de los place holder PRG a un submenu y adicionar capacidad para colocar más plantillas }
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

{ TODO : Crear una ventana dividida donde un treeview a la izquierda, muestre las entradas de las plantillas y a la derecha un editor vhdl en modo solo lectura muestre un preview de las plantillas antes de agregarlas. }
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
    end else
    begin
      N.OnClick:=@EditInsertTemplateExecute;
      N.ImageIndex:=31;
    end;
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

function TMainForm.NewEditorPage: TEditorF;
var
  ActiveTab:TTabSheet;
  EditorF:TEditorF;
begin
  ActiveTab:=EditorPages.AddTabSheet;
  ActiveTab.ShowHint:=false;
  EditorF.CreateEditor(Self,ActiveTab,SynEdit_X);
  EditorF.Editor.OnStatusChange:=@EditorStatusChange;
  selectHighlighter(EditorF);
  EditorPages.ActivePage:=ActiveTab;
  ForceEditorPagesChange;
  Result:=EditorF;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Info('TMainForm','Start of FormDestroy');
  if Assigned(FilesMon) then FilesMon.Terminate;
  if Assigned(PlugInsList) then FreeandNil(PlugInsList);
  if Assigned(ProgramsList) then FreeandNil(ProgramsList);
  if Assigned(SnippetsList) then FreeandNil(SnippetsList);
  if Assigned(IPCoreList) then FreeandNil(IPCoreList);
  If Assigned(SynSBASyn) then FreeandNil(SynSBASyn);
  If Assigned(SynVerilogSyn) then FreeandNil(SynVerilogSyn);
  If Assigned(SynJSONSyn) then FreeandNil(SynJSONSyn);
  If Assigned(SynMultiCaret) then FreeandNil(SynMultiCaret);
  if Assigned(SBASnippet) then FreeandNil(SBASnippet);
  If Assigned(SBAContrlrProg) then FreeandNil(SBAContrlrProg);
  if assigned(SBAPrj) then FreeAndNil(SBAPrj);
  if assigned(AutoUpdate) then FreeAndNil(AutoUpdate);
  Info('TMainForm','End of FormDestroy');
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
    if fileexists(f) then OpenInEditor(f);
  end;
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
  { TODO : Extraer el nombre del archivo y mostrar la pestaña correspondiente a ese archivo o abrirlo si no lo está, antes de saltar al número de línea que contiene el error. }
  s:=Log.GetSelectedText; if s='' then exit;
  if s[2]=':' then s[2]:=' '; //to remove ':' in drive letter
  if pos('line ',s)=1 then s[5]:=':';  // for catch hdlobf result errors
  p.y:=strtointdef(ExtractDelimited(2,s,[':']),0);
  p.x:=strtointdef(ExtractDelimited(3,s,[':']),0);
  if (p.y<>0) then ActEditorF.Editor.CaretXY:=p;
  ActEditorF.Editor.SetFocus;
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
  if ActEditorF.Editor.Modified then
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
  EditorF:TEditorF;
  undostrings:TStringList;
begin
  if PrgReturnTab<>EditorsTab then exit;
  EditorF:=GetActiveEditorPage;
  If assigned(EditorF.Editor) then
  try
    undostrings:=TStringList.Create;
    EditorF.Editor.BeginUpdate(false);
    SynEdit_X.BeginUpdate(false);

    undostrings.Assign(EditorF.Editor.Lines);
    if not SBAContrlrProg.CpyProgDetails(SynEdit_X.Lines, EditorF.Editor.Lines) then
    begin
      EditorF.Editor.ClearAll;
      EditorF.Editor.Lines.Assign(undostrings);
      ShowMessage('Error Copying program details: Please verify "'+cSBAStartProgDetails+'" signatures.');
      Exit;
    end;

    undostrings.Assign(EditorF.Editor.Lines);
    if not SBAContrlrProg.CpyUSignals(SynEdit_X.Lines, EditorF.Editor.Lines) and CtrlAdvMode then
    begin
      EditorF.Editor.ClearAll;
      EditorF.Editor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User signals and type definitions: Please verify "'+cSBAStartUSignals+'" signatures.');
      Exit;
    end;

    undostrings.Assign(EditorF.Editor.Lines);
    if not SBAContrlrProg.CpyUProcedures(SynEdit_X.Lines, EditorF.Editor.Lines) and CtrlAdvMode then
    begin
      EditorF.Editor.ClearAll;
      EditorF.Editor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User Procedures and Functions: Please verify "'+cSBAStartUProc+'" signatures.');
      Exit;
    end;

    undostrings.Assign(EditorF.Editor.Lines);
    if not SBAContrlrProg.CpyProgUReg(SynEdit_X.Lines, EditorF.Editor.Lines) then
    begin
      EditorF.Editor.ClearAll;
      EditorF.Editor.Lines.Assign(undostrings);
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

    undostrings.Assign(EditorF.Editor.Lines);
    if not SBAContrlrProg.CpyProgLabels(L_SBALabels.Items, EditorF.Editor.Lines) then
    begin
      EditorF.Editor.ClearAll;
      EditorF.Editor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User generated labels to controller: Please verify "'+cSBAStartProgLabels+'" signature in the controller.');
      Exit;
    end;

    undostrings.Assign(EditorF.Editor.Lines);
    if not SBAContrlrProg.CpyUserProg(SynEdit_X.Lines, EditorF.Editor.Lines) then
    begin
      EditorF.Editor.ClearAll;
      EditorF.Editor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User program to controller: Please verify "'+cSBAStartUserProg+'" signatures.');
      Exit;
    end;

    undostrings.Assign(EditorF.Editor.Lines);
    if not SBAContrlrProg.CpyUStatements(SynEdit_X.Lines, EditorF.Editor.Lines) and CtrlAdvMode then
    begin
      EditorF.Editor.ClearAll;
      EditorF.Editor.Lines.Assign(undostrings);
      ShowMessage('Error Copying User Statements: Please verify "'+cSBAStartUStatements+'" signatures.');
      Exit;
    end;

    MainPages.ActivePage:=EditorsTab;
    MainPagesChange(Sender);
    ForceEditorPagesChange;
    SynEdit_X.ClearAll;
    SBAContrlrProg.FileName:=cSBADefaultPrgName;
    SynEdit_X.Modified:=false;

  finally
    SynEdit_X.EndUpdate;
    EditorF.Editor.EndUpdate;
    EditorF.Editor.Modified:=true;
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

procedure TMainForm.AsyncLoadPlugIns(Data: PtrInt);
begin
  LoadPlugIns;
end;

procedure TMainForm.ToolsReloadPlugInsExecute(Sender: TObject);
begin
  Application.QueueAsyncCall(@AsyncLoadPlugIns,0);
end;

procedure TMainForm.TReplaceDialogReplace(Sender: TObject);
var
  encon, r : integer;
  buscado : string;
  opciones: TSynSearchOptions;
begin
  if ActEditorF.Editor.ReadOnly then
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
    encon := ActEditorF.Editor.SearchReplace(buscado,SearchReplace.Dialog.ReplaceText,
    opciones+[ssoReplaceAll]); //reemplaza
    ShowMessage('Se reemplazaron ' + IntToStr(encon) + ' ocurrencias.');
    exit;
  end;
  //reemplazo con confirmación
  SearchReplace.Dialog.CloseDialog;
  encon := ActEditorF.Editor.SearchReplace(buscado,'',opciones); //búsqueda
  while encon <> 0 do
  begin
    //pregunta
    r := Application.MessageBox('¿Reemplazar esta ocurrencia?','Reemplazo',MB_YESNOCANCEL);
    if r = IDCANCEL then exit;
    if r = IDYES then
    begin
     ActEditorF.Editor.TextBetweenPoints[ActEditorF.Editor.BlockBegin,ActEditorF.Editor.BlockEnd] :=
     SearchReplace.Dialog.ReplaceText;
    end;
    //busca siguiente
    encon := ActEditorF.Editor.SearchReplace(buscado,'',opciones); //búsca siguiente
  end;
  ShowMessage('No se encuentra: ' + buscado);
end;

procedure TMainForm.UpdGuiTimerTimer(Sender: TObject);
begin
  UpdGuiTimer.Enabled:=false;
  Info('TMainForm.UpdGuiTimerTimer','Tick');
  if SBAPrj.Name<>'' then L_PrjInfo.Caption:=IFTHEN(SBAPrj.Modified,'Project Modified','Project Info');
  if assigned(ActEditorF.Editor) then
  begin
    Info('TMainForm.UpdGuiTimerTimer',ActEditorF.FileName);
    ChangeEditorButtons(ActEditorF);
    DetectSBAController;
  end;
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
  if ActEditorF.EdType in [vhdl,ini,prg,other] then ActEditorF.Editor.SetHighlightSearch(S,[ssoSelectedOnly,ssoWholeWord])
    else ActEditorF.Editor.SetHighlightSearch(S,[ssoMatchCase,ssoSelectedOnly,ssoWholeWord]);
end;

procedure TMainForm.FileNewExecute(Sender: TObject);
begin
  NewEditorPage;
end;

procedure TMainForm.FileOpenExecute(Sender: TObject);
begin
  Info('FileOpenExecute','InitialDir='+wdir);
  OpenDialog.FileName:='';
  OpenDialog.InitialDir:=wdir;
  OpenDialog.DefaultExt:='.vhd';
  OpenDialog.Filter:=FileTypeStr;
  if OpenDialog.Execute then OpenInEditor(OpenDialog.FileName);
end;

procedure TMainForm.DetectSBAController;
begin
  SBA_EditProgram.Enabled:=SBAContrlrProg.DetectSBAContrlr(ActEditorF.Editor.Lines);
end;

procedure TMainForm.ToolProcessReadData(Sender: TObject);
var
  t:TStringList;
  s:string;
begin
   t:=TStringList.Create;
   t.LoadFromStream(ToolProcess.Output);
   for s in t do Log.Items.Add(ConsoleToUtf8(s));
   info('TMainForm.ToolProcessReadData',t);
   t.free;
end;

procedure TMainForm.ToolProcessTerminate(Sender: TObject);
var
  PS:TProcessStatus;
  PStr:String;
begin
  PS:=ProcessStatus;
  ProcessStatus:=Idle;
  EndProcTimer.Enabled:=false;
  try
    if ToolProcess.NumBytesAvailable>0 then ToolProcessReadData(Sender);
  except
    ON E:Exception do InfoErr('TMainForm.ToolProcessTerminate Error',E.Message);
  end;
  Log.ItemIndex:=Log.Count-1;
  case PS of
    SyntaxChk: ToolsFileSyntaxCheck.Enabled:=true;
  end;
{IFDEF Debug}
  WriteStr(PStr,PS);
  info('TMainForm.ToolProcessTerminate','End of process: '+PStr);
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
    L_RsvWord.Items.LoadFromFile(OpenDialog.FileName);
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
  ActEditorF.Editor.Invalidate;
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
  if fileexists(wdir+'rsvwords.txt') and (MessageDlg('File of reserved words found', 'Replace File?', mtConfirmation, [mbYes, mbNo],0)<>mrYes) then exit;
  L_RsvWord.Items.SaveToFile(wdir+'rsvwords.txt');
end;

procedure TMainForm.EditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  if ([scCaretX, scCaretY] * Changes) <> [] then
    StatusBar1.Panels[0].Text:=Format('%4d:%-4d',[TSynEdit(Sender).CaretY,TSynEdit(Sender).CaretX]);
  if scModified in Changes then
  begin
    UpdGuiTimer.Enabled:=true;
    Info('SysEditStatusChange','scModified is in Changes');
  end;
end;

procedure TMainForm.Obfuscate(var EditorF: TEditorF);
var
  f,s,wpath,wfile:string;
begin
  f:=EditorF.FileName;
  case EditorF.EdType of
    vhdl:s:='vhd';
    verilog:s:='ver';
    systemverilog:s:='sv';
  else
    begin
      ShowMessage('Obfuscate is not implemented for this file type');
      exit;
    end;
  end;
  wpath:=extractfilepath(f);
  wfile:=extractfilename(f);
  while ProcessStatus<>Idle do begin sleep(300); application.ProcessMessages; end;
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
  ProcessStatus:=Obfusct;
  EndProcTimer.Enabled:=true;
  ToolProcess.Execute;
  while ToolProcess.Running do begin sleep(300); application.ProcessMessages; end;
  if not fileexists(wpath+'obfuscated_file.'+s) then
  begin
    showmessage('The obfuscated file not was created');
    exit;
  end else OpenInEditor(wpath+'obfuscated_file.'+s);
end;

function TMainForm.Open(f:String):boolean;
begin
  result:=false;
  if FileExists(f) then
  begin
    ActEditorF.Editor.Lines.LoadFromFile(f);
    ActEditorF.FileName:=f;
    if assigned(ActEditorF.Page) then ActEditorF.Page.Caption:=ExtractFileName(f);
    selectHighlighter(ActEditorF);
    ActEditorF.Editor.ReadOnly:=(FileGetAttr(f) and faReadOnly)<>0;
    ActEditorF.Editor.Modified:=false;
    wdir:=extractfilepath(f);
    if wdir='' then wdir:=IFTHEN(SBAPrj.name<>'',SBAPrj.location,ProjectsDir);
    StatusBar1.Panels[1].Text:=f;
    EditorHistory.UpdateList(f);
    if (ActEditorF.Editor<>SynEdit_X) then FilesMon.AddFile(f);
    result:=true;
  end else showmessage('The file: '+f+' was not found.');
end;

procedure TMainForm.OpenInEditor(const f: string);
var i:integer;
begin
  if f='' then exit;
  Info('TMainForm.OpenInEditor',f);
  if (EditorPages.PageCount=0) then NewEditorPage else
    for i:=0 to EditorPages.PageCount-1 do  //Search for already open file
      if EditorPages.Pages[i].Hint=f then
      begin
        EditorPages.ActivePageIndex:=i;
        ForceEditorPagesChange;
        break;
      end;

  if EditorPages.ActivePage.Hint<>f then
  begin
    if not ActEditorF.EditorEmpty then NewEditorPage;
    Open(f);
  end;
  UpdGuiTimer.Enabled:=true;
end;

procedure TMainForm.ChangeEditorButtons(var EditorF: TEditorF);
var f1,f2,f3:boolean;
begin
  if MainPages.ActivePage<>EditorsTab then exit;
  Info('TMainForm.ChangeEditorButtons',EditorF.FileName);
  Info('EditorF.editor.Modified',EditorF.editor.Modified);
  Info('EditorF.EditorEmpty',EditorF.EditorEmpty);
  Info('EditorF.editor.ReadOnly',EditorF.editor.ReadOnly);
  if not assigned(EditorF.editor) then exit;
  f1:=EditorF.editor.Modified;
  f2:=not EditorF.EditorEmpty;
  f3:=not EditorF.editor.ReadOnly;
  FileRevert.Enabled:=f1;
  FileSave.Enabled:=f1 and f2;
  FileSaveAs.Enabled:=f2;
  ToolsFileObf.Enabled:=f2;
  ToolsFileReformat.Enabled:=f2 and f3;
  ToolsFileSyntaxCheck.Enabled:=f2;
  ToolsExporttoHtml.Enabled:=f2;
  SearchReplace.Enabled:=f2 and f3;
  if assigned(EditorF.Page) then
    EditorF.Page.Caption:=IfThen(f1,'*'+ExtractFileName(EditorF.FileName),ExtractFileName(EditorF.FileName));
  if EditorPages.ActivePage.Showing then EditorF.Editor.SetFocus;
end;

procedure TMainForm.SyntaxCheck(f, path: string; hdl: TEdType);
var
  wpath,fname,checkbat:string;
begin
  {$IFDEF WINDOWS}
  case hdl of
    vhdl : checkbat:='checkvhdl.bat';
    systemverilog,verilog : checkbat:='checkver.bat';
    else checkbat:='checkvhdl.bat';
  end;
  {$ENDIF}
  {$IFDEF LINUX}
  case hdl of
    vhdl : checkbat:='checkvhdl.sh';
    systemverilog,verilog : checkbat:='checkver.sh';
    else checkbat:='checkvhdl.sh';
  end;
  {$ENDIF}
  {$IFDEF DARWIN}
  case hdl of
    vhdl : checkbat:='checkvhdl.sh';
    systemverilog,verilog : checkbat:='checkver.sh';
    else checkbat:='checkvhdl.sh';
  end;
  {$ENDIF}
  wpath:=extractfilepath(f);
  fname:=extractfilename(f);
  Log.Clear;
  Log.Items.Add('Starting External Syntax Check Tool, please wait...');
  if not ToolProcessWaitforIdle then
  begin
    ShowMessage('There was an error when executing external tool for syntax check');
    ToolsFileSyntaxCheck.Enabled:=true;
    exit;
  end;
  ToolProcess.Parameters.Clear;
  ToolProcess.CurrentDirectory:=wpath;
  {$IFDEF WINDOWS}
  ToolProcess.Executable:='cmd.exe';
  ToolProcess.Parameters.Add('/c');
  // Hay un bug en el CMD /C que no interpreta adecuadamente las rutas con paréntesis
  // La inclusión de los dobles "" ayuda en la solución temporal del bug
  if path<>'' then
    ToolProcess.Parameters.Add('""'+AppDir+checkbat+'" '+fname+' "'+path+'""')
  else

{ TODO : Evaluar si se trata de un IPCORE (tiene INI) en caso afirmativo agregar
         también los IPCore requeridos al Path en forma recursiva.
         Todo puede ser movido, incluída la insersión del paquete por defecto
         a una función que de el formato necesario al path, antes de llegar
         a esta función. }

    //Por defecto se agrega una versión estable del SBAPackage en la ruta del ghdl si no existe antes en el directorio de trabajo
    if not fileexists(wpath+cSBApkg) then
      ToolProcess.Parameters.Add('""'+AppDir+checkbat+'" '+fname+' "'+SBAbaseDir+cSBApkg+'""')
    else
      ToolProcess.Parameters.Add('""'+AppDir+checkbat+'" '+fname+'"');
  {$ENDIF}
  {$IFDEF LINUX}
  ToolProcess.Executable:='/bin/bash';
  ToolProcess.Parameters.Add('-c');
  if path<>'' then
    ToolProcess.Parameters.Add(AppDir+checkbat+' '+fname+' "'+path+'"')
  else
    //Por defecto se agrega una versión estable del SBAPackage en la ruta del ghdl si no existe antes en el directorio de trabajo
    //Versión estable del SBAPackage: SBAbaseDir+cSBApkg
    if not fileexists(wpath+cSBApkg) then
      ToolProcess.Parameters.Add(AppDir+checkbat+' '+fname+' "'+SBAbaseDir+cSBApkg+'"')
    else
      ToolProcess.Parameters.Add(AppDir+checkbat+' '+fname);
  {$ENDIF}
  {$IFDEF DARWIN}
  ToolProcess.Executable:='sh';
  ToolProcess.Parameters.Add('-c');
  if path<>'' then
    ToolProcess.Parameters.Add(AppDir+checkbat+' '+fname+' "'+path+'"')
  else
    //Por defecto se agrega una versión estable del SBAPackage en la ruta del ghdl si no existe antes en el directorio de trabajo
    //Versión estable del SBAPackage: SBAbaseDir+cSBApkg
    if not fileexists(wpath+cSBApkg) then
      ToolProcess.Parameters.Add(AppDir+checkbat+' '+fname+' "'+SBAbaseDir+cSBApkg+'"')
    else
      ToolProcess.Parameters.Add(AppDir+checkbat+' '+fname);
  {$ENDIF}
  info('TMainForm.SyntaxCheck',ToolProcess.Parameters);
  ProcessStatus:=SyntaxChk;
  EndProcTimer.Enabled:=true;
  ToolProcess.Execute;
  { TODO : Pensar en eliminar el .bat y usar una lista para crear los parámetros debido a las posibles rutas con espacios. }
end;

function TMainForm.ToolProcessWaitforIdle:boolean;
var
  TiO:integer;
  S:string;
begin
  TiO:=100; // Wait for 10 seconds
  While (TiO>0) and (ProcessStatus<>Idle) do
  begin
    Dec(TiO);
    Application.ProcessMessages;
    Sleep(100);
  end;
//
  if (ProcessStatus<>Idle) and not ToolProcess.Running then
  begin
    info('TMainForm.ToolProcessWaitforIdle','el proceso ya no está en ejecución, forzando un Onterminate');
    if ToolProcess.OnTerminate<>nil then ToolProcess.OnTerminate(Self);
    info('TMainForm.ToolProcessWaitforIdle','---- forzado----');
  end;
//
  result:=ProcessStatus=Idle;
  Info('TMainForm.ToolProcessWaitforIdle',IFTHEN(result,'is Idle','can not terminate: Time Out'));
  if not result then
  begin
    WriteStr(S,ProcessStatus);
    Info('TMainForm.ToolProcessWaitforIdle','timeout: '+S);
    //Terminar el proceso que ejecuta si este falla
    EndProcTimer.Enabled:=false;
    ToolProcess.Terminate(0);
    ProcessStatus:=TimeOut;
  end;
end;

procedure TMainForm.ExtractSBALabels;
var
  sl:TStringList;
  l:TListItem;
begin
  ActEditorF.Editor.BeginUpdate(false);
  if SBAContrlrProg.ExtractSBALbls(ActEditorF.Editor.Lines, L_SBALabels.Items) then
  begin
    sl:=TStringList.Create;
    For l in L_SBALabels.Items do sl.Add(l.Caption);
    HighLightReservedWords(sl);
    sl.Free;
  end;
  ActEditorF.Editor.EndUpdate;
end;

procedure TMainForm.LoadRsvWordsFile;
begin
  if not fileexists(wdir+'rsvwords.txt') then copyfile(AppDir+'rsvwords.txt', wdir+'rsvwords.txt');
  L_RsvWord.Clear;
  L_RsvWord.Items.LoadFromFile(wdir+'rsvwords.txt');
  HighLightReservedWords(L_RsvWord.Items);
end;

procedure TMainForm.UpdatePrjTree;
var
  t: TTreeNode;
begin
  PrjTree.BeginUpdate;
  PrjTree.Items.Clear;

  t:=PrjTree.Items.AddChild(nil,SBAPrj.Name);
  PrjTree.Items.AddChild(t, 'Top').StateIndex:=2;
  PrjTree.Items.AddChild(t, 'SBAcfg').StateIndex:=2;
  PrjTree.Items.AddChild(t, 'SBActrlr').StateIndex:=2;
  case SBAPrj.SBAver of
    0: PrjTree.Items.AddChild(t, 'SBAdcdr').StateIndex:=2;
    1: PrjTree.Items.AddChild(t, 'SBAmux').StateIndex:=2;
  end;

  t:=PrjTree.Items.AddChild(nil, 'Aux');
  PrjTree.Items.AddChild(t, 'SBApkg').StateIndex:=3;
  PrjTree.Items.AddChild(t, 'Syscon').StateIndex:=3;
  if SBAPrj.SBAver=0 then PrjTree.Items.AddChild(t, 'DataIntf').StateIndex:=3;

  t:=PrjTree.Items.AddChild(nil, 'Lib');
  AddIPCoresToTree(t,SBAPrj.libcores);

  t:=PrjTree.Items.AddChild(nil, 'User');
  AddUserFilesToTree(t,SBAPrj.UserFiles);

  PrjTree.FullExpand;
  PrjTree.EndUpdate;
  L_PrjInfo.Caption:=IFTHEN(SBAPrj.Modified,'Project Modified','Project Info');
end;

procedure TMainForm.AddIPCoresToTree(t:TTreeNode;cl:TStrings);
var
  i:integer;
  c:TTreeNode;
  s,v:string;
  l:TStringList;
begin
  if (not assigned(cl)) or (cl.Count=0) then exit;
  if t.Level>5 then
  begin
    PrjTree.Items.AddChild(t,'...');
    exit;
  end;
  for i:=0 to cl.Count-1 do
  begin
    v:=cl[i];
    s:=Copy2SymbDel(v,'=');
    if (v<>'UserFiles') then  // Do not insert Core user files in tree
    begin
      c:=PrjTree.Items.AddChild(t,s);
      case v of
        'IPCores','':c.StateIndex:=4;   // if v='' the files are IPCores
        'Packages'  :c.StateIndex:=3;
        else c.StateIndex:=5;
      end;
      l:=SBAIpCore.GetReq(s);
      AddIPCoresToTree(c,l);
      if assigned(l) then freeandnil(l);
    end;
  end;
end;

procedure TMainForm.AddUserFilesToTree(const t: TTreeNode;cl:TStrings);
var
  l: TStringList;
  s: string;
  i: integer;
begin
  l:=FindAllFiles(SBAPrj.location+CPrjUser);
  for s in l do if cl.IndexOfName(ExtractFileName(s))=-1 then
      PrjTree.Items.AddChild(t, ExtractFileName(s)).StateIndex:=5;
  if cl.Count>0 then for i:=0 to cl.Count-1 do
     PrjTree.Items.AddChild(t, cl.names[i]).StateIndex:=5;
  if assigned(l) then FreeAndNil(l);
end;

function TMainForm.CloseProg: boolean;
begin
  if SynEdit_X.Modified then
  begin
    MainPages.ActivePage:=ProgEditTab;
    MainPagesChange(nil);
    SyncroEdit.Enabled:=false;
    SyncroEdit.Editor:=ActEditorF.Editor;
    SyncroEdit.Enabled:=true;
    SynCompletion.Editor:=ActEditorF.Editor;
    SynMultiCaret.Editor:=ActEditorF.Editor;
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
  Info('TMainForm.Check','Compilation Date: '+{$I %date%});
  if TryStrToDate({$I %date%}, ExpDate, 'YYYY/MM/DD', '/') then
  begin
    ExpDate:=IncMonth(ExpDate,6);
  end else ExpDate:=EncodeDate(2019,12,31);
(*
  try
    ExpDate:=IncMonth(ScanDateTime('yyyy/mm/dd',{$I %date%}),6);
  except
    ON E:Exception do
    begin
      Info('TMainForm.Check Error',E.Message);
      ExpDate:=EncodeDate(2019,12,31);
    end;
  end;
*)
  Info('TMainForm.Check','Expiration on: '+DateToStr(ExpDate));
  if CompareDate(Today,ExpDate)>0 then
  begin
    ShowMessage('Sorry, this beta version has expired. You can download the new version from http://sba.accesus.com, thanks you for your support!');
    CheckUpdate;
    If Assigned(AutoUpdate) then FreeAndNil(AutoUpdate);
    halt;
  end;
end;

function TMainForm.selectHighlighter(var EditorF:TEditorF):TEdType;
begin
  result:=EditorF.Edtype;

  If EditorF.Editor=nil then exit;

  case result of
    vhdl,prg : begin
      commentstr:='--';
      EditorF.Editor.Highlighter:=SynSBASyn;
      EditorF.Editor.Options:=EditorF.Editor.Options-[eoShowSpecialChars]+[eoTrimTrailingSpaces];
      mapfile:='vhdl_map.dat'
    end;
    verilog,systemverilog : begin
      commentstr:='//';
      EditorF.Editor.Highlighter:=SynVerilogSyn;
      EditorF.Editor.Options:=EditorF.Editor.Options-[eoShowSpecialChars]+[eoTrimTrailingSpaces];
      mapfile:='verilog_map.dat'
    end;
    ini: begin
      commentstr:=';';
      EditorF.Editor.Highlighter:=SynIniSyn;
      EditorF.Editor.Options:=EditorF.Editor.Options-[eoShowSpecialChars]+[eoTrimTrailingSpaces];
      mapfile:='vhdl_map.dat'
    end;
    json: begin
      commentstr:='"__comment":';
      EditorF.Editor.Highlighter:=SynJSONSyn;
      EditorF.Editor.Options:=EditorF.Editor.Options-[eoShowSpecialChars]+[eoTrimTrailingSpaces];
      mapfile:='vhdl_map.dat'
    end;
    pas : begin
      commentstr:='//';
      EditorF.Editor.Highlighter:=SynFreePascalSyn;
      EditorF.Editor.Options:=EditorF.Editor.Options-[eoShowSpecialChars]+[eoTrimTrailingSpaces];
      mapfile:=''
    end;
    cpp : begin
      commentstr:='//';
      EditorF.Editor.Highlighter:=SynCppSyn;
      EditorF.Editor.Options:=EditorF.Editor.Options-[eoShowSpecialChars]+[eoTrimTrailingSpaces];
      mapfile:=''
    end;
    python: begin
      commentstr:='#';
      EditorF.Editor.Highlighter:=SynPythonSyn;
      EditorF.Editor.Options:=EditorF.Editor.Options-[eoShowSpecialChars]+[eoTrimTrailingSpaces];
      mapfile:=''
    end;
    html : begin
      commentstr:='<!--';
      EditorF.Editor.Highlighter:=SynHTMLSyn;
      EditorF.Editor.Options:=EditorF.Editor.Options-[eoShowSpecialChars]+[eoTrimTrailingSpaces];
      mapfile:=''
    end;
    markdown: begin
      commentstr:='';
      EditorF.Editor.Highlighter:=SynHTMLSyn;
      EditorF.Editor.Options:=EditorF.Editor.Options+[eoShowSpecialChars]-[eoTrimTrailingSpaces];
      mapfile:='vhdl_map.dat'
    end;
    other : begin
      commentstr:='--';
      EditorF.Editor.Highlighter:=nil;
      EditorF.Editor.Options:=EditorF.Editor.Options-[eoShowSpecialChars]+[eoTrimTrailingSpaces];
      mapfile:='vhdl_map.dat'
    end;
  end;
end;

procedure TMainForm.GetFile(filename: string);
var
  f:String;
  Dwt:TDownloadThread;
begin
  f:=ConfigDir+filename;
  DwT:=TDownloadThread.create(Format(SBADwUrl,[filename]),f);
  DwT.OnDownloaded:=@LoadAnnouncement;
  DwT.start;
end;

procedure TMainForm.LoadAnnouncement;
begin
  if Fileexists(ConfigDir+'newbanner.gif') then
  try
    AnnouncementImage.AnimatedGifToSprite(ConfigDir+'newbanner.gif');
    info('TMainForm.LoadAnnouncement','Banner loaded');
  except
    ON E:Exception do
    begin
      DeleteFile(ConfigDir+'newbanner.gif');
      InfoErr('TMainForm.LoadAnnouncement','Error loading new banner:'+E.Message);
    end;
  end;
end;

procedure TMainForm.FileChanged(Sender: TObject);
var
  s:string;
  EditorF:TEditorF;
begin
  if not EnableFilesMon then exit;
  EditorF:=GetEditorFile(TFilesMon(Sender).FileChanged);
  Info('TMainForm.FileChanged',EditorF.FileName);
  if assigned(EditorF.Page) then
  begin
    EditorPages.ActivePage:=EditorF.Page;
    ForceEditorPagesChange;
  end;
  s:='The file has been altered by an external program. Do you wish to '+
     'reload the document?';
  if assigned(EditorF.Editor) and EditorF.Editor.Modified then
    s:=s+#$0a#$0a+'Warning! The open file has been modified. If you reload the '+
       'file, the changes will be lost.';
  s:=s+#$0a#$0a+TFilesMon(Sender).FileChanged;
  if MessageDlg(s, mtConfirmation, [mbYes, mbNo],0)=mrYes then FileRevertExecute(Self);
end;

procedure TMainForm.Colorize(ini: string);
var
  IniFile:TIniFile;
  i:integer;
  EditorF:TEditorF;

  procedure ColHighltr(Hl:TSynCustomHighlighter);
  begin
    if hl=nil then exit;
    With IniFile do
    begin
      case Hl.ClassName of
        'TSynIniSyn' : begin
          TSynIniSyn(Hl).CommentAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterCommentFg','clGreen'));
          TSynIniSyn(Hl).KeywordAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterKeyAttriFg','clBlue'));
          TSynIniSyn(Hl).StringAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterStringAttriFg','clMaroon'));
          TSynIniSyn(Hl).SymbolAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterSymbolAttriFg','clTeal'));
          TSynIniSyn(Hl).NumberAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterNumberAttriFg','clRed'));
          TSynIniSyn(Hl).SectionAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterSectionAttriFg','clNavy'));
          TSynIniSyn(Hl).SectionAttri.Background:=StringToColor(ReadString('Editor','HighlighterSectionAttriBg','clSkyBlue'));
          TSynIniSyn(Hl).TextAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterTextAttriFg','clNone'));
        end;
        'TSynSBASyn': begin
          TSynSBASyn(Hl).CommentAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterCommentFg','clGreen'));
          TSynSBASyn(Hl).KeywordAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterKeyAttriFg','clBlue'));
          TSynSBASyn(Hl).StringAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterStringAttriFg','clMaroon'));
          TSynSBASyn(Hl).SymbolAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterSymbolAttriFg','clTeal'));
          TSynSBASyn(Hl).KeyAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterKeyAttriFg','clBlue'));
          TSynSBASyn(Hl).NumberAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterNumberAttriFg','clRed'));
          TSynSBASyn(Hl).IdentifierAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterIdentifierFg','clWindowText'));
          TSynSBASyn(Hl).AttribAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterAttribFg','$000080FF'));
          TSynSBASyn(Hl).IeeeAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterIeeeAttriFg','$00804000'));
          TSynSBASyn(Hl).SBAAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterSBAAttriFg','$00C08000'));
          TSynSBASyn(Hl).StringAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterStringAttriFg','clMaroon'));
          TSynSBASyn(Hl).SymbolAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterSymbolAttriFg','clTeal'));
        end;
        'TSynJSONSyn': begin
          TSynJSONSyn(Hl).KeyAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterKeyAttriFg','clBlue'));
          TSynJSONSyn(Hl).SymbolAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterSymbolAttriFg','clTeal'));
          TSynJSONSyn(Hl).AttribAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterAttribFg','$000080FF'));
          TSynJSONSyn(Hl).NumberAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterNumberAttriFg','clRed'));
          TSynJSONSyn(Hl).IdentifierAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterIdentifierFg','clWindowText'));
          TSynJSONSyn(Hl).ValueAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterIdentifierFg','clWindowText'));
        end;
        'TSynVerilogSyn': begin
          TSynVerilogSyn(Hl).CommentAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterCommentFg','clGreen'));
          TSynVerilogSyn(Hl).KeywordAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterKeyAttriFg','clBlue'));
          TSynVerilogSyn(Hl).StringAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterStringAttriFg','clMaroon'));
          TSynVerilogSyn(Hl).SymbolAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterSymbolAttriFg','clTeal'));
          TSynVerilogSyn(Hl).KeyAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterKeyAttriFg','clBlue'));
          TSynVerilogSyn(Hl).NumberAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterNumberAttriFg','clRed'));
          TSynVerilogSyn(Hl).IdentifierAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterIdentifierFg','clWindowText'));
          TSynVerilogSyn(Hl).AttribAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterAttribFg','$000080FF'));
          TSynVerilogSyn(Hl).IeeeAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterIeeeAttriFg','$00804000'));
          TSynVerilogSyn(Hl).SBAAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterSBAAttriFg','$00C08000'));
          TSynVerilogSyn(Hl).StringAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterStringAttriFg','clMaroon'));
          TSynVerilogSyn(Hl).SymbolAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterSymbolAttriFg','clTeal'));
        end;
        'TSynHTMLSyn': begin
          TSynHTMLSyn(Hl).CommentAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterCommentFg','clGreen'));
          TSynHTMLSyn(Hl).KeywordAttribute.Foreground:=StringToColor(ReadString('Editor','HighlighterKeyAttriFg','clBlue'));
          TSynHTMLSyn(Hl).SymbolAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterSymbolAttriFg','clTeal'));
          TSynHTMLSyn(Hl).KeyAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterKeyAttriFg','clBlue'));
          TSynHTMLSyn(Hl).IdentifierAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterIdentifierFg','clWindowText'));
          TSynHTMLSyn(Hl).SymbolAttri.Foreground:=StringToColor(ReadString('Editor','HighlighterSymbolAttriFg','clTeal'));
        end;
      end;
    end;
  end;

  procedure ColEdit(Ed:TSynEdit);
  var
    SynMarkup:TSynEditMarkupHighlightAllCaret;
  begin
    With IniFile do
    begin
      Ed.Color:=StringToColor(ReadString('Editor','Color','clWhite'));
      Ed.BracketMatchColor.Foreground:=StringToColor(ReadString('Editor','BracketMatchColorFg','clNone'));
      Ed.BracketMatchColor.Background:=StringToColor(ReadString('Editor','BracketMatchColorBg','clSilver'));
      Ed.FoldedCodeColor.Foreground:=StringToColor(ReadString('Editor','FoldedCodeColorFg','clGray'));
      Ed.FoldedCodeColor.Background:=StringToColor(ReadString('Editor','FoldedCodeColorBg','clNone'));
      Ed.Font.Color:=StringToColor(ReadString('Editor','FontColor','clDefault'));
      Ed.Gutter.Color:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Ed.Gutter.LineNumberPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Ed.Gutter.MarksPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Ed.Gutter.ChangesPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Ed.Gutter.SeparatorPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Ed.Gutter.CodeFoldPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','Color','clWhite'));
      Ed.HighlightAllColor.Background:=StringToColor(ReadString('Editor','HighlightAllColorBg','clMaroon'));
      Ed.HighlightAllColor.Foreground:=StringToColor(ReadString('Editor','HighlightAllColorFg','clHighlightText'));
      Ed.LineHighlightColor.Background:=StringToColor(ReadString('Editor','LineHighlightColorBg','clCream'));
      Ed.LineHighlightColor.FrameColor:=StringToColor(ReadString('Editor','LineHighlightColorFc','clSilver'));
      Ed.MouseLinkColor.Foreground:=StringToColor(ReadString('Editor','MouseLinkColorFg','clBlue'));
      Ed.RightEdgeColor:=StringToColor(ReadString('Editor','RightEdgeColor','clSilver'));
      Ed.RightGutter.Color:=StringToColor(ReadString('Editor','RightGutterColor','clBtnFace'));
      Ed.SelectedColor.Background:=StringToColor(ReadString('Editor','SelectedColorBg','clHighlight'));
      Ed.SelectedColor.Foreground:=StringToColor(ReadString('Editor','SelectedColorFg','clHighlightText'));
      SynMarkup:=TSynEditMarkupHighlightAllCaret(Ed.MarkupByClass[TSynEditMarkupHighlightAllCaret]);
      SynMarkup.MarkupInfo.Background:= StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      SynMarkup.MarkupInfo.FrameColor:= StringToColor(ReadString('Editor','LineHighlightColorFc','clGray'));
    end;
  end;

begin
  try
    IniFile:=TIniFile.Create(ini);
    With IniFile do
    begin
      Color:=StringToColor(ReadString('MainForm','Color','clDefault'));
      Font.Color:=StringToColor(ReadString('MainForm','FontColor','clDefault'));
      Log.Color:=StringToColor(ReadString('MainForm','Color','clDefault'));
      Log.Font.Color:=StringToColor(ReadString('MainForm','FontColor','clDefault'));
      SnippetDescription.Color:=StringToColor(ReadString('Editor','Color','clWhite'));
      SnippetDescription.Font.Color:=StringToColor(ReadString('Editor','HighlighterCommentFg','clGreen'));
      //
      ColHighltr(SynIniSyn);
      ColHighltr(SynHTMLSyn);
      ColHighltr(SynSBASyn);
      ColHighltr(SynVerilogSyn);
      ColHighltr(SynJSONSyn);
      //
      SyncroEdit.MarkupInfoArea.Background:=StringToColor(ReadString('Editor','SyncroEditBg','clMoneyGreen'));
      ColEdit(SynEdit_X);
      if EditorPages.PageCount>0 then For i:=0 to EditorPages.PageCount-1 do
      begin
        EditorF:=GetEditorPage(i);
        ColEdit(EditorF.Editor);
      end;
      //
      PrjTree.BackgroundColor:=StringToColor(ReadString('PrjTree','BackgroundColor','$F0FBFF'));
      PrjTree.Color:=StringToColor(ReadString('PrjTree','Color','$F0FBFF'));
      PrjTree.Font.Color:=StringToColor(ReadString('PrjTree','FontColor','$000000'));
      PrjTree.ExpandSignColor:=StringToColor(ReadString('PrjTree','ExpandSignColor','$808000'));
      PrjTree.SelectionColor:=StringToColor(ReadString('PrjTree','SelectionColor','$00D778'));
      PrjTree.SelectionFontColor:=StringToColor(ReadString('PrjTree','SelectionFontColor','$FFFFFF'));
      PrjTree.SeparatorColor:=StringToColor(ReadString('PrjTree','SeparatorColor','$808080'));
      PrjTree.TreeLineColor:=StringToColor(ReadString('PrjTree','TreeLineColor','$808080'));
    end;
  finally
    If assigned(IniFile) then FreeAndNil(IniFile);
  end;
end;

procedure TMainForm.ShowHintEvent(Sender: TObject; HintInfo: PHintInfo);
var
  Tab: integer;
begin
  With EditorPages do
  begin
    if (PageCount = 0) or (HintInfo = nil) then Exit;
    Tab := IndexOfPageAt(ScreenToClient(Mouse.CursorPos));
    if Tab < 0 then Exit;
    HintInfo^.HintStr := EditorPages.Page[Tab].Hint;
  end;
end;

//function TMainForm.IsShortCut(var Message: TLMKey): Boolean;
//var
//wnd: HWND;
//begin
////wnd:= GetLastactivePopup( application.handle );
////if (wnd <>0) and (wnd <>application.handle) then
////result := false
////else
//result := inherited IsShortcut( Message );
//end;

end.

