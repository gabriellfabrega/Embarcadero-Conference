unit ClientBI.view.card;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmCard = class(TFrame)
    Rectangle1: TRectangle;
    lblCliente: TLabel;
    lblVenc: TLabel;
    lblValor: TLabel;
    lytOpcoes: TLayout;
    spbConfirmar: TSpeedButton;
    Image1: TImage;
    spbCancelar: TSpeedButton;
    Image2: TImage;
    rctPago: TRectangle;
    Label1: TLabel;
  private
    FId: Integer;
    FPago: Integer;
    procedure SetPago(const Value: Integer);
  public
    property Id: Integer read FId write FId;
    property Pago: Integer read FPago write SetPago;
  end;

implementation

{$R *.fmx}

{ TfrmCard }

procedure TfrmCard.SetPago(const Value: Integer);
begin
  FPago := Value;
  lytOpcoes.Visible := Value = 0;
  rctPago.Visible := Value = 1;
end;

end.
