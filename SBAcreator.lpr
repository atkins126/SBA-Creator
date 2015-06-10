program SBAcreator;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
<<<<<<< HEAD
  Forms, HistoryLazarus, uecontrols, MainFormU, synhighlighterverilog,
  synhighlightersba, uSynEditPopupEdit, versionsupportu, SBAProgContrlrU,
  AboutFormU, sbasnippetu, configformu, PrjWizU, dwfileU, DebugFormU,
  SBAProjectU, floatformu;
=======
  Forms, uecontrols, MainFormU,
  synhighlighterverilog, synhighlightersba, uSynEditPopupEdit, versionsupportu,
  SBAProgContrlrU, AboutFormU, sbasnippetu, configformu, prjwizu;
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5

{$R *.res}

begin
  Application.Title:='SBACreator';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TprjWizForm, prjWizForm);
<<<<<<< HEAD
  Application.CreateForm(TFloatForm, FloatForm);
=======
>>>>>>> db05c8822c401acbd5e1b0bd01635f339acbe6e5
  Application.Run;
end.

