program Client;

uses
  Vcl.Forms,
  Vcl.Controls,
  Client.View.Principal in 'src\view\Client.View.Principal.pas' {frmPrincipal},
  Client.View.Login in 'src\view\Client.View.Login.pas' {frmLogin},
  Client.Singleton.Token in 'src\singleton\Client.Singleton.Token.pas',
  Client.Dto.Input.Pagamento in 'src\dto\Client.Dto.Input.Pagamento.pas',
  Client.Util.Autenticacao in 'src\util\Client.Util.Autenticacao.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  TStyleManager.TrySetStyle('Onyx Blue');
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmLogin, frmLogin);
  if frmLogin.ShowModal = mrOk then
  begin
    Application.Initialize;
    Application.MainFormOnTaskbar := True;
    Application.Run;
  end;
end.
