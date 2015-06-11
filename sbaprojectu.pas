unit SBAProjectU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, jsonparser, fileutil, strutils, Dialogs, Inifiles;

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
  cPrjIpCSgnls='%ipcoressignals%';
  cPrjSTB='%stblines%';
  cPrjAddress='%addressmap%';

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
    Modified:boolean;
    PrjData:string;
    constructor Create;
    destructor Destroy; override;
    function Fill(Data: string): boolean;
  private
  public
    function PrepareNewFolder: boolean;
    function CustomizeFiles:boolean;
    function CleanUpLibCores(CL: TStrings): boolean;
    procedure SaveAs(f: String);
    procedure Save;
    procedure LoadIPData(ipname: String; IP, IPS, STL, AML: TStrings);
  end;

var
  SBAPrj:TSBAPrj=nil;


implementation

uses DebugFormU, prjWizU, ConfigFormU;

var AM:integer=0; //Address Map

{ TSBAPrj }

constructor TSBAPrj.Create;
begin
  inherited Create;
  name:='';
  PrjData:='';
  libcores:=TStringList.create;
  ports:=tstringlist.create;
  modified:=false;
end;

destructor TSBAPrj.Destroy;
begin
  if assigned(libcores) then FreeAndNil(libcores);
  if assigned(ports) then FreeAndNil(ports);
  inherited Destroy;
end;

