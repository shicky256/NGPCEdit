object ColorPicker: TColorPicker
  Left = 0
  Top = 0
  Caption = 'ColorPicker'
  ClientHeight = 203
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object RedLabel: TLabel
    Left = 24
    Top = 48
    Width = 19
    Height = 13
    Caption = 'Red'
  end
  object GreenLabel: TLabel
    Left = 24
    Top = 88
    Width = 29
    Height = 13
    Caption = 'Green'
  end
  object BlueLabel: TLabel
    Left = 24
    Top = 136
    Width = 20
    Height = 13
    Caption = 'Blue'
  end
  object PreviewLabel: TLabel
    Left = 152
    Top = 45
    Width = 38
    Height = 13
    Caption = 'Preview'
  end
  object Image1: TImage
    Left = 152
    Top = 64
    Width = 113
    Height = 107
  end
  object PaletteLabel: TLabel
    Left = 24
    Top = 11
    Width = 34
    Height = 13
    Caption = 'Palette'
  end
  object ColorLabel: TLabel
    Left = 152
    Top = 11
    Width = 25
    Height = 13
    Caption = 'Color'
  end
  object RedSpin: TSpinEdit
    Left = 64
    Top = 45
    Width = 49
    Height = 22
    MaxValue = 15
    MinValue = 0
    TabOrder = 0
    Value = 0
    OnChange = RedSpinChange
  end
  object GreenSpin: TSpinEdit
    Left = 64
    Top = 85
    Width = 49
    Height = 22
    MaxValue = 15
    MinValue = 0
    TabOrder = 1
    Value = 0
    OnChange = GreenSpinChange
  end
  object BlueSpin: TSpinEdit
    Left = 64
    Top = 133
    Width = 49
    Height = 22
    MaxValue = 15
    MinValue = 0
    TabOrder = 2
    Value = 0
    OnChange = BlueSpinChange
  end
  object PaletteSpin: TSpinEdit
    Left = 64
    Top = 8
    Width = 49
    Height = 22
    MaxValue = 15
    MinValue = 0
    TabOrder = 3
    Value = 0
    OnChange = PaletteSpinChange
  end
  object ColorSpin: TSpinEdit
    Left = 191
    Top = 8
    Width = 49
    Height = 22
    MaxValue = 3
    MinValue = 1
    TabOrder = 4
    Value = 1
    OnChange = ColorSpinChange
  end
end
