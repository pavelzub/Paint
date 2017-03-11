unit Tools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Graphics, Controls, Figure,
  Transformation, Math, ExtCtrls, Spin, StdCtrls, Checking, typinfo,FrameTimer,History,Dialogs;

type
  StringArray = array of array [1..2] of string;
  Redraw = procedure of object;



  { TFigureTools }

  TFigureTools = class(TPersistent)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); virtual; abstract;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
      virtual; abstract;
    function GetFigure (): TFigure; virtual; abstract;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); virtual; abstract;
    procedure SetProperty (); virtual;
  class var
    FPenColor:TColor;
  end;

  { TTransformationTools }

  TTransformationTools = class(TFigureTools)
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MoveAll (Pt: MegaPoint; ind: integer);
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure SetProperty; override;
  private
    Start: MegaPoint;
    MovingPoint: TAnchorMoving;
  end;

  TGeometryFigureTools = class(TFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure SetProperty (); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure SpinEditPenSizeClick (Sender: TObject);
    procedure ComboBoxPenStylClick (Sender: TObject);
  class var
    FPenStyle, FPenWidth : Integer;
  end;

  TTextTools = class(TFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    function GetFigure (): TFigure; override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure SetProperty (); override;
    procedure TextStyle (Sender: TObject);
    procedure TextSizeChange (Sender: TObject);
    procedure MemoClick (Sender: TObject);
    procedure TextCursiv (Sender: TObject);
    procedure TextFeet (Sender: TObject);
    procedure TextLine (Sender: TObject);
    procedure TextXLine (Sender: TObject);
  class var
    FTextSize : Integer;
    FText, FTextStyle: string;
    FSettings: TFontStyles;
  end;

  THandTools = class(TFigureTools)
  private
    Point: MegaPoint;
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure SetProperty (); override;
  end;

  TFigureToolsClass = class of TFigureTools;

  TFillFigureTools = class(TGeometryFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure SetProperty (); override;
    procedure ComboBoxBrushStylClick (Sender: TObject);
  class var
    FBrushColor: TColor;
    FBrushStyle: Integer;
  end;

  TEllipseTools = class(TFillFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    function GetFigure (): TFigure; override;
  end;

  TRectanglTools = class(TFillFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    function GetFigure (): TFigure; override;
  end;

  TRoundRectanglTools = class(TFillFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    function GetFigure (): TFigure; override;
    procedure SetProperty (); override;
    procedure SpinEditHorizontalRound (Sender: TObject);
    procedure SpinEditVerticalRound (Sender: TObject);
  class var
    FRound: TPoint;
  end;

  TRegularPolygonTools = class(TFillFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    function GetFigure (): TFigure; override;
    procedure SetProperty (); override;
    procedure SpinEditNumberOfAnglesClick (Sender: TObject);
  class var
    NubmerOfAngle : Integer;
  end;

  TPolygonTools = class(TFillFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    function GetFigure (): TFigure; override;
  end;

  TPolylineTools = class(TGeometryFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    function GetFigure (): TFigure; override;
  end;

  TPencilTools = class(TGeometryFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    function GetFigure (): TFigure; override;
  end;

  TLineTools = class(TGeometryFigureTools)
  public
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    function GetFigure (): TFigure; override;
  end;

  { TSpreyTools }

  TSpreyTools = class(TFigureTools)
  private
    Times: integer;
  public
    procedure Ontime (Sender: TObject);
    procedure MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double); override;
    procedure MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: double); override;
    procedure SpinEditSizeClick (Sender: TObject);
    procedure SetProperty (); override;
    procedure SpinEditFreqClick (Sender: TObject);
    function GetFigure (): TFigure; override;
  class var
    FFreq : Integer;
    FSize: integer;
  end;

  { TSaveFlag }

  TSaveFlag = class
    private
      NeedSave : Boolean;
    public
      FileName : ^String;
      procedure SetSaveFlag (AFlag : Boolean);
      property SaveNeed : Boolean read NeedSave write SetSaveFlag ;
  end;

  procedure DestroyControls;
  procedure GetGenericProps ;

var
  ArrayFigureToolsClass: array of TFigureToolsClass;
  ShiftX, ShiftY: double;
  LastTool, CurrentTool: TFigureTools;
  NeedCreat, EndingTransformaton: boolean;
  WTop, WLeft, IndexOfTranformer: integer;
  Panel: ^TPanel;
  Redrawing: Redraw;
  Timer: TTimer;
  SaveFlag : TSaveFlag;

  //FPanel : TPanel;
  ArrayOfProp: array of TControl;

implementation

procedure DestroyControls;
var i : integer;
begin
  if ArrayOfProp <> nil then
      for i := 0 to High (ArrayOfProp) do
        if ArrayOfProp[i] <> nil then
          ArrayOfProp[i].Free;
  ArrayOfProp:=nil;
end;

procedure SetProps (s: string; p: variant);
  var
    i: integer;
  begin
    for i := 0 to High (Figures) do begin
      if Figures[i].Selected and IsPublishedProp (Figures[i], s) then
        SetPropValue (Figures[i], s, p);
    end;
    Change.SaveNeed:=True;
  end;

{ TFigureTools }

procedure TFigureTools.SetProperty;
begin
  Wtop := 2;
  WLeft := 2;
end;

{ TSaveFlag }

procedure TSaveFlag.SetSaveFlag(AFlag: Boolean);
begin
  if not NeedSave and AFlag then FileName^:=FileName^+'*' ;
  if NeedSave and not AFlag then FileName^:=Copy(FileName^,1,Length(FileName^)-1);
  NeedSave:=AFlag;
end;


// TFigureTools

procedure TGeometryFigureTools.SpinEditPenSizeClick (Sender: TObject);
  begin
    FPenWidth := (Sender as TSpinEdit).Value;
    SetProps ('PenWidth', FPenWidth);
    Redrawing;
  end;

procedure TGeometryFigureTools.ComboBoxPenStylClick (Sender: TObject);
  begin
    case (Sender as TComboBox).Text of
      '— — — — — ': FPenStyle := integer (psDash);
      '— - — - — ': FPenStyle := integer (psDashDot);
      '——————————': FPenStyle := integer (psSolid);
      '— - - — - ': FPenStyle := integer (psDashDotDot);
      '          ': FPenStyle := integer (psClear);
    end;
    SetProps ('PenStyle', FPenStyle);
    Redrawing;
  end;

procedure TGeometryFigureTools.MouseMove (Sender: TObject; Shift: TShiftState;
  X, Y: double);
  begin
    MaxMin (PointW (X, Y));
  end;

procedure TGeometryFigureTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  var
    i: integer;
  begin
    SaveFlag.SaveNeed := True;
    DownPress := True;
    SetLength (Figures, Length (Figures) + 1);
    Figures[High (Figures)] := GetFigure ();
    (Figures[High (Figures)] as TGeometryFigure).PenColor := FPenColor;
    (Figures[High (Figures)] as TGeometryFigure).PenStyle := FPenStyle;
    (Figures[High (Figures)] as TGeometryFigure).PenWidth := FPenWidth;
    SetLength (Figures[High (Figures)].FWorldPoints, 2);
    Figures[High (Figures)].FWorldPoints[0] := PointW (X, Y);
    Figures[High (Figures)].FWorldPoints[1] := PointW (X, Y);
    for i := 0 to High (Figures) do
      Figures[i].Selected := False;
  end;


procedure TGeometryFigureTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  var
    i: integer;
  begin
    Change.SaveNeed := True;
    DownPress := False;
    IndexOfTranformer := High (Figures);
    for i := 0 to High (Figures) do
      Figures[i].Selected := False;
    Figures[High (Figures)].Selected := True;
    CurrentTool := LastTool;
    LastTool := TTransformationTools.Create;
    EndingTransformaton := True;
  end;

procedure TGeometryFigureTools.SetProperty ();
  var
    a: array [0..4] of string;
    i: integer;
  begin
    inherited;
    SetLength (ArrayOfProp, 2);
    ArrayOfProp[0] := TSpinEdit.Create (Panel^);
    with (ArrayOfProp[0] as TSpinEdit) do begin
      Parent := Panel^;
      Name := 'SpinEditPenSize';
      top := WTop;
      WTop += 30;
      left := WLeft;
      Width := 55;
      Height := 23;
      MinValue := 1;
      ShowHint := True;
      Hint := 'Размер контура';
      Value := 1;
      for i := 0 to High (Figures) do
        if Figures[i].Selected then
          Value := (Figures[i] as TGeometryFigure).PenWidth;
      OnChange := @SpinEditPenSizeClick;
    end;
    FPenWidth := 1;
    ArrayOfProp[1] := TComboBox.Create (Panel^);
    with (ArrayOfProp[1] as TComboBox) do begin
      Parent := Panel^;
      Name := 'ComboBoxPenStyle';
      top := WTop;
      WTop += 30;
      left := WLeft;
      Width := 62;
      Height := 23;
      ShowHint := True;
      ReadOnly := True;
      Hint := 'Стиль пера';
      a[1] := '— — — — — ';
      a[3] := '— - — - — ';
      a[0] := '——————————';
      a[4] := '— - - — - ';
      a[2] := '          ';
      Items.AddStrings (a);
      Text := a[0];
      FPenStyle := integer (psSolid);
      for i := 0 to High (Figures) do
        if Figures[i].Selected then
          Text := a[(Figures[i] as TGeometryFigure).PenStyle];
      OnChange := @ComboBoxPenStylClick;
    end;

  end;

//FillFigureTools
procedure TFillFigureTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
    (Figures[High (Figures)] as TFillFigure).BrushColor := FBrushColor;
    (Figures[High (Figures)] as TFillFigure).BrushStyle := FBrushStyle;
    SetLength (Figures[High (Figures)].FWorldPoints, 2);
    Figures[High (Figures)].FWorldPoints[0] := PointW (X, Y);
    Figures[High (Figures)].FWorldPoints[1] := PointW (X, Y);
  end;

procedure TFillFigureTools.SetProperty ();
  var
    i: integer;
    a: array [1..8] of string;
  begin
    inherited;
    SetLength (ArrayOfProp, Length (ArrayOfProp) + 1);
    ArrayOfProp[High (ArrayOfProp)] := TComboBox.Create (Panel^);
    with (ArrayOfProp[High (ArrayOfProp)] as TComboBox) do begin
      Parent := Panel^;
      Name := 'ComboBoxBrushStyle';
      top := WTop;
      WTop += 30;
      left := WLeft;
      Width := 62;
      Height := 23;
      OnChange := @ComboBoxBrushStylClick;
      ShowHint := True;
      ReadOnly := True;
      Hint := 'Стиль Заливки';
      a[1] := '██████████';
      a[2] := '          ';
      a[3] := '══════════';
      a[4] := '││││││││││';
      a[5] := '//////////';
      a[6] := '\\\\\\\\\\';
      a[7] := '‡‡‡‡‡‡‡‡‡‡';
      a[8] := '˟˟˟˟˟˟˟˟˟˟';
      Items.AddStrings (a);
      Text := a[1];
      FBrushStyle := integer (bsSolid);
      for i := 0 to High (Figures) do
        if Figures[i].Selected then
          FBrushStyle := (Figures[i] as TFillFigure).BrushStyle;
    end;
  end;

procedure TFillFigureTools.ComboBoxBrushStylClick (Sender: TObject);
  var
    i: integer;
  begin
    case (Sender as TComboBox).Text of
      '██████████': FBrushStyle := integer (bsSolid);
      '          ': FBrushStyle := integer (bsClear);
      '══════════': FBrushStyle := integer (bsHorizontal);
      '││││││││││': FBrushStyle := integer (bsVertical);
      '//////////': FBrushStyle := integer (bsBDiagonal);
      '\\\\\\\\\\': FBrushStyle := integer (bsFDiagonal);
      '‡‡‡‡‡‡‡‡‡‡': FBrushStyle := integer (bsCross);
      '˟˟˟˟˟˟˟˟˟˟': FBrushStyle := integer (bsDiagCross);
    end;
    SetProps ('BrushStyle', FBrushStyle);
    Redrawing;
  end;

// TPencilTools
procedure TPencilTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;

  end;

procedure TPencilTools.MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
  begin
    inherited;
    if DownPress then begin
      SetLength (Figures[High (Figures)].FWorldPoints,
        Length (Figures[High (Figures)].FWorldPoints) + 1);
      Figures[High (Figures)].FWorldPoints[High (
        Figures[High (Figures)].FWorldPoints)] :=
        PointW (X, Y);
    end;
  end;

function TPencilTools.GetFigure (): TFigure;
  begin
    Result := TPencil.Create;
  end;


procedure TPencilTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
  end;
// TLineTools
procedure TLineTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
  end;

procedure TLineTools.MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
  begin
    inherited;
    if DownPress then begin
      if ssShift in Shift then begin
        if abs (ShiftX - X) > abs (ShiftY - Y) then
          Y := ShiftY;
        if abs (ShiftX - X) < abs (ShiftY - Y) then
          X := ShiftX;
      end;
      Figures[High (Figures)].FWorldPoints[High (
        Figures[High (Figures)].FWorldPoints)] :=
        PointW (X, Y);
    end;
  end;

function TLineTools.GetFigure (): TFigure;
  begin
    Result := TPencil.Create;
  end;

procedure TLineTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
  end;
// TEllipseTools
procedure TEllipseTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
    SetLength (Figures[High (Figures)].FWorldPoints, 2);
  end;

procedure TEllipseTools.MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
  begin
    inherited;
    if DownPress then begin
      if ssShift in Shift then begin
        if (abs (ShiftX - X) > abs (ShiftY - Y)) and (ShiftX - X < 0) then
          X := ShiftX + abs (ShiftY - Y);
        if (abs (ShiftX - X) > abs (ShiftY - Y)) and (ShiftX - X > 0) then
          X := ShiftX - abs (ShiftY - Y);
        if (abs (ShiftX - X) < abs (ShiftY - Y)) and (ShiftY - Y < 0) then
          Y := ShiftY + abs (ShiftX - X);
        if (abs (ShiftX - X) < abs (ShiftY - Y)) and (ShiftY - Y > 0) then
          Y := ShiftY - abs (ShiftX - X);
      end;
      Figures[High (Figures)].FWorldPoints[1] :=
        PointW (X, Y);
    end;
  end;

function TEllipseTools.GetFigure (): TFigure;
  begin
    Result := TEllipse.Create;
  end;

procedure TEllipseTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    SetLength (Figures[High (Figures)].FWorldPoints, 2);
    inherited;
  end;
// TPolylineTools
procedure TPolylineTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    if not NeedCreat then begin
      inherited;
      NeedCreat := True;
    end;
    if Button = mbLeft then begin
      DownPress := True;
      SetLength (Figures[High (Figures)].FWorldPoints,
        Length (Figures[High (Figures)].FWorldPoints) + 1);
      Figures[High (Figures)].FWorldPoints[High (
        Figures[High (Figures)].FWorldPoints)] :=
        PointW (X, Y);
    end
    else begin
      Figures[High (Figures)].Selected := True;
      CurrentTool := LastTool;
      LastTool := TTransformationTools.Create;
      EndingTransformaton := True;
      NeedCreat := False;
      Change.SaveNeed := True;
      DownPress := False;
      IndexOfTranformer := High (Figures);
    end;
  end;

procedure TPolylineTools.MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
  begin
    inherited;
    if DownPress then begin
      if ssShift in Shift then begin
        if abs (ShiftX - X) > abs (ShiftY - Y) then
          Y := ShiftY;
        if abs (ShiftX - X) < abs (ShiftY - Y) then
          X := ShiftX;
      end;
      Figures[High (Figures)].FWorldPoints[High (
        Figures[High (Figures)].FWorldPoints)] :=
        PointW (X, Y);
    end;
  end;

function TPolylineTools.GetFigure (): TFigure;
  begin
    Result := TPencil.Create;
  end;

procedure TPolylineTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
  end;
// TRectanglTools
procedure TRectanglTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
    SetLength (Figures[High (Figures)].FWorldPoints, 4);
    Figures[High (Figures)].FWorldPoints[2] := PointW (X, Y);
    Figures[High (Figures)].FWorldPoints[3] := PointW (X, Y);
  end;

procedure TRectanglTools.MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
  begin
    if DownPress then begin
      inherited;
      if ssShift in Shift then begin
        if (abs (ShiftX - X) > abs (ShiftY - Y)) and (ShiftX - X < 0) then
          X := ShiftX + abs (ShiftY - Y);
        if (abs (ShiftX - X) > abs (ShiftY - Y)) and (ShiftX - X > 0) then
          X := ShiftX - abs (ShiftY - Y);
        if (abs (ShiftX - X) < abs (ShiftY - Y)) and (ShiftY - Y < 0) then
          Y := ShiftY + abs (ShiftX - X);
        if (abs (ShiftX - X) < abs (ShiftY - Y)) and (ShiftY - Y > 0) then
          Y := ShiftY - abs (ShiftX - X);
      end;
      Figures[High (Figures)].FWorldPoints[1].X := PointW (X, Y).X;
      Figures[High (Figures)].FWorldPoints[3].Y := PointW (X, Y).Y;
      Figures[High (Figures)].FWorldPoints[2] := PointW (X, Y);
    end;
  end;

function TRectanglTools.GetFigure (): TFigure;
  begin
    Result := TRectangl.Create;
  end;

procedure TRectanglTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    SetLength (Figures[High (Figures)].FWorldPoints, 4);
    inherited;
  end;
//TRoundRectanglTools
procedure TRoundRectanglTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
    (Figures[High (Figures)] as TRoundRectangl).RoundX := FRound.X;
    (Figures[High (Figures)] as TRoundRectangl).RoundY := FRound.Y;
  end;

procedure TRoundRectanglTools.MouseMove (Sender: TObject; Shift: TShiftState;
  X, Y: double);
  begin
    if DownPress then begin
      inherited;
      if ssShift in Shift then begin
        if (abs (ShiftX - X) > abs (ShiftY - Y)) and (ShiftX - X < 0) then
          X := ShiftX + abs (ShiftY - Y);
        if (abs (ShiftX - X) > abs (ShiftY - Y)) and (ShiftX - X > 0) then
          X := ShiftX - abs (ShiftY - Y);
        if (abs (ShiftX - X) < abs (ShiftY - Y)) and (ShiftY - Y < 0) then
          Y := ShiftY + abs (ShiftX - X);
        if (abs (ShiftX - X) < abs (ShiftY - Y)) and (ShiftY - Y > 0) then
          Y := ShiftY - abs (ShiftX - X);
      end;
      Figures[High (Figures)].FWorldPoints[1] := PointW (X, Y);
    end;
  end;

function TRoundRectanglTools.GetFigure (): TFigure;
  begin
    Result := TRoundRectangl.Create;
  end;

procedure TRoundRectanglTools.SetProperty ();
  var
    i: integer;
  begin
    inherited;
    SetLength (ArrayOfProp, Length (ArrayOfProp) + 2);
    ArrayOfProp[High (ArrayOfProp) - 1] := TSpinEdit.Create (Panel^);
    with (ArrayOfProp[High (ArrayOfProp) - 1] as TSpinEdit) do begin
      Parent := Panel^;
      Name := 'SpinEditHorizontalRound';
      top := WTop;
      WTop += 30;
      left := WLeft;
      Width := 55;
      Height := 23;
      MaxValue := 1000;
      Value := 100;
      FRound.X := 100;
      Hint := 'Радиус горизонтального скругления';
      ShowHint := True;
      for i := 0 to High (Figures) do
        if Figures[i].Selected then
          Value := (Figures[i] as TRoundRectangl).RoundX;
      OnChange := @SpinEditHorizontalRound;
    end;
    ArrayOfProp[High (ArrayOfProp)] := TSpinEdit.Create (Panel^);
    with (ArrayOfProp[High (ArrayOfProp)] as TSpinEdit) do begin
      Parent := Panel^;
      Name := 'SpinEditVerticalRound';
      top := WTop;
      WTop += 30;
      left := WLeft;
      Width := 55;
      Height := 23;
      Value := 100;
      FRound.Y := 100;
      MaxValue := 1000;
      Hint := 'Радиус Вертикального скругления';
      ShowHint := True;
      for i := 0 to High (Figures) do
        if Figures[i].Selected then
          Value := (Figures[i] as TRoundRectangl).RoundY;
      OnChange := @SpinEditVerticalRound;
    end;
  end;


procedure TRoundRectanglTools.SpinEditHorizontalRound (Sender: TObject);
  var
    i: integer;
  begin
    FRound.X := (Sender as TSpinEdit).Value;
    SetProps ('RoundX', FRound.X);
    Redrawing;
  end;

procedure TRoundRectanglTools.SpinEditVerticalRound (Sender: TObject);
  var
    i: integer;
  begin
    FRound.Y := (Sender as TSpinEdit).Value;
    SetProps ('RoundY', FRound.Y);
    Redrawing;
  end;

procedure TRoundRectanglTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
  end;

// TRigthFigureTools
procedure TRegularPolygonTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
    (Figures[High (Figures)] as TRegularPolygon).Tops := NubmerOfAngle;
    SetLength (Figures[High (Figures)].FWorldPoints, 2);
    Figures[High (Figures)].FWorldPoints[0] := PointW (X, Y);
  end;

procedure TRegularPolygonTools.MouseMove (Sender: TObject; Shift: TShiftState;
  X, Y: double);
  begin
    if DownPress then begin
      inherited;
      Figures[High (Figures)].FWorldPoints[1] := PointW (X, Y);
    end;
  end;

function TRegularPolygonTools.GetFigure (): TFigure;
  begin
    Result := TRegularPolygon.Create;
  end;

procedure TRegularPolygonTools.SetProperty ();
  var
    i: integer;
  begin
    inherited;
    SetLength (ArrayOfProp, Length (ArrayOfProp) + 1);
    ArrayOfProp[High (ArrayOfProp)] := TSpinEdit.Create (Panel^);
    with (ArrayOfProp[High (ArrayOfProp)] as TSpinEdit) do begin
      Parent := Panel^;
      Name := 'SpinEditNumberofAngles';
      top := WTop;
      WTop += 30;
      left := WLeft;
      Width := 55;
      Height := 23;
      MinValue := 3;
      for i := 0 to High (Figures) do
        if Figures[i].Selected then
          NubmerOfAngle := (Figures[i] as TRegularPolygon).Tops;
      Value := NubmerOfAngle;
      OnChange := @SpinEditNumberOfAnglesClick;
      Hint := 'Количество Углов';
      ShowHint := True;
    end;
  end;

procedure TRegularPolygonTools.SpinEditNumberOfAnglesClick (Sender: TObject);
  var
    i: integer;
  begin
    NubmerOfAngle := (Sender as TSpinEdit).Value;
    SetProps ('Tops', NubmerOfAngle);
    Redrawing;
  end;

procedure TRegularPolygonTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    inherited;
  end;
// TPolygonTools
procedure TPolygonTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    if not NeedCreat then begin
      inherited;
      NeedCreat := True;
    end;
    if Button = mbLeft then begin
      DownPress := True;
      SetLength (Figures[High (Figures)].FWorldPoints,
        Length (Figures[High (Figures)].FWorldPoints) + 1);
      Figures[High (Figures)].FWorldPoints[High (
        Figures[High (Figures)].FWorldPoints)] :=
        PointW (X, Y);
    end
    else begin
      NeedCreat := False;
      DownPress := False;
      IndexOfTranformer := High (Figures);
      Figures[High (Figures)].Selected := True;
      CurrentTool := LastTool;
      LastTool := TTransformationTools.Create;
      EndingTransformaton := True;
      Change.SaveNeed := True;
    end;
  end;

procedure TPolygonTools.MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
  begin
    inherited;
    if DownPress then begin
      Figures[High (Figures)].FWorldPoints[High (
        Figures[High (Figures)].FWorldPoints)] :=
        PointW (X, Y);
    end;
  end;

function TPolygonTools.GetFigure (): TFigure;
  begin
    Result := TPolygon.Create;
  end;

procedure TPolygonTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
  end;
// THandTools
procedure THandTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    DownPress := True;
    Point := PointW (X, Y);
  end;

procedure THandTools.MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
  begin
    if DownPress then begin
      Offset.x -= round ((x - Point.x) * scale);
      Offset.y -= round ((y - Point.y) * scale);
    end;
  end;

procedure THandTools.SetProperty ();
  begin
    SetLength (ArrayOfProp, 0);
  end;

procedure THandTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  begin
    DownPress := False;
    //Figures[High (Figures)].Free;
    //SetLength (Figures, Length (Figures) - 1);
  end;
//TTextToosl
procedure TTextTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  var
    i: integer;
  begin
    SaveFlag.SaveNeed := True;
    Change.SaveNeed := True;
    DownPress := True;
    SetLength (Figures, Length (Figures) + 1);
    Figures[High (Figures)] := GetFigure ();
    SetLength (Figures[High (Figures)].FWorldPoints, 2);
    Figures[High (Figures)].FWorldPoints[0] := PointW (X, Y);
    Figures[High (Figures)].FWorldPoints[1] := PointW (X, Y);
    (Figures[High (Figures)] as TText).TextSeting := FTextStyle;
    (Figures[High (Figures)] as TText).Texts := FText;
    (Figures[High (Figures)] as TText).TextSize := FTextSize;
    (Figures[High (Figures)] as TText).TextStyle := FSettings;
    SetLength ((Figures[High (Figures)] as TText).RectPoints, 2);
    (Figures[High (Figures)] as TText).RectPoints[0] := WorldToScreen (PointW (X, Y));
    (Figures[High (Figures)] as TText).RectPoints[1] := WorldToScreen (PointW (X, Y));
    for i := 0 to High (Figures) do
      Figures[i].Selected := False;
  end;

procedure TTextTools.SetProperty ();
  var
    i: integer;
  begin
    inherited;
    SetLength (ArrayOfProp, 7);
    ArrayOfProp[0] := TEdit.Create (Panel^);
    with (ArrayOfProp[0] as TEdit) do begin
      Parent := Panel^;
      Name := 'Tmemo';
      top := 104;
      left := 2;
      Width := 63;
      Height := 23;
      Text := 'Введите текст';
      for i := 0 to High (Figures) do
        if Figures[i].Selected then
          Text := InNormText ((Figures[i] as TText).Texts);
      OnChange := @MemoClick;
      Hint := 'Текст';
      ShowHint := True;
    end;
    FText := 'Введите текст';
    ArrayOfProp[1] := TSpinEdit.Create (Panel^);
    with (ArrayOfProp[1] as TSpinEdit) do begin
      Parent := Panel^;
      Name := 'TTextSize';
      top := 2;
      left := 2;
      Width := 62;
      Height := 23;
      MinValue := 1;
      Value := FTextSize;
      OnChange := @TextSizeChange;
      Hint := 'Размер шрифта';
      ShowHint := True;
    end;
    ArrayOfProp[2] := TToggleBox.Create (Panel^);
    with (ArrayOfProp[2] as TToggleBox) do begin
      Parent := Panel^;
      Name := 'dfdf';
      Font.Style := [fsItalic];
      Caption := 'к';
      top := 26;
      left := 2;
      Width := 23;
      Height := 23;
      OnChange := @TextCursiv;
      Hint := 'Курсив';
      ShowHint := True;
    end;
    ArrayOfProp[3] := TToggleBox.Create (Panel^);
    with (ArrayOfProp[3] as TToggleBox) do begin
      Parent := Panel^;
      Name := 'dsdsda';
      Font.Style := [fsBold];
      Caption := 'ж';
      top := 26;
      left := 26;
      Width := 23;
      Height := 23;
      OnChange := @TextFeet;
      Hint := 'Полужирный';
      ShowHint := True;
    end;
    ArrayOfProp[4] := TToggleBox.Create (Panel^);
    with (ArrayOfProp[4] as TToggleBox) do begin
      Parent := Panel^;
      Name := 'sdfsdf';
      Font.Style := [fsUnderline];
      Caption := 'ч';
      top := 52;
      left := 2;
      Width := 23;
      Height := 23;
      OnChange := @TextLine;
      Hint := 'Подчеркнутый';
      ShowHint := True;
    end;

    ArrayOfProp[5] := TToggleBox.Create (Panel^);
    with (ArrayOfProp[5] as TToggleBox) do begin
      Parent := Panel^;
      Name := 'qweweq';
      Font.Style := [fsStrikeOut];
      Caption := 'ab';
      top := 52;
      left := 26;
      Width := 23;
      Height := 23;
      OnChange := @TextXLine;
      Hint := 'Зачеркнутый';
      ShowHint := True;
    end;

    ArrayOfProp[6] := TComboBox.Create (Panel^);
    with (ArrayOfProp[6] as TComboBox) do begin
      Parent := Panel^;
      Name := 'Arial';
      top := 78;
      left := 2;
      Width := 62;
      Height := 23;
      OnChange := @TextStyle;
      Hint := 'Стиль текста';
      ShowHint := True;
      Items := Screen.Fonts;
    end;
    FTextStyle := (ArrayOfProp[6] as TComboBox).Items[0];
    FSettings := [];
  end;

procedure TTextTools.TextXLine (Sender: TObject);
  var
    i: integer;
  begin
    if (Sender as TToggleBox).Checked then
      FSettings := FSettings + [fsStrikeOut]
    else
      FSettings := FSettings - [fsStrikeOut];
    for i := 0 to High (Figures) do begin
      if Figures[i].Selected then
        if (Sender as TToggleBox).Checked then
          (Figures[i] as TText).TextStyle :=
            (Figures[i] as TText).TextStyle + [fsStrikeOut]
        else
          (Figures[i] as TText).TextStyle :=
            (Figures[i] as TText).TextStyle - [fsStrikeOut];
    end;
    Change.SaveNeed := True;
    Redrawing;
    //[fsBold,fsItalic, fsStrikeOut, fsUnderline]
  end;

procedure TTextTools.TextLine (Sender: TObject);
  var
    i: integer;
  begin
    if (Sender as TToggleBox).Checked then
      FSettings := FSettings + [fsUnderline]
    else
      FSettings := FSettings - [fsUnderline];
    for i := 0 to High (Figures) do begin
      if Figures[i].Selected then
        if (Sender as TToggleBox).Checked then
          (Figures[i] as TText).TextStyle :=
            (Figures[i] as TText).TextStyle + [fsUnderline]
        else
          (Figures[i] as TText).TextStyle :=
            (Figures[i] as TText).TextStyle - [fsUnderline];
    end;
    Change.SaveNeed := True;
    Redrawing;
  end;

procedure TTextTools.TextFeet (Sender: TObject);
  var
    i: integer;
  begin
    if (Sender as TToggleBox).Checked then
      FSettings := FSettings + [fsBold]
    else
      FSettings := FSettings - [fsBold];
    for i := 0 to High (Figures) do begin
      if Figures[i].Selected then
        if (Sender as TToggleBox).Checked then
          (Figures[i] as TText).TextStyle :=
            (Figures[i] as TText).TextStyle + [fsBold]
        else
          (Figures[i] as TText).TextStyle :=
            (Figures[i] as TText).TextStyle - [fsBold];
    end;
    Change.SaveNeed := True;
    Redrawing;
  end;

procedure TTextTools.TextCursiv (Sender: TObject);
  var
    i: integer;
  begin
    if (Sender as TToggleBox).Checked then
      FSettings := FSettings + [fsItalic]
    else
      FSettings := FSettings - [fsItalic];
    for i := 0 to High (Figures) do begin
      if Figures[i].Selected then
        if (Sender as TToggleBox).Checked then
          (Figures[i] as TText).TextStyle :=
            (Figures[i] as TText).TextStyle + [fsItalic]
        else
          (Figures[i] as TText).TextStyle :=
            (Figures[i] as TText).TextStyle - [fsItalic];
    end;
    Change.SaveNeed := True;
    Redrawing;
  end;

procedure TTextTools.TextStyle (Sender: TObject);
  var
    i: integer;
  begin
    FTextStyle := (Sender as TComboBox).Text;
    for i := 0 to High (Figures) do begin
      if Figures[i].Selected then
        (Figures[i] as TText).TextSeting := FTextStyle;
    end;
    Change.SaveNeed := True;
    Redrawing;
  end;

procedure TTextTools.TextSizeChange (Sender: TObject);
  var
    i: integer;
  begin
    FTextSize := (Sender as TSpinEdit).Value;
    for i := 0 to High (Figures) do begin
      if Figures[i].Selected then
        (Figures[i] as TText).TextSize := FTextSize;
    end;
    Change.SaveNeed := True;
    Redrawing;
  end;

procedure TTextTools.MemoClick (Sender: TObject);
  var
    i: integer;
  begin
    FText := InNonNormText ((Sender as TEdit).Text);
    for i := 0 to High (Figures) do begin
      if Figures[i].Selected then
        (Figures[i] as TText).Texts := FText;
    end;
    Change.SaveNeed := True;
    Redrawing;
  end;

procedure TTextTools.MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
  begin
    if DownPress then begin
      Figures[High (Figures)].FWorldPoints[1] := PointW (x, y);
      (Figures[High (Figures)] as TText).RectPoints[1] := WorldToScreen (PointW (X, Y));
    end;
  end;

function TTextTools.GetFigure (): TFigure;
  begin
    Result := TText.Create;
  end;

procedure TTextTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  var
    i: integer;
  begin
    DownPress := False;
    IndexOfTranformer := High (Figures);
    for i := 0 to High (Figures) do
      Figures[i].Selected := False;
    Figures[High (Figures)].Selected := True;
    CurrentTool := LastTool;
    LastTool := TTransformationTools.Create;
    EndingTransformaton := True;
    //DownPress := False;
    //IndexOfTranformer := High (Figures);
    //Figures[High (Figures)].Selected := True;
    //SetLength((Figures[High (Figures)] as TText).RectPoints,0)
  end;

//TSpreyTools
procedure TSpreyTools.OnTime (Sender: TObject);
  begin
    Inc (Times);
    while (Figures[High (Figures)] as TSprey).Times[Length (
        (Figures[High (Figures)] as TSprey).Times)] <> ':' do
      (Figures[High (Figures)] as TSprey).Times :=
        Copy ((Figures[High (Figures)] as TSprey).Times, 1, Length (
        (Figures[High (Figures)] as TSprey).Times) - 1);
    (Figures[High (Figures)] as TSprey).Times :=
      (Figures[High (Figures)] as TSprey).Times + IntToStr (Times) + ';';
    Redrawing;
  end;

procedure TSpreyTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  var
    i: integer;
  begin
    Timer.Enabled := False;
    Timer.OnTimer := @OnTime;
    DownPress := True;
    Timer.Enabled := True;
    SaveFlag.SaveNeed := True;
    for i := 0 to High (Figures) do
      Figures[i].Selected := False;
    SetLength (Figures, Length (Figures) + 1);
    Figures[High (Figures)] := GetFigure ();
    (Figures[High (Figures)] as TSprey).Times := '[0]:1;';
    Times := 1;
    (Figures[High (Figures)] as TSprey).PenColor := FPenColor;
    (Figures[High (Figures)] as TSprey).FirstElem := Random (100);
    (Figures[High (Figures)] as TSprey).Size := FSize;
    (Figures[High (Figures)] as TSprey).Freq := FFreq;
    SetLength (Figures[High (Figures)].FWorldPoints, 1);
    Figures[High (Figures)].FWorldPoints[0] := PointW (X, Y);
  end;

procedure TSpreyTools.MouseMove (Sender: TObject; Shift: TShiftState; X, Y: double);
  begin
    if DownPress then begin
      SetLength (Figures[High (Figures)].FWorldPoints, Length (
        Figures[High (Figures)].FWorldPoints) + 1);
      Figures[High (Figures)].FWorldPoints[High (
        Figures[High (Figures)].FWorldPoints)] :=
        PointW (X, Y);
      (Figures[High (Figures)] as TSprey).Times :=
        (Figures[High (Figures)] as TSprey).Times + '[' + IntToStr (
        High (Figures[High (Figures)].FWorldPoints)) + ']:' +
        IntToStr (Times) + ';';
      Times += 1;
    end;
  end;

procedure TSpreyTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  var
    i: integer;
  begin
    Timer.Enabled := False;
    DownPress := False;
    SaveFlag.SaveNeed := True;
    Change.SaveNeed := True;
    IndexOfTranformer := High (Figures);
    for i := 0 to High (Figures) do
      Figures[i].Selected := False;
    Figures[High (Figures)].Selected := True;
    CurrentTool := LastTool;
    LastTool := TTransformationTools.Create;
    EndingTransformaton := True;
  end;

function TSpreyTools.GetFigure (): TFigure;
  begin
    Result := TSprey.Create;
  end;

procedure TSpreyTools.SpinEditSizeClick (Sender: TObject);
  var
    i: integer;
  begin
    FSize := (Sender as TSpinEdit).Value;
    SetProps ('Size', FSize);
    Change.SaveNeed := True;
    Redrawing;
  end;

procedure TSpreyTools.SetProperty ();
  var
    i: integer;
  begin
    inherited;
    SetLength (ArrayOfProp, 2);
    ArrayOfProp[0] := TSpinEdit.Create (Panel^);
    with (ArrayOfProp[0] as TSpinEdit) do begin
      Parent := Panel^;
      top := WTop;
      WTop += 30;
      left := WLeft;
      Width := 55;
      Height := 23;
      MinValue := 10;
      OnChange := @SpinEditSizeClick;
      Hint := 'Размер';
      ShowHint := True;
      Value := FSize;
    end;
    for i := 0 to High (Figures) do
      if Figures[i].Selected then
        FSize := (Figures[i] as TSprey).Size;
    ArrayOfProp[1] := TSpinEdit.Create (Panel^);
    with (ArrayOfProp[1] as TSpinEdit) do begin
      Parent := Panel^;
      top := WTop;
      WTop += 30;
      left := WLeft;
      Width := 55;
      Height := 23;
      MinValue := 1;
      MaxValue := 1000;
      OnChange := @SpinEditFreqClick;
      Hint := 'Частота';
      ShowHint := True;
      Value := FFreq;
    end;
    for i := 0 to High (Figures) do
      if Figures[i].Selected then
        FFreq := (Figures[i] as TSprey).Freq;
  end;

procedure TSpreyTools.SpinEditFreqClick (Sender: TObject);
  begin
    FFreq := (Sender as TSpinEdit).Value;
    SetProps ('Freq', FFreq);
    Change.SaveNeed := True;
    Redrawing;
  end;


//TTransformationTools
procedure TTransformationTools.MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  var
    i, j: integer;
  begin
    if (Button = mbLeft) then begin
      Start := PointW (X, Y);
      MovingPoint.Selected := False;
      DownPress := True;
      if IndexOfTranformer <> -1 then begin
        Figures[IndexOfTranformer].Selected := True;
        MovingPoint := Frame.CheckFrameAnchors (PointW (X, Y));
        if not MovingPoint.Selected then
          MovingPoint := Figures[IndexOfTranformer].Check (X, Y);
        if not MovingPoint.Selected then begin
          MovingPoint.Selected :=
            Checking.Check (Figures[IndexOfTranformer], PointW (X, Y), PointW (X, Y));
          MovingPoint.Action := @MoveAll;
        end;
      end;
      if MovingPoint.Selected then
        Exit;
      if EndingTransformaton then begin
        LastTool.Free;
        LastTool := CurrentTool;
        EndingTransformaton := False;
        LastTool.MouseDown (Sender, Button, Shift, X, Y);
        Exit;
      end;
      if (not MovingPoint.Selected) and (not EndingTransformaton) then begin
        MovingPoint := Frame.CheckFrameAnchors (PointW (X, Y));
            if MovingPoint.Selected then
              Exit;
        for i := High (Figures) downto 0 do begin
          if Figures[i].Selected then begin
            MovingPoint := Figures[i].Check (X, Y);
            if MovingPoint.Selected then
              Break;
            MovingPoint.Selected :=
              Checking.Check (Figures[i], PointW (X, Y), PointW (X, Y));
            if MovingPoint.Selected then begin
              MovingPoint.Action := @MoveAll;
              Break;
            end;
          end;

          //    //  if Figures[i].Check (X, Y) then exit;
          //    //IndexOfTranformer:=i;
          //    //SetLength(Figures[High(Figures)].FWorldPoints,High(Figures[i].FWorldPoints));
          //    //Figures[High(Figures)].FWorldPoints:=Copy(Figures[i].FWorldPoints);
        end;
      end;
      if not MovingPoint.Selected then begin
        for i := 0 to High (Figures) do
          Figures[i].Selected := False;
        SetLength (Figures, Length (Figures) + 1);
        Figures[High (Figures)] := TRoundRectangl.Create;
        with (Figures[High (Figures)] as TRoundRectangl) do begin
          SetLength (FWorldPoints, 2);
          FWorldPoints[0] := Start;
          FWorldPoints[1] := Start;
          RoundX := 0;
          RoundY := 0;
          PenColor := clBlack;
          PenStyle := integer (psDot);
          PenWidth := 1;
          BrushStyle := integer (bsClear);
        end;

      end;
    end;
  end;

procedure TTransformationTools.SetProperty ();
  begin
    ArrayOfProp := nil;
  end;

procedure TTransformationTools.MouseMove (Sender: TObject; Shift: TShiftState;
  X, Y: double);
  var
    i: integer;
  begin
    if DownPress then begin
      SaveFlag.SaveNeed := True;
      if MovingPoint.Selected then
        MovingPoint.Action (PointW (X, Y), MovingPoint.ind)
      else begin
        (Figures[High (Figures)] as TRoundRectangl).FWorldPoints[1] := PointW (X, Y);
        for i := High (Figures) - 1 downto 0 do begin
          Figures[i].Selected := False;
          if Check (Figures[i], Figures[High (Figures)].FWorldPoints[0],
            Figures[High (Figures)].FWorldPoints[1]) then begin
            Figures[i].Selected := True;
          end;
        end;
      end;
    end;
  end;

procedure TTransformationTools.MoveAll (Pt: MegaPoint; ind: integer);
  var
    i, j: integer;
  begin
    for i := 0 to High (Figures) do
      if Figures[i].Selected then
        for j := 0 to High (Figures[i].FWorldPoints) do begin
          Figures[i].FWorldPoints[j].X += Pt.X - Start.X;
          Figures[i].FWorldPoints[j].Y += Pt.Y - Start.Y;
        end;
    Start := Pt;
  end;

procedure GetGenericProps ;
var i : integer;
    AClass : TClass;
    BClass : TFigureTools;
  function GetOldestClass (AFClass, ASClass: TClass): TClass;
    begin
      if (AFClass = ASClass) or ASClass.InheritsFrom (AFClass) then
        exit (AFClass)
      else if AFClass.InheritsFrom (ASClass) then
          exit (ASClass)
        else
          exit (GetOldestClass (AFClass.ClassParent, ASClass.ClassParent));
    end;
  begin
     for i := 0 to High (Figures) do
       if Figures[i].Selected then begin
         AClass:=Figures[i].ClassType;
         Break;
       end;
     for i:=i to High (Figures) do
       if Figures[i].Selected then
         AClass:=GetOldestClass(AClass,Figures[i].ClassType);
     BClass:=TFigureToolsClass(GetClass(AClass.ClassName + 'tools')).create;
     if BClass= nil then begin
       ArrayOfProp:=nil;
       Exit;
     end;
     BClass.SetProperty ;
     BClass.Free;
  end;


procedure TTransformationTools.MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: double);
  var
    i: integer;
  begin
    DownPress := False;
    if MovingPoint.Selected then
      Change.SaveNeed := True;
    if (not MovingPoint.Selected) and (not EndingTransformaton) then begin
      DestroyControls;
      for i := High (Figures) - 1 downto 0 do begin
        if Check (Figures[i], Figures[High (Figures)].FWorldPoints[0],
          Figures[High (Figures)].FWorldPoints[1]) then begin
          Figures[i].Selected := True;
          if (Figures[High (Figures)].FWorldPoints[1].X =
            Figures[High (Figures)].FWorldPoints[0].X) and
            (Figures[High (Figures)].FWorldPoints[1].Y =
            Figures[High (Figures)].FWorldPoints[0].Y) then
            Break;
        end;
      end;
      Figures[High (Figures)].Free;
      SetLength (Figures, Length (Figures) - 1);
      GetGenericProps;
    end;
    MovingPoint.Selected := False;
  end;

//Регистрация классов
procedure RegistrateFigureTools (AClass: TFigureToolsClass);
  begin
    SetLength (ArrayFigureToolsClass, Length (ArrayFigureToolsClass) + 1);
    ArrayFigureToolsClass[High (ArrayFigureToolsClass)] := AClass;
    RegisterClass (AClass);
  end;


initialization
  SaveFlag:=TSaveFlag.Create;
  TRegularPolygonTools.NubmerOfAngle:=3;
  TGeometryFigureTools.FPenWidth := 1;
  TGeometryFigureTools.FPenStyle := 3;
  TSpreyTools.FFreq := 10;
  TFillFigureTools.FBrushColor := clWhite;
  TSpreyTools.FSize := 10;
  TTextTools.FTextSize := 12;
  TRoundRectanglTools.FRound := point (10, 10);
  TFigureTools.FPenColor := clBlack;
  Timer := TTimer.Create (nil);
  Timer.Interval := 1;
  RegistrateFigureTools (TSpreyTools);
  RegistrateFigureTools (TPolygonTools);
  RegistrateFigureTools (TRegularPolygonTools);
  RegistrateFigureTools (TPolylineTools);
  RegistrateFigureTools (TRoundRectanglTools);
  RegistrateFigureTools (TPencilTools);
  RegistrateFigureTools (TLineTools);
  RegistrateFigureTools (TEllipseTools);
  RegistrateFigureTools (TRectanglTools);
  RegistrateFigureTools (THandTools);
  RegistrateFigureTools (TTextTools);
  RegistrateFigureTools (TTransformationTools);

end.
