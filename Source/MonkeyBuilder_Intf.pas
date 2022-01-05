unit MonkeyBuilder_Intf;

interface

uses Spring.Collections, JsonDataObjects, JclSysUtils, Graphics, Types, Classes,
  ksInspector;

const
  //C_DELPHI_10_4_VER_NUM = '21.0';
  C_DELPHI_11_0_VER_NUM = '22.0';

type
  TmbPlatform = (mbAndroid, mbAndroid64, mbIosDevice64);
  TmbPlatforms = set of TmbPlatform;
  TmbDeploymentType = (mbDeplyDevelopment, mbDeployAppStore);

  TDevice = record
    DevName: string;
    DevID: string;
  end;

  TDeviceList = TArray<TDevice>;

  IMbDeploymentFile = interface
    ['{1F84E431-5363-4BAD-B829-530D303405ED}']
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
    function GetFilename: string;
    function GetRemoteName: string;
    function GetRemotePath: string;

    procedure SetFilename(const Value: string);
    procedure SetRemoteName(const Value: string);
    procedure SetRemotePath(const Value: string);
    procedure Assign(ASource: IMbDeploymentFile);
    property Filename: string read GetFilename write SetFilename;
    property RemoteName: string read GetRemoteName write SetRemoteName;
    property RemotePath: string read GetRemotePath write SetRemotePath;
  end;

  IMbDeploymentFileList = Interface(IList<IMbDeploymentFile>)
    ['{988EBA21-95A9-4E33-B72C-247A522C5CB8}']
    function AddFile(const AFilename: string = ''): IMbDeploymentFile;
    procedure Assign(ASource: IMbDeploymentFileList);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure SaveToJson(AJson: TJsonObject);
    procedure SortByName;
  end;

  IMbImage = interface
    ['{29AD410F-4EC8-4124-A100-5425857C4FCE}']
    function GetID: string;
    function GetFilename: string;
    function GetHeight: integer;
    function GetWidth: integer;
    function GetName: string;
    function GetIsIcon: Boolean;
    function GetOrientationStr: string;
    function FileExists: Boolean;
    function GetRemoteFolder: string;
    function GetRemoteName: string;
    function GetHash: string;
    procedure LoadIcon;
    procedure Assign(ASource: IMbImage);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure DrawToCanvas(Canvas: TCanvas; ARect: TRect);
    procedure SaveToJson(AJson: TJsonObject);
    procedure SetFilename(const Value: string);
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    procedure SetRemoteFolder(const Value: string);
    procedure SetRemoteName(const Value: string);
    procedure GenerateHash(ASeed: string);
    property ID: string read GetID;
    property Filename: string read GetFilename write SetFilename;
    property Name: string read GetName;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;
    property IsIcon: Boolean read GetIsIcon;
    property OrientationStr: string read GetOrientationStr;
    property RemoteFolder: string read GetRemoteFolder write SetRemoteFolder;
    property RemoteName: string read GetRemoteName write SetRemoteName;
    property Hash: string read GetHash;
  end;

  IMbImageList = Interface(IList<IMbImage>)
    ['{809721C9-1EBE-4140-BB5A-C933D980CFBC}']
    function AddImage(AID, AName: string): IMbImage; overload;
    function AddImage(AID, AName, AFilename: string; AWidth, AHeight: integer; const ARemoteFolder: string = ''; const ARemoteName: string = ''): IMbImage; overload;
    function GetImageByID(AID: string): IMbImage;
    function LargestImage: IMbImage;
    procedure Assign(ASource: IMbImageList);
    procedure AddFromFile(AFile: string);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure LoadFromFolder(AFolder: string);
    procedure SaveToJson(AJson: TJsonObject);
    procedure GenerateHashes;
    property ImageByID[AID: string]: IMbImage read GetImageByID;
  end;

  IMbPlatformImages = interface
    ['{8494FB59-FA76-47FB-9D9B-C6F3CC4C3358}']
    function GetIcons: IMbImageList;
    function GetSplash: IMbImageList;
    procedure Assign(ASource: IMbPlatformImages);
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
    property Icons: IMbImageList read GetIcons;
    property Splash: IMbImageList read GetSplash;
  end;

  IMbProjectVersion = interface
    ['{93FE9A48-CE76-47E1-8313-3FA23B1CEF30}']
    function GetBuild: integer;
    function GetMajor: integer;
    function GetMinor: integer;
    function GetAsString: string;
    procedure Assign(ASource: IMbProjectVersion);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure SaveToJson(AJson: TJsonObject);
    procedure SetBuild(const Value: integer);
    procedure SetMajor(const Value: integer);
    procedure SetMinor(const Value: integer);
    property Major: integer read GetMajor write SetMajor;
    property Minor: integer read GetMinor write SetMinor;
    property Build: integer read GetBuild write SetBuild;
    property AsString: string read GetAsString;
  end;

  IMbProjectUsageDescriptions = interface
    ['{D09CF92D-837F-4F46-84D2-166A0F099C7E}']
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

    procedure Assign(ASource: IMbProjectUsageDescriptions);
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
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

  IMbAndroidEntitlements = interface
    ['{E4128C86-8034-4CED-9913-ADEC6779DE49}']
    function GetAdMobService: Boolean;
    function GetFileSharing: Boolean;
    function GetMapsService: Boolean;
    function GetPushNotifications: Boolean;
    procedure SetAdMobService(const Value: Boolean);
    procedure SetFileSharing(const Value: Boolean);
    procedure SetMapsService(const Value: Boolean);
    procedure SetPushNotifications(const Value: Boolean);
    procedure Assign(ASource: IMbAndroidEntitlements);
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
    property AdMobService: Boolean read GetAdMobService write SetAdMobService;
    property MapsService: Boolean read GetMapsService write SetMapsService;
    property PushNotifications: Boolean read GetPushNotifications write SetPushNotifications;
    property SecureFileSharing: Boolean read GetFileSharing write SetFileSharing;
  end;

  IMbAndroidPermission = interface
    ['{F9FD8995-E174-4FFA-95BA-F28EB2D5E2E2}']
    function GetDangerous: Boolean;
    function GetID: string;
    function GetTitle: string;
    procedure SetDangerous(const Value: Boolean);
    procedure SetID(const Value: string);
    procedure SetTitle(const Value: string);
    property ID: string read GetID write SetID;
    property Title: string read GetTitle write SetTitle;
    property Dangerous: Boolean read GetDangerous write SetDangerous;
  end;

  IMbAndroidPermissionList = interface(IList<IMbAndroidPermission>)
    ['{2770C985-A87F-4C4B-8A91-DBC00AB414BD}']
    procedure BuildPermissionList;
    procedure PopulatePermissionStrings(AStrings: TStrings; ANormal, ADangerous: Boolean);
  end;

  IMbProjectPlatform = interface
    ['{15E7907F-4C9A-4167-AF36-075508BAC3EA}']
    function GetAppID: string;
    function GetConditionals: string;
    function GetLibraryPath: string;
    function GetLinkerOptions: string;
    function GetSearchPath: string;
    function GetUnitScopeNames: string;
    function GetUserInterfaceStyle: string;
    function GetSdk: string;
    function GetConnectionProfile: string;
    function GetVersion: IMbProjectVersion;
    function GetImages: IMbPlatformImages;
    function GetDeploymentFiles: IMbDeploymentFileList;
    function GetLog: TStrings;
    function GetRunning: Boolean;

    function GetAdMobAppID: string;
    procedure SetAdMobAppID(const Value: string);

    function RunPreBuildDeployChecks(ABuild, ADeploy: Boolean; ADeployType: TmbDeploymentType): Boolean;
    procedure SetLinkerOptions(const Value: string);
    procedure SetSearchPath(const Value: string);
    procedure SetUnitScopeNames(const Value: string);
    procedure SetSdk(const Value: string);
    procedure SetConnectionProfile(const Value: string);
    procedure Assign(ASource: IMbProjectPlatform);
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure AbortBuild;
    procedure SetAppID(const Value: string);
    procedure SetConditionals(const Value: string);
    procedure SetLibraryPath(const Value: string);
    procedure SetUserInterfaceStyle(const Value: string);

    procedure BuildASync(APlatform: TmbPlatform; ADeployType: TmbDeploymentType;
      ADeviceID: string; AOnLogOutput: TTextHandler;
      const ARunDeployChecks: Boolean = False);

    property AppID: string read GetAppID write SetAppID;
    property AdMobAppID: string read GetAdMobAppID write SetAdMobAppID;
    property Conditionals: string read GetConditionals write SetConditionals;
    property LibraryPath: string read GetLibraryPath write SetLibraryPath;
    property SearchPath: string read GetSearchPath write SetSearchPath;
    property LinkerOptions: string read GetLinkerOptions write SetLinkerOptions;
    property UnitScopeNames: string read GetUnitScopeNames write SetUnitScopeNames;
    property UserInterfaceStyle: string read GetUserInterfaceStyle write SetUserInterfaceStyle;
    property Sdk: string read GetSdk write SetSdk;
    property ConnectionProfile: string read GetConnectionProfile write SetConnectionProfile;
    property Version: IMbProjectVersion read GetVersion;
    property Images: IMbPlatformImages read GetImages;
    property DeploymentFiles: IMbDeploymentFileList read GetDeploymentFiles;
    property Log: TSTrings read GetLog;
    property Running: Boolean read GetRunning;
  end;

  IMbAndroidKeyStore = interface
    ['{7F739EA3-938F-4A0A-8AB3-52089923632A}']
    function GetAlias: string;
    function GetAliasPassword: string;
    function GetKeystoreFile: string;
    function GetKeystorePassword: string;
    procedure SetAlias(const Value: string);
    procedure SetAliasPassword(const Value: string);
    procedure SetKeystoreFile(const Value: string);
    procedure SetKeystorePassword(const Value: string);
    procedure Assign(ASource: IMbAndroidKeyStore);
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
    function ValidateDetails: Boolean;
    property KeystoreFile: string read GetKeystoreFile write SetKeystoreFile;
    property KeystorePassword: string read GetKeystorePassword write SetKeystorePassword;
    property Alias: string read GetAlias write SetAlias;
    property AliasPassword: string read GetAliasPassword write SetAliasPassword;
  end;

  IMbProjectPlatformAndroid = interface(IMbProjectPlatform)
    ['{52DEAE14-B46F-4AD6-8765-EC2C18B6BB75}']
    function GetGoogleServiceJson: TksFile;
    procedure SetGoogleServiceJson(const AValue: TksFile);

    function GetKeystore: IMbAndroidKeyStore;
    function GetMinSdkVersion: integer;
    function GetTargetSdkVersion: integer;
    function GetEntitlements: IMbAndroidEntitlements;
    function GetPermissions: TStrings;
    function GetGoogleMapsApiKey: string;
    procedure SetGoogleMapsApiKey(const Value: string);
    procedure SetMinSdkVersion(const Value: integer);
    procedure SetTargetSdkVersion(const Value: integer);
    procedure RemovePermission(AID: string);
    property MinSdkVersion: integer read GetMinSdkVersion write SetMinSdkVersion;
    property GoogleMapsApiKey: string read GetGoogleMapsApiKey write SetGoogleMapsApiKey;
    property TargetSdkVersion: integer read GetTargetSdkVersion write SetTargetSdkVersion;
    property Entitlements: IMbAndroidEntitlements read GetEntitlements;
    property Permissions: TStrings read GetPermissions;
    property Keystore: IMbAndroidKeyStore read GetKeyStore;
    property GoogleServiceJson: TksFile read GetGoogleServiceJson write SetGoogleServiceJson;
  end;

  IMbiOSProfile = interface
    ['{2046FC0D-9479-488F-897C-D48DDBEB3000}']
    function IsDevelopmentProfile: Boolean;
    function GetBundleId: string;
    function GetAppID: string;
    function GetMobileProvisionFile: string;
    function GetProfileName: string;
    function GetUuid: string;
    function GetEntitlements: string;
    function GetCreationDate: TDateTime;
    procedure SetBundleId(const Value: string);

    procedure SetMobileProvisionFile(const Value: string);
    procedure SetProfileName(const Value: string);
    procedure SetUuid(const Value: string);
    procedure Assign(Source: IMbiOSProfile);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromGuid(AGuid: string; AProfiles: TJsonArray);
    procedure SetEntitlements(const Value: string);
    procedure SetCreationDate(const Value: TDateTime);
    procedure PopulateCerts(AStrings: TStrings);

    property ProfileName: string read GetProfileName write SetProfileName;
    property Uuid: string read GetUuid write SetUuid;
    property BundleID: string read GetBundleId write SetBundleId;
    property AppID: string read GetAppID;
    property MobileProvisionFile: string read GetMobileProvisionFile write SetMobileProvisionFile;
    property Entitlements: string read GetEntitlements write SetEntitlements;
    property CreationDate: TDateTime read GetCreationDate write SetCreationDate;
  end;

  IMbiOSProfileList = interface(IList<IMbiOSProfile>)
    function AddProfile: IMbiOSProfile;
    function AppStoreProfiles: IMbiOSProfileList;
    function DevelopmentProfiles: IMbiOSProfileList;
    function ProfileFromID(AID: string): IMbiOSProfile;
    procedure LoadFromJson(AData: string);
    procedure PopulateProfileStrings(AStrings: TStrings; AType: TmbDeploymentType);
  end;

  IMbProjectPlatformIos = interface(IMbProjectPlatform)
    ['{EAECF765-9101-4952-85CB-55F25042E453}']
    function GetFrameworkPath: string;
    function SupportsIPhone: Boolean;
    function SupportsIPad: Boolean;
    function GetUsageDescriptions: IMbProjectUsageDescriptions;
    function GetMinOsVersion: string;
    function GetDeviceFamily: string;
    procedure SetDeviceFamily(const AValue: string);

    function GetProvisionCert(AType: TmbDeploymentType): string;
    procedure SetProvisionCert(AType: TmbDeploymentType; const Value: string);
    function GetProvisionProfileID(AType: TmbDeploymentType): string;
    procedure SetProvisionProfileID(AType: TmbDeploymentType; const Value: string);
    procedure SetFrameworkPath(const Value: string);

    function GetGoogleServicePlist: TksFile;
    procedure SetGoogleServicePlist(const AValue: TksFile);
    procedure SetMinOsVersion(const Value: string);
    property FrameworkPath: string read GetFrameworkPath write SetFrameworkPath;
    property DeviceFamily: string read GetDeviceFamily write SetDeviceFamily;
    property GoogleServicePlist: TksFile read GetGoogleServicePlist write SetGoogleServicePlist;
    property MinOsVersion: string read GetMinOsVersion write SetMinOsVersion;
    property UsageDescriptions: IMbProjectUsageDescriptions read GetUsageDescriptions;

    property ProvisionCert[AType: TmbDeploymentType]: string read GetProvisionCert write SetProvisionCert;
    property ProvisionProfileID[AType: TmbDeploymentType]: string read GetProvisionProfileID write SetProvisionProfileID;

  end;


  IMbProject = interface
    ['{BDC223B8-8F4A-4DAA-937B-733FE2EBB9A3}']

    function GetProjectName: string;
    function GetFilename: string;
    function GetDelphiVersion: string;
    function GetProjectDir: string;
    function GetAndroidSettings: IMbProjectPlatformAndroid;
    function GetIosSettings: IMbProjectPlatformIos;
    function GetProjectPlatform(APlatform: TmbPlatform): IMbProjectPlatform;
    function GetTitle: string;
    procedure SetFilename(const Value: string);
    procedure SetDelphiVersion(const Value: string);
    procedure Build(APlatform: TmbPlatform; ADeviceID: string; ADeployType: TmbDeploymentType; AOnLogOutput: TTextHandler);
    procedure SetTitle(const Value: string);

    procedure TerminateBuilds;
    procedure Assign(AProject: IMbProject);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure SaveToJson(AJson: TJsonObject);
    procedure InitializeFromDproj;
    property ProjectDir: string read GetProjectDir;
    property Title: string read GetTitle write SetTitle;
    property ProjectName: string read GetProjectName;// write SetProjectName;
    property Filename: string read GetFilename write SetFilename;
    property DelphiVersion: string read GetDelphiVersion write SetDelphiVersion;
    property PlatformSettings[APlatform: TmbPlatform]: IMbProjectPlatform read GetProjectPlatform;
    property AndroidSettings: IMbProjectPlatformAndroid read GetAndroidSettings;
    property IosSettings: IMbProjectPlatformIos read GetIosSettings;
  end;


   IMbProjectList = Interface(IList<IMbProject>)
     ['{8507E535-70AC-48CA-9F22-3B270DE88202}']
     function AreBuildsRunning: Boolean;

     function AddProject: IMbProject;
     function ProjectExists(AFilename: string): Boolean;
     function ProjectByFilename(AFilename: string): IMbProject;
     procedure LoadFromFile(AFilename: string);
     procedure SaveToFile(AFilename: string);
     procedure SortByName;
     procedure TerminateAllBuilds;
     procedure TerminateBuild(AAppName: string; APlatform: TmbPlatform);
   end;

   function CreateProject: IMbProject;
   function CreateProjectList: IMbProjectList;
   function CreateAndroidPermissionsList: IMbAndroidPermissionList;


   function PlatformToStr(APlatform: TmbPlatform): string;
   function StrToPlatform(AStr: string): TmbPlatform;

implementation

uses MonkeyBuilder.Project, MonkeyBuilder.Platform.Android, SysUtils;

function PlatformToStr(APlatform: TmbPlatform): string;
begin
  case APlatform of
    mbAndroid: Result := 'Android';
    mbAndroid64: Result := 'Android64';
    mbIosDevice64: Result := 'iOSDevice64';
  end;
end;

function StrToPlatform(AStr: string): TmbPlatform;
begin
  if CompareText(AStr, 'Android') = 0 then Result := mbAndroid else
  if CompareText(AStr, 'Android64') = 0 then Result := mbAndroid64 else
    Result := mbIosDevice64;
end;


function CreateProject: IMbProject;
begin
    Result := TMbProject.Create;
end;

function CreateProjectList: IMbProjectList;
begin
  Result := TMbProjectList.Create;
end;

function CreateAndroidPermissionsList: IMbAndroidPermissionList;
begin
  Result := TMbAndroidPermissionList.Create;
end;

end.

