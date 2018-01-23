program ThermostatTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  Thermostat.Classes in '..\Thermostat.Classes.pas',
  Thermostat.DisabledState in '..\Thermostat.DisabledState.pas',
  Thermostat.EnabledState in '..\Thermostat.EnabledState.pas',
  Thermostat.DisabledWaterState in '..\Thermostat.DisabledWaterState.pas',
  Thermostat.DisabledLowWaterState in '..\Thermostat.DisabledLowWaterState.pas',
  Thermostat.HeatingState in '..\Thermostat.HeatingState.pas',
  Thermostat.NotHeatingState in '..\Thermostat.NotHeatingState.pas',
  TestThermostatClasses in 'TestThermostatClasses.pas',
  TestThermostatStates in 'TestThermostatStates.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    with TextTestRunner.RunRegisteredTests do
      Free
  else
    GUITestRunner.RunRegisteredTests;
end.

