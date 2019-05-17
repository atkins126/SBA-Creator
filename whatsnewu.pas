unit WhatsNewU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ButtonPanel;

type

  { TWhatsNewF }

  TWhatsNewF = class(TForm)
    ButtonPanel1: TButtonPanel;
    Label1: TLabel;
    Memo1: TMemo;
  private

  public

  end;

var
  WhatsNewF: TWhatsNewF;

implementation

{$R *.lfm}

end.

