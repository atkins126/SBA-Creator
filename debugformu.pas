unit DebugFormU;

{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Clipbrd;

type

  { TDebugForm }

  TDebugForm = class(TForm)
    B_MemoClpbrdCopy: TBitBtn;
    B_MemoClear: TBitBtn;
    Memo: TMemo;
    Panel1: TPanel;
    procedure B_MemoClearClick(Sender: TObject);
    procedure B_MemoClpbrdCopyClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  DebugForm: TDebugForm=nil;

function info(L,M:String):boolean;
function info(L:String;I:integer):boolean;
function info(L:String;b:boolean):boolean;
function info(L:String;SL:Tstrings):boolean;

function infoln(M:String):boolean;
function infoln(I:integer):boolean;
function infoln(b:boolean):boolean;
function infoln(l:Tstrings):boolean;

implementation

{$R *.lfm}

function info(L,M:String):boolean;
begin
  {$IFDEF DEBUG}
  result:=false;
  if not assigned(DebugForm) then exit;
  DebugForm.Memo.Append(Format('%:3d: %s: %s',[DebugForm.Memo.Lines.Count,L,M]));
  {$IFDEF LINUX}
  DebugForm.Memo.SelStart := Length(DebugForm.Memo.Lines.Text)-1;
  {$ENDIF}
  {$ENDIF}
  result:=true;
end;

function info(L:string; I: integer): boolean;
begin
  result:=info(L,inttostr(i));
end;

function info(L:string;b: boolean): boolean;
begin
  if b then result:=info(L,'true') else result:=info(L,'false');
end;

function info(L:String;SL: TStrings): boolean;
var s:string;
begin
  result:=true;
  info(L,'Start of list: ');
  for s in SL do result:=result and infoln(s);
  info(L,'End of list');
end;


function infoln(M:String):boolean;
begin
  {$IFDEF DEBUG}
  result:=false;
  if not assigned(DebugForm) then exit;
  DebugForm.Memo.Append(Format('%:3d: %s',[DebugForm.Memo.Lines.Count,M]));
  {$IFDEF LINUX}
  DebugForm.Memo.SelStart := Length(DebugForm.Memo.Lines.Text)-1;
  {$ENDIF}
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

procedure TDebugForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:=false;
end;

end.

