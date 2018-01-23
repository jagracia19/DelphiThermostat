unit Thermostat.Classes;

interface

uses
  SysUtils, Generics.Collections;

type
  TThermostatState = class;
  TThermostat = class;

  TWaterLevel = (waterlevelOk, waterlevelLow);

  TThermostatStateList = class(TObjectList<TThermostatState>)
  end;

  TThermostatStateClass = class of TThermostatState;

  TThermostatState = class
  private
    FParent: TThermostatState;
    FStateList: TThermostatStateList;
    FState: TThermostatState;
    FThermostat: TThermostat;
    procedure SetParent(const Value: TThermostatState);
    procedure SetThermostat(const Value: TThermostat);
    procedure SetState(const Value: TThermostatState);
  protected
    function FindStateClass(AClass: TThermostatStateClass): TThermostatState;
    function CreateState(AClass: TThermostatStateClass): TThermostatState;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure Finish; virtual;
    procedure Execute; virtual;
    procedure ChangeState(AClass: TThermostatStateClass);
    function GetStateClass(AClass: TThermostatStateClass): TThermostatState;
    property Parent: TThermostatState read FParent write SetParent;
    property State: TThermostatState read FState write SetState;
    property Thermostat: TThermostat read FThermostat write SetThermostat;
  end;

  TThermostat = class
  private
    FRootState: TThermostatState;
    FSampleTemperature: Integer;
    FTargetTemperature: Integer;
    FWaterLevel: TWaterLevel;
    FActive: Boolean;
    FHeater: Boolean;
    procedure InitStates;
    function GetState: TThermostatState;
    procedure SetSampleTemperature(const Value: Integer);
    procedure SetTargetTemperature(const Value: Integer);
    procedure SetWaterLevel(const Value: TWaterLevel);
    procedure SetActive(const Value: Boolean);
    procedure SetHeater(const Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Run;
    property State: TThermostatState read GetState;
    property SampleTemperature: Integer read FSampleTemperature
      write SetSampleTemperature;
    property TargetTemperature: Integer read FTargetTemperature
      write SetTargetTemperature;
    property WaterLevel: TWaterLevel read FWaterLevel write SetWaterLevel;
    property Active: Boolean read FActive write SetActive;
    property Heater: Boolean read FHeater write SetHeater;
  end;

implementation

uses
  Thermostat.DisabledState; // init state

{ TThermostatState }

procedure TThermostatState.ChangeState(AClass: TThermostatStateClass);
var auxState: TThermostatState;
begin
  Finish;
  if Assigned(Parent) then
  begin
    auxState := Parent.GetStateClass(AClass);
    Parent.State := auxState;
    auxState.Init;
  end;
end;

constructor TThermostatState.Create;
begin
  inherited;
  FStateList := TThermostatStateList.Create(True);
end;

function TThermostatState.CreateState(
  AClass: TThermostatStateClass): TThermostatState;
begin
  Result := AClass.Create;
  FStateList.Add(Result);
  Result.Parent := Self;
  Result.Thermostat := Thermostat;
end;

destructor TThermostatState.Destroy;
begin
  FreeAndNil(FStateList);
  inherited;
end;

procedure TThermostatState.Execute;
begin
  // do nothing
end;

function TThermostatState.FindStateClass(
  AClass: TThermostatStateClass): TThermostatState;
begin
  for Result in FStateList do
    if Result.ClassType = AClass then
      Exit;
  Result := nil;
end;

procedure TThermostatState.Finish;
begin
  // do nothing
end;

function TThermostatState.GetStateClass(
  AClass: TThermostatStateClass): TThermostatState;
begin
  Result := FindStateClass(AClass);
  if Result = nil then
    Result := CreateState(AClass);
end;

procedure TThermostatState.Init;
begin
  // do nothing
end;

procedure TThermostatState.SetParent(const Value: TThermostatState);
begin
  FParent := Value;
end;

procedure TThermostatState.SetState(const Value: TThermostatState);
begin
  FState := Value;
end;

procedure TThermostatState.SetThermostat(const Value: TThermostat);
begin
  FThermostat := Value;
end;

{ TThermostat }

constructor TThermostat.Create;
begin
  inherited;
  InitStates;
end;

destructor TThermostat.Destroy;
begin
  FreeAndNil(FRootState);
  inherited;
end;

function TThermostat.GetState: TThermostatState;
begin
  Result := FRootState.State;
end;

procedure TThermostat.InitStates;
var auxState: TThermostatState;
begin
  FRootState := TThermostatState.Create;
  FRootState.Thermostat := Self;

  auxState := FRootState.GetStateClass(TDisabledThermostatState);
  FRootState.State := auxState;
  auxState.Init;
end;

procedure TThermostat.Run;
begin
  State.Execute;
end;

procedure TThermostat.SetActive(const Value: Boolean);
begin
  FActive := Value;
end;

procedure TThermostat.SetHeater(const Value: Boolean);
begin
  FHeater := Value;
end;

procedure TThermostat.SetSampleTemperature(const Value: Integer);
begin
  FSampleTemperature := Value;
end;

procedure TThermostat.SetTargetTemperature(const Value: Integer);
begin
  FTargetTemperature := Value;
end;

procedure TThermostat.SetWaterLevel(const Value: TWaterLevel);
begin
  FWaterLevel := Value;
end;

end.
