unit untSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untBaseForm, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, JvImageList, Vcl.Mask, JvExMask,
  JvSpin, JvExControls, JvComCtrls, JvComponentBase, JvComputerInfoEx,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.UITypes, Mosco.Types, Mosco.ZMQ.Client;

type
  TfrmSettings = class(TfrmBaseForm)
    PageControl1: TPageControl;
    JvImageList1: TJvImageList;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel4: TBevel;
    Bevel3: TBevel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    edtMoscoHost: TJvIPAddress;
    edtMoscoPort: TJvSpinEdit;
    Label4: TLabel;
    TabSheet2: TTabSheet;
    Label5: TLabel;

    Label6: TLabel;
    Bevel2: TBevel;
    Label7: TLabel;
    Label8: TLabel;
    edtAppSpecifiPassword: TEdit;
    edtITunesUser: TEdit;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure DoShow; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure LoadSettings;
    procedure SaveSettings;
    { Public declarations }
  end;

  function ShowSettings(const ATab: integer = 0): TModalResult;

implementation

uses JsonDataObjects, ShellApi, untMoscoUtils;



{$R *.dfm}

{ TfrmSettings }

function ShowSettings(const ATab: integer = 0): TModalResult;
var
  frmSettings: TfrmSettings;
begin
  frmSettings := TfrmSettings.Create(nil);
  try
    frmSettings.PageControl1.ActivePageIndex := ATab;
    Result := frmSettings.ShowModal;
  finally
    frmSettings.Free;
  end;
end;

procedure TfrmSettings.Button1Click(Sender: TObject);
begin
  inherited;
  SaveSettings;
  ModalResult := mrOk;
end;

procedure TfrmSettings.Button2Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;


procedure TfrmSettings.Button3Click(Sender: TObject);
var
  AError: string;
begin
  inherited;
  if CreateMoscoUtils(edtMoscoHost.Text, edtMoscoPort.AsInteger).Ping(AError) then
    ShowMessage('Connected successfully')
  else
    ShowMessage(AError);


end;

constructor TfrmSettings.Create(AOwner: TComponent);
begin
  inherited;
  PageControl1.ActivePageIndex := 0;
end;

procedure TfrmSettings.DoShow;
begin
  inherited;
  LoadSettings;
end;

procedure TfrmSettings.Label4Click(Sender: TObject);
var
  URL: string;
begin
  inherited;
  URL := 'https://www.monkeybuilder.io/download/';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmSettings.Label8Click(Sender: TObject);
var
  URL: string;
begin
  inherited;  URL := 'https://appleid.apple.com/';
  URL := StringReplace(URL, '"', '%22', [rfReplaceAll]);
  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmSettings.LoadSettings;
begin
  edtMoscoHost.Text := Setting['mosco', 'host'];
  edtMoscoPort.AsInteger := StrToIntDef(Setting['mosco', 'port'], 8088);
  edtITunesUser.Text := Setting['itunesconnect', 'user'];
  edtAppSpecifiPassword.Text := Setting['itunesconnect', 'password'];

end;

procedure TfrmSettings.SaveSettings;
begin
  Setting['mosco', 'host'] := edtMoscoHost.Text;
  Setting['mosco', 'port'] := IntToStr(edtMoscoPort.AsInteger);

  Setting['itunesconnect', 'user'] := edtITunesUser.Text;
  Setting['itunesconnect', 'password'] := edtAppSpecifiPassword.Text;
end;

end.
