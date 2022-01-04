object frmKsInspectorFileList: TfrmKsInspectorFileList
  Left = 0
  Top = 0
  Caption = 'frmKsInspectorFileList'
  ClientHeight = 418
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 272
    Width = 527
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 0
    object Bevel1: TBevel
      Left = 479
      Top = 8
      Width = 8
      Height = 28
      Align = alRight
      Shape = bsSpacer
      Style = bsRaised
      ExplicitLeft = 469
      ExplicitTop = 10
    end
    object Panel2: TPanel
      Left = 8
      Top = 8
      Width = 471
      Height = 28
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Bevel3: TBevel
        Left = 0
        Top = 25
        Width = 471
        Height = 3
        Align = alBottom
        Shape = bsSpacer
        ExplicitTop = 23
      end
      object Bevel4: TBevel
        Left = 0
        Top = 0
        Width = 471
        Height = 3
        Align = alTop
        Shape = bsSpacer
        ExplicitTop = -24
      end
      object Edit1: TEdit
        Left = 0
        Top = 3
        Width = 471
        Height = 22
        Align = alClient
        TabOrder = 0
        OnChange = Edit1Change
        ExplicitHeight = 21
      end
    end
    object JvImgBtn1: TJvImgBtn
      Left = 487
      Top = 8
      Width = 32
      Height = 28
      Align = alRight
      TabOrder = 1
      OnClick = JvImgBtn1Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 367
    Width = 527
    Height = 51
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel4: TPanel
      Left = 335
      Top = 0
      Width = 192
      Height = 51
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button3: TButton
        Left = 20
        Top = 8
        Width = 75
        Height = 33
        Caption = '&Save'
        ModalResult = 1
        TabOrder = 0
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 105
        Top = 8
        Width = 75
        Height = 33
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 0
    Width = 527
    Height = 272
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 8
    TabOrder = 2
    object lbFiles: TListBox
      Left = 8
      Top = 8
      Width = 471
      Height = 256
      Style = lbOwnerDrawFixed
      Align = alClient
      ItemHeight = 21
      MultiSelect = True
      TabOrder = 0
      OnClick = lbFilesClick
    end
    object TPanel
      Left = 479
      Top = 8
      Width = 40
      Height = 256
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object Panel8: TPanel
        Left = 0
        Top = 168
        Width = 40
        Height = 88
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        object JvImgBtn2: TJvImgBtn
          Left = 6
          Top = 60
          Width = 32
          Height = 28
          TabOrder = 0
          OnClick = actMoveDownExecute
        end
        object JvImgBtn3: TJvImgBtn
          Left = 6
          Top = 26
          Width = 32
          Height = 28
          TabOrder = 1
          OnClick = actMoveUpExecute
        end
      end
    end
  end
  object Panel6: TPanel
    Left = 0
    Top = 316
    Width = 527
    Height = 51
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object Bevel2: TBevel
      Left = 0
      Top = 48
      Width = 527
      Height = 3
      Align = alBottom
      Shape = bsBottomLine
      ExplicitTop = 47
      ExplicitWidth = 456
    end
    object Panel7: TPanel
      Left = 103
      Top = 0
      Width = 424
      Height = 48
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object Button7: TButton
        Left = 36
        Top = 8
        Width = 75
        Height = 33
        Action = actReplace
        TabOrder = 0
      end
      object Button8: TButton
        Left = 121
        Top = 8
        Width = 75
        Height = 33
        Action = actAdd
        TabOrder = 1
      end
      object Button9: TButton
        Left = 206
        Top = 8
        Width = 75
        Height = 33
        Action = actDelete
        TabOrder = 2
      end
      object Button10: TButton
        Left = 290
        Top = 7
        Width = 122
        Height = 34
        Action = actDeleteInvalidPaths
        TabOrder = 3
      end
    end
  end
  object ActionList1: TActionList
    Left = 144
    Top = 112
    object actReplace: TAction
      Caption = 'Replace'
      OnExecute = actReplaceExecute
    end
    object actAdd: TAction
      Caption = 'Add'
      OnExecute = actAddExecute
    end
    object actDelete: TAction
      Caption = 'Delete'
      OnExecute = actDeleteExecute
    end
    object actDeleteInvalidPaths: TAction
      Caption = 'Delete Invalid Paths'
    end
    object actMoveUp: TAction
      Caption = 'actMoveUp'
      OnExecute = actMoveUpExecute
    end
    object actMoveDown: TAction
      OnExecute = actMoveDownExecute
    end
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileName = 'C:\Projects\MonkeyBuilderInternal\Components'
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 248
    Top = 80
  end
end
