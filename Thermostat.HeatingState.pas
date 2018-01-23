unit Thermostat.HeatingState;

interface

uses
  Thermostat.Classes;

type
  THeatingState = class(TThermostatState)
  public
    procedure Init; override;
    procedure Finish; override;
    procedure Execute; override;
  end;

implementation

uses
  Thermostat.NotHeatingState;

{ THeatingState }

procedure THeatingState.Execute;
begin
  inherited;
  if Thermostat.SampleTemperature >= Thermostat.TargetTemperature then
    ChangeState(TNotHeatingState);
end;

procedure THeatingState.Finish;
begin
  inherited;
  Thermostat.Heater := False;
end;

procedure THeatingState.Init;
begin
  inherited;
  Thermostat.Heater := True;
end;

end.
