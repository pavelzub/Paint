unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Tools, Figure, Buttons, StdCtrls, ActnList, MaskEdit, CheckLst, Spin, Menus,
  Load, Transformation, ComCtrls, Dialog,TopMenu,EditMenu,FrameTimer,History;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnUndo: TSpeedButton;
    BtnUp: TSpeedButton;
    BtnDown: TSpeedButton;
    BtnSave: TSpeedButton;
    BtnSaveAs: TSpeedButton;
    BtnOpen: TSpeedButton;
    BtnReDo: TSpeedButton;
    ColorDialog1: TColorDialog;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    CopyBtn: TMenuItem;
    Delete: TMenuItem;
    LoseSelected: TMenuItem;
    about: TMenuItem;
    MSave: TMenuItem;
    MSaveAs: TMenuItem;
    MOpen: TMenuItem;
    MReDo: TMenuItem;
    MUndo: TMenuItem;
    MNew: TMenuItem;
    Spravka: TMenuItem;
    MExit: TMenuItem;
    Pasting: TMenuItem;
    MFile: TMenuItem;
    Coping: TMenuItem;
    SelectAll: TMenuItem;
    PastBtn: TMenuItem;
    OpenDialog1: TOpenDialog;
    PaintBox1: TPaintBox;
    HorizontalScrollBar: TScrollBar;
    Panel1: TPanel;
    Panel2: TPanel;
    FPanel: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PanelBrush: TPanel;
    PanelPen: TPanel;
    SaveDialog1: TSaveDialog;
    ScalePanel: TPanel;
    BtnDelete: TSpeedButton;
    SpinEdit1: TSpinEdit;
    FrameTimer: TTimer;
    VerticalScrollBar: TScrollBar;
    procedure aboutClick (Sender: TObject);
    procedure BtnDownClick (Sender: TObject);
    procedure BtnOpenClick (Sender: TObject);
    procedure BtnReDoClick (Sender: TObject);
    procedure BtnSaveClick (Sender: TObject);
    procedure BtnUndoClick (Sender: TObject);
    procedure BtnUpClick (Sender: TObject);
    procedure CopyBtnClick (Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormCloseQuery (Sender: TObject; var CanClose: boolean);
    procedure FormCreate (Sender: TObject);
    procedure FrameTimerTimer (Sender: TObject);
    procedure HorizontalScrollBarScroll (Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: integer);
    procedure LoseSelectedClick (Sender: TObject);
    procedure MExitClick (Sender: TObject);
    procedure MNewClick (Sender: TObject);
    procedure PaintBox1Click(Sender: TObject);
    procedure PaintBox1MouseDown (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PaintBox1MouseMove (Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure PaintBox1MouseUp (Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PaintBox1Paint (Sender: TObject);
    procedure ButtonClick (Sender: TObject);
    procedure DrawFigures ();
    procedure PastBtnClick (Sender: TObject);
    procedure BtnSaveAsClick (Sender: TObject);
    procedure PanelBrushClick (Sender: TObject);
    procedure PanelPenClick (Sender: TObject);
    procedure BtnDeleteClick (Sender: TObject);
    procedure SelectAllClick (Sender: TObject);
    procedure SpinEdit1Change (Sender: TObject);
    procedure VerticalScrollBarScroll (Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: integer);
    procedure PanelPenColorClick (Sender: TObject);
  private
    FirstBitmap, SecondBitmap: TBitmap;
    Sizing, New: boolean;
    NameFile: string;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

// Создание.
procedure TForm1.FormCreate (Sender: TObject);
  var
    i, lefts, tops: integer;
    Button: TSpeedButton;
    s: string;
  begin
    Randomize;
    CurrentTool:=TPencilTools.Create;
    NameFile:=Caption;
    SaveFlag.FileName:=@NameFile;
    Panel := @FPanel;
    Redrawing := @Invalidate;
    New := True;
    IndexOfTranformer := -1;
    EndingTransformaton := False;
    scale := 1;
    maxX := 0;
    maxY := 0;
    minX := 10;
    MinY := 10;
    Lefts := 8;
    tops := 40;
   for i := 0 to High (ArrayFigureToolsClass) do begin
      if lefts = 68 then begin
        lefts := 8;
        tops += 30;
      end;
      Button := TSpeedButton.Create (Form1);
      with Button do begin
        Parent := Form1;
        Name := ArrayFigureToolsClass[i].ClassName;
        Glyph.LoadFromFile ('Image\' +
          ArrayFigureToolsClass[i].ClassName + '.bmp');
        top := tops;
        left := lefts;
        Width := 30;
        Height := 30;
        OnClick := @ButtonClick;
      end;
      lefts += 30;
    end;
    LastTool := TPencilTools.Create;
    SecondBitmap := TBitmap.Create;
    FirstBitmap := TBitmap.Create;
    LastTool.SetProperty ();
  end;

procedure TForm1.FrameTimerTimer (Sender: TObject);
  var
    i: integer;
  begin
    SecondBitmap.Canvas.Draw (0, 0, FirstBitmap);
    Frame.FrameSize;
    Frame.CreateFrame (SecondBitmap.Canvas);
    PaintBox1.Canvas.Draw (0, 0, SecondBitmap);
  end;

procedure TForm1.ButtonClick (Sender: TObject);
  var
    Panel: TPanel;
    i: integer;
  begin
    NeedCreat := False;
    DownPress := False;
    for i := 0 to High (Figures) do
      Figures[i].Selected := False;
    IndexOfTranformer := -1;
    EndingTransformaton := False;
    LastTool.Free;
    LastTool := TFigureToolsClass (GetClass ((Sender as TSpeedButton).Name)).Create;
    DestroyControls;
    LastTool.SetProperty ();
    for i := 0 to High (Figures) do
      Figures[i].Selected := False;
    PaintBox1Paint (PaintBox1);
  end;

//Перересовка
procedure TForm1.PaintBox1Paint (Sender: TObject);
  var
    i: integer;
  begin
    Caption:=NameFile;
    CanvasSize.X := PaintBox1.Width;
    CanvasSize.Y := PaintBox1.Height;
    FirstBitmap.SetSize (PaintBox1.Width, PaintBox1.Height);
    SecondBitmap.SetSize (PaintBox1.Width, PaintBox1.Height);
    DrawFigures ();
    Frame.FrameSize;
    for i := 0 to High (Figures) do
      if Figures[i].Selected then begin
        FrameTimer.Enabled := True;
        Exit;
      end;
    FrameTimer.Enabled := False;
  end;

procedure TForm1.DrawFigures ();
  var
    i, j: integer;
  begin
    maxx := 0;
    maxy := 0;
    minx := 0;
    miny := 0;
    for j := 0 to High (Figures) do begin
      MaxMin (Figures[j].Maxpoint);
      MaxMin (Figures[j].Minpoint);
    end;
    if (HorizontalScrollBar.Min <= Offset.X) and (Offset.X + 1000 <=
      HorizontalScrollBar.Max) then
      HorizontalScrollBar.Position := Offset.X;
    if (VerticalScrollBar.Min <= Offset.Y) and (Offset.Y + 1000 <=
      VerticalScrollBar.Max) then
      VerticalScrollBar.Position := Offset.Y;
    HorizontalScrollBar.Max := MaxPosition ().X + 1010;
    VerticalScrollBar.Max := MaxPosition ().Y + 1010;
    HorizontalScrollBar.Min := MinPosition ().X - 10;
    VerticalScrollBar.Min := MinPosition ().Y - 10;
    FirstBitmap.Canvas.Brush.Color := clWhite;
    FirstBitmap.Canvas.Brush.Style := bsSolid;
    FirstBitmap.Canvas.Pen.Color := clWhite;
    FirstBitmap.Canvas.Pen.Width := 1;
    FirstBitmap.Canvas.Rectangle (0, 0, PaintBox1.Width, PaintBox1.Height);
    i := High (Figures);
    for i := 0 to High (Figures) do
      Figures[i].Draw (FirstBitmap.Canvas);
    SecondBitmap.Canvas.Draw (0, 0, FirstBitmap);
    for i := 0 to High (Figures) do
      if Figures[i].Selected then begin
        Frame.CreateFrame (SecondBitmap.Canvas);
        Break;
      end;
    PaintBox1.Canvas.Draw (0, 0, SecondBitmap);
  end;


// Сохранение
procedure TForm1.BtnSaveAsClick (Sender: TObject);
  var
    i: integer;
  begin
    if SaveDialog1.Execute then begin
      new:=False;
      SaveFlag.SaveNeed := False;
      NameFile := SaveDialog1.FileName;
      Save (SaveDialog1.FileName,SaveDialog1.FilterIndex);
      SaveHistoryNumber:=HistoryIndex;
    end;
  end;

procedure TForm1.BtnOpenClick (Sender: TObject);
var i: integer;
  begin
    if SaveFlag.SaveNeed then Form2.ShowModal
      else  begin
        No:=True;
        OK:=False;
      end;
    if OK then BtnSaveAsClick (BtnSaveAs);
    if No or OK then
      if OpenDialog1.Execute then begin
        SaveFlag.SaveNeed := False;
        for i := 0 to High (Figures) do
          Figures[i].Free;
        SetLength (Figures, 0);
        NameFile := UTF8ToSys (OpenDialog1.FileName);
        Open (UTF8ToSys (OpenDialog1.FileName));
        DestroyControls;
        LastTool := CurrentTool;
        LastTool.SetProperty ();
        New:=False;
      end;
    Invalidate;
  end;

procedure TForm1.BtnSaveClick (Sender: TObject);
  begin
    SaveFlag.SaveNeed:=False;
    if new then
      BtnSaveAsClick (BtnSaveAs)
    else begin
      SaveDialog1.FileName := Form1.Caption;
      Save (NameFile,SaveDialog1.FilterIndex);
    end;
    SaveHistoryNumber:=HistoryIndex;
    New := False;
    Invalidate;
  end;

//undo/redo
procedure TForm1.BtnReDoClick (Sender: TObject);
  begin
    ReDoClick;
    Invalidate;
  end;

procedure TForm1.BtnUndoClick (Sender: TObject);
  begin
  UndoClick;
  Invalidate;
  end;

//Слои
procedure TForm1.BtnDownClick (Sender: TObject);
  begin
  DownClick;
  Invalidate;
  end;

procedure TForm1.BtnUpClick (Sender: TObject);
  begin
  UpClick;
  Invalidate;
  end;

procedure TForm1.aboutClick (Sender: TObject);
  begin
    ShowMessage ('Зубарев П. С. Б8103а');
  end;

// CopyPast
procedure TForm1.CopyBtnClick (Sender: TObject);
  begin
    CopyClick;
  end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
  ShowMessage(IntToStr(ord(key)));
end;

procedure TForm1.PastBtnClick (Sender: TObject);
  begin
    PastClick;
    Invalidate;
  end;

procedure TForm1.FormCloseQuery (Sender: TObject; var CanClose: boolean);
  var
    i: integer;
  begin
    if SaveFlag.SaveNeed then Form2.ShowModal
      else  begin
        No:=True;
        OK:=False;
      end;
    if OK then BtnSaveClick(nil);
    if not (OK or No) then CanClose:=False;
  end;

//Цвет
procedure TForm1.PanelBrushClick (Sender: TObject);
  var
    i: integer;
  begin
    if ColorDialog1.Execute then begin
      TFillFigureTools.FBrushColor := ColorDialog1.Color;
      PanelBrush.Color := TFillFigureTools.FBrushColor;
      for i := 0 to High (Figures) do begin
        if Figures[i].Selected then
          if (Figures[i] is TFillFigure) then
            (Figures[i] as TFillFigure).BrushColor := TFillFigureTools.FBrushColor;
      end;
      Change.SaveNeed := True;
    end;
    PaintBox1Paint (PaintBox1);
  end;

procedure TForm1.PanelPenClick (Sender: TObject);
  var
    i: integer;
  begin
    if ColorDialog1.Execute then begin
      TFigureTools.FPenColor := ColorDialog1.Color;
      PanelPen.Color := TFigureTools.FPenColor;
      for i := 0 to High (Figures) do
        if Figures[i].Selected then
          Figures[i].PenColor := TFigureTools.FPenColor;
      Change.SaveNeed := True;
    end;
    PaintBox1Paint (PaintBox1);
  end;

// Удаление
procedure TForm1.BtnDeleteClick (Sender: TObject);
  begin
    DeleteClick;
    Invalidate;
  end;

procedure TForm1.SelectAllClick (Sender: TObject);
  begin
    EditMenu.SelectAllClick;
    Invalidate;
  end;

//Нажатие мыши
procedure TForm1.PaintBox1MouseDown (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
  var
    XD, YD: double;
  begin
    XD := ScreenToWorld (Point (X, Y)).X;
    YD := ScreenToWorld (Point (X, Y)).Y;
    ShiftX := XD;
    ShiftY := YD;
    LastTool.MouseDown (Sender, Button, Shift, XD, YD);
    FrameTimer.Enabled := False;
    PaintBox1Paint (PaintBox1);
  end;

procedure TForm1.PaintBox1MouseMove (Sender: TObject; Shift: TShiftState; X, Y: integer);
  var
    XD, YD: double;
  begin
    if DownPress then
      FrameTimer.Enabled := False;
    if not FrameTimer.Enabled then begin
      XD := ScreenToWorld (Point (X, Y)).X;
      YD := ScreenToWorld (Point (X, Y)).Y;
      LastTool.MouseMove (Sender, Shift, XD, YD);
      PaintBox1Paint (PaintBox1);
    end;
  end;

procedure TForm1.PaintBox1MouseUp (Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
  var
    XD, YD: double;
  begin
    XD := ScreenToWorld (Point (X, Y)).X;
    YD := ScreenToWorld (Point (X, Y)).Y;
    if DownPress then
      LastTool.MouseUp (Sender, Button, Shift, XD, YD);
    PaintBox1Paint (PaintBox1);
  end;
//Ползунки

procedure TForm1.SpinEdit1Change (Sender: TObject);
  var
    centerh, centerv: double;
  begin
    centerv := (Offset.Y + PaintBox1.Height / 2) / scale;
    centerh := (Offset.X + PaintBox1.Width / 2) / scale;
    scale := SpinEdit1.Value / 100;
    Offset.X := round ((centerh * scale - PaintBox1.Width / 2));
    Offset.Y := round ((centerv * scale - PaintBox1.Height / 2));
    if Offset.x > HorizontalScrollBar.Max then
      Offset.x := HorizontalScrollBar.Max;
    if Offset.x < HorizontalScrollBar.Min then
      Offset.x := HorizontalScrollBar.Min;
    if Offset.y > VerticalScrollBar.Max then
      Offset.y := VerticalScrollBar.Max;
    if Offset.y < HorizontalScrollBar.Min then
      Offset.y := VerticalScrollBar.Min;
    Sizing := True;
    PaintBox1Paint (PaintBox1);
    Sizing := False;
  end;


procedure TForm1.VerticalScrollBarScroll (Sender: TObject; ScrollCode: TScrollCode;
  var ScrollPos: integer);
  begin
    Offset.Y := VerticalScrollBar.Position;
    Offset.X := HorizontalScrollBar.Position;
    PaintBox1Paint (PaintBox1);
  end;

procedure TForm1.HorizontalScrollBarScroll (Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: integer);
  begin
    Offset.Y := VerticalScrollBar.Position;
    Offset.X := HorizontalScrollBar.Position;
    PaintBox1Paint (PaintBox1);
  end;

procedure TForm1.LoseSelectedClick (Sender: TObject);
  begin
    EditMenu.LoseSelectedClick;
    Invalidate;
  end;

procedure TForm1.MExitClick (Sender: TObject);
  begin
    Form1.Close;
  end;

procedure TForm1.MNewClick (Sender: TObject);
var i : integer;
  begin
    if SaveFlag.SaveNeed then Form2.ShowModal
      else  begin
        No:=True;
        OK:=False;
      end;
    if OK then BtnSaveClick(nil);
    if No or OK then begin
    EndingTransformaton := False;
    IndexOfTranformer := -1;
    for i := 0 to High(Figures) do
      Figures[i].Free;
    SetLength(Figures,0);
    DestroyControls;
    LastTool := CurrentTool;
    LastTool.SetProperty ();
    New:=True;
    end;
    Invalidate;
  end;

procedure TForm1.PaintBox1Click(Sender: TObject);
begin

end;


procedure TForm1.PanelPenColorClick (Sender: TObject);
  begin

  end;

end.
