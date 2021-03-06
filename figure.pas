unit Figure;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, Transformation, Math, ExtCtrls;

type

  { TFigure }

  TFigure = class(TPersistent)
  private
    FPenColor: TColor;
    FMinPoint, FMaxPoint: MegaPoint;
    FSelected: boolean;
  public
    FWorldPoints: array of MegaPoint;
    property Minpoint: MegaPoint read FMinPoint;
    property Maxpoint: MegaPoint read FMaxPoint;
    procedure EditPoint (Pt: MegaPoint; Ind: integer); virtual; abstract;
    procedure CreateAncor (ACanvas: TCanvas); virtual;
    procedure MovingFrame (Pt1, Pt2, Pt3: MegaPoint; ind: integer); virtual;
    property Selected: boolean read FSelected write FSelected;
    procedure Draw (ACanvas: TCanvas); virtual;
    function Check (X, Y: double): TAnchorMoving; virtual;
  published
    property PenColor: TColor read FPenColor write FPenColor;
  end;

  { TSprey }

  TSprey = class(TFigure)
  private
    FFreq, FSize, FFirstElem: integer;
    FTimes: string;
  published
    property FirstElem: integer read FFirstElem write FFirstElem;
    property Size: integer read FSize write FSize;
    property Freq: integer read FFreq write FFreq;
    property Times: string read FTimes write FTimes;
    procedure Draw (ACanvas: TCanvas); override;
    procedure EditPoint (Pt: MegaPoint; Ind: integer); override;
    procedure CreateAncor (ACanvas: TCanvas); override;
    function Check (X, Y: double): TAnchorMoving; override;
  end;


  TGeometryFigure = class(TFigure)
  private
    FPenStyle, FPenWidth: integer;
  public
    procedure Draw (ACanvas: TCanvas); override;
    procedure EditPoint (Pt: MegaPoint; Ind: integer); override;
  published
    property PenStyle: integer read FPenStyle write FPenStyle;
    property PenWidth: integer read FPenWidth write FPenWidth;
  end;

  TFigureClass = class of TFigure;

  TFillFigure = class(TGeometryFigure)
  private
    FBrushColor: TColor;
    FBrushStyle: integer;
  public
    procedure Draw (ACanvas: TCanvas); override;
    procedure EditPoint (Pt: MegaPoint; Ind: integer); override;
  published
    property BrushColor: TColor read FBrushColor write FBrushColor;
    property BrushStyle: integer read FBrushStyle write FBrushStyle;
  end;


  TText = class(TFigure)
  private
    FTexts: string;
    FTextStyle: TFontStyles;
    FTextSize: integer;
  public
    RectPoints: array of TPoint;
    TTextSyles: TTextStyle;
    TextSeting: string;
    procedure Draw (ACanvas: TCanvas); override;
    procedure EditPoint (Pt: MegaPoint; Ind: integer); override;
  published
    property Texts: string read FTexts write FTexts;
    property TextStyle: TFontStyles read FTextStyle write FTextStyle;
    property TextSize: integer read FTextSize write FTextSize;
  end;

  TRoundRectangl = class(TFillFigure)
  private
    FRoundX, FRoundY: integer;
  public
    procedure Draw (ACanvas: TCanvas); override;
  published
    property RoundX: integer read FRoundX write FRoundX;
    property RoundY: integer read FRoundY write FRoundY;
  end;

  TEllipse = class(TFillFigure)
  public
    procedure Draw (ACanvas: TCanvas); override;
    procedure EditPoint (Pt: MegaPoint; Ind: integer); override;
  end;

  TPolygon = class(TFillFigure)
  public
    procedure Draw (ACanvas: TCanvas); override;
  end;

  TRegularPolygon = class(TFillFigure)
  private
    FAngles: integer;
  public
    procedure Draw (ACanvas: TCanvas); override;
    procedure EditPoint (Pt: MegaPoint; Ind: integer); override;
    procedure CreateAncor (ACanvas: TCanvas); override;
    function Check (X, Y: double): TAnchorMoving; override;
  published
    property Tops: integer read FAngles write FAngles;
  end;

  TRectangl = class(TFillFigure)
    procedure Draw (ACanvas: TCanvas); override;
    procedure EditPoint (Pt: MegaPoint; Ind: integer); override;
  end;

  TPencil = class(TGeometryFigure)
  public
    procedure Draw (ACanvas: TCanvas) override;
  end;

function CreateRightFigure (Point1, Point2: MegaPoint; Angels: integer): PointArray;

