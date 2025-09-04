program ClientMail;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  RestRequest4D,
  DotEnv4Delphi,
  ClientMail.Util.Autenticacao in 'src\util\ClientMail.Util.Autenticacao.pas',
  ClientMail.Singleton.Token in 'src\singleton\ClientMail.Singleton.Token.pas';

begin
  try
    var LResponse: IResponse := TRequest.New
      .BaseURL(DotEnv.Env('BASE_URL_AUTH'))
      .Resource('realms/master/protocol/openid-connect/token')
      .AddParam('grant_type','client_credentials',pkGETorPOST)
      .AddParam('client_id','erp-backend', pkGETorPOST)
      .AddParam('client_secret',DotEnv.Env('CLIENT_SECRET'), pkGETorPOST)
      .Post;

    if LResponse.StatusCode.ToString.StartsWith('2') then
      WriteLn('Autenticacao bem sucedida');

    TUtilAutenticacao.CarregaJwtEmMemoria(LResponse.Content);

    var LResponse2: IResponse := TRequest.New
      .BaseURL(DotEnv.Env('BASE_URL'))
      .Resource('/pagamentos')
      .SetUserAgent(DotEnv.Env('APP_NAME'))
      .TokenBearer(TSingletonToken.GetInstance.AccessToken)
      .Accept('application/json')
      .Get;

    var LResponseJsonArray: TJSONArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(LResponse2.Content),0) as TJSONArray;

    for var LValue in LResponseJsonArray do
    begin
      WriteLn('Enviando email para ' + LValue.GetValue<string>('cliente') + ' referente ao pagamento ' + LValue.GetValue<string>('id'));
      Sleep(600);
    end;


    Writeln('Pressione ENTER para continuar...');
    Readln;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
