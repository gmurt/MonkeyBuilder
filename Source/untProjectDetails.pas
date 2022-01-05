unit untProjectDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untBaseForm, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Mask, JvExMask, JvToolEdit, Vcl.ExtCtrls, JvSpin,
  System.ImageList, Vcl.ImgList, JvImageList, ksInspector, FireDAC.Phys.ADSDef, FireDAC.Stan.Intf, FireDAC.Phys, FireDAC.Phys.ADS, Vcl.Buttons,
  JvExStdCtrls, JvListComb, Vcl.Imaging.pngimage, JvComponentBase, JvComputerInfoEx, Vcl.Grids, Vcl.CheckLst, JvExCheckLst,
  JvCheckListBox, JvExControls, JvxCheckListBox, JvBaseDlg, Json,
  JvBrowseFolder, Vcl.Menus, MonkeyBuilder_Intf, System.Net.URLClient, Mosco.Types,
  System.Net.HttpClient, System.Net.HttpClientComponent;

type
  TfrmProjectDetails = class(TfrmBaseForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel3: TPanel;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    Label2: TLabel;
    edtTitle: TEdit;
    tabPlatforms: TTabControl;
    Bevel1: TBevel;
    Panel4: TPanel;
    Bevel5: TBevel;
    Bevel4: TBevel;
    Bevel6: TBevel;
    Bevel3: TBevel;
    Panel5: TPanel;
    PageControl1: TPageControl;
    tabProjectSettings: TTabSheet;
    Bevel2: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    inspProjectSettings: TksInspector;
    tabIcons: TTabSheet;
    tabSplashScreens: TTabSheet;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    lbIcons: TListBox;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    Bevel14: TBevel;
    Bevel15: TBevel;
    Bevel16: TBevel;
    OpenDialog1: TOpenDialog;
    Bevel18: TBevel;
    Bevel19: TBevel;
    Bevel20: TBevel;
    lbSplashScreens: TListBox;
    Panel6: TPanel;
    btnAutoSelectIcons: TSpeedButton;
    TabSheet1: TTabSheet;
    JvImageList1: TJvImageList;
    JvImageList2: TJvImageList;
    SpeedButton2: TSpeedButton;
    Panel7: TPanel;
    btnAutoSelectSplash: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Panel8: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Panel9: TPanel;
    Label11: TLabel;
    Image2: TImage;
    Panel10: TPanel;
    Label12: TLabel;
    Image3: TImage;
    Panel11: TPanel;
    Label13: TLabel;
    Image4: TImage;
    TabSheet2: TTabSheet;
    Panel12: TPanel;
    Label14: TLabel;
    Image5: TImage;
    cbSdk: TComboBox;
    Label15: TLabel;
    Label16: TLabel;
    cbProfile: TComboBox;
    TabSheet3: TTabSheet;
    Panel13: TPanel;
    Label18: TLabel;
    Image6: TImage;
    Panel14: TPanel;
    Bevel17: TBevel;
    SpeedButton5: TSpeedButton;
    SpeedButton7: TSpeedButton;
    TabSheet5: TTabSheet;
    Bevel21: TBevel;
    Bevel22: TBevel;
    Bevel23: TBevel;
    Panel16: TPanel;
    Label19: TLabel;
    Image7: TImage;
    Bevel24: TBevel;
    Panel15: TPanel;
    lbPermissionsDangerous: TJvCheckListBox;
    Label20: TLabel;
    Panel17: TPanel;
    Label21: TLabel;
    lbPermissionsNormal: TJvCheckListBox;
    TabSheet6: TTabSheet;
    Panel18: TPanel;
    Label3: TLabel;
    Image8: TImage;
    inspUsageDescriptions: TksInspector;
    TabSheet7: TTabSheet;
    Panel19: TPanel;
    Label4: TLabel;
    Image9: TImage;
    inspEntitlements: TksInspector;
    Bevel25: TBevel;
    Bevel26: TBevel;
    Bevel27: TBevel;
    TabSheet8: TTabSheet;
    Panel20: TPanel;
    Label22: TLabel;
    Image10: TImage;
    edtVersionMajor: TJvSpinEdit;
    Label7: TLabel;
    Label6: TLabel;
    edtVersionMinor: TJvSpinEdit;
    edtBuild: TJvSpinEdit;
    Label8: TLabel;
    SpeedButton6: TSpeedButton;
    JvBrowseForFolderDialog1: TJvBrowseForFolderDialog;
    PopupMenu1: TPopupMenu;
    N11: TMenuItem;
    TabSheet9: TTabSheet;
    Panel21: TPanel;
    Label5: TLabel;
    Image11: TImage;
    edtKeystoreFile: TJvFilenameEdit;
    Label17: TLabel;
    Label23: TLabel;
    edtKeyStorePassword: TEdit;
    Button3: TButton;
    cbAlias: TComboBox;
    Label24: TLabel;
    Label25: TLabel;
    edtCertPasswords: TEdit;
    Button4: TButton;
    pnlMoscoError: TPanel;
    imgWarning: TImage;
    Label26: TLabel;
    Button5: TButton;
    NetHTTPClient1: TNetHTTPClient;
    Label27: TLabel;
    lblProject: TLabel;
    Panel22: TPanel;
    ListBox1: TListBox;
    tabProvisioning: TTabControl;
    Label10: TLabel;
    Label9: TLabel;
    cbProvisionCert: TComboBox;
    cbProvisionProfile: TComboBox;
    gridDeploy: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure tabPlatformsChange(Sender: TObject);
    procedure tabPlatformsChanging(Sender: TObject; var AllowChange: Boolean);
    procedure lbIconsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure FormResize(Sender: TObject);
    procedure lbIconsDblClick(Sender: TObject);
    procedure btnAutoSelectIconsClick(Sender: TObject);
    procedure JvImageListBox1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure SpeedButton4Click(Sender: TObject);
    procedure btnAutoSelectSplashClick(Sender: TObject);
    procedure cbProfileDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cbSdkDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cbAdHocProfileDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure cbAdHocCertDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lbSplashScreensDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure TabSheet5Resize(Sender: TObject);
    procedure lbPermissionsNormalClickCheck(Sender: TObject);
    procedure lbPermissionsNormalDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure lbPermissionsNormalMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure inspProjectSettingsGetComboLookupItems(Sender: TObject; APropertyName: string; AItems: TStrings);
    procedure edtVersionMajorChange(Sender: TObject);
    procedure edtVersionMinorChange(Sender: TObject);
    procedure edtBuildChange(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure inspProjectSettingsGetPropertyType(Sender: TObject;
      AProperty: string; var AType: TksPropertyType);
    procedure tabIconsShow(Sender: TObject);
    procedure tabSplashScreensShow(Sender: TObject);
    procedure inspEntitlementsGetPropertyType(Sender: TObject;
      AProperty: string; var AType: TksPropertyType);
    procedure TabSheet5Show(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure lbIconsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure lbIconsExit(Sender: TObject);
    procedure lbIconsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure edtKeystoreFileChange(Sender: TObject);
    procedure edtKeyStorePasswordExit(Sender: TObject);
    procedure cbAliasChange(Sender: TObject);
    procedure edtKeyStorePasswordChange(Sender: TObject);
    procedure edtCertPasswordsChange(Sender: TObject);
    procedure TabSheet9Show(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure edtTitleChange(Sender: TObject);
    procedure cbDevelopmentProfileDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure tabProvisioningChange(Sender: TObject);
    procedure cbProvisionProfileDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbProvisionProfileChange(Sender: TObject);
    procedure cbProvisionCertChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure lvDeployEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure gridDeployMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure gridDeployDblClick(Sender: TObject);
  private
    FProject: IMbProject;
    FCmdOutput: TStrings;


    FIosIdentities: TStrings;
    FIosDistributionProfiles: TStrings;
    FIosDevelopmentProfiles: TStrings;

    FAndroidPermissions: IMbAndroidPermissionList;

    FProfiles: TProfiles;
    FIdentities: TIdentities;

    procedure ProjectToEdits;
    procedure EditsToProject;
    procedure UpdateInspector;
    procedure UpdateVersion;

    procedure UpdateUsageDescriptions;

    function GetSelectedPlatform: TmbPlatform;
    procedure PopulatePageList;
    procedure PopulateIcons;
    procedure PopulateSplashScreens;
    procedure PopulateDeploymentFiles;
    procedure PopulatePermissions;
    procedure PopulateFrameworks;
    procedure PopulateEntitlements;
    procedure PopulateKeyStore;
    procedure GetDeploymentPaths
    (AFolders: TStrings);
    procedure OnGetKeystoreCertificates(const AText: string);
    procedure PopulateProvisioning;
    procedure ClickDeployMenuItem(Sender: TObject);
    procedure UpdateDeploymentFiles;
    function MouseOverButton(ALb: TListBox; x, y: integer): Boolean;
    procedure GetKeystoreAliases(AKeystore, APassword: string);
    procedure CheckAliasPassword(AKeystore, AStorePassword, AAlias, AAliasPassword: string);
    procedure SetMoscoConnectionErrorVisible(AValue: Boolean);
    procedure PopulateCertificates(AType: TmbDeploymentType; AProfile: TProfile);
    procedure PopulateProfiles(AType: TmbDeploymentType);//(ACert: string);
    { Private declarations }
  protected
    procedure DoShow; override;


  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SelectedPlatform: TmbPlatform read GetSelectedPlatform;
    { Public declarations }
  end;

  function ShowProjectDetails(AProject: IMbProject): TModalResult;

implementation

uses System.Threading, JclStrings, System.UITypes, untMoscoUtils, JsonDataObjects, System.Types,
  untConst, untSelectFolderFiles, MonkeyBuilder.Project, JclSysUtils, JclFileUtils,
  untSettings, ClipBrd, untDeployFileDetails;

{$R *.dfm}



function ShowProjectDetails(AProject: IMbProject): TModalResult;
var
  frmProject: TfrmProjectDetails;
begin
  frmProject := TfrmProjectDetails.Create(nil);
  try
    frmProject.FProject.Assign(AProject);
    Result := frmProject.ShowModal;
    if Result = mrOk then
      AProject.Assign(frmProject.FProject);
  finally
    frmProject.Free;
  end;
end;

{ TfrmProjectDetails }

procedure TfrmProjectDetails.GetKeystoreAliases(AKeystore, APassword: string);
var
  AKeyTool: string;
begin
  cbAlias.Items.Clear;
  cbAlias.Items.Add('');
  FCmdOutput.Clear;
  AKeyTool := GetSdkValueFromRegistry(mbAndroid64, 'JDKKeyToolPath');
  Execute('"'+AKeyTool+'" -list -v -keystore "'+AKeystore+'" -storepass '+APassword, OnGetKeystoreCertificates, True, nil, TJclProcessPriority.ppNormal);
  if (cbAlias.Text = '') and (cbAlias.Items.Count > 1) then
  begin
    cbAlias.ItemIndex := 1;
    FProject.AndroidSettings.Keystore.Alias := Trim(cbAlias.Text);
    edtCertPasswords.SetFocus;
  end;
end;

procedure TfrmProjectDetails.CheckAliasPassword(AKeystore, AStorePassword, AAlias, AAliasPassword: string);
begin
  if FProject.AndroidSettings.Keystore.ValidateDetails then
     MessageDlg('Your keystore and certificate passwords are valid.', mtInformation, [mbOK], 0)
  else
    MessageDlg('Your keystore or alias passwords are incorrect.', mtError, [mbOK], 0)
end;


procedure TfrmProjectDetails.OnGetKeystoreCertificates(const AText: string);
begin
  FCmdOutput.Add(Trim(AText));
  if Pos('alias name:', AText.ToLower) = 1 then cbAlias.Items.Add(Trim(StrAfter(':', AText)));
end;

procedure TfrmProjectDetails.Button1Click(Sender: TObject);
begin
  inherited;
  EditsToProject;
  ModalResult := mrOk;
end;

procedure TfrmProjectDetails.Button2Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

procedure TfrmProjectDetails.Button3Click(Sender: TObject);
begin
  inherited;
  GetKeystoreAliases(edtKeystoreFile.FileName, edtKeyStorePassword.text);
end;

procedure TfrmProjectDetails.Button4Click(Sender: TObject);
var
  ks: IMbAndroidKeyStore;
begin
  inherited;
  ks := FProject.AndroidSettings.Keystore;
  CheckAliasPassword(ks.KeystoreFile, ks.KeystorePassword, ks.Alias, ks.AliasPassword);
end;

procedure TfrmProjectDetails.Button5Click(Sender: TObject);
begin
  inherited;
 { ShowSettings(0);

  TThread.CreateAnonymousThread(
    procedure
    begin
      try
        FProfiles := GetProfiles(Setting['mosco', 'host'], StrToIntDef(Setting['mosco', 'port'], 64219));
        TThread.Queue(nil,
          procedure
          begin
            PopulateProvisioning;
          end
        )
      except
        FProfiles := nil;
      end;
    end
  ).Start;}
end;

procedure TfrmProjectDetails.cbAdHocCertDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  cb: TComboBox;
  AIcon: TIcon;
  ACert: TIdentity;
begin
  inherited;
  cb := (Control as TComboBox);
  AIcon := TIcon.Create;
  try
    JvImageList2.GetIcon(5, AIcon);
    cb.Canvas.FillRect(Rect);
    cb.Canvas.StretchDraw(System.Classes.Rect(Rect.Left+4, Rect.Top+2, Rect.Left+32, Rect.Top+32), AIcon);

    ACert.FromJson(cb.Items[index]);
    cb.Canvas.TextOut(38, Rect.Top+8, ACert.Description);

  finally
    AIcon.Free;
  end;
end;

procedure TfrmProjectDetails.cbAdHocProfileDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  cb: TComboBox;
  AObj: TJsonObject;
  AIcon: TIcon;
begin
  inherited;
  cb := (Control as TComboBox);
  AIcon := TIcon.Create;
  try
    JvImageList2.GetIcon(1, AIcon);
    cb.Canvas.FillRect(Rect);
    AObj := TJsonObject.Parse(cb.Items.ValueFromIndex[Index]) as TJsonObject;
    try
      cb.Canvas.StretchDraw(System.Classes.Rect(Rect.Left+4, Rect.Top+4, Rect.Left+32, Rect.Top+32), AIcon);
      cb.Canvas.TextOut(38, Rect.Top+8, AObj.S['ProfileName']+' - '+AObj.S['UUID']);
    finally
      AObj.Free;
    end;
  finally
    AIcon.Free;
  end;
end;

procedure TfrmProjectDetails.cbAliasChange(Sender: TObject);
begin
  inherited;
  FProject.AndroidSettings.Keystore.Alias := Trim(cbAlias.Text);
end;

procedure TfrmProjectDetails.cbProvisionCertChange(Sender: TObject);
var
  AType: TmbDeploymentType;
  ACert: TIdentity;
begin
  inherited;
  if tabProvisioning.TabIndex = 0 then
    AType := mbDeplyDevelopment
  else
     AType := mbDeployAppStore;

  if cbProvisionCert.ItemIndex > -1 then
    ACert.FromJson(cbProvisionCert.Items[cbProvisionCert.ItemIndex]);
  FProject.IosSettings.ProvisionCert[AType] := ACert.Description;

  //PopulateProfiles(AType)
end;

procedure TfrmProjectDetails.cbProvisionProfileChange(Sender: TObject);
var
  AProfile: TProfile;
  AType: TmbDeploymentType;
begin
  inherited;
  cbProvisionCert.Items.Clear;
  if cbProvisionProfile.ItemIndex = -1 then
    Exit;

  AProfile.FromJson(cbProvisionProfile.Items[cbProvisionProfile.ItemIndex]);
  //AProfileID := StrAfter('=', cbProvisionProfile.Items[cbProvisionProfile.ItemIndex]);

  if tabProvisioning.TabIndex = 0 then
    AType := mbDeplyDevelopment
  else
    AType := mbDeployAppStore;
  FProject.IosSettings.ProvisionProfileID[AType] := AProfile.UUID;

  PopulateCertificates(AType, AProfile);
end;

procedure TfrmProjectDetails.cbProvisionProfileDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  cb: TComboBox;
  AIcon: TIcon;
  AProfile: TProfile;
  //AAppID: string;
begin
  inherited;
  cb := (Control as TComboBox);
  AIcon := TIcon.Create;
  try
    JvImageList2.GetIcon(5, AIcon);
    cb.Canvas.FillRect(Rect);
    cb.Canvas.StretchDraw(System.Classes.Rect(Rect.Left+4, Rect.Top+2, Rect.Left+32, Rect.Top+32), AIcon);

    AProfile.FromJson(cb.Items[index]);
    cb.Canvas.TextOut(38, Rect.Top+8, AProfile.AppID);


    //AAppID := StrAfter('.', AProfile.ProfileName);
    if AProfile.BundleID <> '*' then
    begin
      cb.Canvas.Font.Name := 'Arial';
      cb.Canvas.Font.Size := 7;
      if not (odSelected in State) then
        cb.Canvas.Font.Color := clGray;
      cb.Canvas.TextOut((Rect.Right-8)-cb.Canvas.TextWidth(AProfile.BundleID), Rect.Top+9, AProfile.BundleID);
    end;


  finally
    AIcon.Free;
  end;
end;

procedure TfrmProjectDetails.cbDevelopmentProfileDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  cb: TComboBox;
  AIcon: TIcon;
  AJson: TJsonObject;
begin
  inherited;
  cb := (Control as TComboBox);
  AIcon := TIcon.Create;
  try

    JvImageList2.GetIcon(5, AIcon);
    cb.Canvas.FillRect(Rect);
    cb.Canvas.StretchDraw(System.Classes.Rect(Rect.Left+4, Rect.Top+2, Rect.Left+32, Rect.Top+32), AIcon);
    AJson := TJsonObject.Parse(cb.Items[index]) as TJsonObject;
    try
      cb.Canvas.TextOut(38, Rect.Top+8, AJson.S['ProfileName']);
    finally
      AJson.Free;
    end;

  finally
    AIcon.Free;
  end;
end;

procedure TfrmProjectDetails.cbProfileDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  lb: TComboBox;
  AName, AHost, APort: string;
begin
  inherited;
  lb := (Control as TComboBox);
  lb.Canvas.FillRect(Rect);
  AName := lb.Items.Names[Index];
  AHost := StrBefore('|', lb.Items.ValueFromIndex[Index]);
  APort := StrAfter('|', lb.Items.ValueFromIndex[Index]);
  lb.Canvas.TextOut(9, Rect.Top+4, AName);
  lb.Canvas.TextOut(80, Rect.Top+4, 'Host: '+AHost);
  lb.Canvas.TextOut(200, Rect.Top+4, 'Port: '+APort);
end;

procedure TfrmProjectDetails.cbSdkDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  lb: TComboBox;
  AName: string;
begin
  inherited;
  lb := (Control as TComboBox);
  lb.Canvas.FillRect(Rect);
  AName := lb.Items.Names[Index];
  lb.Canvas.TextOut(9, Rect.Top+4, AName);
end;

procedure TfrmProjectDetails.ClickDeployMenuItem(Sender: TObject);
var
  ICount: integer;
begin
  for ICount := gridDeploy.Selection.Top to gridDeploy.Selection.Bottom do
  begin
    FProject.PlatformSettings[SelectedPlatform].DeploymentFiles[Icount-1].RemotePath := (Sender as TMenuItem).Hint;
  end;
  UpdateDeploymentFiles;
end;

constructor TfrmProjectDetails.Create(AOwner: TComponent);
var
  ICount: integer;
begin
  inherited;

  FProject := CreateProject;
  FCmdOutput := TStringList.Create;

  FIosIdentities := TStringList.Create;
  FIosDistributionProfiles := TStringList.Create;
  FIosDevelopmentProfiles := TStringList.Create;

  //FMosco := nil;
  FAndroidPermissions := CreateAndroidPermissionsList;
  ListBox1.DoubleBuffered := True;
  lbIcons.DoubleBuffered := True;
  lbSplashScreens.DoubleBuffered := True;
  for ICount := 0 to PageControl1.PageCount-1 do
  begin
    PageControl1.Pages[ICount].TabVisible := False;
  end;

 { TThread.CreateAnonymousThread(
    procedure
    begin
      try
        FProfiles := GetProfiles(Setting['mosco', 'host'], StrToIntDef(Setting['mosco', 'port'], 64219));
      except
        FProfiles := nil;
      end;
    end
  ).Start;    }

end;


destructor TfrmProjectDetails.Destroy;
begin
  FCmdOutput.Free;
  FIosDistributionProfiles.Free;
  FIosDevelopmentProfiles.Free;
  FIosIdentities.Free;
  inherited;
end;

procedure TfrmProjectDetails.DoShow;
var
  ADefault: string;
begin
  inherited;
  tabPlatforms.TabIndex := StrToIntDef(Setting['config', 'projectTab'], 0);
  SetMoscoConnectionErrorVisible(False);
  GetConnectionProfiles(SelectedPlatform, cbProfile.Items, ADefault);
  PopulateFrameworks;

  PopulatePageList;
  ProjectToEdits;
  PopulatePermissions;
end;

procedure TfrmProjectDetails.EditsToProject;
var
  APlatformSettings: IMbProjectPlatform;
begin
  APlatformSettings := FProject.PlatformSettings[GetSelectedPlatform];
  APlatformSettings.Sdk := '';
  if cbSdk.ItemIndex > -1 then
    APlatformSettings.Sdk := cbSdk.Items.Names[cbSdk.ItemIndex];
  APlatformSettings.ConnectionProfile := '';
  if cbProfile.ItemIndex > -1 then
    APlatformSettings.ConnectionProfile := cbProfile.Items.Names[cbProfile.ItemIndex];

end;

procedure TfrmProjectDetails.edtBuildChange(Sender: TObject);
begin
  FProject.PlatformSettings[SelectedPlatform].Version.Build := edtBuild.AsInteger;
end;

procedure TfrmProjectDetails.edtCertPasswordsChange(Sender: TObject);
begin
  inherited;
  FProject.AndroidSettings.Keystore.AliasPassword := edtCertPasswords.Text;
end;

procedure TfrmProjectDetails.edtKeyStorePasswordChange(Sender: TObject);
begin
  inherited;
  FProject.AndroidSettings.Keystore.KeystorePassword := edtKeyStorePassword.Text;
end;

procedure TfrmProjectDetails.edtKeyStorePasswordExit(Sender: TObject);
begin
  inherited;
  FProject.AndroidSettings.Keystore.KeystorePassword := edtKeyStorePassword.Text;
end;

procedure TfrmProjectDetails.edtTitleChange(Sender: TObject);
begin
  inherited;
  FProject.Title := Trim(edtTitle.Text);
end;

procedure TfrmProjectDetails.edtVersionMajorChange(Sender: TObject);
begin
  inherited;
  FProject.PlatformSettings[SelectedPlatform].Version.Major := edtVersionMajor.AsInteger;
end;

procedure TfrmProjectDetails.edtVersionMinorChange(Sender: TObject);
begin
  inherited;
  FProject.PlatformSettings[SelectedPlatform].Version.Minor := edtVersionMinor.AsInteger;
end;

procedure TfrmProjectDetails.FormResize(Sender: TObject);
begin
  inherited;
  lbIcons.Invalidate;
end;

function TfrmProjectDetails.GetSelectedPlatform: TmbPlatform;
begin
  case tabPlatforms.TabIndex of
    0: Result := mbIosDevice64;
    1: Result := mbAndroid64;
  else
    raise Exception.Create('Unsupported Platform');
  end;
end;

procedure TfrmProjectDetails.gridDeployDblClick(Sender: TObject);
var
  AFile: IMbDeploymentFile;
begin
  inherited;
  if gridDeploy.Row > 0 then
  begin
     if Supports(gridDeploy.Objects[0, gridDeploy.Row], IMbDeploymentFile, AFile) then
     begin
      if EditDeployFile(AFile) = mrOk then
        UpdateDeploymentFiles;
     end;
  end;
end;

procedure TfrmProjectDetails.GetDeploymentPaths(AFolders: TStrings);
var
  ICount: integer;
  AStr: string;
begin
  for ICount := 1 to gridDeploy.RowCount-1 do
  begin
    AStr := Trim(gridDeploy.Cells[1, ICount]);
    if (AStr <> '') and (AFolders.IndexOf(AStr) = -1) and (AStr.ToLower <> LowerCase('Startup\Documents\')) and (AStr <> '.\') then
    begin
      AFolders.Add(AStr);
    end;
  end;
  AFolders.Insert(0,'Startup\Documents\');
  AFolders.Insert(0, '.\');
end;

procedure TfrmProjectDetails.gridDeployMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: integer;
  APt: TPoint;
begin
  inherited;
  gridDeploy.MouseToCell(X, Y, ACol, ARow);

  if Button = mbRight then
  begin
    if (ACol = 1) and (ARow > 0) then
    begin
      APt := gridDeploy.ClientToScreen(Point(X, Y));
      PopupMenu1.Popup(APt.X, APt.Y);
    end;
  end;
end;

procedure TfrmProjectDetails.inspEntitlementsGetPropertyType(Sender: TObject;
  AProperty: string; var AType: TksPropertyType);
begin
  inherited;
  AType := ksBoolean;
end;

procedure TfrmProjectDetails.inspProjectSettingsGetComboLookupItems(Sender: TObject; APropertyName: string; AItems: TStrings);
begin
  inherited;
  if APropertyName.ToLower = 'userinterfacestyle' then
  begin
    AItems.Add('Light');
    AItems.Add('Dark');
    AItems.Add('Automatic');
  end;

  if APropertyName.ToLower = 'devicefamily' then
  begin
    AItems.Add('');
    AItems.Add('iPhone');
    AItems.Add('iPad');
    AItems.Add('iPhone & iPad');
  end;
end;

procedure TfrmProjectDetails.inspProjectSettingsGetPropertyType(Sender: TObject;
  AProperty: string; var AType: TksPropertyType);
begin
  inherited;
  if AProperty.ToLower = 'appid' then AType := ksString;
  if AProperty.ToLower = 'conditionals' then AType := ksString;
  if AProperty.ToLower = 'userinterfacestyle' then AType := ksComboItem;
  if AProperty.ToLower = 'librarypath' then AType := ksFileList;
  if AProperty.ToLower = 'frameworkpath' then AType := ksFileList;
  if AProperty.ToLower = 'searchpath' then AType := ksFileList;
  if AProperty.ToLower = 'devicefamily' then AType := ksComboItem;
  if AProperty.ToLower = 'googleserviceplist' then AType := ksFile;
  if AProperty.ToLower = 'googleservicejson' then AType := ksFile;

end;

procedure TfrmProjectDetails.edtKeystoreFileChange(Sender: TObject);
begin
  inherited;
  FProject.AndroidSettings.Keystore.KeystoreFile := edtKeystoreFile.FileName;
end;

procedure TfrmProjectDetails.JvImageListBox1Click(Sender: TObject);
begin
  inherited;
  PageControl1.ActivePageIndex := ListBox1.ItemIndex;
  ProjectToEdits;

end;

procedure TfrmProjectDetails.lbIconsDblClick(Sender: TObject);
var
  AImg: IMbImage;
  lb: TListBox;
begin
  inherited;
  lb := (Sender as  TListBox);
  if lb.ItemIndex > -1 then
  begin
    Supports(lb.Items.Objects[lb.ItemIndex], IMbImage, AImg);
    OpenDialog1.Title := '';
    if OpenDialog1.Execute then
    begin
      AImg.Filename := OpenDialog1.FileName;
      lb.Invalidate;
    end;
  end;
end;

procedure TfrmProjectDetails.lbIconsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  lb: TListBox;
  AImg: ImbImage;
  AButtonRect: TRect;
  AButtonCaption: string;
  AIconRect: TRect;
begin
  inherited;
  AButtonRect := Rect;
  AButtonCaption := 'Select';
  AButtonRect.Left := AButtonRect.Right-70;
  AIconRect := Rect;
  AIconRect.Right := Rect.Height;
  InflateRect(AIconRect, -6, -6);
  InflateRect(AButtonRect, -8, -10);


  lb := (Control as TListBox);

  Supports(lb.Items.Objects[Index], ImbImage, AImg);
  lb.Canvas.Brush.Color := clWhite;
  if (odFocused in State)  then
    lb.Canvas.Brush.Color := $00EEEEEE;

  lb.Canvas.FillRect(Rect);
  lb.Canvas.Font.Color := clBlack;
  lb.Canvas.TextOut(50, Rect.Top+16, AImg.Name);

  lb.Canvas.Pen.Color := clGray;
  lb.Canvas.Brush.Color := $00eeeeee;
  lb.Canvas.Rectangle(AButtonRect);
  lb.Canvas.Font.Color := clBlack;
  lb.Canvas.TextRect(AButtonRect, AButtonCaption, [TTextFormats.tfCenter, TTextFormats.tfSingleLine, TTextFormats.tfVerticalCenter]);

  lb.Canvas.Brush.Style := bsSolid;
  OffsetRect(AIconRect, 2, 2);
  lb.Canvas.Brush.Color := clGray;
  lb.Canvas.Rectangle(AIconRect);
  OffsetRect(AIconRect, -2, -2);

  lb.Canvas.Brush.Color := clWhite;
  lb.Canvas.Rectangle(AIconRect);

  AImg.DrawToCanvas(lb.Canvas, AIconRect);

  lb.Canvas.Brush.Style := bsClear;
  lb.Canvas.Pen.Color := clBlack;
  if (odFocused in State)  then
    lb.Canvas.DrawFocusRect(Rect);
end;

procedure TfrmProjectDetails.lbIconsExit(Sender: TObject);
begin
  inherited;
  Screen.Cursor := crDefault;
end;

function TfrmProjectDetails.MouseOverButton(ALb: TListBox; x, y: integer): Boolean;
var
  AIndex: integer;
  ARect: TRect;
begin
  Result := False;
  AIndex := ALb.ItemAtPos(Point(x, y), True);
  if AIndex > -1 then
  begin
    Arect := ALb.ItemRect(AIndex);
    Arect.Left := Arect.Right-70;
    InflateRect(Arect, -8, -10);
    if PtInRect(ARect, Point(x, y)) then
      Result := True;
  end;
end;

procedure TfrmProjectDetails.lbIconsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if MouseOverButton(Sender as TListBox, X, Y) then
    lbIconsDblClick(Sender);
end;

procedure TfrmProjectDetails.lbIconsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  lb: TListBox;
begin
  inherited;
  Invalidate;
  lb := (Sender as TListBox);

  if MouseOverButton(lb, x, y) then
    Screen.Cursor := crHandPoint
  else
    Screen.Cursor := crDefault;
end;

procedure TfrmProjectDetails.lbPermissionsNormalClickCheck(Sender: TObject);
var
  lb: TJvCheckListBox;
  p: IMbAndroidPermission;
  ASettings: IMbProjectPlatformAndroid;
begin
  inherited;
  lb := (Sender as TJvCheckListBox);
  ASettings := FProject.AndroidSettings;
  Supports(lb.Items.Objects[lb.ItemIndex], IMbAndroidPermission, p);
  if lb.Checked[lb.ItemIndex] then
    ASettings.Permissions.Add(p.ID)
  else
    ASettings.RemovePermission(p.ID);
end;

procedure TfrmProjectDetails.lbPermissionsNormalDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  lb: TJvCheckListBox;
begin
  inherited;
  lb := (Control as TJvCheckListBox);
  lb.Canvas.Brush.Color := clWhite;
  lb.Canvas.FillRect(Rect);
  if  lb.Checked[Index] then
  begin
    lb.Canvas.Font.Color := clBlue;
  end
  else
  begin
    lb.Canvas.Font.Color := clGray;
    lb.Canvas.Font.Style := [];
  end;
  lb.Canvas.TextOut(Rect.Left+4, Rect.Top+4, lb.Items[Index]);
  if (odFocused in State)  then
    lb.Canvas.DrawFocusRect(Rect);
end;

procedure TfrmProjectDetails.lbPermissionsNormalMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lb: TJvCheckListBox;
  AIndex: integer;
begin
  inherited;
  lb := (Sender as TJvCheckListBox);
  AIndex := lb.ItemAtPos(Point(x, y), True);
  if AIndex > -1 then
  begin
    if x >= 16 then
      lb.Checked[AIndex] := not lb.Checked[AIndex];
  end;
end;

procedure TfrmProjectDetails.lbSplashScreensDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  lb: TListBox;
  AImg: ImbImage;
  AButtonRect: TRect;
  AButtonCaption: string;
  AIconRect: TRect;
begin
  inherited;
  AButtonRect := Rect;
  AButtonCaption := 'Select';
  AButtonRect.Left := AButtonRect.Right-70;
  AIconRect := Rect;
  AIconRect.Right := Rect.Height;
  InflateRect(AIconRect, -6, -6);
  InflateRect(AButtonRect, -8, -10);


  lb := (Control as TListBox);
  Supports(lb.Items.Objects[Index], ImbImage, AImg);
  lb.Canvas.Brush.Color := clWhite;
  if (odFocused in State)  then
    lb.Canvas.Brush.Color := $00EEEEEE;

  lb.Canvas.FillRect(Rect);
  lb.Canvas.Font.Color := clBlack;
  lb.Canvas.TextOut(50, Rect.Top+16, AImg.Name);

  lb.Canvas.Pen.Color := clGray;
  lb.Canvas.Brush.Color := $00eeeeee;
  lb.Canvas.Rectangle(AButtonRect);
  lb.Canvas.Font.Color := clBlack;
  lb.Canvas.TextRect(AButtonRect, AButtonCaption, [TTextFormats.tfCenter, TTextFormats.tfSingleLine, TTextFormats.tfVerticalCenter]);

  lb.Canvas.Brush.Style := bsSolid;
  OffsetRect(AIconRect, 2, 2);
  lb.Canvas.Brush.Color := clGray;
  lb.Canvas.Rectangle(AIconRect);
  OffsetRect(AIconRect, -2, -2);

  lb.Canvas.Brush.Color := clWhite;
  lb.Canvas.Rectangle(AIconRect);

  AImg.DrawToCanvas(lb.Canvas, AIconRect);

  lb.Canvas.Brush.Style := bsClear;
  lb.Canvas.Pen.Color := clBlack;
  if (odFocused in State)  then
    lb.Canvas.DrawFocusRect(Rect);
end;

procedure TfrmProjectDetails.ListBox1Click(Sender: TObject);
begin
  inherited;
  PageControl1.ActivePage := (ListBox1.Items.Objects[ListBox1.ItemIndex] as TTabSheet);
end;

procedure TfrmProjectDetails.ListBox1DrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  lb: TListBox;
  AIcon: TIcon;
  AImgRect: TRect;
  AStr: string;
begin
  inherited;
  lb := (Control as TListBox);
  lb.Canvas.FillRect(Rect);
  lb.Canvas.TextOut(40, Rect.Top+8, lb.Items[Index]);

  AImgRect.Left := 4;
  AImgRect.Top := Rect.Top+4;
  AImgRect.Right := 28;
  AImgRect.Bottom := Rect.Top+28;
  AIcon := TIcon.Create;
  try
    AStr := lb.Items[Index];
    if AStr = 'Project' then JvImageList2.GetIcon(0, AIcon);
    if AStr = 'Platform' then JvImageList2.GetIcon(1, AIcon);
    if AStr = 'Icons' then JvImageList2.GetIcon(2, AIcon);
    if AStr = 'Launch Screens' then JvImageList2.GetIcon(3, AIcon);
    if AStr = 'Permissions' then JvImageList2.GetIcon(6, AIcon);
    if AStr = 'Provisioning' then JvImageList2.GetIcon(5, AIcon);
    if AStr = 'Deployment Files' then JvImageList2.GetIcon(4, AIcon);
    if AStr = 'Usage Descriptions' then JvImageList2.GetIcon(7, AIcon);
    if AStr = 'Entitlements' then JvImageList2.GetIcon(8, AIcon);
    if AStr = 'Version' then JvImageList2.GetIcon(9, AIcon);
    if AStr = 'Keystore' then JvImageList2.GetIcon(10, AIcon);

    lb.Canvas.StretchDraw(AImgRect, AIcon);
  finally
    AIcon.Free;
  end;
end;

procedure TfrmProjectDetails.lvDeployEditing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
begin
  inherited;
  AllowEdit := False;
end;

procedure TfrmProjectDetails.PageControl1Change(Sender: TObject);
begin
  inherited;
  UpdateInspector;
  ProjectToEdits;
end;

procedure TfrmProjectDetails.PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  inherited;
  EditsToProject;
end;

procedure TfrmProjectDetails.UpdateInspector;
begin
  inspProjectSettings.InspectObject := (FProject.PlatformSettings[SelectedPlatform] as TObject);
  PopulateIcons;
  PopulateSplashScreens;
end;

procedure TfrmProjectDetails.UpdateUsageDescriptions;
begin
  inspUsageDescriptions.PropertyWidth := 250;
  inspUsageDescriptions.InspectObject := (FProject.IosSettings.UsageDescriptions as TObject);
end;

procedure TfrmProjectDetails.UpdateVersion;
var
  AVersion: IMbProjectVersion;
begin
  AVersion := FProject.PlatformSettings[SelectedPlatform].Version;
  edtVersionMajor.AsInteger := AVersion.Major;
  edtVersionMinor.AsInteger := AVersion.Minor;
  edtBuild.AsInteger := AVersion.Build;
end;

procedure TfrmProjectDetails.PopulateDeploymentFiles;
var
  AFile: IMbDeploymentFile;
begin
  gridDeploy.RowCount := 1;
  gridDeploy.Cells[0,0] := 'File';
  gridDeploy.Cells[1,0] := 'Remote Path';
  gridDeploy.Cells[2,0] := 'Remote Name';


  for AFile in FProject.PlatformSettings[SelectedPlatform].DeploymentFiles do
  begin
    gridDeploy.RowCount := gridDeploy.RowCount+1;
    gridDeploy.Objects[0, gridDeploy.RowCount-1] := TObject(AFile);
    gridDeploy.Cells[0, gridDeploy.RowCount-1] := ExtractFileName(AFile.Filename);
    gridDeploy.Cells[1, gridDeploy.RowCount-1] := AFile.RemotePath;

    gridDeploy.Cells[2, gridDeploy.RowCount-1] := AFile.RemoteName;
  end;
  if gridDeploy.RowCount > 1 then
    gridDeploy.FixedRows := 1
  else
  begin
    gridDeploy.RowCount := 2;
    gridDeploy.FixedRows := 1;
  end;
end;

procedure TfrmProjectDetails.UpdateDeploymentFiles;
begin
  PopulateDeploymentFiles;
end;

procedure TfrmProjectDetails.PopulateEntitlements;
begin
  inspEntitlements.InspectObject := (FProject.AndroidSettings.Entitlements as TObject);
end;

procedure TfrmProjectDetails.PopulateKeyStore;
begin
  edtKeystoreFile.FileName := FProject.AndroidSettings.Keystore.KeystoreFile;
  edtKeyStorePassword.Text := FProject.AndroidSettings.Keystore.KeystorePassword;
  GetKeystoreAliases(edtKeystoreFile.FileName, edtKeyStorePassword.text);
  cbAlias.ItemIndex := cbAlias.Items.IndexOf(FProject.AndroidSettings.Keystore.Alias);
  edtCertPasswords.Text := FProject.AndroidSettings.Keystore.AliasPassword;
end;

procedure TfrmProjectDetails.PopulateFrameworks;
var
  ADefault: string;
begin
  GetFrameworks(SelectedPlatform, cbSdk.Items, ADefault);
  cbSdk.Items.Insert(0, '');

end;

procedure TfrmProjectDetails.PopulateIcons;
var
  AImg:ImbImage;
begin
  lbIcons.Items.Clear;
  for AImg in FProject.PlatformSettings[SelectedPlatform].Images.Icons do
    lbIcons.Items.AddObject('',  TObject(AImg));
end;

procedure TfrmProjectDetails.PopulatePageList;
var
  ICount: integer;
  ATab: TTabSheet;
  ASelected: string;
begin
  ASelected := '';
  if ListBox1.ItemIndex > -1 then
    ASelected := ListBox1.Items[ListBox1.ItemIndex];
  ListBox1.Items.Clear;
  for ICount := 0 to PageControl1.PageCount-1 do
  begin
    ATab := PageControl1.Pages[ICount];
    if (ATab.Tag = 0) or
       ((ATab.Tag = 1) and (SelectedPlatform = mbAndroid64)) or
       ((ATab.Tag = 2) and (SelectedPlatform = mbIosDevice64)) then
    begin
      ListBox1.Items.AddObject(ATab.Caption, ATab);
    end;
  end;
  ListBox1.ItemIndex := ListBox1.Items.IndexOf(ASelected);
  if ListBox1.ItemIndex = -1 then
    ListBox1.ItemIndex := 0;
  PageControl1.ActivePage := (ListBox1.Items.Objects[ListBox1.ItemIndex] as TTabSheet);
end;

procedure TfrmProjectDetails.PopulatePermissions;
var
  ICount: integer;
  p: IMbAndroidPermission;
  AAndroid: IMbProjectPlatformAndroid;
begin
  AAndroid := FProject.AndroidSettings;

  FAndroidPermissions.PopulatePermissionStrings(lbPermissionsNormal.Items, True, False);
  for ICount := 0 to lbPermissionsNormal.Items.Count-1 do
  begin
    Supports(lbPermissionsNormal.Items.Objects[ICount], IMbAndroidPermission, p);
    lbPermissionsNormal.Checked[ICount] := Pos(p.ID.ToLower, AAndroid.Permissions.Text.ToLower) > 0;
  end;


  FAndroidPermissions.PopulatePermissionStrings(lbPermissionsDangerous.Items, False, True);
  for ICount := 0 to lbPermissionsDangerous.Items.Count-1 do
  begin
    Supports(lbPermissionsDangerous.Items.Objects[ICount], IMbAndroidPermission, p);
    lbPermissionsDangerous.Checked[ICount] := Pos(p.ID.ToLower, AAndroid.Permissions.Text.ToLower) > 0;
  end;
  lbPermissionsNormal.Invalidate;
  lbPermissionsDangerous.Invalidate;
end;

procedure TfrmProjectDetails.PopulateProfiles(AType: TmbDeploymentType);//(ACert: string);
var
  AHost: string;
  APort: integer;
  AProfile: TProfile;
  ADesc: string;
  ACertDesc: string;
  ABundles: TStrings;
begin
  Screen.Cursor := crHourGlass;

  case AType of
    mbDeplyDevelopment: ADesc := 'iphone developer';
    mbDeployAppStore: ADesc := 'iphone distribution';
  end;

  //if cbProvisionCert.ItemIndex > -1 then
 //   ASelectedCert.FromJson(cbProvisionCert.Items[cbProvisionCert.ItemIndex]);
  cbProvisionProfile.Items.BeginUpdate;
  ABundles := TStringList.Create;
  try
  AHost := GlobalSetting('mosco', 'host');
  APort := StrToIntDef(GlobalSetting('mosco', 'port'), 8088);

  FProfiles := CreateMoscoUtils(Ahost, APort).GetProfiles;
  cbProvisionProfile.Items.Clear;


  for AProfile in FProfiles do
  begin
    for ACertDesc in  AProfile.CertDescriptions do
    begin
      if Pos(ADesc, ACertDesc.ToLower) > 0 then
      begin
        if (AProfile.ExpiryDate >= Date) and (ABundles.IndexOf(AProfile.BundleID) = -1) then
        begin
          cbProvisionProfile.Items.Add(AProfile.ToJsonValue.ToJSON);
          if FProject.IosSettings.ProvisionProfileID[AType] = AProfile.UUID then
            cbProvisionProfile.ItemIndex := cbProvisionProfile.Items.Count-1;
          ABundles.Add(AProfile.BundleID);
        end;
      end;
    end;
  end;

{  SetMoscoConnectionErrorVisible(False);
  Screen.Cursor := crHourGlass;
  cbProvisionProfile.Items.BeginUpdate;
  try
    ASelected := FProject.IosSettings.ProvisionProfileID[AType];

    AHost := GlobalSetting('mosco', 'host');
    APort := StrToIntDef(GlobalSetting('mosco', 'port'), 8088);

    FProfiles := GetProfiles(Ahost, APort);
    for AProfile in FProfiles do
    begin
      cbProvisionProfile.Items.Add(AProfile.ToJsonValue.ToJSON);
    end;
    cbProvisionProfile.Items.Add(AProfile.ToJsonValue.ToJSON);
         }
  finally
    screen.cursor := crDefault;
    cbProvisionProfile.Items.EndUpdate;
    ABundles.Free;
  end;
end;

procedure TfrmProjectDetails.PopulateProvisioning;
var
  AType: TMbDeploymentType;
  AProfile: TProfile;
begin
  screen.Cursor := crHourGlass;
  cbProvisionProfile.Items.BeginUpdate;
  cbProvisionCert.Items.BeginUpdate;
  try
    cbProvisionProfile.Enabled := False;
    cbProvisionCert.Enabled := False;

    AType := mbDeplyDevelopment;

    if tabProvisioning.TabIndex = 1 then
      AType := mbDeployAppStore;

    PopulateProfiles(AType);


    if cbProvisionProfile.ItemIndex > -1 then
      AProfile.FromJson(cbProvisionProfile.Items[cbProvisionProfile.ItemIndex]);

    PopulateCertificates(AType, AProfile);
  finally
    cbProvisionProfile.Enabled := True;
    cbProvisionCert.Enabled := True;
    cbProvisionProfile.Items.EndUpdate;
    cbProvisionCert.Items.Endupdate;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmProjectDetails.PopulateSplashScreens;
var
  AImg:ImbImage;
begin
  btnAutoSelectSplash.Visible := SelectedPlatform = mbAndroid64;
  lbSplashScreens.Items.Clear;
  for AImg in FProject.PlatformSettings[SelectedPlatform].Images.Splash do
    lbSplashScreens.Items.AddObject('',  TObject(AImg));
end;

procedure TfrmProjectDetails.PopupMenu1Popup(Sender: TObject);
var
  AFolders: TStrings;
  AStr: string;
  AMenuItem: TMenuItem;
begin
  inherited;
  PopupMenu1.Items.Clear;
  AFolders := TStringList.Create;
  try
    GetDeploymentPaths(AFolders);
    for AStr in AFolders do
    begin
      AMenuItem := TMenuItem.Create(PopupMenu1);
      AMenuItem.OnClick := ClickDeployMenuItem;
      AMenuItem.Caption := AStr;
      AMenuItem.Hint := AStr;
      PopupMenu1.Items.Add(AMenuItem);
    end;
  finally
    AFolders.Free;
  end;

end;

procedure TfrmProjectDetails.ProjectToEdits;
var
  APlatformSettings: IMbProjectPlatform;
begin
  lblProject.Caption := FProject.Filename;
  APlatformSettings := FProject.PlatformSettings[SelectedPlatform];
  edtTitle.Text := FProject.Title;

  cbSdk.ItemIndex := cbSdk.Items.IndexOfName(APlatformSettings.Sdk);
  cbProfile.ItemIndex := cbProfile.Items.IndexOfName(APlatformSettings.ConnectionProfile);

  if ListBox1.ItemIndex = -1 then
  begin
   ListBox1.ItemIndex := 0;
   ListBox1Click(Self);
  end;
  UpdateInspector;
  UpdateVersion;
  UpdateUsageDescriptions;
  PopulateDeploymentFiles;
  PopulateEntitlements;
end;

procedure TfrmProjectDetails.btnAutoSelectIconsClick(Sender: TObject);
begin
  inherited;
  if JvBrowseForFolderDialog1.Execute then
  begin
    Screen.Cursor := crHourGlass;
    try
      FProject.PlatformSettings[SelectedPlatform].Images.Icons.LoadFromFolder(JvBrowseForFolderDialog1.Directory);
      lbIcons.Invalidate;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TfrmProjectDetails.SpeedButton2Click(Sender: TObject);
var
  AImg: IMbImage;
begin
  inherited;
  if (MessageDlg(C_CLEAR_PROJECT_ICONS+'...'+#13+#10+''+#13+#10+C_ARE_YOU_SURE, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    for AImg in FProject.PlatformSettings[SelectedPlatform].Images.Icons do
      AImg.Filename := '';
    lbIcons.Invalidate;
  end;
end;

procedure TfrmProjectDetails.btnAutoSelectSplashClick(Sender: TObject);

  procedure ListFileDir(Path: string; FileList: TStrings);
  var
    SR: TSearchRec;
  begin
    if FindFirst(Path + '*.png', faAnyFile, SR) = 0 then
    begin
      repeat
        if (SR.Attr <> faDirectory) then
        begin
          FileList.Add(Path+SR.Name);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  end;

var
  AFiles: TStrings;
  AFile: string;
begin
  inherited;
  JvBrowseForFolderDialog1.Directory := ExtractFilePath(FProject.Filename);
  if JvBrowseForFolderDialog1.Execute then
  begin
    Screen.Cursor := crHourGlass;
    AFiles := TStringList.Create;
    try
      ListFileDir(IncludeTrailingPathDelimiter(JvBrowseForFolderDialog1.Directory), AFiles);
      for AFile in AFiles do
        FProject.PlatformSettings[SelectedPlatform].Images.Splash.AddFromFile(AFile);
    finally
      AFiles.Free;
      Screen.Cursor := crDefault;
    end;
    PopulateSplashScreens;
  end;
end;

procedure TfrmProjectDetails.SpeedButton4Click(Sender: TObject);
var
  AImg: IMbImage;
begin
  inherited;
  if (MessageDlg(C_CLEAR_PROJECT_SPLASH+'...'+#13+#10+''+#13+#10+C_ARE_YOU_SURE, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    for AImg in FProject.PlatformSettings[SelectedPlatform].Images.Splash do
      AImg.Filename := '';
    lbSplashScreens.Invalidate;
  end;
end;

procedure TfrmProjectDetails.SpeedButton5Click(Sender: TObject);
var
  AFile: string;
begin
  inherited;
  if OpenDialog1.Execute then
  begin
    for AFile in OpenDialog1.Files do
    begin
      FProject.PlatformSettings[SelectedPlatform].DeploymentFiles.AddFile(AFile);
    end;
    PopulateDeploymentFiles;
  end;
end;

procedure TfrmProjectDetails.SpeedButton6Click(Sender: TObject);
var
  AFiles: TStrings;
  AFile: string;
begin
  inherited;
  AFiles := TStringList.Create;
  try
    if AddFilesFromFolder(AFiles) = mrOk then
    begin
      for AFile in AFiles do
        FProject.PlatformSettings[SelectedPlatform].DeploymentFiles.AddFile(AFile);
    end;
  finally
    AFiles.Free;
  end;
  PopulateDeploymentFiles;
end;

procedure TfrmProjectDetails.SpeedButton7Click(Sender: TObject);
begin
  inherited;
  if (MessageDlg(C_REMOVE_SELECTED_FILE+'...'+#13+#10+''+#13+#10+C_ARE_YOU_SURE, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    FProject.PlatformSettings[SelectedPlatform].DeploymentFiles.Delete(gridDeploy.Row-1);
    PopulateDeploymentFiles;
  end;
end;

procedure TfrmProjectDetails.tabIconsShow(Sender: TObject);
begin
  inherited;
  PopulateIcons;
end;

procedure TfrmProjectDetails.tabPlatformsChange(Sender: TObject);
var
  ADefault: string;
begin
  inherited;
  Setting['config', 'projectTab'] := tabPlatforms.TabIndex.ToString;
  PopulatePageList;
  UpdateInspector;
  PopulateFrameworks;
  GetConnectionProfiles(SelectedPlatform, cbProfile.Items, ADefault);

  ProjectToEdits;
end;

procedure TfrmProjectDetails.tabPlatformsChanging(Sender: TObject; var AllowChange: Boolean);
begin
  inherited;
  EditsToProject;
end;

procedure TfrmProjectDetails.tabProvisioningChange(Sender: TObject);
begin
  inherited;
  PopulateProvisioning;
end;

procedure TfrmProjectDetails.SetMoscoConnectionErrorVisible(AValue: Boolean);
begin
  pnlMoscoError.Visible := AValue;
end;

procedure TfrmProjectDetails.PopulateCertificates(AType: TmbDeploymentType; AProfile: TProfile);
var
  AIdentity: TIdentity;
  AHost: string;
  APort: integer;
  AStr: string;
begin


  AHost := GlobalSetting('mosco', 'host');
  APort := StrToIntDef(GlobalSetting('mosco', 'port'), 8088);

  FIdentities := CreateMoscoUtils(Ahost, APort).GetIdentities(ctDevelopment);

  cbProvisionCert.Items.Clear;
  for AIdentity in FIdentities do
  begin
    //if AType = mbDeplyDevelopment then AStr := 'iphone developer';
    //if AType = mbDeployAppStore then AStr := 'iphone distribution';
    //if Pos(AStr, AIdentity.Description.ToLower) > 0  then

    for AStr in AProfile.CertDescriptions do
    begin
      if AStr.ToLower = AIdentity.Description.ToLower then
      begin
        cbProvisionCert.Items.Add(AIdentity.ToJsonValue.ToJSON);
        if AIdentity.Description = FProject.IosSettings.ProvisionCert[AType] then
          cbProvisionCert.ItemIndex := cbProvisionCert.Items.Count-1;
      end;
    end;
  end;

 { if FProfiles <> nil then
  begin
    for AProfile in FProfiles do
    begin
      if AProfile.UUID = AProfileID then
      begin

        //AProfile.PopulateCerts(cbProvisionCert.Items);
        //.cbProvisionCert.ItemIndex := cbProvisionCert.Items.IndexOf(FProject.IosSettings.ProvisionCert[AType]);

      end;
    end;
  end;  }
end;

procedure TfrmProjectDetails.TabSheet1Show(Sender: TObject);
begin
  inherited;
  PopulateProvisioning;
end;

procedure TfrmProjectDetails.TabSheet5Resize(Sender: TObject);
begin
  inherited;
  Panel17.Width := TabSheet5.Width div 2;
end;

procedure TfrmProjectDetails.TabSheet5Show(Sender: TObject);
begin
  inherited;
  PopulatePermissions;
end;

procedure TfrmProjectDetails.TabSheet9Show(Sender: TObject);
begin
  inherited;
  Application.ProcessMessages;
  PopulateKeyStore;
end;

procedure TfrmProjectDetails.tabSplashScreensShow(Sender: TObject);
begin
  inherited;
  PopulateSplashScreens;
end;

end.
