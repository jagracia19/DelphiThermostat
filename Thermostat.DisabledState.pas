unit Thermostat.DisabledState;

interface

uses
  Thermostat.Classes;

type
  TDisabledThermostatState = class(TThermostatState)
  public
    procedure Init; override;
    procedure Execute; override;
  end;

implementation

uses
  Thermostat.DisabledWaterState,
  Thermostat.DisabledLowWaterState,
  Thermostat.EnabledState;

{ TDisabledThermostatState }

procedure TDisabledThermostatState.Execute;
begin
  inherited;
  if Thermostat.Active and (Thermostat.WaterLevel = waterlevelOk) then
    ChangeState(TEnabledThermostatState)
  else State.Execute;
end;

procedure TDisabledThermostatState.Init;
var auxState: TThermostatState;
begin
  inherited;
  if Thermostat.WaterLevel = waterlevelOk then
    auxState := GetStateClass(TDisabledWaterState)
  else auxState := GetStateClass(TDisabledLowWaterState);
  State := auxState;
  auxState.Init;
end;

end.
