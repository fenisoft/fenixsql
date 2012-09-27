object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'FBLib ClientDataset Demo'
  ClientHeight = 475
  ClientWidth = 597
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 203
    Width = 597
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 169
    ExplicitWidth = 264
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 597
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      Left = 439
      Top = 13
      Width = 23
      Height = 22
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FF078DBE
        078DBE078DBE078DBE078DBE078DBE078DBE078DBE078DBE078DBE078DBE078D
        BE078DBEFF00FFFF00FF078DBE25A1D172C7E785D7FA66CDF965CDF965CDF965
        CDF965CDF865CDF965CDF866CEF939ADD8078DBEFF00FFFF00FF078DBE4CBCE7
        39A8D1A0E2FB6FD4FA6FD4F96ED4FA6FD4F96FD4FA6FD4FA6FD4FA6ED4F93EB1
        D984D7EB078DBEFF00FF078DBE72D6FA078DBEAEEAFC79DCFB79DCFB79DCFB79
        DCFB79DCFB7ADCFB79DCFA79DCFA44B5D9AEF1F9078DBEFF00FF078DBE79DDFB
        1899C79ADFF392E7FB84E4FB83E4FC83E4FC84E4FC83E4FC83E4FB84E5FC48B9
        DAB3F4F9078DBEFF00FF078DBE82E3FC43B7DC65C3E0ACF0FD8DEBFC8DEBFC8D
        EBFD8DEBFD8DEBFC8DEBFD0C85184CBBDAB6F7F96DCAE0078DBE078DBE8AEAFC
        77DCF3229CC6FDFFFFC8F7FEC9F7FEC9F7FEC9F7FEC8F7FE0C85183CBC5D0C85
        18DEF9FBD6F6F9078DBE078DBE93F0FE93F0FD1697C5078DBE078DBE078DBE07
        8DBE078DBE0C851852D97F62ED9741C4650C8518078DBE078DBE078DBE9BF5FE
        9AF6FE9AF6FE9BF5FD9BF6FE9AF6FE9BF5FE0C851846CE6C59E48858E18861EB
        9440C1650C8518FF00FF078DBEFEFEFEA0FBFFA0FBFEA0FBFEA1FAFEA1FBFE0C
        85180C85180C85180C851856E18447CD6E0C85180C85180C8518FF00FF078DBE
        FEFEFEA5FEFFA5FEFFA5FEFF078CB643B7DC43B7DC43B7DC0C85184EDD7936BA
        540C8518FF00FFFF00FFFF00FFFF00FF078DBE078DBE078DBE078DBEFF00FFFF
        00FFFF00FFFF00FF0C851840D0650C8518FF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0C85182AB7432DBA490C85
        18FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FF0C851821B5380C8518FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF0C85180C85180C85180C8518FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0C85180C85180C
        85180C8518FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      OnClick = SpeedButton1Click
    end
    object edDatabase: TEdit
      Left = 8
      Top = 14
      Width = 425
      Height = 21
      TabOrder = 0
      Text = 'c:\programmi\firebird'
    end
    object btnConnect: TBitBtn
      Left = 470
      Top = 10
      Width = 107
      Height = 25
      Caption = 'Connect'
      TabOrder = 1
      OnClick = btnConnectClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 206
    Width = 597
    Height = 269
    Align = alClient
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object mSql: TMemo
    Left = 0
    Top = 81
    Width = 597
    Height = 122
    Align = alTop
    Lines.Strings = (
      'select * from sales')
    TabOrder = 2
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 597
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object btnExecute: TBitBtn
      Left = 8
      Top = 9
      Width = 161
      Height = 25
      Caption = 'Execute query'
      TabOrder = 0
      OnClick = btnExecuteClick
    end
  end
  object DataSetProvider1: TDataSetProvider
    Options = [poFetchBlobsOnDemand, poUseQuoteChar]
    Left = 448
    Top = 224
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    FetchOnDemand = False
    Params = <>
    ProviderName = 'DataSetProvider1'
    ReadOnly = True
    Left = 480
    Top = 224
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 512
    Top = 224
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'fdb'
    Filter = 
      'Firebird Database (*.fdb)|*.fdb|Interbase Database (*.gdb)|*.gdb' +
      '|Any File (*.*)|*.*'
    Left = 432
    Top = 40
  end
end
