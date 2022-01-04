unit Mosco.ZMQ.Client;

interface

uses
  System.JSON, System.Generics.Collections,
  ZMQ.ClientProtocol,
  ZMQ.Shared,
  PascalZMQ,
  DW.OSTimer,
  Mosco.Types;

type
  TMoscoZMQClient = class;

  TActionHandler = procedure(const AJSON: TJSONValue) of object;

  TActionHandlers = TDictionary<string, TActionHandler>;

  TResponseInfo = record
    IsError: Boolean;
    Message: string;
    MethodName: string;
    constructor Create(const AMethodName: string; const AMessage: string; const AIsError: Boolean);
  end;

  TResponseEvent = procedure(Sender: TObject; const Info: TResponseInfo) of object;
  TReceivedIdentitiesEvent = procedure(Sender: TObject; const Identities: TIdentities) of object;
  TReceivedProfilesEvent = procedure(Sender: TObject; const Profiles: TProfiles) of object;
  TReceivedValuesEvent = procedure(Sender: TObject; const Values: TArray<string>) of object;
  TRequestTimeoutEvent = procedure(Sender: TObject; const Request: TJSONValue) of object;
  TSignedLibrariesEvent = procedure(Sender: TObject; const Libraries: TEmbeddedLibraries) of object;
  TPongEvent = procedure(Sender: TObject; const Info: TPingInfo) of object;
  TUploadedEvent = procedure(Sender: TObject) of object;

  TRequestItem = record
    Request: string;
    Timeout: Int64;
    TimedOut: Boolean;
    constructor Create(const ARequest: string; const ATimeout: Int64);
  end;

  TRequestItems = TDictionary<string, TRequestItem>;

  TMoscoZMQClient = class(TZMQClientProtocol)
  private
    FActionHandlers: TActionHandlers;
    FTimeoutDefault: Int64;
    FHost: string;
    FRequestItems: TRequestItems;
    FRequestTimer: TOSTimer;
    FOnPong: TPongEvent;
    FOnReceivedFrameworks: TReceivedValuesEvent;
    FOnReceivedIdentities: TReceivedIdentitiesEvent;
    FOnReceivedProfiles: TReceivedProfilesEvent;
    FOnReceivedSDKs: TReceivedValuesEvent;
    FOnRequestTimeout: TRequestTimeoutEvent;
    FOnResponse: TResponseEvent;
    FOnSignedLibraries: TSignedLibrariesEvent;
    FOnUploaded: TUploadedEvent;
    {$IF CompilerVersion < 35}
    function GetTickCount64: Int64;
    {$ENDIF}
    procedure RequestTimerIntervalHandler(Sender: TObject);
    procedure RequestTimeout(const ARequestItem: TRequestItem);
  protected
    procedure DoConnected; override;
    //procedure DoDisconnected; override;
    procedure DoPong(const AInfo: TPingInfo); virtual;
    procedure DoReceivedFrameworks(const AValues: TArray<string>); virtual;
    procedure DoReceivedIdentities(const AIdentities: TIdentities); virtual;
    procedure DoReceivedProfiles(const AProfiles: TProfiles); virtual;
    procedure DoReceivedSDKs(const AValues: TArray<string>); virtual;
    procedure DoUploaded; virtual;
    procedure DoRecv(const ACommand: TZMQCommand; var AMsg: PZMessage; var ASentFrom: PZFrame); override;
    procedure DoResponse(const AInfo: TResponseInfo); virtual;
    procedure DoSignedLibraries(const ALibraries: TEmbeddedLibraries); virtual;
    procedure HandleFrameworks(const AJSON: TJSONValue); virtual;
    procedure HandleGeneral(const AJSON: TJSONValue); virtual;
    procedure HandleIdentities(const AJSON: TJSONValue); virtual;
    procedure HandlePong(const AJSON: TJSONValue); virtual;
    procedure HandleProfiles(const AJSON: TJSONValue); virtual;
    procedure HandleSDKs(const AJSON: TJSONValue); virtual;
    procedure HandleSignLibraries(const AJSON: TJSONValue);
    procedure HandleUpload(const AJSON: TJSONValue);
  public
    constructor Create;
    destructor Destroy; override;
    procedure BuildIPA(const AProfile, AFileName, ABuildType: string);
    procedure UploadIPA(const AProfile, AFileName, AAppleID, AAppSpecificPassword: string);
    function CreateRequest(const AAction: string): TJSONObject;
    procedure FetchFrameworks(const ASDK: string);
    procedure FetchIdentities;
    procedure FetchProfiles;
    function Ping(const ATimeout: Int64 = 0): Boolean;
    function SendRequest(const ARequest: TJSONValue; const ATimeout: Int64 = 0): Boolean; overload;
    function SendRequest(const AAction: string; const ATimeout: Int64 = 0): Boolean; overload;
    procedure SignLibraries(const AIdentity: string; const ALibraries: TSelectedLibraries);
    procedure ShowDeployedApp(const AProfile: string; const AFileName: string);
    property ActionHandlers: TActionHandlers read FActionHandlers;
    property Host: string read FHost write FHost;
    property TimeoutDefault: Int64 read FTimeoutDefault write FTimeoutDefault;
    property OnResponse: TResponseEvent read FOnResponse write FOnResponse;
    property OnPong: TPongEvent read FOnPong write FOnPong;
    property OnReceivedFrameworks: TReceivedValuesEvent read FOnReceivedFrameworks write FOnReceivedFrameworks;
    property OnReceivedIdentities: TReceivedIdentitiesEvent read FOnReceivedIdentities write FOnReceivedIdentities;
    property OnReceivedProfiles: TReceivedProfilesEvent read FOnReceivedProfiles write FOnReceivedProfiles;
    property OnReceivedSDKs: TReceivedValuesEvent read FOnReceivedSDKs write FOnReceivedSDKs;
    property OnRequestTimeout: TRequestTimeoutEvent read FOnRequestTimeout write FOnRequestTimeout;
    property OnSignedLibraries: TSignedLibrariesEvent read FOnSignedLibraries write FOnSignedLibraries;
    property OnUploaded: TUploadedEvent read FOnUploaded write FOnUploaded;
  end;

