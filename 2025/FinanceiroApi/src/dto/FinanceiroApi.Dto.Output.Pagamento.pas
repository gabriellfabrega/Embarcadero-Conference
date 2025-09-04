unit FinanceiroApi.Dto.Output.Pagamento;

interface

type
  TDtoOutputPagamento = class
  private
    FId: integer;
    FCliente: string;
    FValor: Double;
    FPago: Integer;
    FDatalanc: String;
    FDatavcto: String;
    FDatapag: String;
  public
    property Id: integer read FId write FId;
    property Cliente: string read FCliente write FCliente;
    property Valor: Double read FValor write FValor;
    property Pago: Integer read FPago write FPago;
    property Datalanc: String read FDatalanc write FDatalanc;
    property Datavcto: String read FDatavcto write FDatavcto;
    property Datapag: String read FDatapag write FDatapag;
  end;

implementation

{ TDtoOutputPagamento }

end.
