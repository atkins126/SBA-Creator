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
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  ExportPrjForm: TExportPrjForm;

implementation

{$R *.lfm}

end.

