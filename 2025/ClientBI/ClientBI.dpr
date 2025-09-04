program ClientBI;

uses
  System.StartUpCopy,
  FMX.Forms,
  ClientBI.view.login in 'src\view\ClientBI.view.login.pas' {frmLogin},
  ClientBI.util.Autenticacao in 'src\util\ClientBI.util.Autenticacao.pas',
  ClientBI.singleton.Token in 'src\singleton\ClientBI.singleton.Token.pas',
  ClientBI.view.principal in 'src\view\ClientBI.view.principal.pas' {frmPrincipal},
  ClientBI.view.card in 'src\view\ClientBI.view.card.pas' {frmCard: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
