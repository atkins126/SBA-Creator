unit EditorU;

{$mode objfpc}{$H+}

interface

uses
  Controls, Graphics, Dialogs, Classes, SysUtils, ComCtrls, Fgl,
  StdCtrls, LazFileUtils, SynEdit, SynEditMouseCmds, IniFiles,
  SynEditMarkupHighAll, SynEditTypes, SynEditKeyCmds,
  UtilsU, DebugU;

type

TEdType=(vhdl, prg, verilog, systemverilog, ini, json, markdown, cpp, html, pas, python, other, none);

{ TEditor }

TEditor = class (TSynEdit)
private
  FEdType: TEdType;
  FFileName: string;
  FOnFileNameChanged: TNotifyEvent;
  FPage: TObject;
  FSharedBuffer:TEditor;
  FSharedTopLine:Integer;
  function GetisEmpty: boolean;
  procedure SetEdType(AValue: TEdType);
  procedure SetFileName(AValue: string);
  procedure SetPage(AValue: TObject);
protected
  procedure DoOnStatusChange(Changes: TSynStatusChanges); override;
public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure CommentBlock;
  procedure UncommentBlock;
  procedure Colorize(Ini: string);
  procedure ShareTextBufferFrom(AValue: TEditor);
  procedure UnShareTextBuffer;
published
  property FileName:string read FFileName write SetFileName;
  property isEmpty:boolean read GetisEmpty;
  property EdType:TEdType read FEdType write SetEdType;
  property Page: TObject read FPage write SetPage;
  property OnFileNameChanged: TNotifyEvent read FOnFileNameChanged write FOnFileNameChanged;
  property SharedBuffer:TEditor read FSharedBuffer write ShareTextBufferFrom;
end;

//TEditorList = specialize TFPGObjectList<TEditor>;

var
//  EditorList:TEditorList;
  ActEditor:TEditor=nil;
  EditorCnt:integer=0;
  DefEdType:TEdtype=vhdl;
  EditorFontName:string;
  EditorFontSize:integer;
  CommentStr:string='--';

const
  DefFileTypeKey='VHDL=.vhd|'+
                 'Verilog=.v|'+
                 'System Verilog=.sv|'+
                 'Ini=.ini|'+
                 'Markdown=.md|'+
                 'Python=.py|'+
                 'C=.c|'+
                 'Html=.htm';

  DefFileFilter='VHDL|*.vhd;*.vhdl|'+
                'Verilog|*.v;*.vl;*.ver|'+
                'System Verilog|*.sv|'+
                'Ini|*.ini|'+
                'Markdown|*.md;*.mkd;*.mdwn;*.mdtxt;*.mdtext;*.text|'+
                'Text|*.txt|'+
                'Python|*.py|'+
                'C|*.c;*.cpp|'+
                'Html|*.htm;*.html|'+
                'All files|*.*';

function GetFileType(F: String): TEdType;
function GetFileTypeKey:TStringList;
function GetFileExt(FType: TEdType): string;
function InsertBlock(Editor:TEditor; BStart,BEnd:string;t:TStrings):boolean;
procedure FormatEditor(Editor:TEditor);
procedure Reformat(osl, nsl: Tstrings; filetype: TEdType; Acommentstr: string='--');

implementation

{TEditor}

procedure TEditor.SetFileName(AValue: string);
begin
  if FFileName=AValue then Exit;
  FFileName:=AValue;
  FEdType:=GetFileType(FFileName);
  if assigned(FOnFileNameChanged) then FOnFileNameChanged(Self);
end;

procedure TEditor.SetEdType(AValue: TEdType);
begin
  if FEdType=AValue then Exit;
  FEdType:=AValue;
end;

function TEditor.GetisEmpty: boolean;
begin
  Result:=(Lines.Count=0) or ((Lines.Count=1) and (Lines[0]=''));
end;

procedure TEditor.SetPage(AValue: TObject);
begin
  if FPage=AValue then Exit;
  FPage:=AValue;
end;

procedure TEditor.DoOnStatusChange(Changes: TSynStatusChanges);
begin
  if assigned(FSharedBuffer) and (([scTopLine] * Changes) <> []) then FSharedBuffer.FSharedTopLine:=TopLine;
  inherited DoOnStatusChange(Changes);
end;

constructor TEditor.Create(AOwner: TComponent);
begin
  Info('TEditor.Create',AOwner.Name);
  inherited Create(AOwner);
  DoubleBuffered:=true;
  BorderStyle:= bsNone;
  FEdType:= DefEdType;
  FFileName:= '';
  FPage:= nil;
  FOnFileNameChanged:=nil;
  FSharedBuffer:=nil;
  FSharedTopLine:=0;
  Tag:=EditorCnt;
  FormatEditor(Self);
  Keystrokes.Items[Keystrokes.FindCommand(ecSetMarker1)].Command:=ecToggleMarker1;
  Modified:=false;
  Inc(EditorCnt);
end;

destructor TEditor.Destroy;
begin
  OnStatusChange:=nil;
  inherited Destroy;
end;

