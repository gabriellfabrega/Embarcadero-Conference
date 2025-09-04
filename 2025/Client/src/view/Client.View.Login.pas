unit Client.View.Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TfrmLogin = class(TForm)
    edtUsuario: TLabeledEdit;
    edtSenha: TLabeledEdit;
    btnLoginCredenciais: TButton;
    btnLoginRedirect: TButton;
    procedure btnLoginCredenciaisClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLoginRedirectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FCodeVerifier: String;
    FBaseUrlAuth: string;
    FClientSecret: string;
    FRedirectUri : string;
    FRedirectPort: integer;
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  Client.Singleton.Token,
  Client.Util.Autenticacao,
  RESTRequest4D,
  System.JSON,
  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  DotEnv4Delphi;


{$R *.dfm}

procedure TfrmLogin.btnLoginCredenciaisClick(Sender: TObject);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(FBaseUrlAuth)
    .Resource('realms/master/protocol/openid-connect/token')
    .AddParam('grant_type','password',pkGETorPOST)
    .AddParam('client_id','erp-desktop', pkGETorPOST)
    .AddParam('client_secret',FClientSecret, pkGETorPOST)
    .AddParam('username',edtUsuario.Text, pkGETorPOST)
    .AddParam('password',edtSenha.Text, pkGETorPOST)
    .Post;

  if LResponse.StatusCode <> 200 then
    raise Exception.Create('Usuário ou senha inválidos');

  TUtilAutenticacao.CarregaJwtEmMemoria(LResponse.Content);
  
  ModalResult := mrOk;
end;

procedure TfrmLogin.btnLoginRedirectClick(Sender: TObject);
var
  LCodeChallenge: String;
  LRedirect: string;
begin
  FCodeVerifier := TUtilAutenticacao.GerarCodeVerifier;
  LCodeChallenge := TUtilAutenticacao.GerarCodeChallenge(FCodeVerifier);

  LRedirect := FBaseUrlAuth + '/realms/master/protocol/openid-connect/auth'+
    '?client_id=erp-desktop-public'+
    '&response_type=code'+
    '&scope=openid'+
    '&redirect_uri='+ FRedirectUri +
    '&code_challenge=' + LCodeChallenge +
    '&code_challenge_method=S256'+
    '&prompt=login';


  TUtilAutenticacao.AbrirBrowser(LRedirect);
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  FBaseUrlAuth := DotEnv.Env('BASE_URL_AUTH');
  FClientSecret := DotEnv.Env('CLIENT_SECRET');
  FRedirectUri := DotEnv.Env('OAUTH_REDIRECT_URI');
  FRedirectPort := StrToInt(DotEnv.Env('OAUTH_REDIRECT_PORT'));

  THorse
    .Use(Jhonson)
    .Use(HandleException);

  THorse.Get('/callback',
    procedure(AReq: THorseRequest; AResp: THorseResponse)
    var
      LResponse: IResponse;
    const
      PUBLICO = true;
    begin
        LResponse := TRequest.New
          .BaseURL(FBaseUrlAuth)
          .Resource('realms/master/protocol/openid-connect/token')
          .AddParam('grant_type','authorization_code',pkGETorPOST)
          .AddParam('client_id','erp-desktop-public', pkGETorPOST)
          .AddParam('redirect_uri',FRedirectUri,pkGETorPOST)
          .AddParam('code',AReq.Query['code'],pkGETorPOST)
          .AddParam('code_verifier',FCodeVerifier,pkGETorPOST)
          .Post;

      if LResponse.StatusCode <> 200 then
        raise Exception.Create('Falha no login');

      TUtilAutenticacao.CarregaJwtEmMemoria(LResponse.Content,PUBLICO);

      Self.ModalResult := mrOk;
    end);

  THorse.Listen(StrToInt(DotEnv.Env('OAUTH_REDIRECT_PORT')));
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmLogin := nil;
end;


end.
