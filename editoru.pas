unit EditorU;

{$mode objfpc}{$H+}{$MODESWITCH ADVANCEDRECORDS}

interface

uses
  Dialogs, Classes, SysUtils, ComCtrls, SynEdit, UtilsU, DebugFormU;

type

TEdType=(vhdl, prg, verilog, systemverilog, ini, json, markdown, cpp, html, pas, other);

{ TEditorF }

TEditorF = record
  FileName: String;
  EdType: TEdType;
  Editor: TSynEdit;
  Page: TTabSheet;
  HasError: boolean;
  function InsertBlock(BStart,BEnd:string;t:TStrings):boolean;
  procedure Reformat(osl, nsl: Tstrings; filetype: TEdType; commentstr: string=
    '--');
  function Edtypeselect:TEdType;
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

procedure TEditorF.Reformat(osl, nsl: Tstrings; filetype:TEdType; commentstr:string='--');
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
  nsl.Add(commentstr+'------------------------------------------------------------------------------');
  nsl.Add(commentstr+' This file was obfuscated and reformated using SBA Creator                  --');
  nsl.Add(commentstr+'------------------------------------------------------------------------------');
  ostr.Free;
end;

function TEditorF.Edtypeselect: TEdType;
var
  ts:string;
begin
  ts:=extractfileext(Self.FileName);
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
  Self.EdType:=result;
  Info('TMainForm.Edtypeselect ext',ts);
end;

end.

