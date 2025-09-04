object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Client'
  ClientHeight = 570
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblCriarLancamento: TLabel
      Left = 16
      Top = 13
      Width = 140
      Height = 25
      Caption = 'Criar Lan'#231'amento'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Segoe UI Light'
      Font.Style = []
      ParentFont = False
    end
    object edtCliente: TLabeledEdit
      Left = 63
      Top = 52
      Width = 138
      Height = 23
      EditLabel.Width = 37
      EditLabel.Height = 23
      EditLabel.Caption = 'Cliente'
      LabelPosition = lpLeft
      LabelSpacing = 10
      TabOrder = 0
      Text = 'gabriel'
    end
    object edtVencimento: TLabeledEdit
      Left = 288
      Top = 52
      Width = 96
      Height = 23
      EditLabel.Width = 63
      EditLabel.Height = 23
      EditLabel.Caption = 'Vencimento'
      LabelPosition = lpLeft
      LabelSpacing = 10
      TabOrder = 1
      Text = '02/09/2025'
    end
    object edtValor: TLabeledEdit
      Left = 439
      Top = 52
      Width = 136
      Height = 23
      EditLabel.Width = 26
      EditLabel.Height = 23
      EditLabel.Caption = 'Valor'
      LabelPosition = lpLeft
      LabelSpacing = 10
      TabOrder = 2
      Text = '1000'
    end
    object btnInserirLancamento: TButton
      Left = 589
      Top = 51
      Width = 124
      Height = 25
      Caption = 'Inserir'
      TabOrder = 3
      OnClick = btnInserirLancamentoClick
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 89
    Width = 640
    Height = 481
    Align = alClient
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'id'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'cliente'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'valor'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'datavcto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'pago'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'datapag'
        Visible = True
      end>
  end
  object pnOpcoes: TPanel
    Left = 640
    Top = 89
    Width = 160
    Height = 481
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    object btnConfirmar: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 154
      Height = 38
      Align = alTop
      Caption = 'Confirmar'
      TabOrder = 0
      OnClick = btnConfirmarClick
      ExplicitLeft = 6
    end
    object btnExcluir: TButton
      AlignWithMargins = True
      Left = 3
      Top = 47
      Width = 154
      Height = 38
      Align = alTop
      Caption = 'Excluir'
      TabOrder = 1
      OnClick = btnExcluirClick
    end
    object btnCopyJwt: TButton
      AlignWithMargins = True
      Left = 3
      Top = 453
      Width = 154
      Height = 25
      Align = alBottom
      Caption = 'Copiar JWT'
      TabOrder = 2
      OnClick = btnCopyJwtClick
    end
    object btnRenovarJwt: TButton
      AlignWithMargins = True
      Left = 3
      Top = 422
      Width = 154
      Height = 25
      Align = alBottom
      Caption = 'Renovar'
      TabOrder = 3
      OnClick = btnRenovarJwtClick
    end
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 392
    Top = 288
    object FDMemTable1id: TIntegerField
      FieldName = 'id'
    end
    object FDMemTable1cliente: TStringField
      FieldName = 'cliente'
    end
    object FDMemTable1valor: TCurrencyField
      FieldName = 'valor'
    end
    object FDMemTable1datavcto: TStringField
      FieldName = 'datavcto'
    end
    object FDMemTable1pago: TIntegerField
      FieldName = 'pago'
    end
    object FDMemTable1datapag: TStringField
      FieldName = 'datapag'
    end
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = FDMemTable1
    Left = 392
    Top = 344
  end
end
