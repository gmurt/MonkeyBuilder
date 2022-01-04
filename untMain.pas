unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.Menus, Vcl.StdCtrls, System.Generics.Collections,
  Vcl.ComCtrls, System.Actions, System.ImageList, Vcl.ImgList, Vcl.ActnList,
  Vcl.Buttons, Vcl.Imaging.pngimage,
  untBaseForm,
  {untTypes, }Spring.Collections.Lists, MonkeyBuilder_Intf,

  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  Vcl.FileCtrl, Vcl.ShellAnimations, Vcl.ToolWin, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.VirtualImageList;

type
  TfrmMain = class(TfrmBaseForm)
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    ActionList1: TActionList;
    actAddProject: TAction;
    actRemoveProject: TAction;
    actBuild: TAction;
    actAbout: TAction;
    OpenDialog1: TOpenDialog;
    actDeploy: TAction;
    actBuildAndDeploy: TAction;
    Bevel1: TBevel;
    actBuilds: TAction;
    actSettings: TAction;
    PopupMenu2: TPopupMenu;
    Copy1: TMenuItem;
    actUpdate: TAction;
    Timer1: TTimer;
    actEditProject: TAction;
    popupProjects: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    N1: TMenuItem;
    Remove1: TMenuItem;
    N2: TMenuItem;
    actBuildIos: TAction;
    actBuildAndroid: TAction;
    actBuildIosAndAndroid: TAction;
    actBuildDeployAppStoreIos: TAction;
    actBuildDeployAppStoreAndroid: TAction;
    actBuildDeplyAppStoreIosAndroid: TAction;
    actOpenInExplorer: TAction;
    N3: TMenuItem;
    OpeninExplorer1: TMenuItem;
    BuildforAndroid1: TMenuItem;
    BuildforiOS1: TMenuItem;
    actEnglish: TAction;
    actCopyLog: TAction;
    actSelectAllLog: TAction;
    actIconManager: TAction;
    Timer2: TTimer;
    actGetMosco: TAction;
    Panel1: TPanel;
    actIssues: TAction;
    actDevelopment: TAction;
    actAppStore: TAction;
    actBuildAndDeployDevelopmentAndroid: TAction;
    actBuildAndDeployDevelopmentiOS: TAction;
    TabControl2: TTabControl;
    lbLogWindow: TListBox;
    popupTabs: TPopupMenu;
    CloseTab1: TMenuItem;
    Panel4: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    Bevel2: TBevel;
    Bevel7: TBevel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Bevel8: TBevel;
    SpeedButton6: TSpeedButton;
    Bevel9: TBevel;
    SpeedButton7: TSpeedButton;
    Bevel10: TBevel;
    SpeedButton8: TSpeedButton;
    Bevel11: TBevel;
    SpeedButton9: TSpeedButton;
    popupAppStore: TPopupMenu;
    BuildDeployforAndroid1: TMenuItem;
    BuildDeployforiOS1: TMenuItem;
    BuildDeployforiOSAndroid1: TMenuItem;
    VirtualImageList2: TVirtualImageList;
    popupBuild: TPopupMenu;
    BuildforAndroid2: TMenuItem;
    BuildforiOS2: TMenuItem;
    ListBox1: TListBox;
    VirtualImageList3: TVirtualImageList;
    procedure actAddProjectExecute(Sender: TObject);
    procedure actRemoveProjectExecute(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure actBuildsExecute(Sender: TObject);
    procedure actSettingsExecute(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actEditProjectExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    //procedure JvAppIniFileStorage1GetFileName(Sender: TJvCustomAppStorage; var FileName: TFileName);
    procedure actBuildIosExecute(Sender: TObject);
    procedure actBuildAndroidExecute(Sender: TObject);
    procedure actBuildIosAndAndroidExecute(Sender: TObject);
    procedure actBuildDeployAppStoreIosExecute(Sender: TObject);
    procedure actBuildDeployAppStoreAndroidExecute(Sender: TObject);
    procedure actBuildDeplyAppStoreIosAndroidExecute(Sender: TObject);
    procedure actOpenInExplorerExecute(Sender: TObject);
   // procedure English1Click(Sender: TObject);
    procedure actCopyLogExecute(Sender: TObject);
    procedure actSelectAllLogExecute(Sender: TObject);
    procedure actIconManagerExecute(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure actBuildExecute(Sender: TObject);
    procedure actBuildAndDeployExecute(Sender: TObject);
    procedure actGetMoscoExecute(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure actIssuesExecute(Sender: TObject);
    procedure actDevelopmentExecute(Sender: TObject);
    procedure actAppStoreExecute(Sender: TObject);
    procedure actBuildAndDeployDevelopmentAndroidExecute(Sender: TObject);
    procedure actBuildAndDeployDevelopmentiOSExecute(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TabControl2Change(Sender: TObject);
    procedure lbLogWindowDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TabControl2DrawTab(Control: TCustomTabControl; TabIndex: Integer;
      const Rect: TRect; Active: Boolean);
    procedure CloseTab1Click(Sender: TObject);
    procedure SpeedButton5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FProjectsNew: IMbProjectList;
    procedure OnOutput(const AText: string);
    procedure RefreshProjectList;
    function GetSelectedProjects: IMbProjectList;
    procedure UpdateActionStates;
    procedure RunBuild(APlatforms: TmbPlatforms; ADeployType: TmbDeploymentType);
    procedure RunBuildAndDeploy(APlatforms: TmbPlatforms; ADeployType: TmbDeploymentType; ADeviceID: string);
    procedure UpdateCaption;
    function GetCurrentETag: string;
    procedure SetCurrentETag(const Value: string);
    function EditProject(AProject: IMbProject): Boolean;
    //procedure DeployToAndroidDevice(Sender: TObject);
    //procedure DeployToIosDevice(Sender: TObject);
    procedure AddTab(AName, APlatform: string);
    procedure UpdateTabs;
    { Private declarations }
  protected
    procedure DoShow; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure KillCompilerProcesses;
    procedure CheckForUpdate(AShowMsg: Boolean);
    property SelectedProjects: IMbProjectList read GetSelectedProjects;
    property CurrentETag: string read GetCurrentETag write SetCurrentETag;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses DateUtils, System.Threading, untProjectDetails,
  ksInspector, JsonDataobjects, System.IOUtils, untConst, Inifiles,
  IdGlobal, ShellApi, untSettings, CLipBrd, System.UITypes, untMoscoUtils,
  untAbout, untLoading, ActiveX, System.Types, TlHelp32, System.NetEncoding,
  untDprojUtils, untIconGenerator, MonkeyBuilder.Project, untAndroidHelper,
  untMbUtils, System.SysUtils, JclStrings;

{$R *.dfm}

procedure TfrmMain.actAboutExecute(Sender: TObject);
begin
  ShowAboutForm;
end;


procedure GetApplicationVersion(var AMajor, AMinor, ARelease,
  ABuild: integer; const AExe: string = '');
var
	VerInfoSize, VerValueSize, DUMMY: DWORD;
	VerInfo:pointer;
	VerValue: PVSFixedFileInfo;
  AFilename: string;
begin
  AMajor := 0;
  AMinor := 0;
  ARelease := 0;
  ABuild := 0;
  AFileName := AExe;

  if AFileName = '' then
    AFileName := ParamStr(0);
  if FileExists(AFilename) = False then
    Exit;
  VerInfoSize:=GetFileVersionInfoSize(Pchar(AFilename), DUMMY);
	GetMem(verinfo, verinfosize);
	GetFileVersionInfo(pchar(AFilename),0,VerInfoSize, VerInfo);
  if VerInfo = nil then
    Exit;
	VerQueryValue(VerInfo,'\',Pointer(VerValue), VerValueSize);

		AMajor := VerValue^.dwFileVersionMS shr 16;				//Major
		AMinor := VerValue^.dwFileVersionMS and $FFFF;		//Minor
		ARelease := VerValue^.dwFileVersionLS shr 16;		  //Release
		ABuild := VerValue^.dwFileVersionLS and $FFFF;    //Build

	FreeMem(VerInfo, VerInfoSize);
end;


function GetVersionStr(const AFile: string = ''): string;


var
  v1, v2, v3, v4: integer;
begin
  GetApplicationVersion(v1, v2, v3, v4, AFile);
  Result := Format('%d.%d.%d.', [v1, v2, v3])+FormatFloat('0000', v4);
end;


function GetBuildNumber: integer;
var
  v1, v2, v3, v4: integer;
begin
  GetApplicationVersion(v1, v2, v3, v4);
  Result := v4;
end;

function GetLanguage: string;
var
  AList : array [0..9] of LongWord;
  AklName: array [0..255] of Char;
  i: Longint;
begin
  for i:= 0 to GetKeyboardLayoutList(SizeOf(AList), AList)- 1 do
  begin
    GetLocaleInfo(LoWord(AList[i]), LOCALE_SLANGUAGE, AklName, SizeOf(AklName));
    Result := AklName;
  end;
end;


procedure TfrmMain.actAddProjectExecute(Sender: TObject);
var
  AProject: IMbProject;
  AFilename: string;
  AProjects: TStrings;
  ADpr: string;
begin
  AProjects := TStringList.Create;
  Screen.Cursor := crHourGlass;
  try
    TStringList(AProjects).Duplicates := TDuplicates.dupIgnore;
    
    if OpenDialog1.Execute then
    begin
      for AFileName in OpenDialog1.Files do 
      begin
        if (ExtractFileExt(AFilename.ToLower) = '.dpr') or (ExtractFileExt(AFilename.ToLower) = '.dproj')  then
          AProjects.Add(AFilename);
      end;

     for ADpr in AProjects do
      begin
        if FProjectsNew.ProjectExists(ADpr) = False then
        begin
          AProject := CreateProject;
          try
            AProject.Filename := ADpr;
            AProject.InitializeFromDproj;
            FProjectsNew.AddProject.Assign(AProject);

          except
            on E:Exception do
              ShowMessage('Error adding "'+ExtractFileName(ADpr)+'...'+#13#10+#13#10+e.Message);

          end;
        end;
      end;
      EditProject(FProjectsNew.ProjectByFilename(ADpr));
    end;

  finally
    AProjects.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.actAppStoreExecute(Sender: TObject);
begin
  inherited;
//
end;

function KillTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile))
      = UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile)
      = UpperCase(ExeFileName))) then
      Result := Integer(TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0),
        FProcessEntry32.th32ProcessID), 0));
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

