unit Client.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, REST.Types, RESTRequest4D,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Mask, REST.JSON, Clipbrd, Client.Util.Autenticacao;

type
  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    FDMemTable1: TFDMemTable;
    DataSource1: TDataSource;
    FDMemTable1id: TIntegerField;
    FDMemTable1cliente: TStringField;
    FDMemTable1valor: TCurrencyField;
    FDMemTable1datavcto: TStringField;
    FDMemTable1pago: TIntegerField;
    FDMemTable1datapag: TStringField;
    lblCriarLancamento: TLabel;
    edtCliente: TLabeledEdit;
    edtVencimento: TLabeledEdit;
    edtValor: TLabeledEdit;
    btnInserirLancamento: TButton;
    pnOpcoes: TPanel;
    btnConfirmar: TButton;
    btnExcluir: TButton;
    btnCopyJwt: TButton;
    btnRenovarJwt: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnInserirLancamentoClick(Sender: TObject);
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCopyJwtClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRenovarJwtClick(Sender: TObject);
  private
    FAppName: string;
    FBaseUrl: string;
    FBaseUrlAuth: string;
    FClientSecret: string;
    procedure CarregarLancamentos;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  Client.Singleton.Token,
  Client.Dto.Input.Pagamento,
  DataSet.Serialize.Adapter.RESTRequest4D,
  DotEnv4Delphi;


{$R *.dfm}

procedure TfrmPrincipal.btnConfirmarClick(Sender: TObject);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FBaseUrl)
    .Resource('/pagamentos/' + FDMemTable1.FieldByName('id').AsString + '/confirmar')
    .SetUserAgent(FAppName)
    .TokenBearer(TSingletonToken.GetInstance.AccessToken)
    .Put;

  if not LResponse.StatusCode.ToString.StartsWith('2') then
    ShowMessage('Pagamento não confirmado')
  else
    CarregarLancamentos;
end;

procedure TfrmPrincipal.btnCopyJwtClick(Sender: TObject);
begin
  Clipboard.AsText := TSingletonToken.GetInstance.AccessToken;
end;

procedure TfrmPrincipal.btnExcluirClick(Sender: TObject);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FBaseUrl)
    .Resource('/pagamentos/' + FDMemTable1.FieldByName('id').AsString)
    .SetUserAgent(FAppName)
    .TokenBearer(TSingletonToken.GetInstance.AccessToken)
    .Delete;

  if not LResponse.StatusCode.ToString.StartsWith('2') then
    ShowMessage('Pagamento não excluído')
  else
    CarregarLancamentos;
end;

procedure TfrmPrincipal.btnInserirLancamentoClick(Sender: TObject);
var
  LInput: TDtoInputPagamento;
  LInputJsonString: String;
  LResponse: IResponse;
begin
  LInput := TDtoInputPagamento.Create;
  try
    LInput.Cliente := edtCliente.Text;
    LInput.Valor := StrToFloatDef(edtValor.Text,0);
    LInput.DataVcto := FormatDateTime('yyyy-MM-dd',StrToDateDef(edtVencimento.Text,0));
    LInputJsonString := TJSON.ObjectToJsonString(LInput,[joIndentCaseLower]);
  finally
    LInput.Free;
  end;


  LResponse := TRequest.New
    .BaseURL(FBaseUrl)
    .Resource('/pagamentos')
    .SetUserAgent(FAppName)
    .TokenBearer(TSingletonToken.GetInstance.AccessToken)
    .AddBody(LInputJsonString,TRESTContentType.ctAPPLICATION_JSON)
    .Post;

  if not LResponse.StatusCode.ToString.StartsWith('2') then
    ShowMessage('Registro não inserido')
  else
    CarregarLancamentos;
end;

procedure TfrmPrincipal.btnRenovarJwtClick(Sender: TObject);
var
  LResponse: IResponse;
  LRequest: IRequest;
begin
  LRequest := TRequest.New
    .BaseURL(FBaseUrlAuth)
    .Resource('realms/master/protocol/openid-connect/token')
    .AddParam('grant_type','refresh_token',pkGETorPOST)
    .AddParam('refresh_token',TSingletonToken.GetInstance.RefreshToken, pkGETorPOST);

  if not TSingletonToken.GetInstance.PublicClient then
  begin
    LRequest.AddParam('client_secret',FClientSecret, pkGETorPOST);
    LRequest.AddParam('client_id','erp-desktop', pkGETorPOST)
  end
  else
    LRequest.AddParam('client_id','erp-desktop-public', pkGETorPOST);

  LResponse := LRequest.Post;

  if not LResponse.StatusCode.ToString.StartsWith('2') then
    raise Exception.Create('Erro ao renovar token');

  TUtilAutenticacao.CarregaJwtEmMemoria(LResponse.Content,TSingletonToken.GetInstance.PublicClient);
end;

procedure TfrmPrincipal.CarregarLancamentos;
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FBaseUrl)
    .Resource('/pagamentos')
    .SetUserAgent(FAppName)
    .TokenBearer(TSingletonToken.GetInstance.AccessToken)
    .Adapters(TDataSetSerializeAdapter.New(FDMemTable1))
    .Accept('application/json')
    .Get;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FAppName := DotEnv.Env('APP_NAME');
  FBaseUrl := DotEnv.Env('BASE_URL');
  FBaseUrlAuth := DotEnv.Env('BASE_URL_AUTH');
  FClientSecret := DotEnv.Env('CLIENT_SECRET');
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  CarregarLancamentos;
end;

end.