implementation

uses
  DW.OSLog,
  System.SysUtils, System.IOUtils, System.Classes, System.Zip,
  DW.OSDevice, DW.Base64.Helpers, DW.IOUtils.Helpers, DW.Types.Helpers,
  Mosco.ZMQ.Consts;

function GetFileJSON(const AFileName: string; const AStream: TStream = nil): TJSONObject;
var
  LJSON: TJSONObject;
  LNeedsCompress: Boolean;
begin
  LJSON := TJSONObject.Create;
  LJSON.AddPair('filename', TPath.GetFileName(AFileName));
  LNeedsCompress := not TPath.GetExtension(AFileName).ToLower.Equals('.zip');
  if AStream = nil then
  begin
    if LNeedsCompress then
      LJSON.AddPair('content', TBase64Helper.CompressEncodeFromFile(AFileName))
    else
      LJSON.AddPair('content', TBase64Helper.EncodeFromFile(AFileName));
  end
  else
  begin
    if LNeedsCompress then
      LJSON.AddPair('content', TBase64Helper.CompressEncode(AStream))
    else
      LJSON.AddPair('content', TBase64Helper.Encode(AStream));
  end;
  Result := LJSON;
end;

function GetFolderJSON(const AFolder, AFileName: string): TJSONObject;
var
  LZipFileName, LTempPath, LTempFolder: string;
begin
  LTempPath := TPath.GetTempPath;
  // eg: [temp path]\opus
  LTempFolder := TPath.Combine(LTempPath, TPath.GetFileNameWithoutExtension(AFileName));
  // Copies to eg: [temp path]\opus\opus.framework
  TDirectoryHelper.Copy(AFolder, TPath.Combine(LTempFolder, TPath.GetFileName(AFolder)));
  // eg: [temp path]\opus\opus.zip
  LZipFileName := TPath.Combine(LTempFolder, TPath.ChangeExtension(TPath.GetFileName(AFileName), '.zip'));
  try
    // eg zips contents of: [temp path]\opus
    TZipFile.ZipDirectoryContents(LZipFileName, LTempFolder);
    Result := GetFileJSON(LZipFileName);
  finally
    TDirectoryHelper.Delete(LTempFolder);
  end;
