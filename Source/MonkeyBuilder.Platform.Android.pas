unit MonkeyBuilder.Platform.Android;

interface

uses MonkeyBuilder_Intf, MonkeyBuilder.Project, JsonDataObjects, Spring.Collections.Lists,
  Spring.Collections, Classes, JclSysUtils, ksInspector;

type
  {$M+}
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
    procedure Assign(ASource: IMbAndroidEntitlements);
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
  published
    property AdMobService: Boolean read GetAdMobService write SetAdMobService;
    property MapsService: Boolean read GetMapsService write SetMapsService;
    property PushNotifications: Boolean read GetPushNotifications write SetPushNotifications;
    property SecureFileSharing: Boolean read GetFileSharing write SetFileSharing;
  end;
  {$M-}


  TMbAndroidPermission = class(TInterfacedObject, IMbAndroidPermission)
  private
    FTitle: string;
    FID: string;
    FDangerous: Boolean;
    function GetDangerous: Boolean;
    function GetID: string;
    function GetTitle: string;
    procedure SetDangerous(const Value: Boolean);
    procedure SetID(const Value: string);
    procedure SetTitle(const Value: string);
  protected
    property ID: string read GetID write SetID;
    property Title: string read GetTitle write SetTitle;
    property Dangerous: Boolean read GetDangerous write SetDangerous;
  end;

  TMbAndroidPermissionList = class(TList<IMbAndroidPermission>, IMbAndroidPermissionList)
  protected
    procedure AddPermission(AID, ATitle: string; const ADangerous: Boolean = False);
    procedure AddDangerousPermission(AID, ATitle: string);
    procedure BuildPermissionList;
    procedure PopulatePermissionStrings(AStrings: TStrings; ANormal, ADangerous: Boolean);
  public
    constructor Create; override;
  end;

  TMbAndroidKeystore = class(TInterfacedObject, IMbAndroidKeyStore)
  private
    FKeystoreFile: string;
    FKeyStorePassword: string;
    FAlias: string;
    FAliasPassword: string;
    FCmdOutput: TStrings;
    function GetAlias: string;
    function GetAliasPassword: string;
    function GetKeystoreFile: string;
    function GetKeystorePassword: string;
    procedure SetAlias(const Value: string);
    procedure SetAliasPassword(const Value: string);
    procedure SetKeystoreFile(const Value: string);
    procedure SetKeystorePassword(const Value: string);
  protected

    procedure Assign(ASource: IMbAndroidKeyStore);
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
    function ValidateDetails: Boolean;
    property KeystoreFile: string read GetKeystoreFile write SetKeystoreFile;
    property KeystorePassword: string read GetKeystorePassword write SetKeystorePassword;
    property Alias: string read GetAlias write SetAlias;
    property AliasPassword: string read GetAliasPassword write SetAliasPassword;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TMbProjectPlatformAndroid = class(TMbProjectPlatform, IMbProjectPlatformAndroid)
  private
    FGoogleServiceJson: TksFile;
    FMinSdkVersion: integer;
    FTargetSdkVersion: integer;
    FEntitlements: IMbAndroidEntitlements;
    FGoogleMapsApiKey: string;
    FPermissions: TStrings;
    FJarsignLog: TStrings;
    FKeyStore: IMbAndroidKeyStore;

    function GetDxBatExe(APlatform: TmbPlatform): string;
    function GetLdExe(APlatform: TmbPlatform): string;
    procedure GenerateSplashImageDefXml(APlatform: TmbPlatform);
    procedure GenerateStylesXml(APlatform: TmbPlatform);
    procedure GenerateColorsXml(APlatform: TmbPlatform);
    procedure GenerateProviderPathsXml(APlatform: TmbPlatform);
    procedure GenerateBuildScript(APlatform: TmbPlatform; var AScript: string);
    procedure MergeJarFiles(APlatform: TmbPlatform);
    function GetEntitlements: IMbAndroidEntitlements;
    function GetReleaseFolder(A32Bit: Boolean): string;
    function GetMinSdkVersion: integer;
    function GetTargetSdkVersion: integer;
    procedure SetMinSdkVersion(const Value: integer);
    procedure SetTargetSdkVersion(const Value: integer);
    procedure CopyJavaFiles(ADProj, ADir: string);
    procedure ReadProjectJarFiles(ADproj: string; AJarFiles: TStrings);
    function GetNdkLibPath(APlatform: TmbPlatform): string;
    procedure GetDeploymentScript(AScript: TStrings; ADeployType: TmbDeploymentType; APlatform: TmbPlatform);
    function GetGoogleMapsApiKey: string;
    procedure SetGoogleMapsApiKey(const Value: string);
    function GetPermissions: TStrings;
    procedure GenerateStringsXml(APlatform: TMbPlatform);
    procedure MergeManifest(var AText: string);
    function JarSignApk(APlatform: TmbPlatform; AApkFile: string; ADeployType: TmbDeploymentType): Boolean;
    function GetKeyStore: IMbAndroidKeyStore;
    procedure JarSignerLog(const AText: string);
    function GetGoogleServiceJson: TksFile;
    procedure SetGoogleServiceJson(const Value: TksFile);
    protected
    function RunPreBuildDeployChecks(ABuild, ADeploy: Boolean; ADeployType: TmbDeploymentType): Boolean; override;
    procedure Assign(ASource: IMbProjectPlatform); override;

    procedure Build(APlatform: TmbPlatform; ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler; const ARunDeployChecks: Boolean = False);

    procedure BuildASync(APlatform: TmbPlatform; ADeployType: TmbDeploymentType;
      ADeviceID: string; AOnLogOutput: TTextHandler;
      const ARunDeployChecks: Boolean = False); override;

    procedure Deploy(APlatform: TmbPlatform; ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler); override;
    procedure AddPermission(AID: string);
    procedure RemovePermission(AID: string);
    procedure SaveToJson(AJson: TJsonObject); override;
    procedure LoadFromJson(AJson: TJsonObject); override;
    property Entitlements: IMbAndroidEntitlements read GetEntitlements;
    property Permissions: TStrings read GetPermissions;
    property ReleaseFolder[A32Bit: Boolean]: string read GetReleaseFolder;
    property Keystore: IMbAndroidKeyStore read GetKeyStore;

  public
    constructor Create(AProject: IMbProject); override;
    destructor Destroy; override;
  published
    property MinSdkVersion: integer read GetMinSdkVersion write SetMinSdkVersion;
    property TargetSdkVersion: integer read GetTargetSdkVersion write SetTargetSdkVersion;
    property GoogleMapsApiKey: string read GetGoogleMapsApiKey write SetGoogleMapsApiKey;
    property GoogleServiceJson: TksFile read GetGoogleServiceJson write SetGoogleServiceJson;
  end;

implementation

uses SysUtils, JclFileUtils, XMLIntf, XMLDoc, JclStrings, ActiveX, DateUtils,
  JvStrings, System.IOUtils, untAndroidHelper, System.Threading, SyncObjs;

