program SBAcreator;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uecontrols, MainFormU,
  synhighlighterverilog, synhighlightersba, uSynEditPopupEdit, versionsupportu,
  SBAProgContrlrU, AboutFormU, sbasnippetu, configformu, prjwizu;

{$R *.res}

begin
  Application.Title:='SBACreator';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TprjWizForm, prjWizForm);
  Application.Run;
end.

