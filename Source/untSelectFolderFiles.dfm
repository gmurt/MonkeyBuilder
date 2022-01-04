inherited frmSelectFolderFiles: TfrmSelectFolderFiles
  BorderStyle = bsDialog
  Caption = 'Add Folder'
  ClientHeight = 131
  ClientWidth = 477
  Position = poScreenCenter
  ExplicitWidth = 493
  ExplicitHeight = 170
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 27
    Width = 30
    Height = 13
    Caption = 'Folder'
  end
  object JvDirectoryEdit1: TJvDirectoryEdit
    Left = 64
    Top = 24
    Width = 405
    Height = 21
    TabOrder = 0
    Text = ''
  end
  object Panel1: TPanel
    Left = 0
    Top = 82
    Width = 477
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel2: TPanel
      Left = 247
      Top = 0
      Width = 230
      Height = 49
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button1: TButton
        Left = 58
        Top = 8
        Width = 75
        Height = 33
        Caption = '&Ok'
        TabOrder = 0
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 147
        Top = 8
        Width = 75
        Height = 33
        Caption = 'Cancel'
        TabOrder = 1
        OnClick = Button2Click
      end
    end
  end
  object CheckBox1: TCheckBox
    Left = 64
    Top = 59
    Width = 121
    Height = 17
    Caption = 'Include Sub-Folders'
    TabOrder = 2
  end
end
