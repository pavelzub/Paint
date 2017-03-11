unit History;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Figure,Load;

type

  { FChange }

  TChange = class
   private
      //NeedHistory : Boolean;
    public
      procedure HistoryCreate (AFlag : Boolean);
      property SaveNeed : Boolean write HistoryCreate ;
  end;

var
  Histor: array [0..99] of string;
  MinHistoryIndex,  MaxHistoryIndex, HistoryIndex,SaveHistoryNumber : Integer ;
  Change : TChange;

implementation

{ FChange }

procedure TChange.HistoryCreate(AFlag: Boolean);
var i : Integer;
begin
  if AFlag then begin
      if HistoryIndex <> MaxHistoryIndex then
        MaxHistoryIndex := HistoryIndex;
      MaxHistoryIndex := (MaxHistoryIndex + 1) mod 100;
      HistoryIndex := MaxHistoryIndex;
      if MaxHistoryIndex = MinHistoryIndex then
        MinHistoryIndex := (MinHistoryIndex + 1) mod 100;
      Histor[HistoryIndex] := '';
      for i := 0 to High (Figures) do begin
        Histor[MaxHistoryIndex] += FigureToStr (Figures[i]) + #13;
      end;
    end;
end;

initialization
  Change:=TChange.Create;
  Histor[0] := '';
  HistoryIndex := 0;
  MaxHistoryIndex := 0;
  MinHistoryIndex := 0;

end.

