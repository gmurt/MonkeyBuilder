unit untSelectFolderFiles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untBaseForm, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Mask, JvExMask, JvToolEdit, JvComponentBase, JvComputerInfoEx;

type
  TfrmSelectFolderFiles = class(TfrmBaseForm)
    JvDirectoryEdit1: TJvDirectoryEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FFiles: TStrings;
    { Private declarations }
  public
    { Public declarations }
  end;

  function AddFilesFromFolder(AFiles: TStrings): TModalResult;

implementation

uses JclFileUtils;

{$R *.dfm}


function AddFilesFromFolder(AFiles: TStrings): TModalResult;
var
  frmSelectFolderFiles: TfrmSelectFolderFiles;
begin
  frmSelectFolderFiles := TfrmSelectFolderFiles.Create(nil);
  try
    frmSelectFolderFiles.FFiles := AFiles;
    Result := frmSelectFolderFiles.ShowModal;

  finally
    frmSelectFolderFiles.Free;
  end;
end;

procedure TfrmSelectFolderFiles.Button1Click(Sender: TObject);
var
  AOptions: TFileListOptions;
  ICount: integer;
begin
  inherited;

  AOptions := [flFullNames];
  if CheckBox1.Checked then
    AOptions := AOptions + [flRecursive];

  FFiles.BeginUpdate;
  AdvBuildFileList(IncludeTrailingPathDelimiter(JvDirectoryEdit1.Directory)+'*.*', faNormal, FFiles, amAny, AOptions);
  for ICount := FFiles.Count-1 downto 0 do
    if FileExists(FFiles[ICount]) = False then
      FFiles.Delete(ICount);
  FFiles.EndUpdate;

    ModalResult := mrOk;
end;

procedure TfrmSelectFolderFiles.Button2Click(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

end.
