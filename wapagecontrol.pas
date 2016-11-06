unit WAPageControl;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls, Dialogs;


type
  ParentClass = TPageControl;

  { TStringList }

  { TPageControl }

  TPageControl = class(ParentClass)
  private
    function GetActiveTabSheet: TTabSheet;
    procedure SetActiveTabSheet(const AValue: TTabSheet);
  published
    property ActivePage: TTabSheet read GetActiveTabSheet write SetActiveTabSheet;
  end;


implementation

{ TPageControl }

procedure TPageControl.SetActiveTabSheet(const AValue: TTabSheet);
begin
  inherited ActivePage:=AValue;
  // Work arround for linux bug in lazarus 1.7: ActivePage do not fires OnChange
  {$IFDEF LINUX}
  if OnChange<>nil then OnChange(Self);
  {$ENDIF}
end;

function TPageControl.GetActiveTabSheet: TTabSheet;
begin
  result:=inherited ActivePage;
end;

end.