end;

procedure ExtractBase64Zip(const ASource: string; const AFolder: string);
var
  LStream: TMemoryStream;
  LZipFileName: string;
begin
  LZipFileName := TPath.ChangeExtension(TPath.GetTempFileName, '.zip');
  LStream := TMemoryStream.Create;
  try
    TBase64Helper.Decode(ASource, LStream);
    LStream.SaveToFile(LZipFileName);
  finally
    LStream.Free;
  end;
  TZipFile.ExtractZipFile(LZipFileName, AFolder);
  TFile.Delete(LZipFileName);
end;

{ TResponseInfo }

constructor TResponseInfo.Create(const AMethodName: string; const AMessage: string; const AIsError: Boolean);
begin
  MethodName := AMethodName;
  Message := AMessage;
  IsError := AIsError;
end;

{ TRequestItem }

constructor TRequestItem.Create(const ARequest: string; const ATimeout: Int64);
begin
  Request := ARequest;
  Timeout := ATimeout;
end;

{ TMoscoZMQClient }

constructor TMoscoZMQClient.Create;
begin
  inherited;
  FRequestTimer := TOSTimer.Create;
  FRequestTimer.Interval := 250;
  FRequestTimer.OnInterval := RequestTimerIntervalHandler;
  FRequestItems := TRequestItems.Create;
  FActionHandlers := TActionHandlers.Create;
  FActionHandlers.Add(cZMQActionPong, HandlePong);
  FActionHandlers.Add(cZMQActionFetchIDs, HandleIdentities);
  FActionHandlers.Add(cZMQActionFetchProfiles, HandleProfiles);
  FActionHandlers.Add(cZMQActionFetchSDKs, HandleSDKs);
  FActionHandlers.Add(cZMQActionFetchFrameworks, HandleFrameworks);
  FActionHandlers.Add(cZMQActionSignLibraries, HandleSignLibraries);
  FActionHandlers.Add(cZMQActionUploadApp, HandleUpload);


end;

destructor TMoscoZMQClient.Destroy;
begin
  FRequestTimer.Free;
  FRequestItems.Free;
  FActionHandlers.Free;
  inherited;
end;

function TMoscoZMQClient.CreateRequest(const AAction: string): TJSONObject;
begin
  Result := TJSONObject.Create;
  Result.AddPair(cZMQJSONActionKey, AAction);
end;

procedure TMoscoZMQClient.DoConnected;
begin
  inherited;
  // DoConnectionState(True);
end;
    {
procedure TMoscoZMQClient.DoDisconnected;
begin
  // DoConnectionState(False);
  inherited;
end;   }

procedure TMoscoZMQClient.DoResponse(const AInfo: TResponseInfo);
begin
  if Assigned(FOnResponse) then
    FOnResponse(Self, AInfo);
end;

procedure TMoscoZMQClient.DoPong(const AInfo: TPingInfo);
begin
  if Assigned(FOnPong) then
    FOnPong(Self, AInfo);
end;

{$IF CompilerVersion < 35}
function TMoscoZMQClient.GetTickCount64: Int64;
begin
  Result := Int64(GetTickCount);
end;
{$ENDIF}

procedure TMoscoZMQClient.RequestTimerIntervalHandler(Sender: TObject);
var
  LRequestItem: TRequestItem;
  LKey: string;
begin
  for LKey in FRequestItems.Keys do
  begin
    LRequestItem := FRequestItems.Items[LKey];
    if not LRequestItem.TimedOut and (GetTickCount64 > LRequestItem.Timeout) then
    begin
      LRequestItem.TimedOut := True;
      FRequestItems.AddOrSetValue(LKey, LRequestItem);
      RequestTimeout(LRequestItem);
    end;
  end;
end;

procedure TMoscoZMQClient.DoRecv(const ACommand: TZMQCommand; var AMsg: PZMessage; var ASentFrom: PZFrame);
var
  LService, LAction, LGUID: string;
  LJSON: TJSONValue;
  LHandler: TActionHandler;
  LRequestItem: TRequestItem;
  LHandleRequest: Boolean;
