object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Thermostat'
  ClientHeight = 356
  ClientWidth = 300
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
  object Label1: TLabel
    Left = 24
    Top = 188
    Width = 99
    Height = 13
    Caption = 'Sample Temperature'
  end
  object Label2: TLabel
    Left = 184
    Top = 188
    Width = 97
    Height = 13
    Caption = 'Target Temperature'
  end
  object LabelHeater: TLabel
    Left = 24
    Top = 224
    Width = 60
    Height = 13
    Caption = 'Heater: OFF'
  end
  object TrackBarSampleTemp: TTrackBar
    Left = 56
    Top = 32
    Width = 45
    Height = 150
    Max = 100
    Orientation = trVertical
    PageSize = 10
    Frequency = 10
    TabOrder = 0
    OnChange = TrackBarTempChange
  end
  object TrackBarTargetTemp: TTrackBar
    Left = 216
    Top = 32
    Width = 45
    Height = 150
    Max = 100
    Orientation = trVertical
    PageSize = 10
    Frequency = 10
    TabOrder = 1
  end
  object ButtonStartStop: TButton
    Left = 186
    Top = 219
    Width = 75
    Height = 25
    Caption = 'Start'
    TabOrder = 2
    OnClick = ButtonStartStopClick
  end
  object RadioGroupWaterLevel: TRadioGroup
    Left = 24
    Top = 264
    Width = 99
    Height = 73
    Caption = 'Water Level'
    ItemIndex = 0
    Items.Strings = (
      'Ok'
      'Low')
    TabOrder = 3
    OnClick = RadioGroupWaterLevelClick
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 208
    Top = 288
  end
end
