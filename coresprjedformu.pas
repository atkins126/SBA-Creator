unit CoresPrjEdFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, SBAProjectU;

type

  { TCoresPrjEdForm }

  TCoresPrjEdForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    B_CoreAdd: TBitBtn;
    B_CoreDel: TBitBtn;
    Label1: TLabel;
    Label8: TLabel;
    LibIpCoreList: TListBox;
    PrjIpCoreList: TListBox;
    procedure B_CoreAddClick(Sender: TObject);
    procedure B_CoreDelClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LibIpCoreListDblClick(Sender: TObject);
    procedure PrjIpCoreListDblClick(Sender: TObject);
    procedure ListMouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer);
    procedure ListMouseLeave(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    function CoresEdit(Prj:TSBAPrj):Boolean;
  end;

var
  CoresPrjEdForm: TCoresPrjEdForm;

implementation

{$R *.lfm}

uses ConfigFormU, FloatFormU, DebugFormU;

{ TCoresPrjEdForm }

function TCoresPrjEdForm.CoresEdit(Prj: TSBAPrj): Boolean;
var
  S:String;
  h:integer;
begin
  FloatForm.Start(Self);
  LibIpCoreList.Items.Assign(IpCoreList);
  PrjIpCoreList.Clear;
  PrjIpCoreList.Items.Assign(Prj.libcores);
  for S in PrjIpCoreList.Items do
  begin
    h:=LibIpCoreList.Items.IndexOf(S);
    if h<>-1 then LibIpCoreList.Items.Delete(h);
  end;
  Result:=ShowModal=mrOK;
end;

procedure TCoresPrjEdForm.LibIpCoreListDblClick(Sender: TObject);
begin
  B_CoreAddClick(nil);
end;

procedure TCoresPrjEdForm.ListMouseLeave(Sender: TObject);
begin
  FloatForm.L_CoreName.caption:='';
  FloatForm.hide;
end;

procedure TCoresPrjEdForm.ListMouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  i: Integer;
  L:TListBox;
begin
  If not Sender.ClassNameIs('TListBox') then exit;
  L:=TListBox(Sender);
  P:=Mouse.CursorPos;
  FloatForm.Top:=P.Y+20;
  FloatForm.Left:=P.X+10;
  i:=L.GetIndexAtXY(X,Y);
  if i>=0 then
  begin
    FloatForm.ShowCoreInfo(L.Items[i]);
  end else begin
    FloatForm.L_CoreName.caption:='';
    FloatForm.hide;
  end;
end;

procedure TCoresPrjEdForm.B_CoreAddClick(Sender: TObject);
var
  i: integer;
begin
  if LibIpCoreList.SelCount > 0 then
  begin
    LibIpCoreList.Items.BeginUpdate;
    For i:=LibIpCoreList.Items.Count-1 downto 0 do if LibIpCoreList.Selected[i] then
    begin
      PrjIpCoreList.Items.Add(LibIpCoreList.Items[i]);
      LibIpCoreList.Items.Delete(i);
    end;
    LibIpCoreList.Items.EndUpdate;
  end else
  begin
    ShowMessage('Please select an item first!');
  end;
end;

procedure TCoresPrjEdForm.B_CoreDelClick(Sender: TObject);
var
  i: integer;
begin
  if PrjIpCoreList.SelCount > 0 then
  begin
    PrjIpCoreList.Items.BeginUpdate;
    For i:=PrjIpCoreList.Items.Count-1 downto 0 do if PrjIpCoreList.Selected[i] then
    begin
      LibIpCoreList.Items.Add(PrjIpCoreList.Items[i]);
      PrjIpCoreList.Items.Delete(i);
    end;
    PrjIpCoreList.Items.EndUpdate;
  end else
  begin
      ShowMessage('Please select an item first!');
  end;
end;

procedure TCoresPrjEdForm.FormDestroy(Sender: TObject);
begin
  Info('TCoresPrjEdForm','FormDestroy');
end;

procedure TCoresPrjEdForm.PrjIpCoreListDblClick(Sender: TObject);
begin
  B_CoreDelClick(nil);
end;


end.

