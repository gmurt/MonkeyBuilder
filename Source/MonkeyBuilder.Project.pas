unit MonkeyBuilder.Project;

interface

uses Winapi.Windows, MonkeyBuilder_Intf, Spring.Collections.Lists,
  JsonDataObjects, Classes, JclSysUtils, Graphics, PngImage, System.Threading;

type
  TMbMergeProc = procedure(var AText: string) of object;

  TMbDeploymentFile = class(TInterfacedObject, IMbDeploymentFile)
  private
    FFilename: string;
    FRemoteName: string;
    FRemotePath: string;

  protected
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

  TMbDeploymentFileList = class(TList<IMbDeploymentFile>, IMbDeploymentFileList)
  protected
    function AddFile(const AFilename: string = ''): IMbDeploymentFile;
    procedure Assign(ASource: IMbDeploymentFileList);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure SaveToJson(AJson: TJsonObject);
    procedure SortByName;
  end;

  TMbImage = class(TInterfacedObject, IMbImage)
  private
    FID: string;
    FName: string;
    FFilename: string;
    FHeight: integer;
    FWidth: integer;
    FRemoteFolder: string;
    FRemoteName: string;
    FIcon: TPngImage;
    FHash: string;
    function GetFilename: string;
    function GetHeight: integer;
    function GetWidth: integer;
    procedure ClearImage;
    procedure SetFilename(const Value: string);
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
    function GetID: string;
    function GetName: string;
    function GetIsIcon: Boolean;
    function GetOrientationStr: string;
    function GetRemoteFolder: string;
    function GetRemoteName: string;
    procedure SetRemoteFolder(const Value: string);
    procedure SetRemoteName(const Value: string);
    function GetHash: string;
  protected

    function FileExists: Boolean;
    procedure GenerateHash(ASeed: string);
    procedure Assign(ASource: IMbImage);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure SaveToJson(AJson: TJsonObject);
    procedure DrawToCanvas(Canvas: TCanvas; ARect: TRect);
    procedure LoadIcon;
    property ID: string read GetID;
    property Name: string read GetName;
    property Filename: string read GetFilename write SetFilename;
    property Width: integer read GetWidth write SetWidth;
    property Height: integer read GetHeight write SetHeight;
    property IsIcon: Boolean read GetIsIcon;
    property OrientationStr: string read GetOrientationStr;
    property RemoteFolder: string read GetRemoteFolder write SetRemoteFolder;
    property RemoteName: string read GetRemoteName write SetRemoteName;
    property Hash: string read GetHash;
  public
    constructor Create(AID, AName: string); virtual;
    destructor Destroy; override;
  end;

  TMbImageList = class(TList<IMbImage>, IMbImageList)
  private

  protected
    function GetArrayName: string; virtual; abstract;
    function AddImage(AID, AName: string): IMbImage; overload;
    function GetImageByID(AID: string): IMbImage;
    function LargestImage: IMbImage;

    function AddImage(AID, AName, AFilename: string; AWidth, AHeight: integer;
      const ARemoteFolder: string = ''; const ARemoteName: string = '')
      : IMbImage; overload;
    procedure AddFromFile(AFile: string);
    procedure Assign(ASource: IMbImageList);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure LoadFromFolder(AFolder: string);
    procedure SaveToJson(AJson: TJsonObject);
    procedure GenerateHashes;
  end;

  TMbIconImageList = class(TMbImageList)
  protected
    function GetArrayName: string; override;
  end;

  TMbSplashImageList = class(TMbImageList)
  protected
    function GetArrayName: string; override;
  end;

  TMbPlatformImages = class(TInterfacedObject, IMbPlatformImages)
  private
    FIcons: IMbImageList;
    FSplash: IMbImageList;
    function GetIcons: IMbImageList;
    function GetSplash: IMbImageList;
  protected
    procedure Assign(ASource: IMbPlatformImages);
    procedure LoadFromJson(AJson: TJsonObject);
    procedure SaveToJson(AJson: TJsonObject);
  public
    constructor Create; virtual;
  end;

  TMbProjectVersion = class(TInterfacedObject, IMbProjectVersion)
  private
    FMajor: integer;
    FMinor: integer;
    FBuild: integer;
    function GetBuild: integer;
    function GetMajor: integer;
    function GetMinor: integer;
    procedure LoadFromJson(AJson: TJsonObject);
    procedure SaveToJson(AJson: TJsonObject);
    procedure SetBuild(const Value: integer);
    procedure SetMajor(const Value: integer);
    procedure SetMinor(const Value: integer);
    function GetAsString: string;
  protected
    procedure Assign(ASource: IMbProjectVersion);
    property Major: integer read GetMajor write SetMajor;
    property Minor: integer read GetMinor write SetMinor;
    property Build: integer read GetBuild write SetBuild;
    property AsString: string read GetAsString;
  end;

