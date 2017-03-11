unit Transformation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Math;

type
  MegaPoint = record
    X: double;
    Y: double;
  end;
  MegaArray = array of MegaPoint;
  PointArray = array of TPoint;

  TEditAction = procedure (APoint: MegaPoint; Int: integer) of object;
  TAnchorAction = procedure (X, Y: integer) of object;

  TAnchorMoving = record
    Selected: boolean;
    Action: TEditAction;
    ind: integer;
  end;

const
  AnchorsSize = 5;

var
  Offset: TPoint;
  maxx, maxy, minx, miny, scale: double;
  CanvasSize: TPoint;
  DownPress: boolean;


function ScreenToWorld (Point: TPoint): MegaPoint;
function ScreenToWorldX (X: integer): double;
function ScreenToWorldY (Y: integer): double;
function WorldToScreen (Point: MegaPoint): TPoint;
function ScreenToWorld (x: array of TPoint): MegaArray;
function WorldToScreen (x: array of MegaPoint): PointArray;
function WorldToScreenX (X: double): integer;
function WorldToScreenY (Y: double): integer;
function PointW (X, Y: double): MegaPoint;
function MaxPosition (): TPoint;
function ConstructRect (Point1, Point2: TPoint): TRect;
function MinPosition (): TPoint;
function InNormText (Str: string): string;
function InNonNormText (Str: string): string;
procedure MaxMin (APoint: MegaPoint);

implementation

// Текст
function InNonNormText (Str: string): string;
  var
    i: integer;
  begin
    i := Pos ('|', Str);
    while i <> 0 do begin
      Result += Copy (Str, 1, i) + '*';
      Str := Copy (Str, i + 1, Length (Str) - i);
      i := Pos ('|', Str);
    end;
    Result += Str;
  end;

function InNormText (Str: string): string;
  var
    i: integer;
  begin
    i := Pos ('|*', Str);
    while i <> 0 do begin
      Result += Copy (Str, 1, i);
      Str := Copy (Str, i + 2, Length (Str) - i - 1);
      i := Pos ('|*', Str);
    end;
    Result += Str;
  end;

//Экранне в мировые
function ScreenToWorld (x: array of TPoint): MegaArray;
  var
    i: integer;
  begin
    SetLength (Result, Length (x));
    for i := 0 to High (x) do
      Result[i] := ScreenToWorld (x[i]);
  end;

function ScreenToWorld (Point: TPoint): MegaPoint;
  begin
    Result.X := (Point.X + Offset.X) / scale ;
    Result.Y := (Point.Y + Offset.Y) / scale ;
  end;

function ScreenToWorldX (X: integer): double;
  begin
      Result := (X + Offset.X) / scale;
  end;

function ScreenToWorldY (Y: integer): double;
  begin
      Result := (Y + Offset.Y) / scale;
  end;

//Мировые в экранные

function WorldToScreen (x: array of MegaPoint): PointArray;
  var
    i: integer;
  begin
    SetLength (Result, Length (x));
    for i := 0 to High (x) do
      Result[i] := WorldToScreen (x[i]);
  end;

function WorldToScreen (Point: MegaPoint): TPoint;
  begin
    Result.x := WorldToScreenX(Point.X);
    Result.y := WorldToScreenY(Point.Y);
  end;

function WorldToScreenX (X: double): integer;
  begin
      Result := round (x * scale) - Offset.X;
  end;

function WorldToScreenY (Y: double): integer;
  begin
      Result := round (Y * scale) - Offset.Y;
  end;


function ConstructRect (Point1, Point2: TPoint): TRect;
  begin
    Result := Rect (Min (Point1.X, Point2.X) - 1, Min (Point1.Y, Point2.Y) -
      1, Max (Point1.X, Point2.X), Max (Point1.Y, Point2.Y));
  end;

procedure MaxMin (APoint: MegaPoint);
  begin
    if APoint.X > maxX then
      maxX := APoint.X;
    if APoint.Y > maxY then
      maxY := APoint.Y;
    if APoint.X < minX then
      minX := APoint.X;
    if APoint.Y < minY then
      minY := APoint.Y;
  end;

function MaxPosition (): TPoint;
  begin
    if (maxx * scale - CanvasSize.X) > 0 then
      Result.X := round (maxx * scale - CanvasSize.X)
    else
      Result.X := 1;
    if (maxy * scale - CanvasSize.y) > 0 then
      Result.Y := round (maxy * scale - CanvasSize.Y)
    else
      Result.Y := 1;
  end;

function MinPosition (): TPoint;
  begin
    Result.X := round (minx * scale);
    Result.Y := round (miny * scale);
  end;

function PointW (X, Y: double): MegaPoint;
  begin
    Result.X := X;
    Result.Y := Y;
  end;

end.
