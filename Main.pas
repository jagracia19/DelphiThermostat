unit Main;

interface

uses
  Thermostat.Classes,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
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
    FThermostat: TThermostat;
    procedure UpdateSampleTemperature;
    procedure EnableControls;
    procedure TrackBarFromTemp(TrackBar: TTrackBar; Temp: Integer);
    function TempFromTrackBar(TrackBar: TTrackBar): Integer;
    //procedure SetControlWaterLevel(Value: TWaterLevel);
    function GetControlWaterLevel: TWaterLevel;
    procedure SetCaptionButtonStartStop;
    procedure SetLabelHeater;
  public
    property Thermostat: TThermostat read FThermostat;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

{ TFormMain }

procedure TFormMain.ButtonStartStopClick(Sender: TObject);
begin
  Thermostat.Active := not Thermostat.Active;
end;

procedure TFormMain.EnableControls;
begin
  ButtonStartStop.Enabled := (Thermostat.WaterLevel = waterlevelOk);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FThermostat := TThermostat.Create;

  Thermostat.TargetTemperature := 40 + Random(40);
  Thermostat.SampleTemperature := Random(100);
  TrackBarFromTemp(TrackBarSampleTemp, Thermostat.SampleTemperature);
  TrackBarFromTemp(TrackBarTargetTemp, Thermostat.TargetTemperature);

  EnableControls;
end;

function TFormMain.GetControlWaterLevel: TWaterLevel;
begin
  Result := TWaterLevel(RadioGroupWaterLevel.ItemIndex);
end;

procedure TFormMain.RadioGroupWaterLevelClick(Sender: TObject);
begin
  Thermostat.WaterLevel := GetControlWaterLevel;
end;

procedure TFormMain.SetCaptionButtonStartStop;
begin
  if Thermostat.Active then
    ButtonStartStop.Caption := 'Stop'
  else ButtonStartStop.Caption := 'Start';
end;

//procedure TFormMain.SetControlWaterLevel(Value: TWaterLevel);
//begin
//  RadioGroupWaterLevel.ItemIndex := Ord(Value);
//end;

procedure TFormMain.SetLabelHeater;
begin
  if Thermostat.Heater then
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

function TFormMain.TempFromTrackBar(TrackBar: TTrackBar): Integer;
begin
  Result := TrackBar.Max - TrackBar.Position;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
begin
  UpdateSampleTemperature;
  Thermostat.Run;
  EnableControls;
  SetCaptionButtonStartStop;
  SetLabelHeater;
end;

procedure TFormMain.TrackBarFromTemp(TrackBar: TTrackBar; Temp: Integer);
begin
  TrackBar.Position := TrackBar.Max - Temp;
end;

procedure TFormMain.TrackBarTempChange(Sender: TObject);
begin
  if Sender = TrackBarSampleTemp then
     Thermostat.SampleTemperature := TempFromTrackBar(TTrackBar(Sender))
  else if Sender = TrackBarTargetTemp then
    Thermostat.TargetTemperature := TempFromTrackBar(TTrackBar(Sender));
end;

procedure TFormMain.UpdateSampleTemperature;
begin
  if Thermostat.Heater then
    Thermostat.SampleTemperature := Thermostat.SampleTemperature + 1
  else Thermostat.SampleTemperature := Thermostat.SampleTemperature - 1;
  TrackBarFromTemp(TrackBarSampleTemp, Thermostat.SampleTemperature);
end;

end.
