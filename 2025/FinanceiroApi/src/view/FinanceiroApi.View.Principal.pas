unit FinanceiroApi.View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, Vcl.StdCtrls;

type
  TfrmFinanceiroApi = class(TForm)
    FDConnection1: TFDConnection;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFinanceiroApi: TfrmFinanceiroApi;

implementation

uses
  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  DataSet.Serialize,
  System.JSON,
  REST.JSON,
  JOSE.Core.JWT,
  FinanceiroApi.Dto.Input.Pagamento,
  FinanceiroApi.Service.Pagamento,
  FinanceiroApi.Mapper.PagamentoOutput,
  FinanceiroApi.Util.Token,
  FinanceiroApi.Exception.TokenInvalido;

{$R *.dfm}

procedure TfrmFinanceiroApi.FormCreate(Sender: TObject);
begin
  THorse
    .Use(Jhonson)
    .Use(HandleException);

  THorse.Get('/pagamentos',
    procedure(AReq: THorseRequest; AResp: THorseResponse)
    begin
      try
        var LJWT: TJWT := TUtilToken.ValidateJWT(AReq.Headers['Authorization']);
      except on e: TExceptionTokenInvalido do
        begin
          AResp.Status(401).Send(e.Message);
          exit;
        end;
      end;

      var LService := TServicePagamento.Create(FDConnection1);
      try
        AResp.Status(200).Send<TJSONArray>(TMapperFinanceiroOutput.ToJsonArray(LService.Listar));
      finally
        LService.Free;
      end;
    end);

  THorse.Post('/pagamentos',
    procedure(AReq: THorseRequest; AResp: THorseResponse)
    begin

      try
        var LJWT: TJWT := TUtilToken.ValidateJWT(AReq.Headers['Authorization']);

        if TUtilToken.HasRole(LJWT,'FINANCEIRO_SUPERVISOR') and TUtilToken.HasScope(LJWT,'ERP')
        then
        begin
          var LInput := TJson.JsonToObject<TDtoInputPagamento>(AReq.Body);
          try
            var LService := TServicePagamento.Create(FDConnection1);
            try
              LService.Salvar(LInput);
              AResp.Status(201).Send<TJSONObject>( TJSON.ObjectToJsonObject(LInput) );
            finally
              LService.Free;
            end;
          finally
            LInput.Free;
          end;
        end
        else
          AResp.Status(403);

      except on e: TExceptionTokenInvalido do
        begin
          AResp.Status(401).Send(e.Message);
          exit;
        end;
      end;
    end);

  THorse.Listen(9998);
end;








end.
