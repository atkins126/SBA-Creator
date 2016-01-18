program SBAcreator;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}

  Interfaces, // this includes the LCL widgetset
  Forms, HistoryLazarus, MainFormU, synhighlighterverilog, synhighlightersba,
  versionsupportu, SBAProgContrlrU, AboutFormU, sbasnippetu, configformu,
  PrjWizU, dwfileU, DebugFormU, SBAProjectU, floatformu, CoresPrjEdFormU,
  LibraryFormU, UtilsU, sbaprogramu, IniFilesUTF8, exportprjformu, UScaleDPI,

  {$IFDEF CODETYPHON}
  bs_controls, lz_rtticontrols, pl_bgrauecontrols
  {$ELSE}
  lazcontrols, runtimetypeinfocontrols, uecontrols
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
  HighDPI(96);
  Application.Run;
end.