{$M+}

  TMbProjectPlatform = class(TInterfacedObject, IMbProjectPlatform)
  private
    FThread: ITask;

    FLog: TStrings;
    FProject: IMbProject;
    FAppID: string;
    FAdMobAppID: string;
    FConditionals: string;
    FLibraryPath: string;
    FSearchPath: string;
    FUnitScopeNames: string;
    FUserInterfaceStyle: string;
    FLinkerOptions: string;
    FSdk: string;
    FConnectionProfile: string;
    FVersion: IMbProjectVersion;
    FDeployment: IMbDeploymentFileList;
    FImages: IMbPlatformImages;
    FErrors: TStrings;
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
    function GetUserInterfaceStyle: string;
    procedure SetUserInterfaceStyle(const Value: string);
    function GetSdk: string;
    procedure SetSdk(const Value: string);
    function GetProject: IMbProject;
    function GetConnectionProfile: string;
    procedure SetConnectionProfile(const Value: string);
    function GetErrorCount: integer;
    function GetRunning: Boolean;
    function GetAdMobAppID: string;
    procedure SetAdMobAppID(const Value: string);
  protected
    FAbort: Boolean;

    function GetLog: TStrings;
    function RunPreBuildDeployChecks(ABuild, ADeploy: Boolean;
      ADeployType: TmbDeploymentType): Boolean; virtual;
    procedure CopyResource(AName, AFilename: string;
      const AMergeProc: TMbMergeProc = nil);
    procedure LogText(const AText: string); virtual;
    procedure LogError(const AError: string);
    procedure KeyStoreLogText(const AText: string); virtual;
    procedure Assign(ASource: IMbProjectPlatform); virtual;
    procedure SaveToJson(AJson: TJsonObject); virtual;
    procedure LoadFromJson(AJson: TJsonObject); virtual;
    procedure BuildASync(APlatform: TmbPlatform; ADeployType: TmbDeploymentType;
      ADeviceID: string; AOnLogOutput: TTextHandler;
      const ARunDeployChecks: Boolean = False); virtual;

    procedure Deploy(APlatform: TmbPlatform; ADeployType: TmbDeploymentType;
      ADeviceID: string; AOnLogOutput: TTextHandler); virtual;
    property Project: IMbProject read GetProject;
    property Sdk: string read GetSdk write SetSdk;
    property ConnectionProfile: string read GetConnectionProfile
      write SetConnectionProfile;
    property DeploymentFiles: IMbDeploymentFileList read GetDeploymentFiles;
    property Version: IMbProjectVersion read GetVersion;
    property Images: IMbPlatformImages read GetImages;
    property ErrorCount: integer read GetErrorCount;
    property Errors: TStrings read FErrors;
  public
    constructor Create(AProject: IMbProject); virtual;
    destructor Destroy; override;
    procedure AbortBuild;
    property Thread: ITask read FThread write FThread;
    property Running: Boolean read GetRunning;

  published
    property AppID: string read GetAppID write SetAppID;
    property AdMobAppID: string read GetAdMobAppID write SetAdMobAppID;
    property Conditionals: string read GetConditionals write SetConditionals;
    property LibraryPath: string read GetLibraryPath write SetLibraryPath;
    property SearchPath: string read GetSearchPath write SetSearchPath;
    property LinkerOptions: string read GetLinkerOptions write SetLinkerOptions;
    property UnitScopeNames: string read GetUnitScopeNames write SetUnitScopeNames;
    property UserInterfaceStyle: string read GetUserInterfaceStyle write SetUserInterfaceStyle;
  end;
{$M-}

  TMbProject = class(TInterfacedObject, IMbProject)
  private
    FTitle: string;
    FFilename: string;
    FDelphiVersion: string;
    FAndroidSettings: IMbProjectPlatformAndroid;
    FIosSettings: IMbProjectPlatformIos;

    function GetDelphiVersion: string;
    procedure SetDelphiVersion(const Value: string);
    function GetProjectDir: string;
    function GetProjectPlatform(APlatform: TmbPlatform): IMbProjectPlatform;
    function GetTitle: string;
    procedure SetTitle(const Value: string);
  protected
    function GetProjectName: string;
    function GetFilename: string;
    procedure TerminateBuilds;
    function GetAndroidSettings: IMbProjectPlatformAndroid;
    function GetIosSettings: IMbProjectPlatformIos;

    procedure SetFilename(const Value: string);
    procedure InitializeFromDproj;

    procedure Assign(AProject: IMbProject);
    procedure Build(APlatform: TmbPlatform; ADeviceID: string;
      ADeployType: TmbDeploymentType; AOnLogOutput: TTextHandler);

    procedure LoadFromJson(AJson: TJsonObject);
    procedure SaveToJson(AJson: TJsonObject);

    property Title: string read GetTitle write SetTitle;
    property ProjectDir: string read GetProjectDir;
    property ProjectName: string read GetProjectName; // write SetProjectName;
    property Filename: string read GetFilename write SetFilename;
    property DelphiVersion: string read GetDelphiVersion write SetDelphiVersion;
    property PlatformSettings[APlatform: TmbPlatform]: IMbProjectPlatform
      read GetProjectPlatform;
    property AndroidSettings: IMbProjectPlatformAndroid read GetAndroidSettings;
    property IosSettings: IMbProjectPlatformIos read GetIosSettings;
  public
    constructor Create; virtual;
  end;

  TMbProjectList = class(TList<IMbProject>, IMbProjectList)
  protected
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

function EncryptString(AStr: string): string;
function DescryptString(AStr: string): string;
function GetPaClientExe: string;
function BuildFolder: string;
function GlobalSetting(ASection, AName: string): string;
function GetPlatformString(APlatform: TmbPlatform): string;
function GetSdkValueFromRegistry(APlatform: TmbPlatform; AName: string): string;
function GetDelphiPath: string;
function QuoteFilePaths(AFiles: string): string;
function ReplaceEnvironmentVars(APlatform: TmbPlatform; AText: string)
  : string; overload;

procedure ReplaceEnvironmentVars(APlatform: TmbPlatform;
  AStrings: TStrings); overload;
procedure GetConnectionProfiles(APlatform: TmbPlatform; AStrings: TStrings;
  var ADefault: string);
procedure GetFrameworks(APlatform: TmbPlatform; AStrings: TStrings;
  var ADefault: string);
function GetRoamingFolderPath: string;

implementation

uses MonkeyBuilder.Platform.Ios, MonkeyBuilder.Platform.Android, SysUtils,
  Registry,
  XMLIntf, XMLDoc, JclStrings, ActiveX, IniFiles, JvComputerInfoEx, System.Hash,
  Math,
  System.Generics.Defaults, JvStrings, System.NetEncoding, untDProjUtils,
  untMbUtils,
  System.IOUtils;


// ------------------------------------------------------------------------------

function EncryptString(AStr: string): string;
begin
  Result := string(EncryptB64(AnsiString(AStr), 1010, 2020, 3030));
end;

function DescryptString(AStr: string): string;
begin
  Result := '';
  if AStr <> '' then
  begin
    try
      Result := string(DecryptB64(AnsiString(AStr), 1010, 2020, 3030));
    except
    end;
  end;
end;

function AppDataDir: string;
var
  AInfo: TJvComputerInfoEx;
begin
  AInfo := TJvComputerInfoEx.Create(nil);
  try
    Result := IncludeTrailingPathDelimiter(AInfo.Folders.AppData) +
      'Kernow Software\MonkeyBuilder\';
    if not FileExists(Result) then
      ForceDirectories(Result);
  finally
    AInfo.Free;
  end;
end;

function GetRoamingFolderPath: string;
begin
  Result := System.SysUtils.GetHomePath;
end;

function GetPaClientExe: string;
begin

  Result := ReplaceEnvironmentVars(mbIosDevice64, '$(BDSBIN)') +
    '\paclient.exe';
end;

function BuildFolder: string;
begin
  Result := AppDataDir + 'builds\';
  ForceDirectories(Result);
end;

