unit DataSheetU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, SynExportHTML, MarkdownProcessor, MarkdownUtils,
  SynHighlighterVHDL, SynHighlighterVerilog,
  SynHighlighterIni, SynHighlighterHTML, SynHighlighterPas, SynHighlighterCpp,
  SynHighlighterPython,
  LazFileUtils, StrUtils, LCLIntf;

type
{ TCodeEmiter }
TCodeEmiter = class(TBlockEmitter)
public
  procedure emitBlock(out_: TStringBuilder; lines: TStringList; meta: String); override;
end;

const
  CSSDecoration = '<style type="text/css">'#10+
                  'code{'#10+
                  '  color: #A00;'#10+
                  '}'#10+
                  'pre{'#10+
                  '  background: #f4f4f4;'#10+
                  '  border: 1px solid #ddd;'#10+
                  '  border-left: 3px solid #f36d33;'#10+
                  '  color: #555;'#10+
                  '  overflow: auto;'#10+
                  '  padding: 1em 1.5em;'#10+
                  '  display: block;'#10+
                  '}'#10+
                  'pre code{'#10+
                  '  color: inherit;'#10+
                  '}'#10+
                  'Blockquote{'#10+
                  '  border-left: 3px solid #d0d0d0;'#10+
                  '  padding-left: 0.5em;'#10+
                  '  margin-left:1em;'#10+
                  '}'#10+
                  'Blockquote p{'#10+
                  '  margin: 0;'#10+
                  '}'#10+
                  'table{'#10+
                  '  border:1px solid;'#10+
                  '  border-collapse:collapse;'#10+
                  '}'#10+
                  'th{'+
                  '  padding:5px;'#10+
                  '  background: #e0e0e0;'#10+
                  '  border:1px solid;'#10+
                  '}'#10+
                  'td{'#10+
                  '  padding:5px;'#10+
                  '  border:1px solid;'#10+
                  '}'#10+
                  '</style>'#10;


function Md2Html(fi:string):string;
function Md2Html(s, fi: string): string;
procedure OpenDataSheet(f:string);

implementation

uses
  ConfigFormU;

{ TCodeEmiter }

procedure TCodeEmiter.emitBlock(out_: TStringBuilder; lines: TStringList;
  meta: String);
var
  s:string;
  SynExporterHTML:TSynExporterHTML;

  procedure exportlines;
  var
    sstream: TStringStream;
  begin
    SynExporterHTML.Options:=SynExporterHTML.Options-[heoWinClipHeader];
    SynExporterHTML.ExportAll(lines);
    try
      sstream:=TStringStream.Create('');
      SynExporterHTML.SaveToStream(sstream);
      out_.Append(sstream.DataString);
    finally
      if assigned(sstream) then freeandnil(sstream);
    end;
  end;

begin
  SynExporterHTML := TSynExporterHTML.Create(nil);
  try
    case meta of
      'vhdl':
        begin
          SynExporterHTML.Highlighter:=TSynVHDLSyn.Create(SynExporterHTML);
          exportlines;
        end;
      'verilog','ver','sv':
        begin
          SynExporterHTML.Highlighter:=TSynVerilogSyn.Create(SynExporterHTML);
          exportlines;
        end;
      'html':
        begin
          SynExporterHTML.Highlighter:=TSynHTMLSyn.Create(SynExporterHTML);
          exportlines;
        end;
      'fpc','pas','pascal':
        begin
          SynExporterHTML.Highlighter:=TSynFreePascalSyn.Create(SynExporterHTML);
          exportlines;
        end;
      'cpp','c++','c':
        begin
          SynExporterHTML.Highlighter:=TSynCppSyn.Create(SynExporterHTML);
          exportlines;
        end;
      'py','python':
        begin
          SynExporterHTML.Highlighter:=TSynPythonSyn.Create(SynExporterHTML);
          exportlines;
        end;
       'ini':
         begin
          SynExporterHTML.Highlighter:=TSynIniSyn.Create(SynExporterHTML);
          exportlines;
         end
      else
        begin
          if meta='' then   out_.append('<pre><code>')
          else out_.append('<pre><code class="'+meta+'">');
          for s in lines do
          begin
            TUtils.appendValue(out_,s,0,Length(s));
            out_.append(#10);
          end;
          out_.append('</code></pre>'#10);
        end;
    end;
  finally
    SynExporterHTML.Free;
  end;
end;

function Md2Html(fi:string):string;
var
  md:TMarkdownProcessor=nil;
  fo,fn:string;
  html:TStringList;
begin
  result:=fi;
  fo:=extractFilePath(fi);
  fn:=extractFileNameOnly(fi)+'.html';
  try
    html := TStringList.Create;
    md := TMarkdownProcessor.createDialect(mdCommonMark);
    md.UnSafe := false;
    md.config.codeBlockEmitter:=TCodeEmiter.Create;
    fo:=IfThen(DirectoryIsWritable(fo),fo+fn,GetTempDir+fn);
    try
      html.Text := md.processFile(fi);
      if html.Text<>'' then
      begin
        html.Text:=CSSDecoration+html.Text;
        html.SaveToFile(fo);
        result:=fo;
      end;
    except
      ShowMessage('Can not create or process the temp html file');
    end;
  finally
    if assigned(md) then md.Free;
    if assigned(html) then html.Free;
  end;
end;

function Md2Html(s, fi: string): string;
var
  md:TMarkdownProcessor=nil;
  fo,fn:string;
  html:TStringList;
begin
  result:='';
  fn:=extractFileNameOnly(fi)+'.tmd.html';
  fo:=extractFilePath(fi);
  fo:=IfThen(DirectoryIsWritable(fo),fo+fn,TempFolder+fn);
  try
    html := TStringList.Create;
    md := TMarkdownProcessor.createDialect(mdCommonMark);
    md.UnSafe := false;
    md.config.codeBlockEmitter:=TCodeEmiter.Create;
    try
      html.Text := md.process(s);
      if html.Text<>'' then
      begin
        html.Text:=CSSDecoration+html.Text;
        html.SaveToFile(fo);
        result:=fo;
      end;
    except
      ShowMessage('Can not create or process the temp html file: '+fo);
    end;
  finally
    if assigned(md) then md.Free;
    if assigned(html) then html.Free;
  end;
end;

procedure OpenDataSheet(f:string);
var
  ftype:string;
begin
  ftype:=ExtractFileExt(f);
  case lowerCase(ftype) of
    '.markdown','.mdown','.mkdn',
    '.md','.mkd','.mdwn',
    '.mdtxt','.mdtext','.text',
    '.rmd':
      begin
        OpenURL('file://'+Md2Html(f));
      end;
    '.htm','.html':OpenURL('file://'+f);
  else
    OpenDocument(f);
  end;
end;

end.

