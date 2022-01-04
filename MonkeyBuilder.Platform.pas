unit MonkeyBuilder.Platform;

interface

uses MonkeyBuilder_Intf, JsonDataObjects, Spring.Collections.Lists;

type
  TMbProjectPlatform = class(TInterfacedObject, IMbProjectPlatform)
  private
    FAppID: string;
    FConditionals: string;
    FLibraryPath: string;
    FSearchPath: string;
    FUnitScopeNames: string;
    FInterfaceStyle: string;
    FLinkerOptions: string;
    FSdk: string;
    FVersion: IMbProjectVersion;
    FDeployment: IMbDeploymentFileList;
    FImages: IMbPlatformImages;
    function GetLinkerOptions: string;
    function GetSearchPath: string;
    function GetUnitScopeNames: string;
    function GetImages: IMbPlatformImages;
    function GetDeploymentFiles: IMbDeploymentFileList;
    procedure SetLinkerOptions(const Value: string);
    procedure SetSearchPath(const Value: string);
    procedure SetUnitScopeNames(const Value: string);
    function GetAppID: string;
    function GetConditionals: string;
    function GetLibraryPath: string;
    procedure SetAppID(const Value: string);
    procedure SetConditionals(const Value: string);
    procedure SetLibraryPath(const Value: string);
    function GetVersion: IMbProjectVersion;
    function GetInterfaceStyle: string;
    procedure SetInterfaceStyle(const Value: string);
    function GetSdk: string;
    procedure SetSdk(const Value: string);
  protected
    procedure SaveToJson(AJson: TJsonObject); virtual;
    procedure LoadFromJson(AJson: TJsonObject); virtual;
    property AppID: string read GetAppID write SetAppID;
    property Conditionals: string read GetConditionals write SetConditionals;
    property LibraryPath: string read GetLibraryPath write SetLibraryPath;
    property SearchPath: string read GetSearchPath write SetSearchPath;
    property LinkerOptions: string read GetLinkerOptions write SetLinkerOptions;
    property UnitScopeNames: string read GetUnitScopeNames write SetUnitScopeNames;
    property InterfaceStyle: string read GetInterfaceStyle write SetInterfaceStyle;
    property Sdk: string read GetSdk write SetSdk;
    property DeploymentFiles: IMbDeploymentFileList read GetDeploymentFiles;
    property Version: IMbProjectVersion read GetVersion;
    property Images: IMbPlatformImages read GetImages;
  public
    constructor Create; virtual;
  end;

  TMbPojectUsageDescriptions = class(TInterfacedObject, IMbPojectUsageDescriptions)
  private
    FNSLocationAlwaysUsageDescription: string;
    FNSLocationWhenInUseUsageDescription: string;
    FNSLocationAlwaysAndWhenInUseUsageDescription: string;
    FNSContactsUsageDescription: string;
		FNSPhotoLibraryUsageDescription: string;
		FNSPhotoLibraryAddUsageDescription: string;
		FNSCameraUsageDescription: string;
		FNSFaceIDUsageDescription: string;
		FNSMicrophoneUsageDescription: string;
    FNSSiriUsageDescription: string;
    function GetNSCameraUsageDescription: string;
    function GetNSContactsUsageDescription: string;
    function GetNSFaceIDUsageDescription: string;
    function GetNSLocationAlwaysAndWhenInUseUsageDescription: string;
    function GetNSLocationAlwaysUsageDescription: string;
    function GetNSLocationWhenInUseUsageDescription: string;
    function GetNSMicrophoneUsageDescription: string;
    function GetNSPhotoLibraryAddUsageDescription: string;
    function GetNSPhotoLibraryUsageDescription: string;
    function GetNSSiriUsageDescription: string;
    procedure SetNSCameraUsageDescription(const Value: string);
    procedure SetNSContactsUsageDescription(const Value: string);
    procedure SetNSFaceIDUsageDescription(const Value: string);
    procedure SetNSLocationAlwaysAndWhenInUseUsageDescription(const Value: string);
    procedure SetNSLocationAlwaysUsageDescription(const Value: string);
    procedure SetNSLocationWhenInUseUsageDescription(const Value: string);
    procedure SetNSMicrophoneUsageDescription(const Value: string);
    procedure SetNSPhotoLibraryAddUsageDescription(const Value: string);
    procedure SetNSPhotoLibraryUsageDescription(const Value: string);
    procedure SetNSSiriUsageDescription(const Value: string);
  protected
    property NSLocationAlwaysUsageDescription: string read GetNSLocationAlwaysUsageDescription write SetNSLocationAlwaysUsageDescription;
    property NSLocationWhenInUseUsageDescription: string read GetNSLocationWhenInUseUsageDescription write SetNSLocationWhenInUseUsageDescription;
    property NSLocationAlwaysAndWhenInUseUsageDescription: string read GetNSLocationAlwaysAndWhenInUseUsageDescription write SetNSLocationAlwaysAndWhenInUseUsageDescription;
    property NSContactsUsageDescription: string read GetNSContactsUsageDescription write SetNSContactsUsageDescription;
		property NSPhotoLibraryUsageDescription: string read GetNSPhotoLibraryUsageDescription write SetNSPhotoLibraryUsageDescription;
		property NSPhotoLibraryAddUsageDescription: string read GetNSPhotoLibraryAddUsageDescription write SetNSPhotoLibraryAddUsageDescription;
		property NSCameraUsageDescription: string read GetNSCameraUsageDescription write SetNSCameraUsageDescription;
		property NSFaceIDUsageDescription: string read GetNSFaceIDUsageDescription write SetNSFaceIDUsageDescription;
		property NSMicrophoneUsageDescription: string read GetNSMicrophoneUsageDescription write SetNSMicrophoneUsageDescription;
    property NSSiriUsageDescription: string read GetNSSiriUsageDescription write SetNSSiriUsageDescription;
  end;

  TMbProjectPlatformIos = class(TMbProjectPlatform, IMbProjectPlatformIos)
  private
    FDeviceFamily: string;
    FGoogleServicePlist: string;
    FMinOsVersion: string;
    FUsageDescriptions: IMbPojectUsageDescriptions;
    function GetDeviceFamily: string;
    procedure SetDeviceFamily(const Value: string);
    function GetGoogleServicePList: string;
    function GetMinOsVersion: string;
    procedure SetGoogleServicePList(const Value: string);
    procedure SetMinOsVersion(const Value: string);
    function GetUsageDescriptions: IMbPojectUsageDescriptions;
  protected
    procedure SaveToJson(AJson: TJsonObject); override;
    procedure LoadFromJson(AJson: TJsonObject); override;
    property DeviceFamily: string read GetDeviceFamily write SetDeviceFamily;
    property MinOsVersion: string read GetMinOsVersion write SetMinOsVersion;
    property GoogleServicePlist: string read GetGoogleServicePList write SetGoogleServicePList;
    property UsageDescriptions: IMbPojectUsageDescriptions read GetUsageDescriptions;
  public
    constructor Create; override;
  end;

  TMbAndroidEntitlements = class(TInterfacedObject, IMbAndroidEntitlements)
  private
    FMapsService: Boolean;
    FPushNotifications: Boolean;
    FAdMobService: Boolean;
    FSecureFileSharing: Boolean;
    function GetAdMobService: Boolean;
    function GetFileSharing: Boolean;
    function GetMapsService: Boolean;
    function GetPushNotifications: Boolean;
    procedure SetAdMobService(const Value: Boolean);
    procedure SetFileSharing(const Value: Boolean);
    procedure SetMapsService(const Value: Boolean);
    procedure SetPushNotifications(const Value: Boolean);
  public
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
    property AdMobService: Boolean read GetAdMobService write SetAdMobService;
    property MapsService: Boolean read GetMapsService write SetMapsService;
    property PushNotifications: Boolean read GetPushNotifications write SetPushNotifications;
    property SecureFileSharing: Boolean read GetFileSharing write SetFileSharing;
  end;

  TMbProjectPlatformAndroid = class(TMbProjectPlatform, IMbProjectPlatformAndroid)
  private
    FEntitlements: IMbAndroidEntitlements;
    function GetEntitlements: IMbAndroidEntitlements;
  protected
    procedure SaveToJson(AJson: TJsonObject); override;
    procedure LoadFromJson(AJson: TJsonObject); override;
    property Entitlements: IMbAndroidEntitlements read GetEntitlements;
  public
    constructor Create; override;

  end;

