unit SBAIPCoresU;
{ TODO : Generar un Objeto IPCore y llenar sus métodos y propiedades en el create pasando
como parámetro  el nombre del IPCore, llenar listas de requerimientos como TStringList,etc); }
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, fileutil, LazFileUtils, strutils, math,
  IniFiles;

const
  cIPCores='IPCores';
  cIpPackages='Packages';
  cIpUserFiles='UserFiles';

type

  { TSBAIpCore }

  TSBAIpCore=class(TObject)
  public
    class function GetReq(const id: string):TStringList; static;
    class function FormatData(ipname,instance: String; IP,IPS,STL,AML,DCL,MXL:TStrings; AM:integer):integer; static;
    class function GetFiles(const c:string):String; static;
  end;

var
  SBAIpCore:TSBAIpcore;

  function isIPCore(const f:string):boolean;

implementation

uses DebugU, ConfigFormU;

function isIPCore(const f:string):boolean;
var n:string;
begin
  n:=ExtractFileNameOnly(f);
  result:=FileExists(LibraryDir+n+PathDelim+n+'.ini');
end;

class function TSBAIpCore.GetReq(const id: string): TStringList;
//Extrae los requerimientos del núcleo "id" y los coloca en una lista
//ordenada: id=tipo
var
  ini: TIniFile;
  r,n:string;
  k,l: TStringList;
begin
  n:=LibraryDir+id+PathDelim+id+'.ini';
  l:=TStringList.Create;
  if not FileExists(n) then
  begin
    Info('GetReq','Core '+n+' File not found');
    result:=l;  // Return empty list
    exit;
  end;
  k:=TStringList.Create;
  try
    ini:=TIniFile.Create(n);
    k.DelimitedText:=ini.ReadString('REQUIREMENTS', cIpPackages, '');
    for r in k do l.Append(r+'='+cIpPackages);
    k.DelimitedText:=ini.ReadString('REQUIREMENTS', cIpUserFiles, '');
    for r in k do l.Append(r+'='+cIpUserFiles);
    k.DelimitedText:=ini.ReadString('REQUIREMENTS', cIpCores, '');
    for r in k do l.Append(r+'='+cIpCores);
  finally
    if assigned(k) then FreeAndNil(k);
    if assigned(ini) then FreeAndNil(ini);
  end;
  Result:=l;
end;

class function TSBAIpCore.FormatData(ipname, instance: String; IP, IPS, STL,
  AML, DCL, MXL: TStrings; AM: integer): integer;
// ipname: name of the ipcore
// IP: instance of the ipcore
// IPS: additionals signals
// STL: strobe lines
// AML: address map
// DCL: decoder lines
// AM: address map start address

var
  INI:TINIFile;
  GL,CL,AL,IL,SL:TStringList;
  f:String;
  i,j,k:integer;
  DIL,DOL,ADL:Integer;
  WE,STB,INT,ACK:boolean;
