unit ksInspector;

interface

uses Windows, SysUtils, Controls, Classes, TypInfo, System.Generics.Collections, Forms, Vcl.ExtCtrls, Winapi.Messages, StdCtrls, VCL.Buttons, JvToolEdit,
  Graphics;

type
  TksPropertyType = (ksString, ksFile, ksFileList, ksComboItem, ksBoolean);

  TksInspector = class;
  TksInspectorItems = class;
  TksFile = type string;
  TksFileList = type string;
  TksComboItem = type string;

  TksGetComboLookupItemsEvent      = procedure(Sender: TObject; APropertyName: string; AItems: TStrings) of object;
  TksGetComboPropertyCaptionEvent  = procedure(Sender: TObject; APropertyName: string; var ACaption: string) of object;
  TksInspectorGetPropertyTypeEvent = procedure(Sender: TObject; AProperty: string; var AType: TksPropertyType) of object;

  TksInspectorItem = class
  private
    FTitle: string;
    FControl: TControl;
    FOwner: TksInspectorItems;
    FPropertyName: string;
    FInspectObject: TObject;
    FValue: Variant;
    procedure SetTitle(const Value: string);
    procedure SetPropertyName(const Value: string);
  protected
    function CreateControl: TControl; virtual;
    procedure SetFocus; virtual;
    procedure OnEnter(Sender: TObject); virtual;
    function GetValue: Variant; virtual;
    procedure SetValue(const Value: Variant); virtual;
  public
    constructor Create(AOwner: TksInspectorItems); virtual;
    destructor Destroy; override;
    procedure CustomDraw(ACanvas: TCanvas; ARect: TRect); virtual;
    property Title: string read FTitle write SetTitle;
    property PropertyName: string read FPropertyName write SetPropertyName;
    property Value: Variant read GetValue write SetValue;
    property Control: TControl read FControl;
    property InspectObject: TObject read FInspectObject write FInspectObject;
  end;

  TksInspectorEditItem = class(TksInspectorItem)
  private
    function GetEdit: TEdit;
    procedure DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    procedure OnEnter(Sender: TObject); override;
    function CreateControl: TControl; override;
    procedure DoChanged(Sender: TObject);
    procedure SetValue(const Value: Variant); override;
  public
    property Edit: TEdit read GetEdit;
  end;

  TksInspectorFileItem = class(TksInspectorItem)
  private
    function GetEdit: TJvComboEdit;
    procedure DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoButtonClick(Sender: TObject);
  protected
    procedure OnEnter(Sender: TObject); override;
    function CreateControl: TControl; override;
    procedure DoChanged(Sender: TObject);
    procedure SetValue(const Value: Variant); override;
  public
    property Edit: TJvComboEdit read GetEdit;
  end;


  TksInspectorComboItem = class(TksInspectorItem)
  private
    function GetCombo: TComboBox;
    procedure DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnExit(Sender: TObject);
  protected
    procedure SetFocus; override;
    procedure OnEnter(Sender: TObject); override;
   // procedure OnExit(Sender: TObject);
    function CreateControl: TControl; override;
    procedure DoChanged(Sender: TObject);
    procedure SetValue(const Value: Variant); override;
  public
    constructor Create(AOwner: TksInspectorItems); override;
    procedure CustomDraw(ACanvas: TCanvas; ARect: TRect); override;
    property Combo: TComboBox read GetCombo;
  end;



  TksInspectorFileListItem = class(TksInspectorItem)
  private
    function GetEdit: TJvComboEdit;
    procedure DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DoButtonClick(Sender: TObject);
  protected
    procedure OnEnter(Sender: TObject); override;
    function CreateControl: TControl; override;
    procedure DoChanged(Sender: TObject);
    procedure SetValue(const Value: Variant); override;
    procedure SetFocus; override;
  public
    property Edit: TJvComboEdit read GetEdit;
  end;



  TksInspectorBooleanItem = class(TksInspectorItem)
  private
    function GetCheckbox: TCheckBox;
  protected
    procedure OnEnter(Sender: TObject); override;
    procedure OnClick(Sender: TObject);
    function CreateControl: TControl; override;
    procedure SetValue(const Value: Variant); override;
  public
    property CheckBox: TCheckBox read GetCheckBox;
  end;



  TksInspectorItems = class(TObjectList<TksInspectorItem>)
  private
    FInspector: TksInspector;
  public
    constructor Create(AOwner: TksInspector);
    procedure AddEditProperty(AObject: TObject; AProperty: string);
    procedure AddFileProperty(AObject: TObject; AProperty: string; AFileMask: string = '');
    procedure AddFileListProperty(AObject: TObject; AProperty: string);
    procedure AddComboProperty(AObject: TObject; AProperty: string);
    procedure AddBooleanProperty(AObject: TObject; AProperty: string);
  end;

  TksInspectorContent = class(TPaintBox)
  private
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
  public
  end;


  TksInspector = class(TScrollingWinControl)
  private
    FContent: TksInspectorContent;
    FItems: TksInspectorItems;
    FItemHeight: integer;
    FItemIndex: integer;
    FInspectObject: TObject;
    FOnGetComboLookupItems: TksGetComboLookupItemsEvent;
    FOnGetPropertyCaption: TksGetComboPropertyCaptionEvent;
    FPropertyWidth: integer;
    FOnGetPropertyType: TksInspectorGetPropertyTypeEvent;
    procedure SetItemHeight(const Value: integer);
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
    procedure SetItemIndex(const Value: integer);
    procedure SetObject(const Value: TObject);
    procedure PopulateComponent;
    procedure SetPropertyWidth(const Value: integer);
  protected
    property Items: TksInspectorItems read FItems;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateItems;
    procedure ClearItems;
    property ItemHeight: integer read FItemHeight write SetItemHeight default 30;
    property ItemIndex: integer read FItemIndex write SetItemIndex default -1;
  published
    property Align;
    property InspectObject: TObject read FInspectObject write SetObject;
    property PropertyWidth: integer read FPropertyWidth write SetPropertyWidth default 140;
    property OnGetComboLookupItems: TksGetComboLookupItemsEvent read FOnGetComboLookupItems write FOnGetComboLookupItems;
    property OnGetPropertyType: TksInspectorGetPropertyTypeEvent read FOnGetPropertyType write FOnGetPropertyType;
    property OnGetPropertyCaption: TksGetComboPropertyCaptionEvent read FOnGetPropertyCaption write FOnGetPropertyCaption;
  end;

  procedure Register;

