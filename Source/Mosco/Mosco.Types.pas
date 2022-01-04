unit Mosco.Types;

interface

uses
  System.JSON, System.Types;

type
  TClientStatus = (Connected, Disconnected);

  TProfileKind = (Development, AdHoc, AppStore);

  TProfile = record
    AppID: string;
    BundleID: string;
    CertDescriptions: TArray<string>;
    CreationDate: TDateTime;
    Entitlements: string;
    ExpiryDate: TDateTime;
    TaskAllow: Boolean; // part of entitlements (<get-task-allow>)
    FileName: string;
    PlatformName: string;
    ProfileName: string;
    ProvisionedDevices: TArray<string>;
    UUID: string;
    procedure FromJson(const AValue: string);
    procedure FromJsonValue(const AValue: TJSONValue);
    function GetProfileKind: TProfileKind;
    function IsValid: Boolean;
    function ToJsonValue: TJSONValue;
  end;

  TProfiles = TArray<TProfile>;

  TProfilesHelper = record helper for TProfiles
  public
    function FindIndex(const AFileName: string; var AIndex: Integer): Boolean;
    procedure FromJson(const AValue: string);
    procedure FromJsonValue(const AValue: TJSONValue);
    function ToJsonValue: TJSONValue;
  end;

  TIdentity = record
    Description: string;
    Expiry: TDateTime;
    function LongDescription: string;
    procedure FromJson(const AValue: string);
    procedure FromJsonValue(const AValue: TJSONValue);
    function ToJsonValue: TJSONValue;
  end;

  TIdentities = TArray<TIdentity>;

  TIdentitiesHelper = record helper for TIdentities
  public
    procedure FromJson(const AValue: string);
    procedure FromJsonValue(const AValue: TJSONValue);
    function ToJsonValue: TJSONValue;
    function ToText(const ASeparator: string): string;
  end;

  TCodesignInfo = record
    Identity: string;
    Target: string;
  end;

  TALToolInfo = record
    AppleID: string;
    BundleID: string;
    CertName: string;
    Password: string;
    Provider: string;
    StapleTicket: Boolean;
    Target: string;
    // TeamID: string;
    function IsPackage: Boolean;
  end;

  TACToolInfo = record
    BuildType: Integer;
    InfoPlist: string;
    MinVersion: string;
    PlatformName: string;
    PlatformVersion: string;
    Target: string; // this is the path to the app
    SendCar: Boolean;
  end;

  TAppIconImage = record
    Filename: string;
    Idiom: string;
    Scale: string;
    Size: string;
    ImageSize: TSizeF;
    function Description: string;
    procedure FromJsonValue(const AValue: TJSONValue);
    function ToJsonValue: TJSONValue;
  end;

  TAppIconImages = TArray<TAppIconImage>;

  TAppIconImagesHelper = record helper for TAppIconImages
  public
    function Count: Integer;
    function FindMatching(const ASourcePath, ADestPath: string): Boolean;
    function FindBySize(const AWidth, AHeight: Single; out AImage: TAppIconImage): Boolean;
    procedure FromJsonValue(const AValue: TJSONValue);
    function ToJsonValue: TJSONValue;
  end;

  TContentsInfo = record
    Author: string;
    Version: string;
    procedure FromJsonValue(const AValue: TJSONValue);
    function ToJsonValue: TJSONValue;
  end;

  TAppIconContents = record
    Images: TAppIconImages;
    Info: TContentsInfo;
    procedure FromJson(const AValue: string);
    procedure FromJsonValue(const AValue: TJSONValue);
    function ToJsonValue: TJSONValue;
    function ToJson: string;
  end;

  TProvider = record
    Name: string;
    PublicID: string;
    ShortName: string;
    WWDRTeamID: string;
    function DisplayValue: string;
  end;

  TProviders = TArray<TProvider>;

  TEmbeddedLibrary = record
    Code: Integer;
    Content: string;
    FileName: string;
    DestinationPath: string;
    Error: string;
    procedure FromJsonValue(const AValue: TJSONValue);
    function GetErrorMessage: string;
    function ToJsonValue: TJSONValue;
  end;

  TEmbeddedLibraries = TArray<TEmbeddedLibrary>;

  TEmbeddedLibrariesHelper = record helper for TEmbeddedLibraries
  public
    procedure FromJson(const AValue: string);
    procedure FromJsonValue(const AValue: TJSONValue);
    function GetErrorMessages: string;
    function ToJsonValue: TJSONValue;
  end;

