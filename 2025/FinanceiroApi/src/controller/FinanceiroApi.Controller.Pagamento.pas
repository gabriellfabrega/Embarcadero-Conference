unit FinanceiroApi.Controller.Pagamento;

interface

uses
  Horse,
  System.JSON,
  REST.Json,
  FinanceiroApi.Service.Pagamento,
  FinanceiroApi.Mapper.PagamentoOutput,
  FinanceiroApi.Dto.Input.Pagamento, System.SysUtils;

  procedure Listar(ARequest: THorseRequest; AResponse: THorseResponse);
  procedure Gravar(ARequest: THorseRequest; AResponse: THorseResponse);
  procedure Confirmar(ARequest: THorseRequest; AResponse: THorseResponse);
  procedure Excluir(ARequest: THorseRequest; AResponse: THorseResponse);

implementation

procedure Listar(ARequest: THorseRequest; AResponse: THorseResponse);
var
  LService: TServicePagamento;
begin
  LService := TServicePagamento.Create;
  try
    AResponse.Status(THttpStatus.OK).Send<TJSONArray>(TMapperFinanceiroOutput.ToJsonArray(LService.Listar));
  finally
    LService.Free;
  end;
end;

procedure Gravar(ARequest: THorseRequest; AResponse: THorseResponse);
var
  LInput: TDtoInputPagamento;
  LService: TServicePagamento;
begin
  LInput := TJson.JsonToObject<TDtoInputPagamento>(ARequest.Body);
  try
    LService := TServicePagamento.Create;
    try
      LService.Salvar(LInput);
      AResponse.Status(THttpStatus.Created).Send<TJSONObject>(TJSON.ObjectToJsonObject(LInput) );
    finally
      LService.Free;
    end;
  finally
    LInput.Free;
  end;
end;

procedure Confirmar(ARequest: THorseRequest; AResponse: THorseResponse);
var
  LService: TServicePagamento;
begin
  LService := TServicePagamento.Create;
  try
    LService.Confirmar(StrToIntDef(ARequest.Params['id'],0));
    AResponse.Status(THttpStatus.NoContent);
  finally
    LService.Free;
  end;
end;

procedure Excluir(ARequest: THorseRequest; AResponse: THorseResponse);
var
  LService: TServicePagamento;
begin
  LService := TServicePagamento.Create;
  try
    LService.Excluir(StrToIntDef(ARequest.Params['id'],0));
    AResponse.Status(THttpStatus.NoContent);
  finally
    LService.Free;
  end;
end;

end.
