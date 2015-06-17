unit SBAProjectU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs,
  fpjson, jsonparser,
  fileutil, strutils, Inifiles;

const
  cSBABaseZipFile='sbamaster.zip';
  cSBADefaultPrjName='NewProject';
  cSBAPrjExt='.sba';
  cSBATop='Top.vhd';
  cSBAcfg='SBAcfg.vhd';
  cSBAdcdr='SBAdcdr.vhd';
  cSBActrlr='SBActrlr.vhd';
  cSBApkg='SBApkg.vhd';
  cSyscon='Syscon.vhd';
  cDataIntf='DataIntf.vhd';
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
  cPrjDcdr='%dcdr%';

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
    userfiles:tstringlist;
    ports:tstringlist;
    Modified:boolean;
    PrjData:string;
    //UserTreeNode:ttreenode;
    constructor Create;
    destructor Destroy; override;
    function Fill(Data: string): boolean;
  public
    function PrepareNewFolder: boolean;
    function CustomizeFiles:boolean;
    procedure SaveAs(f: String);
    procedure Save;
    procedure LoadIPData(ipname,instance:String; IP,IPS,STL,AML,DCL:TStrings);
    procedure LoadIPData(ipname: String; IP,IPS,STL,AML,DCL:TStrings);
    function GetConfigConst(sl: TStrings): string;
    function EditLib:boolean;
    procedure CopyIPCoreFiles(cl: TStrings);
    function RemoveCore(c:string):boolean;
    function CleanUpLibCores(CL: TStrings): boolean;
    function AddUserFile(f:string):boolean;
    function RemUserFile(f:string):boolean;
    function GetUserFilePath(f:string):string;
    function GetAllFileNames(vhdonly:boolean=true):string;
  end;

var
  SBAPrj:TSBAPrj=nil;


implementation

uses DebugFormU, prjWizU, ConfigFormU, CoresPrjEdFormU, UtilsU;

var AM:integer=0; //Address Map

{ TSBAPrj }

constructor TSBAPrj.Create;
begin
  inherited Create;
  name:='';
  PrjData:='';
  libcores:=TStringList.create;
  userfiles:=TStringList.create;
  ports:=tstringlist.create;
  modified:=false;
end;

destructor TSBAPrj.Destroy;
begin
  if assigned(userfiles) then FreeAndNil(userfiles);
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
  userfiles.Clear;
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
    loclib:=AppendPathDelim(TrimFilename(location+'lib'));
    title:=J.FindPath('title').AsString;
    author:=J.FindPath('author').AsString;
    version:=J.FindPath('version').AsString;
    date:=J.FindPath('date').AsString;
    description:=J.FindPath('description').AsString;
    description:=wraptext(description,LineEnding+'-- ',[' '],60);
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
    try if not J.FindPath('ipcores').IsNull then
      with J.FindPath('ipcores') do For i:=0 to J.FindPath('ipcores').count-1 do
        libcores.Add(Items[i].AsString);
    except
      ON E:Exception do libcores.Clear;
    end;
    try if not J.FindPath('userfiles').IsNull then
      with J.FindPath('userfiles') do For i:=0 to J.FindPath('userfiles').count-1 do
        userfiles.Add(Items[i].AsString);
    except
      ON E:Exception do userfiles.Clear;
    end;
    PrjData:=Data;
    result:=true;
  finally
    if assigned(J) then FreeAndNil(J);
  end;
end;

function TSBAPrj.EditLib: boolean;
var Prj:TSBAPrj;
begin
  result:=false;
  Prj:=Self;
  if CoresPrjEdForm.CoresEdit(Prj) then
  begin
    CleanUpLibCores(CoresPrjEdForm.PrjIpCoreList.Items);
    result:=true;
  end;
end;

{ TODO : Falta la copia y borrado de archivos de usuario de folder user}
function TSBAPrj.AddUserFile(f: string): boolean;
var
  NewData:string;
