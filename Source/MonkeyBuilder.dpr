program MonkeyBuilder;

{$R *.dres}

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {frmMain},
  untBaseForm in 'untBaseForm.pas' {frmBaseForm},
  untProjectDetails in 'untProjectDetails.pas' {frmProjectDetails},
  ksInspector in 'Components\ksInspector.pas',
  untDprojUtils in 'untDprojUtils.pas',
  untSettings in 'untSettings.pas' {frmSettings},
  untMoscoUtils in 'untMoscoUtils.pas',
  untAbout in 'untAbout.pas' {frmAbout},
  untLoading in 'untLoading.pas' {frmLoading},
  ksInspectorFileListForm in 'Components\ksInspectorFileListForm.pas' {frmKsInspectorFileList},
  untConst in 'untConst.pas',
  untIconGenerator in 'untIconGenerator.pas' {frmIconGenerator},
  untSelectFolderFiles in 'untSelectFolderFiles.pas' {frmSelectFolderFiles},
  DW.Cryptor in 'DW.Cryptor.pas',
  MonkeyBuilder_Intf in 'MonkeyBuilder_Intf.pas',
  MonkeyBuilder.Platform.Ios in 'MonkeyBuilder.Platform.Ios.pas',
  MonkeyBuilder.Project in 'MonkeyBuilder.Project.pas',
  MonkeyBuilder.Platform.Android in 'MonkeyBuilder.Platform.Android.pas',
  untMbUtils in 'untMbUtils.pas',
  untAndroidHelper in 'untAndroidHelper.pas',
  untDeployFileDetails in 'untDeployFileDetails.pas' {frmDeployFileDetails},
  Mosco.Types in 'Mosco\Mosco.Types.pas',
  Mosco.ZMQ.Client in 'Mosco\Mosco.ZMQ.Client.pas',
  Mosco.ZMQ.Consts in 'Mosco\Mosco.ZMQ.Consts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'MonkeyBuilder';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.