implementation

uses Dialogs, System.Threading, ksInspectorFileListForm;

procedure Register;
begin
  RegisterComponents('Monkey Builder', [TksInspector]);
end;


procedure GetPropertyList ( AnObject: TObject; List: TStrings);
var
  PropertyIndex,
  PropertyCount : Integer;
  PropList      : TPropList;
begin

  PropertyCount := GetPropList ( AnObject.ClassInfo, tkAny,
                                 @PropList) ;

  for PropertyIndex := 0 to PropertyCount -1 do
    List.Add ( string(PropList[PropertyIndex].Name) +'='+ string(PropList[PropertyIndex].PropType^.Name) );
end;

{ TksInspector }

procedure TksInspector.ClearItems;
begin
  FItems.Clear;
  Invalidate;
end;

constructor TksInspector.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TksInspectorItems.Create(Self);
  FContent := TksInspectorContent.Create(Self);
  FItemHeight := 30;
  FContent.Align := alTop;
  TabStop := True;
  FItemIndex := -1;
  Color := clWhite;
  FPropertyWidth := 140;
end;

destructor TksInspector.Destroy;
begin
  FItems.Free;
  FContent.Free;
  inherited;
end;

procedure TksInspector.PopulateComponent;
var
  AStrings: TStrings;
  ICount: integer;
  AType: TksPropertyType;
  ACaption: string;
begin
  AStrings := TStringList.Create;
  try
    FItems.Clear;
    if FInspectObject <> nil then
    begin
      GetPropertyList(FInspectObject, AStrings);

      for ICount := 0 to AStrings.Count-1 do
      begin
        AType := ksString;

        ACaption := AStrings.Names[ICount];

        if Assigned(FOnGetPropertyCaption) then
          FOnGetPropertyCaption(Self, AStrings.Names[ICount], ACaption);

        if Assigned(FOnGetPropertyType) then
          FOnGetPropertyType(Self, AStrings.Names[ICount], AType);


        if AType = ksString then FItems.AddEditProperty(FInspectObject, ACaption);
        if AType = ksFile then FItems.AddFileProperty(FInspectObject, ACaption);
        if AType = ksFileList then FItems.AddFileListProperty(FInspectObject, ACaption);
        if AType = ksComboItem then FItems.AddComboProperty(FInspectObject, ACaption);
        if AType = ksBoolean then FItems.AddBooleanProperty(FInspectObject, ACaption);
      end;
    end;
    UpdateItems;
  finally
    AStrings.Free;
  end;