implementation

uses MonkeyBuilder.Project;

{ TMbProjectPlatform }

constructor TMbProjectPlatform.Create;
begin
  inherited;
  FDeployment := TMbDeploymentFileList.Create;
  FImages := TMbPlatformImages.Create;
  FVersion := TMbProjectVersion.Create;
end;

function TMbProjectPlatform.GetAppID: string;
begin
  Result := FAppID;
end;

function TMbProjectPlatform.GetConditionals: string;
begin
  Result := FConditionals;
end;

function TMbProjectPlatform.GetDeploymentFiles: IMbDeploymentFileList;
begin
  Result := FDeployment;
end;

function TMbProjectPlatform.GetImages: IMbPlatformImages;
begin
  Result := FImages;
end;

function TMbProjectPlatform.GetInterfaceStyle: string;
begin
  Result := FInterfaceStyle;
end;

function TMbProjectPlatform.GetLibraryPath: string;
begin
  Result := FLibraryPath;
end;

function TMbProjectPlatform.GetLinkerOptions: string;
begin
  Result := FLinkerOptions;
end;

function TMbProjectPlatform.GetSdk: string;
begin
  Result := FSdk;
end;

function TMbProjectPlatform.GetSearchPath: string;
begin
  Result := FSearchPath;
end;

function TMbProjectPlatform.GetUnitScopeNames: string;
begin
  Result := FUnitScopeNames;
