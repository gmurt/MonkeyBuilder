unit untDeployFileDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, JvExMask, JvToolEdit, Vcl.ExtCtrls,
  MonkeyBuilder_Intf;

type
  TfrmDeployFileDetails = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    edtFilename: TJvFilenameEdit;
    cbRemotePath: TComboBox;
    edtRemoteName: TEdit;
  private
    FDeployFile: IMbDeploymentFile;
    procedure PopulateDetails;
    procedure SaveDetails;
    { Private declarations }
  protected
    procedure DoShow; override;
  public
    property DeployFile: IMbDeploymentFile read FDeployFile write FDeployFile;
    { Public declarations }
  end;


  function EditDeployFile(AFile: IMbDeploymentFile): TModalResult;

implementation

{$R *.dfm}

function EditDeployFile(AFile: IMbDeploymentFile): TModalResult;
var
  frmFile: TfrmDeployFileDetails;
begin
  frmFile := TfrmDeployFileDetails.Create(nil);
  try
    frmFile.DeployFile := AFile;
    Result := frmFile.ShowModal;
    if Result = mrOk then
      frmFile.SaveDetails;
  finally
    frmFile.Free;
  end;
end;

{ TfrmDeployFileDetails }

procedure TfrmDeployFileDetails.DoShow;
begin
  inherited;
  PopulateDetails;
end;

procedure TfrmDeployFileDetails.PopulateDetails;
begin
  edtFilename.Filename := FDeployFile.Filename;
  cbRemotePath.Text := FDeployFile.RemotePath;
  edtRemoteName.Text := FDeployFile.RemoteName;
end;

procedure TfrmDeployFileDetails.SaveDetails;
begin
  FDeployFile.Filename := edtFileNAme.Filename;
  FDeployFile.RemotePath := cbRemotePath.Text;
  FDeployFile.RemoteName := edtRemoteName.Text;
end;

end.