end;

procedure TksInspector.SetObject(const Value: TObject);
begin
  ClearItems;
  FInspectObject := Value;
  PopulateComponent;
  UpdateItems;
end;

procedure TksInspector.SetPropertyWidth(const Value: integer);
begin
  FPropertyWidth := Value;
  UpdateItems;
end;

procedure TksInspector.SetItemHeight(const Value: integer);
begin
  FItemHeight := Value;
  UpdateItems;
end;

procedure TksInspector.SetItemIndex(const Value: integer);
begin
  if ((Value >= 0) and (Value <= FItems.Count-1)) and (Value <> FItemIndex) then
  begin
    FItemIndex := Value;
    FItems[FItemIndex].SetFocus;
    Invalidate;
  end;
end;

procedure TksInspector.UpdateItems;
var
  ICount: integer;
  ACtrl: TControl;
begin
  FContent.Parent := Self;
  FContent.Height := (FItemHeight * FItems.Count)+1;
  for ICount := 0 to FItems.Count-1 do
  begin
    ACtrl := FItems[ICount].Control;
    if ACtrl <> nil then
    begin
      ACtrl.SetBounds(FPropertyWidth+8,
                      1+((FItemHeight * ICount) + ((FItemHeight - ACtrl.Height) div 2)) - VertScrollBar.Position,
                      ClientWidth-(FPropertyWidth+8),
                      ACtrl.Height);

      ACtrl.Parent := Self;
    end;
  end;
  GetParentForm(Self).FocusControl(nil);
  VertScrollBar.Range := FContent.Height;
  VertScrollBar.Tracking := True;
  Invalidate;
end;

procedure TksInspector.WMMouseWheel(var Message: TWMMouseWheel);
var
  ADelta: integer;
begin
  if Message.WheelDelta > 0 then
    ADelta := 0-FItemHeight
  else
    ADelta := FItemHeight;
  VertScrollBar.Position := ((VertScrollBar.Position + ADelta) div FItemHeight) * FItemHeight;
end;

{ TksInspectorItem }

constructor TksInspectorItem.Create(AOwner: TksInspectorItems);
begin
  FControl := CreateControl;
  if FControl <> nil then
    TWinControl(FControl).DoubleBuffered := True;
  FOwner := AOwner;
end;

function TksInspectorItem.CreateControl: TControl;
begin
  Result := nil;
end;

procedure TksInspectorItem.CustomDraw(ACanvas: TCanvas; ARect: TRect);
begin
  //
end;

destructor TksInspectorItem.Destroy;
begin
  if FControl <> nil then
    FControl.Free;
  inherited;
end;

function TksInspectorItem.GetValue: Variant;
begin
  Result := FValue;
end;

procedure TksInspectorItem.OnEnter(Sender: TObject);
begin
  FOwner.FInspector.ItemIndex := FOwner.IndexOf(Self)

end;

procedure TksInspectorItem.SetFocus;
begin
  if FControl <> nil then
    TWinControl(FControl).SetFocus;
end;

procedure TksInspectorItem.SetPropertyName(const Value: string);
begin
  FPropertyName := Value;
end;

procedure TksInspectorItem.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TksInspectorItem.SetValue(const Value: Variant);
begin
  FValue := Value;
end;

{ TksInspectorItems }

procedure TksInspectorItems.AddEditProperty(AObject: TObject; AProperty: string);
var
  AItem: TksInspectorEditItem;
begin
  AItem := TksInspectorEditItem.Create(Self);
  AItem.InspectObject := AObject;
  AItem.Title := AProperty;
  AItem.PropertyName := AProperty;
  AItem.Value := GetPropValue(AObject, AProperty);
  Add(AItem);
end;

