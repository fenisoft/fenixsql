unit fsbrowserintf;

{$mode objfpc}{$H+}

interface

uses
  Classes;

type

TFsEditInfo = class
  private
    FText: string;
    FCarretPos: TPoint;
  public
    constructor Create(const AText: string = '');
    property Text: String read FText write FText;
    property CarretPos: TPoint read FCarretPos write FCarretPos;
  end;

implementation

constructor TFsEditInfo.Create(const AText: string = '');
begin
  FText := AText;
  FCarretPos.x := 1;
  FCarretPos.y := 1;
end;

end.

