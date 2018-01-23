unit Thermostat.DisabledWaterState;

interface

uses
  Thermostat.Classes;

type
  TDisabledWaterState = class(TThermostatState)
  public
    procedure Execute; override;
  end;


implementation

uses
  Thermostat.DisabledLowWaterState;

{ TDisabledWaterState }

procedure TDisabledWaterState.Execute;
begin
  inherited;
  if Thermostat.WaterLevel = waterlevelLow then
    ChangeState(TDisabledLowWaterState);
end;

end.