end;

function TMbProjectPlatform.GetVersion: IMbProjectVersion;
begin
  Result := FVersion;
end;

procedure TMbProjectPlatform.LoadFromJson(AJson: TJsonObject);
begin
  FAppID := AJson.S['appId'];
  FConditionals := AJson.S['conditionals'];
  FLibraryPath := AJson.S['libraryPath'];
  FSearchPath := AJson.S['searchPath'];
  FLinkerOptions := AJson.S['linkerOptions'];
  FUnitScopeNames := AJson.S['unitScopeNames'];
  FInterfaceStyle := AJson.S['interfaceStyle'];
  FDeployment.LoadFromJson(AJson);
  FVersion.LoadFromJson(AJson.O['version']);
  FImages.LoadFromJson(AJson);
end;

procedure TMbProjectPlatform.SaveToJson(AJson: TJsonObject);
begin
  AJson.S['appId'] := FAppID;
  AJson.S['conditionals'] := FConditionals;
  AJson.S['libraryPath'] := FLibraryPath;
  AJson.S['searchPath'] := FSearchPath;
  AJson.S['linkerOptions'] := FLinkerOptions;
  AJson.S['unitScopeNames'] := FUnitScopeNames;
  AJson.S['interfaceStyle'] := FInterfaceStyle;

  FVersion.SaveToJson(AJson.O['version']);
  FDeployment.SaveToJson(AJson);
  FImages.SaveToJson(AJson);
end;

procedure TMbProjectPlatform.SetAppID(const Value: string);
begin
  FAppID := Value;
end;

procedure TMbProjectPlatform.SetConditionals(const Value: string);
begin
  FConditionals := Value;
end;

procedure TMbProjectPlatform.SetInterfaceStyle(const Value: string);
begin
  FInterfaceStyle := Value;
end;

procedure TMbProjectPlatform.SetLibraryPath(const Value: string);
begin
  FLibraryPath := Value;
end;

procedure TMbProjectPlatform.SetLinkerOptions(const Value: string);
begin
  FLinkerOptions := Value;
end;

procedure TMbProjectPlatform.SetSdk(const Value: string);
begin
  FSdk := Value;
