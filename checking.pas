unit Checking;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Windows, Transformation, Figure, Math;

function Check (Figure: TFigure; Point1, Point2: MegaPoint): boolean;

implementation

procedure Swap (var a, b: double);
  var
    Buf: double;
  begin
    Buf := a;
    a := b;
    b := Buf;
  end;

function Intersect (a, b, c, d: MegaPoint): boolean;

  function IntersectAux (a, b, c, d: double): boolean;
    begin
      if (a > b) then
        swap (a, b);
      if (c > d) then
        swap (c, d);
      Result := max (a, c) <= min (b, d);
    end;

  function Area (a, b, c: MegaPoint): double;
    begin
      Result := (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
    end;

  begin
    Result := IntersectAux (a.x, b.x, c.x, d.x) and
      IntersectAux (a.y, b.y, c.y, d.y) and (Area (a, b, c) * Area (a, b, d) <= 0) and
      (Area (c, d, a) * Area (c, d, b) <= 0);
  end;

function Check (Figure: TFigure; Point1, Point2: MegaPoint): boolean;
  var
    Region: HRGN;
    i: integer;
    Points: PointArray;
    Center: TPoint;
    x0, y0, r, angle: double;
  begin
    SetLength (Points, Length (Figure.FWorldPoints));
    if Figure is TPencil then begin
      if Point1.X = Point2.X then begin
        Point1.X -= Round (5 / scale);
        Point1.Y -= Round (5 / scale);
        Point2.X += Round (5 / scale);
        Point2.Y += Round (5 / scale);
      end;
      for i := 0 to High (Figure.FWorldPoints) - 1 do begin
        if Intersect (Figure.FWorldPoints[i], Figure.FWorldPoints[i + 1],
          PointW (Point1.X, Point1.Y), PointW (Point1.X, Point2.Y)) or
          Intersect (Figure.FWorldPoints[i], Figure.FWorldPoints[i + 1],
          PointW (Point1.X, Point2.Y), PointW (Point2.X, Point2.Y)) or
          Intersect (Figure.FWorldPoints[i], Figure.FWorldPoints[i + 1],
          PointW (Point2.X, Point2.Y), PointW (Point2.X, Point1.Y)) or
          Intersect (Figure.FWorldPoints[i], Figure.FWorldPoints[i + 1],
          PointW (Point2.X, Point1.Y), PointW (Point1.X, Point1.Y)) or
          ((Figure.FWorldPoints[i].X < max (Point1.X, Point2.X)) and
          (Figure.FWorldPoints[i].X > min (Point1.X, Point2.X)) and
          (Figure.FWorldPoints[i].Y < max (Point1.Y, Point2.Y)) and
          (Figure.FWorldPoints[i].Y > min (Point1.Y, Point2.Y))) then begin
          Exit (True);
          DeleteObject (Region);
        end;
      end;
    end;
    for i := 0 to High (Figure.FWorldPoints) do
      Points[i] := WorldToScreen (Figure.FWorldPoints[i]);
    if Figure is TPolygon then begin
      for i := 0 to High (Figure.FWorldPoints) do
        Points[i] := WorldToScreen (Figure.FWorldPoints[i]);
      Region := CreatePolygonRgn (Points[0], Length (Points), WINDING);
      if RectInRegion (Region, ConstructRect (WorldToScreen (Point2),
        WorldToScreen (Point1))) then begin
        Exit (True);
        DeleteObject (Region);
      end;
    end;
    if Figure is TRoundRectangl then begin
      for i := 0 to High (Figure.FWorldPoints) do
        Points[i] := WorldToScreen (Figure.FWorldPoints[i]);
      for i := 0 to High (Figure.FWorldPoints) - 1 do begin
        Region := CreateRoundRectRgn (Points[i].X, Points[i].Y,
          Points[i + 1].X, Points[i + 1].Y, (Figure as TRoundRectangl).RoundX,
          (Figure as TRoundRectangl).RoundY);
        if RectInRegion (Region, ConstructRect (WorldToScreen (Point2),
          WorldToScreen (Point1))) then begin
          Exit (True);
          DeleteObject (Region);
        end;
      end;
    end;
    if Figure is TEllipse then begin
      for i := 0 to High (Figure.FWorldPoints) do
        Points[i] := WorldToScreen (Figure.FWorldPoints[i]);
      for i := 0 to High (Figure.FWorldPoints) - 1 do begin
        Region := CreateEllipticRgn (Points[0].X, Points[0].Y, Points[1].X, Points[1].Y);
        if RectInRegion (Region, ConstructRect (WorldToScreen (Point2),
          WorldToScreen (Point1))) then begin
          Exit (True);
          DeleteObject (Region);
        end;
      end;
    end;
    if Figure is TRectangl then begin
      for i := 0 to High (Figure.FWorldPoints) do
        Points[i] := WorldToScreen (Figure.FWorldPoints[i]);
      for i := 0 to High (Figure.FWorldPoints) - 1 do begin
        Region := CreateRectRgn (Points[0].X, Points[0].Y, Points[2].X, Points[2].Y);
        if RectInRegion (Region, ConstructRect (WorldToScreen (Point2),
          WorldToScreen (Point1))) then begin
          Exit (True);
          DeleteObject (Region);
        end;
      end;
    end;
    if Figure is TText then begin
      for i := 0 to High (Figure.FWorldPoints) do
        Points[i] := WorldToScreen (Figure.FWorldPoints[i]);
      for i := 0 to High (Figure.FWorldPoints) - 1 do begin
        Region := CreateRectRgn (Points[0].X, Points[0].Y, Points[1].X, Points[1].Y);
        if RectInRegion (Region, ConstructRect (WorldToScreen (Point2),
          WorldToScreen (Point1))) then begin
          Exit (True);
          DeleteObject (Region);
        end;
      end;
    end;
    if Figure is TRegularPolygon then begin
      SetLength (Points, (Figure as TRegularPolygon).Tops);
      Center := WorldToScreen (Figure.FWorldPoints[0]);
      x0 := WorldToScreen (Figure.FWorldPoints[1]).X - Center.X;
      y0 := WorldToScreen (Figure.FWorldPoints[1]).Y - Center.Y;
      r := sqrt (x0 * x0 + y0 * y0);
      if r = 0 then
        Exit;
      angle := arccos (x0 / r);
      if y0 < 0 then
        angle *= -1;
      for i := 0 to (Figure as TRegularPolygon).Tops - 1 do begin
        angle += 2 * pi / (Figure as TRegularPolygon).Tops;
        Points[i].X := Round (r * cos (angle) + Center.X);
        Points[i].Y := Round (r * sin (angle) + Center.Y);
      end;
      Region := CreatePolygonRgn (Points[0], Length (Points), WINDING);
      if RectInRegion (Region, ConstructRect (WorldToScreen (Point2),
        WorldToScreen (Point1))) then begin
        Exit (True);
        DeleteObject (Region);
      end;
    end;
    if Figure is TSprey then begin
      for i := 0 to High (Figure.FWorldPoints) do
        Points[i] := WorldToScreen (Figure.FWorldPoints[i]);
      for i := 0 to High (Figure.FWorldPoints) do begin
        Region := CreateEllipticRgn (Points[i].X + (Figure as TSprey).Size,
          Points[i].Y + (Figure as TSprey).Size, Points[i].X -
          (Figure as TSprey).Size, Points[i].Y - (Figure as TSprey).Size);
        if RectInRegion (Region, ConstructRect (WorldToScreen (Point2),
          WorldToScreen (Point1))) then begin
          Exit (True);
          DeleteObject (Region);
        end;
        DeleteObject (Region);
      end;
    end;
    DeleteObject (Region);
    Result := False;

  end;
























end.
