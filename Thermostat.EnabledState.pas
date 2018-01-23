unit Thermostat.EnabledState;

interface

uses
  Thermostat.Classes;

type
  TEnabledThermostatState = class(TThermostatState)
  public
    procedure Init; override;
    procedure Finish; override;
    procedure Execute; override;
  end;

implementation

uses
  Thermostat.HeatingState,
  Thermostat.NotHeatingState,
  Thermostat.DisabledState;

{ TEnabledThermostatState }

procedure TEnabledThermostatState.Execute;
begin
  inherited;
  if not Thermostat.Active or (Thermostat.WaterLevel = waterlevelLow) then
    ChangeState(TDisabledThermostatState)
  else State.Execute;
end;

procedure TEnabledThermostatState.Finish;
begin
  inherited;
  if State is THeatingState then
    State.ChangeState(TNotHeatingState); // disable Heater
end;

procedure TEnabledThermostatState.Init;
var auxState: TThermostatState;
begin
  inherited;
  if Thermostat.SampleTemperature < Thermostat.TargetTemperature then
    auxState := GetStateClass(THeatingState)
  else auxState := GetStateClass(TNotHeatingState);
  State := auxState;
  auxState.Init;
end;

end.
