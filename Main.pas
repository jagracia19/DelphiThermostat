unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TWaterLevel = (waterlevelOk, waterlevelLow);

  TThermostatState = (thermostateOff, thermostateOn, thermostateDisabledWater,
                      thermostateDisabledLowWater);

  TFormMain = class(TForm)
    TrackBarSampleTemp: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    TrackBarTargetTemp: TTrackBar;
    LabelHeater: TLabel;
    ButtonStartStop: TButton;
    RadioGroupWaterLevel: TRadioGroup;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure TrackBarTempChange(Sender: TObject);
    procedure RadioGroupWaterLevelClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonStartStopClick(Sender: TObject);
  private
    FSampleTemperature: Integer;
    FTargetTemperature: Integer;
    FHeater: Boolean;
    FWaterLevel: TWaterLevel;
    FThermostatEnabled: Boolean;
    procedure UpdateSampleTemperature;
    procedure EnableControls;
    procedure SetButtonStarStopCaption;
    procedure TrackBarFromTemp(TrackBar: TTrackBar; Temp: Integer);
    function TempFromTrackBar(TrackBar: TTrackBar): Integer;
    procedure SetControlWaterLevel(Value: TWaterLevel);
    function GetControlWaterLevel: TWaterLevel;
    procedure SetLabelHeater;
    procedure SetSampleTemperature(const Value: Integer);
    procedure SetTargetTemperature(const Value: Integer);
    procedure SetHeater(const Value: Boolean);
    procedure SetWaterLevel(const Value: TWaterLevel);
    procedure SetThermostatEnabled(const Value: Boolean);
  private
    FThermostatState: TThermostatState;
    procedure CheckState;
    procedure CheckOffState;
    procedure CheckOnState;
    procedure CheckDisabledWater;
    procedure CheckDisabledLowWater;
    procedure SetOffState;
    procedure SetOnState;
    procedure SetDisabledWater;
    procedure SetDisabledLowWater;
    procedure SetThermostatState(const Value: TThermostatState);
  public
    property SampleTemperature: Integer read FSampleTemperature
      write SetSampleTemperature;
    property TargetTemperature: Integer read FTargetTemperature
      write SetTargetTemperature;
    property Heater: Boolean read FHeater write SetHeater;
    property WaterLevel: TWaterLevel read FWaterLevel write SetWaterLevel;
    property ThermostatEnabled: Boolean read FThermostatEnabled
      write SetThermostatEnabled;
    property ThermostatState: TThermostatState read FThermostatState
      write SetThermostatState;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

{ TFormMain }

procedure TFormMain.ButtonStartStopClick(Sender: TObject);
begin
  ThermostatEnabled := not ThermostatEnabled;
end;

procedure TFormMain.CheckDisabledLowWater;
begin
  if WaterLevel = waterlevelOk then
  begin
    if ThermostatEnabled then
    begin
      if SampleTemperature < TargetTemperature then
        ThermostatState := thermostateOn
      else ThermostatState := thermostateOff;
    end
    else ThermostatState := thermostateDisabledWater;
  end;
end;

procedure TFormMain.CheckDisabledWater;
begin
  if WaterLevel = waterlevelOk then
  begin
    if ThermostatEnabled then
    begin
      if SampleTemperature < TargetTemperature then
        ThermostatState := thermostateOn
      else ThermostatState := thermostateOff;
    end
  end
  else ThermostatState := thermostateDisabledLowWater;
end;

procedure TFormMain.CheckOffState;
begin
  if ThermostatEnabled and (WaterLevel = waterlevelOk) then
  begin
    if SampleTemperature < TargetTemperature then
      ThermostatState := thermostateOn;
  end
  else
  begin
    if not ThermostatEnabled then
    begin
      if WaterLevel = waterlevelOk then
        ThermostatState := thermostateDisabledWater
      else ThermostatState := thermostateDisabledLowWater;
    end;
  end;
end;

procedure TFormMain.CheckOnState;
begin
  if ThermostatEnabled and (WaterLevel = waterlevelOk) then
  begin
    if SampleTemperature >= TargetTemperature then
      ThermostatState := thermostateOff;
  end
  else
  begin
    ThermostatEnabled := False;
    if WaterLevel = waterlevelOk then
      ThermostatState := thermostateDisabledWater
    else ThermostatState := thermostateDisabledLowWater;
  end;
end;

