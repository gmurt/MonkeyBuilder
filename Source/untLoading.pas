unit untLoading;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, untBaseForm, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Imaging.pngimage, JvComponentBase, JvComputerInfoEx, Vcl.ComCtrls,
  Vcl.Menus;

type
  TfrmLoading = class(TfrmBaseForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Timer1: TTimer;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    { Private declarations }
private
protected
  procedure CreateParams(var Params: TCreateParams); override;
  procedure DoShow; override;
  public
    { Public declarations }
  end;

  procedure ShowLoading;
  procedure HideLoading;

implementation

uses untMain;

var
  frmLoading: TfrmLoading;

{$R *.dfm}

procedure ShowLoading;
begin
  frmLoading := TfrmLoading.Create(nil);
  frmLoading.Show;
  Application.ProcessMessages;
  Sleep(1500);
end;

procedure HideLoading;
begin
  frmLoading.Free;
end;

procedure TfrmLoading.CreateParams(var Params: TCreateParams);
begin
  // Needs to be "sizeable" to show a border.
  BorderStyle := bsSizeable;
  inherited CreateParams(Params);
  with Params do begin
    // Hide the caption bar - WS_POPUP ensures the border isn't hidden too.
    Style := (Style or WS_POPUP) and not WS_CAPTION;
  end;

end;

procedure TfrmLoading.DoShow;

begin
  inherited;
  Timer1.Enabled := True;
end;

procedure TfrmLoading.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption := Application.Title;
  Label2.Caption := 'Version '+AppVersionStr;

end;

procedure TfrmLoading.Timer1Timer(Sender: TObject);
begin
  inherited;
  Timer1.Enabled := False;
  Hide;
  frmMain.Show;
end;

end.
