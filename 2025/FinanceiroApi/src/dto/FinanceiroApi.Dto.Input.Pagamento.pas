unit FinanceiroApi.Dto.Input.Pagamento;

interface

type
  TDtoInputPagamento = class
  private
    FCliente: string;
    FValor: Double;
    FDataVcto: String;
  published
    property Cliente: string read FCliente write FCliente;
    property Valor: Double read FValor write FValor;
    property DataVcto: String read FDataVcto write FDataVcto;
  end;

implementation

end.
