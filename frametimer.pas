unit FrameTimer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Transformation, Figure, Graphics,math ;

type

  TFrame = class(TPersistent)
  private
    FrameMax, FrameMin: MegaPoint;
  public
    FrameTime: integer;
    procedure FrameSize;
    procedure FrameAnchorsMove (Pt: MegaPoint; ind: integer);
    function CheckFrameAnchors (Pt3: MegaPoint): TAnchorMoving;
    procedure CreateFrame (ACanvas: TCanvas);
  end;

var
  Frame: TFrame;

implementation

procedure TFrame.FrameSize;
  var
    i: integer;
  begin
    for i := 0 to High (Figures) do
      if Figures[i].Selected then begin
        FrameMax := Figures[i].Maxpoint;
        FrameMin := Figures[i].Minpoint;
        Break;
      end;
    for i := i to High (Figures) do
      if Figures[i].Selected then begin
        if FrameMax.x < Figures[i].Maxpoint.x then
          FrameMax.x := Figures[i].Maxpoint.x;
        if FrameMax.y < Figures[i].Maxpoint.y then
          FrameMax.y := Figures[i].Maxpoint.y;
        if FrameMin.x > Figures[i].Minpoint.x then
          FrameMin.x := Figures[i].Minpoint.x;
        if FrameMin.y > Figures[i].Minpoint.y then
          FrameMin.y := Figures[i].Minpoint.y;
      end;
  end;

function TFrame.CheckFrameAnchors (Pt3: MegaPoint): TAnchorMoving;
  var
    P3: TPoint;
    Points: array [1..4] of TPoint;
    i: integer;
  begin
    Points[1] := WorldToScreen (PointW (FrameMin.X-AnchorsSize/scale, FrameMin.y-AnchorsSize/scale));
    Points[2] := WorldToScreen (PointW (FrameMax.X+AnchorsSize/scale, FrameMin.y-AnchorsSize/scale));
    Points[3] := WorldToScreen (PointW (FrameMax.X+AnchorsSize/scale, FrameMax.y+AnchorsSize/scale));
    Points[4] := WorldToScreen (PointW (FrameMin.X-AnchorsSize/scale, FrameMax.y+AnchorsSize/scale));
    P3 := WorldToScreen (Pt3);
    for i := 1 to 4 do begin
      if (P3.x > Points[i].x - 5) and (P3.x < Points[i].x + 5) and
        (P3.y > Points[i].y - 5) and (P3.y < Points[i].y + 5) then begin
        Result.Selected := True;
        Result.ind := i;
        Result.Action := @FrameAnchorsMove;
        Exit;
      end;
    end;
    Result.Selected := False;
  end;

procedure TFrame.FrameAnchorsMove (Pt: MegaPoint; ind: integer);
  var
    i: integer;
  begin
    for i := 0 to High (Figures) do
      if Figures[i].Selected then begin
        Figures[i].MovingFrame (FrameMin, FrameMax, Pt, ind);
      end;

  end;

procedure TFrame.CreateFrame (ACanvas: TCanvas);
  var
    i: integer;
    Pt1,Pt2 : TPoint;
  begin
    FrameTime := (FrameTime + 1) mod 10;
    Pt1.x:=WorldToScreenX(FrameMin.X)-AnchorsSize;
    Pt1.y:=WorldToScreenY(FrameMin.Y)-AnchorsSize;
    Pt2.x:=WorldToScreenX(FrameMax.X)+AnchorsSize;
    Pt2.y:=WorldToScreenY(FrameMax.Y)+AnchorsSize;
    with ACanvas.Pen do begin
      Style := psSolid;
      Width := 1;
    end;
    i := Pt1.X + FrameTime;
    while i <= Pt2.X do begin
      ACanvas.Pen.Color := ACanvas.Pixels[Min (Pt2.x, i + 5), Pt1.y] xor clWhite;
      ACanvas.Line (i, Pt1.y, Min (Pt2.x, i + 5), Pt1.y);
      i += 10;
    end;
    i := Pt1.Y + FrameTime;
    while i <= Pt2.Y do begin
      ACanvas.Pen.Color := ACanvas.Pixels[Pt2.x, Min (Pt2.y, i + 5)] xor clWhite;
      ACanvas.Line (Pt2.x, i, Pt2.x, Min (Pt2.y, i + 5));
      i += 10;
    end;
    i := Pt2.X - FrameTime;
    while i >= Pt1.X do begin
      ACanvas.Pen.Color := ACanvas.Pixels[Max (Pt1.x, i - 5), Pt2.y] xor clWhite;
      ACanvas.Line (i, Pt2.y, Max (Pt1.x, i - 5), Pt2.y);
      i -= 10;
    end;
    i := Pt2.Y - FrameTime;
    while i >= Pt1.Y do begin
      ACanvas.Pen.Color := ACanvas.Pixels[Pt1.x, Max (Pt1.y, i - 5)] xor clWhite;
      ACanvas.Line (Pt1.x, i, Pt1.x, Max (Pt1.y, i - 5));
      i -= 10;
    end;
    with ACanvas do begin
      Pen.Color := clBlack;
      Pen.Width := 1;
      Pen.Style := psSolid;
      Brush.Style := bsSolid;
      Brush.Color := $ff4408;
      Rectangle (Pt1.X + AnchorsSize, Pt1.y + AnchorsSize, Pt1.X -
        AnchorsSize, Pt1.y - AnchorsSize);
      Rectangle (Pt1.X + AnchorsSize, Pt2.y + AnchorsSize, Pt1.X -
        AnchorsSize, Pt2.y - AnchorsSize);
      Rectangle (Pt2.X + AnchorsSize, Pt1.y + AnchorsSize, Pt2.X -
        AnchorsSize, Pt1.y - AnchorsSize);
      Rectangle (Pt2.X + AnchorsSize, Pt2.y + AnchorsSize, Pt2.X -
        AnchorsSize, Pt2.y - AnchorsSize);
    end;
  end;

initialization
  Frame:=TFrame.Create;
end.

