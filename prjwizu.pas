unit PrjWizU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, EditBtn, StdCtrls, Spin, Grids, ValEdit, Menus, fpjson, jsonparser,
  strutils, IniFilesUTF8, StringListUTF8, types;

const
  CDefPrjTitle='Short title or description of the project';

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
    procedure SummarizeData(SData: String);
    function ValidateSBAName(s: string): boolean;
    function ValidateName(s: string): boolean;
    { private declarations }
  public
    { public declarations }
    PrjData:String;
    function NewPrj: TModalResult;
    function EditPrj(SData: string): TModalResult;
    function CollectData: string;
    procedure FillPrjWizValues(SData: String);
    procedure ResetFormData;
  end;

var
  prjWizForm: TprjWizForm;

implementation

{$R *.lfm}

uses ConfigFormU, UtilsU, SBAProjectU, DebugFormU, FloatFormU;

{ TprjWizForm }

procedure TprjWizForm.PageBeforeShow(ASender: TObject; ANewPage: TPage;
  ANewIndex: Integer);
begin
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

function TprjWizForm.CollectData:string;
var
  i:integer;
  S,SData:String;
begin
  SData:='{'#10+
            '"name": "'+Ed_PrjName.text+'",'#10+
            '"location": "'+AppendPathDelim(L_PrjFinalLoc.caption)+'",'#10+
            '"title": "'+Ed_Prjtitle.text+'",'#10+
            '"author": "'+Ed_PrjAuthor.text+'",'#10+
            '"version": "'+L_PrjVersion.caption+'",'#10+
            '"date": "'+Ed_Date.text+'",'#10+
            '"description": "'+Ed_Description.text+'"';
  S:='';
  with Ed_TopInterface do for i:=1 to RowCount-1 do
  begin
    if Cells[0, i]<>'' then
    begin
      S+=#9'{"portname": "'+Cells[0, i]+'", '+
               '"dir": "'+Cells[1, i]+'", '+
               '"bus": '+Cells[2, i];
      if Cells[2, i]='1' then S+=', '+
               '"msb": '+Cells[3, i]+', '+
               '"lsb": '+Cells[4, i];
      S+='},'#10;
    end;
  end;
  if S<>'' then SData+=','#10'"interface": ['#10+LeftStr(S, length(S)-2)+#10']'
    else SData+=','#10'"interface": null';
  S:='';
  if PrjIpCoreList.Count>0 then for i:=0 to PrjIpCoreList.Count-1 do S+=#9'"'+PrjIpCoreList.Items[i]+'",'#10;
  if S<>'' then SData+=','#10'"ipcores": ['#10+LeftStr(S, length(S)-2)+#10']'
    else SData+=','#10'"ipcores": null';
  S:='';
  if UserFileList.Strings.Count>0 then for i:=0 to UserFileList.Strings.Count-1 do S+=#9'"'+UserFileList.Strings[i]+'",'#10;
  if S<>'' then SData+=','#10'"userfiles": ['#10+LeftStr(S, length(S)-2)+#10']'#10
    else SData+=','#10'"userfiles": null'#10;
  SData+='}';
  result:=SData;
end;

procedure TprjWizForm.SummarizeData(SData:String);
var
  J:TJSONData;
  S:String;
  i:integer;
