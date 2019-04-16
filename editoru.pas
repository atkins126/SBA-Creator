unit EditorU;

{$mode objfpc}{$H+}{$MODESWITCH ADVANCEDRECORDS}

interface

uses
  Controls, Graphics, Dialogs, Classes, SysUtils, ComCtrls,
  StdCtrls, LazFileUtils, SynEdit, SynEditMouseCmds,
  SynEditMarkupHighAll, SynEditTypes, SynEditKeyCmds,
  UtilsU, DebugU;

type

TEdType=(vhdl, prg, verilog, systemverilog, ini, json, markdown, cpp, html, pas, other, none);

{ TEditorF }

TEditorF = record
private
  FFileName: string;
  procedure SetFileName(AValue: string);
public
  EdType: TEdType;
  Editor: TSynEdit;
  Page: TTabSheet;
  HasError: boolean;
  procedure FormatEditor;
  function InsertBlock(BStart,BEnd:string;t:TStrings):boolean;
  procedure Reformat(osl, nsl: Tstrings; filetype: TEdType; Acommentstr: string='--');
  function Edtypeselect:TEdType;
  procedure CreateEditor(AOwner: TComponent; ATab: TTabSheet; Template:TSynEdit=nil);
  property FileName:string read FFileName write SetFileName;
  function EditorEmpty : boolean;
  procedure Close;
end;

var
  EditorList:TFPList;
  ActEditorF:TEditorF;
  EditorCnt:integer=1;

implementation

{TEditorF}

function TEditorF.InsertBlock(BStart,BEnd:string;t:TStrings):boolean;
var
  sblk,eblk,y:integer;
begin
  if t.Count=0 then exit(true);
  result:=false;
  Y:=Editor.CaretY;
  sblk:=GetPosList(BStart,Editor.Lines);
  eblk:=GetPosList(BEnd,Editor.Lines,sblk);
  Info('TEditorF.InsertBlock',Format('%s %d:%d',[BStart,sblk+1,eblk+1]));
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
    Info('TEditorF.InsertBlock Insert At:',Editor.CaretY);
    Editor.InsertTextAtCaret(t.Text);
    if Y<sblk then Editor.CaretY:=Y else Editor.CaretY:=Y+t.Count;
    result:=true;
  end else ShowMessage('Error in block definitions, check '+BStart+' keywords');
end;

procedure TEditorF.SetFileName(AValue: string);
begin
  if FFileName=AValue then Exit;
  FFileName:=AValue;
  Edtypeselect;
  if assigned(Page) then Page.Hint:=AValue;
end;

procedure TEditorF.FormatEditor;
var
  SynMarkup: TSynEditMarkupHighlightAllCaret;
begin
  Editor.Font.Height:=-12;
  Editor.Font.Quality:=fqProof;
  Editor.Gutter.Width:=54;
  Editor.Options:=[eoAutoIndent, eoBracketHighlight, eoGroupUndo,
    eoScrollPastEof, eoScrollPastEol, eoSmartTabs, eoTabIndent, eoTabsToSpaces,
    eoTrimTrailingSpaces, eoAltSetsColumnMode];
  Editor.MouseOptions:=[emAltSetsColumnMode];
  Editor.ScrollBars:=ssAutoBoth;
  Editor.HighlightAllColor.Background:=clMaroon;
  Editor.BracketMatchColor.Background:=clWhite;
  Editor.LineHighlightColor.Background:=clCream;
  Editor.LineHighlightColor.FrameColor:=clSilver;
  Editor.LineHighlightColor.FrameStyle:=slsDotted;
  Editor.TabWidth:=4;
  Editor.Gutter.MarksPart().AutoSize:=false;
  Editor.Gutter.MarksPart().Width:=16;
  Editor.Gutter.LineNumberPart().Width:=22;
  Editor.Gutter.LineNumberPart().DigitCount:=3;
  Editor.Gutter.LineNumberPart().ShowOnlyLineNumbersMultiplesOf:=5;
  Editor.Gutter.SeparatorPart().MarkupInfo.Background:=clBtnFace;
  Editor.Gutter.SeparatorPart().MarkupInfo.Foreground:=clGray;
  Editor.Gutter.CodeFoldPart().MarkupInfo.Background:=clWindow;
  SynMarkup:=TSynEditMarkupHighlightAllCaret(Editor.MarkupByClass[
    TSynEditMarkupHighlightAllCaret]);
  SynMarkup.MarkupInfo.Background:= clBtnFace;
  SynMarkup.MarkupInfo.FrameColor:= clGray;
  SynMarkup.WaitTime := 500;
  SynMarkup.Trim := True;
  SynMarkup.FullWord:= True;