var
  ASection: TCriticalSection;


function TMbProjectPlatformAndroid.JarSignApk(APlatform: TmbPlatform; AApkFile: string; ADeployType: TmbDeploymentType): Boolean;
var
  AJarSigner: string;
  ks: IMbAndroidKeyStore;
begin
  ASection.Enter;
  try
    FJarsignLog.Clear;
    ks := FKeyStore;
    AJarSigner := GetSdkValueFromRegistry(APlatform, 'JDKJarsignerPath');
    if ADeployType = mbDeplyDevelopment then
    begin
      Execute('"'+AJarSigner+'" -verbose '+
              '-keystore "'+GetRoamingFolderPath+'\Embarcadero\BDS\'+C_DELPHI_11_0_VER_NUM+'\debug.keystore" "'+AApkFile+'" '+
              '-storepass "android" '+
              '"androiddebugkey" -keypass "android"',
              JarSignerLog, True, nil, TJclProcessPriority.ppNormal);
    end
    else
    begin
      Execute('"'+AJarSigner+'" -verbose '+
              '-keystore "'+ks.KeystoreFile+'" "'+AApkFile+'" '+
              '-storepass "'+ks.KeystorePassword+'" '+
              '"'+ks.Alias+'" -keypass "'+ks.AliasPassword+'"',
              JarSignerLog, True, nil, TJclProcessPriority.ppNormal);
    end;

    Result := FJarsignLog.IndexOf('jar signed.') > -1;
    if not Result then
      LogText('Error: '+Trim(FJarsignLog.Text));
  finally
    ASection.Leave;
  end;
end;


procedure TMbProjectPlatformAndroid.JarSignerLog(const AText: string);
begin
  FJarsignLog.Add(Trim(AText));
end;

function TMbProjectPlatformAndroid.GetDxBatExe(APlatform: TmbPlatform): string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(GetSdkValueFromRegistry(APlatform, 'SDKZipAlignPath')));
  Result := Result + 'dx.bat';
end;

function TMbProjectPlatformAndroid.GetLdExe(APlatform: TmbPlatform): string;
begin
  Result := GetSdkValueFromRegistry(APlatform, 'NDKArmLinuxAndroidFile');
end;

function TMbProjectPlatformAndroid.GetNdkLibPath(APlatform: TmbPlatform): string;
begin
  Result := GetSdkValueFromRegistry(APlatform, 'DelphiNDKLibraryPath');
end;

{ TMbProjectPlatformAndroid }

procedure TMbProjectPlatformAndroid.Assign(ASource: IMbProjectPlatform);
begin
  inherited;
  FMinSdkVersion := (ASource as IMbProjectPlatformAndroid).MinSdkVersion;
  FTargetSdkVersion := (ASource as IMbProjectPlatformAndroid).TargetSdkVersion;
  FGoogleMapsApiKey := (ASource as IMbProjectPlatformAndroid).GoogleMapsApiKey;
  FGoogleServiceJson := (ASource as IMbProjectPlatformAndroid).GoogleServiceJson;
  FEntitlements.Assign((ASource as IMbProjectPlatformAndroid).Entitlements);
  FPermissions.Assign((ASource as IMbProjectPlatformAndroid).Permissions);
  FKeyStore.Assign((ASource as IMbProjectPlatformAndroid).Keystore);
end;

procedure TMbProjectPlatformAndroid.MergeManifest(var AText: string);
var
  APermissions: TStrings;
  AMetaData: TStrings;
  AUsesLibrary: TStrings;
  AProviders: TStrings;
  AReceivers: TStrings;
  APerm: string;
begin
  AText := StringReplace(AText, '%MAJOR%', Version.Major.ToString, [rfReplaceAll]);
  AText := StringReplace(AText, '%MINOR%', Version.Minor.ToString, [rfReplaceAll]);
  AText := StringReplace(AText, '%BUILD%', Version.Build.ToString, [rfReplaceAll]);
  AText := StringReplace(AText, '%APPID%', AppID, [rfReplaceAll]);
  AText := StringReplace(AText, '%DISPLAYNAME%', Project.Title, [rfReplaceAll]);
  AText := StringReplace(AText, '%APPNAME%', Project.ProjectName, [rfReplaceAll]);
  AText := StringReplace(AText, '%MINSDKVERSION%', MinSdkVersion.ToString, [rfReplaceAll]);
  AText := StringReplace(AText, '%TARGETSDKVERSION%', TargetSdkVersion.ToString, [rfReplaceAll]);
  AMetaData := TStringList.Create;
  APermissions := TStringList.Create;
  AUsesLibrary := TStringList.Create;
  AProviders := TStringList.Create;
  AReceivers := TStringList.Create;
  try
    if Entitlements.MapsService then
    begin
      AddPermission('com.google.android.providers.gsf.permission.READ_GSERVICES');
      AMetaData.Add('<meta-data android:name="com.google.android.maps.v2.API_KEY" android:value="'+GoogleMapsApiKey+'" />');
      AMetaData.Add('<meta-data android:name="com.google.android.gms.version" android:value="12451000" />');
      AUsesLibrary.Add('<uses-library android:name="org.apache.http.legacy" android:required="False" />');

    end;

    for APerm in FPermissions do
      APermissions.Add('<uses-permission android:name="'+APerm+'" />');

    if Entitlements.PushNotifications then
    begin
      APermissions.Add('<permission android:name="'+AppID+'.permission.C2D_MESSAGE" android:protectionLevel="signature" /> ');
      APermissions.Add('<uses-permission android:name="'+AppID+'.permission.C2D_MESSAGE" /> ');
      APermissions.Add('<uses-permission android:name="com.google.android.c2dm.permission.RECEIVE" /> ');
    end;

    if Entitlements.SecureFileSharing then
    begin
      AProviders.Add('<provider ');
      AProviders.Add('    android:name="android.support.v4.content.FileProvider" ');
      AProviders.Add('    android:authorities="'+AppID+'.fileprovider" ');
      AProviders.Add('    android:exported="false" ');
      AProviders.Add('    android:grantUriPermissions="true"> ');
      AProviders.Add('    <meta-data ');
      AProviders.Add('        android:name="android.support.FILE_PROVIDER_PATHS" ');
      AProviders.Add('        android:resource="@xml/provider_paths" /> ');
      AProviders.Add('</provider> ');
    end;

    if (Entitlements.PushNotifications) and (FileExists(Project.AndroidSettings.GoogleServiceJson)) then
    begin
      AProviders.Add('<provider ');
      AProviders.Add('  android:name="com.embarcadero.firebase.provider.FirebaseInitProvider" ');
      AProviders.Add('  android:authorities="'+AppID+'.firebaseinitprovider" ');
      AProviders.Add('  android:exported="false" ');
      AProviders.Add('  android:initOrder="100">');
      AProviders.Add('</provider> ');

      AProviders.Add('<meta-data android:name="com.google.firebase.messaging.default_notification_color" android:resource="@color/notification_accent_color" /> ');
      AProviders.Add('<meta-data android:name="com.google.firebase.messaging.default_notification_icon" android:resource="@drawable/ic_notification" /> ');

      AProviders.Add('<service android:exported="false" android:name="com.delphiworlds.kastri.DWFirebaseMessagingService"> ');

      AProviders.Add('  <intent-filter> ');
      AProviders.Add('    <action android:name="com.google.firebase.MESSAGING_EVENT" /> ');
      AProviders.Add('  </intent-filter> ');
      AProviders.Add('</service> ');
      AProviders.Add('<service android:exported="true" android:name="com.google.firebase.messaging.FirebaseMessagingService"> ');
      AProviders.Add('  <intent-filter android:priority="-500"> ');
      AProviders.Add('    <action android:name="com.google.firebase.MESSAGING_EVENT" /> ');
      AProviders.Add('  </intent-filter> ');
      AProviders.Add('  </service> ');
      AProviders.Add('<service android:exported="false" android:name="com.google.firebase.components.ComponentDiscoveryService"> ');
      AProviders.Add('  <meta-data android:name="com.google.firebase.components:com.google.firebase.iid.Registrar" android:value="com.google.firebase.components.ComponentRegistrar" /> ');
      AProviders.Add('</service> ');
    end;

    AReceivers.Add('<receiver android:name="com.embarcadero.rtl.notifications.NotificationAlarm" />');
    if Entitlements.PushNotifications then
    begin
      AReceivers.Add('<receiver android:exported="true" android:name="com.google.firebase.iid.FirebaseInstanceIdReceiver" android:permission="com.google.android.c2dm.permission.SEND"> ');
      AReceivers.Add('      <intent-filter> ');
      AReceivers.Add('          <action android:name="com.google.android.c2dm.intent.RECEIVE" /> ');
      AReceivers.Add('      </intent-filter> ');
      AReceivers.Add('  </receiver> ');
    end;

    AText := StringReplace(AText, '%PERMISSIONS%', APermissions.Text, []);
    AText := StringReplace(AText, '%METADATA%', AMetaData.Text, []);
    AText := StringReplace(AText, '%USESLIBRARY%', AUsesLibrary.Text, []);
    AText := StringReplace(AText, '%PROVIDERS%', AProviders.Text, []);
    AText := StringReplace(AText, '%RECEIVERS%', AReceivers.Text, []);
  finally
    APermissions.Free;
    AMetaData.Free;
    AUsesLibrary.Free;
    AProviders.Free;
    AReceivers.Free;

  end;