begin
  LHandleRequest := True;
  LService := AMsg.PopString; // Should be blank
  LJSON := TJSONObject.ParseJSONValue(AMsg.PopString);
  if LJSON <> nil then
  try
    if LJSON.TryGetValue(cZMQJSONGUIDKey, LGUID) then
    begin
      if FRequestItems.TryGetValue(LGUID, LRequestItem) then
      begin
        LHandleRequest := not LRequestItem.TimedOut;
        FRequestItems.Remove(LGUID);
      end;
    end;
    if LHandleRequest then
    begin
      LJSON.TryGetValue(cZMQJSONActionKey, LAction);
      if not LAction.IsEmpty then
      begin
        if FActionHandlers.TryGetValue(LAction, LHandler) then
          LHandler(LJSON);
        HandleGeneral(LJSON);
      end;
      // else missing action
    end;
  finally
    LJSON.Free;
  end;
  // else it aint JSON
end;

procedure TMoscoZMQClient.DoSignedLibraries(const ALibraries: TEmbeddedLibraries);
begin
  TOSLog.d('TMoscoZMQClient.DoSignedLibraries');
  if Assigned(FOnSignedLibraries) then
    FOnSignedLibraries(Self, ALibraries);
end;

procedure TMoscoZMQClient.DoUploaded;
begin
  TOSLog.d('TMoscoZMQClient.DoUploaded');
  if Assigned(FOnUploaded) then
    FOnUploaded(Self);
end;

procedure TMoscoZMQClient.HandleFrameworks(const AJSON: TJSONValue);
var
  LValues: TArray<string>;
  LValuesJSON: TJSONValue;
begin
  if AJSON.TryGetValue(cZMQJSONValuesKey, LValuesJSON) then
  begin
    LValues.FromJsonValue(LValuesJSON);
    DoReceivedFrameworks(LValues);
  end;
end;

procedure TMoscoZMQClient.HandleGeneral(const AJSON: TJSONValue);
var
  LCode: Integer;
  LDescription, LMessage: string;
begin
  if not AJSON.TryGetValue(cZMQJSONCodeKey, LCode) then
    LCode := 0;
  AJSON.TryGetValue(cZMQJSONMessageKey, LMessage);
  AJSON.TryGetValue(cZMQJSONDescriptionKey, LDescription);
  DoResponse(TResponseInfo.Create(LDescription, LMessage, LCode <> 0));
end;

procedure TMoscoZMQClient.HandleIdentities(const AJSON: TJSONValue);
var
  LIdentities: TIdentities;
  LValues: TJSONValue;
begin
  if AJSON.TryGetValue(cZMQJSONValuesKey, LValues) then
  begin
    LIdentities.FromJsonValue(LValues);
    DoReceivedIdentities(LIdentities);
  end;
end;

procedure TMoscoZMQClient.DoReceivedFrameworks(const AValues: TArray<string>);
begin
  if Assigned(FOnReceivedFrameworks) then
    FOnReceivedFrameworks(Self, AValues);
end;

procedure TMoscoZMQClient.DoReceivedIdentities(const AIdentities: TIdentities);
begin
  if Assigned(FOnReceivedIdentities) then
    FOnReceivedIdentities(Self, AIdentities);
end;

procedure TMoscoZMQClient.HandlePong(const AJSON: TJSONValue);
var
  LInfo: TPingInfo;
begin
  AJSON.TryGetValue('version', LInfo.Version);
  DoPong(LInfo);
end;

procedure TMoscoZMQClient.HandleProfiles(const AJSON: TJSONValue);
var
  LProfiles: TProfiles;
  LValues: TJSONValue;
begin
  if AJSON.TryGetValue(cZMQJSONValuesKey, LValues) then
  begin
    LProfiles.FromJsonValue(LValues);
    DoReceivedProfiles(LProfiles);
  end;
end;

procedure TMoscoZMQClient.HandleSDKs(const AJSON: TJSONValue);
var
  LValues: TArray<string>;
  LValuesJSON: TJSONValue;
