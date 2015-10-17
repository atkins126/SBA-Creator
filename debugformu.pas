unit DebugFormU;

{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons
  ;

type

  { TDebugForm }

  TDebugForm = class(TForm)
    B_MemoClear: TBitBtn;
    Memo: TMemo;
    procedure B_MemoClearClick(Sender: TObject);
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

implementation

{$R *.lfm}

function infoln(M:String):boolean;
begin
  {$IFDEF DEBUG}
  result:=false;
  if not assigned(DebugForm) then exit;
  DebugForm.Memo.Append(Format('%:3d: %s',[DebugForm.Memo.Lines.Count,M]));
  DebugForm.ShowOnTop;
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

{ TDebugForm }

procedure TDebugForm.B_MemoClearClick(Sender: TObject);
begin
  Memo.Clear;
end;

end.

