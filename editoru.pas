unit EditorU;

{$mode objfpc}{$H+}{$MODESWITCH ADVANCEDRECORDS}

interface

uses
  Dialogs, Classes, SysUtils, ComCtrls, SynEdit, UtilsU, DebugFormU;

type

TEdType=(vhdl, prg, verilog, systemverilog, ini, json, markdown, other);

TEditorF = record
  FileName: String;
  EdType: TEdType;
  Editor: TSynEdit;
  Page: TTabSheet;
  HasError: boolean;
  function InsertBlock(BStart,BEnd:string;t:TStrings):boolean;
end;

var
  EditorList:TFPList;

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

end.

