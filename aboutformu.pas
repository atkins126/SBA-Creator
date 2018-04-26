unit AboutFormU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, ComCtrls, StdCtrls, LCLIntf;

type
  { TScrollingText }

  TScrollingText = class(TGraphicControl)
  private
    FActive: boolean;
    FActiveLine: integer;   //the line over which the mouse hovers
    FBuffer: TBitmap;
    FEndLine: integer;
    FLineHeight: integer;
    FLines: TStrings;
    FNumLines: integer;
    FOffset: integer;
    FStartLine: integer;
    FStepSize: integer;
    FTimer: TTimer;
    function ActiveLineIsURL: boolean;
    procedure DoTimer(Sender: TObject);
    procedure SetActive(const AValue: boolean);
    procedure Init;
    procedure DrawScrollingText(Sender: TObject);
  protected
    procedure DoOnChangeBounds; override;
    procedure MouseDown(Button: TMouseButton; Shift:TShiftState; X,Y:Integer); override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Active: boolean read FActive write SetActive;
    property Lines: TStrings read FLines write FLines;
  end;

  { TAboutForm }

  TAboutForm = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    L_Version: TLabel;
    PageControl1: TPageControl;
    About: TTabSheet;
    AcknowledgementsPage: TTabSheet;
    ContributorsPage: TTabSheet;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { private declarations }
    Acknowledgements: TScrollingText;
    Contributors: TScrollingText;
    procedure LoadContributors;
    procedure LoadAcknowledgements;
  public
    { public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.lfm}

uses ConfigFormU, DebugFormU, VersionSupportU;

const
  cContributors = '#Programming'+LineEnding+
                   LineEnding+
                   'Miguel Risco-Castillo'+LineEnding+
                   LineEnding+
                   '#Reviews'+LineEnding+
                   LineEnding+
                   'Juan Vega Martinez';

  cAcknowledgements = '#SBACreator uses the following'+LineEnding+
                   '#libraries and tools:'+LineEnding+
                   LineEnding+
                   'SBA Simple Bus Architecture'+LineEnding+
                   'http://sba.accesus.com/'+LineEnding+
                   LineEnding+
                   'Lazarus IDE'+LineEnding+
                   'http://www.lazarus-ide.org/'+LineEnding+
                   LineEnding+
                   'Silk Icons'+LineEnding+
                   'http://www.famfamfam.com/lab/icons/silk/'+LineEnding+
                   LineEnding+
                   'IPCodeDraw PlugIn'+LineEnding+
                   'https://github.com/jvegam/IpCoreDraw';
{ TAboutForm }

procedure TAboutForm.FormDestroy(Sender: TObject);
begin
  Info('TAboutForm','FormDestroy');
end;

procedure TAboutForm.PageControl1Change(Sender: TObject);
begin
  if Assigned(Contributors) then
    Contributors.Active:=PageControl1.ActivePage = ContributorsPage;
  if Assigned(Acknowledgements) then
    Acknowledgements.Active:=PageControl1.ActivePage = AcknowledgementsPage;
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  L_Version.Caption:='Version: '+GetFileVersion+' - BuildDate: '+{$I %date%};
  LoadContributors;
  LoadAcknowledgements;
end;

procedure TAboutForm.FormActivate(Sender: TObject);
begin
  PageControl1.ActivePageIndex:=0;
end;

procedure TAboutForm.LoadContributors;
var
  ContributorsFileName: string;
begin
  ContributorsPage.ControlStyle := ContributorsPage.ControlStyle - [csOpaque];
  Contributors:= TScrollingText.Create(ContributorsPage);
  Contributors.Name:='Contributors';
  Contributors.Parent := ContributorsPage;
  Contributors.Align:=alClient;

  ContributorsFileName:=AppDir+'contributors.txt';

  if FileExists(ContributorsFileName) then
    Contributors.Lines.LoadFromFile(ContributorsFileName)
  else
    Contributors.Lines.Text:=cContributors;
end;

procedure TAboutForm.LoadAcknowledgements;
var
  AcknowledgementsFileName: string;
begin
  Acknowledgements := TScrollingText.Create(AcknowledgementsPage);
  Acknowledgements.Name:='Acknowledgements';
  Acknowledgements.Parent := AcknowledgementsPage;
  Acknowledgements.Align:=alClient;

  AcknowledgementsFileName:=AppDir+'acknowledgements.txt';

  if FileExists(AcknowledgementsFileName) then
    Acknowledgements.Lines.LoadFromFile(AcknowledgementsFileName)
  else
    Acknowledgements.Lines.Text:=cAcknowledgements;
