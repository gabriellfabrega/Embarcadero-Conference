object frmLogin: TfrmLogin
  Left = 0
  Top = 0
  Caption = 'Login'
  ClientHeight = 345
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object edtUsuario: TLabeledEdit
    Left = 48
    Top = 88
    Width = 281
    Height = 23
    EditLabel.Width = 57
    EditLabel.Height = 15
    EditLabel.Caption = 'edtUsuario'
    TabOrder = 0
    Text = 'gabriel.supervisor'
  end
  object edtSenha: TLabeledEdit
    Left = 48
    Top = 136
    Width = 281
    Height = 23
    EditLabel.Width = 67
    EditLabel.Height = 15
    EditLabel.Caption = 'LabeledEdit1'
    TabOrder = 1
    Text = '123'
  end
  object btnLoginCredenciais: TButton
    Left = 48
    Top = 176
    Width = 281
    Height = 33
    Caption = 'Login com Credenciais'
    TabOrder = 2
    OnClick = btnLoginCredenciaisClick
  end
  object btnLoginRedirect: TButton
    Left = 48
    Top = 215
    Width = 281
    Height = 34
    Caption = 'Login SSO'
    TabOrder = 3
    OnClick = btnLoginRedirectClick
  end
end
