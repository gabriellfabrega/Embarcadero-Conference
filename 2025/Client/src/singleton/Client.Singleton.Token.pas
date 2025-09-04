unit Client.Singleton.Token;

interface

type
  TSingletonToken = class
  private
    FAccessToken: string;
    FRefreshToken: string;
    FExpiresIn: Integer;
    FTokenType: string;
    FPublicClient: Boolean;
    class var FInstance: TSingletonToken;
    constructor Create;
  public
    class function GetInstance: TSingletonToken;
    property AccessToken: string read FAccessToken write FAccessToken;
    property RefreshToken: string read FRefreshToken write FRefreshToken;
    property ExpiresIn: Integer read FExpiresIn write FExpiresIn;
    property TokenType: string read FTokenType write FTokenType;
    property PublicClient : boolean read FPublicClient write FPublicClient;
    procedure Limpar;
  end;

implementation

var
  Instance: TSingletonToken = nil;

{ TTokenManager }

constructor TSingletonToken.Create;
begin
  inherited;
  Limpar;
end;


class function TSingletonToken.GetInstance: TSingletonToken;
begin
  if not Assigned(FInstance) then
    FInstance := TSingletonToken.Create;
  Result := FInstance;
end;

procedure TSingletonToken.Limpar;
begin
  FAccessToken := '';
  FRefreshToken := '';
  FExpiresIn := 0;
  FTokenType := '';
  FPublicClient := false;
end;

initialization

finalization
  if Assigned(Instance) then
    Instance.Free;

end.