begin
  result:=false;
  if fileexistsUTF8(f) then
  if UserFiles.IndexOfName(ExtractFileName(f))=-1 then
  begin
    UserFiles.Append(ExtractFileName(f)+'='+extractfilepath(f));
    prjWizForm.ResetFormData;
    prjWizForm.FillPrjWizValues(PrjData);
    prjWizForm.UserFileList.Strings.Assign(UserFiles);
    NewData:=prjWizForm.CollectData;
    PrjData:=NewData;
    Save;
    result:=true;
  end else ShowMessage('The file is already in the list')
  else ShowMessage('The user file: '+f+',could not be found.');
end;

function TSBAPrj.RemUserFile(f: string): boolean;
var
  i:integer;
  NewData:string;
begin
  result:=false;
  i:=UserFiles.IndexOfName(f);
  if i<>-1 then
  try
    UserFiles.Delete(i);
    prjWizForm.ResetFormData;
    prjWizForm.FillPrjWizValues(PrjData);
    prjWizForm.UserFileList.Strings.Assign(UserFiles);
    NewData:=prjWizForm.CollectData;
    PrjData:=NewData;
    Save;
    result:=true;
  except
    on E:Exception do ShowMessage(E.Message);
  end;
end;

function TSBAPrj.GetUserFilePath(f: string): string;
begin
  result:=UserFiles.Values[f];
end;

function TSBAPrj.GetAllFileNames(vhdonly: boolean): string;
var
  S,R:string;
  i:integer;
begin
  S:=loclib+cSBApkg+' ';
  S+=loclib+cSyscon+' ';
  S+=loclib+cDataIntf+' ';
  if libcores.Count>0 then for R in libcores do
    S+=loclib+R+'.vhd ';
  if userfiles.Count>0 then for i:=0 to userfiles.Count-1 do
    if not vhdonly or (extractfileext(userfiles.names[i])='.vhd') then
      S+=userfiles.ValueFromIndex[i]+userfiles.names[i]+' ';
  S+=location+name+'_'+cSBAcfg+' ';
  S+=location+name+'_'+cSBAdcdr+' ';
  S+=location+name+'_'+cSBActrlr+' ';
  S+=location+name+'_'+cSBATop;
  Result:=S;
end;

function TSBAPrj.PrepareNewFolder:boolean;
var
  SL:TStringList;
begin
  result:=false;
  if name='' then exit;
  If (not DirectoryExistsUTF8(Location)) and (not CreateDirUTF8(Location)) Then
  begin
    ShowMessage('Failed to create SBA project folder: '+Location);
    exit;
  end;
  try
    try
      SL:=TStringList.Create;
      SL.Text:=PrjData;
      SL.SaveToFile(Location+Name+cSBAPrjExt);
    finally
      if assigned(SL) then FreeAndNil(SL);
    end;
    CopyFile(SBAbaseDir+cSBATop,Location+Name+'_'+cSBATop);
    CopyFile(SBAbaseDir+cSBAcfg,Location+Name+'_'+cSBAcfg);
    CopyFile(SBAbaseDir+cSBAdcdr,Location+Name+'_'+cSBAdcdr);
    CopyFile(SBAbaseDir+cSBActrlr,Location+Name+'_'+cSBActrlr);
    CreateDirUTF8(LocLib);
    CopyFile(SBAbaseDir+cSBApkg,LocLib+cSBApkg);
    CopyFile(SBAbaseDir+cSyscon,LocLib+cSyscon);
    CopyFile(SBAbaseDir+cDataIntf,LocLib+cDataIntf);
    if LibAsReadOnly then
    begin
      FileSetAttr(LocLib+cSBApkg,faReadOnly);
      FileSetAttr(LocLib+cSyscon,faReadOnly);
      FileSetAttr(LocLib+cDataIntf,faReadOnly);
    end;
    CopyIPCoreFiles(libcores);
    CreateDirUTF8(Location+'user');
    result:= CustomizeFiles;
  except
    on E:Exception do
    begin
      ShowMessage('Failed to create SBA project files: '+E.Message);
      exit;
    end;
  end;