end;

{ TScrollingText }

procedure TScrollingText.SetActive(const AValue: boolean);
begin
  FActive := AValue;
  if FActive then
    Init;
  FTimer.Enabled:=Active;
end;

procedure TScrollingText.Init;
begin
  FBuffer.Width := Width;
  FBuffer.Height := Height;
  FLineHeight := FBuffer.Canvas.TextHeight('X');
  FNumLines := FBuffer.Height div FLineHeight;

  if FOffset = -1 then
    FOffset := FBuffer.Height;

  with FBuffer.Canvas do
  begin
    Brush.Color := clWhite;
    Brush.Style := bsSolid;
    FillRect(0, 0, Width, Height);
  end;
end;

procedure TScrollingText.DrawScrollingText(Sender: TObject);
begin
  if Active then
    Canvas.Draw(0,0,FBuffer);
end;

procedure TScrollingText.DoTimer(Sender: TObject);
var
  w: integer;
  s: string;
  i: integer;
begin
  if not Active then
    Exit;

  Dec(FOffset, FStepSize);

  if FOffSet < 0 then
    FStartLine := -FOffset div FLineHeight
  else
    FStartLine := 0;

  FEndLine := FStartLine + FNumLines + 1;
  if FEndLine > FLines.Count - 1 then
    FEndLine := FLines.Count - 1;

  FBuffer.Canvas.FillRect(Rect(0, 0, FBuffer.Width, FBuffer.Height));

  for i := FEndLine downto FStartLine do
  begin
    s := Trim(FLines[i]);

    //reset buffer font
    FBuffer.Canvas.Font.Style := [];
    FBuffer.Canvas.Font.Color := clBlack;

    //skip empty lines
    if Length(s) > 0 then
    begin
      //check for bold format token
      if s[1] = '#' then
      begin
        s := copy(s, 2, Length(s) - 1);
        FBuffer.Canvas.Font.Style := [fsBold];
      end
      else
      begin
        //check for url
        if (Pos('http://', s) = 1) or (Pos('https://', s) = 1) then
        begin
          if i = FActiveLine then
          begin
            FBuffer.Canvas.Font.Style := [fsUnderline];
            FBuffer.Canvas.Font.Color := clRed;
          end
          else
            FBuffer.Canvas.Font.Color := clBlue;
         end;
      end;

      w := FBuffer.Canvas.TextWidth(s);
      FBuffer.Canvas.TextOut((FBuffer.Width - w) div 2, FOffset + i * FLineHeight, s);
    end;
  end;

  //start showing the list from the start
  if FStartLine > FLines.Count - 1 then
    FOffset := FBuffer.Height;
  Invalidate;
end;

function TScrollingText.ActiveLineIsURL: boolean;
begin
  if (FActiveLine > 0) and (FActiveLine < FLines.Count) then
    Result := Pos('http://', FLines[FActiveLine]) = 1
  else
    Result := False;
end;

procedure TScrollingText.DoOnChangeBounds;
begin
  inherited DoOnChangeBounds;

  Init;
end;

procedure TScrollingText.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);

  if ActiveLineIsURL then
    OpenURL(FLines[FActiveLine]);
end;

procedure TScrollingText.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseMove(Shift, X, Y);

  //calculate what line is clicked from the mouse position
  FActiveLine := (Y - FOffset) div FLineHeight;

  Cursor := crDefault;

  if (FActiveLine >= 0) and (FActiveLine < FLines.Count) and ActiveLineIsURL then
    Cursor := crHandPoint;
end;

constructor TScrollingText.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle + [csOpaque];

  OnPaint := @DrawScrollingText;
  FLines := TStringList.Create;
  FTimer := TTimer.Create(nil);
  FTimer.OnTimer:=@DoTimer;
  FTimer.Interval:=30;
  FBuffer := TBitmap.Create;

  FStepSize := 1;
  FStartLine := 0;
  FOffset := -1;
end;

destructor TScrollingText.Destroy;
begin
  FLines.Free;
  FTimer.Free;
  FBuffer.Free;
  inherited Destroy;
end;

end.