end;

procedure TMbProjectPlatform.SetSearchPath(const Value: string);
begin
  FSearchPath := Value;
end;

procedure TMbProjectPlatform.SetUnitScopeNames(const Value: string);
begin
  FUnitScopeNames := Value;
end;

{ TMbProjectPlatformAndroid }

constructor TMbProjectPlatformAndroid.Create;
begin
  inherited;
  FEntitlements := TMbAndroidEntitlements.Create;
end;


function TMbProjectPlatformAndroid.GetEntitlements: IMbAndroidEntitlements;
begin
  Result := FEntitlements;
end;

procedure TMbProjectPlatformAndroid.LoadFromJson(AJson: TJsonObject);
begin
  inherited;
  FEntitlements.LoadFromJson(AJson.O['entitlements']);
end;

procedure TMbProjectPlatformAndroid.SaveToJson(AJson: TJsonObject);
begin
  inherited SaveToJson(AJson);
  FEntitlements.SaveToJson(AJson.O['entitlements']);
end;

{ TMbProjectPlatformIos }

constructor TMbProjectPlatformIos.Create;
begin
  inherited;
  FUsageDescriptions := TMbPojectUsageDescriptions.Create;
end;

function TMbProjectPlatformIos.GetDeviceFamily: string;
begin
  Result := FDeviceFamily;
end;

function TMbProjectPlatformIos.GetGoogleServicePList: string;
begin
  Result := FGoogleServicePlist;
end;

function TMbProjectPlatformIos.GetMinOsVersion: string;
begin
  Result := FMinOsVersion;
end;

function TMbProjectPlatformIos.GetUsageDescriptions: IMbPojectUsageDescriptions;
begin
  Result := FUsageDescriptions;
end;

procedure TMbProjectPlatformIos.LoadFromJson(AJson: TJsonObject);
begin
  inherited;
  FDeviceFamily := AJson.S['deviceFamily'];
  FGoogleServicePlist := AJson.S['googleServicePList'];
  FMinOsVersion := AJson.S['minOsVersion'];
end;

procedure TMbProjectPlatformIos.SaveToJson(AJson: TJsonObject);
begin
  inherited;
  AJson.S['deviceFamily'] := FDeviceFamily;
  AJson.S['googleServicePList'] := FGoogleServicePlist;
  AJson.S['minOsVersion'] := FMinOsVersion;
end;


procedure TMbProjectPlatformIos.SetDeviceFamily(const Value: string);
begin
  FDeviceFamily := Value;
end;

procedure TMbProjectPlatformIos.SetGoogleServicePList(const Value: string);
begin
  FGoogleServicePlist := Value;
end;

procedure TMbProjectPlatformIos.SetMinOsVersion(const Value: string);
begin
  FMinOsVersion := Value;
end;

{ TMbAndroidEntitlements }

function TMbAndroidEntitlements.GetAdMobService: Boolean;
begin
  Result := FAdMobService;
end;

function TMbAndroidEntitlements.GetFileSharing: Boolean;
begin
  Result := FSecureFileSharing;
end;

function TMbAndroidEntitlements.GetMapsService: Boolean;
begin
  Result := FMapsService;
end;

function TMbAndroidEntitlements.GetPushNotifications: Boolean;
begin
  Result := FPushNotifications;
end;

procedure TMbAndroidEntitlements.LoadFromJson(AJson: TJsonObject);
begin
  FAdMobService := AJson.B['AdMobService'];
  FMapsService := AJson.B['MapsService'];
  FPushNotifications := AJson.B['ReceivePushNotifications'];
  FSecureFileSharing := AJson.B['SecureFileSharing'];
end;

procedure TMbAndroidEntitlements.SaveToJson(AJson: TJsonObject);
begin
  AJson.B['AdMobService'] := FAdMobService;
  AJson.B['MapsService'] := FMapsService;
  AJson.B['ReceivePushNotifications'] := FPushNotifications;
  AJson.B['SecureFileSharing'] := FSecureFileSharing;
end;

