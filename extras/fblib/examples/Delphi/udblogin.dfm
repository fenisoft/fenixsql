object frmDBlogin: TfrmDBlogin
  Left = 335
  Top = 264
  BorderStyle = bsDialog
  Caption = 'frmDBlogin'
  ClientHeight = 119
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  DesignSize = (
    323
    119)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 33
    Top = 56
    Width = 41
    Height = 13
    Anchors = []
    Caption = 'Pasword'
  end
  object Label1: TLabel
    Left = 33
    Top = 8
    Width = 22
    Height = 13
    Anchors = []
    Caption = 'User'
  end
  object Panel1: TPanel
    Left = 0
    Top = 80
    Width = 323
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 323
      Height = 4
      Align = alTop
      Shape = bsTopLine
    end
    object BitBtn1: TBitBtn
      Left = 181
      Top = 10
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 100
      Top = 10
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object edUser: TEdit
    Left = 120
    Top = 8
    Width = 182
    Height = 21
    Anchors = []
    TabOrder = 1
  end
  object edPassword: TEdit
    Left = 120
    Top = 53
    Width = 182
    Height = 21
    Anchors = []
    PasswordChar = '*'
    TabOrder = 2
  end
end
