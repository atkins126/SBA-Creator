unit FloatFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lclintf, LCLType, ExtCtrls, uEImage, INIFilesUTF8, BGRABitmap;

type

  { TFloatForm }

  TFloatForm = class(TForm)
    CoreImagePanel: TuEImage;
    L_Title: TLabel;
    L_CoreName: TLabel;
    L_Description: TLabel;
    Panel1: TPanel;
    TimerShow: TTimer;
    procedure FormDestroy(Sender: TObject);
    procedure TimerShowTimer(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    { private declarations }
    INI:TIniFile;
  public
    { public declarations }
    procedure ShowCoreInfo(s:string);
    procedure Start(F:TForm);
    procedure Hide;
  end;

var
  FloatForm: TFloatForm;

implementation

{$R *.lfm}

uses ConfigFormU, DebugU;

{ TFloatForm }

procedure TFloatForm.ShowCoreInfo(s: string);
begin
  if s=L_CoreName.caption then exit;
  L_CoreName.caption:=s;
  TimerShow.Interval:=500;
  TimerShow.Enabled:=true;
end;

procedure TFloatForm.Start(F:TForm);
begin
  Info('TFloatForm.Start','Parent = '+F.Name);
  PopupParent:=nil;
  Hide;
  PopupParent:=F;
  FormStyle:=fsSystemStayOnTop;
end;

procedure TFloatForm.Hide;
begin
  TimerShow.Enabled:=false;
  inherited hide;
end;

procedure TFloatForm.TimerShowTimer(Sender: TObject);
begin
  Info('TFloatForm','ShowCore= '+L_CoreName.caption);
  TimerShow.Enabled:=false;
  CoreImagePanel.Image.Clear;
  try
    CoreImagePanel.LoadFromFile(LibraryDir+L_CoreName.caption+PathDelim+'image.png');
    L_Title.Caption:='';
    L_Description.Caption:='';
    try
      Ini:=TINIFile.Create(LibraryDir+L_CoreName.caption+PathDelim+L_CoreName.caption+'.ini');
      L_Title.Caption:=Ini.ReadString('MAIN','Title','');
      L_Description.Caption:=Ini.ReadString('MAIN','Description','');
    finally
      Ini.free;
    end;
    ShowWindow(Self.Handle, SW_SHOWNOACTIVATE);
    Visible := True;
  except
    ON E:Exception do
    begin
      Visible := False;
    end;
  end;
end;

procedure TFloatForm.FormDestroy(Sender: TObject);
begin
  Info('TFloatForm','FormDestroy');
end;

procedure TFloatForm.CreateParams(var Params: TCreateParams); // override;
 begin
   inherited;
   params.wndParent := 0;
 end;

end.

