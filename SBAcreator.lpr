program SBAcreator;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  cmem,
  {$ENDIF}{$ENDIF}

  Interfaces, // this includes the LCL widgetset
  Forms, FrameViewer09, HistoryLazarus, MainFormU, synhighlighterverilog,
  synhighlightersba, versionsupportu, SBAProgContrlrU, AboutFormU, sbasnippetu,
  configformu, PrjWizU, dwfileU, DebugU, AutoUpdateU, SBAProjectU,
  floatformu, CoresPrjEdFormU, LibraryFormU, UtilsU, sbaprogramu,
  exportprjformu, UScaleDPI,
  lazcontrols, uecontrols, SBAIPCoresU, PlugInU
  {$IFDEF debug}
  , SysUtils, unit1
  {$ENDIF}
  ;

{$R *.res}

begin
  {$IFDEF DEBUG}
  // Assuming your build mode sets -dDEBUG in Project Options/Other when defining -gh
  // This avoids interference when running a production/default build without -gh
  // Set up -gh output for the Leakview package:
  if FileExists('heap.trc') then DeleteFile('heap.trc');
  SetHeapTraceOutput('heap.trc');
  {$ENDIF DEBUG}
  Application.Title:='SBACreator';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TConfigForm, ConfigForm);
  Application.CreateForm(TFloatForm, FloatForm);
  Application.CreateForm(TCoresPrjEdForm, CoresPrjEdForm);
  Application.CreateForm(TExportPrjForm, ExportPrjForm);
  Application.CreateForm(TLibraryForm, LibraryForm);
  Application.CreateForm(TprjWizForm, prjWizForm);
  Application.CreateForm(TAboutForm, AboutForm);
  //HighDPI(96);
  Application.Run;
end.