end;

function TEditorF.Edtypeselect: TEdType;
var
  ts:string;
begin
  ts:=extractfileext(FileName);
  Info('TMainForm.Edtypeselect ext',ts);
  if FFileName='' then exit(none);
  case lowercase(ts) of
    '.vhd','.vhdl': result:=vhdl;
    '.prg','.snp' : result:=prg;
    '.v','.vl','.ver' : result:=verilog;
    '.sv' : result:=systemverilog;
    '.ini' : result:=ini;
    '.sba' : result:=json;
    '.c','.cpp' : result:=cpp;
    '.htm','.html': result:=html;
    '.p','.pas' : result:=pas;
    '.markdown','.mdown','.mkdn',
    '.md','.mkd','.mdwn',
    '.mdtxt','.mdtext','.text',
    '.rmd' : result:=markdown;
  else result:=other;
  end;
  EdType:=result;
end;

procedure TEditorF.CreateEditor(AOwner: TComponent; ATab: TTabSheet;
  Template: TSynEdit);
var
  SaveName,f: String;
  memStrm: TMemoryStream;
  SynMarkup: TSynEditMarkupHighlightAllCaret;
begin
  if Template<>nil then
  try
    memStrm:=TMemoryStream.Create;
    SaveName:=Template.Name;
    Template.Name:='SynEdit_'+inttostr(EditorCnt);
    memStrm.WriteComponent(Template);
    Template.Name:=SaveName;
    Editor:= TSynEdit.Create(AOwner);
    memStrm.Position:=0;
    memStrm.ReadComponent(Editor);
    SynMarkup:=TSynEditMarkupHighlightAllCaret(Editor.MarkupByClass[
      TSynEditMarkupHighlightAllCaret]);
    SynMarkup.MarkupInfo.Background:= TSynEditMarkupHighlightAllCaret(Template.MarkupByClass[
      TSynEditMarkupHighlightAllCaret]).MarkupInfo.Background;
    SynMarkup.MarkupInfo.FrameColor:= TSynEditMarkupHighlightAllCaret(Template.MarkupByClass[
      TSynEditMarkupHighlightAllCaret]).MarkupInfo.FrameColor;
    SynMarkup.WaitTime := 500;
    SynMarkup.Trim := True;
    SynMarkup.FullWord:= True;
  finally
    if assigned(memStrm) then freeAndNil(memStrm);
  end else
  begin
    Editor:= TSynEdit.Create(AOwner);
    Editor.Name:='SynEdit_'+inttostr(EditorCnt);
    Editor.Tag:=EditorCnt;
    FormatEditor;
    Editor.Keystrokes.Items[Editor.Keystrokes.FindCommand(ecSetMarker1)].Command:=
      ecToggleMarker1;
  end;
  Editor.Parent:=ATab;
  Editor.Clear;
  Editor.Align:=alClient;
  Page:=ATab;
  f:='NewFile'+inttostr(EditorCnt)+'.vhd';
  SetFileName(AppendPathDelim(GetCurrentDir)+f);
  Page.Caption:=f;
  Page.Tag:=EditorCnt;
  Editor.Modified:=false;
  Inc(EditorCnt);
  Info('TEditorF.CreateEditor',f);
  //Editor.BookMarkOptions.BookmarkImages:=MarkImages;
  //Editor.PopupMenu:=EditorPopUp;
  //Editor.OnStatusChange:=@SynEditStatusChange;
end;

function TEditorF.EditorEmpty: boolean;
begin
  Result:=(Editor.Lines.Count=0) or ((Editor.Lines.Count=1) and (Editor.Lines[1]=''));
end;

procedure TEditorF.Close;
begin
  Info('TEditorF.Close',Filename);
  FFileName:='';
  if assigned(Editor) then
  begin
    Editor.OnStatusChange:=nil;
    FreeAndNil(Editor);
  end;
  if assigned(Page) then FreeAndNil(Page);
end;

procedure TEditorF.Reformat(osl, nsl: Tstrings; filetype: TEdType;
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

end.