end;

procedure TMbProjectPlatformAndroid.BuildASync(APlatform: TmbPlatform; ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler; const ARunDeployChecks: Boolean = False);
begin
  inherited;

  if Assigned(Thread) then
  begin
    FAbort := True;
    Thread := nil;
  end;

  FAbort := False;
  Thread := TTask.Create(
    procedure
    begin
      CoInitialize(nil);
      try
        Build(APlatform, ADeployType, ADeviceID, AOnLogOutput, ARunDeployChecks);
      finally
        CoUninitialize;
      end;
    end
  );
  Thread.Start;
end;

procedure TMbProjectPlatformAndroid.Build(APlatform: TmbPlatform; ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler; const ARunDeployChecks: Boolean = False);
var
  AScript: string;
  AStart: TDateTime;
begin
  inherited;
  if FAbort then
    Exit;

  AStart := now;
  if  (APlatform = mbAndroid64) then
  begin
  if (RunPreBuildDeployChecks(True, ARunDeployChecks, ADeployType) = False) then
    Exit;
  end;

  if (APlatform = mbAndroid64) and (ADeployType = mbDeployAppStore) then
    Build(mbAndroid, ADeployType, ADeviceID, AOnLogOutput);

  if (ErrorCount > 0) or (FAbort) then
    Exit;

  if not (APlatform in [mbAndroid, mbAndroid64]) then
    raise Exception.Create('Platform not supported!');

  LogText('Starting '+GetPlatformString(APlatform)+' build...');

  DeleteDirectory(ReleaseFolder[APlatform = mbAndroid], False);
  if not ForceDirectories(ReleaseFolder[APlatform = mbAndroid]) then
  begin
    LogError('Unable to create folder: '+ReleaseFolder[APlatform = mbAndroid]);
    Exit;
  end;

  CopyResource('manifest', ReleaseFolder[APlatform = mbAndroid]+'\AndroidManifest.xml', MergeManifest);


  GenerateSplashImageDefXml(APlatform);

  GenerateStylesXml(APlatform);
  GenerateColorsXml(APlatform);
  GenerateStringsXml(APlatform);
  GenerateProviderPathsXml(APlatform);

  CopyJavaFiles(Project.Filename, ReleaseFolder[APlatform = mbAndroid]);

  GenerateBuildScript(APlatform, AScript);
  MergeJarFiles(APlatform);
  SetCurrentDir(Project.ProjectDir);

  LogText( 'Building: '+AScript);

  SetCurrentDir(Project.ProjectDir);
  Execute(AScript, LogText, True, @FAbort, TJclProcessPriority.ppNormal);
  if FAbort then
    Exit;

  if ErrorCount = 0 then
  begin
    LogText('Build complete. '+FormatFloat('0.00', MilliSecondsBetween(Now, AStart) / 1000)+' seconds.');
    if (APlatform = mbAndroid64) then
    begin
      Deploy(APlatform, ADeployType, ADeviceID, AOnLogOutput);
    end;
  end
  else
    LogText('Build failed with errors.');
end;

procedure TMbProjectPlatformAndroid.GetDeploymentScript(AScript: TStrings; ADeployType: TmbDeploymentType; APlatform: TmbPlatform);
var
  APaClient: string;
  AImg: IMbImage;
  APlatStr: string;
  pn: string;
  AStripExe: string;
  AAptExe: string;
  AApt2Exe: string;
  AAndroidPath: string;
  AJarSigner: string;
  AJdkPath: string;
  AZipAlign: string;
  ADeployFile: IMbDeploymentFile;
  ARelDir: string;
  AAndroidJar: string;
