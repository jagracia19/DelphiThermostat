unit Thermostat.DisabledLowWaterState;

interface

uses
  Thermostat.Classes;

type
  TDisabledLowWaterState = class(TThermostatState)
  public
    procedure Execute; override;
  end;

implementation

uses
  Thermostat.DisabledWaterState;

{ TDisabledLowWaterState }

procedure TDisabledLowWaterState.Execute;
begin
  inherited;
  if Thermostat.WaterLevel = waterlevelOk then
    ChangeState(TDisabledWaterState);
end;

end.