procedure TfrmMain.actRemoveProjectExecute(Sender: TObject);
var
  AProject: ImbProject;
begin
  if (MessageDlg(C_REMOVE_PROJECTS + #13 + #10 + '' + #13 + #10 +
    C_ARE_YOU_SURE, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
  begin
    for AProject in SelectedProjects do
    begin
      FProjectsNew.Remove(AProject);
    end;
    FProjectsNew.SaveToFile(AppDataDir + 'projects.json');
    RefreshProjectList;
  end;
end;

procedure TfrmMain.actSelectAllLogExecute(Sender: TObject);
begin
  inherited;
  lbLogWindow.SelectAll;
end;

procedure TfrmMain.actSettingsExecute(Sender: TObject);
begin
  ShowSettings;
end;

procedure TfrmMain.KillCompilerProcesses;
begin
 KillTask('dcciosarm64.exe');
end;

procedure TfrmMain.lbLogWindowDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  lb: TListBox;
  AStr: string;
begin
  inherited;
  lb := Control as TListBox;
  AStr := lb.Items[index];

  if Pos('Linker command line', AStr) > 0 then
  begin
    AStr := 'Linking...';
  end;


  lb.Canvas.FillRect(Rect);

  if (Pos('Hint:', AStr) > 0) then lb.Canvas.Font.Color := $00FF8000;
  if (Pos('Warning:', AStr) > 0) then lb.Canvas.Font.Color := $004080FF;
  if (Pos('Error:', AStr) > 0) or (Pos('Fatal:', AStr) > 0)then lb.Canvas.Font.Color := clRed;

  if (odSelected in State) then
    lb.Canvas.Font.Color := clWhite;
  lb.Canvas.TextOut(Rect.Left+4, Rect.Top+6, AStr);
end;

procedure TfrmMain.OnOutput(const AText: string);
begin
  //
end;

procedure TfrmMain.RefreshProjectList;
var
  AProject: ImbProject;
begin
  ListBox1.Items.Clear;
  for AProject in FProjectsNew do
    ListBox1.Items.AddObject(AProject.Filename, TObject(AProject));
  UpdateActionStates;
end;

procedure TfrmMain.TabControl2Change(Sender: TObject);
begin
  inherited;
  UpdateTabs;
end;



procedure TfrmMain.TabControl2DrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  AName: string;
  APlat: string;
  AImg: TIcon;
begin
  inherited;
  Control.Canvas.FillRect(Rect);
  AName := StrBefore('|', TTabControl(Control).Tabs[TabIndex]);
  APlat := StrAfter('|', TTabControl(Control).Tabs[TabIndex]);
  Control.Canvas.TextOut(Rect.Left+36, Rect.Top+12, AName);

  AImg := TIcon.Create;
  try
    if APlat.ToLower = 'iosdevice64' then VirtualImageList2.Draw(Control.Canvas, Rect.Left+8, Rect.Top+8, 'imgApple'); //JvImageList1.GetIcon(9, AImg);
    if APlat.ToLower = 'android64' then VirtualImageList2.Draw(Control.Canvas, Rect.Left+8, Rect.Top+8, 'imgAndroid');
  finally
    AImg.Free;
  end;
end;

procedure TfrmMain.Timer2Timer(Sender: TObject);
begin
  UpdateTabs;
end;

procedure TfrmMain.UpdateActionStates;
begin
  actRemoveProject.Enabled := ListBox1.SelCount > 0;
  actEditProject.Enabled := ListBox1.SelCount = 1;
  actBuild.Enabled := ListBox1.SelCount > 0;
  actDevelopment.Enabled := ListBox1.SelCount > 0;
  actAppStore.Enabled := ListBox1.SelCount > 0;
  actBuildAndDeploy.Enabled := ListBox1.SelCount > 0;
  actOpenInExplorer.Enabled := ListBox1.SelCount > 0;
end;

procedure TfrmMain.UpdateCaption;
begin
  inherited;
  Caption := 'Monkey Builder v' + AppVersionStr;
end;

procedure TfrmMain.UpdateTabs;
var
  ASelectedTab: string;
  AProject: IMbProject;
  ASelectedProject: string;
  ASelectedPlatform: TmbPlatform;
begin
  inherited;

  lbLogWindow.Items.BeginUpdate;
  if TabControl2.TabIndex = -1 then
    lbLogWindow.Clear;
  ASelectedTab := '';
  ASelectedProject := '';
  ASelectedPlatform := mbIosDevice64;

  if TabControl2.TabIndex > -1 then
  begin
    ASelectedTab := TabControl2.Tabs[TabControl2.TabIndex];
    ASelectedProject := StrBefore('|', ASelectedTab);
    ASelectedPlatform := StrToPlatform(StrAfter('|', ASelectedTab));
  end;

  for AProject in FProjectsNew do
  begin
    if AProject.ProjectName.ToLower = ASelectedProject.ToLower then
    begin
      if lbLogWindow.Items.Text <> AProject.PlatformSettings[ASelectedPlatform].Log.Text then
        lbLogWindow.Items.Assign(AProject.PlatformSettings[ASelectedPlatform].Log);
    end;
  end;
  lbLogWindow.Items.EndUpdate;
end;


procedure TfrmMain.CheckForUpdate(AShowMsg: Boolean);
begin
 //
end;

procedure TfrmMain.CloseTab1Click(Sender: TObject);
var
  AName: string;
  APlat: string;
  AIndex: integer;
  ALastIndex: integer;
begin
  inherited;
  ALastIndex := TabControl2.TabIndex;
  AIndex := TabControl2.TabIndex;
  AName := StrBefore('|', TabControl2.Tabs[AIndex]);
  APlat := StrAfter('|', TabControl2.Tabs[AIndex]);
  FProjectsNew.TerminateBuild(AName, StrToPlatform(Aplat));
  TabControl2.Tabs.Delete(AIndex);
  if TabControl2.Tabs.Count > 0 then
  begin
    if ALastIndex > 0 then ALastIndex := ALastIndex-1;
    TabControl2.TabIndex := ALastIndex;
  end;

  UpdateTabs;

end;

constructor TfrmMain.Create(AOwner: TComponent);

begin
  inherited;
  ShowLoading;

  FProjectsNew := CreateProjectList;
  ListBox1.DoubleBuffered := True;

  if FileExists(AppDataDir + 'projects.json') then
  begin
    try
      FProjectsNew.LoadFromFile(AppDataDir + 'projects.json');
    except
    end;
  end;
  RefreshProjectList;
  HideLoading;
end;

destructor TfrmMain.Destroy;
begin
  inherited;
end;

procedure TfrmMain.DoShow;
begin
  CheckForUpdate(True);
  StatusBar1.Panels[0].Text := '';
  UpdateCaption;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Timer2.Enabled := False;
  lbLogWindow.Items.Add('');
  lbLogWindow.Items.Add('Waiting for processes to finish...');
  FProjectsNew.TerminateAllBuilds;
end;

function TfrmMain.GetCurrentETag: string;
begin
  Result := Setting['version', 'etag'];
end;

function TfrmMain.GetSelectedProjects: IMbProjectList;
var
  ICount: Integer;
begin
  Result := CreateProjectList;
  for ICount := 0 to ListBox1.Items.Count - 1 do
  begin
    if ListBox1.Selected[ICount] then
    begin
      Result.Add(fProjectsNew[ICount]);
    end;
  end;

end;

procedure TfrmMain.ListBox1Click(Sender: TObject);
begin
  UpdateActionStates;
end;

procedure TfrmMain.ListBox1DblClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    if ShowProjectDetails(FProjectsNew[ListBox1.ItemIndex]) = mrOk then
    begin
      FProjectsNew.SortByName;
      FProjectsNew.SaveToFile(AppDataDir + 'projects.json');

      ListBox1.Invalidate;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  AProject: ImbProject;
  AIconRect: TRect;
  AImg: IMbImage;
  ASettingsRect: TRect;
  ACanvas: TCanvas;
begin
  AProject := FProjectsNew[Index];
  ACanvas := ListBox1.Canvas;
  begin
    AImg := AProject.IosSettings.Images.Icons.LargestImage;
    AIconRect := System.Classes.Rect(4, Rect.Top + 14, 4 + 48, Rect.Top + 14 + 48);
    if (odSelected in State) then
      ACanvas.Brush.Color := $00FFBA75;

    ACanvas.FillRect(Rect);


    if AImg <> nil then
    begin
      AImg.DrawToCanvas(ACanvas, AIconRect);
    end;

    ACanvas.Pen.Color := clGray;
    ACanvas.Brush.Style := bsClear;
    ACanvas.Rectangle(AIconRect);

    ACanvas.Font.Name := 'Calibri';
    ACanvas.Font.Size := 12;
    ACanvas.TextOut(Rect.Left + 64, Rect.Top + 10, AProject.Title);
    ACanvas.Font.Style := [];
    ACanvas.Font.Size := 10;
    if (not(odSelected in State)) then
      ACanvas.Font.Color := clGrayText;

    VirtualImageList3.Draw(ACanvas,  Rect.Left+64, Rect.Top+32, 'imgApple');
    VirtualImageList3.Draw(ACanvas,  Rect.Left+64, Rect.Top+50, 'imgAndroid');

    ACanvas.TextOut(Rect.Left + 84, Rect.Top + 32, AProject.IosSettings.Version.AsString);
    ACanvas.TextOut(Rect.Left + 84, Rect.Top + 50, AProject.AndroidSettings.Version.AsString);
    ACanvas.Font.Style := [];

    ASettingsRect := Rect;
    ASettingsRect.Left := Rect.Right - 140;
    ASettingsRect.Right := Rect.Right - 20;


    if (odFocused in State) then
      ACanvas.DrawFocusRect(Rect);
  end;
end;

procedure TfrmMain.ListBox1KeyDown(Sender: TObject; var Key: Word;
Shift: TShiftState);
begin
  inherited;
  if (Chr(Key) = 'A') and (ssCtrl in Shift) then
  begin
    ListBox1.SelectAll;
    UpdateActionStates;
  end;
end;

procedure TfrmMain.ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  AIndex: integer;
  ICount: integer;
begin
  inherited;
  AIndex := ListBox1.ItemAtPos(Point(x,y), True);
  if (SelectedProjects.Count <= 1) or (AIndex = -1) then
  begin
    for ICount := 0 to ListBox1.Items.Count-1 do
      ListBox1.Selected[ICount] := False;
    if AIndex > -1 then
      ListBox1.Selected[AIndex] := True;
  end;

  UpdateActionStates;
end;

procedure TfrmMain.SetCurrentETag(const Value: string);
begin
  Setting['version', 'etag'] := Value;
end;

procedure TfrmMain.SpeedButton4MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  popupBuild.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfrmMain.SpeedButton5MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  popupAppStore.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TfrmMain.actBuildAndDeployDevelopmentAndroidExecute(Sender: TObject);
begin
  inherited;
  RunBuildAndDeploy([mbAndroid64], mbDeplyDevelopment, '');
end;

procedure TfrmMain.actBuildAndDeployDevelopmentiOSExecute(Sender: TObject);
begin
  inherited;
  RunBuildAndDeploy([mbIosDevice64], mbDeplyDevelopment, '');

end;

procedure TfrmMain.actBuildAndDeployExecute(Sender: TObject);
begin
  inherited;
  {do not remove - used by an action}
end;

procedure TfrmMain.actBuildAndroidExecute(Sender: TObject);
begin
  inherited;
  RunBuild([mbAndroid64], mbDeplyDevelopment);
end;

procedure TfrmMain.actBuildDeployAppStoreAndroidExecute(Sender: TObject);
begin
  inherited;
  RunBuildAndDeploy([mbAndroid64], mbDeployAppStore, '');
end;

procedure TfrmMain.actBuildDeployAppStoreIosExecute(Sender: TObject);
begin
  inherited;

  RunBuildAndDeploy([mbIosDevice64], mbDeployAppStore, '');
end;

procedure TfrmMain.actBuildDeplyAppStoreIosAndroidExecute(Sender: TObject);
begin
  inherited;
  RunBuildAndDeploy([mbAndroid64, mbIosDevice64], mbDeployAppStore, '');
end;

procedure TfrmMain.actBuildExecute(Sender: TObject);
begin
  inherited;
//
end;

procedure TfrmMain.AddTab(AName, APlatform: string);
var
  ATab: string;
begin
  ATab := AName+'|'+APlatform;
  if TabControl2.Tabs.IndexOf(ATab) = -1 then
    TabControl2.Tabs.Add(ATab);
  TabControl2.TabIndex := TabControl2.Tabs.IndexOf(ATab);
  Application.ProcessMessages;
end;

procedure TfrmMain.RunBuild(APlatforms: TmbPlatforms; ADeployType: TmbDeploymentType);
var
  APlatform: TmbPlatform;
  ICount: integer;
begin
  for ICount := 0 to ListBox1.Items.Count-1 do
  begin
    if ListBox1.Selected[ICount] then
    begin
      for APlatform in APlatforms do
      begin
        AddTab(FProjectsNew[ICount].ProjectName, PlatformToStr(APlatform));
        FProjectsNew[ICount].Build(APlatform, '', ADeployType, OnOutput);
      end;
    end;
  end;
end;

procedure  TfrmMain.RunBuildAndDeploy(APlatforms: TmbPlatforms; ADeployType: TmbDeploymentType; ADeviceID: string);
var
  APlatform: TmbPlatform;
  ICount: integer;
begin
  for ICount := 0 to ListBox1.Items.Count-1 do
  begin
    if ListBox1.Selected[ICount] then
    begin
      for APlatform in APlatforms do
      begin
        AddTab(FProjectsNew[ICount].ProjectName, PlatformToStr(APlatform));
        FProjectsNew[ICount].Build(APlatform, ADeviceID, ADeployType, OnOutput);
      end;
    end;
  end;
end;

procedure TfrmMain.actBuildIosAndAndroidExecute(Sender: TObject);
begin
  inherited;
  RunBuild([mbAndroid64, mbIosDevice64], mbDeplyDevelopment);
end;

procedure TfrmMain.actBuildIosExecute(Sender: TObject);
begin
  inherited;
  RunBuild([mbIosDevice64], mbDeplyDevelopment);

end;

procedure TfrmMain.actBuildsExecute(Sender: TObject);
begin
  ForceDirectories(AppDir + 'Builds\');
  ShellExecute(Application.Handle, nil, 'explorer.exe',
    PChar(BuildFolder), nil, SW_NORMAL);
end;

procedure TfrmMain.actCopyLogExecute(Sender: TObject);
begin
  inherited;
  if lbLogWindow.ItemIndex > -1 then
    Clipboard.AsText := lbLogWindow.Items[lbLogWindow.ItemIndex];
end;

procedure TfrmMain.actDevelopmentExecute(Sender: TObject);
begin
  inherited;
  CreateAndroidHelper.GetConnectedDevices;
end;

procedure TfrmMain.actEditProjectExecute(Sender: TObject);
begin
  inherited;
  if (ListBox1.ItemIndex > -1) and (ListBox1.SelCount = 1) then
  begin
    EditProject(FProjectsNew[ListBox1.ItemIndex]);
  end;
end;

function TfrmMain.EditProject(AProject: IMbProject): Boolean;
begin
  inherited;
  Screen.Cursor := crHourGlass;
  try
    Result := False;
    if ShowProjectDetails(AProject) = mrOk then
    begin
      FProjectsNew.SortByName;
      FProjectsNew.SaveToFile(AppDataDir + 'projects.json');
      RefreshProjectList;
      Result := True;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.actGetMoscoExecute(Sender: TObject);
begin
  inherited;
  ShellExecute(Application.Handle, nil, 'explorer.exe',
    PChar(AppDir + 'Mosco\'), nil, SW_NORMAL);
end;

procedure TfrmMain.actIconManagerExecute(Sender: TObject);
begin
  inherited;
  ShowIconGenerator;
end;

procedure TfrmMain.actIssuesExecute(Sender: TObject);
begin
  inherited;
  OpenURL('https://github.com/gmurt/MonkeyBuilder/issues')
end;

procedure TfrmMain.actOpenInExplorerExecute(Sender: TObject);
var
  AProject: IMbProject;
begin
  inherited;
  if ListBox1.ItemIndex = -1 then
    Exit;
  if Supports(ListBox1.Items.Objects[ListBox1.ItemIndex], IMbProject, AProject) then
  begin
    ShellExecute(Application.Handle, nil, 'explorer.exe', PChar(AProject.ProjectDir), nil, SW_NORMAL);
  end;
end;

end.
