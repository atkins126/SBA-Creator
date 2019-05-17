unit PlugInU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Menus, Graphics, Controls,
  fileutil, LazFileUtils, IniFiles, Fgl,
  Dialogs, ConfigFormU, SBAProjectU, EditorU;

type
  TPlugInCmd=procedure(Sender:TObject) of object;

  { TPlugIn }

  TPlugIn=class(TObject)
  private
    procedure SetEnabled(AValue: Boolean);
  public
    id:string;
    IniFile:string;
    Path:string;
    Name:string;
    Version:string;
    PlgType:string;
    Cmd:string;
    Parameters:string;
    FEnabled:boolean;
    ButtonCaption:string;
    ButtonGlyph:string;
    MenuCaption:string;
    MenuIcon:string;
    MenuHint:string;
    Tag:Integer;
    PlugInCmd:TPlugInCmd;
    MenuItem:TMenuItem;
    constructor Create(ifile: string);
    function IsValid:boolean;
    function ParseParameters:string;
    procedure OnClick(Sender: TObject);
    function CreateMenuItem(Menu: TMenuItem): TMenuItem;
    function GetPlugIn(plid: string): TPlugIn;
    property Enabled:Boolean read FEnabled write SetEnabled;
  end;

  TPlugInsList=specialize TFPGObjectList<TPlugIn>;

var
  PlugInsList:TPlugInsList;

function GetPlugInList:boolean;
function TestforPlugIn(s,d:string):TPlugIn;

implementation

uses UtilsU, DebugU;

Const
  cPrjPath='%prjpath%';
  cPrjFile='%prjfile%';
  cPrjName='%prjname%';
  cFileName='%filename%';
  cFilePath='%filepath%';
  cAppDir='%appdir%';
  cConfigFile='%configfile%';

{ TPlugIn }

procedure TPlugIn.SetEnabled(AValue: Boolean);
var
  Ini:TIniFile;
begin
  if FEnabled=AValue then Exit;
  FEnabled:=AValue;
  Ini:=TIniFile.Create(inifile);
  try
    Ini.WriteBool('MAIN','Enabled',FEnabled);
  finally
    If assigned(Ini) then FreeAndNil(Ini);
  end;
end;

constructor TPlugIn.Create(ifile: string);
var
  Ini:TIniFile;
begin
  Ini:=TIniFile.Create(ifile);
  try
    Inifile:=ifile;
    Id:=Ini.Readstring('MAIN','Id',ExtractFileNameOnly(ifile));
    Path:=ExtractFilePath(ifile);
    Name:=Ini.Readstring('MAIN','Name','');
    Version:=Ini.Readstring('MAIN','Version','');
    plgtype:=Ini.ReadString('MAIN','Type','binary');
    Cmd:=Ini.Readstring('MAIN','Cmd','');
    Parameters:=Ini.Readstring('MAIN','Parameters','');
    Enabled:=Ini.ReadBool('MAIN','Enabled',true);
    ButtonCaption:=Ini.Readstring('Button','Caption',Name);
    ButtonGlyph:=Ini.Readstring('Button','Glyph','');
    MenuCaption:=Ini.Readstring('Menu','Caption','');
    MenuIcon:=Ini.Readstring('Menu','Icon','');
    MenuHint:=Ini.Readstring('Menu','Hint','');
  finally
    If assigned(Ini) then FreeAndNil(Ini);
  end;
  PlugInCmd:=nil;
  MenuItem:=nil;
  Tag:=0;
end;

function TPlugIn.IsValid: boolean;
begin
  result:=not(Name.IsEmpty or Cmd.IsEmpty);
end;

function TPlugIn.ParseParameters: string;
begin
  result:=Parameters;
  result:=StringReplace(result,cPrjPath,SBAPrj.location,[rfIgnoreCase]);
  result:=StringReplace(result,cPrjFile,SBAPrj.PrjFile,[rfIgnoreCase]);
  result:=StringReplace(result,cPrjName,SBAPrj.Name,[rfIgnoreCase]);
  result:=StringReplace(result,cPrjAuthor,SBAPrj.author,[rfIgnoreCase]);
  //
  if assigned(ActEditor) then
  begin
    result:=StringReplace(result,cFileName,ActEditor.FileName,[rfIgnoreCase]);
    result:=StringReplace(result,cFilePath,ExtractFilePath(ActEditor.FileName),[rfIgnoreCase]);
  end else begin
    result:=StringReplace(result,cFileName,cDefNewFileName+'.vhd',[rfIgnoreCase]);
    result:=StringReplace(result,cFilePath,'',[rfIgnoreCase]);
  end;
  //
  result:=StringReplace(result,cAppDir,AppDir,[rfIgnoreCase]);
  result:=StringReplace(result,cConfigFile,ConfigFile,[rfIgnoreCase]);
end;

function TPlugIn.CreateMenuItem(Menu: TMenuItem): TMenuItem;
var
  picture:TPicture;
begin
  if not MenuCaption.IsEmpty then
  begin
    MenuItem:=TMenuItem.Create(Menu);
    MenuItem.Caption:=MenuCaption;
    MenuItem.Hint:=MenuHint;
    Menu.Add(MenuItem);
    MenuItem.OnClick:=@OnClick;
    if not MenuIcon.IsEmpty then
    begin
      Picture := TPicture.Create;
      try
        Picture.LoadFromFile(Path+MenuIcon);
        MenuItem.Bitmap.Assign(Picture.Graphic);
      finally
        Picture.Free;
      end;
    end;
    result:=MenuItem;
  end else result:=nil;
end;

function TPlugIn.GetPlugIn(plid: string): TPlugIn;
var
  PlugIn:TPlugIn;
begin
  result:=nil;
  if assigned(PlugInsList) and (PlugInsList.Count>0) then
  for PlugIn in PlugInsList do if PlugIn.Id=plid then
  begin
    result:=PlugIn;
    break;
  end;
end;

procedure TPlugIn.OnClick(Sender: TObject);
begin
  if assigned(PlugInCmd) then PlugInCmd(Self);
end;

function GetPlugInList:boolean;
var
  s:string;
  L:TStringList;
  PlugIn:TPlugIn;
begin
  result:=false;
  if assigned(PlugInsList) then FreeAndNil(PlugInsList);
  PlugInsList:=TPlugInsList.Create(true);
  L:=FindAllFiles(ConfigDir+'plugins','*.ini');
  try
    For s in L do
    begin
      PlugIn:=TPlugIn.Create(s);
      if PlugIn.IsValid then
        PlugInsList.Add(PlugIn)
      else
        PlugIn.Free;
    end;
  finally
    if assigned(L) then FreeAndNil(L);
  end;
end;

function TestforPlugIn(s,d:string):TPlugIn;
var
  PlugIn:TPlugIn;
  Inis:TStringList;
begin
  result:=nil;
  if FileSize(s)<1 then
  begin
    Info('TestforPlugIn','Invalid or missing PlugIn file');
    exit(nil);
  end;
  ForceDirectory(d);
  if DirectoryIsWritable(d) then
  begin
    Info('TestforPlugIn Unzipping',s+' in '+d);
    if UnZip(s,d) then
    begin
      Inis:=FindAllFiles(d,'*.ini');
      if Inis.Count>0 then
      begin
        If Inis.Count>1 then Info('TestforPlugIn Warning there ir more of one ini file',Inis);
        PlugIn:=TPlugIn.Create(Inis[0]);
        if PlugIn.IsValid then result:=PlugIn;
      end;
      Inis.Free;
    end;
    if result=nil then DirDelete(d);
  end;
end;

end.

