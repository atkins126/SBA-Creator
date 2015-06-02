unit SBAProyectU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

const
  cSBADefaultPrjName='NewProject.sba';

type

  { TSBAProyect }

  TSBAProyect = class(TCollectionItem)
  private
    Ffilename: string;
    Fipcores: TStringList;
    Fname: string;
    procedure Setfilename(AValue: string);
    procedure Setipcores(AValue: TStringList);
    procedure Setname(AValue: string);
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  published
    property name:string read Fname write Setname;
    property filename:string read Ffilename write Setfilename;
    property ipcores:TStringList read Fipcores write Setipcores;
  end;

  { TSBAProyects }

  TSBAProyects = class(TCollection)
  private
    function GetItem(Index: integer): TSBAProyect;
    procedure SetItem(Index: integer; AValue: TSBAProyect);
  public
    constructor Create;
    function Add:TSBAProyect;
    property Items[Index:integer]:TSBAProyect read GetItem write SetItem; default;
  end;


implementation

{ TSBAProyects }

function TSBAProyects.GetItem(Index: integer): TSBAProyect;
begin
  Result:= TSBAProyect(inherited Items[Index]);
end;

procedure TSBAProyects.SetItem(Index: integer; AValue: TSBAProyect);
begin
  Items[Index].Assign(AValue);
end;

constructor TSBAProyects.Create;
begin
  inherited Create(TSBAProyect);
end;

function TSBAProyects.Add: TSBAProyect;
begin
  result:= inherited Add as TSBAProyect;
end;

{ TSBAProyect }

procedure TSBAProyect.Setname(AValue: string);
begin
  if Fname=AValue then Exit;
  Fname:=AValue;
end;

procedure TSBAProyect.Setfilename(AValue: string);
begin
  if Ffilename=AValue then Exit;
  Ffilename:=AValue;
end;

procedure TSBAProyect.Setipcores(AValue: TStringList);
begin
  if Fipcores=AValue then Exit;
  Fipcores:=AValue;
end;

constructor TSBAProyect.Create(ACollection: TCollection);
begin
  if Assigned(ACollection) then inherited Create(ACollection);
  FIPCores:=TStringList.Create;
end;

destructor TSBAProyect.Destroy;
begin
  if assigned(FIPCores) then FreeandNil(FIPCores);
  inherited Destroy;
end;

end.

