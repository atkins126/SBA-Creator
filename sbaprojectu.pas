unit SBAProjectU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, fileutil, strutils, Dialogs;

const
  cSBABaseZipFile='sbamaster.zip';
  cSBADefaultPrjName='NewProject';
  cSBAPrjExt='.sba';
  cPrjName='%name%';
  cPrjLoc='%location%';
  cPrjTitle='%title%';
  cPrjAuthor='%author%';
  cPrjVersion='%version%';
  cPrjDate='%date%';
  cPrjDescrip='%description%';
  cPrjInterface='%interface%';
  cPrjIpcores='%ipcores%';

type

  { TSBAPrj }

  TSBAPrj=class(TObject)
    name:string;
    location:string;
    loclib:string;
    title:string;
    author:string;
    version:string;
    date:string;
    description:string;
    libcores:tstringlist;
    ports:tstringlist;
    constructor Create;
    destructor Destroy; override;
    function Fill(PrjData:string):boolean;
  end;

var
  SBAPrj:TSBAPrj=nil;

function CreateNewProject(PrjData:String):boolean;
function CustomizeFiles:boolean;

implementation

uses DebugFormU,ConfigFormU;

function CustomizeFiles: boolean;
var
  FL,SL,IP:TStringList;
  i:integer;
begin
  result:=false;
  With SBAPrj do try
    FL:=TStringList.Create;
    SL:=TStringList.Create;
    IP:=TStringList.Create;
    for i:=0 to libcores.Count-1 do
    begin
      if DirectoryExistsUTF8(LibraryDir+libcores[i]) then
      begin
        IP.add(Format('  %0:s: entity work.%0:s',[libcores[i]]));
        IP.add('  port map(');
        IP.add('    RST_I => RSTi,');
        IP.add('    CLK_I => CLKi,');
        IP.add('    DAT_I => DATOi,');
        IP.add('    DAT_O => DAT_'+libcores[i]+',');
        IP.add('    ADR_I => ADRi,');
        IP.add('    STB_I => STBi(STB_'+libcores[i]+'),');
        IP.add('    WE_I  => WEi,');
        IP.add('    -------------');
        IP.add('  );');
        IP.add('');
      end;
    end;
    FL.Add(location+name+'_Top.vhd');
    FL.Add(location+name+'_SBAcfg.vhd');
    FL.Add(location+name+'_SBActrlr.vhd');
    FL.Add(location+name+'_SBAdcdr.vhd');
    for i:=0 to FL.Count-1 do
    begin
      SL.LoadFromFile(FL[i]);
      SL.text:=StringReplace(SL.text, cPrjName, name, [rfReplaceAll]);
      SL.text:=StringReplace(SL.text, cPrjTitle, title, []);
      SL.text:=StringReplace(SL.text, cPrjAuthor, author, []);
      SL.text:=StringReplace(SL.text, cPrjVersion, version, []);
      SL.text:=StringReplace(SL.text, cPrjDate, date, []);
      SL.text:=StringReplace(SL.text, cPrjDescrip, description, []);
      if i=0 then
      begin
        SL.text:=StringReplace(SL.text, cPrjInterface, ports.text, []);
        SL.text:=StringReplace(SL.text, cPrjIpcores, IP.text, []);
      end;
      SL.SaveToFile(FL[i]);
    end;
    result:=true;
  finally
    if assigned(IP) then FreeAndNil(IP);
    if assigned(SL) then FreeAndNil(SL);
    if assigned(FL) then FreeAndNil(FL);
  end;
end;

function CreateNewProject(PrjData:String):boolean;
var
  J:TJSONData;
  SL:TStringList;
  PrjName:String;
  PrjLocation:String;
  PrjLocLib:String;
  S:String;
  i:integer;
