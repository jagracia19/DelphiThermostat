unit Thermostat.NotHeatingState;

interface

uses
  Thermostat.Classes;

type
  TNotHeatingState = class(TThermostatState)
  public
    procedure Execute; override;
  end;

implementation

uses
  Thermostat.HeatingState;

{ TNotHeatingState }

procedure TNotHeatingState.Execute;
begin
  inherited;
  if Thermostat.SampleTemperature < Thermostat.TargetTemperature then
    ChangeState(THeatingState);
end;

end.
