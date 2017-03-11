unit Load;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Figure, Transformation, typinfo, Graphics, Dialogs;

type
  TPropArray = array of PPropInfo;

function FigureToStr (Figur: TFigure): string;
function StrToFigure (Str: string): TFigure;

var
  Signature : String;

implementation

uses main;

procedure GetProps (AObject: TObject; var PropArr: TPropArray);
  var
    i, PropCount: integer;
    PrList: PPropList;
  begin
    PropCount := GetTypeData (AObject.ClassInfo)^.PropCount;
    GetMem (PrList, SizeOf (PPropInfo) * PropCount);
    SetLength (PropArr, PropCount);
    GetPropInfos (AObject.ClassInfo, PrList);
    for i := 0 to PropCount - 1 do
      PropArr[i] := PrList^[i];
    Freemem (PrList, SizeOf (PPropInfo) * PropCount);
  end;


function FigureToStr (Figur: TFigure): string;
  var
    i: integer;
    PropList: PPropList;
    s: string;
    PropArr: TPropArray;
  begin
    Result := Figur.ClassName + '|||';
    Result += 'Points::' + IntToStr (Length (Figur.FWorldPoints)) + '::';
    for i := 0 to High (Figur.FWorldPoints) do
      Result += FloatToStr (Figur.FWorldPoints[i].X) + '|' +
        FloatToStr (Figur.FWorldPoints[i].Y) + '::';
    Result := Copy (Result, 1, Length (Result) - 2) + '|||';
    GetProps (Figur, PropArr);
    for i := 0 to High (PropArr) do begin
      Result += PropArr[i]^.Name + '::';
      s := GetPropValue (Figur, PropArr[i]^.Name);
      Result += s + '|||';
    end;
  end;

function GetStr (r: string; var Info: string): string;
  begin
    Result := Copy (Info, 1, Pos (r, Info) - 1);
    Info := Copy (Info, Length (Result) + Length (r) + 1, Length (Info) -
      Length (Result) - Length (r));
  end;

function GetNum (r: string; var Info: string): double;
  begin
    Result := StrToFloat (GetStr (r, Info));
  end;

function StrToFigure (Str: string): TFigure;
  var
    S: string;
    i, ind: integer;
    Flag: boolean;
    X, Y: double;
    PropArr: TPropArray;
  begin
    Flag := False;
    S := Copy (Str, 1, Pos ('|||', Str) - 1);
    Str := Copy (Str, Length (S) + 4, Length (Str) - Length (S) - 3);
    for i := 0 to High (ArrayFigureClass) do
      if S = Copy (ArrayFigureClass[i].ClassName, 1, Length (s)) then begin
        Result := ArrayFigureClass[i].Create;
        Flag := True;
        break;
      end;
    if not Flag or (GetStr ('::', Str) <> 'Points') then begin
      Result := nil;
      exit;
    end;
    try
      Ind := round (GetNum ('::', Str));
      SetLength (Result.FWorldPoints, ind);
      for i := 0 to Ind - 1 do begin
        X := GetNum ('|', Str);
        if i <> Ind - 1 then
          Y := GetNum ('::', Str)
        else
          Y := GetNum ('|||', Str);
        Result.FWorldPoints[i] := PointW (X, Y);
      end;
      GetProps (Result, PropArr);
      for i := 0 to High (PropArr) do begin
        s := GetStr ('::', Str);
        if IsPublishedProp (Result, s) then
          SetPropValue (Result, s, GetStr ('|||', Str));
      end;
    except
      Result := nil;
      exit;
    end;
  end;

initialization
   Signature:='Тратата';

end.