procedure TksInspectorItems.AddFileListProperty(AObject: TObject; AProperty: string);
var
  AItem: TksInspectorFileListItem;
begin
  AItem := TksInspectorFileListItem.Create(Self);
  AItem.InspectObject := AObject;
  AItem.Title := AProperty;
  AItem.PropertyName := AProperty;
  AItem.Value := GetPropValue(AObject, AProperty);
  Add(AItem);
end;

procedure TksInspectorItems.AddComboProperty(AObject: TObject; AProperty: string);
var
  AItem: TksInspectorComboItem;
begin
  AItem := TksInspectorComboItem.Create(Self);
  AItem.InspectObject := AObject;
  AItem.Title := AProperty;
  AItem.PropertyName := AProperty;
  AItem.Value := GetPropValue(AObject, AProperty);
  Add(AItem);
end;


procedure TksInspectorItems.AddFileProperty(AObject: TObject; AProperty: string; AFileMask: string = '');
var
  AItem: TksInspectorFileItem;
begin
  AItem := TksInspectorFileItem.Create(Self);
  AItem.InspectObject := AObject;
  AItem.Title := AProperty;
  AItem.PropertyName := AProperty;
  AItem.Value := GetPropValue(AObject, AProperty);
  Add(AItem);
end;

procedure TksInspectorItems.AddBooleanProperty(AObject: TObject; AProperty: string);
var
  AItem: TksInspectorBooleanItem;
begin
  AItem := TksInspectorBooleanItem.Create(Self);
  AItem.InspectObject := AObject;
  AItem.Title := AProperty;
  AItem.PropertyName := AProperty;
  AItem.Value := GetPropValue(AObject, AProperty);
  Add(AItem);
end;


constructor TksInspectorItems.Create(AOwner: TksInspector);
begin
  inherited Create(True);
  FInspector := AOwner;
end;

//---------------------------------------------------------------------------------------------------

{ TksInspectorEditItem }


function TksInspectorEditItem.CreateControl: TControl;
begin
  Result := TEdit.Create(nil);
  TEdit(Result).BorderStyle := bsNone;
  TEdit(Result).OnEnter := OnEnter;
  TEdit(Result).OnKeyUp := DoKeyUp;
end;


procedure TksInspectorEditItem.DoChanged(Sender: TObject);
begin
end;

procedure TksInspectorEditItem.DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  try
    SetPropValue(FInspectObject, FPropertyName, Trim(Edit.Text));
  except
    // invalid value?  ignore.
  end;
end;

function TksInspectorEditItem.GetEdit: TEdit;
begin
  Result := Control as TEdit;
end;


procedure TksInspectorEditItem.OnEnter(Sender: TObject);
begin
  inherited;
  TTask.Run(
    procedure
    begin
      //Sleep(200);
      TThread.Synchronize(nil,
      procedure
      begin
        //Edit.SelectAll;
      end
    );
    end
  );

end;

procedure TksInspectorEditItem.SetValue(const Value: Variant);
begin
  inherited;
  Edit.Text := Value;
end;






{ TksInspectorContent }

procedure TksInspectorContent.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  AIndex: integer;
  AInspector: TksInspector;
begin
  AInspector := (Owner as TksInspector);
  AIndex := Y div AInspector.ItemHeight;
  AInspector.ItemIndex := AIndex;
end;

procedure TksInspectorContent.Paint;
var
  AItems: TksInspectorItems;
  ICount: integer;
  AInspector: TksInspector;
  AItemHeight: integer;
  AFontHeight: integer;
  AItemRect: TRect;
  AFirstColRect: TRect;
