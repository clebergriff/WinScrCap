unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, madExceptVcl;

type
  TForm2 = class(TForm)
    Timer1: TTimer;
    MadExceptionHandler1: TMadExceptionHandler;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    procedure pTestarChoque(shp: TShape);
    procedure pCriarShape(nHeight, nWidth, nX, nY: Integer; newColor: TColor);
    function Blend(Color1, Color2: TColor; A: Byte): TColor;
  public
    { Public declarations }
  end;

const
   initialColors: array [0 .. 3] of string = ('FF0000', '00FF00', '0000FF', 'FFFF00');

var
  Form2: TForm2;

implementation

uses
  Math;

{$R *.dfm}

function TForm2.Blend(Color1, Color2: TColor; A: Byte): TColor;
var
  c1, c2: LongInt;
  r, g, b, v1, v2: byte;
begin
  try
    A:= Round(2.55 * A);
    c1 := ColorToRGB(Color1);
    c2 := ColorToRGB(Color2);
    v1:= Byte(c1);
    v2:= Byte(c2);
    r:= A * (v1 - v2) shr 8 + v2;
    v1:= Byte(c1 shr 8);
    v2:= Byte(c2 shr 8);
    g:= A * (v1 - v2) shr 8 + v2;
    v1:= Byte(c1 shr 16);
    v2:= Byte(c2 shr 16);
    b:= A * (v1 - v2) shr 8 + v2;
    Result := (b shl 16) + (g shl 8) + r;
  except
    on E: Exception do
      ShowMessage('Blend - ' +E.Message);
  end;
end;

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
begin
  try
    pCriarShape(20, 20, X, Y, HexToTColor(initialColors[RandomRange(0, 4)]));
  except
   on E: Exception do
    showmessage(e.Message);
   end;
end;

procedure TForm2.pCriarShape(nHeight, nWidth, nX, nY: Integer; newColor: TColor);
begin
  TThread.CreateAnonymousThread(
  procedure
  var
    newX, newY: Integer;
    shp: TShape;
  begin
    shp := TShape.Create(Self);

    shp.Brush.Color := newColor;

    shp.Height := nHeight;
    shp.Width := nWidth;

    shp.Parent := Self;

    shp.Left := nX;
    shp.Top := nY;

    shp.Visible := True;

    while shp <> nil do
    begin
      if (shp.Left + shp.Height < 0) or (shp.Left + shp.Height > 300) or
         (shp.Top + shp.Width < 0) or (shp.Left + shp.Width > 300) then
      begin
        shp.Left := 0;
        shp.Top := 0;
      end;

      repeat
        newX := RandomRange(-4, 5);
      until (shp.Left + newX > 0) and (shp.Left + shp.Width + newX <= 300);

      repeat
        newY := RandomRange(-4, 5);
      until (shp.Top + newY > 0) and (shp.Top + shp.Height + newY < 300);

      shp.Left := shp.Left + newX;
      shp.Top := shp.Top + newY;

      Sleep(RandomRange(0, 100));

      shp.Refresh;

      pTestarChoque(shp);
    end;
  end).Start;
end;

procedure TForm2.pTestarChoque(shp: TShape);
var
  i: Integer;
  R : TRect;
  corFilho: TColor;
begin
    for i := 0 to Pred(Form2.ComponentCount) do
    begin
      if (Form2.Components[i] is TShape) and
        (Form2.Components[i] <> shp)
      then
      begin
        IntersectRect(R, shp.BoundsRect, (Form2.Components[i] as TShape).BoundsRect);

        if (R.Left <> R.Right) and (R.Top <> R.Bottom) then
        begin
          {
          shp.Top := shp.Top - 10;
          shp.Left := shp.Left - 10;

          (Form2.Components[i] as TShape).Top := (Form2.Components[i] as TShape).Top + 10;
          (Form2.Components[i] as TShape).Left := (Form2.Components[i] as TShape).Left + 10;
          }

          corFilho :=
            Blend(shp.Brush.Color, (Form2.Components[i] as TShape).Brush.Color, 50);

          try
            if Assigned(Form2.Components[i]) then
              Form2.Components[i].Destroy;

            if Assigned(shp) then
              shp.Destroy;
          except
            ;
          end;

          try
            pCriarShape(20, 20, R.Left, R.Top, corFilho);
          except
           on E: Exception do
            showmessage(e.Message);
           end;

          Exit;
        end;
      end;
    end;
end;

end.
