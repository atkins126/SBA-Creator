program SBAcreator;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}

  {$IFDEF CODETYPHON}
  Interfaces, // this includes the LCL widgetset
  Forms, bs_controls, lz_rtticontrols, HistoryLazarus, pl_bgrauecontrols,
  MainFormU, synhighlighterverilog, synhighlightersba, uSynEditPopupEdit,
  versionsupportu, SBAProgContrlrU, AboutFormU, sbasnippetu, configformu,
  PrjWizU, dwfileU, DebugFormU, SBAProjectU, floatformu, CoresPrjEdFormU,
  LibraryFormU, UtilsU, sbaprogramu, IniFilesUTF8;
  {$ELSE}
  Interfaces, // this includes the LCL widgetset
  Forms, lazcontrols, runtimetypeinfocontrols, HistoryLazarus, uecontrols,
  MainFormU, synhighlighterverilog, synhighlightersba, uSynEditPopupEdit,
  versionsupportu, SBAProgContrlrU, AboutFormU, sbasnippetu, configformu,
  PrjWizU, dwfileU, DebugFormU, SBAProjectU, floatformu, CoresPrjEdFormU,
  LibraryFormU, UtilsU, sbaprogramu, IniFilesUTF8, exportprjformu
  {$ENDIF}
  {$IFDEF debug}
  , SysUtils
  {$ENDIF}
  ;

{$R *.res}

begin
  {$IFDEF DEBUG}
  // Assuming your build mode sets -dDEBUG in Project Options/Other when defining -gh
  // This avoids interference when running a production/default build without -gh
  // Set up -gh output for the Leakview package:
  if FileExists('heap.trc') then
    DeleteFile('heap.trc');
  SetHeapTraceOutput('heap.trc');
  {$ENDIF DEBUG}
  Application.Title:='SBACreator';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TCoresPrjEdForm, CoresPrjEdForm);
  Application.CreateForm(TFloatForm, FloatForm);
  Application.CreateForm(TLibraryForm, LibraryForm);
  Application.CreateForm(TprjWizForm, prjWizForm);
  Application.CreateForm(TExportPrjForm, ExportPrjForm);
  Application.Run;
end.

