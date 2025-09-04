unit FinanceiroApi.Util.Terminal;

interface

uses
  Winapi.Windows, System.SysUtils;

type
  TUtilTerminal = class
  public
    class procedure WriteAqua(const S: string); static;
  end;

implementation

class procedure TUtilTerminal.WriteAqua(const S: string);
var
  hOut: THandle;
  OldAttr: Word;
  BufInfo: TConsoleScreenBufferInfo;
begin
  hOut := GetStdHandle(STD_OUTPUT_HANDLE);

  // Salva atributos atuais
  GetConsoleScreenBufferInfo(hOut, BufInfo);
  OldAttr := BufInfo.wAttributes;

  // Ciano brilhante (azul piscina)
  SetConsoleTextAttribute(hOut, FOREGROUND_GREEN or FOREGROUND_BLUE or FOREGROUND_INTENSITY);
  Write('[INFO] ' + S);
  Write(#13#10);

  // Restaura atributos
  SetConsoleTextAttribute(hOut, OldAttr);
end;

end.