procedure TEditor.Colorize(Ini:string);
var
  SynMarkup:TSynEditMarkupHighlightAllCaret;
  IniFile:TIniFile;
begin
  try
    IniFile:=TIniFile.Create(ini);
    With IniFile do
    begin
      Color:=StringToColor(ReadString('Editor','Color','clWhite'));
      BracketMatchColor.Foreground:=StringToColor(ReadString('Editor','BracketMatchColorFg','clNone'));
      BracketMatchColor.Background:=StringToColor(ReadString('Editor','BracketMatchColorBg','clSilver'));
      FoldedCodeColor.Foreground:=StringToColor(ReadString('Editor','FoldedCodeColorFg','clGray'));
      FoldedCodeColor.Background:=StringToColor(ReadString('Editor','FoldedCodeColorBg','clNone'));
      Font.Color:=StringToColor(ReadString('Editor','FontColor','clDefault'));
      Gutter.Color:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Gutter.LineNumberPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Gutter.MarksPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Gutter.ChangesPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Gutter.SeparatorPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      Gutter.CodeFoldPart().MarkupInfo.Background:=StringToColor(ReadString('Editor','Color','clWhite'));
      HighlightAllColor.Background:=StringToColor(ReadString('Editor','HighlightAllColorBg','clMaroon'));
      HighlightAllColor.Foreground:=StringToColor(ReadString('Editor','HighlightAllColorFg','clHighlightText'));
      LineHighlightColor.Background:=StringToColor(ReadString('Editor','LineHighlightColorBg','clCream'));
      LineHighlightColor.FrameColor:=StringToColor(ReadString('Editor','LineHighlightColorFc','clSilver'));
      MouseLinkColor.Foreground:=StringToColor(ReadString('Editor','MouseLinkColorFg','clBlue'));
      RightEdgeColor:=StringToColor(ReadString('Editor','RightEdgeColor','clSilver'));
      RightGutter.Color:=StringToColor(ReadString('Editor','RightGutterColor','clBtnFace'));
      SelectedColor.Background:=StringToColor(ReadString('Editor','SelectedColorBg','clHighlight'));
      SelectedColor.Foreground:=StringToColor(ReadString('Editor','SelectedColorFg','clHighlightText'));
      SynMarkup:=TSynEditMarkupHighlightAllCaret(MarkupByClass[TSynEditMarkupHighlightAllCaret]);
      SynMarkup.MarkupInfo.Background:= StringToColor(ReadString('Editor','GutterColor','clBtnFace'));
      SynMarkup.MarkupInfo.FrameColor:= StringToColor(ReadString('Editor','LineHighlightColorFc','clGray'));
    end;
  finally
    If assigned(IniFile) then FreeAndNil(IniFile);
  end;
end;

procedure TEditor.ShareTextBufferFrom(AValue: TEditor);
begin
  if FSharedBuffer=AValue then Exit;
  FSharedBuffer:=AValue;
  inherited ShareTextBufferFrom(AValue);
  if AValue<>nil then
  begin
    Highlighter:=AValue.Highlighter;
    EdType:=AValue.EdType;
    TopLine:=AValue.FSharedTopLine;
  end;
end;

procedure TEditor.UnShareTextBuffer;
begin
  inherited UnShareTextBuffer;
  FSharedBuffer:=nil;
end;

procedure TEditor.CommentBlock;
Var
  C:TPoint;
  L:integer;
begin
  BeginUpdate(true);
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
  EndUpdate;
end;

procedure TEditor.UncommentBlock;
Var
  C:TPoint;
  L:Integer;
begin
  BeginUpdate(true);
  C:=CaretXY;
  if SelAvail then
  begin
    for L:=BlockBegin.y to BlockEnd.y do
    begin
     CaretY:=L;
     if (Pos(commentstr,ActEditor.LineText)=1) then
     begin
       CaretX:=length(commentstr)+1;
       ExecuteCommand(ecDeleteBOL,'',nil);
     end;
    end;
    CaretY:=C.Y;
  end else if (Pos(commentstr,ActEditor.LineText)=1) then
  begin
    CaretX:=length(commentstr)+1;
    ExecuteCommand(ecDeleteBOL,'',nil);
  end;
  CaretX:=C.X-length(commentstr);
  EndUpdate;
end;

//------------------- Utilities ---------------------//

function InsertBlock(Editor:TEditor; BStart,BEnd:string;t:TStrings):boolean;
var
  sblk,eblk,y:integer;
begin
  if t.Count=0 then exit(true);
  result:=false;
  Y:=Editor.CaretY;
  sblk:=GetPosList(BStart,Editor.Lines);
  eblk:=GetPosList(BEnd,Editor.Lines,sblk);
  Info('TEditor.InsertBlock',Format('%s %d:%d',[BStart,sblk+1,eblk+1]));
  if (sblk<>-1) and (eblk<>-1) then
  begin
    if (Editor.CaretY<sblk+1) or (Editor.CaretY>eblk+1) then
    begin
      while Editor.Lines[eblk-1]='' do dec(eblk);
      Editor.CaretY:=eblk+1;
      Editor.InsertTextAtCaret(LineEnding); //Add a blank line
      if Y>=eblk+1 then Inc(Y);
    end;
    while (t.count>0) and (t[t.count-1]='') do t.Delete(t.count-1);
    sblk:=Editor.CaretY;
    Info('TEditor.InsertBlock Insert At:',Editor.CaretY);
    Editor.InsertTextAtCaret(t.Text);
    if Y<sblk then Editor.CaretY:=Y else Editor.CaretY:=Y+t.Count;
    result:=true;
  end else ShowMessage('Error in block definitions, check '+BStart+' keywords');