procedure TMbAndroidEntitlements.SetAdMobService(const Value: Boolean);
begin
  FAdMobService := Value;
end;

procedure TMbAndroidEntitlements.SetFileSharing(const Value: Boolean);
begin
  FSecureFileSharing := Value;
end;

procedure TMbAndroidEntitlements.SetMapsService(const Value: Boolean);
begin
  FMapsService := Value;
end;

procedure TMbAndroidEntitlements.SetPushNotifications(const Value: Boolean);
begin
  FPushNotifications := Value;
end;

{ TMbPojectUsageDescriptions }

function TMbPojectUsageDescriptions.GetNSCameraUsageDescription: string;
begin
  Result := FNSCameraUsageDescription;
end;

function TMbPojectUsageDescriptions.GetNSContactsUsageDescription: string;
begin
  Result := FNSContactsUsageDescription;
end;

function TMbPojectUsageDescriptions.GetNSFaceIDUsageDescription: string;
begin
  Result := FNSFaceIDUsageDescription;
end;

function TMbPojectUsageDescriptions.GetNSLocationAlwaysAndWhenInUseUsageDescription: string;
begin
  Result := FNSLocationAlwaysAndWhenInUseUsageDescription;
end;

function TMbPojectUsageDescriptions.GetNSLocationAlwaysUsageDescription: string;
begin
  Result := FNSLocationAlwaysUsageDescription;
end;

function TMbPojectUsageDescriptions.GetNSLocationWhenInUseUsageDescription: string;
begin
  Result := FNSLocationWhenInUseUsageDescription;
end;

function TMbPojectUsageDescriptions.GetNSMicrophoneUsageDescription: string;
begin
  Result := FNSMicrophoneUsageDescription;
end;

function TMbPojectUsageDescriptions.GetNSPhotoLibraryAddUsageDescription: string;
begin
  Result := FNSPhotoLibraryAddUsageDescription;
end;

function TMbPojectUsageDescriptions.GetNSPhotoLibraryUsageDescription: string;
begin
  Result := FNSPhotoLibraryUsageDescription;
end;

function TMbPojectUsageDescriptions.GetNSSiriUsageDescription: string;
begin
  Result := FNSSiriUsageDescription;
end;

procedure TMbPojectUsageDescriptions.SetNSCameraUsageDescription(
  const Value: string);
begin
  FNSCameraUsageDescription := Value;
end;

procedure TMbPojectUsageDescriptions.SetNSContactsUsageDescription(
  const Value: string);
begin
  FNSContactsUsageDescription := Value;
end;

procedure TMbPojectUsageDescriptions.SetNSFaceIDUsageDescription(
  const Value: string);
begin
  FNSFaceIDUsageDescription := Value;
end;

procedure TMbPojectUsageDescriptions.SetNSLocationAlwaysAndWhenInUseUsageDescription(
  const Value: string);
begin
  FNSLocationAlwaysAndWhenInUseUsageDescription := Value;
end;

procedure TMbPojectUsageDescriptions.SetNSLocationAlwaysUsageDescription(
  const Value: string);
begin
  FNSLocationAlwaysUsageDescription := Value;
end;

procedure TMbPojectUsageDescriptions.SetNSLocationWhenInUseUsageDescription(
  const Value: string);
begin
  FNSLocationWhenInUseUsageDescription := Value;
end;

procedure TMbPojectUsageDescriptions.SetNSMicrophoneUsageDescription(
  const Value: string);
begin
  FNSMicrophoneUsageDescription := Value;
end;

procedure TMbPojectUsageDescriptions.SetNSPhotoLibraryAddUsageDescription(
  const Value: string);
begin
  FNSPhotoLibraryAddUsageDescription := Value;
end;

procedure TMbPojectUsageDescriptions.SetNSPhotoLibraryUsageDescription(
  const Value: string);
begin
  FNSPhotoLibraryUsageDescription := Value;
end;

procedure TMbPojectUsageDescriptions.SetNSSiriUsageDescription(
  const Value: string);
begin
  FNSSiriUsageDescription := Value;
end;

end.

