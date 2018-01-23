program Thermostat;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  Thermostat.Classes in 'Thermostat.Classes.pas',
  Thermostat.DisabledState in 'Thermostat.DisabledState.pas',
  Thermostat.EnabledState in 'Thermostat.EnabledState.pas',
  Thermostat.DisabledWaterState in 'Thermostat.DisabledWaterState.pas',
  Thermostat.DisabledLowWaterState in 'Thermostat.DisabledLowWaterState.pas',
  Thermostat.HeatingState in 'Thermostat.HeatingState.pas',
  Thermostat.NotHeatingState in 'Thermostat.NotHeatingState.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
