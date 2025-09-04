unit ClientMail.Util.Autenticacao;

interface

uses
  System.JSON;

type
  TUtilAutenticacao = class
  public
    class procedure CarregaJwtEmMemoria(AJwtString: string); static;
  end;

implementation

uses
  ClientMail.Singleton.Token;

class procedure TUtilAutenticacao.CarregaJwtEmMemoria(AJwtString: string);
var
  LResponseObject: TJSONObject;
begin
  LResponseObject := TJSONObject.ParseJSONValue(AJwtString) as TJsonObject;
  try
    TSingletonToken.GetInstance.AccessToken := LResponseObject.GetValue<String>('access_token');
    TSingletonToken.GetInstance.ExpiresIn := LResponseObject.GetValue<Integer>('expires_in');
    TSingletonToken.GetInstance.TokenType := LResponseObject.GetValue<String>('token_type');
  finally
    LResponseObject.Free
  end;
end;


end.