begin
  result:=false;
  try
    SL:=TStringList.Create;
    SL.Text:=PrjData;
    J:=GetJSON(ReplaceStr(PrjData,'\','/'));
    PrjName:=J.FindPath('name').AsString;
    PrjLocation:=AppendPathDelim(TrimFilename(J.FindPath('location').AsString));
    PrjLocLib:=AppendPathDelim(TrimFilename(PrjLocation+'lib'));
    If (not DirectoryExistsUTF8(PrjLocation)) and (not CreateDirUTF8(PrjLocation)) Then
    begin
      ShowMessage('Failed to create SBA project folder: '+PrjLocation);
      exit;
    end;
    try
      CreateDirUTF8(PrjLocLib);
      SL.SaveToFile(PrjLocation+PrjName+cSBAPrjExt);
      CopyFile(SBAbaseDir+'Top.vhd',PrjLocation+PrjName+'_Top.vhd');
      CopyFile(SBAbaseDir+'SBAcfg.vhd',PrjLocation+PrjName+'_SBAcfg.vhd');
      CopyFile(SBAbaseDir+'SBActrlr.vhd',PrjLocation+PrjName+'_SBActrlr.vhd');
      CopyFile(SBAbaseDir+'SBAdcdr.vhd',PrjLocation+PrjName+'_SBAdcdr.vhd');
      CopyFile(SBAbaseDir+'SBApkg.vhd',PrjLocLib+'SBApkg.vhd');
      CopyFile(SBAbaseDir+'Syscon.vhd',PrjLocLib+'Syscon.vhd');
      CopyFile(SBAbaseDir+'DataIntf.vhd',PrjLocLib+'DataIntf.vhd');
      if LibAsReadOnly then
      begin
        FileSetAttr(PrjLocLib+'SBApkg.vhd',faReadOnly);
        FileSetAttr(PrjLocLib+'Syscon.vhd',faReadOnly);
        FileSetAttr(PrjLocLib+'DataIntf.vhd',faReadOnly);
      end;
      if not J.FindPath('ipcores').IsNull then
        with J.FindPath('ipcores') do For i:=0 to count-1 do
        begin
          S:=Items[i].AsString;
          CopyFile(LibraryDir+S+PathDelim+S+'.vhd',PrjLocLib+S+'.vhd');
          if LibAsReadOnly then FileSetAttr(PrjLocLib+S+'.vhd',faReadOnly);
        end;
      result:=SBAPrj.Fill(PrjData) and CustomizeFiles;
    except
      on E:Exception do
      begin
        ShowMessage('Failed to create all SBA project files: '+E.Message);
        exit;
      end;
    end;
  finally
    if assigned(J) then FreeAndNil(J);
    if assigned(SL) then FreeAndNil(SL);
  end;
end;

{ TSBAPrj }

constructor TSBAPrj.Create;
begin
  inherited Create;
  name:='';
  libcores:=TStringList.create;
  ports:=tstringlist.create;
end;

destructor TSBAPrj.Destroy;
begin
  if assigned(libcores) then FreeAndNil(libcores);
  if assigned(ports) then FreeAndNil(ports);
  inherited Destroy;
end;

function TSBAPrj.Fill(PrjData: string): boolean;
var
  J:TJSONData;
  i:integer;
  S:string;
begin
  result:=false;
  name:='';
  libcores.Clear;
  ports.Clear;
  try
    J:=GetJSON(ReplaceStr(PrjData,'\','/'));
  except
    on E:Exception do
    begin
      ShowMessage('The is an error in the project data, exiting...');
      exit;
    end;
  end;
  try
    name:=J.FindPath('name').AsString;
    location:=AppendPathDelim(TrimFilename(J.FindPath('location').AsString));
    loclib:=AppendPathDelim(TrimFilename(SBAPrj.location+'lib'));
    title:=J.FindPath('title').AsString;
    author:=J.FindPath('author').AsString;
    version:=J.FindPath('version').AsString;
    date:=J.FindPath('date').AsString;
    description:=J.FindPath('description').AsString;
    description:=wraptext(description,LineEnding+'-- ',[' '],60);
    if not J.FindPath('ipcores').IsNull then
      with J.FindPath('ipcores') do For i:=0 to count-1 do
        libcores.Add(Items[i].AsString);
    if not J.FindPath('interface').IsNull then
      For i:=0 to J.FindPath('interface').count-1 do with J.FindPath('interface').Items[i] do
      begin
        if FindPath('bus').AsInteger=1 then
          S:='std_logic_vector('+FindPath('msb').AsString+' downto '+FindPath('lsb').AsString+')'
        else
          S:='std_logic';
        S:=Format('  %0:-10s: %1:-3s %s',[FindPath('portname').AsString,FindPath('dir').AsString,S]);
        if (i<J.FindPath('interface').count-1) then S+=';';
        ports.Add(S);
      end;
    result:=true;
  finally
    if assigned(J) then FreeAndNil(J);
  end;
end;

end.

