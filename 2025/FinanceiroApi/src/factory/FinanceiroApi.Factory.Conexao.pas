unit FinanceiroApi.Factory.Conexao;

interface

uses
  FireDAC.Comp.Client,
  System.SysUtils;

type
  TFactoryConexao = class
  public
    class function CriarConexao: TFDConnection; static;
  end;

implementation

{ TFactoryConexao }

class function TFactoryConexao.CriarConexao: TFDConnection;
begin
  result := TFDConnection.Create(nil);
  result.Params.DriverID := 'SQLite';
  result.Params.Database := ExtractFilePath(ParamStr(0)) + 'Financeiro.db';
  result.LoginPrompt := false;
  result.Params.Values['OpenMode'] := 'ReadWrite';
  result.Params.Values['LockingMode'] := 'Normal';
end;

end.
