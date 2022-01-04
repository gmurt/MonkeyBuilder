unit untIconGenerator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untBaseForm, JvComponentBase,
  JvComputerInfoEx, Vcl.ExtCtrls, Vcl.ComCtrls, System.ImageList, Vcl.ImgList,
  Vcl.StdCtrls, Vcl.Mask, JvExMask, JvToolEdit, Vcl.Imaging.pngimage, System.Generics.Collections,
  Vcl.ExtDlgs, JvImageList, JvBaseDlg, JvBrowseFolder;

type
  TIconImage = class
  private
    FName: string;
    FBitmap: TBitmap;
    FSize: integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure GenerateIcon(ASource: TBitmap);
    procedure SavePng(AFolder: string);
  end;

  TIconList = class(TObjectList<TIconImage>)
  protected
    procedure InitializeIcons; virtual; abstract;
  public
    constructor Create; virtual;
    procedure AddIcon(AName: string; ASize: integer);
    procedure GenerateAll(ASource: TBitmap);
    procedure SaveToFolder(ADir: string);

  end;

  TIosIconList = class(TIconList)
  protected
    procedure InitializeIcons; override;
  end;

  TAndroidIconList = class(TIconList)
  protected
    procedure InitializeIcons; override;
  end;

  TIconGenerator = class
  private
    FAndroidIcons: TAndroidIconList;
    FIosIcons: TIosIconList;
    procedure GenerateAll(ASource: TBitmap);

  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TfrmIconGenerator = class(TfrmBaseForm)
    Image1: TImage;
    Button1: TButton;
    ImageList1: TImageList;
    TabControl1: TTabControl;
    lv: TListView;
    Bevel1: TBevel;
    Panel1: TPanel;
    Panel2: TPanel;
    Button3: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Button2: TButton;
    Shape1: TShape;
    Label1: TLabel;
    Bevel2: TBevel;
    Label2: TLabel;
    lblFolder: TLabel;
    Label4: TLabel;
    JvImageList1: TJvImageList;
    JvBrowseForFolderDialog1: TJvBrowseForFolderDialog;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    FSource: TPngImage;
    FGenerator: TIconGenerator;
    FOutput: string;
    procedure PopulateIcons;
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  end;

  procedure ShowIconGenerator;

implementation

uses IOUtils, JclFileUtils, ShellApi;

type
TBitmapForceHalftone=class(TBitmap)
protected
  procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
end;

procedure ShowIconGenerator;
var
  frmIcon: TfrmIconGenerator;
begin
  frmIcon := TfrmIconGenerator.Create(nil);
  try
    frmIcon.ShowModal;
  finally
    frmIcon.Free;
  end;
end;

procedure SelectFileInExplorer(const Fn: string);
begin
  ShellExecute(Application.Handle, 'open', 'explorer.exe',
    PChar('/open,"' + Fn+'"'), nil, SW_NORMAL);
end;



procedure TBitmapForceHalftone.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  APt: TPoint;
  ADc: HDC;
begin
  ADc := ACanvas.Handle;
  GetBrushOrgEx(ADc, APt);
  SetStretchBltMode(ADc,HALFTONE);
  SetBrushOrgEx(ADc,APt.x,APt.y,@APt);
  StretchBlt(ADc, Rect.Left, Rect.Top, Rect.Right-Rect.Left, Rect.Bottom-Rect.Top, Canvas.Handle, 0, 0, Width, Height, ACanvas.CopyMode);
end;


procedure CreateIcon(w,h: integer; ASource: TBitmapForceHalftone; AResult: TBitmap);
var
  ABmp: TBitmapForceHalftone;
begin
  ABmp := TBitmapForceHalftone.Create;
  try
    ABmp.SetSize(w,h);
    ASource.Draw(ABmp.Canvas, Rect(0,0, w,h));
    AResult.Assign(ABmp);
  finally
    ABmp.Free;
  end;
end;

{$R *.dfm}

