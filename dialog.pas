unit Dialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Figure;

type

  { TForm2 }

  TForm2 = class(TForm)
    BtnYes: TButton;
    BtnNo: TButton;
    BtnCancel: TButton;
    Panel1: TPanel;
    procedure BtnNoClick (Sender: TObject);
    procedure BtnYesClick (Sender: TObject);
    procedure BtnCancelClick (Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form2: TForm2;
  Activity: string;
  OK, No : Boolean;

implementation

uses Main;

{$R *.lfm}

{ TForm2 }

procedure TForm2.BtnYesClick (Sender: TObject);
  begin
    OK:=True;
    No:=False;
    Form2.Close;
  end;

procedure TForm2.BtnCancelClick (Sender: TObject);
  begin
    OK:=False;
    No:=False;
    Form2.Close;
  end;

procedure TForm2.BtnNoClick (Sender: TObject);
  begin
    OK:=False;
    No:=True;
    Form2.Close;
  end;

end.
