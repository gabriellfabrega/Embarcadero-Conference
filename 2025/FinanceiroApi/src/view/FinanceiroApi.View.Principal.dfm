object frmFinanceiroApi: TfrmFinanceiroApi
  Left = 0
  Top = 0
  Caption = 'frmFinanceiroApi'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Memo1: TMemo
    Left = 24
    Top = 24
    Width = 545
    Height = 377
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=C:\Econ25\resource-servers\FinanceiroApi\Financeiro.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 104
    Top = 152
  end
end
