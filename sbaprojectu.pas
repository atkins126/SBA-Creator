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
    exportpath:string;
    expmonolithic:boolean;
    explibfiles:boolean;
    expuserfiles:boolean;
    Modified:boolean;
    constructor Create;
    destructor Destroy; override;
  private
    procedure FillRequeriments(list, m: TStrings; var level:integer);
  public
    function Open(f:string):boolean;
    function Fill(Data: string): boolean;
    function Collect:string;
    function PrepareNewFolder: boolean;
    function CustomizeFiles:boolean;
    function SaveAs(f: String):boolean;
    function Save:boolean;
    function PrjExport:boolean;
    procedure LoadIPData(ipname: String; IP,IPS,STL,AML,DCL:TStrings);
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
  end;

var
  SBAPrj:TSBAPrj=nil;


implementation

uses SBAIPCoresU, DebugFormU, ConfigFormU, CoresPrjEdFormU, UtilsU;

var AM:integer; //Address Map pointer

{ TSBAPrj }

constructor TSBAPrj.Create;
begin
  inherited Create;
  name:='';
  exportpath:='';
  expmonolithic:=false;
  explibfiles:=true;
  expuserfiles:=true;
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
    name:='';
    modified:=true;
    ports.Clear;
    libcores.Clear;
    userfiles.Clear;
    try
      name:=J.FindPath('name').AsString;
      title:=J.FindPath('title').AsString;
      author:=J.FindPath('author').AsString;
      version:=J.FindPath('version').AsString;
      date:=J.FindPath('date').AsString;
      description:=J.FindPath('description').AsString;
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
    if J.FindPath('exportpath')=nil then exportpath:='' else exportpath:=AppendPathDelim(TrimFilename(J.FindPath('exportpath').AsString));
    if J.FindPath('expmonolithic')=nil then expmonolithic:=false else expmonolithic:=J.FindPath('expmonolithic').AsBoolean;
    if J.FindPath('explibfiles')=nil then explibfiles:=true else explibfiles:=J.FindPath('explibfiles').AsBoolean;
    if J.FindPath('expuserfiles')=nil then expuserfiles:=true else expuserfiles:=J.FindPath('expuserfiles').AsBoolean;
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
            '"name": "'+name+'",'#10+
            '"title": "'+title+'",'#10+
            '"author": "'+author+'",'#10+
            '"version": "'+version+'",'#10+
            '"date": "'+date+'",'#10+
            '"description": "'+description+'",'#10+
            '"exportpath": "'+exportpath+'",'#10+
            '"expmonolithic": '+IfThen(expmonolithic,'true','false')+','#10+
            '"explibfiles": '+IfThen(explibfiles,'true','false')+','#10+
            '"expuserfiles": '+IfThen(expuserfiles,'true','false');
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
    Modified:=true;
//    Save;
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
    Modified:=true;
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
  result:=IFTHEN(result='',location+'user'+PathDelim,result);
end;

function TSBAPrj.ListAllPrjFiles(vhdonly: boolean=true): tstringlist;
var
  r:string;
  i,level:integer;
  l,m:tstringlist;
begin
  l:=tstringlist.create;
  l.add(loclib+cSBApkg);
  l.add(loclib+cSyscon);
  l.add(loclib+cDataIntf);
  if libcores.Count>0 then
  begin
    m:=tstringlist.create;
    level:=0;
    FillRequeriments(libcores,m,level);
    infoln('Cores Requeriments:');
    infoln(m);
    for r in m do l.add(loclib+r+'.vhd');
    if assigned(m) then freeandnil(m);
  end;
  if userfiles.Count>0 then for i:=0 to userfiles.Count-1 do
    if not vhdonly or (extractfileext(userfiles.names[i])='.vhd') then
      l.add(userfiles.ValueFromIndex[i]+userfiles.names[i]);
  l.add(location+name+'_'+cSBAcfg);
  l.add(location+name+'_'+cSBAdcdr);
  l.add(location+name+'_'+cSBActrlr);
  l.add(location+name+'_'+cSBATop);
  Result:=l
