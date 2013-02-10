(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file: fsbrowserintf.pas


  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.

*)

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

