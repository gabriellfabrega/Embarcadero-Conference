unit ClientBI.view.login;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMX.Objects, FMX.Layouts, FMX.StdCtrls,
  FMX.TabControl, FMX.WebBrowser, System.NetEncoding, FMX.Effects;

type
  TfrmLogin = class(TForm)
    lytLogo: TLayout;
    lytCampos: TLayout;
    lytUsuario: TLayout;
    rctUsuario: TRectangle;
    edtUsuario: TEdit;
    lytSenha: TLayout;
    rctSenha: TRectangle;
    edtSenha: TEdit;
    lytBotoes: TLayout;
    rctLogin: TRoundRect;
    lblLogin: TLabel;
    sbpLogin: TSpeedButton;
    rctSSO: TRoundRect;
    lblSSO: TLabel;
    spbSSO: TSpeedButton;
    lblTitulo: TLabel;
    Image1: TImage;
    tbctrlPrincipal: TTabControl;
    tbitemLogin: TTabItem;
    tbitemBrowser: TTabItem;
    WebBrowser1: TWebBrowser;
    Rectangle1: TRectangle;
    ShadowEffect1: TShadowEffect;
    spbVoltar: TSpeedButton;
    lblTituloBrowser: TLabel;
    procedure sbpLoginClick(Sender: TObject);
    procedure spbSSOClick(Sender: TObject);
    procedure WebBrowser1ShouldStartLoadWithRequest(ASender: TObject;
      const URL: string);
    procedure FormShow(Sender: TObject);
    procedure spbVoltarClick(Sender: TObject);
  private
    FCodeVerifier: String;
    procedure AbreFormPrincipal;
  public
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  RestRequest4D,
  ClientBI.util.Autenticacao,
  ClientBI.view.principal;

const
  //SERVER_AUTH = 'http://192.168.0.108:8080';
  SERVER_AUTH = 'https://keycloak.fabregaserver.cloud';
  SECRET = 'KrIb0IrkXCjWOwlvVESQ0mmIg9YZv0tJ';
{$R *.fmx}

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  tbctrlPrincipal.ActiveTab := tbitemLogin;
end;

procedure TfrmLogin.AbreFormPrincipal;
begin
  Application.CreateForm(tfrmPrincipal, frmPrincipal);
  Application.MainForm := frmPrincipal;
  frmPrincipal.Show;
  Self.Close;
end;

procedure TfrmLogin.sbpLoginClick(Sender: TObject);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New
    .BaseURL(SERVER_AUTH)
    .Resource('realms/master/protocol/openid-connect/token')
    .AddParam('grant_type','password',pkGETorPOST)
    .AddParam('client_id','erp-bi', pkGETorPOST)
    .AddParam('client_secret',SECRET, pkGETorPOST)
    .AddParam('username',edtUsuario.Text.Trim, pkGETorPOST)
    .AddParam('password',edtSenha.Text.Trim, pkGETorPOST)
    .Post;

  if LResponse.StatusCode <> 200 then
  begin
    ShowMessage(LResponse.StatusCode.ToString);
    raise Exception.Create('Usuário ou senha inválidos');
  end;


  TUtilAutenticacao.CarregaJwtEmMemoria(LResponse.Content);
  AbreFormPrincipal;
end;


procedure TfrmLogin.spbSSOClick(Sender: TObject);
var
  LCodeChallenge: String;
  LRedirect : string;
begin
  FCodeVerifier := TUtilAutenticacao.GerarCodeVerifier;
  LCodeChallenge := TUtilAutenticacao.GerarCodeChallenge(FCodeVerifier);

  LRedirect := SERVER_AUTH + '/realms/master/protocol/openid-connect/auth'+
    '?client_id=erp-bi-public'+
    '&response_type=code'+
    '&scope=openid'+
    '&redirect_uri=myapp://callback'+
    '&code_challenge='+ LCodeChallenge +
    '&code_challenge_method=S256'+
    '&prompt=login';

  WebBrowser1.URL := LRedirect;
  WebBrowser1.Navigate;
  tbctrlPrincipal.ActiveTab := tbitemBrowser;
end;


procedure TfrmLogin.spbVoltarClick(Sender: TObject);
begin
  tbctrlPrincipal.ActiveTab := tbitemLogin;
end;

procedure TfrmLogin.WebBrowser1ShouldStartLoadWithRequest(ASender: TObject;
  const URL: string);
var
  LCode: string;
  LResponse: IResponse;
begin
  if URL.StartsWith('myapp://callback') then
  begin

    LCode := TNetEncoding.URL.Decode(URL.Split(['code='])[1]);

    LResponse := TRequest.New
      .BaseURL(SERVER_AUTH)
      .Resource('realms/master/protocol/openid-connect/token')
      .AddParam('grant_type','authorization_code',pkGETorPOST)
      .AddParam('client_id','erp-bi-public', pkGETorPOST)
      .AddParam('redirect_uri','myapp://callback',pkGETorPOST)
      .AddParam('code',LCode,pkGETorPOST)
      .AddParam('code_verifier',FCodeVerifier,pkGETorPOST)
      .Post;


    if LResponse.StatusCode <> 200 then
      raise Exception.Create('Falha no login');

    TUtilAutenticacao.CarregaJwtEmMemoria(LResponse.Content);

    AbreFormPrincipal;
    Self.ModalResult := mrOk;
  end;
end;


end.
