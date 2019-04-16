unit ExportPrjFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ExtCtrls, ButtonPanel;

type

  { TExportPrjForm }

  TExportPrjForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    CB_ExpPrjUser: TCheckBox;
    CB_ExpPrjMonolithic: TCheckBox;
    CB_ExpPrjAllLib: TCheckBox;
    Ed_TargetDir: TDirectoryEdit;
    Label3: TLabel;
    L_PrjDir: TLabel;
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ExportPrjForm: TExportPrjForm;

implementation

{$R *.lfm}

Uses DebugU;

{ TExportPrjForm }

procedure TExportPrjForm.FormDestroy(Sender: TObject);
begin
  Info('TExportPrjForm','FormDestroy');
end;

end.