end;

function TSBAPrj.CustomizeFiles: boolean;
var
  FL,SL,IP,IPS,STL,AML,DCL:TStringList;
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
    DCL:=TStringList.Create;
    for i:=0 to libcores.Count-1 do LoadIPData(libcores[i],IP,IPS,STL,AML,DCL);
    FL.Add(location+name+'_'+cSBATop);
    FL.Add(location+name+'_'+cSBAcfg);
    FL.Add(location+name+'_'+cSBAdcdr);
    FL.Add(location+name+'_'+cSBActrlr);
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
        2:begin //SBAdcdr
          SL.text:=StringReplace(SL.text, cPrjDcdr, DCL.text, []);
        end;
      end;
      SL.SaveToFile(FL[i]);
    end;
    result:=true;
  finally
    if assigned(DCL) then FreeAndNil(DCL);
    if assigned(AML) then FreeAndNil(AML);
    if assigned(STL) then FreeAndNil(STL);
    if assigned(IPS) then FreeAndNil(IPS);
    if assigned(IP) then FreeAndNil(IP);
    if assigned(SL) then FreeAndNil(SL);
    if assigned(FL) then FreeAndNil(FL);
  end;
end;

function TSBAPrj.RemoveCore(c: string): boolean;
begin
  result:=false;
  //NO implementado
end;

procedure TSBAPrj.LoadIPData(ipname: String; IP,IPS,STL,AML,DCL:TStrings);
begin
  LoadIPData(ipname,ipname,IP,IPS,STL,AML,DCL);
end;

function TSBAPrj.GetConfigConst(sl:TStrings): string;
var
  s,k,v:string;
begin
  result:='';
  if sl.Count=0 then exit;
  for s in sl do if AnsiStartsText('Constant',Trim(s)) then
  begin
    k:=ExtractWord(2,s,StdWordDelims);
    v:=ExtractWord(5,s,StdWordDelims);
    result+=Format('%s=%s',[k,v])+#10;
  end;
end;

procedure TSBAPrj.LoadIPData(ipname,instance: String; IP,IPS,STL,AML,DCL:TStrings);
// ipname: name of the ipcore
// IP: instance of the ipcore
// IPS: additionals signals
// STL: strobe lines
// AML: address map
// DCL: decoder lines
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

    IP.add(Format('  %0:s: entity work.%1:s',[instance,ipname]));
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
    if STB then   IP.add('    STB_I => STBi(STB_'+instance+'),');
    if ADL>0 then IP.add('    ADR_I => ADRi,');
    if WE then    IP.add('    WE_I  => WEi,');
    if DIL>0 then IP.add('    DAT_I => DATOi,');
    if DOL>0 then IP.add('    DAT_O => DAT_'+instance+',');
    IP.add('    -------------');
    if IL.Count>0 then for i:=0 to IL.Count-1 do
      IP.add(Format('    %:-8s=> %s',[IL.names[i],IL.ValueFromIndex[i]])+
      IfThen(i<IL.Count-1,','));
    IP.add('  );');
    IP.add('');
    if DOL>0 then
    begin
      IP.add(Format('  %:sDataIntf: entity work.DataIntf',[instance]));
      IP.add('  port map(');
      IP.add('    STB_I => STBi(STB_'+instance+'),');
      IP.add('    DAT_I => DAT_'+instance+',');
      IP.add('    DAT_O => DATIi');
      IP.add('  );');
      IP.add('');
      IPS.add(Format('  Signal %:-11s: DATA_type;',['DAT_'+instance]));
    end;
    if STB then STL.add(Format('  Constant %:-11s: integer := %d;',['STB_'+instance,STL.count]));
    if SL.Count>0 then for i:=0 to SL.Count-1 do
      IPS.add(Format('  Signal %:-11s: %s;',[SL.names[i],SL.ValueFromIndex[i]]));
    if AL.Count>0 then
    begin
      f:=AL.ValueFromIndex[0];
      if (f<>'X') then
      begin
        ADL:=StrtoIntDef(f,0);
        if (ADL=0) and ((AM mod 2)=1) then inc(AM);
      end;
      for i:=0 to AL.Count-1 do
      begin
        AML.Add(Format('  Constant %:-11s: integer := %d;',[AL.Names[i],AM]));
        DCL.Add(Format('     When %:-20s=> STBi <= stb(%s);',[AL.Names[i],'STB_'+instance]));
        inc(AM);
  { TODO : Calcular AM en base al offset dado en la sección Address del INI }
  {     When RAM0 to RAM0+255        => STBi <= stb(STB_RAM0);  -- RAM0, (x000 - x0FF)}
      end;
    end;
  finally
    if assigned(SL) then FreeAndNil(SL);
    if assigned(IL) then FreeAndNil(IL);
    if assigned(AL) then FreeAndNil(AL);
    if assigned(CL) then FreeAndNil(CL);
    if assigned(GL) then FreeAndNil(GL);
  end;
