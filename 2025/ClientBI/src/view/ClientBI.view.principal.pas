unit ClientBI.view.principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects;

type
  TfrmPrincipal = class(TForm)
    Layout1: TLayout;
    Rectangle1: TRectangle;
    Image1: TImage;
    lblTitulo: TLabel;
    ScrollBox1: TScrollBox;
    Layout2: TLayout;
    imgRefresh: TImage;
    spbRefresh: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure spbRefreshClick(Sender: TObject);
  private
    procedure LimpaLancamentos;
    procedure CarregarLancamentos;
    procedure EventoConfirmar(Sender: TObject);
    procedure EventoCancelar(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  System.JSON,
  RESTRequest4D,
  ClientBI.singleton.Token,
  ClientBI.view.card;

{$R *.fmx}

{ TfrmPrincipal }

const
  //API = 'http://192.168.0.110:9998';
  API = 'https://api.fabregaserver.cloud';
  APP_NAME = 'Conference BI Mobile';

procedure TfrmPrincipal.CarregarLancamentos;
var
  LResponse2: IResponse;
  LResponseJsonArray: TJSONArray;
begin
  LResponse2 := TRequest.New
    .BaseURL(API)
      .Resource('/pagamentos')
      .SetUserAgent(APP_NAME)
      .TokenBearer(TSingletonToken.GetInstance.AccessToken)
      .Accept('application/json')
      .Get;

  if not LResponse2.StatusCode.ToString.StartsWith('2') then
    exit;

  LResponseJsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LResponse2.Content),0) as TJSONArray;

  LimpaLancamentos;

  for var LValue in LResponseJsonArray do
  begin
    var LCard : TfrmCard := TfrmCard.Create(Self);
    LCard.Parent := ScrollBox1;
    LCard.Align := TAlignLayout.Top;
    LCard.Name := 'frmCard' + LValue.GetValue<string>('id');
    LCard.lblCliente.Text := LValue.GetValue<string>('cliente');
    LCard.lblVenc.Text := LValue.GetValue<string>('datavcto');
    LCard.lblValor.Text := FormatFloat('R$ #,##0.00', LValue.GetValue<Double>('valor',0));
    LCard.Id := LValue.GetValue<Integer>('id');
    LCard.Pago := LValue.GetValue<Integer>('pago');
    LCard.spbConfirmar.OnClick := EventoConfirmar;
    LCard.spbCancelar.OnClick := EventoCancelar;
  end;
end;

procedure TfrmPrincipal.EventoCancelar(Sender: TObject);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(API)
    .Resource('/pagamentos/' +  TfrmCard(TSpeedButton(Sender).Owner).Id.ToString)
    .SetUserAgent(APP_NAME)
    .TokenBearer(TSingletonToken.GetInstance.AccessToken)
    .Delete;

  if not LResponse.StatusCode.ToString.StartsWith('2') then
    ShowMessage('Pagamento não excluído')
  else
    CarregarLancamentos;
end;

procedure TfrmPrincipal.EventoConfirmar(Sender: TObject);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(API)
    .Resource('/pagamentos/' + TfrmCard(TSpeedButton(Sender).Owner).Id.ToString + '/confirmar')
    .SetUserAgent(APP_NAME)
    .TokenBearer(TSingletonToken.GetInstance.AccessToken)
    .Put;

  if not LResponse.StatusCode.ToString.StartsWith('2') then
    ShowMessage('Pagamento não confirmado')
  else
    CarregarLancamentos;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  CarregarLancamentos;
end;

procedure TfrmPrincipal.LimpaLancamentos;
var
  LCard: TFrmCard;
begin
  for var i := Self.ComponentCount-1 downto 0 do
  begin
    if Self.Components[i] is TfrmCard then
    begin
      LCard := TfrmCard(Self.Components[i]);
      LCard.Free;
    end;
  end;
end;

procedure TfrmPrincipal.spbRefreshClick(Sender: TObject);
begin
  CarregarLancamentos;
end;

end.