end;

function TSBAPrj.GetAllFileNames(dir:string; vhdonly: boolean=true): string;
var
  s,r:string;
  l:tstringlist;
begin
  l:=ListAllPrjFiles(vhdonly);
  Result:='';
  r:=IFTHEN(dir='',location,dir);
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
  if name='' then exit;
  If not ForceDirectories(Location) Then
  begin
    ShowMessage('Failed to create SBA project folder: '+Location);
    exit;
  end;
  If not IsDirectoryEmpty(Location) then
  begin
    l:=TStringList(FindAllFiles(Location,'*.*'));
    for s in l do FileSetAttr(s,faArchive);
    if assigned(l) then FreeAndNil(l);
  end;
  try
    Save;
    CopyFile(SBAbaseDir+cSBATop,Location+Name+'_'+cSBATop);
    CopyFile(SBAbaseDir+cSBAcfg,Location+Name+'_'+cSBAcfg);
    CopyFile(SBAbaseDir+cSBAdcdr,Location+Name+'_'+cSBAdcdr);
    CopyFile(SBAbaseDir+cSBActrlr,Location+Name+'_'+cSBActrlr);
    CreateDir(LocLib);
    CopyFile(SBAbaseDir+cSBApkg,LocLib+cSBApkg);
    CopyFile(SBAbaseDir+cSyscon,LocLib+cSyscon);
    CopyFile(SBAbaseDir+cDataIntf,LocLib+cDataIntf);
    if LibAsReadOnly then
    begin
      FileSetAttr(LocLib+cSBApkg,faReadOnly);
      FileSetAttr(LocLib+cSyscon,faReadOnly);
      FileSetAttr(LocLib+cDataIntf,faReadOnly);
    end;
    CreateDir(Location+'user');
    CopyIPCoreFiles(libcores,Location);
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
  FL,SL,PL,IP,IPS,STL,AML,DCL:TStringList;
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
    AM:=0;
    for i:=0 to libcores.Count-1 do LoadIPData(libcores[i],IP,IPS,STL,AML,DCL);
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
      S:=wraptext(description,LineEnding+'-- ',[' '],60);
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

procedure TSBAPrj.LoadIPData(ipname: String; IP,IPS,STL,AML,DCL:TStrings);
begin
  AM:=IPCoreData(ipname,ipname,IP,IPS,STL,AML,DCL,AM);
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

{
 procedure TSBAPrj.CopyIPCoreFiles(cl:TStrings);
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
     if not fileExists(LibraryDir+s+PathDelim+s+'.ini') then
     begin
       ShowMessage('The IP Core file: '+LibraryDir+S+' was not found.');
       exit;
     end else if (v<>'UserFiles') and not FileExists(LocLib+s+'.vhd') then
     begin
       infoln('Copiando: '+s+'.vhd');  //Copy IPCore
       CopyFile(LibraryDir+s+PathDelim+s+'.vhd',LocLib+s+'.vhd');
       if LibAsReadOnly then FileSetAttr(LocLib+s+'.vhd',faReadOnly);

       l:=CoreGetReq(LibraryDir+s+PathDelim+s+'.ini');
       for j:=0 to l.Count-1 do
       begin
         v:=l[j];
         r:=Copy2SymbDel(v,'=');
         if FileExists(LibraryDir+s+PathDelim+r+'.vhd') then
         begin
           infoln('Copiando: '+r+'.vhd'); //Copy Requirements
           if (v<>'UserFiles') then
           begin
             CopyFile(LibraryDir+s+PathDelim+r+'.vhd',LocLib+r+'.vhd');
             if LibAsReadOnly then FileSetAttr(LocLib+r+'.vhd',faReadOnly);
           end else
           begin
             CopyFile(LibraryDir+s+PathDelim+r+'.vhd',location+'user'+PathDelim+r+'.vhd');
             AddUserFile(location+'user'+PathDelim+r+'.vhd');
           end;
         end else CopyIPCoreFiles(l);  //If requirement is not in core folder get from lib
       end;
       if assigned(l) then freeandnil(l);
     end;
   end;
 end;
}

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
    m.Add(r);
    try
      k:=CoreGetReq(r);
      FillRequeriments(k,m,level);
    finally
      if assigned(k) then FreeAndNil(k);
    end;
  end;
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
    location:=ExtractFilePath(f);
    loclib:=location+'lib'+PathDelim;
    Modified:=false;
    result:=true;
  finally
    if assigned(SL) then FreeAndNil(SL);
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
    l:=TStringList(FindAllFiles(LocLib,'*.vhd'));
    for s in l do
    begin
      n:=extractfilenameonly(s);
      if not AnsiMatchText(n+'.vhd',[cSBApkg,cSyscon,cDataIntf]) and (m.IndexOf(n)=-1) then
      begin
        FileSetAttr(s,faArchive);
        infoln('Borrando: '+s);
        DeleteFile(s);
      end;
    end;
  finally
    if assigned(m) then FreeAndNil(m);
    if assigned(l) then FreeAndNil(l);
  end;
  CopyIPCoreFiles(CL,location);
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
    Modified:=false;
    Info('TSBAPrj.SaveAs',Name+' Saved');
    result:=true;
  finally
    if assigned(SL) then FreeAndNil(SL);
  end;