function GetPlatformString(APlatform: TmbPlatform): string;
begin
  case APlatform of
    mbAndroid:
      Result := 'Android';
    mbAndroid64:
      Result := 'Android64';
    mbIosDevice64:
      Result := 'iOSDevice64';
  end;
end;

function GlobalSetting(ASection, AName: string): string;
var
  AFile: string;
  AIni: TMemIniFile;
begin
  AFile := IncludeTrailingPathDelimiter(AppDataDir) + 'settings.ini';
  AIni := TMemIniFile.Create(AFile);
  try
    Result := AIni.ReadString(ASection, AName, '');
  finally
    AIni.Free;
  end;
end;

function GetSdkValueFromRegistry(APlatform: TmbPlatform; AName: string): string;
var
  AReg: TRegistry;
  AVerNum: string;
  ADefault: string;
begin
  AVerNum := C_DELPHI_11_0_VER_NUM;
  AReg := TRegistry.Create;
  try
    AReg.RootKey := HKEY_CURRENT_USER;
    if AReg.OpenKey('Software\Embarcadero\BDS\' + AVerNum + '\PlatformSDKs\',
      False) then
    begin
      ADefault := AReg.ReadString('Default_' + GetPlatformString(APlatform));
      if AReg.OpenKey(ADefault, False) then
      begin
        Result := AReg.ReadString(AName);
      end;
    end;
  finally
    AReg.Free;
  end;
end;

