unit EditorU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls, SynEdit;

type

TEdType=(vhdl, prg, verilog, systemverilog, ini, json, markdown, other);

TEditorF = record
  FileName: String;
  EdType: TEdType;
  Editor: TSynEdit;
  Page: TTabSheet;
  HasError: boolean;
end;

var
  EditorList:TFPList;

implementation

end.