var
  ArrayFigureClass: array of TFigureClass;
  Figures: array of TFigure;
  Maxp,Minp : TPoint;

implementation

function CreateRightFigure (Point1, Point2: MegaPoint; Angels: integer): PointArray;
  var
    Center: TPoint;
    i: integer;
    x0, y0, r, angle: double;
  begin
    SetLength (Result, Angels);
    Center := WorldToScreen (Point1);
    x0 := WorldToScreen (Point2).X - Center.X;
    y0 := WorldToScreen (Point2).Y - Center.Y;
    angle := arctan2(y0, x0);
    r := sqrt (x0 * x0 + y0 * y0);
    if r = 0 then
      Exit;
    angle := arccos (x0 / r);
    if y0 < 0 then
      angle *= -1;
    for i := 0 to Angels - 1 do begin
      angle += 2 * pi / Angels;
      Result[i].X := Round (r * cos (angle) + Center.X);
      Result[i].Y := Round (r * sin (angle) + Center.Y);
      MaxMin (ScreenToWorld (Result[i]));
    end;
    Minp:=Result[0];
    Maxp:=Result[0];
   for i :=1  to High(Result) do begin
        if Maxp.x < Result[i].x then
          Maxp.x := Result[i].x;
        if Maxp.y < Result[i].y then
          Maxp.y := Result[i].y;
        if Minp.x > Result[i].x then
          Minp.x := Result[i].x;
        if Minp.y > Result[i].y then
          Minp.y := Result[i].y;
      end;
  end;

{ TSprey }

function MyRandom (Elem : integer) : Integer;
 var r,a,b : Integer;
begin
  r := 714025;
  a := 4096;
  b := 150889;
  Result := ((Elem * a) + b) mod r;
end;

procedure TSprey.Draw (ACanvas: TCanvas);
  var
    i, Digit, x, y, Angle, Time: integer;
    Counter: double;
    TimesStr: string;
  begin
    FMinpoint := PointW (FWorldPoints[0].X - Size, FWorldPoints[0].Y - Size);
    FMaxpoint := PointW (FWorldPoints[0].X + Size, FWorldPoints[0].Y + Size);
    for i := 1 to High (FWorldPoints) do begin
      if (FWorldPoints[i].x + FSize) > FMaxPoint.X then
        FMaxPoint.X := FWorldPoints[i].x + FSize;
      if (FWorldPoints[i].x - FSize) < FMinPoint.X then
        FMinPoint.X := FWorldPoints[i].x - FSize;
      if (FWorldPoints[i].y + FSize) > FMaxPoint.y then
        FMaxPoint.y := FWorldPoints[i].y + FSize;
      if (FWorldPoints[i].y - FSize) < FMinPoint.y then
        FMinPoint.y := FWorldPoints[i].y - FSize;
    end;
    Counter := 1;
    Digit := FirstElem;
    Angle := 1;
    TimesStr := Times;
    for i := 0 to High (FWorldPoints) do begin
      TimesStr := Copy (TimesStr, Pos (':', TimesStr) + 1, Length (TimesStr) - Pos (':', TimesStr));
      Time := StrToInt (Copy (TimesStr, 1, Pos (';', TimesStr) - 1));
      while Counter <= Time do begin
        Digit := MyRandom(Digit);
        Angle := MyRandom(Angle);
        x := round ((Digit mod Size) * cos (Angle)) + WorldToScreen (FWorldPoints[i]).X;
        y := round ((Digit mod Size) * sin (Angle)) + WorldToScreen (FWorldPoints[i]).Y;
        ACanvas.Pixels[x,y] := FPenColor;
        Counter += 10 / Freq;
      end;
    end;
  end;

procedure TSprey.EditPoint (Pt: MegaPoint; Ind: integer);
  begin

  end;

procedure TSprey.CreateAncor (ACanvas: TCanvas);
  begin
    inherited CreateAncor (ACanvas);
  end;

function TSprey.Check (X, Y: double): TAnchorMoving;
  begin
    Result.Selected := False;
  end;

// Classes Figures
procedure TFigure.Draw (ACanvas: TCanvas);
  var
    i: integer;
  begin
    FMinpoint := FWorldPoints[0];
    FMaxpoint := FWorldPoints[0];
    for i := 1 to High (FWorldPoints) do begin
      if (FWorldPoints[i].x) > FMaxPoint.X then
        FMaxPoint.X := FWorldPoints[i].x;
      if (FWorldPoints[i].x) < FMinPoint.X then
        FMinPoint.X := FWorldPoints[i].x;
      if (FWorldPoints[i].y) > FMaxPoint.y then
        FMaxPoint.y := FWorldPoints[i].y;
      if (FWorldPoints[i].y) < FMinPoint.y then
        FMinPoint.y := FWorldPoints[i].y;
    end;
  end;

