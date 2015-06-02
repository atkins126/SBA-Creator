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

implementation

{$R *.lfm}

function infoln(M:String):boolean;
begin
  result:=false;
  if not assigned(DebugForm) then exit;
{$IFDEF DEBUG}
  DebugForm.Show;
{$ENDIF}
  DebugForm.Memo.Append(M);
  result:=true;
end;

{ TDebugForm }

procedure TDebugForm.B_MemoClearClick(Sender: TObject);
begin
  Memo.Clear;
end;

end.

