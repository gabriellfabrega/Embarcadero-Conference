unit FinanceiroApi.Util.Banner;

interface

type
  TUtilBanner = class
  public
    class function EscreverEcon25: string; static;
  end;

implementation

{ TUtilBanner }

class function TUtilBanner.EscreverEcon25: string;
begin
  result :=
      ' 88888888b   a88888b.   .88888.   888888ba     d8888b.  888888P' + sLineBreak +
      ' 88         d8    `88  d8    `8b  88    `8b        `88  88'       + sLineBreak +
      ' a88aaaa    88         88     88  88     88    .aaadP   88baaa.'  + sLineBreak +
      ' 88         88         88     88  88     88    88            88'  + sLineBreak +
      ' 88         Y8.   .88  Y8.   .8P  88     88    88.           88'  + sLineBreak +
      ' 88888888P   Y88888P    `8888P    dP     dP    Y88888P  d88888P';
end;

end.