begin
  try
    J:=GetJSON(ReplaceStr(SData,'\','/'));
  except
    on E:Exception do
    begin
      ShowMessage('The is an error in the project data. '+E.Message);
      exit;
    end;
  end;
  try
    S:='Name: '+J.FindPath('name').AsString+LineEnding+
       'Filename: '+J.FindPath('name').AsString+cSBAPrjExt+LineEnding+
       'Location: '+J.FindPath('location').AsString+LineEnding+
       LineEnding+
       'Title: '+J.FindPath('title').AsString+LineEnding+
       'Author: '+J.FindPath('author').AsString+LineEnding+
       'Version: '+J.FindPath('version').AsString+LineEnding+
       'Date: '+J.FindPath('date').AsString+LineEnding+
       'Description: '+J.FindPath('description').AsString+LineEnding+
       LineEnding;
    Summary.Text:=S;

    if not J.FindPath('interface').IsNull then
    begin
      Summary.Append('Top entity ports:');
      with J.FindPath('interface') do For i:=0 to count-1 do with Items[i] do
      begin
        S:=FindPath('portname').AsString+#09+
           FindPath('dir').AsString+#09;
        if FindPath('bus').AsInteger=1 then S+='bus('+FindPath('msb').AsString+':'+FindPath('lsb').AsString+')' else S+='pin';
        Summary.Append(S);
      end;
    end;

    if not J.FindPath('ipcores').IsNull then
    begin
      Summary.Append(LineEnding+'IP Cores added to Project:');
      Summary.Append(J.FindPath('ipcores').AsJSON);
    end;

    if not J.FindPath('userfiles').IsNull then
    begin
      Summary.Append(LineEnding+'User files added to Project:');
      For i:=0 to J.FindPath('userfiles').Count-1 do
        Summary.Append(J.FindPath('userfiles').Items[i].AsString);
    end;

  finally
    if assigned(J) then FreeAndNil(J);
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
      PrjData:=CollectData;
      SummarizeData(PrjData);
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
      PrjData:=S.Text;
    end;
  finally
    S.Free;
  end;
  if PrjData<>'' then FillPrjWizValues(PrjData);
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
    S.Text:=PrjData;
    if SaveDialog1.Execute then S.SaveToFile(SaveDialog1.FileName);
  finally
    S.Free;
  end;
end;

procedure TprjWizForm.B_RemoveFileClick(Sender: TObject);
begin
  if UserFileList.RowCount>1 then UserFileList.DeleteRow(UserFileList.Row);
end;

procedure TprjWizForm.FillPrjWizValues(SData: String);
var
  h,i:Integer;
  J:TJSONData;
  s:string;
begin
  try
    J:=GetJSON(ReplaceStr(SData,'\','/'));
  except
    on E:Exception do
    begin
      ShowMessage('The is an error in the project data, exiting...');
      exit;
    end;
  end;
  try
    Ed_PrjName.text:=J.FindPath('name').AsString;
    s:=ChompPathDelim(TrimFileName(J.FindPath('location').AsString));
    if AnsiEndsText(Ed_PrjName.text,s) then
      Ed_PrjLocation.text:=LeftStr(s,pos(Ed_PrjName.text,s)-1)
    else
      Ed_PrjLocation.text:=s;
    Ed_PrjTitle.Text:=J.FindPath('title').AsString;
    Ed_PrjAuthor.Text:=J.FindPath('author').AsString;
    Ed_Description.Text:=J.FindPath('description').AsString;
    s:=J.FindPath('version').AsString;
    Ed_MayorVer.Value:=StrtoIntDef(ExtractDelimited(1,s,['.']),0);
    Ed_MinVer.Value:=StrtoIntDef(ExtractDelimited(2,s,['.']),1);
    Ed_RevVer.Value:=StrtoIntDef(ExtractDelimited(3,s,['.']),1);
    L_PrjVersion.Caption:=s;
    Ed_Date.Text:=J.FindPath('date').AsString;
    if not J.FindPath('interface').IsNull then
    begin
      Ed_TopInterface.RowCount:=J.FindPath('interface').count+2;
      with Ed_TopInterface,J.FindPath('interface') do For i:=0 to count-1 do with Items[i] do
      begin
        Cells[0, i+1]:=FindPath('portname').AsString;
        Cells[1, i+1]:=FindPath('dir').AsString;
        Cells[2, i+1]:=FindPath('bus').AsString;
        if FindPath('bus').AsInteger=1 then
        begin
          Cells[3, i+1]:=FindPath('msb').AsString;
          Cells[4, i+1]:=FindPath('lsb').AsString;
        end;
      end;
    end;
    if not J.FindPath('ipcores').IsNull then
    begin
      with J.FindPath('ipcores') do For i:=0 to count-1 do
      begin
        h:=LibIpCoreList.Items.IndexOf(Items[i].AsString);
        if h<>-1 then
        begin
          LibIpCoreList.Items.Delete(h);
          PrjIpCoreList.Items.Add(Items[i].AsString);
        end else
        begin
          ShowMessage('The IP Core: '+Items[i].AsString+' is not available in your library.');
        end;
      end;
    end;
    try if not J.FindPath('userfiles').IsNull then
      with J.FindPath('userfiles') do For i:=0 to count-1 do
      begin
        s:=Items[i].AsString;
        UserFileList.Strings.Add(s);
      end;
    except
      ON E:Exception do UserFileList.Clear;
    end;
  finally
    if assigned(J) then FreeAndNil(J);
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

function TprjWizForm.EditPrj(SData: string): TModalResult;
begin
  Editing:=true;
  WizPages.PageIndex:=0;
  ResetFormData;
  FillPrjWizValues(SData);
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
  PrjData:='';
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

