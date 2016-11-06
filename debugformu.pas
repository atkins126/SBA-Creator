unit DebugFormU;

{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Clipbrd
  ;

type

  { TDebugForm }

  TDebugForm = class(TForm)
    B_MemoClpbrdCopy: TBitBtn;
    B_MemoClear: TBitBtn;
    Memo: TMemo;
    Panel1: TPanel;
    procedure B_MemoClearClick(Sender: TObject);
    procedure B_MemoClpbrdCopyClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DebugForm: TDebugForm=nil;

function infoln(M:String):boolean;
function infoln(I:integer):boolean;
function infoln(b:boolean):boolean;
function infoln(l:Tstrings):boolean;

implementation

{$R *.lfm}

function infoln(M:String):boolean;
begin
  {$IFDEF DEBUG}
  result:=false;
  if not assigned(DebugForm) then exit;
  DebugForm.Memo.Append(Format('%:3d: %s',[DebugForm.Memo.Lines.Count,M]));
  {$IFDEF LINUX}
  DebugForm.Memo.SelStart := Length(DebugForm.Memo.Lines.Text)-1;
  {$ENDIF}
  DebugForm.Show;
  {$ENDIF}
  result:=true;
end;

function infoln(I: integer): boolean;
begin
  result:=infoln(inttostr(i));
end;

function infoln(b: boolean): boolean;
begin
  if b then result:=infoln('true') else result:=infoln('false');
end;

function infoln(l: TStrings): boolean;
var s:string;
begin
  result:=true;
  infoln('Start of list: ');
  for s in l do result:=result and infoln(s);
  infoln('End of list');
end;

{ TDebugForm }

procedure TDebugForm.B_MemoClearClick(Sender: TObject);
begin
  Memo.Clear;
end;

procedure TDebugForm.B_MemoClpbrdCopyClick(Sender: TObject);
begin
  Clipboard.AsText:=Memo.Text;
end;

end.