function TSBAPrj.Fill(Data: string): boolean;
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
    J:=GetJSON(ReplaceStr(Data,'\','/'));
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
    PrjData:=Data;
    result:=true;
  finally
    if assigned(J) then FreeAndNil(J);
  end;
end;

function TSBAPrj.PrepareNewFolder:boolean;
var
  S:String;
  i:integer;
  SL:TStringList;
begin
  result:=false;
  if SBAPrj.name='' then exit;
  If (not DirectoryExistsUTF8(SBAPrj.Location)) and (not CreateDirUTF8(SBAPrj.Location)) Then
  begin
    ShowMessage('Failed to create SBA project folder: '+SBAPrj.Location);
    exit;
  end;
  with SBAPrj do
  try
    try
      SL:=TStringList.Create;
      SL.Text:=PrjData;
      SL.SaveToFile(Location+Name+cSBAPrjExt);
    finally
      if assigned(SL) then FreeAndNil(SL);
    end;
    CopyFile(SBAbaseDir+'Top.vhd',Location+Name+'_Top.vhd');
    CopyFile(SBAbaseDir+'SBAcfg.vhd',Location+Name+'_SBAcfg.vhd');
    CopyFile(SBAbaseDir+'SBActrlr.vhd',Location+Name+'_SBActrlr.vhd');
    CopyFile(SBAbaseDir+'SBAdcdr.vhd',Location+Name+'_SBAdcdr.vhd');
    CreateDirUTF8(LocLib);
    CopyFile(SBAbaseDir+'SBApkg.vhd',LocLib+'SBApkg.vhd');
    CopyFile(SBAbaseDir+'Syscon.vhd',LocLib+'Syscon.vhd');
    CopyFile(SBAbaseDir+'DataIntf.vhd',LocLib+'DataIntf.vhd');
    if LibAsReadOnly then
    begin
      FileSetAttr(LocLib+'SBApkg.vhd',faReadOnly);
      FileSetAttr(LocLib+'Syscon.vhd',faReadOnly);
      FileSetAttr(LocLib+'DataIntf.vhd',faReadOnly);
    end;
    if libcores.count>0 then For i:=0 to libcores.count-1 do
      begin
        S:=libcores[i];
        CopyFile(LibraryDir+S+PathDelim+S+'.vhd',LocLib+S+'.vhd');
        if LibAsReadOnly then FileSetAttr(LocLib+S+'.vhd',faReadOnly);
      end;
    result:= CustomizeFiles;
  except
    on E:Exception do
    begin
      ShowMessage('Failed to create all SBA project files: '+E.Message);
      exit;
    end;
  end;
end;

function TSBAPrj.CustomizeFiles: boolean;
var
  FL,SL,IP,IPS,STL,AML:TStringList;
  i:integer;
begin
  result:=false;
  try
    FL:=TStringList.Create;
    SL:=TStringList.Create;
    IP:=TStringList.Create;
    IPS:=TStringList.Create;
    STL:=TStringList.Create;
    AML:=TStringList.Create;
    for i:=0 to libcores.Count-1 do LoadIPData(libcores[i],IP,IPS,STL,AML);
    FL.Add(location+name+'_Top.vhd');
    FL.Add(location+name+'_SBAcfg.vhd');
    FL.Add(location+name+'_SBAdcdr.vhd');
    FL.Add(location+name+'_SBActrlr.vhd');
    for i:=0 to FL.Count-1 do
    begin
      SL.LoadFromFile(FL[i]);
      SL.text:=StringReplace(SL.text, cPrjName, name, [rfReplaceAll]);
      SL.text:=StringReplace(SL.text, cPrjTitle, title, []);
      SL.text:=StringReplace(SL.text, cPrjAuthor, author, []);
      SL.text:=StringReplace(SL.text, cPrjVersion, version, []);
      SL.text:=StringReplace(SL.text, cPrjDate, date, []);
      SL.text:=StringReplace(SL.text, cPrjDescrip, description, []);
      case i of
        0:begin //Top
          SL.text:=StringReplace(SL.text, cPrjInterface, ports.text, []);
          SL.text:=StringReplace(SL.text, cPrjIpcores, IP.text, []);
          SL.text:=StringReplace(SL.text, cPrjIpCSgnls, IPS.text, []);
        end;
        1:begin //SBAconfig
            SL.text:=StringReplace(SL.text, cPrjSTB, STL.text, []);
            SL.text:=StringReplace(SL.text, cPrjAddress, AML.text, []);
        end;
      end;
      SL.SaveToFile(FL[i]);
    end;
    result:=true;
  finally
    if assigned(AML) then FreeAndNil(AML);
    if assigned(STL) then FreeAndNil(STL);
    if assigned(IPS) then FreeAndNil(IPS);
    if assigned(IP) then FreeAndNil(IP);
    if assigned(SL) then FreeAndNil(SL);
    if assigned(FL) then FreeAndNil(FL);
  end;
end;

procedure TSBAPrj.LoadIPData(ipname: String; IP, IPS, STL, AML: TStrings);
var
  INI:TINIFile;
  GL,CL,AL,IL,SL:TStringList;
  f:String;
  i:integer;
  DIL,DOL,ADL:Integer;
  WE,STB:boolean;
begin
  ADL:=1;
  DIL:=16;
  DOL:=16;
  WE:=true;
  STB:=true;
  if DirectoryExistsUTF8(LibraryDir+ipname) then
  try
    GL:=TStringList.Create;
    CL:=TStringList.Create;
    AL:=TStringList.Create;
    IL:=TStringList.Create;
    SL:=TStringList.Create;
    f:=LibraryDir+ipname+PathDelim+ipname+'.ini';
    if fileexistsUTF8(f) then
    try
      INI:=TIniFile.Create(f);
      INI.ReadSectionRaw('Generic',GL);
      INI.ReadSectionRaw('Config',CL);
      INI.ReadSectionRaw('Address',AL);
      INI.ReadSectionRaw('Interface',IL);
      INI.ReadSectionRaw('Signals',SL);
      if StrToIntDef(CL.Values['SBAPORTS'],1)=1 then
      begin
        WE:=StrToIntDef(CL.Values['WE'],1)=1;
        STB:=StrToIntDef(CL.Values['STB'],1)=1;
        ADL:=StrToIntDef(CL.Values['ADRLINES'],1);
        DIL:=StrToIntDef(CL.Values['DATILINES'],16);
        DOL:=StrToIntDef(CL.Values['DATOLINES'],16);
      end else
      begin
        ADL:=1;
        DIL:=16;
        DOL:=16;
      end;
    finally
      if assigned(INI) then FreeAndNil(INI);
    end;

    IP.add(Format('  %0:s: entity work.%0:s',[ipname]));
    if GL.Count>0 then
    begin
      IP.add('  generic map(');
      for i:=0 to GL.Count-1 do IP.add('    '+
        Format('%:-8s=> %s',[GL.names[i],GL.ValueFromIndex[i]])+
        IfThen(i<GL.Count-1,','));
      IP.add('  )');
    end;
    IP.add('  port map(');
    IP.add('    -------------');
    IP.add('    RST_I => RSTi,');
    IP.add('    CLK_I => CLKi,');
    if STB then   IP.add('    STB_I => STBi(STB_'+ipname+'),');
    if ADL>0 then IP.add('    ADR_I => ADRi,');
    if WE then    IP.add('    WE_I  => WEi,');
    if DIL>0 then IP.add('    DAT_I => DATOi,');
    if DOL>0 then IP.add('    DAT_O => DAT_'+ipname+',');
    IP.add('    -------------');
    if IL.Count>0 then for i:=0 to IL.Count-1 do
      IP.add(Format('    %:-8s=> %s',[IL.names[i],IL.ValueFromIndex[i]])+
      IfThen(i<IL.Count-1,','));
    IP.add('  );');
    IP.add('');
    if DOL>0 then
    begin
      IP.add(Format('  %:sDataIntf: entity work.DataIntf',[ipname]));
      IP.add('  port map(');
      IP.add('    STB_I => STBi(STB_'+ipname+'),');
      IP.add('    DAT_I => DAT_'+ipname+',');
      IP.add('    DAT_O => DATIi');
      IP.add('  );');
      IP.add('');
      IPS.add(Format('  Signal %:-11s: DATA_type;',['DAT_'+ipname]));
    end;
    if STB then STL.add(Format('  Constant %:-11s: integer := %d;',['STB_'+ipname,STL.count]));
    if SL.Count>0 then for i:=0 to SL.Count-1 do
      IPS.add(Format('  Signal %:-11s: %s;',[SL.names[i],SL.ValueFromIndex[i]]));
    if AL.Count>0 then for i:=0 to AL.Count-1 do
    begin
      if (AL.ValueFromIndex[i]='0') and ((AM mod 2)=1) then inc(AM);
      AML.Add(Format('  Constant %:-11s: integer := %d;',[AL.Names[i],AM]));
      inc(AM);
{ TODO : Calcular AM en base al offset dado en la sección Address del INI }
    end;
  finally
    if assigned(SL) then FreeAndNil(SL);
    if assigned(IL) then FreeAndNil(IL);
    if assigned(AL) then FreeAndNil(AL);
    if assigned(CL) then FreeAndNil(CL);
    if assigned(GL) then FreeAndNil(GL);
  end;
end;

function TSBAPrj.CleanUpLibCores(CL:TStrings): boolean;
var
  s,NewData:string;
begin
  result:=false;
  prjWizForm.ResetFormData;
  prjWizForm.FillPrjWizValues(PrjData);
  prjWizForm.PrjIpCoreList.Items.Assign(CL);
  NewData:=prjWizForm.CollectData;
  for s in libcores do if CL.IndexOf(s)=-1 then
  begin
    FileSetAttr(LocLib+s+'.vhd',faArchive);
    DeleteFileUTF8(loclib+s+'.vhd');
  end;
  for s in CL do if libcores.IndexOf(s)=-1 then
  begin
    CopyFile(LibraryDir+S+PathDelim+s+'.vhd',LocLib+s+'.vhd');
    if LibAsReadOnly then FileSetAttr(LocLib+s+'.vhd',faReadOnly);
  end;
  libcores.Assign(CL);
  PrjData:=NewData;
  Save;
  result:=true;
end;

procedure TSBAPrj.SaveAs(f: String);
var
  SL:TStringList;
begin
  try
    SL:=TStringList.Create;
    SL.Text:=PrjData;
    SL.SaveToFile(f);
    Modified:=false;
  finally
    if assigned(SL) then FreeAndNil(SL);
  end;
end;

procedure TSBAPrj.Save;
begin
  SaveAs(Location+Name+cSBAPrjExt);
end;

end.