begin
  AInspector := (Owner as TksInspector);
  Canvas.Brush.Color := clWhite;


  Canvas.FillRect(ClientRect);
  AItems := AInspector.Items;
  AItemHeight := AInspector.ItemHeight;

  for ICount := 0 to AItems.Count-1 do
  begin

    AItemRect := Rect(0, ICount*AItemHeight, ClientWidth, (ICount*AItemHeight)+AItemHeight);
    AFirstColRect := AItemRect;
    AFirstColRect.Right := AInspector.FPropertyWidth;

    Canvas.Brush.Color := clWhite;

    Canvas.Pen.Color := clSkyBlue;
    Canvas.Pen.Color := clWhite;
    if AInspector.ItemIndex = ICount then
    begin
      Canvas.Brush.Color := clSkyBlue;
      Canvas.Pen.Color := clSkyBlue;
      Canvas.FillRect(AFirstColRect);
      Canvas.MoveTo(0, AItemRect.Top);
      Canvas.LineTo(ClientWidth, AItemRect.Top);
      Canvas.MoveTo(0, AItemRect.Bottom);
      Canvas.LineTo(ClientWidth, AItemRect.Bottom);

    end;

    AFontHeight := Canvas.TextHeight('Ty');
    Canvas.TextOut(4, AItemRect.Top + ((AItemHeight-AFontHeight) div 2), AItems[ICount].Title);
    Canvas.Pen.Color := clSilver;
    Canvas.Pen.Style := psSolid;
    Canvas.MoveTo(AInspector.FPropertyWidth, AItemRect.Top); //((ICount+1)*AInspector.ItemHeight));
    Canvas.LineTo(AInspector.FPropertyWidth, AItemRect.Bottom);// ((ICount+1)*AInspector.ItemHeight));

    AItems[ICount].CustomDraw(Canvas, AItemRect);
  end;


end;

{ TksInspectorBooleanItem }

function TksInspectorBooleanItem.CreateControl: TControl;
begin
  Result := TCheckBox.Create(nil);
  TCheckbox(Result).OnClick := OnClick;
end;

function TksInspectorBooleanItem.GetCheckbox: TCheckBox;
begin
  Result := FControl as TCheckBox;
end;

procedure TksInspectorBooleanItem.OnClick(Sender: TObject);
begin
  OnEnter(Self);
  SetPropValue(FInspectObject, FPropertyName, CheckBox.Checked);
end;

procedure TksInspectorBooleanItem.OnEnter(Sender: TObject);
begin
  inherited;

end;

procedure TksInspectorBooleanItem.SetValue(const Value: Variant);
begin
  inherited;
  CheckBox.Checked := LowerCase(Value) = 'true';
end;


{ TksInspectorFileListItem }

function TksInspectorFileListItem.CreateControl: TControl;
begin
  Result := TJvComboEdit.Create(nil);

  TJvComboEdit(Result).OnChange := DoChanged;

  //TJvComboEdit(Result).BorderStyle := bsNone;
  TJvComboEdit(Result).OnEnter := OnEnter;
  TJvComboEdit(Result).OnKeyUp := DoKeyUp;
  TJvComboEdit(Result).ImageKind := ikEllipsis;
  TJvComboEdit(Result).Button.Width := 24;
  TJvComboEdit(Result).OnButtonClick := DoButtonClick;
end;

procedure TksInspectorFileListItem.DoButtonClick(Sender: TObject);
var
  frmFileList: TfrmKsInspectorFileList;
begin
  frmFileList := TfrmKsInspectorFileList.Create(nil);
  try
    frmFileList.Title := Title;
    frmFileList.FileList := Edit.Text;
    if frmFileList.ShowModal = mrOk then
      Edit.Text := frmFileList.FileList;
  finally
    frmFileList.Free;
  end;
end;

procedure TksInspectorFileListItem.DoChanged(Sender: TObject);
begin
  //Edit.Text := Value;
  if FPropertyName <> '' then
    SetPropValue(FInspectObject, FPropertyName, Edit.Text);
end;

procedure TksInspectorFileListItem.DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SetPropValue(FInspectObject, FPropertyName, Edit.Text);
end;

function TksInspectorFileListItem.GetEdit: TJvComboEdit;
begin
  Result := Control as TJvComboEdit;
end;

procedure TksInspectorFileListItem.OnEnter(Sender: TObject);
begin
  inherited;
  TTask.Run(
    procedure
    begin
      //Sleep(200);
      TThread.Synchronize(nil,
      procedure
      begin
        //Edit.SelectAll;

      end
    );
    end
  );

end;

procedure TksInspectorFileListItem.SetFocus;
begin
  inherited;
  Edit.SelStart := 0;
end;

procedure TksInspectorFileListItem.SetValue(const Value: Variant);
begin
  inherited;
  Edit.Text := Value;
end;

{ TksInspectorFileItem }