begin
  APaClient := '"'+GetPaClientExe+'"';
  APlatStr := GetPlatformString(APlatform);
  pn := Project.ProjectName;
  ARelDir := GetReleaseFolder(False);

  AStripExe := GetSdkValueFromRegistry(APlatform, 'NDKArmLinuxAndroidStripFile');
  AAptExe := GetSdkValueFromRegistry(APlatform, 'SDKAaptPath');
  AApt2Exe := StringReplace(GetSdkValueFromRegistry(APlatform, 'SDKAaptPath'), 'aapt.exe', 'aapt2.exe', [rfIgnoreCase]);
  AAndroidPath := GetSdkValueFromRegistry(APlatform, 'SDKApiLevelPath');
  AJarSigner := GetSdkValueFromRegistry(APlatform, 'JDKJarsignerPath');
  AJdkPath := GetSdkValueFromRegistry(APlatform, 'JDKPath');
  AZipAlign := GetSdkValueFromRegistry(APlatform, 'SDKZipAlignPath');
  AAndroidJar := IncludeTrailingPathDelimiter(AAndroidPath)+'android.jar';


  for AImg in Images.Icons do
  begin
    if AImg.FileExists then
      AScript.Add(APaClient+' -u8 --put="'+AImg.Filename+','+ARelDir+'\'+pn+'\res\'+AImg.RemoteFolder+'\,1,'+AImg.RemoteName+'" ');
  end;

  for AImg in Images.Splash do
  begin
    if AImg.FileExists then
      AScript.Add(APaClient+' -u8 --put="'+AImg.Filename+','+ARelDir+'\'+pn+'\res\'+AImg.RemoteFolder+'\,1,'+AImg.RemoteName+'" ');
  end;

  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\provider_paths.xml,'+ARelDir+'\'+pn+'\res\xml\,1,provider_paths.xml" ');
  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\lib'+pn+'.so,'+ARelDir+'\'+pn+'\library\lib\arm64-v8a\,1,lib'+pn+'.so" ');



  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\styles.xml,'+ARelDir+'\'+pn+'\res\values\,1,styles.xml" ');
  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\strings.xml,'+ARelDir+'\'+pn+'\res\values\,1,strings.xml" ');
  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\colors.xml,'+ARelDir+'\'+pn+'\res\values\,1,colors.xml" ');


  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\classes.dex,'+ARelDir+'\'+pn+'\classes\,1,classes.dex" ');
  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\AndroidManifest.xml,'+ARelDir+'\'+pn+'\,1,AndroidManifest.xml" ');
  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\styles-v21.xml,'+ARelDir+'\'+pn+'\res\values-v21\,1,styles.xml" ');
  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\splash_image_def.xml,'+ARelDir+'\'+pn+'\res\drawable\,1,splash_image_def.xml" ');

  for ADeployFile in DeploymentFiles do
  begin
    AScript.Add(APaClient+' -u8 --put="'+ADeployFile.Filename+','+ARelDir+'\'+pn+'\'+ADeployFile.RemotePath+',1,'+ADeployFile.RemoteName+'" ');
  end;

  if ADeployType = mbDeployAppStore then
  begin
    // 32 bit...
    AScript.Add(APaClient+' -u8 --put="'+GetReleaseFolder(True)+'\lib'+pn+'.so,'+ARelDir+'\'+pn+'\library\lib\armeabi-v7a\,1,lib'+pn+'.so" ');
    AScript.Add(APaClient+' -u8 --stripdebug="'+AStripExe+','+ ARelDir+'\'+pn+'\library\lib\arm64-v8a\..\armeabi-v7a\lib'+pn+'.so"" ');
  end;

  AScript.Add(APaClient+' -u8 --put="'+ARelDir+'\lib'+pn+'.so,'+ARelDir+'\'+pn+'\library\lib\arm64-v8a\,1,lib'+pn+'.so" ');


  AScript.Add('[CMD]COPY_TO_DEBUG_FOLDER');

  AScript.Add(APaClient+' -u8 --stripdebug="'+AStripExe+','+ ARelDir+'\'+pn+'\debug\lib'+pn+'.so,'+ARelDir+'\'+pn+'\library\lib\arm64-v8a\lib'+pn+'.so" ');


  AScript.Add('[REM]Generating app file (*.apk)');
  AScript.Add(APaClient+' -u8 --aaptpackage="'+AAptExe+','+ARelDir+'\'+pn+'\library,'+ARelDir+'\'+pn+'\classes,'+ARelDir+'\'+pn+'\res,'+ARelDir+'\'+pn+'\assets,'+ARelDir+'\'+pn+'\AndroidManifest.xml,'+AAndroidPath+'\android.jar,'+ARelDir+'\'+pn+'\bin\'+pn+'-unsigned.apk" ');
  AScript.Add('[REM]Codesigning app (*.apk)');
  AScript.Add('[CMD]SIGN_APK');
  AScript.Add('[REM]zipalign app (*.apk)');

  AScript.Add(APaClient+' -u8 --zipalign="'+AZipAlign+','+ARelDir+'\'+pn+'\bin\'+pn+'-unsigned.apk,'+ARelDir+'\'+pn+'\bin\'+pn+'.apk,4" ');


  if ADeployType = mbDeployAppStore then
  begin
    AScript.Add('[REM]Generating  app bundle (*.aab)');

    AScript.Add(APaClient+' -u8 --appbundle="'+
                AJdkPath+'\bin\java.exe,'+
                AApt2Exe+','+
                '$(BDSBIN)\android\bundletool-all-1.2.0.jar,'+
                ARelDir+'\'+pn+'\library,'+
                ARelDir+'\'+pn+'\classes,'+
                ARelDir+'\'+pn+'\res,'+
                ARelDir+'\'+pn+'\assets,'+
                ARelDir+'\'+pn+'\AndroidManifest.xml,'+
                AAndroidPath+'\android.jar,'+
                ARelDir+'\'+pn+'\bin\'+pn+'-unsigned.aab"');

    AScript.Add('[REM]Codesigning app bundle (*.aab)');
    AScript.Add('[CMD]SIGN_AAB');
    AScript.Add('[CMD]RENAME_TO_AAB');
  end;
  AScript.Text := ReplaceEnvironmentVars(APlatform, AScript.Text);
end;


constructor TMbProjectPlatformAndroid.Create(AProject: IMbProject);
begin
  inherited;
  FEntitlements := TMbAndroidEntitlements.Create;
  FPermissions := TStringList.Create;
  FKeyStore := TMbAndroidKeystore.Create;
  FJarsignLog := TStringList.Create;
  FMinSdkVersion := 23;
  FTargetSdkVersion := 29;

  // icon images...
  Images.Icons.AddImage('{b0f117f2-deca-4b64-b79c-fc226259370a}', 'Launcher Icon 36x36', '', 36, 36, 'drawable-ldpi', 'ic_launcher.png');
  Images.Icons.AddImage('{2f34f363-2116-4c6c-8ae3-e46de5a26d4c}', 'Launcher Icon 48x48', '', 48, 48, 'drawable-mdpi', 'ic_launcher.png');
  Images.Icons.AddImage('{0520f530-9566-4a52-8fa7-0df1d04ee1d1}', 'Launcher Icon 72x72', '', 72, 72, 'drawable-hdpi', 'ic_launcher.png');
  Images.Icons.AddImage('{BD1424EF-6C6C-4165-AE0E-D7694B6D8081}', 'Launcher Icon 96x96', '', 96, 96, 'drawable-xhdpi', 'ic_launcher.png');
  Images.Icons.AddImage('{39e25e86-24f7-4b8a-87a5-58c5be79ac22}', 'Launcher Icon 144x144', '', 144, 144, 'drawable-xxhdpi', 'ic_launcher.png');
  Images.Icons.AddImage('{e9cb006b-11bd-4b9d-b133-1bdb9e0fa158}', 'Notification Icon 24x24', '', 24, 24, 'drawable-mdpi', 'ic_notification.png');
  Images.Icons.AddImage('{e023adac-9744-4d40-bb97-ab0f47b9d0e8}', 'Notification Icon 36x36', '', 36, 36, 'drawable-hdpi', 'ic_notification.png');
  Images.Icons.AddImage('{e51ec057-2722-4be1-af11-7c2883c5b399}', 'Notification Icon 48x48', '', 48, 48, 'drawable-xhdpi', 'ic_notification.png');
  Images.Icons.AddImage('{36762509-8c7d-424c-94f2-b25c3fca577c}', 'Notification Icon 72x72', '', 72, 72, 'drawable-xxhdpi', 'ic_notification.png');
  Images.Icons.AddImage('{9d97d994-3278-48a2-8468-eb406c16328d}', 'Notification Icon 96x96', '', 96, 96, 'drawable-xxxhdpi', 'ic_notification.png');
  Images.Icons.AddImage('{05904711-80CF-4380-8225-2FBCA32066B0}', 'Launcher Icon 192x192', '', 192, 192, 'drawable-xxxhdpi', 'ic_launcher.png');

  Images.Splash.AddImage('{15ea997f-2cbe-4d28-b109-226fc70ad308}', 'Launch Image 640x480', '', 640, 480, 'drawable-large', 'splash_image.png');
  Images.Splash.AddImage('{1625fd90-0454-46ea-a207-88e802050bad}', 'Launch Image 470x320', '', 470, 320, 'drawable-normal', 'splash_image.png');
  Images.Splash.AddImage('{32556240-34c2-4263-aa1d-95706a0a83e8}', 'Launch Image 426x320', '', 426, 320, 'drawable-small', 'splash_image.png');
  Images.Splash.AddImage('{fd3a0a44-4807-4422-8ff2-491a3abc79d4}', 'Launch Image 960x720', '', 960, 720, 'drawable-xlarge', 'splash_image.png');
end;




procedure TMbProjectPlatformAndroid.Deploy(APlatform: TmbPlatform;
  ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler);
var
  AScript: TStrings;
  ALine: string;
  AReleaseDir: string;
  pn: string;
  ACmd: string;
  ABinDir: string;
begin
  inherited;
  LogText('Starting deployment...');
  AReleaseDir := ReleaseFolder[False]+'\';
  ABinDir := AReleaseDir+Project.ProjectName+'\bin\';
  pn := Project.ProjectName;

  ForceDirectories(AReleaseDir+pn+'\bin\');
  ForceDirectories(AReleaseDir+pn+'\assets\');
  ForceDirectories(AReleaseDir+pn+'\debug\');

  AScript := TStringList.Create;
  try
    GetDeploymentScript(AScript, ADeployType, APlatform);
    SetCurrentDir(Project.ProjectDir);
    for ALine in AScript do
    begin
        LogText(StrAfter('[REM]', Trim(ALine)));

      if Trim(ALine) <> '' then
      begin
        if Pos('[CMD]', ALine) = 1 then
        begin
          ACmd := StrAfter('[CMD]', ALine);
          if ACmd = 'COPY_TO_DEBUG_FOLDER' then FileCopy(ReleaseFolder[False]+'\lib'+pn+'.so', ReleaseFolder[False]+'\'+pn+'\debug\lib'+pn+'.so');
          if ACmd = 'RENAME_TO_AAB' then
          begin
            FileCopy(ABinDir+pn+'-unsigned.aab', ABinDir+pn+'.aab', True );
            FileDelete(ABinDir+pn+'-unsigned.aab');
          end;
          if ACmd = 'SIGN_APK' then if not JarSignApk(APlatform, ABinDir+pn+'-unsigned.apk', ADeployType) then Exit;
          if ACmd = 'SIGN_AAB' then if not JarSignApk(APlatform, ABinDir+pn+'-unsigned.aab', ADeployType) then Exit;
          if ACmd = 'DELETE_APK' then FileDelete(ABinDir+pn+'-unsigned.apk');
        end
        else
          Execute(ALine, LogText, True, @FAbort, TJclProcessPriority.ppNormal);
      end;
    end;
  finally
    AScript.Free;
  end;
  if ErrorCount = 0 then
  begin
    LogText('Copying '+pn+'.apk & '+pn+'.aab to build folder.');
    FileCopy(ABinDir+pn+'.apk', BuildFolder+Project.ProjectName+'.apk', True);
    FileCopy(ABinDir+pn+'.aab', BuildFolder+Project.ProjectName+'.aab', True);


    CreateAndroidHelper.InstallApk(ADeviceID, BuildFolder+Project.ProjectName+'.apk', AppID);

    LogText('Deployment complete.');
  end
  else
    LogText('Deployment failed with errors: '+Errors.Text);
end;

destructor TMbProjectPlatformAndroid.Destroy;
begin
  FPermissions.Free;
  FJarsignLog.Free;
  inherited;
end;

procedure TMbProjectPlatformAndroid.GenerateBuildScript(APlatform: TmbPlatform; var AScript: string);
var
  ACompiler: string;
  APlatformStr: string;
  ALibPath: string;
  ASearchPath: string;
  ARelDir: string;
begin
  AScript := '';
  ARelDir := ReleaseFolder[APlatform = mbAndroid];

  ALibPath := QuoteFilePaths(ReplaceEnvironmentVars(APlatform, LibraryPath));
  ASearchPath := QuoteFilePaths(ReplaceEnvironmentVars(APlatform, SearchPath));

  case APlatform of
    mbAndroid: ACompiler := 'dccaarm.exe';
    mbAndroid64: ACompiler := 'dccaarm64.exe';
  end;
  APlatformStr := GetPlatformString(APlatform);
  AScript := AScript + '"$(BDSBIN)\'+ACompiler+'" ';
  AScript := AScript + '-$D0 -$L- -$Y- --no-config ';
  AScript := AScript + '-B ';
  AScript := AScript + '-Q ';
  AScript := AScript + '-TX.so ';
  AScript := AScript + '-AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults ';
  AScript := AScript + '-D'+Conditionals+' ';
  AScript := AScript + '-E"'+ReleaseFolder[APlatform=mbAndroid]+'" ';

  AScript := AScript + '-I'+ALibPath+' ';
  AScript := AScript + '-LE$(BDSCOMMONDIR)\Bpl\'+APlatformStr+' ';
  AScript := AScript + '-LN$(BDSCOMMONDIR)\Dcp\'+APlatformStr+' ';
  AScript := AScript + '-NU"'+ReleaseFolder[APlatform=mbAndroid]+'" ';

  AScript := AScript + '-NS'+UnitScopeNames+' ';
  AScript := AScript + '-O'+ALibPath+ASearchPath+' ';
  AScript := AScript + '-R'+ALibPath+ASearchPath+' ';
  AScript := AScript + '-U'+ALibPath+ASearchPath+' ';
  AScript := AScript + '--libpath:'+GetNdkLibPath(APlatform)+'  ';
  AScript := AScript + '--linker:'+GetLdExe(APlatform)+' ';
  AScript := AScript + '-NO"'+ReleaseFolder[APlatform=mbAndroid]+'" "'+ChangeFileExt(Project.Filename, '.dpr')+'" ';

  AScript := ReplaceEnvironmentVars(APlatform, AScript);
end;

procedure TMbProjectPlatformAndroid.GenerateSplashImageDefXml(APlatform: TmbPlatform);
var
  AStrings: TStrings;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Add('<?xml version="1.0" encoding="utf-8"?>');
    AStrings.Add('<layer-list xmlns:android="http://schemas.android.com/apk/res/android" android:opacity="opaque">');
    AStrings.Add('<item android:drawable="@android:color/black" />');
    AStrings.Add('<item>');
    AStrings.Add('<bitmap');
    AStrings.Add('android:src="@drawable/splash_image"');
    AStrings.Add('android:antialias="true"');
    AStrings.Add('android:dither="true"');
    AStrings.Add('android:filter="true"');
    AStrings.Add('android:gravity="center"');
    AStrings.Add('android:tileMode="disabled"/>');
    AStrings.Add('</item>');
    AStrings.Add('</layer-list>');
    AStrings.SaveToFile(ReleaseFolder[APlatform = mbAndroid]+'\splash_image_def.xml');
  finally
    AStrings.Free;
  end;
end;

procedure TMbProjectPlatformAndroid.GenerateStylesXml(APlatform: TmbPlatform);
var
  AStrings: TStrings;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Add('<resources xmlns:android="http://schemas.android.com/apk/res/android">');
    AStrings.Add('<style name="AppTheme" parent="@android:style/Theme.NoTitleBar">');
    AStrings.Add('<item name="android:windowBackground">@drawable/splash_image_def</item>');
    AStrings.Add('<item name="android:windowNoTitle">true</item>');
    AStrings.Add('</style>');
    AStrings.Add('</resources>');
    AStrings.SaveToFile(ReleaseFolder[APlatform = mbAndroid]+'\styles.xml');

    AStrings.Clear;
    AStrings.Add('<resources xmlns:android="http://schemas.android.com/apk/res/android">');
    AStrings.Add('<style name="AppTheme" parent="@android:style/Theme.Material.Light.NoActionBar">');
    AStrings.Add('    <item name="android:windowBackground">@drawable/splash_image_def</item>');
    AStrings.Add('    <item name="android:windowClipToOutline">false</item>');
    AStrings.Add('</style>');
    AStrings.Add('</resources>');
    AStrings.SaveToFile(ReleaseFolder[APlatform = mbAndroid]+'\styles-v21.xml');

  finally
    AStrings.Free;
  end;
end;

procedure TMbProjectPlatformAndroid.GenerateStringsXml(APlatform: TMbPlatform);
var
  AStrings: TStrings;
  AJson: TJsonObject;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Add('<?xml version="1.0" encoding="utf-8"?>');
    AStrings.Add('<resources xmlns:android="http://schemas.android.com/apk/res/android">');

    if (Entitlements.PushNotifications) and (FileExists(FGoogleServiceJson)) then
    begin
      AJson := TJsonObject.Create;
      try
        AJson.LoadFromFile(FGoogleServiceJson);

        AStrings.Add('<string name="google_app_id">'+AJson.A['client'][0].O['client_info'].S['mobilesdk_app_id']+'</string>');
        AStrings.Add('<string name="gcm_defaultSenderId">'+AJson.O['project_info'].S['project_number']+'</string>');
        AStrings.Add('<string name="fcm_fallback_notification_channel_label" translatable="false">Notification channel for Firebase</string>');
      finally
        AJson.Free;
      end;
    end;
    AStrings.Add('</resources>');
    AStrings.SaveToFile(ReleaseFolder[APlatform = mbAndroid]+'\strings.xml');
  finally
    AStrings.Free;
  end;

end;

procedure TMbProjectPlatformAndroid.GenerateColorsXml(APlatform: TmbPlatform);
var
  AStrings: TStrings;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Add('<?xml version="1.0" encoding="utf-8"?>');
    AStrings.Add('<resources xmlns:android="http://schemas.android.com/apk/res/android">');
    AStrings.Add('<color name="notification_accent_color">#000000</color>');
    AStrings.Add('</resources>');
    AStrings.SaveToFile(ReleaseFolder[APlatform = mbAndroid]+'\colors.xml');
  finally
    AStrings.Free;
  end;
end;

procedure TMbProjectPlatformAndroid.GenerateProviderPathsXml(APlatform: TmbPlatform);
var
  AStrings: TStrings;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Add('<?xml version="1.0" encoding="utf-8"?>');
    AStrings.Add('<paths xmlns:android="http://schemas.android.com/apk/res/android">');
    AStrings.Add('<files-path name="internal_private_files" path="." />');
    AStrings.Add('<cache-path name="internal_cache_files" path="." />');
    AStrings.Add('<external-path name="external_public_files" path="." />');
    AStrings.Add('<external-files-path name="external_private_files" path="." />');
    AStrings.Add('<external-cache-path name="external_cache_files" path="." />');
    AStrings.Add('<external-media-path name="external_media_files" path="." />');
    AStrings.Add('</paths>');
    AStrings.SaveToFile(ReleaseFolder[APlatform = mbAndroid]+'\provider_paths.xml');
  finally
    AStrings.Free;
  end;
end;




function TMbProjectPlatformAndroid.GetPermissions: TStrings;
begin
  Result := FPermissions;
end;


function TMbProjectPlatformAndroid.GetEntitlements: IMbAndroidEntitlements;
begin
  Result := FEntitlements;
end;

function TMbProjectPlatformAndroid.GetGoogleMapsApiKey: string;
begin
  Result := FGoogleMapsApiKey;
end;

function TMbProjectPlatformAndroid.GetGoogleServiceJson: TksFile;
begin
  Result := FGoogleServiceJson;
end;

function TMbProjectPlatformAndroid.GetKeyStore: IMbAndroidKeyStore;
begin
  Result := FKeyStore;
end;

function TMbProjectPlatformAndroid.GetMinSdkVersion: integer;
begin
  Result := FMinSdkVersion;
end;

function TMbProjectPlatformAndroid.GetReleaseFolder(A32Bit: Boolean): string;
begin
  case A32Bit of
    True: Result := Project.ProjectDir+'MonkeyBuilder\'+Project.ProjectName+'\Android\Release';
    False: Result := Project.ProjectDir+'MonkeyBuilder\'+Project.ProjectName+'\Android64\Release';
  end;
end;

function TMbProjectPlatformAndroid.GetTargetSdkVersion: integer;
begin
  Result := FTargetSdkVersion;
end;

procedure TMbProjectPlatformAndroid.LoadFromJson(AJson: TJsonObject);
var
  APerm: string;
begin
  inherited;
  FEntitlements.LoadFromJson(AJson.O['entitlements']);
  FGoogleMapsApiKey := AJson.S['googleMapApiKey'];
  FGoogleServiceJson := AJson.S['googleServiceJson'];
  FPermissions.Clear;

  if AJson.Values['permissions'].Typ = TJsonDataType.jdtArray then
  begin
    for APerm in AJson.A['permissions'] do
    begin
      FPermissions.Add(APerm)
    end;
  end
  else
    FPermissions.CommaText := AJson.S['permissions'];
  FKeyStore.LoadFromJson(AJson.O['keystore']);
end;

procedure TMbProjectPlatformAndroid.MergeJarFiles(APlatform: TmbPlatform);
var
  AMergeJars: TStrings;
  AJarFiles: TStrings;
  APath: string;
  AJar: string;
  AJarStr: string;
  ADexFile: string;
  AReleaseDir: string;
begin
  AReleaseDir := ReleaseFolder[APlatform = mbAndroid];
  AMergeJars := TStringList.Create;
  AJarFiles := TStringList.Create;
  try
    AMergeJars.Text := 'PATH %path% & "%DX_BAT%" --dex --output="%releaseDir%\classes.dex" %jar_files%';
    AMergeJars.Text := StringReplace(AMergeJars.Text, '%PROJECTNAME%', Project.ProjectName, [rfReplaceAll]);
    AMergeJars.Text := StringReplace(AMergeJars.Text, '%DX_BAT%', GetDxBatExe(APlatform), [rfReplaceAll]);
    APath := GetSdkValueFromRegistry(APlatform, 'JDKPath')+'\bin;'+GetDelphiPath;
    AMergeJars.Text := StringReplace(AMergeJars.Text, '%path%', APath, []);
    AMergeJars.Text := StringReplace(AMergeJars.Text, '%releaseDir%', AReleaseDir, []);

    ReadProjectJarFiles(Project.Filename, AJarFiles);
    AJarStr := '';
    for AJar in AJarFiles do
      AJarStr := AJarStr + ' "'+AJar+'"';
    AMergeJars.Text := StringReplace(AMergeJars.Text, '%jar_files%', AJarStr, []);

    ReplaceEnvironmentVars(APlatform, AMergeJars);
    if AJarFiles.Count > 0 then
    begin
      LogText('Merging '+AJarFiles.Count.ToString+' *.jar files into classes.dex file.');
      SetCurrentDir(Project.ProjectDir);

      Execute(StrAfter('& ', AMergeJars[0]), nil, True, nil, TJclProcessPriority.ppNormal);

    end
    else
    begin
      ADexFile := ReplaceEnvironmentVars(APlatform, '$(BDSLIB)\'+PlatformToStr(APlatform)+'\release\classes.dex');
      FileCopy(ADexFile, ReleaseFolder[APlatform = mbAndroid]+'\classes.dex', True);
    end;
  finally
    AMergeJars.Free;
    AJarFiles.Free;
  end;
end;

procedure TMbProjectPlatformAndroid.SaveToJson(AJson: TJsonObject);
var
  APerm: string;
begin
  inherited SaveToJson(AJson);
  AJson.S['googleMapApiKey'] := FGoogleMapsApiKey;
  AJson.S['googleServiceJson'] := FGoogleServiceJson;
  FEntitlements.SaveToJson(AJson.O['entitlements']);
  for APerm in FPermissions do
  begin
    AJson.A['permissions'].Add(APerm);
  end;
  FKeyStore.SaveToJson(AJson.O['keystore']);
end;

procedure TMbProjectPlatformAndroid.SetGoogleMapsApiKey(const Value: string);
begin
  FGoogleMapsApiKey := Value;
end;

procedure TMbProjectPlatformAndroid.SetGoogleServiceJson(const Value: TksFile);
begin
  FGoogleServiceJson := Value;
end;

procedure TMbProjectPlatformAndroid.SetMinSdkVersion(const Value: integer);
begin
  FMinSdkVersion := Value;
end;

procedure TMbProjectPlatformAndroid.SetTargetSdkVersion(const Value: integer);
begin
  FTargetSdkVersion := Value;
end;

procedure TMbProjectPlatformAndroid.ReadProjectJarFiles(ADproj: string; AJarFiles: TStrings);
var
  AXml: IXMLDocument;
  ICount: integer;
  ICount2: integer;
  ANode: IXMLNode;
  AValue: IXMLNode;
  AFiles: TStrings;

begin
  AXml := TXmlDocument.Create(ADproj);
  AFiles := TStringList.Create;
  try
    AFiles.Delimiter := ';';
    for ICount := 0 to AXml.ChildNodes[0].ChildNodes.Count-1 do
    begin
      ANode := AXml.ChildNodes[0].ChildNodes[ICOunt];
      if ANode.HasAttribute('Condition') then
      begin
        if (ANode.NodeName = 'PropertyGroup') and ((ANode.Attributes['Condition']) = '''$(Base_Android64)''!=''''') then
        begin
          AValue := ANode.ChildNodes.FindNode('EnabledSysJars');
          if AValue <> nil then
          begin
            AFiles.DelimitedText := AValue.Text;
            AJarFiles.Assign(AFiles);
            for ICount2 := 0 to AJarFiles.Count-1 do
            begin
              if Trim(AJarFiles[ICount2]) <> '' then
                AJarFiles[ICount2] := '$(BDSLIB)\android\Release\'+AJarFiles[ICount2];
            end;


          end;
        end;


      end;
      if (ANode.NodeName = 'ItemGroup') then
      begin
        for ICount2 := 0 to ANode.ChildNodes.Count-1 do
        begin
          AValue := ANode.ChildNodes[ICount2];
          if AValue.NodeName = 'JavaReference' then
          begin
            AJarFiles.Add(AValue.Attributes['Include']);
          end;
        end;
      end;
    end;

  finally
    AFiles.Free;
  end;
end;

procedure TMbProjectPlatformAndroid.AddPermission(AID: string);
var
  AStrings: TStrings;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Assign(FPermissions);
    AStrings.Text := AStrings.Text.ToLower;
    if AStrings.IndexOf(AID.ToLower) = -1 then
      FPermissions.Add(AID);
  finally
    AStrings.Free;
  end;
end;

procedure TMbProjectPlatformAndroid.RemovePermission(AID: string);
var
  AStrings: TStrings;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Assign(FPermissions);
    AStrings.Text := AStrings.Text.ToLower;
    if AStrings.IndexOf(AID.ToLower) > -1 then
      FPermissions.Delete(AStrings.IndexOf(AID.ToLower));
  finally
    AStrings.Free;
  end;
end;

function TMbProjectPlatformAndroid.RunPreBuildDeployChecks(ABuild,
  ADeploy: Boolean; ADeployType: TmbDeploymentType): Boolean;
begin
  Result := inherited;
  if (Result) and (ADeploy) then
  if ADeploy then
  begin
    if FileExists(Keystore.KeystoreFile) = False then LogError('Keystore file not found. Please check in Android->Keystore settings.');

    if Trim(Keystore.Alias) = '' then LogError('No keystore alias selected. Please check in Android->Keystore settings.');
    if ErrorCount = 0 then
    begin
      if not FKeyStore.ValidateDetails then LogError('Invalid keystore credentials. Please check in Android->Keystore settings.');
    end;
    Result := ErrorCount = 0;
  end;
end;

procedure TMbProjectPlatformAndroid.CopyJavaFiles(ADProj, ADir: string);
var
  AFiles: TStrings;
  AFile: string;
begin
  AFiles := TStringList.Create;
  try
    ReadProjectJarFiles(ADProj, AFiles);
    for AFile in AFiles do
      FileCopy(AFile, IncludeTrailingPathDelimiter(ADir)+ExtractFileName(AFile));
  finally
    AFiles.Free;
  end;
end;

{ TMbAndroidEntitlements }

procedure TMbAndroidEntitlements.Assign(ASource: IMbAndroidEntitlements);
begin
  FMapsService := ASource.MapsService;
  FPushNotifications := ASource.PushNotifications;
  FAdMobService := ASource.AdMobService;
  FSecureFileSharing := ASource.SecureFileSharing;
end;

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



{ TMbAndroidPermission }

function TMbAndroidPermission.GetDangerous: Boolean;
begin
  Result := FDangerous;
end;

function TMbAndroidPermission.GetID: string;
begin
  Result := FID;
end;

function TMbAndroidPermission.GetTitle: string;
begin
  Result := FTitle;
end;

procedure TMbAndroidPermission.SetDangerous(const Value: Boolean);
begin
  FDangerous := Value;
end;

procedure TMbAndroidPermission.SetID(const Value: string);
begin
  FID := Value;
end;

procedure TMbAndroidPermission.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

{ TMbAndroidPermissionList }

procedure TMbAndroidPermissionList.AddDangerousPermission(AID, ATitle: string);
begin
  AddPermission(AID, ATitle, True);
end;

procedure TMbAndroidPermissionList.AddPermission(AID, ATitle: string; const ADangerous: Boolean = False);
var
  APermission: IMbAndroidPermission;
begin
  APermission := TMbAndroidPermission.Create;
  APermission.ID := AID;
  APermission.Title := ATitle;
  APermission.Dangerous := ADangerous;
  Add(APermission);
end;

procedure TMbAndroidPermissionList.BuildPermissionList;
begin
  AddPermission('android.permission.INTERNET',                          'Internet');
  AddPermission('android.permission.WAKE_LOCK',                         'Wake Lock');
  AddPermission('android.permission.ACCESS_NETWORK_STATE',              'Access Network State');
  AddPermission('com.android.vending.BILLING',                          'Vending Billing (In-App Billing)');

  // dangerous
  AddDangerousPermission('android.permission.READ_PHONE_STATE',         'Read Phone State');
  AddDangerousPermission('android.permission.READ_CONTACTS',            'Get Contacts');
  AddDangerousPermission('android.permission.ACCESS_COARSE_LOCATION',   'Access Course Location');
  AddDangerousPermission('android.permission.ACCESS_FINE_LOCATION',     'Access Fine Location');
  AddDangerousPermission('android.permission.CALL_PHONE',               'Call Phone');
  AddDangerousPermission('android.permission.SEND_SMS',                 'Send SMS');
  AddDangerousPermission('android.permission.CAMERA',                   'Camera');
  AddDangerousPermission('android.permission.GET_ACCOUNTS',             'Get Accounts');
  AddDangerousPermission('android.permission.READ_EXTERNAL_STORAGE',    'Read External Storage');
  AddDangerousPermission('android.permission.WRITE_EXTERNAL_STORAGE',   'Write External Storage');
end;



constructor TMbAndroidPermissionList.Create;
begin
  inherited;
  BuildPermissionList;
end;

procedure TMbAndroidPermissionList.PopulatePermissionStrings(AStrings: TStrings;
  ANormal, ADangerous: Boolean);
var
  p: IMbAndroidPermission;
begin
  AStrings.Clear;
  for p in Self do
  begin
    if ((ANormal) and (p.Dangerous = False)) or
       ((ADangerous) and (p.Dangerous)) then
      AStrings.AddObject(p.Title, TObject(p));
  end;
end;

{ TMbAndroidKeystore }

procedure TMbAndroidKeystore.Assign(ASource: IMbAndroidKeyStore);
begin
  FKeystoreFile := ASource.KeystoreFile;
  FKeyStorePassword := ASource.KeystorePassword;
  FAlias := ASource.Alias;
  FAliasPassword := ASource.AliasPassword;
end;

constructor TMbAndroidKeystore.Create;
begin
  FCmdOutput := TStringList.Create;
end;

destructor TMbAndroidKeystore.Destroy;
begin
  FCmdOutput.Free;
  inherited;
end;

function TMbAndroidKeystore.GetAlias: string;
begin
  Result := FAlias;
end;

function TMbAndroidKeystore.GetAliasPassword: string;
begin
  Result := FAliasPassword;
end;

function TMbAndroidKeystore.GetKeystoreFile: string;
begin
  Result := FKeystoreFile;
end;

function TMbAndroidKeystore.GetKeystorePassword: string;
begin
  Result := FKeyStorePassword;
end;

procedure TMbAndroidKeystore.LoadFromJson(AJson: TJsonObject);
begin
  FKeystoreFile := AJson.S['keystore'];
  FKeyStorePassword := DescryptString(AJson.S['keyStorePass']);
  FAlias := Trim(AJson.S['alias']);
  FAliasPassword := DescryptString(AJson.S['aliasPass']);
end;

procedure TMbAndroidKeystore.SaveToJson(AJson: TJsonObject);
begin
  AJson.S['keystore'] := FKeystoreFile;
  AJson.S['keyStorePass'] := EncryptString(FKeyStorePassword);
  AJson.S['alias'] := FAlias;
  AJson.S['aliasPass'] := EncryptString(FAliasPassword);
end;

procedure TMbAndroidKeystore.SetAlias(const Value: string);
begin
  FAlias := Value;
end;

procedure TMbAndroidKeystore.SetAliasPassword(const Value: string);
begin
  FAliasPassword := Value;
end;

procedure TMbAndroidKeystore.SetKeystoreFile(const Value: string);
begin
  FKeystoreFile := Value;
end;

procedure TMbAndroidKeystore.SetKeystorePassword(const Value: string);
begin
  FKeyStorePassword := Value;
end;

function TMbAndroidKeystore.ValidateDetails: Boolean;
begin
  Result := CreateAndroidHelper.ValidateKeystore(FKeystoreFile, FKeyStorePassword, FAlias, FAliasPassword);
end;

initialization

  ASection := TCriticalSection.Create;

finalization

  ASection.Free;

end.

