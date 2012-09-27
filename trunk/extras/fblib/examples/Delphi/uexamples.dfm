object frmFblEx: TfrmFblEx
  Left = 297
  Top = 195
  Width = 649
  Height = 533
  Caption = 'frmFblEx'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 456
    Width = 633
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object BitBtn1: TBitBtn
      Left = 8
      Top = 10
      Width = 75
      Height = 25
      Action = aCommit
      Caption = 'Commit'
      TabOrder = 0
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object BitBtn2: TBitBtn
      Left = 96
      Top = 10
      Width = 75
      Height = 25
      Action = aRollback
      Caption = 'Rollback'
      TabOrder = 1
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        333333333333333333333333000033338833333333333333333F333333333333
        0000333911833333983333333388F333333F3333000033391118333911833333
        38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
        911118111118333338F3338F833338F3000033333911111111833333338F3338
        3333F8330000333333911111183333333338F333333F83330000333333311111
        8333333333338F3333383333000033333339111183333333333338F333833333
        00003333339111118333333333333833338F3333000033333911181118333333
        33338333338F333300003333911183911183333333383338F338F33300003333
        9118333911183333338F33838F338F33000033333913333391113333338FF833
        38F338F300003333333333333919333333388333338FFF830000333333333333
        3333333333333333333888330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 633
    Height = 415
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    object mMsg: TMemo
      Left = 0
      Top = 0
      Width = 633
      Height = 415
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object ActionList1: TActionList
    Left = 464
    Top = 248
    object aConnect: TAction
      Caption = 'Connect'
      OnExecute = aConnectExecute
    end
    object aCreateDb: TAction
      Caption = 'Create Database'
      OnExecute = aCreateDbExecute
    end
    object aInsertRecord: TAction
      Caption = 'Insert record'
      Enabled = False
      OnExecute = aInsertRecordExecute
    end
    object aCommit: TAction
      Caption = 'Commit'
      Enabled = False
      OnExecute = aCommitExecute
    end
    object aRollback: TAction
      Caption = 'Rollback'
      Enabled = False
      OnExecute = aRollbackExecute
    end
    object aDisconnect: TAction
      Caption = 'Disconnect'
      Enabled = False
      OnExecute = aDisconnectExecute
    end
    object aMetadata: TAction
      Caption = 'Exctract &Metadata'
      Enabled = False
      OnExecute = aMetadataExecute
    end
    object aBackup: TAction
      Caption = 'Backup'
      OnExecute = aBackupExecute
    end
    object aDelete: TAction
      Caption = 'Delete'
      Enabled = False
      OnExecute = aDeleteExecute
    end
    object aSelect: TAction
      Caption = 'Select'
      Enabled = False
      OnExecute = aSelectExecute
    end
  end
  object MainMenu1: TMainMenu
    Left = 424
    Top = 248
    object Database1: TMenuItem
      Caption = '&Database'
      object CreateDatabase1: TMenuItem
        Action = aConnect
      end
      object N1: TMenuItem
        Action = aDisconnect
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object CreateDatabase2: TMenuItem
        Action = aCreateDb
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = '&Exit'
        OnClick = Exit1Click
      end
    end
    object Sql1: TMenuItem
      Caption = '&Sql'
      object Insertrecord1: TMenuItem
        Action = aInsertRecord
      end
      object Delete1: TMenuItem
        Action = aDelete
      end
      object aSelect1: TMenuItem
        Action = aSelect
      end
    end
    object Action1: TMenuItem
      Caption = '&Action'
      object exctractMetadata1: TMenuItem
        Action = aMetadata
      end
      object Backup1: TMenuItem
        Action = aBackup
      end
    end
  end
end