end;

procedure Reformat(osl, nsl: Tstrings; filetype: TEdType;
  Acommentstr: string);
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
  if not (filetype in [vhdl,prg,verilog,systemverilog]) then exit;

  ostr:=TStringList.Create;
  ostr.Assign(osl);

  //Delete comments
  for i:=ostr.Count-1 downto 0 do
  begin
    s:=ostr[i];
    j:=pos(Acommentstr,s);
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
      'a'..'z', 'A'..'Z': if (filetype=vhdl) then c:=RandomCase(c);
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
  nsl.Add(Acommentstr+'------------------------------------------------------------------------------');
  nsl.Add(Acommentstr+' This file was obfuscated and reformated using SBA Creator                  --');
  nsl.Add(Acommentstr+'------------------------------------------------------------------------------');
  ostr.Free;
end;

function GetFileType(F:String):TEdType;
var
  ts:string;
begin
  if F='' then exit(none);
  ts:=extractfileext(F);
  case lowercase(ts) of
    '.vhd','.vhdl': result:=vhdl;
    '.prg','.snp' : result:=prg;
    '.v','.vl','.ver' : result:=verilog;
    '.sv' : result:=systemverilog;
    '.ini' : result:=ini;
    '.sba' : result:=json;
    '.c','.cpp' : result:=cpp;
    '.py' : result:=python;
    '.htm','.html': result:=html;
    '.p','.pas' : result:=pas;
    '.markdown','.mdown','.mkdn',
    '.md','.mkd','.mdwn',
    '.mdtxt','.mdtext','.text',
    '.rmd' : result:=markdown;
  else result:=other;
  end;
end;

function GetFileExt(FType:TEdType):string;
begin
  case FType of
    vhdl:result:='.vhd';
    prg:result:='.prg';
    verilog:result:='.v';
    systemverilog:result:='.sv';
    ini:result:='.ini';
    json:result:='.sba';
    cpp:result:='.c';
    python:result:='.py';
    html:result:='.htm';
    pas:result:='.pas';
    markdown:result:='.md';
    else result:='.txt';
  end;
end;

function GetFileTypeKey: TStringList;
var FFileTypeKey:TStringList;
begin
  FFileTypeKey:=TStringList.Create;
  FFileTypeKey.Delimiter := '|';
  FFileTypeKey.StrictDelimiter := True;
  FFileTypeKey.DelimitedText:=DefFileTypeKey;
  result:=FFileTypeKey;
end;

procedure FormatEditor(Editor:TEditor);
var
  SynMarkup: TSynEditMarkupHighlightAllCaret;
begin
  with Editor do
  begin
    Font.Name:=EditorFontName;
    Font.Size:=EditorFontSize;
    //Font.Height:=-12;
    Font.Quality:=fqProof;
    Gutter.Width:=54;
    Options:=[eoAutoIndent, eoBracketHighlight, eoGroupUndo,
       eoScrollPastEof, eoScrollPastEol, eoSmartTabs, eoTabIndent, eoTabsToSpaces,
       eoTrimTrailingSpaces, eoAltSetsColumnMode];
     MouseOptions:=[emAltSetsColumnMode];
     ScrollBars:=ssAutoBoth;
     HighlightAllColor.Background:=clMaroon;
     BracketMatchColor.Background:=clWhite;
     LineHighlightColor.Background:=clCream;
     LineHighlightColor.FrameColor:=clSilver;
     LineHighlightColor.FrameStyle:=slsDotted;
     TabWidth:=4;
     Gutter.MarksPart().AutoSize:=false;
     Gutter.MarksPart().Width:=16;
     Gutter.LineNumberPart().Width:=22;
     Gutter.LineNumberPart().DigitCount:=3;
     Gutter.LineNumberPart().ShowOnlyLineNumbersMultiplesOf:=5;
     Gutter.SeparatorPart().MarkupInfo.Background:=clBtnFace;
     Gutter.SeparatorPart().MarkupInfo.Foreground:=clGray;
     Gutter.CodeFoldPart().MarkupInfo.Background:=clWindow;
     SynMarkup:=TSynEditMarkupHighlightAllCaret(Editor.MarkupByClass[
       TSynEditMarkupHighlightAllCaret]);
     SynMarkup.MarkupInfo.Background:= clBtnFace;
     SynMarkup.MarkupInfo.FrameColor:= clGray;
     SynMarkup.WaitTime := 500;
     SynMarkup.Trim := True;
     SynMarkup.FullWord:= True;
  end;
end;

end.