{
  TErrorInfo = record
    Action: string;
    Code: Integer;
    ErrorMessage: string;
  end;
}

  TPingInfo = record
    Version: string;
  end;

  TSelectedLibrary = record
    FileName: string;
    DestinationPath: string;
  end;

  TSelectedLibraries = TArray<TSelectedLibrary>;

implementation

uses
  System.SysUtils, System.DateUtils, System.Generics.Collections, System.IOUtils, System.Math,
  {$IF Defined(MACOS)}
  Macapi.AppKit, Macapi.Helpers,
  Mosco.Logger, Mosco.Config,
  {$ENDIF}
  DW.Base64.Helpers;

{ TProfile }

procedure TProfile.FromJsonValue(const AValue: TJSONValue);
var
  LValue: string;
  LJSONArray: TJSONArray;
  I: Integer;
begin
  CertDescriptions := [];
  ProvisionedDevices := [];
  CreationDate := 0;
  ExpiryDate := 0;
  AValue.TryGetValue('AppID', AppID);
  AValue.TryGetValue('BundleID', BundleID);
  AValue.TryGetValue('CertDescriptions', LJSONArray);
  if LJSONArray <> nil then
  begin
    for I := 0 to LJSONArray.Count - 1 do
      CertDescriptions := CertDescriptions + [LJSONArray.Items[I].Value];
  end;
  AValue.TryGetValue('ProvisionedDevices', LJSONArray);
  if LJSONArray <> nil then
  begin
    for I := 0 to LJSONArray.Count - 1 do
      ProvisionedDevices := ProvisionedDevices + [LJSONArray.Items[I].Value];
  end;
  AValue.TryGetValue('CreationDate', LValue);
  if not LValue.IsEmpty then
    CreationDate := ISO8601ToDate(LValue)   ;
  AValue.TryGetValue('Entitlements', LValue);
  Entitlements := TBase64Helper.DecodeDecompress(LValue);
  AValue.TryGetValue('ExpiryDate', LValue);
  if not LValue.IsEmpty then
    ExpiryDate := ISO8601ToDate(LValue);
  AValue.TryGetValue('FileName', FileName);
  AValue.TryGetValue('PlatformName', PlatformName);
  AValue.TryGetValue('ProfileName', ProfileName);
  AValue.TryGetValue('UUID', UUID);
  AValue.TryGetValue('TaskAllow', TaskAllow);
end;

function TProfile.GetProfileKind: TProfileKind;
begin
  if TaskAllow then
    Result := TProfileKind.Development
  else if Length(ProvisionedDevices) > 0 then
    Result := TProfileKind.AdHoc
  else
    Result := TProfileKind.AppStore;
end;

function TProfile.IsValid: Boolean;
begin
  Result := not BundleID.IsEmpty and not ProfileName.IsEmpty and (Length(CertDescriptions) > 0);
end;

function TProfile.ToJsonValue: TJSONValue;
var
  LJSON: TJSONObject;
  LJSONArray: TJSONArray;
  I: Integer;
begin
  LJSON := TJSONObject.Create;
  LJSON.AddPair('AppID', AppID);
  LJSON.AddPair('BundleID', BundleID);
  LJSON.AddPair('CreationDate', DateToISO8601(CreationDate));
  LJSON.AddPair('Entitlements', TBase64Helper.CompressEncode(Entitlements));
  LJSON.AddPair('ExpiryDate', DateToISO8601(ExpiryDate));
  LJSON.AddPair('FileName', FileName);
  LJSON.AddPair('TaskAllow', TJSONBool.Create(TaskAllow));
  LJSON.AddPair('PlatformName', PlatformName);
  LJSON.AddPair('ProfileName', ProfileName);
  LJSON.AddPair('UUID', UUID);
  LJSONArray := TJSONArray.Create;
  for I := 0 to Length(CertDescriptions) - 1 do
    LJSONArray.Add(CertDescriptions[I]);
  LJSON.AddPair('CertDescriptions', LJSONArray);
  LJSONArray := TJSONArray.Create;
  for I := 0 to Length(ProvisionedDevices) - 1 do
    LJSONArray.Add(ProvisionedDevices[I]);
  LJSON.AddPair('ProvisionedDevices', LJSONArray);
  Result := LJSON;
end;

procedure TProfile.FromJson(const AValue: string);
var
  LJSON: TJSONValue;
begin
  LJSON := TJSONObject.ParseJSONValue(AValue);
  if LJSON <> nil then
  try
    FromJsonValue(LJSON);
  finally
    LJSON.Free;
  end;
end;

{ TProfilesHelper }