function TFigure.Check (X, Y: double): TAnchorMoving;
  var
    i: integer;
  begin
    for i := 0 to High (FWorldPoints) do begin
      Result.Selected :=
        (Abs(WorldToScreenX (FWorldPoints[i].X) - WorldToScreenX (X)) < AnchorsSize) and
        (Abs(WorldToScreenY (FWorldPoints[i].Y) - WorldToScreenY (Y)) < AnchorsSize);
      if Result.Selected then begin
        Result.Action := @EditPoint;
        Result.ind := i;
        Break;
      end;
    end;
  end;

procedure TFigure.CreateAncor (ACanvas: TCanvas);
  var
    i: integer;
  begin
    for i := 0 to High (FWorldPoints) do begin
      ACanvas.Brush.Style := bsClear;
      ACanvas.Pen.Style := psSolid;
      ACanvas.Pen.Color := $ff4400;
      ACanvas.Pen.Width := 1;
      ACanvas.Rectangle (
        WorldToScreenX (FWorldPoints[i].X) - AnchorsSize,
        WorldToScreenY (FWorldPoints[i].Y) - AnchorsSize,
        WorldToScreenX (FWorldPoints[i].X) + AnchorsSize,
        WorldToScreenY (FWorldPoints[i].Y) + AnchorsSize);
    end;
  end;

procedure TFigure.MovingFrame (Pt1, Pt2, Pt3: MegaPoint; ind: integer);
  var
    cofx, cofy: double;
    i,inset: integer;
  begin
    inset:=Round(1/scale);
    case ind of
      1:
      begin
        if ((Pt2.X - Pt3.X) <= inset) or ((Pt2.y - Pt3.y) <= inset) or
           ((Pt2.X - Pt1.X)=0) or ((Pt2.y - Pt1.y)=0)   then
          Exit;
        cofx := (Pt2.X - Pt3.X) / (Pt2.X - Pt1.X);
        cofy := (Pt2.y - Pt3.y) / (Pt2.y - Pt1.y);
        for i := 0 to High (FWorldPoints) do begin
          FWorldPoints[i].x := Pt2.X - (Pt2.X - FWorldPoints[i].x) * cofx;
          FWorldPoints[i].y := Pt2.y - (Pt2.y - FWorldPoints[i].y) * cofy;
        end;
      end;


      2:
      begin
        if ((Pt3.X - Pt1.X) <= inset) or (Pt2.y - Pt3.y <= inset) or
           ((Pt2.X - Pt1.X)=0) or ((Pt2.y - Pt1.y)=0) then
          Exit;
        cofx := (Pt3.X - Pt1.X) / (Pt2.X - Pt1.X);
        cofy := (Pt2.y - Pt3.y) / (Pt2.y - Pt1.y);
        for i := 0 to High (FWorldPoints) do begin
          FWorldPoints[i].x := Pt1.X + (FWorldPoints[i].x - Pt1.X) * cofx;
          FWorldPoints[i].y := Pt2.y - (Pt2.y - FWorldPoints[i].y) * cofy;
        end;
      end;


      3:
      begin
        if (Pt3.X - Pt1.X <= inset) or (Pt3.Y - Pt1.Y <= inset) or
           ((Pt2.X - Pt1.X)=0) or ((Pt2.y - Pt1.y)=0) then
          Exit;
        cofy := (Pt3.Y - Pt1.Y) / (Pt2.Y - Pt1.Y);
        cofx := (Pt3.X - Pt1.X) / (Pt2.X - Pt1.X);
        for i := 0 to High (FWorldPoints) do begin
          FWorldPoints[i].x := Pt1.X + (FWorldPoints[i].x - Pt1.X) * cofx;
          FWorldPoints[i].y := Pt1.y + (FWorldPoints[i].y - Pt1.y) * cofy;
        end;
      end;



      4:
      begin
        if (Pt2.X - Pt3.X <= inset) or (Pt3.Y - Pt1.Y <= inset) or
           ((Pt2.X - Pt1.X)=0) or ((Pt2.y - Pt1.y)=0) then
          Exit;
        cofx := (Pt2.X - Pt3.X) / (Pt2.X - Pt1.X);
        cofy := (Pt3.Y - Pt1.Y) / (Pt2.Y - Pt1.Y);
        for i := 0 to High (FWorldPoints) do begin
          FWorldPoints[i].x := Pt2.X - (Pt2.X - FWorldPoints[i].x) * cofx;
          FWorldPoints[i].y := Pt1.y + (FWorldPoints[i].y - Pt1.y) * cofy;
        end;
      end;
    end;
  end;