end;

procedure TSBAPrj.CopyIPCoreFiles(cl:TStrings);
var
  s:string;
  Ini:TINIFile;
  l:TStringList;
begin
  if cl.Count=0 then exit;
  for s in cl do if not fileExistsUTF8(LibraryDir+S+PathDelim+s+'.vhd') then
  begin
    ShowMessage('The IP Core file: '+LibraryDir+S+PathDelim+s+'.vhd was not found.');
    exit;
  end else
  begin
    if not FileExistsUTF8(LocLib+s+'.vhd') then
    begin
infoln('Copiando: '+LibraryDir+S+PathDelim+s+'.vhd');
      CopyFile(LibraryDir+S+PathDelim+s+'.vhd',LocLib+s+'.vhd');
      if LibAsReadOnly then FileSetAttr(LocLib+s+'.vhd',faReadOnly);
    end;
    try
      Ini:=TIniFile.Create(LibraryDir+S+PathDelim+s+'.ini');
      l:=TStringList.Create;
      l.CommaText:=Ini.ReadString('Requirements','IPCores','');
      CopyIPCoreFiles(l);
    finally
      Ini.Free;
      if assigned(l) then freeandnil(l);
    end;
  end;
end;

//function TSBAPrj.CleanUpLibCores(CL:TStrings): boolean;
//var
//  s,NewData:string;
//begin
//  result:=false;
//  prjWizForm.ResetFormData;
//  prjWizForm.FillPrjWizValues(PrjData);
//  prjWizForm.PrjIpCoreList.Items.Assign(CL);
//  NewData:=prjWizForm.CollectData;
//  for s in libcores do if CL.IndexOf(s)=-1 then
//  begin
//    FileSetAttr(LocLib+s+'.vhd',faArchive);
//    DeleteFileUTF8(loclib+s+'.vhd');
//  end;
//  CopyIPCoreFiles(CL);
//  libcores.Assign(CL);
//  PrjData:=NewData;
//  Save;
//  result:=true;
//end;

function TSBAPrj.CleanUpLibCores(CL:TStrings): boolean;
var
  s,n,NewData:string;
  l:TStringList;
begin
  result:=false;
  prjWizForm.ResetFormData;
  prjWizForm.FillPrjWizValues(PrjData);
  prjWizForm.PrjIpCoreList.Items.Assign(CL);
  NewData:=prjWizForm.CollectData;
  try
    l:=FindAllFiles(LocLib,'*.vhd');
    for s in l do
    begin
      n:=extractfilenameonly(s);
      if not AnsiMatchText(n,[cSBApkg,cSyscon,cDataIntf]) and (CL.IndexOf(n)=-1) then
      begin
        FileSetAttr(s,faArchive);
infoln('Borrando: '+s);
        DeleteFileUTF8(s);
      end;
    end;
  finally
    if assigned(l) then FreeAndNil(l);
  end;
  CopyIPCoreFiles(CL);
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