function TProfilesHelper.FindIndex(const AFileName: string; var AIndex: Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Length(Self) - 1 do
  begin
    if Self[I].FileName.Equals(AFileName) then
    begin
      AIndex := I;
      Exit(True);
    end;
  end;
end;

procedure TProfilesHelper.FromJson(const AValue: string);
var
  LJSON: TJSONValue;
begin
  LJSON := TJSONObject.ParseJSONValue(AValue);
  if LJSON <> nil then
  try
    FromJsonValue(LJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TProfilesHelper.FromJsonValue(const AValue: TJSONValue);
var
  LJSON: TJSONArray;
  I: Integer;
  LProfile: TProfile;
begin
  if AValue is TJSONArray then
  begin
    LJSON := TJSONArray(AValue);
    for I := 0 to LJSON.Count - 1 do
    begin
      LProfile.FromJSONValue(LJSON.Items[I]);
      Self := Self + [LProfile];
    end;
  end;
end;

function TProfilesHelper.ToJsonValue: TJSONValue;
var
  LJSONArray: TJSONArray;
  I: Integer;
begin
  LJSONArray := TJSONArray.Create;
  for I := 0 to Length(Self) - 1 do
    LJSONArray.AddElement(Self[I].ToJsonValue);
  Result := LJSONArray;
end;

{ TIdentity }

procedure TIdentity.FromJson(const AValue: string);
var
  LJSON: TJSONValue;
begin
  LJSON := TJSONObject.ParseJSONValue(AValue);
  if LJSON <> nil then
  try
    FromJsonValue(LJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TIdentity.FromJsonValue(const AValue: TJSONValue);
var
  LValue: string;
begin
  AValue.TryGetValue('Description', Description);
  AValue.TryGetValue('Expiry', LValue);
  if not LValue.IsEmpty then
    Expiry := ISO8601ToDate(LValue);
end;

function TIdentity.LongDescription: string;
begin
  if Expiry > 0 then
    Result := Format('%s [Expires %s]', [Description, FormatDateTime('dd-MMM-yyyy', Expiry)])
  else
    Result := Description;
end;

function TIdentity.ToJsonValue: TJSONValue;
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;
  LJSON.AddPair('Description', Description);
  LJSON.AddPair('Expiry', DateToISO8601(Expiry));
  Result := LJSON;
end;

{ TIdentitiesHelper }

function TIdentitiesHelper.ToText(const ASeparator: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(Self) - 1 do
  begin
    Result := Result + AnsiQuotedStr(Self[I].Description, '"');
    if I < Length(Self) - 1 then
      Result := Result + ASeparator;
  end;
end;

procedure TIdentitiesHelper.FromJson(const AValue: string);
var
  LJSON: TJSONValue;
begin
  LJSON := TJSONObject.ParseJSONValue(AValue);
  if LJSON <> nil then
  try
    FromJsonValue(LJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TIdentitiesHelper.FromJsonValue(const AValue: TJSONValue);
var
  LJSON: TJSONArray;
  I: Integer;
  LIdentity: TIdentity;
begin
  if AValue is TJSONArray then
  begin
    LJSON := TJSONArray(AValue);
    for I := 0 to LJSON.Count - 1 do
    begin
      LIdentity.FromJSONValue(LJSON.Items[I]);
      Self := Self + [LIdentity];
    end;
  end;
end;

function TIdentitiesHelper.ToJsonValue: TJSONValue;
var
  LJSONArray: TJSONArray;
  I: Integer;
begin
  LJSONArray := TJSONArray.Create;
  for I := 0 to Length(Self) - 1 do
    LJSONArray.AddElement(Self[I].ToJsonValue);
  Result := LJSONArray;
end;

{ TALToolInfo }

function TALToolInfo.IsPackage: Boolean;
begin
  Result := Target.EndsWith('.pkg');
end;

{ TAppIconImage }

function TAppIconImage.Description: string;
begin
  Result := Format('Idiom: %s, Scale: %S, Size: %s', [Idiom, Scale, Size]);
end;

procedure TAppIconImage.FromJsonValue(const AValue: TJSONValue);
var
  LSizeParts: TArray<string>;
  LScale: Integer;
  LFormatSettings: TFormatSettings;
begin
  AValue.TryGetValue('filename', Filename);
  AValue.TryGetValue('idiom', Idiom);
  AValue.TryGetValue('scale', Scale);
  LScale := StrToIntDef(Scale.Substring(0, Length(Scale) - 1), 0);
  if AValue.TryGetValue('size', Size) and (LScale > 0) then
  begin
    LSizeParts := Size.Split(['x'], 2);
    if Length(LSizeParts) = 2 then
    begin
      LFormatSettings := TFormatSettings.Create;
      LFormatSettings.DecimalSeparator := '.';
      TryStrToFloat(LSizeParts[0], ImageSize.cx, LFormatSettings);
      TryStrToFloat(LSizeParts[1], ImageSize.cy, LFormatSettings);
      ImageSize.cx := ImageSize.cx * LScale;
      ImageSize.cy := ImageSize.cy * LScale;
    end;
  end;
end;

function TAppIconImage.ToJsonValue: TJSONValue;
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;
  if not Filename.IsEmpty then
    LJSON.AddPair('filename', Filename);
  LJSON.AddPair('idiom', Idiom);
  LJSON.AddPair('scale', Scale);
  LJSON.AddPair('size', Size);
  Result := LJSON;
end;

{ TContentsInfo }

procedure TContentsInfo.FromJsonValue(const AValue: TJSONValue);
begin
  AValue.TryGetValue('author', Author);
  AValue.TryGetValue('version', Version);
end;

function TContentsInfo.ToJsonValue: TJSONValue;
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;
  LJSON.AddPair('author', Author);
  LJSON.AddPair('version', Version);
  Result := LJSON;
end;

{ TAppIconContents }

procedure TAppIconContents.FromJson(const AValue: string);
var
  LJSON: TJSONValue;
begin
  LJSON := TJSONObject.ParseJSONValue(AValue);
  if LJSON <> nil then
  try
    FromJsonValue(LJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TAppIconContents.FromJsonValue(const AValue: TJSONValue);
var
  LValue: TJSONValue;
begin
  if AValue.TryGetValue('images', LValue) then
    Images.FromJsonValue(LValue);
  if AValue.TryGetValue('info', LValue) then
    Info.FromJsonValue(LValue);
end;

function TAppIconContents.ToJson: string;
var
  LJSONValue: TJSONValue;
begin
  LJSONValue := ToJsonValue;
  try
    Result := LJSONValue.ToJSON;
  finally
    LJSONValue.Free;
  end;
end;

function TAppIconContents.ToJsonValue: TJSONValue;
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;
  LJSON.AddPair('images', Images.ToJsonValue);
  LJSON.AddPair('info', Info.ToJsonValue);
  Result := LJSON;
end;

{$IF Defined(MACOS)}
function GetImageSize(const AImage: NSImage): TPoint;
var
  LRep: NSImageRep;
  I: Integer;
begin
  Result := TPoint.Create(Trunc(AImage.size.width), Trunc(AImage.size.height));
  for I := 0 to AImage.representations.count - 1 do
  begin
    LRep := TNSImageRep.Wrap(AImage.representations.objectAtIndex(I));
    if LRep.pixelsWide > Result.X then
      Result.X := LRep.pixelsWide;
    if LRep.pixelsHigh > Result.Y then
      Result.Y := LRep.pixelsHigh;
  end;
end;
{$ENDIF}

{ TAppIconImagesHelper }

function TAppIconImagesHelper.Count: Integer;
begin
  Result := Length(Self);
end;

function TAppIconImagesHelper.FindBySize(const AWidth, AHeight: Single; out AImage: TAppIconImage): Boolean;
var
  LImage: TAppIconImage;
begin
  Result := False;
  for LImage in Self do
  begin
    if (LImage.ImageSize.cx = AWidth) and (LImage.ImageSize.cy = AHeight) then
    begin
      AImage := LImage;
      Exit(True);
    end;
  end;
end;

function TAppIconImagesHelper.FindMatching(const ASourcePath, ADestPath: string): Boolean;
{$IF Defined(MACOS)}
var
  LIconImage: TAppIconImage;
  LImage: NSImage;
  LImageSize: TPoint;
  LFile, LCopyToFileName: string;
  I: Integer;
begin
  Result := True;
  LImage := TNSImage.Wrap(TNSImage.OCClass.alloc);
  if TMoscoConfig.Current.ShowDeepDiagnostics then
    TLogger.Log('Searching image files in ' + ASourcePath);
  for LFile in TDirectory.GetFiles(ASourcePath, '*.png', TSearchOption.soTopDirectoryOnly) do
  begin
    LImage.initWithContentsOfFile(StrToNSStr(LFile));
    LImageSize := GetImageSize(LImage);
    if TMoscoConfig.Current.ShowDeepDiagnostics then
      TLogger.Log(TPath.GetFileName(LFile) + Format(' is %d x %d', [LImageSize.X, LImageSize.Y]));
    for I := 0 to Length(Self) - 1 do
    begin
      LIconImage := Self[I];
      if (Trunc(LIconImage.ImageSize.cx) = LImageSize.X) and (Trunc(LIconImage.ImageSize.cy) = LImageSize.Y) then
        Self[I].Filename := TPath.GetFileName(LFile);
    end;
  end;
  if TMoscoConfig.Current.ShowDeepDiagnostics then
    TLogger.Log('Checking files against AppIconConfig');
  for I := 0 to Length(Self) - 1 do
  begin
    LIconImage := Self[I];
    LCopyToFileName := TPath.Combine(ADestPath, LIconImage.Filename);
    if not LIconImage.Filename.IsEmpty then
    begin
      if TMoscoConfig.Current.ShowDeepDiagnostics then
        TLogger.Log(LIconImage.Description + ' matched with: ' + TPath.GetFileName(LIconImage.Filename));
      if not TFile.Exists(LCopyToFileName) then
        TFile.Copy(TPath.Combine(ASourcePath, LIconImage.Filename), LCopyToFileName);
    end
    else
    begin
      TLogger.Log('Did not find a matching image for: ' + LIconImage.Description);
      Result := False; // Does not exit - just indicates that not all images were found
    end;
  end;
end;
{$ELSE}
begin
  Result := False;
end;
{$ENDIF}

procedure TAppIconImagesHelper.FromJsonValue(const AValue: TJSONValue);
var
  LJSON: TJSONArray;
  I: Integer;
  LImage: TAppIconImage;
begin
  if AValue is TJSONArray then
  begin
    LJSON := TJSONArray(AValue);
    for I := 0 to LJSON.Count - 1 do
    begin
      LImage.FromJSONValue(LJSON.Items[I]);
      Self := Self + [LImage];
    end;
  end;
end;

function TAppIconImagesHelper.ToJsonValue: TJSONValue;
var
  LJSONArray: TJSONArray;
  I: Integer;
begin
  LJSONArray := TJSONArray.Create;
  for I := 0 to Length(Self) - 1 do
    LJSONArray.AddElement(Self[I].ToJsonValue);
  Result := LJSONArray;
end;

{ TProvider }

function TProvider.DisplayValue: string;
begin
  Result := Format('%s (%s)', [Name, ShortName]);
end;

{ TEmbeddedLibrary }

procedure TEmbeddedLibrary.FromJsonValue(const AValue: TJSONValue);
begin
  AValue.TryGetValue('code', Code);
  AValue.TryGetValue('content', Content);
  AValue.TryGetValue('error', Error);
  AValue.TryGetValue('filename', FileName);
  AValue.TryGetValue('destpath', DestinationPath);
end;

function TEmbeddedLibrary.GetErrorMessage: string;
begin
  if Code <> 0 then
    Result := Format('Signing %s failed with exit code: %d, message: %s', [TPath.GetFileNameWithoutExtension(FileName), Code, Error])
  else
    Result := '';
end;

function TEmbeddedLibrary.ToJsonValue: TJSONValue;
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create;
  LJSON.AddPair('code', TJSONNumber.Create(Code));
  LJSON.AddPair('content', Content);
  LJSON.AddPair('error', Error);
  LJSON.AddPair('filename', FileName);
  LJSON.AddPair('destpath', DestinationPath);
  Result := LJSON;
end;

{ TEmbeddedLibrariesHelper }

procedure TEmbeddedLibrariesHelper.FromJson(const AValue: string);
var
  LJSON: TJSONValue;
begin
  LJSON := TJSONObject.ParseJSONValue(AValue);
  if LJSON <> nil then
  try
    FromJsonValue(LJSON);
  finally
    LJSON.Free;
  end;
end;

procedure TEmbeddedLibrariesHelper.FromJsonValue(const AValue: TJSONValue);
var
  LJSON: TJSONArray;
  I: Integer;
  LLibrary: TEmbeddedLibrary;
begin
  if AValue is TJSONArray then
  begin
    LJSON := TJSONArray(AValue);
    for I := 0 to LJSON.Count - 1 do
    begin
      LLibrary.FromJSONValue(LJSON.Items[I]);
      Self := Self + [LLibrary];
    end;
  end;
end;

function TEmbeddedLibrariesHelper.GetErrorMessages: string;
var
  LLibrary: TEmbeddedLibrary;
begin
  Result := '';
  for LLibrary in Self do
  begin
    if not Result.IsEmpty then
      Result := Result + #13#10;
    Result := Result + LLibrary.GetErrorMessage;
  end;
end;

function TEmbeddedLibrariesHelper.ToJsonValue: TJSONValue;
var
  LJSONArray: TJSONArray;
  I: Integer;
begin
  LJSONArray := TJSONArray.Create;
  for I := 0 to Length(Self) - 1 do
    LJSONArray.AddElement(Self[I].ToJsonValue);
  Result := LJSONArray;
end;

end.
