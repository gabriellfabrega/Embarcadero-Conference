unit FinanceiroApi.Service.Pagamento;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.DApt, SysUtils, System.Generics.Collections,

  FinanceiroApi.Dto.Input.Pagamento,
  FinanceiroApi.Dto.Output.Pagamento;

type
  TServicePagamento = class
  public
    procedure Salvar(AInput: TDtoInputPagamento);
    procedure Confirmar(AId: integer);
    procedure Excluir(AId: integer);
    function Listar: TObjectList<TDtoOutputPagamento>;
  end;

implementation

uses
  FinanceiroApi.Factory.Conexao;

{ TServicePagamento }

function TServicePagamento.Listar: TObjectList<TDtoOutputPagamento>;
var
  LConexao: TFDConnection;
  LQuery: TFDQuery;
begin
  result := TObjectList<TDtoOutputPagamento>.Create(true);
  LConexao := TFactoryConexao.CriarConexao;
  try
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := LConexao;
      LQuery.Open('SELECT * FROM PAGAMENTOS');
      LQuery.First;

      while not LQuery.Eof do
      begin
        var LDto := TDtoOutputPagamento.Create;
        LDto.Id := LQuery.FieldByName('ID').AsInteger;
        LDto.Cliente := LQuery.FieldByName('CLIENTE').AsString;
        LDto.Valor := LQuery.FieldByName('VALOR').Value;
        LDto.Pago := LQuery.FieldByName('PAGO').AsInteger;
        LDto.Datalanc := LQuery.FieldByName('DATALANC').AsString;
        LDto.Datavcto := LQuery.FieldByName('DATAVCTO').AsString;
        LDto.Datapag := LQuery.FieldByName('DATAPAG').AsString;
        result.Add(LDto);
        LQuery.Next;
      end;

    finally
      LQuery.Free;
    end;
  finally
    LConexao.Free;
  end;
end;

procedure TServicePagamento.Salvar(AInput: TDtoInputPagamento);
var
  LConexao: TFDConnection;
begin
  LConexao := TFactoryConexao.CriarConexao;
  try
    LConexao.ExecSQL('INSERT INTO PAGAMENTOS ' +
      '(datalanc, cliente, valor, datavcto) ' +
      'VALUES(CURRENT_TIMESTAMP, ' + AInput.Cliente.QuotedString + ',' + AInput.Valor.ToString + ',' + AInput.DataVcto.QuotedString + ')');
  finally
    LConexao.Free;
  end;
end;

procedure TServicePagamento.Confirmar(AId: integer);
var
  LConexao: TFDConnection;
begin
  if AId <= 0  then
    raise Exception.Create('ID do Pagamento não informado');

  LConexao := TFactoryConexao.CriarConexao;
  try
    LConexao.ExecSQL(
      'UPDATE PAGAMENTOS ' +
      'SET PAGO = 1, ' +
      '     DATAPAG = CURRENT_TIMESTAMP '+
      'WHERE ID = ' + AId.ToString);
  finally
    LConexao.Free;
  end;
end;

procedure TServicePagamento.Excluir(AId: integer);
var
  LConexao: TFDConnection;
begin
  if AId <= 0  then
    raise Exception.Create('ID do Pagamento não informado');

  LConexao := TFactoryConexao.CriarConexao;
  try
    LConexao.ExecSQL('DELETE FROM PAGAMENTOS WHERE ID = ' + AId.ToString);
  finally
    LConexao.Free;
  end;
end;


end.
