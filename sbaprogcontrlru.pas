unit SBAProgContrlrU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

const
  cSBACtrlrSignatr='-- /SBA: Controller';
  cSBALblSignatr='-- /L:';
  cSBAStartProgDetails='-- /SBA: Program Details';
  cSBAEndProgDetails='-- /SBA: End';
  cSBAStartProgUReg='-- /SBA: User Registers';
  cSBAEndProgUReg='-- /SBA: End';
  cSBAStartProgLabels='-- /SBA: Label constants';
  cSBAEndProgLabels='-- /SBA: End';
  cSBAStartUserProg='-- /SBA: User Program';
  cSBAEndUserProg='-- /SBA: End';
  cSBADefaultPrgName='NewProgram.prg';
  cSBADefaultPrgTemplate='PrgTemplate.prg';

type

  { TSBAContrlrProg }

  TSBAContrlrProg = class(TObject)
    FFileName : string;
  private
    procedure SetFilename(AValue: String);
  public
    constructor Create;
    function GetPosList(s: string; list: Tstrings; start:integer=0): integer;
    function DetectSBAContrlr(Src:TStrings):boolean;
    function ExtractSBALbls(Prog, Labels: TStrings): boolean;
    function CpySrc2Prog(Src,Prog:TStrings):boolean;
    function CpyProgDetails(Prog,Src:TStrings):boolean;
    function CpyProgUReg(Prog,Src:TStrings):boolean;
    function GenLblandProgFormat(Prog, Labels: TStrings): boolean;
    function CpyProgLabels(Labels,Src:TStrings):boolean;
    function CpyUserProg(Prog,Src:TStrings):boolean;
    property Filename : String read FFilename write SetFilename;
  end;

implementation

{ TSBAContrlrProg }

function TSBAContrlrProg.DetectSBAContrlr(Src: TStrings): boolean;
var I:integer;
begin
  Result:=false;
  for I:=0 to Min(Src.Count-1,9) do
  begin
    Result:=(Pos(cSBACtrlrSignatr,Src[i])<>0);
    if Result then break;
  end;
end;

function TSBAContrlrProg.ExtractSBALbls(Prog, Labels: TStrings): boolean;
var i,iPos,sblock:integer;
begin
  Result:=false;
  Labels.Clear;
  sblock:=GetPosList(cSBAStartUserProg,Prog);
  if sblock=-1 then exit;
  for i:=sblock to Prog.Count-1 do
  begin
    iPos := Pos(cSBALblSignatr, Prog[i]);
    if (iPos<>0) then Labels.AddText(Copy(Prog[i],iPos+length(cSBALblSignatr),100));
    if (pos(cSBAEndUserProg,Prog[i])<>0) then break;
  end;
  Result:=pos(cSBAEndUserProg,Prog[i])<>0;
end;

function TSBAContrlrProg.CpySrc2Prog(Src, Prog: TStrings): boolean;
var
  i,startpos,iPos:integer;

begin
  Result:=false;

  // Program Details
  startpos:=GetPosList(cSBAStartProgDetails,Src);
  if startpos>=0 then
  begin
    For i:=startpos to Src.Count-1 do
    begin
      Prog.Append(Src[i]);
      if (pos(cSBAEndProgDetails,Src[i])<>0) then break;
    end;
    if (pos(cSBAEndProgDetails,Src[i])=0) then exit;
    Prog.Append('');
  end;

  // User Registers and Constants
  startpos:=GetPosList(cSBAStartProgUReg,Src);
  if startpos>=0 then
  begin
    For i:=startpos to Src.Count-1 do
    begin
      Prog.Append(Src[i]);
      if (pos(cSBAEndProgUReg,Src[i])<>0) then break;
    end;
    if (pos(cSBAEndProgUReg,Src[i])=0) then exit;
    Prog.Append('');
  end;

  //Check for labels block
  startpos:=GetPosList(cSBAStartProgLabels,Src);
  iPos:=GetPosList(cSBAEndProgLabels,Src,startpos);
  startpos:=GetPosList(cSBAStartUserProg,Src,iPos);
  if startpos=-1 then exit;

  // SBA User Program
  startpos:=GetPosList(cSBAStartUserProg,Src);
  if startpos>=0 then
  begin
    iPos:=0;
    For i:=startpos to Src.Count-1 do
    begin
      iPos := Pos('=>', Src[i]);
      if (iPos<>0) then break;
    end;
    if (iPos=0) or (iPos>20) then exit;

    For i:=startpos to Src.Count-1 do
    begin
      if LeftStr(Src[i],2)='--' then
        Prog.Append(Src[i])
      else
        Prog.Append(Copy(Src[i],iPos,1000));
      if (pos(cSBAEndUserProg,Src[i])<>0) then
      begin
        Result:=true;
        break;
      end;
    end;
  end;
end;

function TSBAContrlrProg.CpyProgDetails(Prog, Src: TStrings): boolean;
var
  i,sblock,eblock,iPos:integer;

