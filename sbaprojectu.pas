unit SBAProjectU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Controls,
  fpjson, jsonparser, fileutil, LazFileUtils, strutils,
  math;

const
  cSBADefaultPrjName='NewProject';
  CDefPrjTitle='Short title or description of the project';
  cSBAPrjExt='.sba';
  cSBATop='Top.vhd';
  cSBAcfg='SBAcfg.vhd';
  cSBAdcdr='SBAdcdr.vhd'; // SBA v1.1
  cSBAmux='SBAmux.vhd';   // SBA v1.2
  cSBActrlr='SBActrlr.vhd';
  cSBApkg='SBApkg.vhd';
  cSyscon='Syscon.vhd';
  cDataIntf='DataIntf.vhd';
  cPrjName='%name%';
  cPrjLib='lib';
  cPrjUser='user';
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
  cPrjMux='%mux%';        // SBA v1.2
  cPrjDcdr='%dcdr%';

type

  { TSBAPrj }

  TSBAPrj=class(TObject)
    libcores:tstringlist;
    userfiles:tstringlist;
    ports:tstringlist;
    constructor Create;
    destructor Destroy; override;
  private
    Fauthor: string;
    Fdate: string;
    Fdescription: string;
    Fexplibfiles: boolean;
    Fexpmonolithic: boolean;
    Fexpuserfiles: boolean;
    Flocation: string;
    Floclib: string;
    Flocuser: string;
    FModified: boolean;
    Fname: string;
    FPrjFile: string;
    Ftitle: string;
    Fversion: string;
    FSBAver: integer;
    procedure CopyIPCoreFiles(cl: TStrings);
    procedure FillRequeriments(list, m: TStrings; var level:integer);
    procedure Setauthor(AValue: string);
    procedure Setdate(AValue: string);
    procedure Setdescription(AValue: string);
    procedure Setexplibfiles(AValue: boolean);
    procedure Setexpmonolithic(AValue: boolean);
    procedure Setexpuserfiles(AValue: boolean);
    procedure Setlocation(AValue: string);
    procedure SetModified(AValue: boolean);
    procedure Setname(AValue: string);
    procedure Settitle(AValue: string);
    procedure Setversion(AValue: string);
    procedure SetSBAversion(AValue: integer);
    procedure SetSBAversion(AValue: string);
  public
    function Open(f:string):boolean;
    function Close:boolean;
    function Fill(Data: string): boolean;
    function Collect:string;
    function PrepareNewFolder: boolean;
    function CustomizeFiles:boolean;
    function SaveAs(f: String):boolean;
    function Save:boolean;
    function PrjExport(ExportPath: string): boolean;
    procedure LoadIPData(ipname: String; IP,IPS,STL,AML,DCL,MXL:TStrings);
    function GetConfigConst(sl: TStrings): string;
    function EditLib:boolean;
    function RemoveCore(c:string):boolean;
    function UpdateCore(c: string): boolean;
    function CleanUpLibCores(CL: TStrings): boolean;
    function AddUserFile(f:string):boolean;
    function RemUserFile(f:string):boolean;
    function GetUserFilePath(f:string):string;
    function ListAllPrjFiles(vhdonly: boolean=true): tstringlist;
    function GetAllFileNames(dir: string; vhdonly: boolean=true): string;
    function GetSBAverStr:string;
  published
    property PrjFile:string read FPrjFile;
    property location:string read Flocation write Setlocation;
    property loclib:string read Floclib;
    property locuser:string read Flocuser;
    property Modified:boolean read FModified write SetModified;
    property expmonolithic:boolean read Fexpmonolithic write Setexpmonolithic;
    property explibfiles:boolean read Fexplibfiles write Setexplibfiles;
    property expuserfiles:boolean read Fexpuserfiles write Setexpuserfiles;
    property name:string read Fname write Setname;
    property title:string read Ftitle write Settitle;
    property author:string read Fauthor write Setauthor;
    property version:string read Fversion write Setversion;
    property SBAver:integer read FSBAver write SetSBAversion;
    property date:string read Fdate write Setdate;
    property description:string read Fdescription write Setdescription;
  end;

