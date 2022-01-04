unit ksInspectorFileListForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ksInspector, Vcl.ExtCtrls, System.ImageList, Vcl.ImgList,
  System.Actions, Vcl.ActnList, JvImageList, JvExStdCtrls, JvButton, JvCtrls;

type
  TfrmKsInspectorFileList = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Button3: TButton;
    Button4: TButton;
    Panel5: TPanel;
    lbFiles: TListBox;
    Panel6: TPanel;
    Bevel2: TBevel;
    Panel7: TPanel;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Bevel1: TBevel;
    Panel2: TPanel;
    Edit1: TEdit;
    Bevel3: TBevel;
    Bevel4: TBevel;
    JvImgBtn1: TJvImgBtn;
    ActionList1: TActionList;
    actReplace: TAction;
    actAdd: TAction;
    actDelete: TAction;
    actDeleteInvalidPaths: TAction;
    Panel8: TPanel;
    JvImgBtn2: TJvImgBtn;
    JvImgBtn3: TJvImgBtn;
    actMoveUp: TAction;
    actMoveDown: TAction;
    FileOpenDialog1: TFileOpenDialog;
    procedure lbFilesClick(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure actReplaceExecute(Sender: TObject);
    procedure actAddExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actMoveUpExecute(Sender: TObject);
    procedure actMoveDownExecute(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure JvImgBtn1Click(Sender: TObject);
  private
    FFileList: string;
    FTitle: string;
    procedure UpdateActionStates;
    { Private declarations }
  protected
    procedure DoShow; override;
  public
    property FileList: string read FFileList write FFileList;
    property Title: string read FTitle write FTitle;
    { Public declarations }
  end;



implementation

uses JclStrings;

{$R *.dfm}

{ TfrmKsInspectorFileList }

procedure TfrmKsInspectorFileList.actAddExecute(Sender: TObject);
begin
  lbFiles.Items.Add(Edit1.Text);
  Edit1.Text := '';
end;

procedure TfrmKsInspectorFileList.actDeleteExecute(Sender: TObject);
begin
  lbFiles.DeleteSelected;
end;

procedure TfrmKsInspectorFileList.actMoveDownExecute(Sender: TObject);
var
  i: Integer;
begin
  i := lbFiles.ItemIndex + 1;
  if i < lbFiles.Items.Count then
    lbFiles.Items.Exchange(i, i - 1);
  lbFiles.SetFocus;
end;

procedure TfrmKsInspectorFileList.actMoveUpExecute(Sender: TObject);
var
  i: integer;
begin
  i := lbFiles.ItemIndex;
  if i > 0 then
    lbFiles.Items.Exchange(i, i - 1);
  lbFiles.SetFocus;
end;

procedure TfrmKsInspectorFileList.actReplaceExecute(Sender: TObject);
begin
  lbFiles.Items[lbFiles.ItemIndex] := Trim(Edit1.Text);
end;

procedure TfrmKsInspectorFileList.Button3Click(Sender: TObject);
var
  AStr: string;
begin
  FFileList := '';
  for AStr in lbFiles.Items do
    FFileList := FFileList + AStr+';';
  FFileList := StrEnsureNoSuffix(';', FFileList);
end;

procedure TfrmKsInspectorFileList.Button9Click(Sender: TObject);
begin
  lbFiles.DeleteSelected;
end;

procedure TfrmKsInspectorFileList.DoShow;
var
  AStrings: TStrings;
  ICount: integer;
begin
  inherited;
  Caption := FTitle;
  AStrings := TStringList.Create;
  try
    AStrings.Text := StringReplace(FFileList, ';', #13, [rfReplaceAll]);
    for ICount := 0 to AStrings.Count-1 do
    begin
      AStrings[ICount] := StrEnsureNoPrefix('"', AStrings[ICount]);
      AStrings[ICount] := StrEnsureNoSuffix('"', AStrings[ICount]);
    end;
    lbFiles.Items.Assign(AStrings);
  finally
    AStrings.Free;
  end;
end;

procedure TfrmKsInspectorFileList.Edit1Change(Sender: TObject);
begin
  UpdateActionStates;
end;

procedure TfrmKsInspectorFileList.JvImgBtn1Click(Sender: TObject);
begin
  if FileOpenDialog1.Execute then
    Edit1.Text := FileOpenDialog1.Filename;
end;

procedure TfrmKsInspectorFileList.lbFilesClick(Sender: TObject);
begin
  Edit1.Text := '';

  if lbFiles.ItemIndex > -1 then
    Edit1.Text := lbFiles.Items[lbFiles.ItemIndex];

  UpdateActionStates;
end;

procedure TfrmKsInspectorFileList.UpdateActionStates;
begin
  actAdd.Enabled := (lbFiles.Items.IndexOf(Trim(Edit1.Text)) = -1) and (Trim(Edit1.Text) <> '');
  actReplace.Enabled := (Trim(Edit1.Text) <> '') and (lbFiles.SelCount = 1);
  actDelete.Enabled := lbFiles.SelCount > 0;
  actMoveUp.Enabled := lbFiles.SelCount > 0;
  actMoveDown.Enabled := lbFiles.SelCount > 0;
end;

end.