function TksInspectorFileItem.CreateControl: TControl;
begin
  Result := TJvComboEdit.Create(nil);
  TJvComboEdit(Result).OnChange := DoChanged;
  TJvComboEdit(Result).ImageKind := ikEllipsis;
  TJvComboEdit(Result).OnEnter := OnEnter;
  TJvComboEdit(Result).OnKeyUp := DoKeyUp;
  TJvComboEdit(Result).Button.Width := 24;
  TJvComboEdit(Result).OnButtonClick := DoButtonClick;
end;

procedure TksInspectorFileItem.DoButtonClick(Sender: TObject);
var
  ADialog: TOpenDialog;
  ADir: string;
begin
  ADialog := TOpenDialog.Create(nil);
  try
    ADialog.Title := 'Select File';
    ADir := Trim(ExtractFilePath(Edit.Text));
    if DirectoryExists(ADir) then
      ADialog.InitialDir := ADir;
     //  ADir := ExtractFilePath(ParamStr(0));

    ADialog.FileName := Edit.Text;

    if ADialog.Execute then
      Edit.Text := ADialog.FileName;
  finally
    ADialog.Free;
  end;
end;

procedure TksInspectorFileItem.DoChanged(Sender: TObject);
begin
  //Edit.Text := Value;
  SetPropValue(FInspectObject, FPropertyName, Edit.Text);
end;

procedure TksInspectorFileItem.DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SetPropValue(FInspectObject, FPropertyName, Edit.Text);
end;

function TksInspectorFileItem.GetEdit: TJvComboEdit;
begin
  Result := Control as TJvComboEdit;
end;

procedure TksInspectorFileItem.OnEnter(Sender: TObject);
begin
  inherited;
  TTask.Run(
    procedure
    begin
      //Sleep(200);
      TThread.Synchronize(nil,
      procedure
      begin
        //Edit.SelectAll;
        //Edit.SelStart := 1;
      end
    );
    end
  );

end;

procedure TksInspectorFileItem.SetValue(const Value: Variant);
begin
  inherited;
  Edit.Text := Value;
end;

{ TksInspectorComboItem }

constructor TksInspectorComboItem.Create(AOwner: TksInspectorItems);
begin
  inherited;
end;

function TksInspectorComboItem.CreateControl: TControl;
begin
  Result := TComboBox.Create(nil);
  TComboBox(Result).OnChange := DoChanged;
  TComboBox(Result).OnEnter := OnEnter;
  TComboBox(Result).OnExit := OnExit;
  TComboBox(Result).OnKeyUp := DoKeyUp;

  TComboBox(Result).Style := TComboBoxStyle.csOwnerDrawFixed;
  TComboBox(Result).Visible := False;
  TComboBox(Result).Ctl3D := False;

end;

procedure TksInspectorComboItem.CustomDraw(ACanvas: TCanvas; ARect: TRect);
var
  r: TRect;
  s: string;
begin
  inherited;
  r := Combo.BoundsRect;
  OffsetRect(r, 3, 3);
  s := StringReplace(Combo.Text, '&', '&&', [rfReplaceAll]);
  ACanvas.TextRect(r, s, []);
end;

procedure TksInspectorComboItem.DoChanged(Sender: TObject);
begin
  SetPropValue(FInspectObject, FPropertyName, Combo.Text);
  Value := Combo.Text;
end;

procedure TksInspectorComboItem.DoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  SetPropValue(FInspectObject, FPropertyName, Combo.Text);

end;

function TksInspectorComboItem.GetCombo: TComboBox;
begin
  Result := Control as TComboBox;
end;

procedure TksInspectorComboItem.OnEnter(Sender: TObject);
begin
  inherited;

end;

procedure TksInspectorComboItem.OnExit(Sender: TObject);
begin
  inherited;
  Combo.Hide;
end;

procedure TksInspectorComboItem.SetFocus;
begin
  Combo.Items.Clear;
  if Assigned(FOwner.FInspector.OnGetComboLookupItems) then
    FOwner.FInspector.OnGetComboLookupItems(FOwner.FInspector, FPropertyName, Combo.Items);
  Combo.Show;
  Combo.ItemIndex := Combo.Items.IndexOf(Value);
  inherited;
end;

procedure TksInspectorComboItem.SetValue(const Value: Variant);
begin
  inherited;
  Combo.Text := Value;
end;

end.