begin
  Result:=false;
  iPos:=GetPosList(cSBAStartProgDetails,Src);
  if iPos=-1 then exit;

  while (pos(cSBAEndProgDetails,Src[iPos])=0) and (Src.Count>iPos) do Src.Delete(iPos);
  if (pos(cSBAEndProgDetails,Src[iPos])=0) then exit else Src.Delete(iPos);

  sblock:=GetPosList(cSBAStartProgDetails,Prog);
  eblock:=GetPosList(cSBAEndProgDetails,Prog,sblock);
  if (sblock=-1) or (eblock=-1) then exit;

  For i:=eblock downto sblock do Src.Insert(iPos,Prog[i]);
  Result:=true;
end;

function TSBAContrlrProg.GetPosList(s: string; list: Tstrings; start: integer=0): integer;
var
  i: integer;
begin
  if start<0 then begin result:=-1; exit; end;
  For i:=start to list.Count-1 do if pos(s,list[i])<>0 then break;
  if pos(s,list[i])<>0 then Result:=i else Result:=-1;
end;

procedure TSBAContrlrProg.SetFilename(AValue: String);
begin
  if FFilename=AValue then Exit;
  FFilename:=AValue;
end;

constructor TSBAContrlrProg.Create;
begin
  FFileName:=cSBADefaultPrgName;
end;


function TSBAContrlrProg.CpyProgUReg(Prog, Src: TStrings): boolean;
var
  i,sblock,eblock,iPos:integer;

begin
  Result:=false;
  iPos:=GetPosList(cSBAStartProgUReg,Src);
  if iPos=-1 then exit;

  while (pos(cSBAEndProgUReg,Src[iPos])=0) and (Src.Count>iPos) do Src.Delete(iPos);
  if (pos(cSBAEndProgUReg,Src[iPos])=0) then exit else Src.Delete(iPos);

  sblock:=GetPosList(cSBAStartProgUReg,Prog);
  eblock:=GetPosList(cSBAEndProgUReg,Prog,sblock);
  if (sblock=-1) or (eblock=-1) then exit;

  For i:=eblock downto sblock do Src.Insert(iPos,Prog[i]);
  Result:=true;
end;

function TSBAContrlrProg.CpyProgLabels(Labels, Src: TStrings): boolean;
var i,iPos:integer;
begin
  Result:=false;
  iPos:=GetPosList(cSBAStartProgLabels,Src);
  if iPos=-1 then exit;
  Inc(iPos);
  while (pos(cSBAEndProgLabels,Src[iPos])=0) and (Src.Count>iPos) do Src.Delete(iPos);
  if (pos(cSBAEndProgLabels,Src[iPos])=0) then exit;
  For i:=Labels.Count-1 downto 0 do Src.Insert(iPos,Labels[i]);
  Result:=true;
end;

// Extract Labels and complete steps numbers
function TSBAContrlrProg.GenLblandProgFormat(Prog,Labels:TStrings):boolean;
const
  sizestep = 3;  //Number of digits for the step
var
  i,sblock:integer;
  iPos,cnt:integer;
  s:String;

begin
  Result:=false;
  Labels.Clear;
  cnt:=1;
  sblock:=GetPosList(cSBAStartUserProg,Prog);
  if sblock=-1 then exit;

  for i:=sblock to Prog.Count-1 do
  begin
    iPos := Pos(cSBALblSignatr, Prog[i]);
    if (iPos<>0) then Labels.AddText('  constant '+Copy(Prog[i],iPos+length(cSBALblSignatr),100)+': integer := '+Format('%.*d;', [sizestep,cnt]));
    iPos := Pos('=>', Prog[i]);
    if (iPos=1) then
    begin
      s:='        When '+Format('%.*d', [sizestep,cnt]);
      inc(cnt);
    end else S:= Format('%*s',[13+sizestep,' ']);
    if LeftStr(Prog[i],2)<>'--' then Prog[i]:=S+Prog[i];
    if (pos(cSBAEndUserProg,Prog[i])<>0) then break;
  end;
  Result:=pos(cSBAEndUserProg,Prog[i])<>0;
end;

// Copy User program
function TSBAContrlrProg.CpyUserProg(Prog, Src: TStrings): boolean;
var
  i,sblock,eblock,iPos:integer;

begin
  Result:=false;
  iPos:=GetPosList(cSBAStartUserProg,Src);
  if iPos=-1 then exit;

  while (pos(cSBAEndUserProg,Src[iPos])=0) and (Src.Count>iPos) do Src.Delete(iPos);
  if (pos(cSBAEndUserProg,Src[iPos])=0) then exit else Src.Delete(iPos);

  sblock:=GetPosList(cSBAStartUserProg,Prog);
  eblock:=GetPosList(cSBAEndUserProg,Prog,sblock);
  if (sblock=-1) or (eblock=-1) then exit;

  For i:=eblock downto sblock do Src.Insert(iPos,Prog[i]);
  Result:=true;
end;


end.

