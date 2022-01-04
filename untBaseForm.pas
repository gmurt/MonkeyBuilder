unit untBaseForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type


  TfrmBaseForm = class(TForm)
  private
    function GetSetting(ASection, AIdent: string): string;
    procedure SetSetting(ASection, AIdent: string; const Value: string);
    procedure GetApplicationVersion(var AMajor, AMinor, ARelease, ABuild: integer);
    function GetAppVersionStr: string;
    { Private declarations }
  protected
    procedure OpenURL(Url: string);
  public
    function AppDir: string;
    function AppDataDir: string;
    property Setting[ASection: string; AIdent: string]: string read GetSetting write SetSetting;
    property AppVersionStr: string read GetAppVersionStr;
    { Public declarations }
  end;

implementation

uses IniFiles, Registry, ShellApi, System.UITypes,
untMbUtils, JclShell, Winapi.ShlObj, JsonDataObjects;

{$R *.dfm}

{$IFDEF DEBUG}

function GetGoogleKey: string;
var
  AStrings: TStrings;
  AFile: string;
begin
  Result := '';
  AStrings := TStringList.Create;
  try
    AFile := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))+'google.key';
    if FileExists(AFile) then
    begin
      AStrings.LoadFromFile(AFile);
      Result := AStrings.Text;
    end;
  finally
    AStrings.Free;
  end;
end;


{$ENDIF}

{ TfrmBaseForm }


procedure TfrmBaseForm.OpenURL(Url: string);
begin
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;



procedure TfrmBaseForm.GetApplicationVersion(var AMajor, AMinor, ARelease, ABuild: integer);
var
	VerInfoSize, VerValueSize, DUMMY: DWORD;
	VerInfo:pointer;
	VerValue: PVSFixedFileInfo;
  AFilename: string;
begin
  try
    AMajor := 0;
    AMinor := 0;
    ARelease := 0;
    ABuild := 0;

    AFileName := ParamStr(0);
    VerInfoSize:=GetFileVersionInfoSize(Pchar(AFilename), DUMMY);
    GetMem(verinfo, verinfosize);
    GetFileVersionInfo(pchar(AFilename),0,VerInfoSize, VerInfo);
    VerQueryValue(VerInfo,'\',Pointer(VerValue), VerValueSize);
    AMajor := VerValue^.dwFileVersionMS shr 16;				//Major
    AMinor := VerValue^.dwFileVersionMS and $FFFF;		//Minor
    ARelease := VerValue^.dwFileVersionLS shr 16;				//Release
    ABuild := VerValue^.dwFileVersionLS and $FFFF;    //Build
    FreeMem(VerInfo, VerInfoSize);
  except
    // corrupt *.exe?
  end;
end;

function TfrmBaseForm.GetAppVersionStr: string;
var
  v1, v2, v3, v4: integer;
begin
  GetApplicationVersion(v1, v2, v3, v4);
  Result := Format('%d.%d.%d.', [v1, v2, v3])+FormatFloat('0000', v4);
end;

function TfrmBaseForm.AppDataDir: string;
var
  AAppData: string;
begin
  AAppData := JclShell.GetSpecialFolderLocation(CSIDL_APPDATA);
  Result := IncludeTrailingPathDelimiter(AAppData)+'Kernow Software\MonkeyBuilder\';
  if not FileExists(Result) then
    ForceDirectories(Result);
end;

function TfrmBaseForm.AppDir: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;

function TfrmBaseForm.GetSetting(ASection, AIdent: string): string;
var
  AIni: TMemIniFile;
begin
  AIni := TMemIniFile.Create(AppDataDir+'settings.ini');
  try
    Result := AIni.ReadString(ASection, AIdent, '');
  finally
    AIni.Free;
  end;
end;

procedure TfrmBaseForm.SetSetting(ASection, AIdent: string; const Value: string);
var
  AIni: TMemIniFile;
begin
  AIni := TMemIniFile.Create(AppDataDir+'settings.ini');
  try
    AIni.WriteString(ASection, AIdent, Value);
    AIni.UpdateFile;
  finally
    AIni.Free;
  end;
end;

end.
