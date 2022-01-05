unit MonkeyBuilder.Platform.Ios;

interface

uses Windows, MonkeyBuilder_Intf, JsonDataObjects, MonkeyBuilder.Project,
  JclSysUtils, Classes, ksInspector, Mosco.Types, untMoscoUtils;

type


  {$M+}
  TMbPojectUsageDescriptions = class(TInterfacedObject, IMbProjectUsageDescriptions)
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
    procedure Assign(ASource: IMbProjectUsageDescriptions);
    procedure SaveToJson(AJson: TJsonObject);
    procedure LoadFromJson(AJson: TJsonObject);
  published
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
  {$M-}

  TMbProjectPlatformIos = class(TMbProjectPlatform, IMbProjectPlatformIos)
  private
    FFrameworkPath: string;
    FDeviceFamily: string;
    FGoogleServicePlist: TksFile;
    FMinOsVersion: string;
    FUsageDescriptions: IMbProjectUsageDescriptions;

    FProvisionCert: array[mbDeplyDevelopment..mbDeployAppStore] of string;
    FProvisionProfile: array[mbDeplyDevelopment..mbDeployAppStore] of string;

    FProfiles: TProfiles;
    FBundleID: string;

    //FAppStoreProfile: IMbiOSProfile;
    function CreateMoscoUtils: IMoscoUtils;
    function SupportsIPhone: Boolean;
    function SupportsIPad: Boolean;
    function GetReleaseFolder: string;
    function GetDeviceFamily: string;
    procedure SetDeviceFamily(const Value: string);
    function GetGoogleServicePList: TksFile;
    function GetMinOsVersion: string;
    procedure SetGoogleServicePList(const Value: TksFile);
    procedure SetMinOsVersion(const Value: string);
    function GetUsageDescriptions: IMbProjectUsageDescriptions;
    procedure GenerateBuildScript(var AScript: string);
    procedure GenerateDeployScript(AScript: TStrings; AGenerateIpa: Boolean; AProfile: TProfile; ACert: string);

    procedure GenerateResourceRulesFile;
    procedure GenerateAppIconContentsJson;

    procedure CreateLaunchScreenFiles;
    procedure MergeAppPlistFile(var AText: string);
    procedure MergeLaunchImages(var AText: string);
    procedure GetCleanupScript(AScript: TStrings);
    procedure CreateEntitlementsXml(ADeployType: TmbDeploymentType);
    //procedure MergeEntitlements(var AText: string);

    function GetProvisionCert(AType: TmbDeploymentType): string;
    procedure SetProvisionCert(AType: TmbDeploymentType; const Value: string);
    function GetProvisionProfileID(AType: TmbDeploymentType): string;
    procedure SetProvisionProfileID(AType: TmbDeploymentType; const Value: string);
    function GetFrameworkPath: string;
    procedure SetFrameworkPath(const Value: string);



  protected
    function RunPreBuildDeployChecks(ABuild, ADeploy: Boolean; ADeployType: TmbDeploymentType): Boolean; override;
    procedure Assign(ASource: IMbProjectPlatform);  override;
    procedure BuildASync(APlatform: TmbPlatform; ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler; const ARunDeployChecks: Boolean = False); override;
    procedure Deploy(APlatform: TmbPlatform; ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler); override;
    procedure SaveToJson(AJson: TJsonObject); override;
    procedure LoadFromJson(AJson: TJsonObject); override;
    property ReleaseFolder: string read GetReleaseFolder;
    property UsageDescriptions: IMbProjectUsageDescriptions read GetUsageDescriptions;

    property ProvisionCert[AType: TmbDeploymentType]: string read GetProvisionCert write SetProvisionCert;
    property ProvisionProfileID[AType: TmbDeploymentType]: string read GetProvisionProfileID write SetProvisionProfileID;

  public
    constructor Create(AProject: IMbProject); override;
  published
    property FrameworkPath: string read GetFrameworkPath write SetFrameworkPath;
    property DeviceFamily: string read GetDeviceFamily write SetDeviceFamily;
    property GoogleServicePlist: TksFile read GetGoogleServicePList write SetGoogleServicePList;
    property MinOsVersion: string read GetMinOsVersion write SetMinOsVersion;
  end;

implementation

uses SysUtils, JclFileUtils, ActiveX, JclStrings, Math, JclSysInfo,
  DateUtils, System.Threading;

{ TMbProjectPlatformIos }

procedure TMbProjectPlatformIos.Assign(ASource: IMbProjectPlatform);
var
  ADeployType: TmbDeploymentType;
begin
  inherited;
  FFrameworkPath := (ASource as IMbProjectPlatformIos).FrameworkPath;
  FDeviceFamily := (ASource as IMbProjectPlatformIos).DeviceFamily;
  FGoogleServicePlist := (ASource as IMbProjectPlatformIos).GoogleServicePlist;
  FMinOsVersion := (ASource as IMbProjectPlatformIos).MinOsVersion;
  FUsageDescriptions.Assign((ASource as IMbProjectPlatformIos).UsageDescriptions);


  for ADeployType := mbDeplyDevelopment to mbDeployAppStore do
  begin
    FProvisionProfile[ADeployType] := (ASource as IMbProjectPlatformIos).ProvisionProfileID[ADeployType];
    FProvisionCert[ADeployType] := (ASource as IMbProjectPlatformIos).ProvisionCert[ADeployType];
  end;


