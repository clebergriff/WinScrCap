unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
   initialColors: array [0 .. 2] of string = ('FF0000', '00FF00', '0000FF');

var
  Form2: TForm2;

implementation

uses
  Math;

{$R *.dfm}

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  function HexToTColor(sColor : string) : TColor;
  begin
     Result :=
       RGB(
         StrToInt('$'+Copy(sColor, 1, 2)),
         StrToInt('$'+Copy(sColor, 3, 2)),
         StrToInt('$'+Copy(sColor, 5, 2))
       ) ;
  end;

var
  shp: TShape;
  newX, newY: Integer;
begin
  Randomize;

  shp := TShape.Create(Self);

  shp.Parent := Self;

  shp.Brush.Color := HexToTColor(initialColors[RandomRange(0, 2)]);

  shp.Height := 20;
  shp.Width := 20;

  shp.Left := X;
  shp.Top := Y;

  shp.Visible := True;

  TThread.CreateAnonymousThread(procedure begin
    while True do
    begin

      repeat
        newX := RandomRange(-4, 5);
      until (shp.Left + newX > 0) and (shp.Left + newX < Self.Width);

      repeat
        newY := RandomRange(-4, 5);
      until (shp.Top + newY > 0) and (shp.Top + newY < Self.Height);

      shp.Left := shp.Left + newX;
      shp.Top := shp.Top + newY;

      Sleep(RandomRange(0, 100));
    end;
  end).Start;
end;

end.
