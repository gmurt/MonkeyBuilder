object frmDeployFileDetails: TfrmDeployFileDetails
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Deploy File'
  ClientHeight = 179
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 48
    Height = 15
    Caption = 'Filename'
  end
  object Label2: TLabel
    Left = 24
    Top = 56
    Width = 68
    Height = 15
    Caption = 'Remote Path'
  end
  object Label3: TLabel
    Left = 24
    Top = 88
    Width = 76
    Height = 15
    Caption = 'Remote Name'
  end
  object Panel1: TPanel
    Left = 0
    Top = 130
    Width = 413
    Height = 49
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = -291
    ExplicitTop = 103
    ExplicitWidth = 716
    object Panel2: TPanel
      Left = 183
      Top = 0
      Width = 230
      Height = 49
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitLeft = 486
      object Button1: TButton
        Left = 58
        Top = 8
        Width = 75
        Height = 33
        Caption = '&Ok'
        ModalResult = 1
        TabOrder = 0
      end
      object Button2: TButton
        Left = 147
        Top = 8
        Width = 75
        Height = 33
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object edtFilename: TJvFilenameEdit
    Left = 120
    Top = 24
    Width = 281
    Height = 23
    TabOrder = 1
    Text = ''
  end
  object cbRemotePath: TComboBox
    Left = 120
    Top = 53
    Width = 281
    Height = 23
    TabOrder = 2
  end
  object edtRemoteName: TEdit
    Left = 120
    Top = 82
    Width = 281
    Height = 23
    TabOrder = 3
  end
end