begin
  ADL:=1;
  DIL:=16;
  DOL:=16;
  WE:=true;
  STB:=true;
  if DirectoryExists(LibraryDir+ipname) then
  try
    GL:=TStringList.Create;
    CL:=TStringList.Create;
    AL:=TStringList.Create;
    IL:=TStringList.Create;
    SL:=TStringList.Create;
    f:=LibraryDir+ipname+PathDelim+ipname+'.ini';
    if fileexists(f) then
    try
      INI:=TIniFile.Create(f);
      f:=IfThen(INI.ReadInteger('Config','SBAPORTS',1)>1,'0');
      WE:=INI.ReadInteger('Config','WE'+f,1)=1;
      STB:=INI.ReadInteger('Config','STB'+f,1)=1;
      INT:=INI.ReadInteger('Config','INT'+f,0)=1;
      ACK:=INI.ReadInteger('Config','ACK'+f,0)=1;
      ADL:=INI.ReadInteger('Config','ADR'+f+'LINES',1);
      DIL:=INI.ReadInteger('Config','DATI'+f+'LINES',16);
      DOL:=INI.ReadInteger('Config','DATO'+f+'LINES',16);
      INI.ReadSectionRaw('Generic',GL);
      INI.ReadSectionRaw('Address',AL);
      INI.ReadSectionRaw('Interface',IL);
      INI.ReadSectionRaw('Signals',SL);
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
    if STB then   IP.add('    STB'+f+'_I => STBi(STB_'+instance+'),');
    if ADL>0 then IP.add('    ADR'+f+'_I => ADRi,');
    if WE then    IP.add('    WE'+f+'_I  => WEi,');
    if DIL>0 then IP.add('    DAT'+f+'_I => DATOi,');
    if DOL>0 then case SBAversion of
      0: IP.add('    DAT'+f+'_O => DAT_'+instance+',');
      1: IP.add('    DAT'+f+'_O => ADATi(STB_'+instance+'),');
    end;
    if INT then   IP.add('    INT'+f+'_O => INT_'+instance+',');
    if ACK then   IP.add('    ACK'+f+'_O => ACK_'+instance+',');
    IP.add('    -------------');
    if IL.Count>0 then for i:=0 to IL.Count-1 do
      IP.add(Format('    %:-6s=> %s',[IL.names[i],IL.ValueFromIndex[i]])+
      IfThen(i<IL.Count-1,','));
    IP.add('  );');
    IP.add('');
    if (DOL>0) and (SBAversion=0) then
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
    if INT then IPS.add(Format('  Signal %:-11s: std_logic;',['INT_'+instance]));
    if ACK then IPS.add(Format('  Signal %:-11s: std_logic;',['ACK_'+instance]));
    if STB or (DOL>0) then STL.add(Format('  Constant %:-11s: integer := %d;',['STB_'+instance,STL.count]));
    if SL.Count>0 then for i:=0 to SL.Count-1 do
      IPS.add(Format('  Signal %:-11s: %s;',[SL.names[i],SL.ValueFromIndex[i]]));
    if AL.Count>0 then
    begin
      // AL Lista de direcciones y offsets
      // ADL Ancho del bus de direcciones
      // AM Siguiente dirección disponible en el mapa de direcciones
      // AML salidas para el config
      // DCL Address decoder
      // MXL Data mux
      j:=trunc(intpower(2,ADL));
      if (AM mod j)>0 then
      begin
        AM:= ((AM div j)+1)*j
      end;
      for i:=0 to AL.Count-1 do
      begin
        f:=AL.ValueFromIndex[i];
        if (Pos(',',f)=0) and (Pos(':',f)=0) then  //Is not a range value
        begin
          j:=StrtoIntDef(f,0);
          k:=0;
          f:=AL.Names[i];
        end else //Is a range from,to
        begin
          j:=StrtoIntDef(ExtractDelimited(1,f,[',',':']),0);
          k:=StrtoIntDef(ExtractDelimited(2,f,[',',':']),0);
          f:=AL.Names[i]+' to '+AL.Names[i]+'+'+InttoStr(k);
        end;
        AML.Add(Format('  Constant %:-11s: integer := %d;',[AL.Names[i],AM+j]));
        DCL.Add(Format('     When %-20s=> STBi <= stb(%s',[f,'STB_'+instance+');']));
        if DOL>0 then MXL.Add(Format('     When %-20s=> DAT_O <= ADAT_I(%s',[f,'STB_'+instance+');']));
      end;
      AM:=IfThen(k=0,AM+j+1,AM+k+1);
    end;
  finally
    if assigned(SL) then FreeAndNil(SL);
    if assigned(IL) then FreeAndNil(IL);
    if assigned(AL) then FreeAndNil(AL);
    if assigned(CL) then FreeAndNil(CL);
    if assigned(GL) then FreeAndNil(GL);
  end;
  result:=AM;
end;

class function TSBAIpCore.GetFiles(const c:string): String;
//Colecta todos los archivos que forman parte del path/núcleo incluyendo
//sus requerimientos en una lista hasta el nivel 10 en forma recursiva
var
  l,m:TStringList;
  level:integer;
  path:string;
  i:integer;
  s:string;

  procedure GetList(list,m:TStrings; var level:integer);
  var
    i:integer;
    v:string;
    k:TStringList;
  begin
    if list.Count=0 then exit;
    if level<10 then inc(level) else exit;

    for i:=0 to list.Count-1 do
    begin
      v:=list[i];
      v:=Copy2SymbDel(v,'=');
      if m.IndexOfName(v)=-1 then
      try
        k:=GetReq(v);
        GetList(k,m,level);
      finally
        if assigned(k) then FreeAndNil(k);
        m.Add(v);
      end;
    end;
  end;

begin
  Result:='';
  try
    l:=TStringList.Create;
    m:=TStringList.Create;
    path:=ExtractFilePath(c);
    l.add(ExtractFileNameOnly(c)); level:=0;
    GetList(l,m,level);
  finally
    if assigned(l) then FreeAndNil(l);
  end;
  if assigned(m) then
  begin
    for i:=0 to m.Count-1 do
    begin
      if fileexists(path+m[i]+'.vhd') then
        s:=m[i]+'.vhd'
      else
        s:=CreateRelativePath(LibraryDir+m[i]+PathDelim+m[i]+'.vhd',path);
      m[i]:=s;
    end;
    m.Delimiter:=' ';
    Result:=m.DelimitedText;
  end;
end;


end.
