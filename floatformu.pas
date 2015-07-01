unit FloatFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lclintf, LCLType, ExtCtrls, INIFilesUTF8;

type

  { TFloatForm }

  TFloatForm = class(TForm)
    Image: TImage;
    L_CoreName: TLabel;
    L_Description: TLabel;
    Panel1: TPanel;
    TimerShow: TTimer;
    procedure TimerShowTimer(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { private declarations }
    INI:TIniFile;
  public
    { public declarations }
    procedure ShowCoreImage(s:string);
    procedure Hide;
  end;

var
  FloatForm: TFloatForm;

implementation

{$R *.lfm}

uses ConfigFormU;

{ TFloatForm }

procedure TFloatForm.ShowCoreImage(s: string);
begin
  if s=L_CoreName.caption then exit;
  L_CoreName.caption:=s;
  TimerShow.Interval:=500;
  TimerShow.Enabled:=true;
end;

procedure TFloatForm.Hide;
begin
  TimerShow.Enabled:=false;
  inherited hide;
end;

procedure TFloatForm.TimerShowTimer(Sender: TObject);
begin
  TimerShow.Enabled:=false;
  try
    Image.Picture.LoadFromFile(LibraryDir+L_CoreName.caption+PathDelim+'image.png');
    L_Description.Caption:='';
    try
      Ini:=TINIFile.Create(LibraryDir+L_CoreName.caption+PathDelim+L_CoreName.caption+'.ini');
      L_Description.Caption:=Ini.ReadString('MAIN','Description','');
    finally
      Ini.free;
    end;
    ShowWindow(Self.Handle, SW_SHOWNOACTIVATE);
    Visible := True;
  except
    ON E:Exception do
    begin
      Image.Picture.Clear;
      Visible := False;
    end;
  end;
end;

procedure TFloatForm.CreateParams(var Params: TCreateParams); // override;
 begin
   inherited;
   params.wndParent := 0;
 end;

end.

