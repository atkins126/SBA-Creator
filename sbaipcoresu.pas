unit SBAIPCoresU;
{ TODO : Generar un Objeto IPCore y llenar sus métodos y propiedades en el create pasando
como parámetro  el nombre del IPCore, llenar listas de requerimientos como TStringList,etc); }
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, fileutil, LazFileUtils, strutils, math,
  IniFiles;

function CoreGetReq(const f: string): TStringList;
function IPCoreData(ipname,instance: String; IP,IPS,STL,AML,DCL:TStrings; AM:integer):integer;
procedure CopyIPCoreFiles(cl:TStrings; Destination:String);

implementation

uses DebugFormU, ConfigFormU;

function CoreGetReq(const f: string): TStringList;
var
  ini: TIniFile;
  r,n:string;
  k,l: TStringList;
begin
  n:=LibraryDir+f+PathDelim+f+'.ini';
  l:=TStringList.Create;
  if not FileExists(n) then
  begin
    Info('CoreGetReq','Core '+n+' File not found');
    result:=l;  // Return empty list
    exit;
  end;
  k:=TStringList.Create;
  try
    ini:=TIniFile.Create(n);
    k.DelimitedText:=ini.ReadString('REQUIREMENTS', 'IPCores', '');
    for r in k do l.Append(r+'=IPCores');
    k.DelimitedText:=ini.ReadString('REQUIREMENTS', 'Packages', '');
    for r in k do l.Append(r+'=Packages');
    k.DelimitedText:=ini.ReadString('REQUIREMENTS', 'UserFiles', '');
    for r in k do l.Append(r+'=UserFiles');
  finally
    if assigned(k) then FreeAndNil(k);
    if assigned(ini) then FreeAndNil(ini);
  end;
  Result:=l;
end;

function IPCoreData(ipname,instance: String; IP,IPS,STL,AML,DCL:TStrings; AM:integer):integer;
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
  WE,STB,INT:boolean;
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
    if DOL>0 then IP.add('    DAT'+f+'_O => DAT_'+instance+',');
    if INT then   IP.add('    INT'+f+'_O => INT_'+instance+',');
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
    if INT then IPS.add(Format('  Signal %:-11s: DATA_type;',['INT_'+instance]));
    if STB or (DOL>0) then STL.add(Format('  Constant %:-11s: integer := %d;',['STB_'+instance,STL.count]));
    if SL.Count>0 then for i:=0 to SL.Count-1 do
      IPS.add(Format('  Signal %:-11s: %s;',[SL.names[i],SL.ValueFromIndex[i]]));
    if AL.Count>0 then
    begin
      // AL Lista de direcciones y offsets
      // ADL Ancho del bus de direcciones
      // AM Siguiente dirección disponible en el mapa de direcciones
      // AML y DCL salidas para el config y el decoder
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
        DCL.Add(Format('     When %-20s=> STBi <= stb(%-15s-- %-10s = %d',[f,'STB_'+instance+');',AL.Names[i],AM+j]));
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

procedure CopyIPCoreFiles(cl:TStrings; Destination:String);
//IPCores are copied to Destination/lib
//Userfiles are copied to Destination/user
var
  i,j:integer;
  r,s,v,loclib,locuser:string;
  l:TStringList;
begin
  if cl.Count=0 then exit;
  loclib:=Destination+'lib'+PathDelim;
  locuser:=Destination+'user'+PathDelim;
  for i:=0 to cl.Count-1 do
  begin
    v:=cl[i];
    s:=Copy2SymbDel(v,'=');
    if not fileExists(LibraryDir+s+PathDelim+s+'.ini') then
    begin
      ShowMessage('The IP Core file: '+LibraryDir+S+' was not found.');
      exit;
    end else if (v<>'UserFiles') and not FileExists(loclib+s+'.vhd') then
    begin
      infoln('Copiando: '+s+'.vhd');  //Copy IPCore
      CopyFile(LibraryDir+s+PathDelim+s+'.vhd',loclib+s+'.vhd');
      if LibAsReadOnly then FileSetAttr(loclib+s+'.vhd',faReadOnly);

      l:=CoreGetReq(s);
      for j:=0 to l.Count-1 do
      begin
        v:=l[j];
        r:=Copy2SymbDel(v,'=');
        if FileExists(LibraryDir+s+PathDelim+r+'.vhd') then
        begin
          infoln('Copiando: '+r+'.vhd'); //Copy Requirements
          if (v<>'UserFiles') then
          begin
            CopyFile(LibraryDir+s+PathDelim+r+'.vhd',loclib+r+'.vhd');
            if LibAsReadOnly then FileSetAttr(loclib+r+'.vhd',faReadOnly);
          end else
          begin
            CopyFile(LibraryDir+s+PathDelim+r+'.vhd',locuser+r+'.vhd');
          end;
        end else CopyIPCoreFiles(l,Destination);  //If requirement is not in core folder get from lib
      end;
      if assigned(l) then freeandnil(l);
    end;
  end;
end;

end.