//ClassGeometryFigure

procedure TGeometryFigure.Draw (ACanvas: TCanvas);
  begin
    inherited;
    ACanvas.Pen.Color := PenColor;
    ACanvas.Pen.Width := PenWidth;
    ACanvas.Pen.Style := TPenStyle (PenStyle);
  end;

procedure TGeometryFigure.EditPoint (Pt: MegaPoint; Ind: integer);
  begin
    FWorldPoints[Ind] := Pt;
  end;

//Class FillFigure
procedure TFillFigure.Draw (ACanvas: TCanvas);
  begin
    inherited;
    ACanvas.Brush.Color := BrushColor;
    ACanvas.Brush.Style := TBrushStyle (BrushStyle);
  end;


procedure TFillFigure.EditPoint (Pt: MegaPoint; Ind: integer);
  begin
    FWorldPoints[Ind] := Pt;
  end;

//Class Pensil
procedure TPencil.Draw (ACanvas: TCanvas);
  begin
    inherited;
    //DestroyAncor ();
    ACanvas.PolyLine (WorldToScreen (FWorldPoints));
    if Selected then
      CreateAncor (ACanvas);
  end;


// Class Text
procedure TText.Draw (ACanvas: TCanvas);
  var
    FScreenPoints: PointArray;
  begin
    inherited;
    SetLength (FScreenPoints, Length (FWorldPoints));
    FScreenPoints := WorldToScreen (FWorldPoints);
    ACanvas.Font.Size := round (TextSize * scale);
    ACanvas.Font.Color := FPenColor;
    ACanvas.Font.Style := TextStyle;
    TTextSyles.Wordbreak := True;
    TTextSyles.Clipping := True;
    TTextSyles.SingleLine := False;
    ACanvas.Brush.Style := bsClear;
    ACanvas.Pen.Style := psDash;
    ACanvas.Pen.Width := 1;
    ACanvas.Pen.Color := clBlack;
    ACanvas.Font.Name := TextSeting;
    if not DownPress then
      SetLength (RectPoints, 0);
    if Length (RectPoints) <> 0 then
      ACanvas.Rectangle (
        RectPoints[0].X, RectPoints[0].Y,
        RectPoints[1].X, RectPoints[1].Y);
    ACanvas.TextRect (Rect (
      min (FScreenPoints[0].x, FScreenPoints[1].x),
      min (FScreenPoints[0].y, FScreenPoints[1].y),
      max (FScreenPoints[0].x, FScreenPoints[1].x),
      max (FScreenPoints[0].y, FScreenPoints[1].y)),
      min (FScreenPoints[0].x, FScreenPoints[1].x),
      min (FScreenPoints[0].y, FScreenPoints[1].y), InNormText (Texts), TTextSyles);


    if Selected then begin
      with ACanvas do begin
        Pen.Color := clBlack;
        Pen.Style := psDash;
        Pen.Width := 1;
        Brush.Style := bsClear;
      end;
      CreateAncor (ACanvas);
    end;
  end;

procedure TText.EditPoint (Pt: MegaPoint; Ind: integer);
  begin
    FWorldPoints[Ind] := Pt;
  end;


//ClassEllips
procedure TEllipse.Draw (ACanvas: TCanvas);
  begin
    inherited;
    ACanvas.Ellipse (
      WorldToScreen (FWorldPoints[0]).x, WorldToScreen (FWorldPoints[0]).y,
      WorldToScreen (FWorldPoints[1]).x, WorldToScreen (FWorldPoints[1]).y);
    if Selected then
      CreateAncor (ACanvas);
  end;


procedure TEllipse.EditPoint (Pt: MegaPoint; Ind: integer);
  begin
    FWorldPoints[Ind] := Pt;
  end;

//RoundRectangl
procedure TRoundRectangl.Draw (ACanvas: TCanvas);
  begin
    inherited;
    ACanvas.RoundRect (
      WorldToScreen (FWorldPoints[0]).x, WorldToScreen (FWorldPoints[0]).y,
      WorldToScreen (FWorldPoints[1]).x, WorldToScreen (FWorldPoints[1]).y,
      RoundX, RoundY);
    if Selected then
      CreateAncor (ACanvas);
  end;

