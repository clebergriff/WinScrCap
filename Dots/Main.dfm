object Form2: TForm2
  Left = 1040
  Top = 414
  Caption = 'Form2'
  ClientHeight = 300
  ClientWidth = 300
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object Timer1: TTimer
    Interval = 60
    OnTimer = Timer1Timer
    Left = 264
    Top = 8
  end
end
