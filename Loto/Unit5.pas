unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm5 = class(TForm)
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;
    Shape13: TShape;
    Shape14: TShape;
    Shape15: TShape;
    Shape16: TShape;
    Shape17: TShape;
    Shape18: TShape;
    Shape19: TShape;
    Shape20: TShape;
    Shape21: TShape;
    Shape22: TShape;
    Shape23: TShape;
    Shape24: TShape;
    Shape25: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure pDefineHeat(shp: TShape; temp: Integer);
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}

procedure TForm5.Button1Click(Sender: TObject);
var
  arrInt: Array of Integer;
  i: Integer;
begin
  arrInt :=
    [1,2,3,5,6,7,11,12,14,16,17,19,21,22,24,
     2,4,7,9,10,12,13,14,15,16,17,22,23,24,25,
     1,2,3,5,9,10,11,13,15,16,17,18,23,24,
     1,4,5,6,7,9,12,13,15,17,18,19,20,21,25,
     1,2,3,7,8,10,11,12,15,16,17,20,22,23,25,
     1,2,3,7,8,10,11,12,13,14,18,20,21,23,25];

  for i := 0 to Length(arrInt) - 1 do
  begin
    (FindComponent('Label' +IntToStr(arrInt[i])) as TLabel).Caption :=
      IntToStr(StrToIntDef((FindComponent('Label' +IntToStr(arrInt[0])) as TLabel).Caption, 0) + 1);

    pDefineHeat((FindComponent('Shape' +IntToStr(arrInt[i])) as TShape),
      StrToIntDef((FindComponent('Label' +IntToStr(arrInt[0])) as TLabel).Caption, 0));
  end;
end;

procedure TForm5.pDefineHeat(shp: TShape; temp: Integer);
begin
  if temp < 4 then
    shp.Brush.Color := clWebCornFlowerBlue
  else if temp < 5 then
    shp.Brush.Color := clWebLightSalmon
  else
    shp.Brush.Color := clWebRed;

  shp.Shape := stCircle;
  shp.Height := 5 + (temp*6);
  shp.Width := 5 + (temp*6);

  shp.Refresh;
end;

end.