procedure TFormMain.CheckState;
begin
  case ThermostatState of
    thermostateOff: CheckOffState;
    thermostateOn: CheckOnState;
    thermostateDisabledWater: CheckDisabledWater;
    thermostateDisabledLowWater: CheckDisabledLowWater;
  end;
end;

procedure TFormMain.EnableControls;
begin
  ButtonStartStop.Enabled := (WaterLevel = waterlevelOk);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  TargetTemperature := 40 + Random(40);
  SampleTemperature := Random(100);
  Heater := False;
  WaterLevel := waterlevelOk;
  ThermostatEnabled := False;
  EnableControls;
end;

function TFormMain.GetControlWaterLevel: TWaterLevel;
begin
  Result := TWaterLevel(RadioGroupWaterLevel.ItemIndex);
end;

procedure TFormMain.RadioGroupWaterLevelClick(Sender: TObject);
begin
  WaterLevel := GetControlWaterLevel;
end;

procedure TFormMain.SetButtonStarStopCaption;
begin
  if ThermostatEnabled then
    ButtonStartStop.Caption := 'Stop'
  else ButtonStartStop.Caption := 'Start';
end;

procedure TFormMain.SetControlWaterLevel(Value: TWaterLevel);
begin
  RadioGroupWaterLevel.ItemIndex := Ord(Value);
end;

procedure TFormMain.SetDisabledLowWater;
begin
  Heater := False;

end;

procedure TFormMain.SetDisabledWater;
begin
  Heater := False;

end;

procedure TFormMain.SetHeater(const Value: Boolean);
begin
  if FHeater <> Value then
  begin
    FHeater := Value;
    SetLabelHeater;
  end;
end;

procedure TFormMain.SetLabelHeater;
begin
  if Heater then
  begin
    LabelHeater.Caption := 'Heater: ON';
    LabelHeater.Font.Color := clGreen;
  end
  else
  begin
    LabelHeater.Caption := 'Heater: OFF';
    LabelHeater.Font.Color := clWindowText;
  end;
end;

procedure TFormMain.SetOffState;
begin
  Heater := False;
end;

procedure TFormMain.SetOnState;
begin
  Heater := True;
end;

procedure TFormMain.SetSampleTemperature(const Value: Integer);
begin
  if FSampleTemperature <> Value then
  begin
    FSampleTemperature := Value;
    TrackBarFromTemp(TrackBarSampleTemp, FSampleTemperature);
  end;
end;

procedure TFormMain.SetTargetTemperature(const Value: Integer);
begin
  if FTargetTemperature <> Value then
  begin
    FTargetTemperature := Value;
    TrackBarFromTemp(TrackBarTargetTemp, FTargetTemperature);
  end;
end;

procedure TFormMain.SetThermostatEnabled(const Value: Boolean);
begin
  if FThermostatEnabled <> Value then
  begin
    FThermostatEnabled := Value;
    SetButtonStarStopCaption;
  end;
end;

procedure TFormMain.SetThermostatState(const Value: TThermostatState);
begin
  if FThermostatState <> Value then
  begin
    FThermostatState := Value;
    case ThermostatState of
      thermostateOff: SetOffState;
      thermostateOn: SetOnState;
      thermostateDisabledWater: SetDisabledWater;
      thermostateDisabledLowWater: SetDisabledLowWater;
    end;
  end;
end;

procedure TFormMain.SetWaterLevel(const Value: TWaterLevel);
begin
  if FWaterLevel <> Value then
  begin
    FWaterLevel := Value;
    SetControlWaterLevel(FWaterLevel);
  end;
end;

function TFormMain.TempFromTrackBar(TrackBar: TTrackBar): Integer;
begin
  Result := TrackBar.Max - TrackBar.Position;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  UpdateSampleTemperature;
  CheckState;
  EnableControls;
end;

procedure TFormMain.TrackBarFromTemp(TrackBar: TTrackBar; Temp: Integer);
begin
  TrackBar.Position := TrackBar.Max - Temp;
end;

procedure TFormMain.TrackBarTempChange(Sender: TObject);
begin
  if Sender = TrackBarSampleTemp then
     SampleTemperature := TempFromTrackBar(TTrackBar(Sender))
  else if Sender = TrackBarTargetTemp then
    TargetTemperature := TempFromTrackBar(TTrackBar(Sender));
end;

procedure TFormMain.UpdateSampleTemperature;
begin
  if Heater then
    SampleTemperature := SampleTemperature + 1
  else SampleTemperature := SampleTemperature - 1;
end;

end.
