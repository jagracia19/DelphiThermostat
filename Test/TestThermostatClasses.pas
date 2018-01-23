unit TestThermostatClasses;

interface

uses
  Thermostat.Classes,
  TestFramework, SysUtils, Generics.Collections;

type
  // Test methods for class TThermostatState

  TestTThermostatState = class(TTestCase)
  strict private
    FThermostatState: TThermostatState;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestChangeState;
  end;

  // Test methods for class TThermostat

//  TestTThermostat = class(TTestCase)
//  strict private
//    FThermostat: TThermostat;
//  public
//    procedure SetUp; override;
//    procedure TearDown; override;
//  end;

implementation

type
  TTestThermostatState = class(TThermostatState)
  end;

{ TestTThermostatState }

procedure TestTThermostatState.SetUp;
begin
  FThermostatState := TThermostatState.Create;
end;

procedure TestTThermostatState.TearDown;
begin
  FThermostatState.Free;
  FThermostatState := nil;
end;

procedure TestTThermostatState.TestChangeState;
var state     : TThermostatState;
    testState: TThermostatState;
begin
  state := FThermostatState.GetStateClass(TThermostatState);
  FThermostatState.State := state;

  Assert(state.ClassType = TThermostatState);
  Assert(state.Parent = FThermostatState);
  Assert(FThermostatState.State = state);

  state.ChangeState(TTestThermostatState);
  testState := FThermostatState.State;
  Assert(testState is TTestThermostatState);
  Assert(testState.ClassType = TTestThermostatState);
end;

{ TestTThermostat }

//procedure TestTThermostat.SetUp;
//begin
//  FThermostat := TThermostat.Create;
//end;
//
//procedure TestTThermostat.TearDown;
//begin
//  FThermostat.Free;
//  FThermostat := nil;
//end;

initialization
  RegisterTest(TestTThermostatState.Suite);
//  RegisterTest(TestTThermostat.Suite);

end.

