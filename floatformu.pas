unit FloatFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lclintf, LCLType, ExtCtrls, uERotImage;

type

  { TFloatForm }

  TFloatForm = class(TForm)
    Image: TImage;
    L_CoreName: TLabel;
    Panel1: TPanel;
  private
    { private declarations }
  public
    { public declarations }
    procedure ShowCoreImage(s:string);
  end;

var
  FloatForm: TFloatForm;

implementation

{$R *.lfm}

uses ConfigFormU;

{ TFloatForm }

procedure TFloatForm.ShowCoreImage(s: string);
begin
  if s=L_CoreName.caption then exit;
  L_CoreName.caption:=s;
  try
    Image.Picture.LoadFromFile(LibraryDir+s+PathDelim+'image.png');
    ShowWindow(Self.Handle, SW_SHOWNOACTIVATE);
    Visible := True;
  except
    ON E:Exception do
    begin
      Image.Picture.Clear;
      Visible := False;
    end;
  end;
end;

end.

