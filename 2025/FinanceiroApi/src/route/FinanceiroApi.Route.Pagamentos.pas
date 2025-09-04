unit FinanceiroApi.Route.Pagamentos;

interface

uses
  Horse,
  JOSE.Core.JWT,
  System.SysUtils;

procedure Registrar;

implementation

uses
  FinanceiroApi.Util.Token,
  FinanceiroApi.Controller.Pagamento,
  FinanceiroApi.Util.Terminal;

procedure Registrar;
begin

  THorse.Get('/pagamentos', procedure(ARequest: THorseRequest; AResponse: THorseResponse)
  begin
    try
      TUtilToken.ValidateJWT(ARequest.Headers['Authorization']);
    except on e: Exception do
      begin
        AResponse.Status(THttpStatus.Unauthorized).Send(e.Message);
        TUtilTerminal.WriteAqua(e.Message);
        exit;
      end;
    end;

    FinanceiroApi.Controller.Pagamento.Listar(ARequest,AResponse);
  end);

  THorse.Post('/pagamentos', procedure(ARequest: THorseRequest; AResponse: THorseResponse)
  var LJWT: TJWT;
  begin
    try
      LJWT := TUtilToken.ValidateJWT(ARequest.Headers['Authorization']);
    except on e: Exception do
      begin
        AResponse.Status(THttpStatus.Unauthorized).Send(e.Message);
        TUtilTerminal.WriteAqua(e.Message);
        exit;
      end;
    end;

    if TUtilToken.HasScope(LJWT,'erp.write') then
      FinanceiroApi.Controller.Pagamento.Gravar(ARequest,AResponse)
    else
      AResponse.Status(THttpStatus.Forbidden);
  end);

  THorse.Put('/pagamentos/:id/confirmar', procedure(ARequest: THorseRequest; AResponse: THorseResponse)
  var LJWT: TJWT;
  begin
    try
      LJWT := TUtilToken.ValidateJWT(ARequest.Headers['Authorization']);
    except on e: Exception do
      begin
        AResponse.Status(THttpStatus.Unauthorized).Send(e.Message);
        TUtilTerminal.WriteAqua(e.Message);
        exit;
      end;
    end;

    if TUtilToken.HasScope(LJWT,'erp.write') and TUtilToken.HasRole(LJWT,'supervisor') then
      FinanceiroApi.Controller.Pagamento.Confirmar(ARequest,AResponse)
    else
      AResponse.Status(THttpStatus.Forbidden);
  end);

  THorse.Delete('/pagamentos/:id', procedure(ARequest: THorseRequest; AResponse: THorseResponse)
  var LJWT: TJWT;
  begin
    try
      LJWT := TUtilToken.ValidateJWT(ARequest.Headers['Authorization']);
    except on e: Exception do
      begin
        AResponse.Status(THttpStatus.Unauthorized).Send(e.Message);
        TUtilTerminal.WriteAqua(e.Message);
        exit;
      end;
    end;

    if TUtilToken.HasScope(LJWT,'erp.write') and TUtilToken.HasRole(LJWT,'supervisor') then
      FinanceiroApi.Controller.Pagamento.Excluir(ARequest,AResponse)
    else
      AResponse.Status(THttpStatus.Forbidden);
  end);


end;



end.