begin
  if AJSON.TryGetValue(cZMQJSONValuesKey, LValuesJSON) then
  begin
    LValues.FromJsonValue(LValuesJSON);
    DoReceivedSDKs(LValues);
  end;
end;

procedure TMoscoZMQClient.HandleSignLibraries(const AJSON: TJSONValue);
var
  LLibraries: TEmbeddedLibraries;
  LLibrary: TEmbeddedLibrary;
  LItemsJSON: TJSONArray;
  LZipFileName: string;
begin
  TOSLog.d('TMoscoZMQClient.HandleSignLibraries');
  if AJSON.TryGetValue('items', LItemsJSON) then
  begin
    LZipFileName := TPath.Combine(TPath.GetTempPath, LLibrary.FileName);
    LLibraries.FromJsonValue(LItemsJSON);
    for LLibrary in LLibraries do
    begin
      if LLibrary.Code = 0 then
      begin
        ExtractBase64Zip(LLibrary.Content, LLibrary.DestinationPath);
        TOSLog.d('> Extracted '+ LLibrary.FileName + ' to ' + LLibrary.DestinationPath);
      end;
    end;
  end;
  DoSignedLibraries(LLibraries);
end;

procedure TMoscoZMQClient.HandleUpload(const AJSON: TJSONValue);
var
  LValues: TArray<string>;
  LValuesJSON: TJSONValue;
begin
  if AJSON.TryGetValue(cZMQJSONValuesKey, LValuesJSON) then
  begin
    LValues.FromJsonValue(LValuesJSON);
    DoUploaded;
  end;
end;



function TMoscoZMQClient.Ping(const ATimeout: Int64 = 0): Boolean;
begin
  Result := SendRequest(cZMQActionPing, ATimeout);
end;

procedure TMoscoZMQClient.DoReceivedProfiles(const AProfiles: TProfiles);
begin
  if Assigned(FOnReceivedProfiles) then
    FOnReceivedProfiles(Self, AProfiles);
end;

procedure TMoscoZMQClient.DoReceivedSDKs(const AValues: TArray<string>);
begin
  if Assigned(FOnReceivedSDKs) then
    FOnReceivedSDKs(Self, AValues);
end;

procedure TMoscoZMQClient.RequestTimeout(const ARequestItem: TRequestItem);
var
  LJSONValue: TJSONValue;
begin
  LJSONValue := TJSONObject.ParseJSONValue(ARequestItem.Request);
  if (LJSONValue <> nil) and Assigned(FOnRequestTimeout) then
  try
    FOnRequestTimeout(Self, LJSONValue);
  finally
    LJSONValue.Free;
  end;
end;

function TMoscoZMQClient.SendRequest(const ARequest: TJSONValue; const ATimeout: Int64 = 0): Boolean;
var
  LZMsg: PZMessage;
  LConnected: Boolean;
  LJSON, LGUID: string;
  LTimeout: UInt64;
begin
  Result := False;
  LGUID := TGUID.NewGuid.ToString;
  if ARequest is TJSONObject then
    TJSONObject(ARequest).AddPair(cZMQJSONGUIDKey, LGUID);
  if State <> TZMQState.Connected then
    LConnected := Connect(FHost)
  else
    LConnected := True;
  if LConnected then
  begin
    LJSON := ARequest.ToJSON;
    if ATimeout > -1 then
    begin
      LTimeout := ATimeout;
      if LTimeout = 0 then
        LTimeout := FTimeoutDefault;
      FRequestItems.Add(LGUID, TRequestItem.Create(LJSON, GetTickCount64 + LTimeout));
      FRequestTimer.Enabled := True;
    end;
    LZMsg := TZMessage.Create;
    try
      LZMsg.PushString(LJSON);
      {$R-}
      Send('', LZMsg);
      {$R+}
    finally
      LZMsg.Free;
    end;
    Result := True;
  end
  else
    DoResponse(TResponseInfo.Create('TMoscoZMQClient.SendRequest', 'Could not connect to Mosco', True));
end;

function TMoscoZMQClient.SendRequest(const AAction: string; const ATimeout: Int64 = 0): Boolean;
var
  LRequest: TJSONObject;
