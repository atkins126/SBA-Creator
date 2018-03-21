unit AboutFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

uses DebugFormU;

{ TAboutForm }

procedure TAboutForm.FormDestroy(Sender: TObject);
begin
  Info('TAboutForm','FormDestroy');
end;

{ TAboutForm }


end.

