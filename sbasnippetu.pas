unit SBASnippetU;

{$mode objfpc}{$H+}

interface

uses
  Dialogs, Classes, SysUtils, SBAProgContrlrU, ListViewFilterEdit, FileUtil;

const
  cSBADefaultSnippetName='NewSnippet.prg';

type

  { TSBASnippet }

  TSBASnippet = class(TSBAContrlrProg)
  private
    FData: TStrings;
    FCode: Tstrings;
    FDescription: Tstrings;
    FRegisters: Tstrings;
    FFilter:TListViewFilterEdit;
    procedure AddItemToSnippetsFilter(FileIterator: TFileIterator);
    procedure Setfilename(AValue: string);
  public
    constructor Create;
    destructor Destroy; override;
    function CpyProgDetails(Prog,Src:TStrings):boolean;
    function CpyUserProg(Prog,Src:TStrings):boolean;
    function CpyProgUReg(Prog,Src:TStrings):boolean;
    procedure UpdateSnippetsFilter(Filter: TListViewFilterEdit);
  published
    property Filename:string read Ffilename write Setfilename;
    property Code:Tstrings read Fcode;
    property Description: Tstrings read Fdescription;
    property Registers: Tstrings read FRegisters;
  end;


implementation

uses ConfigFormU,UtilsU;

{ TSBASnippet }

procedure TSBASnippet.Setfilename(AValue: string);
begin
  if Ffilename=AValue then Exit;
  try
    FData.LoadFromFile(AValue);
  except
    showmessage('Code snippet could not be loaded');
    exit;
  end;
  CpyUserProg(FData,FCode);
  CpyProgDetails(FData,FDescription);
  CpyProgUReg(FData,FRegisters);
  Ffilename:=AValue;
end;

constructor TSBASnippet.Create;
begin
  inherited Create;
  FFileName:=cSBADefaultSnippetName;
  FData:=TStringList.Create;
  FCode:=TStringList.Create;
  FDescription:=TStringList.Create;
  FRegisters:=TStringList.Create;
end;

destructor TSBASnippet.Destroy;
begin
  if assigned(FData) then FreeAndNil(FData);
  if assigned(FCode) then FreeAndNil(FCode);
  if assigned(FRegisters) then FreeAndNil(FRegisters);
  if assigned(FDescription) then FreeAndNil(FDescription);
  inherited Destroy;
end;

function TSBASnippet.CpyProgDetails(Prog, Src: TStrings): boolean;
Var I:Integer;
begin
  Src.Clear;
  Src.Add(cSBAStartProgDetails);
  Src.Add(cSBAEndProgDetails);
  Result:=inherited CpyProgDetails(Prog, Src);
  If Src.Count>1 then
  begin
    Src.Delete(0);
    Src.Delete(Src.Count-1);
    for I:=0 to Src.count-1 do Src[i]:=Trim(Copy(Src[i],3,1000)); //remove extra comments "--"
  end;
end;

function TSBASnippet.CpyUserProg(Prog, Src: TStrings): boolean;
begin
  Src.Clear;
  Src.Add(cSBAStartUserProg);
  Src.Add(cSBAEndUserProg);
  Result:=inherited CpyUserProg(Prog, Src);
  If Src.Count>1 then
  begin
    Src.Delete(0);
    Src.Delete(Src.Count-1);
  end;
end;

function TSBASnippet.CpyProgUReg(Prog, Src: TStrings): boolean;
begin
  Src.Clear;
  Src.Add(cSBAStartProgUReg);
  Src.Add(cSBAEndProgUReg);
  Result:=inherited CpyProgUReg(Prog, Src);
  If Src.Count>1 then
  begin
    Src.Delete(0);
    Src.Delete(Src.Count-1);
  end;
end;

procedure TSBASnippet.AddItemToSnippetsFilter(FileIterator: TFileIterator);
var
  Data:TStringArray;
begin
  SetLength(Data,2);
  Data[0]:=ExtractFileNameWithoutExt(FileIterator.FileInfo.Name);
  Data[1]:=AppendPathDelim(FileIterator.Path)+FileIterator.FileInfo.Name;
  FFilter.Items.Add(Data);
end;

procedure TSBASnippet.UpdateSnippetsFilter(Filter:TListViewFilterEdit);
begin
  FFilter:=Filter;
  FFilter.Items.Clear;
  SearchForFiles(SnippetDir,'*.snp',@AddItemToSnippetsFilter);
  SearchForFiles(LibraryDir,'*.snp',@AddItemToSnippetsFilter);
  FFilter.InvalidateFilter;
end;


end.