var
  SBAPrj:TSBAPrj=nil;

implementation

uses SBAIPCoresU, DebugU, ConfigFormU, CoresPrjEdFormU, UtilsU;

var AM:integer; //Address Map pointer


{ TSBAPrj }

constructor TSBAPrj.Create;
begin
  inherited Create;
  Fname:='';
  FLocation:='';
  Floclib:='';
  Flocuser:='';
  Fversion:='0.1.1';
  FPrjFile:='';
  FAuthor:='';
  FSBAver:=SBAversion;
  Fmodified:=false;
  Fexpmonolithic:=false;
  Fexplibfiles:=true;
  Fexpuserfiles:=true;
  libcores:=TStringList.create;
  userfiles:=TStringList.create;
  ports:=tstringlist.create;
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
  try
    J:=GetJSON(ReplaceStr(Data,'\','/'));
    if J=nil then exit;
  except
    on E:Exception do
    begin
      ShowMessage('The is an error in the SBA project data, exiting the parse process...');
      exit;
    end;
  end;
  try
    Fname:='';
    Fmodified:=true;
    ports.Clear;
    libcores.Clear;
    userfiles.Clear;
    try
      Fname:=J.FindPath('name').AsString;
      Ftitle:=J.FindPath('title').AsString;
      Fauthor:=J.FindPath('author').AsString;
      Fversion:=J.FindPath('version').AsString;
      if J.FindPath('sbaversion')<>nil then
        SetSBAversion(J.FindPath('sbaversion').AsString)
      else
        SetSBAVersion(0);
      Fdate:=J.FindPath('date').AsString;
      Fdescription:=J.FindPath('description').AsString;
      if not J.FindPath('interface').IsNull then
      begin
        with J.FindPath('interface') do For i:=0 to count-1 do with Items[i] do
        begin
          S:=FindPath('portname').AsString+',';
          S+=FindPath('dir').AsString+',';
          S+=FindPath('bus').AsString+',';
          if FindPath('bus').AsInteger=1 then
          begin
            S+=FindPath('msb').AsString+',';
            S+=FindPath('lsb').AsString;
          end;
          ports.Append(S);
        end;
      end;
    except
      on E:Exception do
      begin
        ShowMessage('There is invalid data in the SBA project definition: '+E.Message);
        exit;
      end;
    end;
    try if not J.FindPath('ipcores').IsNull then
      with J.FindPath('ipcores') do For i:=0 to J.FindPath('ipcores').count-1 do
        libcores.Append(Items[i].AsString);
    except
      ON E:Exception do
      begin
        libcores.Clear;
        ShowMessage('The list of cores definitions is invalid.');
        exit;
      end;
    end;
    try if not J.FindPath('userfiles').IsNull then
      with J.FindPath('userfiles') do For i:=0 to J.FindPath('userfiles').count-1 do
        userfiles.Append(Items[i].AsString);
    except
      ON E:Exception do
      begin
        userfiles.Clear;
        ShowMessage('The list of user files is invalid.');
        exit;
      end;
    end;
    if J.FindPath('expmonolithic')=nil then Fexpmonolithic:=false else Fexpmonolithic:=J.FindPath('expmonolithic').AsBoolean;
    if J.FindPath('explibfiles')=nil then Fexplibfiles:=true else Fexplibfiles:=J.FindPath('explibfiles').AsBoolean;
    if J.FindPath('expuserfiles')=nil then Fexpuserfiles:=true else Fexpuserfiles:=J.FindPath('expuserfiles').AsBoolean;
    result:=true;
  finally
    if assigned(J) then FreeAndNil(J);
  end;
end;

function TSBAPrj.Collect:string;
var
  i:integer;
  S,SData:String;
begin
  SData:='{'#10+
            '"name": "'+Fname+'",'#10+
            '"title": "'+Ftitle+'",'#10+
            '"author": "'+Fauthor+'",'#10+
            '"version": "'+Fversion+'",'#10+
            '"sbaversion": "'+GetSBAverStr+'",'#10+
            '"date": "'+Fdate+'",'#10+
            '"description": "'+Fdescription+'",'#10+
            '"expmonolithic": '+IfThen(Fexpmonolithic,'true','false')+','#10+
            '"explibfiles": '+IfThen(Fexplibfiles,'true','false')+','#10+
            '"expuserfiles": '+IfThen(Fexpuserfiles,'true','false');
  S:='';
  for i:=0 to ports.Count-1 do
  begin
    S+=#9'{"portname": "'+ExtractDelimited(1,ports[i],[','])+'", '+
               '"dir": "'+ExtractDelimited(2,ports[i],[','])+'", '+
               '"bus": '+ExtractDelimited(3,ports[i],[',']);
    if ExtractDelimited(3,ports[i],[','])='1' then S+=', '+
               '"msb": '+ExtractDelimited(4,ports[i],[','])+', '+
               '"lsb": '+ExtractDelimited(5,ports[i],[',']);
    S+='},'#10;
  end;
  if S<>'' then SData+=','#10'"interface": ['#10+LeftStr(S, length(S)-2)+#10']'
    else SData+=','#10'"interface": null';
  S:='';
  if libcores.Count>0 then for i:=0 to libcores.Count-1 do S+=#9'"'+libcores[i]+'",'#10;
  if S<>'' then SData+=','#10'"ipcores": ['#10+LeftStr(S, length(S)-2)+#10']'
    else SData+=','#10'"ipcores": null';
  S:='';
  if userfiles.Count>0 then for i:=0 to userfiles.Count-1 do S+=#9'"'+userfiles[i]+'",'#10;
  if S<>'' then SData+=','#10'"userfiles": ['#10+LeftStr(S, length(S)-2)+#10']'#10
    else SData+=','#10'"userfiles": null'#10;
  SData+='}';
  result:=ReplaceStr(SData,'\','/');
end;

{ TODO : Falta la copia y borrado de archivos de usuario de folder user}
function TSBAPrj.AddUserFile(f: string): boolean;
begin
  result:=false;
  if fileexists(f) then
  if UserFiles.IndexOfName(ExtractFileName(f))=-1 then
  begin
    UserFiles.Append(ExtractFileName(f)+'='+extractfilepath(f));
    FModified:=true;
    result:=true;
  end else ShowMessage('The file '+f+' is already in the list')
  else ShowMessage('The user file: '+f+',could not be found.');
end;

function TSBAPrj.RemUserFile(f: string): boolean;
var
  i:integer;
  p:string;
begin
  result:=false;
  i:=UserFiles.IndexOfName(f);
  if i<>-1 then
  try
    UserFiles.Delete(i);
    FModified:=true;
    result:=true;
  except
    on E:Exception do ShowMessage(E.Message);
  end else
  begin
    p:=GetUserFilePath(f);
    if MessageDlg('Delete user file? ',f, mtConfirmation, [mbYes, mbNo], 0, mbYes) = mryes then
      result:=DeleteFile(p+f);
  end;
end;

function TSBAPrj.GetUserFilePath(f: string): string;
begin
  result:=UserFiles.Values[f];
  result:=IFTHEN(result='',FLocUser,result);
end;

function TSBAPrj.ListAllPrjFiles(vhdonly: boolean=true): tstringlist;
var
  r:string;
  i,level:integer;
  l,m:tstringlist;
begin
  l:=tstringlist.create;
  l.add(Floclib+cSBApkg);
  l.add(Floclib+cSyscon);
  if SBAversion=0 then l.add(Floclib+cDataIntf);
  if libcores.Count>0 then
  begin
    m:=tstringlist.create;
    level:=0;
    FillRequeriments(libcores,m,level);
    info('ListAllPrjFiles','Cores Requeriments:');
    info('',m);
    for r in m do l.add(Floclib+r+'.vhd');
    if assigned(m) then freeandnil(m);
  end;
  m:=FindAllFiles(Flocuser);
  for r in m do if userfiles.IndexOfName(ExtractFileName(r))=-1 then
    if not vhdonly or (extractfileext(r)='.vhd') then
      l.add(r);
  if userfiles.Count>0 then for i:=0 to userfiles.Count-1 do
    if not vhdonly or (extractfileext(userfiles.names[i])='.vhd') then
      l.add(userfiles.ValueFromIndex[i]+userfiles.names[i]);
  if assigned(m) then FreeAndNil(m);
  l.add(Flocation+Fname+'_'+cSBAcfg);
  case SBAversion of
    0 : l.add(Flocation+Fname+'_'+cSBAdcdr);
    1 : l.add(Flocation+Fname+'_'+cSBAmux);
  end;
  l.add(Flocation+Fname+'_'+cSBActrlr);
  l.add(Flocation+Fname+'_'+cSBATop);
  Result:=l
end;

function TSBAPrj.GetAllFileNames(dir:string; vhdonly: boolean=true): string;
var
  s,r:string;
  l:tstringlist;
begin
  l:=ListAllPrjFiles(vhdonly);
  Result:='';
  r:=IFTHEN(dir='',Flocation,dir);
  for s in l do Result+=CreateRelativePath(s,r)+' ';
  Result:=LeftStr(Result,length(Result)-1);
  if assigned(l) then freeandnil(l);
  { TODO : Sería mejor devolver la lista y luego armar el comando sin el .bat }
end;

function TSBAPrj.PrepareNewFolder:boolean;
var
  l:TStringList;
  S:String;
begin
  result:=false;
  if Fname='' then exit;
  If not ForceDirectories(Flocation) Then
  begin
    ShowMessage('Failed to create SBA project folder: '+Flocation);
    exit;
  end;
  If not IsDirectoryEmpty(Flocation) then
  begin
    l:=TStringList(FindAllFiles(Flocation,'*.*'));
    for s in l do FileSetAttr(s,faArchive);
    if assigned(l) then FreeAndNil(l);
  end;
  try
    Save;
    CopyFile(SBAbaseDir+cSBATop,Flocation+Fname+'_'+cSBATop);
    CopyFile(SBAbaseDir+cSBAcfg,Flocation+Fname+'_'+cSBAcfg);
    case SBAversion of
      0 : CopyFile(SBAbaseDir+cSBAdcdr,Flocation+Fname+'_'+cSBAdcdr);
      1 : CopyFile(SBAbaseDir+cSBAmux,Flocation+Fname+'_'+cSBAmux);
    end;
    CopyFile(SBAbaseDir+cSBActrlr,Flocation+Fname+'_'+cSBActrlr);
    CreateDir(FLocLib);
    CopyFile(SBAbaseDir+cSBApkg,FLocLib+cSBApkg);
    CopyFile(SBAbaseDir+cSyscon,FLocLib+cSyscon);
    if SBAversion=0 then CopyFile(SBAbaseDir+cDataIntf,FLocLib+cDataIntf);
    if LibAsReadOnly then
    begin
      FileSetAttr(FLocLib+cSBApkg,faReadOnly);
      FileSetAttr(FLocLib+cSyscon,faReadOnly);
      if SBAversion=0 then FileSetAttr(FLocLib+cDataIntf,faReadOnly);
    end;
    CreateDir(Flocation+cPrjUser);
    CopyIPCoreFiles(libcores);
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
  S:String;
  FL,SL,PL,IP,IPS,STL,AML,DCL,MXL:TStringList;
  i:integer;
begin
  result:=false;
  try
    FL:=TStringList.Create;
    SL:=TStringList.Create;
    PL:=TStringList.Create;
    IP:=TStringList.Create;
    IPS:=TStringList.Create;
    STL:=TStringList.Create;
    AML:=TStringList.Create;
    DCL:=TStringList.Create;
    MXL:=TStringList.Create;
    AM:=0;
    for i:=0 to libcores.Count-1 do LoadIPData(libcores[i],IP,IPS,STL,AML,DCL,MXL);
{ TODO : en el archivo json están definidos los puertos agregados al interfaz del top provenientes de los IP Core, pero sería mas legible agregar los puertos en forma posterior y agregar un comentario al inicio de la definición de cada puerto para separarlos: -- DEMO interface, -- GPIO1 interface, -- Video1 interface, etc. }
    for i:=0 to ports.count-1 do
    begin
      if ExtractDelimited(3,ports[i],[','])='1' then
        S:='std_logic_vector('+ExtractDelimited(4,ports[i],[','])+' downto '+ExtractDelimited(5,ports[i],[','])+')'
      else
        S:='std_logic';
      S:=Format('  %0:-10s: %1:-3s %s',[ExtractDelimited(1,ports[i],[',']),ExtractDelimited(2,ports[i],[',']),S]);
      if (i<ports.count-1) then S+=';';
      PL.Add(S);
    end;
    FL.Add(Flocation+Fname+'_'+cSBATop);
    FL.Add(Flocation+Fname+'_'+cSBAcfg);
    case SBAversion of
      0 : FL.Add(Flocation+Fname+'_'+cSBAdcdr);
      1 : FL.Add(Flocation+Fname+'_'+cSBAmux);
    end;
    FL.Add(Flocation+Fname+'_'+cSBActrlr);
    for i:=0 to FL.Count-1 do
    begin
      SL.LoadFromFile(FL[i]);
      SL.text:=StringReplace(SL.text, cPrjName, Fname, [rfReplaceAll]);
      SL.text:=StringReplace(SL.text, cPrjTitle, FTitle, []);
      SL.text:=StringReplace(SL.text, cPrjAuthor, FAuthor, []);
      SL.text:=StringReplace(SL.text, cPrjVersion, FVersion, []);
      SL.text:=StringReplace(SL.text, cPrjDate, FDate, []);
      S:=wraptext(FDescription,LineEnding+'-- ',[' '],60);
      SL.text:=StringReplace(SL.text, cPrjDescrip, S, []);
      case i of
        0:begin //Top
          SL.text:=StringReplace(SL.text, cPrjInterface, PL.text, []);
          SL.text:=StringReplace(SL.text, cPrjIpcores, IP.text, []);
          SL.text:=StringReplace(SL.text, cPrjIpCSgnls, IPS.text, []);
        end;
        1:begin //SBAconfig
            SL.text:=StringReplace(SL.text, cPrjSTB, STL.text, []);
            SL.text:=StringReplace(SL.text, cPrjAddress, AML.text, []);
        end;
        2:begin //SBAdcdr
          SL.text:=StringReplace(SL.text, cPrjDcdr, DCL.text, []);
          SL.text:=StringReplace(SL.text, cPrjmux, MXL.text, []);
        end;
      end;
      SL.SaveToFile(FL[i]);
    end;
    result:=true;
  finally
    if assigned(MXL) then FreeAndNil(DCL);
    if assigned(DCL) then FreeAndNil(DCL);
    if assigned(AML) then FreeAndNil(AML);
    if assigned(STL) then FreeAndNil(STL);
    if assigned(IPS) then FreeAndNil(IPS);
    if assigned(IP) then FreeAndNil(IP);
    if assigned(PL) then FreeAndNil(PL);
    if assigned(SL) then FreeAndNil(SL);
    if assigned(FL) then FreeAndNil(FL);
  end;
end;

function TSBAPrj.RemoveCore(c: string): boolean;
begin
  { TODO : Implementar funcionalidad para remover el IPCore }
  result:=false;
end;

function TSBAPrj.UpdateCore(c: string): boolean;
begin
  { TODO : Implementar funcionalidad para actualizar el IPCore }
  result:=false;
end;

procedure TSBAPrj.LoadIPData(ipname: String; IP, IPS, STL, AML, DCL,
  MXL: TStrings);
begin
  AM:=SBAIpCore.FormatData(ipname,ipname,IP,IPS,STL,AML,DCL,MXL,AM);
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

//Colecta todos los nombres de núcleos de "list" más sus requerimientos en una
//lista "m" hasta el nivel 10 en forma recursiva
procedure TSBAPrj.FillRequeriments(list, m: TStrings; var level: integer);
var
  i:integer;
  r,v:string;
  k:TStringList;
begin
  if list.Count=0 then exit;
  if level<10 then inc(level) else exit;

  for i:=0 to list.Count-1 do
  begin
    v:=list[i];
    r:=Copy2SymbDel(v,'=');
    if v='UserFiles' then Continue;
    if m.IndexOf(r)=-1 then
    try
      k:=SBAIpCore.GetReq(r);
      FillRequeriments(k,m,level);
    finally
      if assigned(k) then FreeAndNil(k);
      m.Add(r);
    end;
  end;
end;

procedure TSBAPrj.Setauthor(AValue: string);
begin
  if Fauthor=AValue then Exit;
  Fauthor:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.Setdate(AValue: string);
begin
  if Fdate=AValue then Exit;
  Fdate:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.Setdescription(AValue: string);
begin
  if Fdescription=AValue then Exit;
  Fdescription:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.Setexplibfiles(AValue: boolean);
begin
  if Fexplibfiles=AValue then Exit;
  Fexplibfiles:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.Setexpmonolithic(AValue: boolean);
begin
  if Fexpmonolithic=AValue then Exit;
  Fexpmonolithic:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.Setexpuserfiles(AValue: boolean);
begin
  if Fexpuserfiles=AValue then Exit;
  Fexpuserfiles:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.Setlocation(AValue: string);
begin
  if Flocation=AValue then Exit;
  Flocation:=AValue;
  Floclib:=Flocation+cPrjLib+PathDelim;
  Flocuser:=Flocation+cPrjUser+PathDelim;
  FModified:=true;
end;

procedure TSBAPrj.SetModified(AValue: boolean);
begin
  if FModified=AValue then Exit;
  FModified:=AValue;
end;

procedure TSBAPrj.Setname(AValue: string);
begin
  if Fname=AValue then Exit;
  Fname:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.Settitle(AValue: string);
begin
  if Ftitle=AValue then Exit;
  Ftitle:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.Setversion(AValue: string);
begin
  if Fversion=AValue then Exit;
  Fversion:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.SetSBAversion(AValue: integer);
begin
  if FSBAver=AValue then Exit;
  FSBAver:=AValue;
  SBAVersion:=AValue;
  FModified:=true;
end;

procedure TSBAPrj.SetSBAversion(AValue: string);
begin
  SetSBAversion(StrToSBAVersion(AValue));
end;

function TSBAPrj.GetSBAverStr: string;
begin
  Result:=SBAVersionToStr(FSBAver);
end;

function TSBAPrj.Open(f: string): boolean;
var SL:TStringList;
begin
  result:=false;
  if not FileExists(f) then
  begin
    showmessage('The project '+f+' does not exist');
    exit;
  end;
  try
    SL:=TStringList.create;
    SL.LoadFromFile(f);
    if not Fill(SL.Text) then exit;
    SetLocation(ExtractFilePath(f));
    FPrjFile:=f;
    FModified:=false;
    result:=true;
  finally
    if assigned(SL) then FreeAndNil(SL);
  end;
end;

function TSBAPrj.Close: boolean;
begin
  result:=not Modified;
  If Modified then
  begin
    result:=false;
    case MessageDlg('The Project was modified', 'Save Project? ', mtConfirmation, [mbYes, mbNo, mbCancel],0) of
      mrYes:result:=Save;
      mrNo:result:=True;
    end;
  end;
  if result then
  begin
    FName:='';
    FPrjFile:='';
    FLocation:='';
    FAuthor:='';
    FModified:=false;
  end;
end;

function TSBAPrj.CleanUpLibCores(CL:TStrings): boolean;
var
  s,n:string;
  l,m:TStringList;
  level:integer;

begin
  result:=false;
  level:=0;
  try
    //Fill the m stringlist with ipcore and requeriments files
    m:=TStringList.Create;
    FillRequeriments(cl,m,level);
    //Delete all vhd files not in the m stringlist from the LocLib folder
    l:=TStringList(FindAllFiles(FLocLib,'*.vhd'));
    for s in l do
    begin
      n:=extractfilenameonly(s);
      if not AnsiMatchText(n+'.vhd',[cSBApkg,cSyscon,cDataIntf]) and (m.IndexOf(n)=-1) then
      begin
        FileSetAttr(s,faArchive);
        info('CleanUpLibCores',s);
        DeleteFile(s);
      end;
    end;
  finally
    if assigned(m) then FreeAndNil(m);
    if assigned(l) then FreeAndNil(l);
  end;
  CopyIPCoreFiles(CL);
  Info('CleanUpLibCores',CL);
  libcores.Assign(CL);
  Save;
  result:=true;
end;


function TSBAPrj.SaveAs(f: String): boolean;
var
  SL:TStringList;
begin
  result:=false;
  try
    SL:=TStringList.Create;
    SL.Text:=Collect;
    SL.SaveToFile(f);
    FModified:=false;
    Info('TSBAPrj.SaveAs',Fname+' Saved');
    result:=true;
  finally
    if assigned(SL) then FreeAndNil(SL);
  end;
end;

function TSBAPrj.Save: boolean;
begin
  result:=SaveAs(Flocation+Fname+cSBAPrjExt);
end;

function TSBAPrj.PrjExport(ExportPath:string): boolean;
var
  R,S,M:TStringList;
  Level:integer;
  T:String;
begin
  { TODO : Verificar que se exportan los requerimientos de los IPCores y los archivos de usuario }
  result:=false;
  if not directoryexists(ExportPath) then
  begin
    ShowMessage('The Project export path: '+ExportPath+'do not exists');
    exit;
  end;

  if Fexpmonolithic then
  begin
    S:=TStringList.Create;
    R:=TStringList.Create;
    M:=TStringList.Create;
    try
      R.LoadFromFile(Flocation+Fname+'_'+cSBAcfg);
      S.AddStrings(R);
      case SBAversion of
        0 : R.LoadFromFile(Flocation+Fname+'_'+cSBAdcdr);
        1 : R.LoadFromFile(Flocation+Fname+'_'+cSBAmux);
      end;
      S.AddStrings(R);
      R.LoadFromFile(Flocation+Fname+'_'+cSBActrlr);
      S.AddStrings(R);
      if Fexplibfiles then
      begin
        R.LoadFromFile(Floclib+cSBApkg);
        S.AddStrings(R);
        R.LoadFromFile(Floclib+cSyscon);
        S.AddStrings(R);
        if SBAversion=0 then
        begin
          R.LoadFromFile(Floclib+cDataIntf);
          S.AddStrings(R);
        end;
        level:=0;
        FillRequeriments(libcores,m,level);
        if m.Count>0 then for T in m do
        begin
          R.LoadFromFile(Floclib+T+'.vhd');
          S.AddStrings(R);
        end;
      end;
      if Fexpuserfiles and GetAllFileNamesOnly(Flocuser,'*.vhd',M) then for T in m do
      try
        R.LoadFromFile(Flocuser+T+'.vhd');
        S.AddStrings(R);
      except
        ON E:Exception do
        begin
          Info('TSBAPrj.PrjExport Error',E.Message);
          ShowMessage('Can not copy the user file: '+T+'.vhd');
        end;
      end;
      //Top se exporta al final del archivo para permitir que las herramientas de
      //síntesis pre-carguen las dependencias.
      R.LoadFromFile(Flocation+Fname+'_'+cSBATop);
      S.AddStrings(R);
      S.SaveToFile(ExportPath+Fname+'.vhd');
    finally
      M.Free;
      R.Free;
      S.Free;
    end;
    ShowMessage('Monolithic Project file was create: '+ExportPath+Fname+'.vhd');
  end else
  begin
    CopyFile(Flocation+Fname+'_'+cSBATop,ExportPath+Fname+'_'+cSBATop,true);
    CopyFile(Flocation+Fname+'_'+cSBAcfg,ExportPath+Fname+'_'+cSBAcfg,true);
    case SBAversion of
      0 : CopyFile(Flocation+Fname+'_'+cSBAdcdr,ExportPath+Fname+'_'+cSBAdcdr,true);
      1 : CopyFile(Flocation+Fname+'_'+cSBAmux,ExportPath+Fname+'_'+cSBAmux,true);
    end;
    CopyFile(Flocation+Fname+'_'+cSBActrlr,ExportPath+Fname+'_'+cSBActrlr,true);
    if Fexplibfiles then CopyDirTree(Floclib,ExportPath+cPrjLib+PathDelim,[cffOverwriteFile,cffCreateDestDirectory,cffPreserveTime]);
    if Fexpuserfiles then CopyDirTree(Flocuser,ExportPath+cPrjUser+PathDelim,[cffOverwriteFile,cffCreateDestDirectory,cffPreserveTime]);
  end;
end;

procedure TSBAPrj.CopyIPCoreFiles(cl: TStrings);
//IPCores and Packages are copied to FLoclib
//Userfiles are copied to FLocuser
var
  i,j:integer;
  r,s,v:string;
  l:TStringList;
begin
  if cl.Count=0 then exit;
  for i:=0 to cl.Count-1 do
  begin
    v:=cl[i];
    s:=Copy2SymbDel(v,'=');
    if not isIpCore(s) then
    begin
      ShowMessage('The IP Core file: '+LibraryDir+S+' was not found.');
      exit;
    end else if (v<>'UserFiles') and not FileExists(FlocLib+s+'.vhd') then
    begin
      info('CopyIPCoreFiles','Copiando: '+s+'.vhd');  //Copy IPCore
      CopyFile(LibraryDir+s+PathDelim+s+'.vhd',FlocLib+s+'.vhd');
      if LibAsReadOnly then FileSetAttr(FlocLib+s+'.vhd',faReadOnly);

      l:=SBAIpCore.GetReq(s);
      for j:=0 to l.Count-1 do
      begin
        v:=l[j];
        r:=Copy2SymbDel(v,'=');
        if FileExists(LibraryDir+s+PathDelim+r+'.vhd') then
        begin
          info('CopyIPCoreFiles','Copiando: '+r+'.vhd'); //Copy Requirements
          if (v<>'UserFiles') then
          begin
            CopyFile(LibraryDir+s+PathDelim+r+'.vhd',FlocLib+r+'.vhd');
            if LibAsReadOnly then FileSetAttr(FlocLib+r+'.vhd',faReadOnly);
          end else
          begin
            CopyFile(LibraryDir+s+PathDelim+r+'.vhd',FlocUser+r+'.vhd');
          end;
        end else CopyIPCoreFiles(l);  //If requirement is not in core folder get from lib
      end;
      if assigned(l) then freeandnil(l);
    end;
  end;
end;


end.

