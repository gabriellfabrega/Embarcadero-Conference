program Producer;

uses
  Vcl.Forms,
  Producer.View.Principal in 'src\View\Producer.View.Principal.pas' {ViewPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;
end.
