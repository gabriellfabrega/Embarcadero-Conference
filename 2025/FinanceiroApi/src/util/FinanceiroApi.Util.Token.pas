unit FinanceiroApi.Util.Token;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.JSON,
  System.DateUtils,
  JOSE.Core.JWT,
  JOSE.Core.JWS,
  JOSE.Core.JWK,
  JOSE.Core.Builder,
  FinanceiroAPI.Util.Terminal,
  DotEnv4Delphi;

type
  TUtilToken = class
  private
    class function GetPemString: string;
  public
    class function ValidateJWT(const Token: string): TJWT; static;
    class function HasScope(AJWT: TJWT; const AScope: string): Boolean; static;
    class function HasRole(AJWT: TJWT; const ARole: string): Boolean; static;
  end;

implementation

class function TUtilToken.HasScope(AJWT: TJWT; const AScope: string): Boolean;
var
  LScopes: TArray<string>;
  LScopeStr: string;
begin
  LScopeStr := AJWT.Claims.JSON.GetValue<string>('scope');

  if LScopeStr.IsEmpty then
    Exit(False);

  LScopes := LScopeStr.Split([' '], TStringSplitOptions.ExcludeEmpty);

  Result := MatchText(AScope, LScopes);
  if not Result then
      TUtilTerminal.WriteAqua('Escopo <' + AScope + '> não encontrado ')
end;

class function TUtilToken.HasRole(AJWT: TJWT; const ARole: string): Boolean;
var
  LRoles: TJSONArray;
  LResourceAccess: TJSONObject;
begin
  Result := False;
  LResourceAccess := nil;

  if AJWT.Claims.ClaimExists('realm_access') then
    LResourceAccess := AJWT.Claims.JSON.GetValue<TJSONObject>('realm_access');

  if not Assigned(LResourceAccess) then
    Exit;

  LRoles := LResourceAccess.GetValue<TJSONArray>('roles');
  if not Assigned(LRoles) then
    exit(false);

  for var I := 0 to LRoles.Count - 1 do
  begin
    if SameText(LRoles.Items[I].Value, ARole) then
      Exit(True);
  end;

  TUtilTerminal.WriteAqua('Role <' + ARole + '> não encontrada ');
end;

class function TUtilToken.ValidateJWT(const Token: string): TJWT;
var
  JWT: TJWT;
  JWS: TJWS;
  JWK: TJWK;
begin
  Result := nil;

  if Token.IsEmpty then
    raise Exception.Create('Token em branco');

  JWT := TJWT.Create;
  try
    JWK := TJWK.Create(GetPemString);
    try
      JWS := TJWS.Create(JWT);
      try
        JWS.SetKey(JWK);

        if not JWS.CheckCompactToken(Token.Replace('Bearer ','',[rfReplaceAll])) then
          raise Exception.Create('Token inválido');
        if not JWS.VerifySignature(JWK,Token.Replace('Bearer ','',[rfReplaceall])) then
          raise Exception.Create('Assinatura não validada');
        if JWT.Claims.IssuedAt > Now then
          raise Exception.Create('Data de emissão do Token não pode ser superior à data atual');
        if Now > JWT.Claims.Expiration then
          raise Exception.Create('Token expirado');

        Result := JWT;
      finally
        JWS.Free;
      end;
    finally
      JWK.Free;
    end;
  except on e:exception do
    begin
      JWT.Free;
      raise Exception.Create(e.Message);
    end;
  end;
end;

class function TUtilToken.GetPemString: string;
var
  LPemFile: TStringList;
begin
  LPemFile := TStringList.Create;
  try
    LPemFile.LoadFromFile(DotEnv.Env('PEM_FILE'));
    result := LPemFile.Text;
  finally
    LPemFile.Free;
  end;
end;

end.
