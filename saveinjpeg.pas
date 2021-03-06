unit SaveInJpeg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls,Figure,Transformation,FrameTimer,math;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    ComboBox1: TComboBox;
    EditWidth: TEdit;
    EditHeigth: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure EditWidthChange (Sender: TObject);
    procedure EditWidthKeyPress (Sender: TObject; var Key: char);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure SaveJpeg (Name: string);

var
  Form3: TForm3;
  PictureWidth,PictureHight: integer;
  FileName: String;

implementation

{$R *.lfm}

{ TForm3 }

procedure SaveJpeg (Name: string);
var p: TPoint;
  i,h,w: integer;
    s: Double;
    f: File;
    BitMap : TBitmap;
    Picture : TJPEGImage;
  begin
  BitMap:=TBitmap.Create;
  h:=StrToInt(Form3.EditHeigth.Text);
  w:=StrToInt(Form3.EditWidth.Text);
  p:=Offset;
  s:=scale;
  scale:=min((w-5)/(maxx-minx),(h-5)/(maxy-miny));
  Offset.X:=round(minx*scale);
  Offset.y:=round(miny*scale);
  Bitmap.SetSize (w, h);
  Bitmap.Canvas.Brush.Color := clWhite;
  Bitmap.Canvas.Brush.Style := bsSolid;
  Bitmap.Canvas.Pen.Color := clWhite;
  Bitmap.Canvas.Pen.Width := 1;
  Bitmap.Canvas.Rectangle (0, 0, w, h);
  for i:=0 to High(Figures) do begin
    Figures[i].Selected:=False;
    Figures[i].Draw (Bitmap.Canvas);
  end;
  scale:=s;
  Offset:=p;
  Picture:=TJPEGImage.Create;
  Picture.Assign(BitMap);
  Picture.SaveToFile(Name);
  end;

procedure TForm3.EditWidthKeyPress (Sender: TObject; var Key: char);
  begin
    if not (key in ['0'..'9', #8])  then
      Key := #0;
  end;

procedure TForm3.EditWidthChange (Sender: TObject);
  begin
    if ((Sender as TEdit).Text = '') or ((Sender as TEdit).Text[1] = '0')  then
      (Sender as TEdit).Text := '1';
  end;


end.