begin
  LRequest := CreateRequest(AAction);
  try
    Result := SendRequest(LRequest, ATimeout);
  finally
    LRequest.Free;
  end;
end;

procedure TMoscoZMQClient.ShowDeployedApp(const AProfile, AFileName: string);
var
  LRequest: TJSONObject;
begin
  LRequest := CreateRequest(cZMQActionShowDeployedApp);
  try
    LRequest.AddPair('user', TOSDevice.GetUsername);
    LRequest.AddPair('profile', AProfile);
    LRequest.AddPair('filename', AFileName);
    SendRequest(LRequest, -1);
  finally
    LRequest.Free;
  end;
end;

procedure TMoscoZMQClient.BuildIPA(const AProfile, AFileName, ABuildType: string);
var
  LRequest: TJSONObject;
begin
  LRequest := CreateRequest(cZMQActionBuildIPA);
  try
    LRequest.AddPair('user', TOSDevice.GetUsername);
    LRequest.AddPair('profile', AProfile);
    LRequest.AddPair('filename', AFileName);
    LRequest.AddPair('buildtype', ABuildType);
    SendRequest(LRequest, 30000);
  finally
    LRequest.Free;
  end;
end;

procedure TMoscoZMQClient.FetchFrameworks(const ASDK: string);
var
  LRequest: TJSONObject;
begin
  LRequest := CreateRequest(cZMQActionFetchFrameworks);
  try
    LRequest.AddPair('sdk', ASDK);
    SendRequest(LRequest);
  finally
    LRequest.Free;
  end;
end;

procedure TMoscoZMQClient.FetchIdentities;
var
  LRequest: TJSONObject;
begin
  LRequest := CreateRequest(cZMQActionFetchIDs);
  try
    SendRequest(LRequest);
  finally
    LRequest.Free;
  end;
end;

procedure TMoscoZMQClient.FetchProfiles;
var
  LRequest: TJSONObject;
begin
  LRequest := CreateRequest(cZMQActionFetchProfiles);
  try
    SendRequest(LRequest);
  finally
    LRequest.Free;
  end;
end;

procedure TMoscoZMQClient.SignLibraries(const AIdentity: string; const ALibraries: TSelectedLibraries);
var
  LValue, LFileName, LFolder: string;
  LRequest: TJSONObject;
  LFileJSON: TJSONObject;
  LItemsJSON: TJSONArray;
  LLibrary: TSelectedLibrary;
begin
  LItemsJSON := nil;
  for LLibrary in ALibraries do
  begin
    LFileJSON := nil;
    LValue := LLibrary.FileName;
    LFileName := TPath.GetFileName(LValue);
    LFolder := TPath.GetDirectoryName(LValue);
    if LFolder.EndsWith('.framework', True) then
      // Zip the framework folder
      LFileJSON := GetFolderJSON(LFolder, LFileName)
    else ; // Unsupported as yet
    if LFileJSON <> nil then
    begin
      LFileJSON.AddPair('destpath', LLibrary.DestinationPath);
      if LItemsJSON = nil then
        LItemsJSON := TJSONArray.Create;
      LItemsJSON.AddElement(LFileJSON);
    end;
  end;
  if LItemsJSON <> nil then
  begin
    LRequest := CreateRequest(cZMQActionSignLibraries);
    try
      LRequest.AddPair('identity', AIdentity);
      LRequest.AddPair('items', LItemsJSON);
      SendRequest(LRequest);
    finally
      LRequest.Free;
    end;
  end;
  // else nothing to sign!!
end;

procedure TMoscoZMQClient.UploadIPA(const AProfile, AFileName, AAppleID, AAppSpecificPassword: string);
var
  LRequest: TJSONObject;
begin
  LRequest := CreateRequest(cZMQActionUploadApp);
  try
    LRequest.AddPair('user', TOSDevice.GetUsername);
    LRequest.AddPair('profile', AProfile);
    LRequest.AddPair('filename', AFileName);
    LRequest.AddPair('appleid', AAppleID);
    LRequest.AddPair('password', AAppSpecificPassword);
    SendRequest(LRequest, 30000);
  finally
    LRequest.Free;
  end;
end;

end.
