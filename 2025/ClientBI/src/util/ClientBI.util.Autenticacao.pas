unit ClientBI.util.Autenticacao;

interface

uses
  System.SysUtils, System.NetEncoding, System.Hash, System.JSON;

type
  TUtilAutenticacao = class
  public
    class function GerarCodeVerifier(ALength: Integer = 43): string; static;
    class function GerarCodeChallenge(const ACodeVerifier: string): string; static;
    class procedure CarregaJwtEmMemoria(AJwtString: string); static;
  end;

implementation

uses
  ClientBI.Singleton.Token;

class function TUtilAutenticacao.GerarCodeVerifier(ALength: Integer = 43): string;
const
  CHARS: string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
var
  I: Integer;
begin
  Randomize;
  Result := '';
  for I := 1 to ALength do
    Result := Result + CHARS[1 + Random(Length(CHARS))];
end;

class procedure TUtilAutenticacao.CarregaJwtEmMemoria(AJwtString: string);
var
  LResponseObject: TJSONObject;
begin
  LResponseObject := TJSONObject.ParseJSONValue(AJwtString) as TJsonObject;
  try
    TSingletonToken.GetInstance.AccessToken := LResponseObject.GetValue<String>('access_token');
    TSingletonToken.GetInstance.RefreshToken := LResponseObject.GetValue<String>('refresh_token');
    TSingletonToken.GetInstance.ExpiresIn := LResponseObject.GetValue<Integer>('expires_in');
    TSingletonToken.GetInstance.TokenType := LResponseObject.GetValue<String>('token_type');
  finally
    LResponseObject.Free
  end;
end;

class function TUtilAutenticacao.GerarCodeChallenge(const ACodeVerifier: string): string;
var
  LHash: TBytes;
begin
  LHash := THashSHA2.GetHashBytes(ACodeVerifier);
  Result := TNetEncoding.Base64.EncodeBytesToString(LHash);
  Result := Result.Replace('+', '-').Replace('/', '_').Replace('=', '');
end;

end.
