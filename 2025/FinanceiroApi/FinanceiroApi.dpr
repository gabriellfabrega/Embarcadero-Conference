program FinanceiroApi;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  REST.JSON,
  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  Horse.Logger,
  Horse.Logger.Provider.Console,
  JOSE.Core.JWT,
  DotEnv4Delphi,
  FinanceiroApi.Dto.Input.Pagamento in 'src\dto\FinanceiroApi.Dto.Input.Pagamento.pas',
  FinanceiroApi.Dto.Output.Pagamento in 'src\dto\FinanceiroApi.Dto.Output.Pagamento.pas',
  FinanceiroApi.Util.Token in 'src\util\FinanceiroApi.Util.Token.pas',
  FinanceiroApi.Service.Pagamento in 'src\service\FinanceiroApi.Service.Pagamento.pas',
  FinanceiroApi.Mapper.PagamentoOutput in 'src\mapper\FinanceiroApi.Mapper.PagamentoOutput.pas',
  FinanceiroApi.Factory.Conexao in 'src\factory\FinanceiroApi.Factory.Conexao.pas',
  FinanceiroApi.Controller.Pagamento in 'src\controller\FinanceiroApi.Controller.Pagamento.pas',
  FinanceiroApi.Route.Pagamentos in 'src\route\FinanceiroApi.Route.Pagamentos.pas',
  FinanceiroApi.Util.Banner in 'src\util\FinanceiroApi.Util.Banner.pas',
  FinanceiroApi.Util.Terminal in 'src\util\FinanceiroApi.Util.Terminal.pas';

begin
  THorseLoggerManager.RegisterProvider(THorseLoggerProviderConsole.New());

  THorse
    .Use(Jhonson)
    .Use(HandleException)
    .Use(THorseLoggerManager.HorseCallback);;

  FinanceiroApi.Route.Pagamentos.Registrar;

  THorse.Listen(
    StrToInt(DotEnv.EnvOrDefault('API_PORT','9998')),
    procedure()
    begin
      WriteLn(TUtilBanner.EscreverEcon25);
      WriteLn(EmptyStr);
      WriteLn('Horse Versão: ', THorse.Version);
      WriteLn('Servidor online na porta ', THorse.Port.ToString );
    end);
end.
