unit PrjWizU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, EditBtn, StdCtrls, Spin, Grids, ValEdit, Menus, strutils, types,
  IniFilesUTF8, StringListUTF8, SBAProjectU;

type

  { TprjWizForm }

  TprjWizForm = class(TForm)
    B_AddFile: TBitBtn;
    B_RemoveFile: TBitBtn;
    B_PrjSaveAsTemplate: TBitBtn;
    B_PrjLoadFromTemplate: TBitBtn;
    B_CoreDel: TBitBtn;
    B_CoreAdd: TBitBtn;
    B_Cancel: TBitBtn;
    B_Ok: TBitBtn;
    B_Next: TBitBtn;
    B_Previous: TBitBtn;
    CB_CreateSubDir: TCheckBox;
    CheckBox1: TCheckBox;
    Ed_Date: TDateEdit;
    Ed_PrjLocation: TDirectoryEdit;
    Image1: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LibIpCoreList: TListBox;
    LabelX: TLabel;
    InsertRow: TMenuItem;
    RowDelete: TMenuItem;
    OpenDialog1: TOpenDialog;
    Page4: TPage;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    Summary: TMemo;
    PrjIpCoreList: TListBox;
    L_PrjVersion: TLabel;
    Label3: TLabel;
    Ed_PrjName: TLabeledEdit;
    Label4: TLabel;
    Ed_PrjAuthor: TLabeledEdit;
    Ed_PrjTitle: TLabeledEdit;
    L_PrjFinalLoc: TLabel;
    Label5: TLabel;
    Ed_Description: TMemo;
    Page3: TPage;
    ProgressPanel: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Ed_MayorVer: TSpinEdit;
    Ed_MinVer: TSpinEdit;
    Ed_RevVer: TSpinEdit;
    StaticText1: TStaticText;
    Ed_TopInterface: TStringGrid;
    StaticText2: TStaticText;
    TB_Start: TToggleBox;
    TB_Step2: TToggleBox;
    TB_Step3: TToggleBox;
    TB_Step4: TToggleBox;
    TB_End: TToggleBox;
    UserFileList: TValueListEditor;
    WizPages: TNotebook;
    StartPage: TPage;
    Page2: TPage;
    EndPage: TPage;
    NavPanel: TPanel;
    procedure B_AddFileClick(Sender: TObject);
    procedure B_CoreAddClick(Sender: TObject);
    procedure B_CoreDelClick(Sender: TObject);
    procedure B_NextClick(Sender: TObject);
    procedure B_PreviousClick(Sender: TObject);
    procedure B_PrjLoadFromTemplateClick(Sender: TObject);
    procedure B_PrjSaveAsTemplateClick(Sender: TObject);
    procedure B_RemoveFileClick(Sender: TObject);
    procedure Ed_MayorVerChange(Sender: TObject);
    procedure Ed_PrjNameChange(Sender: TObject);
    procedure Ed_PrjNameEditingDone(Sender: TObject);
    procedure Ed_TopInterfaceCheckboxToggled(sender: TObject; aCol,
      aRow: Integer; aState: TCheckboxState);
    procedure Ed_TopInterfaceContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Ed_TopInterfaceEditingDone(Sender: TObject);
    procedure Ed_TopInterfaceExit(Sender: TObject);
    procedure Ed_TopInterfacePrepareCanvas(sender: TObject; aCol,
      aRow: Integer; aState: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure InsertRowClick(Sender: TObject);
    procedure LibIpCoreListDblClick(Sender: TObject);
    procedure ListMouseLeave(Sender: TObject);
    procedure ListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PageBeforeShow(ASender: TObject; ANewPage: TPage;
      ANewIndex: Integer);
    procedure PrjIpCoreListDblClick(Sender: TObject);
    procedure RowDeleteClick(Sender: TObject);
  private
    Editing:boolean;
    procedure SummarizeData(Prj:TSBAPrj);
    function ValidateSBAName(s: string): boolean;
    function ValidateName(s: string): boolean;
    { private declarations }
  public
    { public declarations }
    function NewPrj: TModalResult;
    function EditPrj(Prj:TSBAPrj): TModalResult;
    procedure CollectData(Prj:TSBAPrj);
    procedure FillPrjWizValues(Prj:TSBAPrj);
    procedure ResetFormData;
  end;

var
  prjWizForm: TprjWizForm;

implementation

{$R *.lfm}

uses ConfigFormU, UtilsU, DebugFormU, FloatFormU;

{ TprjWizForm }

procedure TprjWizForm.PageBeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
  { TODO : Linux BUG, Mejorar la apariencia de los indicadores de pasos (steps) usar paneles en vez de TToggle }
  TB_Start.Checked:=false;
  TB_Step2.Checked:=false;
  TB_Step3.Checked:=false;
  TB_Step4.Checked:=false;
  TB_End.Checked:=false;
  case ANewIndex of
  0://if ANewPage=StartPage then
  begin
    B_Previous.Visible:=false;
    B_Next.visible:=true;
    B_Next.Default:=true;
    B_Ok.visible:=false;
    TB_Start.Checked:=true;
  end;
  1://if ANewPage=Page2 then
  begin
    B_Previous.Visible:=true;
    B_Next.visible:=true;
    B_Next.Default:=true;
    TB_Step2.Checked:=true;
  end;
  2://if ANewPage=Page3 then
  begin
    B_Previous.Visible:=true;
    B_Next.visible:=true;
    B_Next.Default:=true;
    TB_Step3.Checked:=true;
  end;
  3://if ANewPage=Page4 then
  begin
    B_Previous.Visible:=true;
    B_Next.visible:=true;
    B_Next.Default:=true;
    B_Ok.visible:=false;
    TB_Step4.Checked:=true;
  end;
  4://if ANewPage=EndPage then
  begin
    B_Next.visible:=false;
    B_Ok.visible:=true;
    B_Ok.Default:=true;
    TB_End.Checked:=true;
  end;
  end;
end;

procedure TprjWizForm.PrjIpCoreListDblClick(Sender: TObject);
begin
  B_CoreDelClick(nil);
end;

procedure TprjWizForm.CollectData(Prj:TSBAPrj);
var
  i:integer;
begin
  With Prj do
  begin
    name:=Ed_PrjName.text;
    location:=AppendPathDelim(L_PrjFinalLoc.caption);
    loclib:=location+'lib'+PathDelim;
    title:=Ed_Prjtitle.text;
    author:=Ed_PrjAuthor.text;
    version:=L_PrjVersion.caption;
    date:=Ed_Date.text;
    description:=Ed_Description.text;
    ports.Clear;
    with Ed_TopInterface do for i:=1 to RowCount-1 do
      if Cells[0, i]<>'' then ports.Append(Rows[i].CommaText);
    libcores.Assign(PrjIpCoreList.Items);
    userfiles.Assign(UserFileList.Strings);
    modified:=true;
  end;
end;

procedure TprjWizForm.SummarizeData(Prj: TSBAPrj);
var
  S:String;
  i:integer;
begin
  S:='Name: '+Prj.name+LineEnding+
     'Filename: '+Prj.name+cSBAPrjExt+LineEnding+
     'Location: '+Prj.location+LineEnding+
     LineEnding+
     'Title: '+Prj.title+LineEnding+
     'Author: '+Prj.author+LineEnding+
     'Version: '+Prj.version+LineEnding+
     'Date: '+Prj.date+LineEnding+
     'Description: '+Prj.description+LineEnding+
     LineEnding;
  Summary.Text:=S;

  if Prj.ports.Count>0 then
  begin
    Summary.Append('Top entity ports:');
    with Prj do For i:=0 to ports.count-1 do
    begin
      S:=ExtractDelimited(1,ports[i],[','])+#09+
         ExtractDelimited(2,ports[i],[','])+#09;
      if ExtractDelimited(3,ports[i],[','])='1' then S+='bus('+
         ExtractDelimited(4,ports[i],[','])+':'+
         ExtractDelimited(5,ports[i],[','])+')' else S+='pin';
      Summary.Append(S);
    end;
  end;
  Summary.Append('');

  if Prj.libcores.Count>0 then
  begin
    Summary.Append('IP Cores added to Project:');
    Summary.Append(Prj.libcores.Text);
  end;

  if Prj.userfiles.Count>0 then
  begin
    Summary.Append('User files added to Project:');
    For i:=0 to Prj.userfiles.Count-1 do Summary.Append(Prj.userfiles.Names[i]);
  end;
end;

procedure TprjWizForm.B_NextClick(Sender: TObject);
begin
  case WizPages.PageIndex of
    0: begin
      If not Editing and DirectoryExistsUTF8(L_PrjFinalLoc.caption) and not IsDirectoryEmpty(L_PrjFinalLoc.caption) and
        (MessageDlg('Overwrite Files?','The project folder "'+L_PrjFinalLoc.caption+
                    '" already exist.', mtConfirmation, [mbYes, mbCancel],0)<>mrYes) then exit;
    end;
    3: begin
      CollectData(SBAPrj);
      SummarizeData(SBAPrj);
    end;
  end;
  WizPages.PageIndex:=WizPages.PageIndex+1;
end;

procedure TprjWizForm.B_CoreAddClick(Sender: TObject);
var
  i,j:integer;
  f,ipname,s:string;
  Ini:TIniFile;
  EL:TStringList;
begin
  if LibIpCoreList.SelCount > 0 then
  begin
    LibIpCoreList.Items.BeginUpdate;
    For i:=LibIpCoreList.Items.Count-1 downto 0 do if LibIpCoreList.Selected[i] then
    begin
      ipname:=LibIpCoreList.Items[i];
      PrjIpCoreList.Items.Add(ipname);
      LibIpCoreList.Items.Delete(i);
      f:=LibraryDir+ipname+PathDelim+ipname+'.ini';
      if fileexistsUTF8(f) then
      try
        EL:=TStringList.Create;
        INI:=TIniFile.Create(f);
        INI.ReadSectionRaw('External',EL);
        for j:=0 to EL.Count-1 do with Ed_TopInterface do
        begin
          RowCount:=RowCount+1;
          s:=EL.ValueFromIndex[j];
          s:=IfThen(Pos(':',s)=0,s+',0',StringsReplace(s,['(',':',')'],[',1,',',',''],[rfReplaceAll]));
          s:=EL.Names[j]+','+s;
          Ed_TopInterface.Rows[RowCount-1].CommaText:=s;
        end;
      finally
        if assigned(EL) then FreeAndNil(EL);
        if assigned(INI) then FreeAndNil(INI);
      end;
    end;
    LibIpCoreList.Items.EndUpdate;
  end else
  begin
    ShowMessage('Please select an item first!');
  end;
end;

procedure TprjWizForm.B_AddFileClick(Sender: TObject);
var
  f,s:string;
  r:integer;
begin
  OpenDialog1.Options:=OpenDialog1.Options+[ofAllowMultiSelect];
  OpenDialog1.DefaultExt:='';
  OpenDialog1.Filter:='';
  if OpenDialog1.Execute then for s in OpenDialog1.Files do if fileexistsUTF8(s) then
  begin
    f:=ExtractFileName(s);
    if UserFileList.FindRow(f,r) then
    begin
      ShowMessage('The file is already in the list');
      UserFileList.Row:=r;
      continue;
    end;
    UserFileList.Strings.Append(f+'='+extractfilepath(s));
  end else ShowMessage('The user file: '+s+',could not be found.');
end;

procedure TprjWizForm.B_CoreDelClick(Sender: TObject);
var
  i,j,k:integer;
  f,ipname:string;
  Ini:TIniFile;
  EL:TStringList;
begin
  if PrjIpCoreList.SelCount > 0 then
  begin
    PrjIpCoreList.Items.BeginUpdate;
    For i:=PrjIpCoreList.Items.Count-1 downto 0 do if PrjIpCoreList.Selected[i] then
    begin
      ipname:=PrjIpCoreList.Items[i];
      LibIpCoreList.Items.Add(ipname);
      PrjIpCoreList.Items.Delete(i);
      f:=LibraryDir+ipname+PathDelim+ipname+'.ini';
      if fileexistsUTF8(f) then
      try
        EL:=TStringList.Create;
        INI:=TIniFile.Create(f);
        INI.ReadSectionRaw('External',EL);
        for j:=0 to EL.Count-1 do with Ed_TopInterface do
        begin
          k:=Ed_TopInterface.Cols[0].IndexOf(EL.Names[j]);
          if k>0 then Ed_TopInterface.DeleteColRow(False,k);
        end;
      finally
        if assigned(EL) then FreeAndNil(EL);
        if assigned(INI) then FreeAndNil(INI);
      end;
    end;
    PrjIpCoreList.Items.EndUpdate;
  end else
  begin
    ShowMessage('Please select an item first!');
  end;
end;

procedure TprjWizForm.B_PreviousClick(Sender: TObject);
begin
  WizPages.PageIndex:=WizPages.PageIndex-1;
end;

procedure TprjWizForm.B_PrjLoadFromTemplateClick(Sender: TObject);
var
  S:TStringList;
begin
  OpenDialog1.Options:=OpenDialog1.Options-[ofAllowMultiSelect];
  OpenDialog1.DefaultExt:='.sba';
  OpenDialog1.Filter:='SBA Project|*.sba';
  try
    S:=TStringList.Create;
    if OpenDialog1.Execute then
    begin
      S.LoadFromFile(OpenDialog1.FileName);
      ResetFormData;
      SBAPrj.Fill(S.Text);
    end;
  finally
    S.Free;
  end;
  if SBAPrj.name<>'' then FillPrjWizValues(SBAPrj);
  Ed_prjLocation.Text:=ProjectsDir;
end;

procedure TprjWizForm.B_PrjSaveAsTemplateClick(Sender: TObject);
var
  S:TStringList;
begin
  SaveDialog1.DefaultExt:='.sba';
  SaveDialog1.Filter:='SBA Project|*.sba';
  try
    S:=TStringList.Create;
    S.Text:=SBAPrj.Collect;
    if SaveDialog1.Execute then S.SaveToFile(SaveDialog1.FileName);
  finally
    S.Free;
  end;
end;

procedure TprjWizForm.B_RemoveFileClick(Sender: TObject);
begin
  if UserFileList.RowCount>1 then UserFileList.DeleteRow(UserFileList.Row);
end;

procedure TprjWizForm.FillPrjWizValues(Prj: TSBAPrj);
var
  h,i:Integer;
  s:string;
begin
  With Prj do
  begin
    Ed_PrjName.text:=name;
    s:=ChompPathDelim(TrimFileName(location));
    if AnsiEndsText(Ed_PrjName.text,s) then
      Ed_PrjLocation.text:=LeftStr(s,pos(Ed_PrjName.text,s)-1)
    else
      Ed_PrjLocation.text:=s;
    Ed_PrjTitle.Text:=title;
    Ed_PrjAuthor.Text:=author;
    Ed_Description.Text:=description;
    s:=version;
    Ed_MayorVer.Value:=StrtoIntDef(ExtractDelimited(1,s,['.']),0);
    Ed_MinVer.Value:=StrtoIntDef(ExtractDelimited(2,s,['.']),1);
    Ed_RevVer.Value:=StrtoIntDef(ExtractDelimited(3,s,['.']),1);
    L_PrjVersion.Caption:=s;
    Ed_Date.Text:=date;
    if ports.Count>0 then
    begin
      Ed_TopInterface.RowCount:=ports.count+2;
      with Ed_TopInterface do For i:=0 to ports.count-1 do
      begin
        s:=ports[i];
        Cells[0, i+1]:=ExtractDelimited(1,s,[',']);
        Cells[1, i+1]:=ExtractDelimited(2,s,[',']);
        Cells[2, i+1]:=ExtractDelimited(3,s,[',']);
        if Cells[2, i+1]='1' then
        begin
          Cells[3, i+1]:=ExtractDelimited(4,s,[',']);
          Cells[4, i+1]:=ExtractDelimited(5,s,[',']);
        end;
      end;
    end;
    if libcores.count>0 then
    begin
      For i:=0 to libcores.count-1 do
      begin
        h:=LibIpCoreList.Items.IndexOf(libcores[i]);
        if h<>-1 then
        begin
          LibIpCoreList.Items.Delete(h);
          PrjIpCoreList.Items.Add(libcores[i]);
        end else
        begin
          ShowMessage('The IP Core: '+libcores[i]+' is not available in your library.');
        end;
      end;
    end;
    UserFileList.Strings.Assign(userfiles);
  end;
end;


procedure TprjWizForm.Ed_MayorVerChange(Sender: TObject);
begin
  L_PrjVersion.caption:=Ed_MayorVer.Text+'.'+Ed_MinVer.Text+'.'+Ed_RevVer.Text;
end;

procedure TprjWizForm.Ed_PrjNameChange(Sender: TObject);
Var s:string;
begin
  s:=AppendPathDelim(TrimFilename(Ed_PrjLocation.text));
  s+=IfThen(CB_CreateSubDir.Checked,Ed_PrjName.Text);
  L_PrjFinalLoc.caption:=TrimFilename(s);
end;

procedure TprjWizForm.Ed_PrjNameEditingDone(Sender: TObject);
begin
  B_Next.Enabled:=ValidateSBAName(Ed_PrjName.Text);
  B_PrjLoadFromTemplate.Enabled:=B_Next.Enabled;
end;

procedure TprjWizForm.Ed_TopInterfaceCheckboxToggled(sender: TObject; aCol,
  aRow: Integer; aState: TCheckboxState);
begin
  with Ed_TopInterface do if Cells[2,aRow]='1' then
  begin
    Cells[3,aRow]:='0';
    Cells[4,aRow]:='0';
  end else
  begin
    Cells[3,aRow]:='';
    Cells[4,aRow]:='';
  end;
end;

procedure TprjWizForm.Ed_TopInterfaceContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
var NewCell: TPoint;
begin
  NewCell:=Ed_TopInterface.MouseToCell(MousePos);
  Ed_TopInterface.Col:=NewCell.X;
  Ed_TopInterface.Row:=NewCell.Y;
end;

procedure TprjWizForm.RowDeleteClick(Sender: TObject);
begin
  if Ed_TopInterface.Row=0 then exit;
  Ed_TopInterface.DeleteColRow(False, Ed_TopInterface.Row);
end;

procedure TprjWizForm.InsertRowClick(Sender: TObject);
begin
  Ed_TopInterface.InsertColRow(False, Ed_TopInterface.Row);
end;

procedure TprjWizForm.Ed_TopInterfaceEditingDone(Sender: TObject);
begin
  with Ed_TopInterface do
  begin
    Ed_TopInterface.BeginUpdate;
    if (Col=0) then
    begin
      if Cells[1,Row]='' then Cells[1,Row]:='in';
      if Cells[2,Row]='' then Cells[2,Row]:='0';
    end;
    Ed_TopInterface.EndUpdate(true);
  end;
  B_Next.Enabled:=True;
  B_Previous.Enabled:=True;
end;

procedure TprjWizForm.Ed_TopInterfaceExit(Sender: TObject);
var
  i,j:integer;
  s:string;
  V:boolean;
begin
  With Ed_TopInterface do
  begin
    For i:=RowCount-1 downto 1 do if (i<RowCount-1) and (Cells[0,i]='') then DeleteColRow(False,i);
    V:=true;
    For i:=1 to RowCount-1 do
    begin
      S:=Cells[0,i];
      If S='' then break;
      V:=V and ValidateName(S);
      for j:=1 to RowCount-1 do V:=V and ((j=i) or (CompareText(S,Cells[0,j])<>0));
    end;
  end;
  B_Next.Enabled:=V;
  B_Previous.Enabled:=V;
end;

procedure TprjWizForm.Ed_TopInterfacePrepareCanvas(sender: TObject; aCol,
  aRow: Integer; aState: TGridDrawState);
var
  S:String;
  V:Boolean;
  i:integer;
begin
  If (gdFixed in aState) or (aCol<>0) or (aRow=0) then exit;
  With Ed_TopInterface do
  begin
    S:=Cells[0,aRow];
    if S<>'' then
    begin
      V:=ValidateName(S);
      for i:=1 to RowCount-1 do V:=V and ((i=aRow) or (CompareText(Cells[0,i],S)<>0));
    end;
    if not V then Ed_TopInterface.canvas.Brush.Color:=$008080FF;
  end;
end;

procedure TprjWizForm.FormShow(Sender: TObject);
begin
  Ed_Prjname.SetFocus;
end;

function TprjWizForm.ValidateSBAName(s:string):boolean;
begin
  result:=false;
  if s='' then exit;
  Image1.Picture.Bitmap:= nil;
  ImageList1.GetBitmap(1, Image1.Picture.Bitmap);
  if ValidateName(s) then
  begin
    Image1.Picture.Bitmap:= nil;
    ImageList1.GetBitmap(2, Image1.Picture.Bitmap);
    result:=true;
  end;
end;

function TprjWizForm.ValidateName(s: string): boolean;
var i:integer;
begin
  result:=false;
  if s='' then exit;
  if not(upcase(s[1]) in ['A'..'Z']) then exit;
  for i:=2 to Length(s) do if not (upcase(s[i]) in ['0'..'9','A'..'Z','_']) then exit;
  result:=true;
end;

function TprjWizForm.NewPrj: TModalResult;
begin
  WizPages.PageIndex:=0;
  ResetFormData;
  Editing:=false;
  result:=ShowModal;
end;

function TprjWizForm.EditPrj(Prj: TSBAPrj): TModalResult;
begin
  Editing:=true;
  WizPages.PageIndex:=0;
  ResetFormData;
  FillPrjWizValues(Prj);
  result:=ShowModal;
end;

procedure TprjWizForm.ResetFormData;
begin
  Ed_Prjname.text:=cSBADefaultPrjName;
  Ed_PrjLocation.Directory:=ProjectsDir;
  Ed_PrjLocation.RootDir:=ProjectsDir;
  CB_CreateSubDir.Checked:=false;
  Image1.Picture.Bitmap:= nil;
  ImageList1.GetBitmap(0, Image1.Picture.Bitmap);
  Ed_PrjAuthor.Text:=DefAuthor;
  Ed_PrjTitle.Text:=CDefPrjTitle;
  Ed_MayorVer.Value:=0;
  Ed_MinVer.Value:=1;
  Ed_RevVer.Value:=1;
  Ed_Date.Date:=Now;
  Ed_Description.Clear;
  Ed_TopInterface.Clean;
  Ed_TopInterface.RowCount:=3;
  with Ed_TopInterface do
  begin
    Cells[0, 1]:='CLK_I';
    Cells[1, 1]:='in';
    Cells[2, 1]:='0';
    Cells[0, 2]:='RST_I';
    Cells[1, 2]:='in';
    Cells[2, 2]:='0';
  end;
  LibIpCoreList.Items.Assign(IpCoreList);
  PrjIpCoreList.Clear;
  UserFileList.Clear;
end;

procedure TprjWizForm.LibIpCoreListDblClick(Sender: TObject);
begin
  B_CoreAddClick(nil);
end;

procedure TprjWizForm.ListMouseLeave(Sender: TObject);
begin
  FloatForm.L_CoreName.caption:='';
  FloatForm.hide;
end;

procedure TprjWizForm.ListMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  i: Integer;
  L:TListBox;
begin
  If not Sender.ClassNameIs('TListBox') then exit;
  L:=TListBox(Sender);
  P:=Mouse.CursorPos;
  FloatForm.Top:=P.Y+10;
  FloatForm.Left:=P.X+10;
  i:=L.GetIndexAtXY(X,Y);
  if i>=0 then
  begin
    FloatForm.ShowCoreImage(L.Items[i]);
  end else begin
    FloatForm.L_CoreName.caption:='';
    FloatForm.hide;
  end;
end;

end.

