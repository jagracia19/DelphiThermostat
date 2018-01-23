unit TestThermostatStates;

interface

uses
  Thermostat.Classes,
  TestFramework, SysUtils, Generics.Collections;

type
  // Test methods for class TThermostatState

  TestStates = class(TTestCase)
  strict private
    FThermostat: TThermostat;
  private
    function GetSuperState: TThermostatState;
    function GetSubState: TThermostatState;
  protected
    property Thermostat: TThermostat read FThermostat;
    property SuperState: TThermostatState read GetSuperState;
    property SubState: TThermostatState read GetSubState;
  published
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestStates;
  end;

implementation

uses
  Thermostat.DisabledState,
  Thermostat.EnabledState,
  Thermostat.DisabledWaterState,
  Thermostat.DisabledLowWaterState,
  Thermostat.HeatingState,
  Thermostat.NotHeatingState;

{ TestStates }

function TestStates.GetSubState: TThermostatState;
begin
  if Assigned(Thermostat.State) then
    Result := Thermostat.State.State
  else Result := nil;
end;

function TestStates.GetSuperState: TThermostatState;
begin
  Result := Thermostat.State;
end;

procedure TestStates.SetUp;
begin
  FThermostat := TThermostat.Create;
end;

procedure TestStates.TearDown;
begin
  FThermostat.Free;
  FThermostat := nil;
end;

procedure TestStates.TestStates;
begin
  Assert(SuperState.ClassType = TDisabledThermostatState);
  Assert(SubState.ClassType = TDisabledWaterState);

  Thermostat.SampleTemperature := 10;
  Thermostat.TargetTemperature := 23;
  Thermostat.Run;
  Assert(SuperState.ClassType = TDisabledThermostatState);
  Assert(SubState.ClassType = TDisabledWaterState);

  Thermostat.Active := True;
  Thermostat.Run;
  Assert(SuperState.ClassType = TEnabledThermostatState);
  Assert(SubState.ClassType = THeatingState);
  Assert(Thermostat.Heater);

  Thermostat.SampleTemperature := 23;
  Thermostat.TargetTemperature := 23;
  Thermostat.Run;
  Assert(SuperState.ClassType = TEnabledThermostatState);
  Assert(SubState.ClassType = TNotHeatingState);
  Assert(not Thermostat.Heater);

  Thermostat.SampleTemperature := 22;
  Thermostat.TargetTemperature := 23;
  Thermostat.Run;
  Assert(SuperState.ClassType = TEnabledThermostatState);
  Assert(SubState.ClassType = THeatingState);
  Assert(Thermostat.Heater);

  Thermostat.Active := False;
  Thermostat.Run;
  Assert(SuperState.ClassType = TDisabledThermostatState);
  Assert(SubState.ClassType = TDisabledWaterState);
  Assert(not Thermostat.Heater);
end;

initialization
  RegisterTest(TestStates.Suite);

end.