end;

function TSBAPrj.Save: boolean;
begin
  result:=SaveAs(Location+Name+cSBAPrjExt);
end;

function TSBAPrj.PrjExport: boolean;
var
  R,S:TStringList;
  T,locuser:String;
begin
  { TODO : Verificar que se exportan los requerimientos de los IPCores y los archivos de usuario }
  result:=false;
  if not directoryexists(ExportPath) then
  begin
    ShowMessage('The Project export path: '+ExportPath+'do not exists');
    exit;
  end;
//  loclib:=location+'lib'+PathDelim;
  locuser:=location+'user'+PathDelim;
  if expmonolithic then
  begin
    S:=TStringList.Create;
    R:=TStringList.Create;
    R.LoadFromFile(location+Name+'_'+cSBATop);
    S.AddStrings(R);
    R.LoadFromFile(location+Name+'_'+cSBAcfg);
    S.AddStrings(R);
    R.LoadFromFile(location+Name+'_'+cSBAdcdr);
    S.AddStrings(R);
    R.LoadFromFile(location+Name+'_'+cSBActrlr);
    S.AddStrings(R);
    if explibfiles then
    begin
      R.LoadFromFile(loclib+cSBApkg);
      S.AddStrings(R);
      R.LoadFromFile(loclib+cSyscon);
      S.AddStrings(R);
      R.LoadFromFile(loclib+cDataIntf);
      S.AddStrings(R);
      if libcores.Count>0 then for T in libcores do
      begin
        R.LoadFromFile(loclib+T+'.vhd');
        S.AddStrings(R);
      end;
    end;
    R.Free;
    S.SaveToFile(ExportPath+Name+'.vhd');
    S.Free;
    ShowMessage('Monolithic Project file was create: '+ExportPath+Name+'.vhd');
  end else
  begin
    CopyFile(location+Name+'_'+cSBATop,ExportPath+Name+'_'+cSBATop,true);
    CopyFile(location+Name+'_'+cSBAcfg,ExportPath+Name+'_'+cSBAcfg,true);
    CopyFile(location+Name+'_'+cSBAdcdr,ExportPath+Name+'_'+cSBAdcdr,true);
    CopyFile(location+Name+'_'+cSBActrlr,ExportPath+Name+'_'+cSBActrlr,true);
    if explibfiles then CopyDirTree(loclib,exportpath+'lib\',[cffOverwriteFile,cffCreateDestDirectory,cffPreserveTime]);
    if expuserfiles then CopyDirTree(locuser,exportpath+'user\',[cffOverwriteFile,cffCreateDestDirectory,cffPreserveTime]);
  end;
end;

end.