// TRectangl
procedure TRectangl.Draw (ACanvas: TCanvas);
  begin
    inherited;
    ACanvas.Polygon (WorldToScreen (FWorldPoints));
    if Selected then
      CreateAncor (ACanvas);
  end;

procedure TRectangl.EditPoint (Pt: MegaPoint; Ind: integer);
  begin
    case ind of
      0:
      begin
        FWorldPoints[0] := Pt;
        FWorldPoints[1].Y := Pt.Y;
        FWorldPoints[3].X := Pt.X;
      end;
      1:
      begin
        FWorldPoints[1] := Pt;
        FWorldPoints[0].Y := Pt.Y;
        FWorldPoints[2].X := Pt.X;
      end;
      2:
      begin
        FWorldPoints[2] := Pt;
        FWorldPoints[3].Y := Pt.Y;
        FWorldPoints[1].X := Pt.X;
      end;
      3:
      begin
        FWorldPoints[3] := Pt;
        FWorldPoints[2].Y := Pt.Y;
        FWorldPoints[0].X := Pt.X;
      end;
    end;
  end;

//TRegularPolygon
procedure TRegularPolygon.Draw (Acanvas: TCanvas);
  var
    Points: PointArray;
    x0,y0,r :  Double;
    //WPoints: MegaArray;
  begin
    inherited;
    SetLength (Points, Tops);
    Points := CreateRightFigure (FWorldPoints[0], FWorldPoints[1], Tops);
    FMinPoint:=ScreenToWorld(minp);
    FMaxPoint:=ScreenToWorld(maxp);
    ACanvas.Polygon (Points);
    if Selected then
      CreateAncor (Acanvas);
  end;

function TRegularPolygon.Check (X, Y: double): TAnchorMoving;
  var
    i: integer;
    pt: TPoint;
  begin
    pt := WorldToScreen (PointW (X, Y));
    for i := 0 to 1 do begin
      if (pt.x < WorldToScreenX (FWorldPoints[i].X) + AnchorsSize) and
        (pt.x > WorldToScreenX (FWorldPoints[i].X) - AnchorsSize) and
        (pt.y < WorldToScreenY (FWorldPoints[i].Y) + AnchorsSize) and
        (pt.y > WorldToScreenY (FWorldPoints[i].Y) - AnchorsSize) then begin
        Result.Selected := True;
        Result.Action := @EditPoint;
        Result.ind := i;
        Break;
      end
      else
        Result.Selected := False;
    end;
  end;

procedure TRegularPolygon.EditPoint (Pt: MegaPoint; Ind: integer);
  begin
    FWorldPoints[Ind] := Pt;
  end;

procedure TRegularPolygon.CreateAncor (ACanvas: TCanvas);
  var
    i: integer;
  begin
    for i := 0 to 1 do begin
      ACanvas.Brush.Style := bsClear;
      ACanvas.Pen.Style := psSolid;
      ACanvas.Pen.Color := $ff4400;
      ACanvas.Pen.Width := 1;
      ACanvas.Rectangle (
        WorldToScreenX (FWorldPoints[i].X) - AnchorsSize,
        WorldToScreenY (FWorldPoints[i].Y) - AnchorsSize,
        WorldToScreenX (FWorldPoints[i].X) + AnchorsSize,
        WorldToScreenY (FWorldPoints[i].Y) + AnchorsSize);
    end;
  end;

//ClassPoligone
procedure TPolygon.Draw (ACanvas: TCanvas);
  begin
    inherited;
    ACanvas.Polygon (WorldToScreen (FWorldPoints));
    if Selected then
      CreateAncor (ACanvas);
  end;

procedure RegistrateFigure (AClass: TFigureClass);
  begin
    SetLength (ArrayFigureClass, Length (ArrayFigureClass) + 1);
    ArrayFigureClass[High (ArrayFigureClass)] := AClass;
    RegisterClass (AClass);
  end;

initialization
  RegistrateFigure (TSprey);
  RegistrateFigure (TRegularPolygon);
  RegistrateFigure (TRectangl);
  RegistrateFigure (TRoundRectangl);
  RegistrateFigure (TPencil);
  RegistrateFigure (TEllipse);
  RegistrateFigure (TPolygon);
  RegistrateFigure (TText);

end.