function QuoteFilePaths(AFiles: string): string;
var
  AStrings: TStrings;
  ICount: integer;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Text := Trim(StringReplace(AFiles, ';', #13, [rfReplaceAll]));
    AStrings.Text := StringReplace(AStrings.Text, '"', '', [rfReplaceAll]);
    for ICount := 0 to AStrings.Count - 1 do
    begin
      AStrings[ICount] := Trim(AStrings[ICount]);
      AStrings[ICount] := StrEnsureNoSuffix('\', AStrings[ICount]);
      if Pos(' ', AStrings[ICount]) > 0 then
      begin
        AStrings[ICount] := StrEnsurePrefix('"', AStrings[ICount]);
        AStrings[ICount] := StrEnsureSuffix('"', AStrings[ICount]);
      end;

    end;
    Result := Trim(StringReplace(AStrings.Text, #13#10, ';', [rfReplaceAll]));
  finally
    AStrings.Free;
  end;
end;

function GetDelphiPath: string;
var
  AXml: IXmlDocument;
  APropertyGroup: IXMLNode;
  AVerNum: string;
begin
  AVerNum := C_DELPHI_11_0_VER_NUM;
  AXml := TXmlDocument.Create(GetEnvironmentVariable('APPDATA') +
    '\Embarcadero\BDS\' + AVerNum + '\environment.proj');
  APropertyGroup := AXml.ChildNodes[0].ChildNodes[0];
  Result := APropertyGroup.ChildValues['Path'];
end;

function ReplaceEnvironmentVars(APlatform: TmbPlatform; AText: string): string;
var
  AVars: TStrings;
  AXmlDoc: IXmlDocument;
  APropertyGroup: IXMLNode;
  ANode: IXMLNode;
  ICount: integer;
  AVerNum: string;
begin
  AVerNum := C_DELPHI_11_0_VER_NUM;
  AXmlDoc := TXmlDocument.Create(GetEnvironmentVariable('APPDATA') +
    '\Embarcadero\BDS\' + AVerNum + '\environment.proj');
  Result := AText;
  AVars := TStringList.Create;
  try
    APropertyGroup := (AXmlDoc.ChildNodes[0].ChildNodes[0]);
    for ICount := 0 to APropertyGroup.ChildNodes.Count - 1 do
    begin
      ANode := APropertyGroup.ChildNodes[ICount];
      Result := StringReplace(Result, '$(' + ANode.NodeName + ')', ANode.Text,
        [rfReplaceAll]);
    end;
    Result := StringReplace(Result, '$(PLATFORM)', GetPlatformString(APlatform),
      [rfReplaceAll]);
  finally
    AVars.Free;
  end;
end;

function GetDelphiLibraryPath(APlatform: TmbPlatform): string;
var
  ARegistry: TRegistry;
  AStrings: TStrings;
  APlatformStr: string;
  AVerNum: string;
begin
  Result := '';
  APlatformStr := GetPlatformString(APlatform);
  ARegistry := TRegistry.Create;
  AStrings := TStringList.Create;
  try
    ARegistry.RootKey := HKEY_CURRENT_USER;
    AVerNum := C_DELPHI_11_0_VER_NUM;
    ARegistry.OpenKey('Software\Embarcadero\BDS\' + AVerNum + '\Library\' +
      APlatformStr, False);
    Result := ARegistry.ReadString('Search Path');

    AStrings.Text := StringReplace(Result, ';', #13, [rfReplaceAll]);
    AStrings.Text := QuoteFilePaths(AStrings.Text);
    Result := Trim(AStrings.Text);
  finally
    ARegistry.Free;
    AStrings.Free;
  end;

end;

procedure ReplaceEnvironmentVars(APlatform: TmbPlatform; AStrings: TStrings);
var
  ICount: integer;
begin
  for ICount := 0 to AStrings.Count - 1 do
  begin
    AStrings[ICount] := ReplaceEnvironmentVars(APlatform, AStrings[ICount]);
  end;
end;

procedure GetConnectionProfiles(APlatform: TmbPlatform; AStrings: TStrings;
  var ADefault: string);
var
  AReg: TRegistry;
  AVerNum: string;
  AChildren: TStrings;
  AKey: string;
begin
  ADefault := '';
  AVerNum := C_DELPHI_11_0_VER_NUM;
  AReg := TRegistry.Create;
  try
    AReg.RootKey := HKEY_CURRENT_USER;
    if AReg.OpenKey('Software\Embarcadero\BDS\' + AVerNum + '\RemoteProfiles\',
      False) then
    begin
      ADefault := AReg.ReadString('Default_' + GetPlatformString(APlatform));
      if AStrings <> nil then
      begin
        AStrings.Clear;
        if ADefault <> '' then
        begin
          AChildren := TStringList.Create;
          try
            AReg.GetKeyNames(AChildren);
            for AKey in AChildren do
            begin
              AReg.OpenKey(AKey, False);
              try
                AStrings.Add(AKey + '=' + AReg.ReadString('HostName') + '|' +
                  AReg.ReadInteger('PortNumber').ToString);
              except
                // ignore, no portnumber?
              end;
              AReg.CloseKey;
            end;
          finally
            AChildren.Free;
          end;
        end;
      end;
    end;
  finally
    AReg.Free;
  end;
end;

procedure GetFrameworks(APlatform: TmbPlatform; AStrings: TStrings;
  var ADefault: string);
var
  AReg: TRegistry;
  AVerNum: string;
  AChildren: TStrings;
  AKey: string;
  APlatformStr: string;
begin
  ADefault := '';
  APlatformStr := GetPlatformString(APlatform);

  AVerNum := C_DELPHI_11_0_VER_NUM;
  AReg := TRegistry.Create;
  try
    AReg.RootKey := HKEY_CURRENT_USER;
    if AReg.OpenKey('Software\Embarcadero\BDS\' + AVerNum + '\PlatformSDKs',
      False) then
    begin
      ADefault := AReg.ReadString('Default_' + APlatformStr);
      if AStrings <> nil then
      begin
        AStrings.Clear;
        AChildren := TStringList.Create;
        try
          AReg.GetKeyNames(AChildren);
          AReg.CloseKey;

          for AKey in AChildren do
          begin

            if AReg.OpenKey('Software\Embarcadero\BDS\' + AVerNum +
              '\PlatformSDKs\' + AKey, False) then
            begin
              if Pos(APlatformStr, AReg.ReadString('PlatformName')) > 0 then
                AStrings.Add(AKey + '=' + AReg.ReadString('SDKDisplayName') +
                  '|' + AReg.ReadString('SystemRoot'));
              AReg.CloseKey;
            end;
          end;
        finally
          AChildren.Free;
        end;
      end;
    end;
  finally
    AReg.Free;
  end;
end;

// ------------------------------------------------------------------------------

function TMbProjectList.AddProject: IMbProject;
begin
  Result := TMbProject.Create;
  Add(Result);
end;

function TMbProjectList.AreBuildsRunning: Boolean;
var
  AProject: IMbProject;
begin
  Result := False;
  for AProject in Self do
  begin
    if (AProject.IosSettings.Running) or (AProject.AndroidSettings.Running) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TMbProjectList.LoadFromFile(AFilename: string);
var
  AJson: TJsonObject;
  AProject: TJsonObject;
begin
  Clear;
  AJson := TJsonObject.Create;
  try
    AJson.LoadFromFile(AFilename);
    for AProject in AJson.A['projects'] do
    begin
      AddProject.LoadFromJson(AProject);
    end;
  finally
    AJson.Free;
  end;
end;

function TMbProjectList.ProjectByFilename(AFilename: string): IMbProject;
var
  AProject: IMbProject;
begin
  Result := nil;
  for AProject in Self do
  begin
    if ChangeFileExt(AFilename.ToLower, '.dproj')
      = ChangeFileExt(AProject.Filename.ToLower, '.dproj') then
    begin
      Result := AProject;
      Exit;
    end;
  end;
end;

function TMbProjectList.ProjectExists(AFilename: string): Boolean;
var
  AProject: IMbProject;
begin
  Result := False;
  for AProject in Self do
  begin
    if ChangeFileExt(AProject.Filename, '.dpr').ToLower = ChangeFileExt
      (AFilename, '.dpr').ToLower then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

procedure TMbProjectList.SaveToFile(AFilename: string);
var
  AJson: TJsonObject;
  AProject: IMbProject;
  AObj: TJsonObject;
begin
  AJson := TJsonObject.Create;
  try
    for AProject in Self do
    begin
      AObj := TJsonObject.Create;
      AProject.SaveToJson(AObj);
      AJson.A['projects'].Add(AObj);

    end;
    AJson.SaveToFile(AFilename);
  finally
    AJson.Free;
  end;
end;

procedure TMbProjectList.SortByName;
begin
  //
end;

procedure TMbProjectList.TerminateAllBuilds;
var
  AProject: IMbProject;
begin
  for AProject in Self do
  begin
    AProject.TerminateBuilds;
  end;
end;

procedure TMbProjectList.TerminateBuild(AAppName: string;
  APlatform: TmbPlatform);
var
  AProject: IMbProject;
begin
  for AProject in Self do
  begin
    if AProject.ProjectName = AAppName then
    begin
      case APlatform of
        mbAndroid, mbAndroid64: AProject.AndroidSettings.AbortBuild;
        mbIosDevice64: AProject.IosSettings.AbortBuild;
      end;
    end;
  end;
end;

{ TMbProject }

constructor TMbProject.Create;
begin
  FAndroidSettings := TMbProjectPlatformAndroid.Create(Self);
  FIosSettings := TMbProjectPlatformIos.Create(Self);
end;

procedure TMbProject.Assign(AProject: IMbProject);
begin
  FTitle := AProject.Title;
  FFilename := AProject.Filename;
  FDelphiVersion := AProject.DelphiVersion;;
  FAndroidSettings.Assign(AProject.AndroidSettings);
  FIosSettings.Assign(AProject.IosSettings);
end;

procedure TMbProject.Build(APlatform: TmbPlatform; ADeviceID: string;
  ADeployType: TmbDeploymentType; AOnLogOutput: TTextHandler);
begin
  case APlatform of
    mbAndroid:
      FAndroidSettings.BuildASync(mbAndroid, ADeployType, ADeviceID,
        AOnLogOutput);
    mbAndroid64:
      FAndroidSettings.BuildASync(mbAndroid64, ADeployType, ADeviceID,
        AOnLogOutput);
    mbIosDevice64:
      FIosSettings.BuildASync(mbIosDevice64, ADeployType, ADeviceID,
        AOnLogOutput);
  end;
end;

function TMbProject.GetAndroidSettings: IMbProjectPlatformAndroid;
begin
  Result := FAndroidSettings;
end;

function TMbProject.GetDelphiVersion: string;
begin
  Result := FDelphiVersion;
end;

function TMbProject.GetFilename: string;
begin
  Result := FFilename;
end;

function TMbProject.GetIosSettings: IMbProjectPlatformIos;
begin
  Result := FIosSettings;
end;

function TMbProject.GetProjectDir: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(FFilename));
end;

function TMbProject.GetProjectPlatform(APlatform: TmbPlatform)
  : IMbProjectPlatform;
begin
  case APlatform of
    mbAndroid, mbAndroid64:
      Result := FAndroidSettings;
    mbIosDevice64:
      Result := FIosSettings;
  end;
end;

function TMbProject.GetTitle: string;
begin
  if Trim(FTitle) = '' then
  begin
    FTitle := ProjectName;
  end;
  Result := FTitle;
end;

procedure TMbProject.InitializeFromDproj;
var
  AXml: IXmlDocument;
  AStrings: TStrings;
begin
  AXml := TXmlDocument.Create(ChangeFileExt(FFilename, '.dproj'));

  FTitle := ProjectName;
  FIosSettings.SearchPath := GetProjectSearchPath(FFilename, mbIosDevice64);
  FIosSettings.LibraryPath := GetDelphiLibraryPath(mbIosDevice64);
  FIosSettings.Conditionals := 'RELEASE';
  FIosSettings.UnitScopeNames := 'System;Xml;Data;Datasnap;Web;Soap';
  FIosSettings.AppID := ReadPropertyGroupValue(AXml,
    GetPlatformString(mbIosDevice64), 'VerInfo_BundleId');
  FIosSettings.MinOsVersion := '11.0';
  FIosSettings.DeviceFamily := 'iPhone';
  FIosSettings.UserInterfaceStyle := 'Light';

  FAndroidSettings.SearchPath := GetProjectSearchPath(FFilename, mbAndroid64);
  FAndroidSettings.LibraryPath := GetDelphiLibraryPath(mbAndroid64);
  FAndroidSettings.Conditionals := 'RELEASE';
  FAndroidSettings.UnitScopeNames := 'System;Xml;Data;Datasnap;Web;Soap';

  AStrings := TStringList.Create;
  try
    AStrings.Delimiter := ';';
    AStrings.DelimitedText := ReadPropertyGroupValue(AXml,
      GetPlatformString(mbAndroid64), 'VerInfo_Keys');
    FAndroidSettings.AppID := AStrings.Values['package'];
    FAndroidSettings.GoogleMapsApiKey := AStrings.Values['apiKey'];
  finally
    AStrings.Free;

  end;
end;

function TMbProject.GetProjectName: string;
begin
  Result := StrBefore('.', ExtractFileName(FFilename));
end;

procedure TMbProject.LoadFromJson(AJson: TJsonObject);
begin
  FFilename := AJson.S['filename'];
  FTitle := AJson.S['title'];
  FDelphiVersion := AJson.S['delphiVersion'];

  if AJson.IndexOf('iOS') > -1 then
    FIosSettings.LoadFromJson(AJson.O['iOS'])
  else
  begin
    FIosSettings.LoadFromJson(AJson.O['settings'].O['iOSDevice64'].O
      ['projectSettings']);
    FIosSettings.Version.LoadFromJson(AJson.O['settings'].O['iOSDevice64'].O
      ['version']);
  end;
  if AJson.IndexOf('Android') > -1 then
    FAndroidSettings.LoadFromJson(AJson.O['Android'])
  else
  begin
    FAndroidSettings.LoadFromJson(AJson.O['settings'].O['Android'].O
      ['projectSettings']);
    FAndroidSettings.Version.LoadFromJson(AJson.O['settings'].O['Android'].O
      ['version'])
  end;
end;

procedure TMbProject.SaveToJson(AJson: TJsonObject);
begin
  AJson.S['filename'] := FFilename;
  AJson.S['title'] := FTitle;
  AJson.S['delphiVersion'] := FDelphiVersion;

  FIosSettings.SaveToJson(AJson.O['iOS']);
  FAndroidSettings.SaveToJson(AJson.O['Android']);
end;

procedure TMbProject.SetDelphiVersion(const Value: string);
begin
  FDelphiVersion := Value;
end;

procedure TMbProject.SetFilename(const Value: string);
begin
  FFilename := Value;
end;

procedure TMbProject.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TMbProject.TerminateBuilds;
begin
  FAndroidSettings.AbortBuild;
  FIosSettings.AbortBuild;
end;

{ TMbImage }

procedure TMbImage.Assign(ASource: IMbImage);
begin
  FID := ASource.ID;
  FFilename := ASource.Filename;
  FHeight := ASource.Height;
  FWidth := ASource.Width;
  FRemoteFolder := ASource.RemoteFolder;
  FRemoteName := ASource.RemoteName;
end;

procedure TMbImage.ClearImage;
begin
  FreeAndNil(FIcon);
  FIcon := TPngImage.Create;
end;

constructor TMbImage.Create(AID, AName: string);
begin
  inherited Create;
  FIcon := TPngImage.Create;
  FID := AID;
  FName := AName;
end;

destructor TMbImage.Destroy;
begin
  FIcon.Free;
  inherited;
end;

procedure TMbImage.DrawToCanvas(Canvas: TCanvas; ARect: TRect);
begin
  if FIcon.Empty then
    LoadIcon;

  Canvas.StretchDraw(ARect, FIcon);
end;

function TMbImage.FileExists: Boolean;
begin
  Result := SysUtils.FileExists(FFilename);
end;

procedure TMbImage.GenerateHash(ASeed: string);
begin
  FHash := THashMD5.GetHashString(ASeed + FFilename);
end;

function TMbImage.GetFilename: string;
begin
  Result := FFilename;
end;

function TMbImage.GetHash: string;
begin
  Result := FHash;
end;

function TMbImage.GetHeight: integer;
begin
  Result := FHeight;
end;

function TMbImage.GetID: string;
begin
  Result := FID;
end;

function TMbImage.GetIsIcon: Boolean;
begin
  Result := FWidth = FHeight;
end;

function TMbImage.GetName: string;
begin
  Result := FName;
end;

function TMbImage.GetOrientationStr: string;
begin
  Result := 'Portrait';
  if FWidth > FHeight then
    Result := 'Landscape';
end;

function TMbImage.GetRemoteFolder: string;
begin
  Result := FRemoteFolder;
end;

function TMbImage.GetRemoteName: string;
begin
  Result := FRemoteName;
end;

function TMbImage.GetWidth: integer;
begin
  Result := FWidth;
end;

procedure TMbImage.LoadFromJson(AJson: TJsonObject);
begin
  FFilename := AJson.S['filename'];
  FWidth := AJson.I['width'];
  FHeight := AJson.I['height'];
end;

procedure TMbImage.LoadIcon;
begin
  if (SysUtils.FileExists(FFilename)) and (FIcon.Empty) then
  begin
    FIcon.LoadFromFile(FFilename);
  end;
end;

procedure TMbImage.SaveToJson(AJson: TJsonObject);
begin
  AJson.S['id'] := FID;
  AJson.S['filename'] := FFilename;
  AJson.I['width'] := FWidth;
  AJson.I['height'] := FHeight;
end;

procedure TMbImage.SetFilename(const Value: string);
begin
  FFilename := Value;
  ClearImage;
end;

procedure TMbImage.SetHeight(const Value: integer);
begin
  FHeight := Value;
end;

procedure TMbImage.SetRemoteFolder(const Value: string);
begin
  FRemoteFolder := Value;
end;

procedure TMbImage.SetRemoteName(const Value: string);
begin
  FRemoteName := Value;
end;

procedure TMbImage.SetWidth(const Value: integer);
begin
  FWidth := Value;
end;

{ TMbImageList }

function TMbImageList.AddImage(AID, AName: string): IMbImage;
begin
  Result := TMbImage.Create(AID, AName);
  Add(Result);
end;

procedure TMbImageList.GenerateHashes;
var
  AImg: IMbImage;
begin
  Randomize;
  for AImg in Self do
    AImg.GenerateHash(IntToStr(Random(MaxInt)));
end;

function TMbImageList.GetImageByID(AID: string): IMbImage;
var
  AImg: IMbImage;
begin
  Result := nil;
  for AImg in Self do
  begin
    if AImg.ID = AID then
    begin
      Result := AImg;
      Exit;
    end;
  end;
end;

function TMbImageList.AddImage(AID, AName, AFilename: string;
  AWidth, AHeight: integer; const ARemoteFolder: string = '';
  const ARemoteName: string = ''): IMbImage;
begin
  Result := AddImage(AID, AName);
  Result.Filename := AFilename;
  Result.Width := AWidth;
  Result.Height := AHeight;
  Result.RemoteFolder := ARemoteFolder;
  Result.RemoteName := ARemoteName;
end;

procedure TMbImageList.Assign(ASource: IMbImageList);
var
  AImg: IMbImage;
begin
  Clear;
  for AImg in ASource do
    AddImage(AImg.ID, AImg.Name).Assign(AImg);
end;

function ReadMWord(f: TFileStream): word;
type
  TMotorolaWord = record
    case byte of
      0:
        (Value: word);
      1:
        (Byte1, Byte2: byte);
  end;

var
  MW: TMotorolaWord;
begin
  f.Read(MW.Byte2, SizeOf(byte));
  f.Read(MW.Byte1, SizeOf(byte));
  Result := MW.Value;
end;

procedure GetPNGSize(const sFile: string; var wWidth, wHeight: word);
type
  TPNGSig = array [0 .. 7] of byte;
const
  ValidSig: TPNGSig = (137, 80, 78, 71, 13, 10, 26, 10);
var
  Sig: TPNGSig;
  f: TFileStream;
  x: integer;
begin
  FillChar(Sig, SizeOf(Sig), #0);
  f := TFileStream.Create(sFile, fmOpenRead);
  try
    f.Read(Sig[0], SizeOf(Sig));
    for x := Low(Sig) to High(Sig) do
      if Sig[x] <> ValidSig[x] then
        Exit;
    f.Seek(18, 0);
    wWidth := ReadMWord(f);
    f.Seek(22, 0);
    wHeight := ReadMWord(f);
  finally
    f.Free;
  end;
end;

procedure TMbImageList.AddFromFile(AFile: string);
var
  AImg: IMbImage;
  w, h: word;
begin
  if FileExists(AFile) then
  begin
    try
      GetPNGSize(AFile, w, h);
      for AImg in Self do
      begin
        if (AImg.Width = w) and (AImg.Height = h) then
        begin
          AImg.Filename := AFile;
        end;
      end;
    except
      // invalid file?
    end;
  end;
end;

function TMbImageList.LargestImage: IMbImage;
var
  AImg: IMbImage;
begin
  Result := nil;
  for AImg in Self do
  begin
    if (AImg.Width > 0) and (AImg.FileExists) then
    begin
      if Result = nil then
        Result := AImg
      else
      begin
        if AImg.Width > Result.Width then
          Result := AImg;
      end;
    end;
  end;
end;

procedure TMbImageList.LoadFromFolder(AFolder: string);

  procedure ListFileDir(Path: string; FileList: TStrings);
  var
    SR: TSearchRec;
  begin
    if FindFirst(Path + '*.png', faAnyFile, SR) = 0 then
    begin
      repeat
        if (SR.Attr <> faDirectory) then
        begin
          FileList.Add(Path + SR.Name);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  end;

var
  AFiles: TStrings;
  AFile: string;
begin
  AFiles := TStringList.Create;
  try
    ListFileDir(IncludeTrailingPathDelimiter(AFolder), AFiles);
    for AFile in AFiles do
      AddFromFile(AFile);
  finally
    AFiles.Free;
  end;
end;

procedure TMbImageList.LoadFromJson(AJson: TJsonObject);
var
  AImg: TJsonObject;
begin
  for AImg in AJson.A[GetArrayName] do
  begin
    if GetImageByID(AImg.S['id']) <> nil then
      GetImageByID(AImg.S['id']).LoadFromJson(AImg);
  end;
end;

procedure TMbImageList.SaveToJson(AJson: TJsonObject);
var
  AImg: IMbImage;
  AObj: TJsonObject;
begin
  for AImg in Self do
  begin
    AObj := TJsonObject.Create;
    AImg.SaveToJson(AObj);
    AJson.A[GetArrayName].Add(AObj);
  end;
end;

{ TMbIconImageList }

function TMbIconImageList.GetArrayName: string;
begin
  Result := 'icons';
end;

{ TMbSplashImageList }

function TMbSplashImageList.GetArrayName: string;
begin
  Result := 'splash';
end;

{ TMbPlatformImages }

procedure TMbPlatformImages.Assign(ASource: IMbPlatformImages);
begin
  FIcons.Assign(ASource.Icons);
  FSplash.Assign(ASource.Splash);
end;

constructor TMbPlatformImages.Create;
begin
  FIcons := TMbIconImageList.Create;
  FSplash := TMbSplashImageList.Create;
end;

function TMbPlatformImages.GetIcons: IMbImageList;
begin
  Result := FIcons;
end;

function TMbPlatformImages.GetSplash: IMbImageList;
begin
  Result := FSplash;
end;

procedure TMbPlatformImages.LoadFromJson(AJson: TJsonObject);
begin
  FIcons.LoadFromJson(AJson.O['images']);
  FSplash.LoadFromJson(AJson.O['images']);
end;

procedure TMbPlatformImages.SaveToJson(AJson: TJsonObject);
begin
  FIcons.SaveToJson(AJson.O['images']);
  FSplash.SaveToJson(AJson.O['images']);
end;

{ TMbProjectVersion }

procedure TMbProjectVersion.Assign(ASource: IMbProjectVersion);
begin
  FMajor := ASource.Major;
  FMinor := ASource.Minor;
  FBuild := ASource.Build;
end;

function TMbProjectVersion.GetAsString: string;
begin
  Result := Format('%d.%d.%d', [FMajor, FMinor, FBuild]);
end;

function TMbProjectVersion.GetBuild: integer;
begin
  Result := FBuild;
end;

function TMbProjectVersion.GetMajor: integer;
begin
  Result := FMajor;
end;

function TMbProjectVersion.GetMinor: integer;
begin
  Result := FMinor;
end;

procedure TMbProjectVersion.LoadFromJson(AJson: TJsonObject);
begin
  FMajor := AJson.I['major'];
  FMinor := AJson.I['minor'];
  FBuild := AJson.I['build'];
end;

procedure TMbProjectVersion.SaveToJson(AJson: TJsonObject);
begin
  AJson.I['major'] := FMajor;
  AJson.I['minor'] := FMinor;
  AJson.I['build'] := FBuild;
end;

procedure TMbProjectVersion.SetBuild(const Value: integer);
begin
  FBuild := Value;
end;

procedure TMbProjectVersion.SetMajor(const Value: integer);
begin
  FMajor := Value;
end;

procedure TMbProjectVersion.SetMinor(const Value: integer);
begin
  FMinor := Value;
end;

{ TMbDeploymentFile }

procedure TMbDeploymentFile.Assign(ASource: IMbDeploymentFile);
begin
  FFilename := ASource.Filename;
  FRemoteName := ASource.RemoteName;
  FRemotePath := ASource.RemotePath;
end;

function TMbDeploymentFile.GetFilename: string;
begin
  Result := FFilename;
end;

function TMbDeploymentFile.GetRemoteName: string;
begin
  Result := FRemoteName;
end;

function TMbDeploymentFile.GetRemotePath: string;
begin
  Result := FRemotePath;
end;

procedure TMbDeploymentFile.LoadFromJson(AJson: TJsonObject);
begin
  FFilename := AJson.S['filename'];
  FRemoteName := AJson.S['remoteName'];
  FRemotePath := AJson.S['remotePath'];
end;

procedure TMbDeploymentFile.SaveToJson(AJson: TJsonObject);
begin
  AJson.S['filename'] := FFilename;
  AJson.S['remoteName'] := FRemoteName;
  AJson.S['remotePath'] := FRemotePath;
  AJson.A['platforms'].Clear;
end;

procedure TMbDeploymentFile.SetFilename(const Value: string);
begin
  FFilename := Value;
end;

procedure TMbDeploymentFile.SetRemoteName(const Value: string);
begin
  FRemoteName := Value;
end;

procedure TMbDeploymentFile.SetRemotePath(const Value: string);
begin
  FRemotePath := Value;
end;

{ TMbDeploymentFileList }

function TMbDeploymentFileList.AddFile(const AFilename: string = '')
  : IMbDeploymentFile;
begin
  Result := TMbDeploymentFile.Create;
  Result.Filename := AFilename;
  Result.RemotePath := '.\';
  Result.RemoteName := ExtractFileName(AFilename);
  Add(Result);
  SortByName;
end;

procedure TMbDeploymentFileList.Assign(ASource: IMbDeploymentFileList);
var
  AFile: IMbDeploymentFile;
begin
  Clear;
  for AFile in ASource do
  begin
    AddFile.Assign(AFile);
  end;
end;

procedure TMbDeploymentFileList.LoadFromJson(AJson: TJsonObject);
var
  AFile: TJsonObject;
begin
  for AFile in AJson.A['deployment'] do
  begin
    AddFile.LoadFromJson(AFile);
  end;
end;

procedure TMbDeploymentFileList.SaveToJson(AJson: TJsonObject);
var
  AFile: IMbDeploymentFile;
  AObj: TJsonObject;
begin
  for AFile in Self do
  begin
    AObj := TJsonObject.Create;
    AFile.SaveToJson(AObj);
    AJson.A['deployment'].Add(AObj);
  end;
end;

procedure TMbDeploymentFileList.SortByName;
begin
  Sort(TComparer<IMbDeploymentFile>.Construct(
    function(const L, R: IMbDeploymentFile): integer
    begin
      Result := CompareStr(ExtractFileName(L.Filename),
        ExtractFileName(R.Filename));
    end));
end;

{ TMbProjectPlatform }

procedure TMbProjectPlatform.AbortBuild;
begin
  FThread := nil;
  FAbort := True;
end;

procedure TMbProjectPlatform.Assign(ASource: IMbProjectPlatform);
begin
  FAppID := ASource.AppID;
  FAdMobAppID := ASource.AdMobAppID;
  FConditionals := ASource.Conditionals;
  FLibraryPath := ASource.LibraryPath;
  FSearchPath := ASource.SearchPath;
  FUnitScopeNames := ASource.UnitScopeNames;
  FUserInterfaceStyle := ASource.UserInterfaceStyle;
  FLinkerOptions := ASource.LinkerOptions;
  FSdk := ASource.Sdk;
  FConnectionProfile := ASource.ConnectionProfile;
  FVersion.Assign(ASource.Version);
  FImages.Assign(ASource.Images);
  FDeployment.Assign(ASource.DeploymentFiles);
end;

procedure TMbProjectPlatform.BuildASync(APlatform: TmbPlatform;
ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler;
const ARunDeployChecks: Boolean);
begin
  FLog.Clear;
  FErrors.Clear;
end;

procedure TMbProjectPlatform.Deploy(APlatform: TmbPlatform;
ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler);
begin
  //
end;

destructor TMbProjectPlatform.Destroy;
begin
  FErrors.Free;
  FLog.Free;
  inherited;
end;

procedure TMbProjectPlatform.CopyResource(AName, AFilename: string;
const AMergeProc: TMbMergeProc = nil);
var
  AStream: TStringStream;
  S: string;
begin
  AStream := TStringStream.Create;
  try
    GetResourceStream(AName, AStream);

    S := AStream.DataString;
    AStream.Free;

    if Assigned(AMergeProc) then
      AMergeProc(S);

    AStream := TStringStream.Create(S);
    AStream.Position := 0;
    try
      ForceDirectories(ExtractFilePath(AFilename));
      AStream.SaveToFile(AFilename);
    except
      on E: Exception do
        LogError(E.Message);
    end;

  finally
    AStream.Free;
  end;
end;

constructor TMbProjectPlatform.Create(AProject: IMbProject);
begin
  inherited Create;
  FProject := AProject;
  FDeployment := TMbDeploymentFileList.Create;
  FImages := TMbPlatformImages.Create;
  FVersion := TMbProjectVersion.Create;
  FErrors := TStringList.Create;
  FLog := TStringList.Create;
end;

function TMbProjectPlatform.GetAdMobAppID: string;
begin
  Result := FAdMobAppID;
end;

function TMbProjectPlatform.GetAppID: string;
begin
  Result := FAppID;
end;

function TMbProjectPlatform.GetConditionals: string;
begin
  Result := FConditionals;
end;

function TMbProjectPlatform.GetConnectionProfile: string;
begin
  Result := FConnectionProfile;
end;

function TMbProjectPlatform.GetDeploymentFiles: IMbDeploymentFileList;
begin
  Result := FDeployment;
end;

function TMbProjectPlatform.GetErrorCount: integer;
begin
  Result := FErrors.Count;
end;

function TMbProjectPlatform.GetImages: IMbPlatformImages;
begin
  Result := FImages;
end;

function TMbProjectPlatform.GetUserInterfaceStyle: string;
begin
  Result := FUserInterfaceStyle;
end;

function TMbProjectPlatform.GetLibraryPath: string;
begin
  Result := FLibraryPath;
end;

function TMbProjectPlatform.GetLinkerOptions: string;
begin
  Result := FLinkerOptions;
end;

function TMbProjectPlatform.GetLog: TStrings;
begin
  Result := FLog;
end;

function TMbProjectPlatform.GetProject: IMbProject;
begin
  Result := FProject;
end;

function TMbProjectPlatform.GetRunning: Boolean;
begin
  Result := False;
  if Assigned(FThread) then
    Result := (FThread.Status = TTaskStatus.Running);
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

procedure TMbProjectPlatform.KeyStoreLogText(const AText: string);
begin
  beep;
end;

procedure TMbProjectPlatform.LoadFromJson(AJson: TJsonObject);
begin
  FAppID := AJson.S['appId'];
  FAdMobAppID := AJson.S['adMobAppId'];
  FConditionals := AJson.S['conditionals'];
  FLibraryPath := AJson.S['libraryPath'];
  FSearchPath := AJson.S['searchPath'];
  FLinkerOptions := AJson.S['linkerOptions'];
  FUnitScopeNames := AJson.S['unitScopeNames'];
  FUserInterfaceStyle := AJson.S['userInterfaceStyle'];
  FSdk := AJson.S['sdk'];
  FConnectionProfile := AJson.S['connectionProfile'];

  FDeployment.LoadFromJson(AJson);
  FVersion.LoadFromJson(AJson.O['version']);
  FImages.LoadFromJson(AJson);
end;

procedure TMbProjectPlatform.LogError(const AError: string);
begin
  LogText('Error: ' + AError);
end;

procedure TMbProjectPlatform.LogText(const AText: string);
begin
  if (Trim(AText) = '') or (Pos('Connecting to ', AText) = 1) or
    (Pos('Deleting file(s) copied', AText) = 1) or
    (Pos('Deleting file(s)', AText) = 1) or
    (Pos('Total file(s) deleted', AText) = 1) or
    (Pos('Embarcadero Delphi', AText) > 0) or
    (Pos('Total file(s) copied', AText) = 1) or
    (Pos('Copying file(s)', AText) = 1) or (Pos('Copyright ', AText) = 1) or
    (Pos('Hint: ', AText) > 0) or (Pos('Warning: ', AText) > 0) or
    (Pos('Platform Assistant Client', AText) = 1) then
    Exit;
  FLog.Add(AText);
end;

function TMbProjectPlatform.RunPreBuildDeployChecks(ABuild, ADeploy: Boolean;
ADeployType: TmbDeploymentType): Boolean;
var
  AImg: IMbImage;
begin
  case ADeploy of
    False:
      LogText('Running pre-build checks for: ' + FProject.ProjectName);
    True:
      LogText('Running pre-build & deploy checks: ' + FProject.ProjectName);
  end;

  if FAppID = '' then
    LogError('Please assign an AppID in the settings');
  if FSdk = '' then
    LogError('No SDK has been selected for the project');
  if ADeploy then
  begin
    for AImg in Images.Icons do
      if AImg.FileExists = False then
        LogError('Missing icon:  ' + AImg.Name);
    for AImg in Images.Splash do
      if AImg.FileExists = False then
        LogError('Missing launch image:  ' + AImg.Name);
  end;
  Result := ErrorCount = 0;
end;

procedure TMbProjectPlatform.SaveToJson(AJson: TJsonObject);
begin
  AJson.S['appId'] := FAppID;
  AJson.S['adMobAppId'] := FAdMobAppID;
  AJson.S['conditionals'] := FConditionals;
  AJson.S['libraryPath'] := FLibraryPath;
  AJson.S['searchPath'] := FSearchPath;
  AJson.S['linkerOptions'] := FLinkerOptions;
  AJson.S['unitScopeNames'] := FUnitScopeNames;
  AJson.S['userInterfaceStyle'] := FUserInterfaceStyle;
  AJson.S['sdk'] := FSdk;
  AJson.S['connectionProfile'] := FConnectionProfile;

  FVersion.SaveToJson(AJson.O['version']);
  FDeployment.SaveToJson(AJson);
  FImages.SaveToJson(AJson);
end;

procedure TMbProjectPlatform.SetAdMobAppID(const Value: string);
begin
  FAdMobAppID := Value;
end;

procedure TMbProjectPlatform.SetAppID(const Value: string);
begin
  FAppID := Value;
end;

procedure TMbProjectPlatform.SetConditionals(const Value: string);
begin
  FConditionals := Value;
end;

procedure TMbProjectPlatform.SetConnectionProfile(const Value: string);
begin
  FConnectionProfile := Value;
end;

procedure TMbProjectPlatform.SetUserInterfaceStyle(const Value: string);
begin
  FUserInterfaceStyle := Value;
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

end.
