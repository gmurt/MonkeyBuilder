unit untAndroidHelper;

interface

uses Classes, Spring.Collections.Lists, MonkeyBuilder_Intf;

type
  IAndroidHelper = interface
    ['{E6549488-EBB2-41E0-A4C2-CCE416E6947B}']
    function ValidateKeystore(AStore, AStorePass, AKey, AKeyPass: string): Boolean;
    function GetConnectedDevices: TDeviceList;
    procedure InstallApk(ADevID, AApkFile, AAppID: string);
  end;

  function CreateAndroidHelper: IAndroidHelper;

implementation

uses System.IOUtils, JclFileUtils, MonkeyBuilder.Project,
  JclSysUtils, SysUtils;

type
  TAndroidHelper = class(TInterfacedObject, IAndroidHelper)
  private
    FCmdOutput: TStrings;
    procedure OnKeyToolOutput(const AText: string);
  protected
    function ValidateKeystore(AStore, AStorePass, AKey, AKeyPass: string): Boolean;
    function GetConnectedDevices: TDeviceList;
    procedure InstallApk(ADevID, AApkFile, AAppID: string);
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

function CreateAndroidHelper: IAndroidHelper;
begin
  Result := TAndroidHelper.Create;
end;

constructor TAndroidHelper.Create;
begin
  inherited Create;
  FCmdOutput := TStringList.Create;
end;



destructor TAndroidHelper.Destroy;
begin
  FCmdOutput.Free;
  inherited;
end;

function TAndroidHelper.GetConnectedDevices: TDeviceList;
var
  AAdb: string;
  AStr: string;
  AStrings: TStrings;
  ADev: TDevice;
begin
  Result := [];
  try
    AStrings := TStringList.Create;
    try
      FCmdOutput.Clear;
      AAdb := GetSdkValueFromRegistry(mbAndroid64, 'SDKAdbPath');
      Execute('"'+AAdb+'" devices -l', OnKeyToolOutput, True, nil, TJclProcessPriority.ppNormal);
      for AStr in FCmdOutput do
      begin

        AStrings.CommaText := StringReplace(AStr, ':', '=', [rfReplaceAll]);
        if AStrings.IndexOfName('model') > -1 then
        begin
          ADev.DevID := AStrings[0];
          ADev.DevName := StringReplace(AStrings.Values['model'], '_', ' ', [rfReplaceAll]);
          SetLength(Result, Length(Result)+1);
          Result[Length(Result)-1] := ADev;
        end;
      end;
    finally
      AStrings.Free;
    end;
  except
    //
  end;
end;

procedure TAndroidHelper.InstallApk(ADevID, AApkFile, AAppID: string);
var
  AAdb: string;
begin
  AAdb := GetSdkValueFromRegistry(mbAndroid64, 'SDKAdbPath');
  Execute('"'+AAdb+'" install "'+AApkFile+'"', OnKeyToolOutput, True, nil, TJclProcessPriority.ppNormal);
  Execute('"'+AAdb+'" shell monkey -p '+AAppID+' 1', OnKeyToolOutput, True, nil, TJclProcessPriority.ppNormal);
end;

procedure TAndroidHelper.OnKeyToolOutput(const AText: string);
begin
  FCmdOutput.Add(AText);
end;

function TAndroidHelper.ValidateKeystore(AStore, AStorePass, AKey, AKeyPass: string): Boolean;
var
  AKeyTool: string;
  ATmpStore: string;
begin
  FCmdOutput.Clear;
  ATmpStore := TPath.GetTempFileName;
  try
    FileCopy(AStore, ATmpStore, True);

    AKeyTool := GetSdkValueFromRegistry(mbAndroid64, 'JDKKeyToolPath');
    Execute('"'+AKeyTool+'" -keyclone -alias "'+AKey+'" -dest "'+AKey+'_temp" -keypass '+AKeyPass+' -new '+AKeyPass+' -keystore "'+ATmpStore+'" -storepass '+AStorePass, OnKeyToolOutput, True, nil, TJclProcessPriority.ppNormal);
    Result := Trim(FCmdOutput[0]) = '';
  finally
    if FileExists(ATmpStore) then
      DeleteFile(ATmpStore);
  end;
end;

end.