end;

procedure TMbProjectPlatformIos.BuildASync(APlatform: TmbPlatform;
                                      ADeployType: TmbDeploymentType;
                                      ADeviceID: string;
                                      AOnLogOutput: TTextHandler;
                                      const ARunDeployChecks: Boolean = False);
var
  AScript: string;
  ADir: string;
  pn: string;
begin
  inherited;
  if Assigned(Thread) then
  begin
    FAbort := True;
    Thread := nil;
  end;

  Thread :=  TTask.Create(
    procedure
    var
      AStart: TDateTime;
    begin
      AStart := Now;
      CoInitialize(nil);
      try
        if not (APlatform in [mbIosDevice64]) then
          raise Exception.Create('Platform not supported!');

        if RunPreBuildDeployChecks(True, ARunDeployChecks, ADeployType) = False then
          Exit;


        pn := Project.ProjectName;
        ADir := ReleaseFolder;
        if FileExists(ADir) then
          DeleteFile(ADir);
        if DirectoryExists(ADir) then
          DeleteDirectory(ADir, False);

        ForceDirectories(ReleaseFolder);

        LogText('Starting iOS build...');


        GenerateBuildScript(AScript);
        SetCurrentDir(Project.ProjectDir);

        LogText( 'Building: '+AScript);
        Execute(AScript, LogText, True, @FAbort, TJclProcessPriority.ppNormal);
        if FAbort then
          Exit;
        RenameFile(ReleaseFolder+'\'+pn, ReleaseFolder+'\'+pn);

        if ErrorCount = 0 then
        begin
          LogText('Build complete. '+FormatFloat('0.00', MilliSecondsBetween(Now, AStart) / 1000)+' seconds.');
          if (ADeployType <>  mbDeplyDevelopment) or (ADeviceID <> '') then
          begin
            Deploy(APlatform, ADeployType, ADeviceID, AOnLogOutput);
          end;
        end
        else
          LogText('Build failed with errors.');


      finally
        CoUninitialize;
      end;
    end
  );
  Thread.Start;
end;

procedure TMbProjectPlatformIos.Deploy(APlatform: TmbPlatform;
  ADeployType: TmbDeploymentType; ADeviceID: string; AOnLogOutput: TTextHandler);
var
  AScript: TStrings;
  ALine: string;
  pn: string;
  AProfile: TProfile;
  AError: string;
  ICount: integer;
begin
  inherited;

  FProfiles := CreateMoscoUtils.GetProfiles;
  for ICount := Low(FProfiles) to High(FProfiles) do
  begin
    if FProfiles[ICount].UUID = ProvisionProfileID[ADeployType] then
      AProfile := FProfiles[ICount];
  end;

  FBundleID := AProfile.BundleID;
  LogText('Using provisioning profile "'+AProfile.ProfileName+' ('+AProfile.Uuid+')" with certificate "'+ProvisionCert[ADeployType]+'")');
  pn := Project.ProjectName;
  LogText('Starting deployment...');

  CreateEntitlementsXml(ADeployType);

  CopyResource('app_info_plist', ReleaseFolder+'\'+pn+'.info.plist', MergeAppPlistFile);

  GenerateResourceRulesFile;
  Images.Splash.GenerateHashes;
  CreateLaunchScreenFiles;
  AScript := TStringList.Create;
  try
    GenerateDeployScript(AScript, ADeployType = mbDeployAppStore, AProfile, FProvisionCert[ADeployType]);
    SetCurrentDir(Project.ProjectDir);
    for ALine in AScript do
    begin
      if Pos('[REM]', ALine) = 1 then
        LogText(StrAfter('[REM]', ALine));
      Execute(ALine, LogText, True, @FAbort, TJclProcessPriority.ppNormal);
      if FAbort then
        Exit;
    end;
  finally
    AScript.Free;
  end;
  if ErrorCount = 0 then
  begin
    LogText('Copying *.ipa to build folder.');
    FileCopy(ReleaseFolder+'\'+pn+'.ipa', BuildFolder+pn+'.ipa', True);

    if ADeviceID <> '' then
    begin
      //S
    end;
    if ADeployType = mbDeployAppStore then
    begin
      LogText('Uploading to iTunesConnect...');

      CreateMoscoUtils.UploadToiTunes(Project.IosSettings.ConnectionProfile,
                                      BuildFolder+pn+'.ipa',
                                      GlobalSetting('itunesconnect', 'user'),
                                      GlobalSetting('itunesconnect', 'password'),
                                      AError);
      if AError <> '' then
        LogText(AError)
      else
        LogText('done.');
    end;


    LogText('Deployment complete.');
  end
  else
    LogText('Deployment failed with errors: '+Errors.Text);
end;

procedure TMbProjectPlatformIos.GetCleanupScript(AScript: TStrings);
var
  APaClient: string;
  pn: string;
  cp: string;
begin
  APaClient := '"'+GetPaClientExe+'"';
  pn := Project.ProjectName;
  cp := '"'+ConnectionProfile+'"';
  AScript.Add(APaClient+' -u8 -R="'+pn+'.app\..\'+pn+'.launchscreen\**\*.*" '+cp);
  AScript.Add(APaClient+' -u8 -R="'+pn+'.app\..\'+pn+'.launchscreen\Assets\AppIcon.appiconset\" '+cp);
  AScript.Add(APaClient+' -u8 -R="'+pn+'.app\..\'+pn+'.launchscreen\Assets\LaunchScreenImage.imageset\" '+cp);
  AScript.Add(APaClient+' -u8 -R="'+pn+'.app\..\'+pn+'.launchscreen\Assets\LaunchScreenBackgroundColor.colorset\" '+cp);
  AScript.Add(APaClient+' -u8 -R="'+pn+'.app\..\'+pn+'.entitlements" '+cp);
  AScript.Add(APaClient+' -u8 -R="'+pn+'.app\..\'+pn+'.launchscreen\**\*.*" '+cp);
  AScript.Add(APaClient+' -u8 -R="'+pn+'.app\**\*.*" '+cp);
  AScript.Add(APaClient+' -u8 -R="'+pn+'.app" '+cp);
end;

procedure TMbProjectPlatformIos.GenerateDeployScript(AScript: TStrings; AGenerateIpa: Boolean; AProfile: TProfile; ACert: string);
var
  pn: string;
  AImg: IMbImage;
  APaClient: string;
  cp: string;
  ADeployFile: IMbDeploymentFile;
begin
  pn := Project.ProjectName;
  cp := '"'+ConnectionProfile+'"';
  APaClient := '"'+GetPaClientExe+'"';
  GetCleanupScript(AScript);
  for AImg in Images.Icons do
  begin
    if AImg.FileExists then
      FileCopy(AImg.Filename, ReleaseFolder+'\'+pn+'.launchscreen\Assets\AppIcon.appiconset\'+AImg.Name, True);
  end;
  for AImg in Images.Splash do
  begin
    if AImg.FileExists then
      FileCopy(AImg.Filename, ReleaseFolder+'\'+pn+'.launchscreen\Assets\LaunchScreenImage.imageset\'+AImg.Hash+'.png', True);
  end;


  for ADeployFile in DeploymentFiles do
  begin
    AScript.Add(APaClient+' -u8 --put="'+ADeployFile.Filename+','+pn+'.app\'+ADeployFile.RemotePath+',1,'+ADeployFile.RemoteName+'" '+cp);
  end;

  if Project.IosSettings.GoogleServicePlist <> '' then
    AScript.Add(APaClient+' -u8 --put="'+Project.IosSettings.GoogleServicePlist+','+pn+'.app\,1,'+ExtractFilename(Project.IosSettings.GoogleServicePlist)+'" '+cp);

  AScript.Add(APaClient+' -u8 --put="'+ReleaseFolder+'\'+pn+'.launchscreen\**\*.*,'+pn+'.app\..\'+pn+'.launchscreen\,0" '+cp);
  AScript.Add(APaClient+' -u8 --put="'+ReleaseFolder+'\'+pn+','+pn+'.app\,1,'+pn+'" '+cp);
  AScript.Add(APaClient+' -u8 --put="'+ReleaseFolder+'\'+pn+'.entitlements,'+pn+'.app\..\,1,'+pn+'.entitlements" '+cp);
  AScript.Add(APaClient+' -u8 --put="'+ReleaseFolder+'\'+pn+'.info.plist,'+pn+'.app\,1,Info.plist" '+cp);

  AScript.Add('[REM]Generating asset catalog file');
  AScript.Add(APaClient+' -u8 --assetcatalog="'+pn+'.launchscreen/Assets,'+pn+'.app" '+cp);

  AScript.Add(APaClient+' -u8 --storyboard="'+pn+'.launchscreen/LaunchScreen.storyboard,'+pn+'.app" '+cp);

  if AGenerateIpa then
  begin
    AScript.Add('[REM]Codesigning app');
    AScript.Add(APaClient+' -u8 --Put="'+AProfile.FileName+','+pn+'.app,embedded.mobileprovision" '+cp);
    AScript.Add(APaClient+' -u8 --codesign="'+pn+'.app,'+ACert+','+pn+'.app\..\'+pn+'.entitlements" '+cp);
    AScript.Add(APaClient+' -u8 --ipa="'+pn+'.app,'+pn+'.ipa,'+ACert+','+AProfile.FileName+',2" '+cp);
    AScript.Add(APaClient+' --get="'+pn+'.ipa,'+ReleaseFolder+'" '+cp);
  end;
end;

procedure TmbProjectPlatformIos.CreateEntitlementsXml(ADeployType: TmbDeploymentType);
var
  AProfile: TProfile;
  AStream: TStringStream;
  AStr: string;
begin
  AProfile := CreateMoscoUtils.GetProfile(FProvisionProfile[ADeployType]);
  AStr := StringReplace(AProfile.Entitlements, '<key>Entitlements</key>', '', [rfReplaceAll, rfIgnoreCase]);
  AStr := '<?xml version="1.0" encoding="UTF-8"?>'+#10+
          '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">'+#10+
          '<plist version="1.0">'+
          AStr+#10+
          '</plist>';
  AStr := StringReplace(AStr, #13, '', [rfReplaceAll]);
  //AStr := StringReplace(AStr, '2HR3HAAL6E.*', '2HR3HAAL6E.com.kernowsoftware.irescue', []);
  AStream := TStringStream.Create(AStr, TEncoding.UTF8);
  try
    AStream.SaveToFile(ReleaseFolder+'\'+Project.ProjectName+'.entitlements');
  finally
    AStream.Free;
  end;
end;

procedure TmbProjectPlatformIos.MergeAppPlistFile(var AText: string);
var
  ADevices: string;
  pn: string;
begin
  pn := Project.ProjectName;
  AText := StringReplace(AText, '%APPNAME%', pn, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%ADMOBAPPID%', AdMobAppID, [rfReplaceAll, rfIgnoreCase]);


  AText := StringReplace(AText, '%EXECUTABLE%', pn, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%DISPLAYNAME%', Project.Title, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%APPID%', AppID, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%MAJOR%', Version.Major.ToString, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%MINOR%', Version.Minor.ToString, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%BUILD%', Version.Build.ToString, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%MinimumOSVersion%', MinOsVersion, [rfReplaceAll, rfIgnoreCase]);

  if Project.IosSettings.SupportsIPhone then ADevices := ADevices + '<integer>1</integer>';
  if Project.IosSettings.SupportsIPad then ADevices := ADevices + '<integer>2</integer>';
  AText := StringReplace(AText, '%DEVICEFAMILY%', ADevices, [rfReplaceAll, rfIgnoreCase]);

  AText := StringReplace(AText, '%NSLocationAlwaysUsageDescription%', UsageDescriptions.NSLocationAlwaysUsageDescription, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSLocationWhenInUseUsageDescription%', UsageDescriptions.NSLocationWhenInUseUsageDescription, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSLocationAlwaysAndWhenInUseUsageDescription%', UsageDescriptions.NSLocationAlwaysAndWhenInUseUsageDescription, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSContactsUsageDescription%', UsageDescriptions.NSContactsUsageDescription, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSPhotoLibraryUsageDescription%', UsageDescriptions.NSPhotoLibraryUsageDescription, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSPhotoLibraryAddUsageDescription%', UsageDescriptions.NSPhotoLibraryAddUsageDescription, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSCameraUsageDescription%', UsageDescriptions.NSCameraUsageDescription, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSFaceIDUsageDescription%', UsageDescriptions.NSFaceIDUsageDescription, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSMicrophoneUsageDescription%', UsageDescriptions.NSMicrophoneUsageDescription, [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSSiriUsageDescription%', UsageDescriptions.NSSiriUsageDescription, [rfReplaceAll, rfIgnoreCase]);


  AText := StringReplace(AText, '%NSBluetoothAlwaysUsageDescription%', '', [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSBluetoothPeripheralUsageDescription%', '', [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSCalendarsUsageDescription%', '', [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSRemindersUsageDescription%', '', [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSMotionUsageDescription%', '', [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%NSSpeechRecognitionUsageDescription%', '', [rfReplaceAll, rfIgnoreCase]);
end;

procedure TMbProjectPlatformIos.GenerateResourceRulesFile;
var
  AStrings: TStrings;
begin
  AStrings := TStringList.Create;
  try
    AStrings.Add('<?xml version="1.0" encoding="UTF-8"?>');
    AStrings.Add('<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">');
    AStrings.Add('<plist version="1.0">');
    AStrings.Add('<dict>');
    AStrings.Add('    <key>rules</key>');
    AStrings.Add('    <dict>');
    AStrings.Add('        <key>.*</key>');
    AStrings.Add('        <true/>');
    AStrings.Add('        <key>info.plist</key>');
    AStrings.Add('        <dict>');
    AStrings.Add('            <key>omit</key>');
    AStrings.Add('            <true/>');
    AStrings.Add('            <key>weight</key>');
    AStrings.Add('            <real>10</real>');
    AStrings.Add('        </dict>');
    AStrings.Add('        <key>ResourceRules.plist</key>');
    AStrings.Add('        <dict>');
    AStrings.Add('            <key>omit</key>');
    AStrings.Add('            <true/>');
    AStrings.Add('            <key>weight</key>');
    AStrings.Add('            <real>100</real>');
    AStrings.Add('        </dict>');
    AStrings.Add('    </dict>');
    AStrings.Add('</dict>');
    AStrings.Add('</plist>');
    AStrings.SaveToFile(ReleaseFolder+'\ResourceRules.plist');

  finally
    AStrings.Free;
  end;
end;


procedure TMbProjectPlatformIos.GenerateAppIconContentsJson;

  procedure AddImageJson(AImages: TJsonArray; AImgID, AIdiom: string; AScale: integer);
  var
    AObj: TJsonObject;
    AImg: IMbImage;
  begin
    AImg := Images.Icons.ImageByID[AImgID];
    if (AImg <> nil) and (AImg.FileExists) then
    begin
      AObj := TJsonObject.Create;
      AObj.S['idiom'] := AIdiom;
      AObj.S['filename'] := AImg.Name;
      AObj.S['scale'] := AScale.ToString+'x';
      AObj.S['size'] := FloatToStr(AImg.Width / AScale)+'x'+FloatToStr(AImg.Width / AScale);
      AImages.Add(AObj);
    end;
  end;
var
  AJson: TJsonObject;
  AImages: TJsonArray;
  ADir: string;
  pn: string;
begin
  pn := Project.ProjectName;

  AJson := TJsonObject.Create;
  try
    AImages := AJson.A['images'];
    AddImageJson(AImages, '{1EA07DDA-50E0-40C1-BF32-DE1AEC6AD293}', 'ios-marketing', 1);
    AddImageJson(AImages, '{7BD2F301-4ECE-41DC-8ABE-AB1053BAC345}', 'iphone', 2);
    AddImageJson(AImages, '{A6369735-DEF1-4A7A-BEA1-8CE2B1A2201F}', 'iphone', 3);
    AddImageJson(AImages, '{4E151FA3-3766-42D4-B102-AF4CB94C937F}', 'iphone', 2);
    AddImageJson(AImages, '{4FD87981-D791-44AC-AA54-25F525940BC2}', 'iphone', 3);
    AddImageJson(AImages, '{6CF74494-B5E7-4A5F-9643-B9B9550F5B12}', 'iphone', 2);
    AddImageJson(AImages, '{73BA3793-7CCB-4CA1-90E5-6E6018DC13F3}', 'iphone', 3);
    AddImageJson(AImages, '{B2A5CA57-0ABF-4ADD-88E7-A30B300CA5F7}', 'iphone', 2);
    AddImageJson(AImages, '{0DFA922A-5495-4CA8-A5FA-BFDFA3A349F5}', 'iphone', 3);
    AddImageJson(AImages, '{5F11F207-9ED3-4A54-80E3-491684D6D07D}', 'ipad', 2);
    AddImageJson(AImages, '{BA1D1FDD-E547-4A6E-BA28-EAE297A854F1}', 'ipad', 2);
    AddImageJson(AImages, '{4E151FA3-3766-42D4-B102-AF4CB94C937F}', 'ipad', 2);
    AddImageJson(AImages, '{6CF74494-B5E7-4A5F-9643-B9B9550F5B12}', 'ipad', 2);
    AddImageJson(AImages, '{B2A5CA57-0ABF-4ADD-88E7-A30B300CA5F7}', 'ipad', 2);
    AJson.O['info'].I['version'] := 1;
    AJson.O['info'].S['author'] := 'RAD Studio';

    ADir := ReleaseFolder+'\'+pn+'.launchscreen\Assets\AppIcon.appiconset';

    ForceDirectories(ADir);

    AJson.SaveToFile(ADir+'\Contents.json');
  finally
    AJson.Free;                        end;
end;

procedure TMbProjectPlatformIos.GenerateBuildScript(var AScript: string);
var
  APlatformStr: string;
  ALibPath: string;
  ASearchPath: string;
  ASdkPath: string;
  pn: string;
begin
  AScript := '';

  pn := Project.ProjectName;


  ALibPath := QuoteFilePaths(ReplaceEnvironmentVars(mbIosDevice64, LibraryPath));
  ASearchPath := QuoteFilePaths(ReplaceEnvironmentVars(mbIosDevice64, ASearchPath));
  ASdkPath := ReplaceEnvironmentVars(mbIosDevice64, '$(BDSPLATFORMSDKSDIR)\'+Sdk);
  APlatformStr := GetPlatformString(mbIosDevice64);
  AScript := AScript + '"$(BDSBIN)\dcciosarm64.exe" ';
  AScript := AScript + '-$D0 -$L- -$Y- --no-config ';
  AScript := AScript + '-B ';
  AScript := AScript + '-Q ';
  AScript := AScript + '-AGenerics.Collections=System.Generics.Collections;Generics.Defaults=System.Generics.Defaults ';
  AScript := AScript + '-D'+Conditionals+' ';
  //AScript := AScript + '-E.\'+APlatformStr+'\Release ';
  AScript := AScript + '-E"'+ReleaseFolder+'" ';
  AScript := AScript + '-I'+ALibPath+' ';
  AScript := AScript + '-LE$(BDSCOMMONDIR)\Bpl\'+APlatformStr+' ';
  AScript := AScript + '-LN$(BDSCOMMONDIR)\Dcp\'+APlatformStr+' ';
  AScript := AScript + '-NU"'+ReleaseFolder+'" ';
  AScript := AScript + '-NS'+UnitScopeNames+' ';
  AScript := AScript + '-O'+ALibPath+ASearchPath+' ';
  AScript := AScript + '-R'+ALibPath+ASearchPath+' ';
  AScript := AScript + '-U'+ALibPath+ASearchPath+' ';
  AScript := AScript + '--syslibroot:'+ASdkPath+' ';
  AScript := AScript + '--frameworkpath:'+ASdkPath+'\System\Library\Frameworks;'+ASdkPath+'\System\Library\PrivateFrameworks;'+FFrameworkPath+ ' ';
  AScript := AScript + '--linker-option:"'+LinkerOptions+' -arch arm64" ';
  AScript := AScript + '-NO"'+ReleaseFolder+'" "'+ChangeFileExt(Project.Filename, '.dpr')+'" ';
  AScript := ReplaceEnvironmentVars(mbIosDevice64, AScript);
end;



constructor TMbProjectPlatformIos.Create(AProject: IMbProject);
begin
  inherited;
  FUsageDescriptions := TMbPojectUsageDescriptions.Create;

  // add icons...
  Images.Icons.AddImage('{B2A5CA57-0ABF-4ADD-88E7-A30B300CA5F7}', 'FM_NotificationIcon_40x40.png', '', 40, 40);
  Images.Icons.AddImage('{6CF74494-B5E7-4A5F-9643-B9B9550F5B12}', 'FM_SettingIcon_58x58.png', '', 58, 58);
  Images.Icons.AddImage('{0DFA922A-5495-4CA8-A5FA-BFDFA3A349F5}', 'FM_NotificationIcon_60x60.png', '', 60, 60);
  Images.Icons.AddImage('{4E151FA3-3766-42D4-B102-AF4CB94C937F}', 'FM_SpotlightSearchIcon_80x80.png', '', 80, 80);
  Images.Icons.AddImage('{73BA3793-7CCB-4CA1-90E5-6E6018DC13F3}', 'FM_SettingIcon_87x87.png', '', 87, 87);
  Images.Icons.AddImage('{7BD2F301-4ECE-41DC-8ABE-AB1053BAC345}', 'FM_ApplicationIcon_120x120.png', '', 120, 120);
  Images.Icons.AddImage('{4FD87981-D791-44AC-AA54-25F525940BC2}', 'FM_SpotlightSearchIcon_120x120.png', '', 120, 120);
  Images.Icons.AddImage('{5F11F207-9ED3-4A54-80E3-491684D6D07D}', 'FM_ApplicationIcon_152x152.png', '', 152, 152);
  Images.Icons.AddImage('{BA1D1FDD-E547-4A6E-BA28-EAE297A854F1}', 'FM_ApplicationIcon_167x167.png', '', 167, 167);
  Images.Icons.AddImage('{A6369735-DEF1-4A7A-BEA1-8CE2B1A2201F}', 'FM_ApplicationIcon_180x180.png', '', 180, 180);
  Images.Icons.AddImage('{1EA07DDA-50E0-40C1-BF32-DE1AEC6AD293}', 'FM_ApplicationIcon_1024x1024.png', '', 1024, 1024);

  // splash
  Images.Splash.AddImage('{6477EC2E-63F5-4E3A-83FC-715ED014CB9C}', 'Launch Image 2x Scale', '', 0, 0);
  Images.Splash.AddImage('{F11ECB62-770E-4F44-99EA-8D7879C0FC54}', 'Launch Image 3x Scale', '', 0, 0);

end;

procedure TMbProjectPlatformIos.MergeLaunchImages(var AText: string);
var
  AImg2x: IMbImage;
  AImg3x: IMbImage;
begin
  AImg2x := Images.Splash.ImageByID['{6477EC2E-63F5-4E3A-83FC-715ED014CB9C}'];
  AImg3x := Images.Splash.ImageByID['{F11ECB62-770E-4F44-99EA-8D7879C0FC54}'];

  // iphone
  AText := StringReplace(AText, '%iPhone@2x%', AImg2x.Hash+'.png', [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%iPhoneDark@2x%', AImg2x.Hash+'.png', [rfReplaceAll, rfIgnoreCase]);

  AText := StringReplace(AText, '%iPhone@3x%', AImg3x.Hash+'.png', [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%iPhoneDark@3x%', AImg3x.Hash+'.png', [rfReplaceAll, rfIgnoreCase]);

  // ipad
  AText := StringReplace(AText, '%iPad@2x%', AImg2x.Hash+'.png', [rfReplaceAll, rfIgnoreCase]);
  AText := StringReplace(AText, '%iPadDark@2x%', AImg2x.Hash+'.png', [rfReplaceAll, rfIgnoreCase]);
end;

function TMbProjectPlatformIos.RunPreBuildDeployChecks(ABuild,
  ADeploy: Boolean; ADeployType: TmbDeploymentType): Boolean;
var
  AStr: string;
  AError: string;
begin
  Result := inherited;
  if CreateMoscoUtils.Ping(AError) = False then
  begin
    LogText('Error! '+AError);
    Exit;
  end;

  case ADeployType of
    mbDeplyDevelopment: AStr := 'development';
    mbDeployAppStore: AStr := 'app store';
  end;
  if (Result) then
  begin
    if ADeploy then
    begin
      if ConnectionProfile = '' then LogError('No connection profile has been selected.');
      if FProvisionCert[ADeployType] = '' then LogError('No '+AStr+' certificate selected.');
    end;
    Result := ErrorCount = 0;
  end;
end;

procedure TMbProjectPlatformIos.CreateLaunchScreenFiles;
var
  ADir: string;
  pn: string;
begin
  pn := Project.ProjectName;

  ADir :=  ReleaseFolder+'\'+pn+'.launchscreen\';
  DeleteDirectory(ADir, False);
  ForceDirectories(ADir);
  ForceDirectories(ADir+'Assets\AppIcon.appiconset');
  ForceDirectories(ADir+'Assets\LaunchScreenBackgroundColor.colorset');
  ForceDirectories(ADir+'Assets\LaunchScreenImage.imageset');
  CopyResource('storyboard_xml', ADir+'launchscreen.storyboard', nil);
  GenerateAppIconContentsJson;
  CopyResource('background_color_contents_json', ADir+'Assets\LaunchScreenBackgroundColor.colorset\Contents.json', nil);
  CopyResource('launch_screen_image_contents_json', ADir+'Assets\LaunchScreenImage.imageset\Contents.json', MergeLaunchImages);
end;


function TMbProjectPlatformIos.CreateMoscoUtils: IMoscoUtils;
begin
  Result := untMoscoUtils.CreateMoscoUtils(GlobalSetting('mosco', 'host'),
                                           StrToIntDef(GlobalSetting('mosco', 'port'), 8088));
end;

function TMbProjectPlatformIos.GetDeviceFamily: string;
begin
  Result := FDeviceFamily;
end;

function TMbProjectPlatformIos.GetFrameworkPath: string;
begin
  Result := FFrameworkPath;
end;

function TMbProjectPlatformIos.GetGoogleServicePList: TksFile;
begin
  Result := FGoogleServicePlist;
end;

function TMbProjectPlatformIos.GetMinOsVersion: string;
begin
  Result := FMinOsVersion;
end;

function TMbProjectPlatformIos.GetProvisionCert(
  AType: TmbDeploymentType): string;
begin
  Result := FProvisionCert[AType];
end;

function TMbProjectPlatformIos.GetProvisionProfileID(
  AType: TmbDeploymentType): string;
begin
  Result := FProvisionProfile[AType];
end;

function TMbProjectPlatformIos.GetReleaseFolder: string;
begin
  Result := Project.ProjectDir+'MonkeyBuilder\'+Project.ProjectName+'\iOSDevice64\Release';
end;

function TMbProjectPlatformIos.GetUsageDescriptions: IMbProjectUsageDescriptions;
begin
  Result := FUsageDescriptions;
end;

procedure TMbProjectPlatformIos.LoadFromJson(AJson: TJsonObject);
begin
  inherited;
  FFrameworkPath := AJson.S['frameworkpath'];
  FDeviceFamily := AJson.S['deviceFamily'];
  FGoogleServicePlist := AJson.S['googleServicePList'];
  FMinOsVersion := AJson.S['minOsVersion'];

  FProvisionCert[mbDeployAppStore] := AJson.O['provisioning'].S['appStoreCert'];
  FProvisionProfile[mbDeployAppStore] := AJson.O['provisioning'].S['appStoreProfileId'];

  FProvisionCert[mbDeplyDevelopment] := AJson.O['provisioning'].S['devCert'];
  FProvisionProfile[mbDeplyDevelopment] := AJson.O['provisioning'].S['devProfileId'];

  FUsageDescriptions.LoadFromJson(AJson.O['usageDescriptions']);
end;


procedure TMbProjectPlatformIos.SaveToJson(AJson: TJsonObject);
begin
  inherited;
  AJson.S['frameworkpath'] := FFrameworkPath;

  AJson.S['deviceFamily'] := FDeviceFamily;

  AJson.S['googleServicePList'] := FGoogleServicePlist;
  AJson.S['minOsVersion'] := FMinOsVersion;


  AJson.O['provisioning'].S['appStoreCert'] := FProvisionCert[mbDeployAppStore];
  AJson.O['provisioning'].S['appStoreProfileId'] := FProvisionProfile[mbDeployAppStore];

  AJson.O['provisioning'].S['devCert'] := FProvisionCert[mbDeplyDevelopment];
  AJson.O['provisioning'].S['devProfileId'] := FProvisionProfile[mbDeplyDevelopment];
  FUsageDescriptions.SaveToJson(AJson.O['usageDescriptions']);
end;

procedure TMbProjectPlatformIos.SetDeviceFamily(const Value: string);
begin
  FDeviceFamily := Value;
end;

procedure TMbProjectPlatformIos.SetFrameworkPath(const Value: string);
begin
  FFrameworkPath := Value;
end;

procedure TMbProjectPlatformIos.SetGoogleServicePList(const Value: TksFile);
begin
  FGoogleServicePlist := Value;
end;

procedure TMbProjectPlatformIos.SetMinOsVersion(const Value: string);
begin
  FMinOsVersion := Value;
end;

procedure TMbProjectPlatformIos.SetProvisionCert(AType: TmbDeploymentType;
  const Value: string);
begin
  FProvisionCert[AType] := Value;
end;

procedure TMbProjectPlatformIos.SetProvisionProfileID(AType: TmbDeploymentType;
  const Value: string);
begin
  FProvisionProfile[AType] := Value;
end;

function TMbProjectPlatformIos.SupportsIPad: Boolean;
begin
  Result := Pos('ipad', FDeviceFamily.ToLower) > 0;
end;

function TMbProjectPlatformIos.SupportsIPhone: Boolean;
begin
  Result := Pos('iphone', FDeviceFamily.ToLower) > 0;
end;

{ TMbPojectUsageDescriptions }

procedure TMbPojectUsageDescriptions.Assign(
  ASource: IMbProjectUsageDescriptions);
begin
  FNSLocationAlwaysUsageDescription := ASource.NSLocationAlwaysUsageDescription;
  FNSLocationWhenInUseUsageDescription := ASource.NSLocationWhenInUseUsageDescription;
  FNSLocationAlwaysAndWhenInUseUsageDescription := ASource.NSLocationAlwaysAndWhenInUseUsageDescription;
  FNSContactsUsageDescription := ASource.NSContactsUsageDescription;
  FNSPhotoLibraryUsageDescription := ASource.NSPhotoLibraryUsageDescription;
  FNSPhotoLibraryAddUsageDescription := ASource.NSPhotoLibraryAddUsageDescription;
  FNSCameraUsageDescription := ASource.NSCameraUsageDescription;
  FNSFaceIDUsageDescription := ASource.NSFaceIDUsageDescription;
  FNSMicrophoneUsageDescription := ASource.NSMicrophoneUsageDescription;
  FNSSiriUsageDescription := ASource.NSSiriUsageDescription;
end;

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

procedure TMbPojectUsageDescriptions.LoadFromJson(AJson: TJsonObject);
begin
  FNSLocationAlwaysUsageDescription := AJson.S['FNSLocationAlwaysUsageDescription'];
  FNSLocationWhenInUseUsageDescription := AJson.S['FNSLocationWhenInUseUsageDescription'];
  FNSLocationAlwaysAndWhenInUseUsageDescription := AJson.S['FNSLocationAlwaysAndWhenInUseUsageDescription'];
  FNSContactsUsageDescription := AJson.S['FNSContactsUsageDescription'];
  FNSPhotoLibraryUsageDescription := AJson.S['FNSPhotoLibraryUsageDescription'];
  FNSPhotoLibraryAddUsageDescription := AJson.S['FNSPhotoLibraryAddUsageDescription'];
  FNSCameraUsageDescription := AJson.S['FNSCameraUsageDescription'];
  FNSFaceIDUsageDescription := AJson.S['FNSFaceIDUsageDescription'];
  FNSMicrophoneUsageDescription := AJson.S['FNSMicrophoneUsageDescription'];
  FNSSiriUsageDescription := AJson.S['FNSSiriUsageDescription'];
end;

procedure TMbPojectUsageDescriptions.SaveToJson(AJson: TJsonObject);
begin
  AJson.S['FNSLocationAlwaysUsageDescription'] := FNSLocationAlwaysUsageDescription;
  AJson.S['FNSLocationWhenInUseUsageDescription'] := FNSLocationWhenInUseUsageDescription;
  AJson.S['FNSLocationAlwaysAndWhenInUseUsageDescription'] := FNSLocationAlwaysAndWhenInUseUsageDescription;
  AJson.S['FNSContactsUsageDescription'] := FNSContactsUsageDescription;
  AJson.S['FNSPhotoLibraryUsageDescription'] := FNSPhotoLibraryUsageDescription;
  AJson.S['FNSPhotoLibraryAddUsageDescription'] := FNSPhotoLibraryAddUsageDescription;
  AJson.S['FNSCameraUsageDescription'] := FNSCameraUsageDescription;
  AJson.S['FNSFaceIDUsageDescription'] := FNSFaceIDUsageDescription;
  AJson.S['FNSMicrophoneUsageDescription'] := FNSMicrophoneUsageDescription;
  AJson.S['FNSSiriUsageDescription'] := FNSSiriUsageDescription;
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

