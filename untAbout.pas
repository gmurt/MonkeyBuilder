unit untAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untBaseForm, JvComponentBase, JvComputerInfoEx, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  TfrmAbout = class(TfrmBaseForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure ShowAboutForm;

implementation

{$R *.dfm}

procedure ShowAboutForm;
var
  frmAbout: TfrmAbout;
begin
  frmAbout := TfrmAbout.Create(nil);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmAbout.Button1Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrClose;
end;

procedure TfrmAbout.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  inherited;
  ModalResult := mrClose;

end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption := Application.Title;
  Label2.Caption := 'Version '+AppVersionStr;

end;

end.
