object Editor: TEditor
  Left = 0
  Top = 0
  Caption = 'Editor'
  ClientHeight = 320
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 429
    Height = 25
    Caption = 'ToolBar1'
    TabOrder = 0
    object Color1: TSpeedButton
      Left = 0
      Top = 0
      Width = 23
      Height = 22
      GroupIndex = 1
      Caption = '1'
      OnClick = Color1Click
    end
    object Color2: TSpeedButton
      Left = 23
      Top = 0
      Width = 23
      Height = 22
      GroupIndex = 1
      Caption = '2'
      OnClick = Color2Click
    end
    object Color3: TSpeedButton
      Left = 46
      Top = 0
      Width = 23
      Height = 22
      GroupIndex = 1
      Caption = '3'
      OnClick = Color3Click
    end
    object Color4: TSpeedButton
      Left = 69
      Top = 0
      Width = 23
      Height = 22
      GroupIndex = 1
      Caption = '4'
      OnClick = Color4Click
    end
    object ScalingLabel: TLabel
      Left = 92
      Top = 0
      Width = 53
      Height = 22
      Alignment = taCenter
      AutoSize = False
      Caption = ' Scaling Factor'
      Color = clBtnFace
      ParentColor = False
      WordWrap = True
    end
    object ScalingSpin: TSpinEdit
      Left = 145
      Top = 0
      Width = 48
      Height = 22
      MaxValue = 40
      MinValue = 1
      TabOrder = 0
      Value = 1
      OnChange = ScalingSpinChange
    end
    object XLabel: TLabel
      Left = 193
      Top = 0
      Width = 64
      Height = 22
      AutoSize = False
      Caption = '  Num Tiles X'
    end
    object XSpin: TSpinEdit
      Left = 257
      Top = 0
      Width = 48
      Height = 22
      MaxValue = 20
      MinValue = 1
      TabOrder = 1
      Value = 1
      OnChange = XSpinChange
    end
    object YLabel: TLabel
      Left = 305
      Top = 0
      Width = 64
      Height = 22
      AutoSize = False
      Caption = '  Num Tiles Y'
    end
    object YSpin: TSpinEdit
      Left = 369
      Top = 0
      Width = 48
      Height = 22
      MaxValue = 19
      MinValue = 1
      TabOrder = 2
      Value = 1
      OnChange = YSpinChange
    end
  end
  object DrawGrid1: TDrawGrid
    Left = 8
    Top = 31
    Width = 273
    Height = 278
    ColCount = 8
    DefaultColWidth = 32
    DefaultRowHeight = 32
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    TabOrder = 1
    OnDrawCell = DrawGrid1DrawCell
    OnSelectCell = DrawGrid1SelectCell
  end
  object MainMenu1: TMainMenu
    Left = 480
    Top = 32
    object FileMenu: TMenuItem
      Caption = 'File'
      object Export: TMenuItem
        Caption = 'Export'
        OnClick = ExportClick
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
  end
end
