unit EditorU;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ComCtrls, SynEdit;

type

TEdType=(vhdl, prg, verilog, systemverilog, ini, json, other);

TEditorF = record
  FileName: String;
  EdType: TEdType;
  Editor: TSynEdit;
  Page: TTabSheet;
  HasError: boolean;
end;


implementation

end.

