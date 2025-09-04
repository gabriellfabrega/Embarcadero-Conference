unit FinanceiroApi.Mapper.PagamentoOutput;

interface

uses
  System.JSON,
  System.Generics.Collections,
  FinanceiroApi.Dto.Output.Pagamento;

type
  TMapperFinanceiroOutput = class
  public
    class function ToJsonArray(AList: TObjectList<TDtoOutputPagamento>): TJSONArray;
  end;

implementation

{ TMapperFinanceiroOutput }

class function TMapperFinanceiroOutput.ToJsonArray(AList: TObjectList<TDtoOutputPagamento>): TJSONArray;
var
  LItem: TJSONObject;
begin
  Result := TJSONArray.Create;
  for var LPagamento: TDtoOutputPagamento in AList do
  begin
    LItem := TJSONObject.Create;
    LItem.AddPair('id', TJSONNumber.Create(LPagamento.Id));
    LItem.AddPair('cliente', LPagamento.Cliente);
    LItem.AddPair('valor', TJSONNumber.Create(LPagamento.Valor));
    LItem.AddPair('pago', TJSONNumber.Create(LPagamento.Pago));
    LItem.AddPair('datalanc', LPagamento.Datalanc);
    LItem.AddPair('datavcto', LPagamento.Datavcto);
    LItem.AddPair('datapag', LPagamento.Datapag);
    Result.AddElement(LItem);
  end;
end;

end.
