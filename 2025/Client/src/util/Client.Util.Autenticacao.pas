unit Client.Util.Autenticacao;

interface

uses
  System.SysUtils, ShellAPI, System.NetEncoding, Winapi.Windows, System.Hash,
  System.JSON;

type
  TUtilAutenticacao = class
  public
    class function GerarCodeVerifier(ALength: Integer = 43): string; static;
    class function GerarCodeChallenge(const ACodeVerifier: string): string; static;
    class procedure AbrirBrowser(const URL: string); static;
    class procedure CarregaJwtEmMemoria(AJwtString: string; APublicClient: boolean = false); static;
  end;

implementation

uses
  Client.Singleton.Token;

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

class procedure TUtilAutenticacao.CarregaJwtEmMemoria(AJwtString: string; APublicClient: boolean = false);
var
  LResponseObject: TJSONObject;
begin
  LResponseObject := TJSONObject.ParseJSONValue(AJwtString) as TJsonObject;
  try
    TSingletonToken.GetInstance.AccessToken := LResponseObject.GetValue<String>('access_token');
    TSingletonToken.GetInstance.RefreshToken := LResponseObject.GetValue<String>('refresh_token');
    TSingletonToken.GetInstance.ExpiresIn := LResponseObject.GetValue<Integer>('expires_in');
    TSingletonToken.GetInstance.TokenType := LResponseObject.GetValue<String>('token_type');
    TSingletonToken.GetInstance.PublicClient := APublicClient;
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

class procedure TUtilAutenticacao.AbrirBrowser(const URL: string);
var
  ChromePath: string;
begin
  // Caminho padrão do Chrome no Windows
  ChromePath := 'C:\Program Files\Google\Chrome\Application\chrome.exe';


  ShellExecute(0, 'open', PChar(URL), nil, nil, SW_SHOWNORMAL);
end;



end.
