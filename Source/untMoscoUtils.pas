unit untMoscoUtils;

interface

uses Mosco.Types;

type
  TiOSCertType = (ctDevelopment, ctAdHoc, ctAppStore);

  IMoscoUtils = interface
    ['{D757D328-4B68-4037-B2D0-11DC8B91B0C1}']
    function Ping(var AError: string): Boolean;
    function GetIdentities(ACertType: TiOSCertType): TIdentities;
    function GetProfiles: TProfiles;
    function GetProfile(AUUID: string): TProfile;
    procedure UploadToiTunes(const AProfileName, AFileName, AAppleID, AAppSpecificPassword: string; var AError: string);
  end;

  function CreateMoscoUtils(AHost: string; APort: integer): IMoscoUtils;

implementation

uses Mosco.ZMQ.Client,Classes, SysUtils, DateUtils, System.Net.HttpClient, DW.Cryptor, System.NetEncoding, Json;

type
  TMoscoUtils = class(TInterfacedObject, IMoscoUtils)
  private
    FMosco: TMoscoZMQClient;
    FResponse: TResponseInfo;
    FResponseReceived: Boolean;
    FIdentities: TIdentities;
    FProfiles: TProfiles;
    FLastError: string;
    procedure WaitForResponse(ATimeoutSecs: integer);
    procedure DoResponse(Sender: TObject; const Info: TResponseInfo);
    procedure DoRequestTimeout(Sender: TObject; const Request: TJSONValue);
    procedure DoGetIdentities(Sender: TObject; const Identities: TIdentities);
    procedure DoGetProfiles(Sender: TObject; const Profiles: TProfiles);
    procedure DoUploaded(Sender: TObject);
  protected
    function Ping(var AError: string): Boolean;
    function GetIdentities(ACertType: TiOSCertType): TIdentities;
    function GetProfiles: TProfiles;
    function GetProfile(AUUID: string): TProfile;
    procedure UploadToiTunes(const AProfileName, AFileName, AAppleID, AAppSpecificPassword: string; var AError: string);
  public
    constructor Create(AHost: string; APort: integer); virtual;
    destructor Destroy; override;
  end;

function CreateMoscoUtils(AHost: string; APort: integer): IMoscoUtils;
begin
  Result := TMoscoUtils.Create(AHost, APort);
end;

function TestConnection(AHost: string; APort: integer; var AError: string): Boolean;
begin
  Result := CreateMoscoUtils(AHost, APort).Ping(AError);
end;

{ TMoscoUtils }

constructor TMoscoUtils.Create(AHost: string; APort: integer);
begin
  FMosco := TMoscoZMQClient.Create;
  FMosco.Host := 'tcp://'+AHost+':'+APort.ToString;
  FMosco.OnResponse := DoResponse;
  FMosco.OnRequestTimeout := DoRequestTimeout;

end;

destructor TMoscoUtils.Destroy;
begin
  FMosco.Free;
  inherited;
end;

procedure TMoscoUtils.DoGetIdentities(Sender: TObject; const Identities: TIdentities);
begin
  FIdentities := Identities;
end;

procedure TMoscoUtils.DoGetProfiles(Sender: TObject; const Profiles: TProfiles);
begin
  FProfiles := Profiles;
end;

procedure TMoscoUtils.DoRequestTimeout(Sender: TObject; const Request: TJSONValue);
begin
  FLastError := 'Unable to connect to Mosco server';
end;

procedure TMoscoUtils.DoResponse(Sender: TObject; const Info: TResponseInfo);
begin
  FResponseReceived := True;
  FResponse := Info;
  if Info.IsError then
    FLastError := Info.Message;
end;

procedure TMoscoUtils.DoUploaded(Sender: TObject);
begin
  FResponseReceived := True;
end;

function TMoscoUtils.Ping(var AError: string): Boolean;
begin
  FResponseReceived := False;
  FLastError := '';
  FMosco.Ping(0);
  WaitForResponse(5);
  Result := FLastError = '';
  AError := FLastError;
end;

procedure TMoscoUtils.UploadToiTunes(const AProfileName, AFileName, AAppleID, AAppSpecificPassword: string; var AError: string);
begin
  if Ping(AError) then
  begin
    FLastError := '';
    FResponseReceived := False;

    FMosco.OnResponse := DoResponse;
    FMosco.OnUploaded := DoUploaded;

    FMosco.UploadIPA(AProfileName, ExtractFilename(AFileName), AAppleID, TCryptor.Encrypt(AAppSpecificPassword));
    WaitForResponse(60);
    AError := FLastError;
  end;
end;

function TMoscoUtils.GetIdentities(ACertType: TiOSCertType): TIdentities;
var
  AError: string;
begin
  if not Ping(AError) then
    raise Exception.Create(AError);
  FIdentities := [];
  FResponseReceived := False;
  FLastError := '';
  FMosco.OnReceivedIdentities := DoGetIdentities;
  FMosco.FetchIdentities;
  WaitForResponse(5);
  if FResponseReceived then
    Result := FIdentities;
end;

function TMoscoUtils.GetProfile(AUUID: string): TProfile;
var
  p: TProfile;
begin
  GetProfiles;
  for p in FProfiles do
  begin
    if p.UUID = AUUid then
      Result := p;
  end;
end;

function TMoscoUtils.GetProfiles: TProfiles;
var
  AError: string;
begin
  FProfiles := [];
  if not Ping(AError) then
    raise Exception.Create(AError);

  FResponseReceived := False;
  FLastError := '';
  FMosco.OnReceivedProfiles := DoGetProfiles;
  FMosco.FetchProfiles;
  WaitForResponse(5);
  if FResponseReceived then
    Result := FProfiles;
end;

procedure TMoscoUtils.WaitForResponse(ATimeoutSecs: integer);
var
  AStart: TDateTime;
begin
  AStart := Now;
  while (FResponseReceived = False) and (FLastError = '') and (SecondsBetween(AStart, Now) <= ATimeoutSecs) do
  begin
    Sleep(10);
  end;
end;

end.