{ TfrmIconGenerator }

procedure TfrmIconGenerator.Button1Click(Sender: TObject);
var
  ABmp: TBitmap;
  ADir: string;
begin
  inherited;
  if FSource.Empty then
  begin
    ShowMessage('You need to load an icon image first.');
    Exit;
  end;
  ABmp := TBitmap.Create;
  try
    ABmp.SetSize(FSource.Width, FSource.Height);
    ABmp.Canvas.Draw(0, 0, FSource);
    FGenerator.GenerateAll(ABmp);

    ADir := IncludeTrailingPathDelimiter(JvBrowseForFolderDialog1.Directory)+'MonkeyBuilderIcons\android\';
    ForceDirectories(ADir);
    FGenerator.FAndroidIcons.SaveToFolder(ADir);
    ADir := IncludeTrailingPathDelimiter(JvBrowseForFolderDialog1.Directory)+'MonkeyBuilderIcons\iOS\';
    ForceDirectories(ADir);
    FGenerator.FIosIcons.SaveToFolder(ADir);
    SelectFileInExplorer(IncludeTrailingPathDelimiter(JvBrowseForFolderDialog1.Directory)+'MonkeyBuilderIcons\');
  finally
    ABmp.Free;
  end;
  PopulateIcons;
end;

procedure TfrmIconGenerator.Button2Click(Sender: TObject);
var
  ABmp: TBitmapForceHalftone;
  AResized: TBitmap;
begin
  inherited;
  if OpenPictureDialog1.Execute then
  begin
    JvBrowseForFolderDialog1.Directory := ExtractFilePath(OpenPictureDialog1.FileName);
    FSource.LoadFromFile(OpenPictureDialog1.FileName);
    AResized := TBitmap.Create;
    ABmp := TBitmapForceHalftone.Create;
    try
      ABmp.SetSize(1024,1024);
      FSource.Draw(ABmp.Canvas, Rect(0,0,1024,1024));

      CreateIcon(Image1.Width, Image1.Height, ABmp, AResized);

      Image1.Picture.Assign(AResized);

      ImageList1.Clear;
      CreateIcon(36, 36, ABmp, AResized);
      ImageList1.Add(AResized, nil);
      FOutput := IncludeTrailingPathDelimiter(ExtractFilePath(OpenPictureDialog1.FileName));
      lblFolder.Caption := FOutput;

    finally
      ABmp.Free;
      AResized.Free;
    end;
  end;
end;

procedure TfrmIconGenerator.Button3Click(Sender: TObject);
begin
  inherited;
  Close;
end;

constructor TfrmIconGenerator.Create(AOwner: TComponent);
begin
  inherited;
  FSource := TPngImage.Create;
  FGenerator := TIconGenerator.Create;
end;

destructor TfrmIconGenerator.Destroy;
begin
  FGenerator.Free;
  FSource.Free;
  inherited;
end;

procedure TfrmIconGenerator.Label4Click(Sender: TObject);
begin
  inherited;

  if FOutput <> '' then
    JvBrowseForFolderDialog1.Directory := FOutput;
  if JvBrowseForFolderDialog1.Execute then
    FOutput := IncludeTrailingPathDelimiter(JvBrowseForFolderDialog1.Directory);
  lblFolder.Caption := FOutput;
end;

procedure TfrmIconGenerator.PopulateIcons;
var
  AIcons: TIconList;
  AIcon: TIconImage;
  AItem: TListItem;
begin
  AIcons := nil;
  lv.Items.Clear;
  case TabControl1.TabIndex of
    0: AIcons := FGenerator.FIosIcons;
    1: AIcons := FGenerator.FAndroidIcons;
  end;
  for AIcon in AIcons do
  begin
    if AIcon.FBitmap.Empty = False then
    begin
      AItem := lv.Items.Add;

      AItem.Caption := AIcon.FName+' ('+AIcon.FSize.ToString+' x '+AIcon.FSize.ToString+')';
    end;
  end;

end;

procedure TfrmIconGenerator.TabControl1Change(Sender: TObject);
begin
  inherited;
  PopulateIcons;
end;

{ TIconList }

procedure TIconList.AddIcon(AName: string; ASize: integer);
var
  AIcon: TIconImage;
begin
  AIcon := TIconImage.Create;
  AIcon.FName := AName;
  AIcon.FSize := ASize;
  Add(AIcon);
end;


procedure TIconList.SaveToFolder(ADir: string);
var
  AIcon: TIconImage;
begin
  for AIcon in Self do
  begin
    AIcon.SavePng(ADir);
  end;
end;



constructor TIconList.Create;
begin
  inherited Create(True);
  InitializeIcons;
end;

procedure TIconList.GenerateAll(ASource: TBitmap);
var
  AIcon: TIconImage;
begin
  for AIcon in Self do
  begin
    AIcon.GenerateIcon(ASource);
  end;
end;

{ TIconGenerator }

constructor TIconGenerator.Create;
begin
  inherited;
  FIosIcons := TIosIconList.Create;
  FAndroidIcons := TAndroidIconList.Create;
end;

destructor TIconGenerator.Destroy;
begin
  FIosIcons.Free;
  FAndroidIcons.Free;
  inherited;
end;

procedure TIconGenerator.GenerateAll(ASource: TBitmap);
begin
  FIosIcons.GenerateAll(ASource);
  FAndroidIcons.GenerateAll(ASource);

end;



{ TIconImage }

constructor TIconImage.Create;
begin
  inherited Create;
  FBitmap := TBitmap.Create;
end;

destructor TIconImage.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TIconImage.GenerateIcon(ASource: TBitmap);
var
  b: TBitmapForceHalftone;
begin
  b := TBitmapForceHalftone.Create;
  try
    b.Assign(ASource);
    CreateIcon(FSize, FSize, b, FBitmap);
  finally
    b.Free;
  end;
end;

procedure TIconImage.SavePng(AFolder: string);
var
  APng: TPngImage;
begin
  APng := TPngImage.Create;
  try
    APng.Assign(FBitmap);
    APng.SaveToFile(IncludeTrailingPathDelimiter(AFolder)+'\'+StringReplace(FName, ' ', '_', [rfReplaceAll])+'.png');
  finally
    APng.Free;
  end;
end;

{ TIosIconList }

procedure TIosIconList.InitializeIcons;
begin
  AddIcon('iPhone Spotlight_29', 29);
  AddIcon('iPhone Spotlight_40', 40);
  AddIcon('iPhone AppIcon_57', 57);
  AddIcon('iPhone Spotlight_58', 58);
  AddIcon('iPhone AppIcon_60', 60);
  AddIcon('iPhone AppIcon_72', 72);
  AddIcon('iPad AppIcon_76', 76);
  AddIcon('iPhone Spotlight_80', 80);
  AddIcon('iPhone AppIcon_87', 87);
  AddIcon('iPhone Spotlight_100', 100);
  AddIcon('iPhone AppIcon_114', 114);
  AddIcon('iPhone AppIcon_120', 120);
  AddIcon('iPhone AppIcon_144', 144);
  AddIcon('iPad AppIcon_152', 152);
  AddIcon('iPad AppIcon_167', 167);
  AddIcon('iPad AppIcon_180', 180);
  AddIcon('AppIcon_1024', 1024);
end;

{ TAndroidIconList }

procedure TAndroidIconList.InitializeIcons;
begin
  AddIcon('launcher_36', 36);
  AddIcon('launcher_48', 48);
  AddIcon('launcher_72', 72);
  AddIcon('launcher_96', 96);
  AddIcon('launcher_144', 144);
  AddIcon('launcher_192', 192);
  AddIcon('notification_24', 24);
  AddIcon('notification_36', 36);
  AddIcon('notification_48', 48);
  AddIcon('notification_72', 72);
  AddIcon('notification_96', 96);
end;

end.

