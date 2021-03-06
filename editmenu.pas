unit EditMenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,Figure,Tools,Transformation,Clipbrd,Load,History;

procedure SelectAllClick ;
procedure LoseSelectedClick ;
procedure DeleteClick ;
procedure CopyClick ;
procedure PastClick ;

var PastNumber : Integer;

implementation

procedure SelectAllClick ;
  var
    i: integer;
  begin
    if DownPress or (Length (Figures)=0)  then
      exit;
    for i := 0 to High (Figures) do
      Figures[i].Selected := True;
    EndingTransformaton := False;
    LastTool.Free;
    LastTool := TTransformationTools.Create;
    DestroyControls;
    GetGenericProps;
  end;

procedure LoseSelectedClick ;
  var
    i: integer;
  begin
    if DownPress then
      exit;
    for i := 0 to High (Figures) do
      Figures[i].Selected := False;
    if EndingTransformaton then begin
      LastTool.Free;
      LastTool := CurrentTool;
      EndingTransformaton := False;
    end
    else DestroyControls;
  end;

// Удаление

procedure Swap (var Figure1, Figure2: TFigure);
  var
    Buf: TFigure;
  begin
    Buf := Figure1;
    Figure1 := Figure2;
    Figure2 := Buf;
  end;

procedure DeleteClick ;
  var
    i, j: integer;
  begin
    if DownPress then
      exit;
    i := High (Figures);
    while (i <> -1) do begin
      if Figures[i].Selected then begin
        Figures[i].Free;
        Figures[i] := nil;
        for j := i to High (Figures) - 1 do
          Swap (Figures[j], Figures[j + 1]);
        SetLength (Figures, Length (Figures) - 1);
      end;
      Dec (i);
    end;
    NeedCreat := False;
    DownPress := False;
    Change.SaveNeed:=True ;
    IndexOfTranformer := -1;
  end;

// CopyPast
procedure CopyClick ;
  var
    i: integer;
  begin
    Clipboard.AsText := Signature + #13;
    for i := 0 to High (Figures) do begin
      if Figures[i].Selected then
        Clipboard.AsText := Clipboard.AsText + FigureToStr (Figures[i]) + #13;
    end;
    PastNumber := 1;
  end;

procedure PastClick ;
  var
    s, Str: string;
    posi, i: integer;
  begin
    Str := Clipboard.AsText;
    s := Copy (Str, 1, Pos (#13, Str) - 1);
    if s = Signature then begin
      Change.SaveNeed := True;
      for i := 0 to High (Figures) do
        if Figures[i].Selected then
          Figures[i].Selected := False;
      Str := Copy (Str, length (s) + 2, Length (Str) - length (s) - 1);
      posi := pos (#13, str);
      while posi <> 0 do begin
        s := Copy (Str, 1, posi - 1);
        if StrToFigure (s) <> nil then begin
          SetLength (Figures, Length (Figures) + 1);
          Figures[(High (Figures))] := StrToFigure (s);
        end;
        Str := Copy (Str, posi + 1, Length (Str) - posi);
        Figures[High (Figures)].Selected := True;
        for i := 0 to High (Figures[High (Figures)].FWorldPoints) do begin
          Figures[High (Figures)].FWorldPoints[i].X += 10 * PastNumber;
          Figures[High (Figures)].FWorldPoints[i].Y += (10 * PastNumber);
        end;
        posi := pos (#13, str);
      end;
    end;
    PastNumber += 1;
    LastTool.Free;
    LastTool := TTransformationTools.Create;
    IndexOfTranformer := -1;
    EndingTransformaton := False;
    DestroyControls;
    GetGenericProps;
  end;

end.

