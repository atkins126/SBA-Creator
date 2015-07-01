program SBAcreator;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, runtimetypeinfocontrols, HistoryLazarus, uecontrols,
  MainFormU, synhighlighterverilog, synhighlightersba, uSynEditPopupEdit,
  versionsupportu, SBAProgContrlrU, AboutFormU, sbasnippetu, configformu,
  PrjWizU, dwfileU, DebugFormU, SBAProjectU, floatformu, CoresPrjEdFormU,
  LibraryFormU, UtilsU, sbaprogramu, IniFilesUTF8;

{$R *.res}

begin
  Application.Title:='SBACreator';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TprjWizForm, prjWizForm);
  Application.CreateForm(TFloatForm, FloatForm);
  Application.CreateForm(TCoresPrjEdForm, CoresPrjEdForm);
  Application.CreateForm(TLibraryForm, LibraryForm);
  Application.Run;
end.

