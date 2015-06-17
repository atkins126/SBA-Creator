unit LibraryFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, ListViewFilterEdit, Forms, Controls, Graphics,
  Dialogs, ComCtrls, Buttons, ExtCtrls;

type

  { TLibraryForm }

  TLibraryForm = class(TForm)
    LibraryPages: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SnippetsFilter: TListViewFilterEdit;
    IPCoresFilter: TListViewFilterEdit;
    ProgramsFilter: TListViewFilterEdit;
    SnippetsList: TListView;
    IPCores: TTabSheet;
    Programs: TTabSheet;
    Snippets: TTabSheet;
    IPCoresList: TListView;
    ProgramsList: TListView;
    procedure SnippetsListClick(Sender: TObject);
  private
    procedure AddItemToIPCoresFilter(FileIterator: TFileIterator);
    procedure AddItemToProgramsFilter(FileIterator: TFileIterator);
    procedure AddItemToSnippetsFilter(FileIterator: TFileIterator);
    { private declarations }
  public
    { public declarations }
    procedure UpdateLists;
  end;

var
  LibraryForm: TLibraryForm;

function ShowLibraryForm:TModalResult;

implementation

{$R *.lfm}

uses ConfigFormU,UtilsU;

function ShowLibraryForm: TModalResult;
begin
  LibraryForm.UpdateLists;
  result:=LibraryForm.ShowModal;
end;

{ TLibraryForm }

procedure TLibraryForm.SnippetsListClick(Sender: TObject);
begin
  ShowMessage(SnippetsList.Selected.SubItems[0]);
end;

procedure TLibraryForm.AddItemToIPCoresFilter(FileIterator: TFileIterator);
var
  Data:TStringArray;
begin
  SetLength(Data,2);
  Data[0]:=ExtractFileNameWithoutExt(FileIterator.FileInfo.Name);
  Data[1]:=FileIterator.Path;
  IPCoresFilter.Items.Add(Data);
end;

procedure TLibraryForm.AddItemToProgramsFilter(FileIterator: TFileIterator);
var
  Data:TStringArray;
begin
  SetLength(Data,2);
  Data[0]:=ExtractFileNameWithoutExt(FileIterator.FileInfo.Name);
  Data[1]:=FileIterator.Path;
  ProgramsFilter.Items.Add(Data);
end;

procedure TLibraryForm.AddItemToSnippetsFilter(FileIterator: TFileIterator);
var
  Data:TStringArray;
begin
  SetLength(Data,2);
  Data[0]:=ExtractFileNameWithoutExt(FileIterator.FileInfo.Name);
  Data[1]:=FileIterator.Path;
  SnippetsFilter.Items.Add(Data);
end;

procedure TLibraryForm.UpdateLists;
begin
  IpCoresFilter.Items.Clear;
  SearchForFiles(LibraryDir, '*.vhd',@AddItemToIpCoresFilter);
  IpCoresFilter.InvalidateFilter;
//
  ProgramsFilter.Items.Clear;
  SearchForFiles(ProjectsDir, '*.prg',@AddItemToProgramsFilter);
  SearchForFiles(LibraryDir, '*.prg',@AddItemToSnippetsFilter);
  SearchForFiles(SnippetDir, '*.prg',@AddItemToSnippetsFilter);
  ProgramsFilter.InvalidateFilter;
//
  SnippetsFilter.Items.Clear;
  SearchForFiles(SnippetDir, '*.snp',@AddItemToSnippetsFilter);
  SearchForFiles(LibraryDir, '*.snp',@AddItemToSnippetsFilter);
  SnippetsFilter.InvalidateFilter;
end;

end.

