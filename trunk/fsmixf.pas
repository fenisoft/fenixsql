(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsmixf.pas


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


unit fsmixf;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, ibase_h;

function TimeT(ADateTime: TDateTime): string;
function TypeDesc(const AType: smallint): string;
function FormatNumericValue(AValue: Double; AScale: Integer): string;
function StmErrorAtLine(const AErrorMsg: string):Integer;


implementation

function TypeDesc(const AType: smallint): string;
begin
  Result := '';
  case AType of
    SQL_VARYING: Result := 'VARYING';
    SQL_TEXT: Result := 'TEXT';
    SQL_DOUBLE: Result := 'DOUBLE';
    SQL_FLOAT: Result := 'FLOAT';
    SQL_LONG: Result := 'LONG';
    SQL_SHORT: Result := 'SHORT';
    SQL_TIMESTAMP: Result := 'TIMESTAMP';
    SQL_BLOB: Result := 'BLOB';
    SQL_D_FLOAT: Result := 'D_FLOAT';
    SQL_ARRAY: Result := 'ARRAY';
    SQL_QUAD: Result := 'QUAD';
    SQL_TYPE_TIME: Result := 'TIME';
    SQL_TYPE_DATE: Result := 'DATE';
    SQL_INT64: Result := 'INT64';
  end;
end;


function TimeT(ADateTime: TDateTime): string;
var
  h, m, s, ms: word;
begin
  DecodeTime(ADateTime, h, m, s, ms);
  if m > 0 then
    Result := Format('%dm and %d.%d s', [m, s, ms])
  else
    Result := Format('%d.%d s', [s, ms]);
end;

function FormatNumericValue(AValue: Double; AScale: Integer): string;
var
  FormStr: string;
begin
  if AScale < 0 then
  begin
    FormStr := '%.' + IntToStr(Abs(AScale)) + 'f';
    Result := Format(FormStr, [AValue]);
  end
  else
    Result := FloatToStr(AValue);
end;

function StmErrorAtLine(const AErrorMsg: string): Integer;
const
  L = 'line ';
var
  i: integer;
  c: char;
  Num: string;
  function IsDigit(c: char): boolean;
  begin
    Result := (c in ['0'..'9']);
  end;
begin
  Num := '';
  i := Pos(L, AErrorMsg);
  if i > 0 then
  begin
      i := i + Length(L);
      c := AErrorMsg[i];
      while IsDigit(c) do
      begin
        Num := Num + c;
        Inc(i);
        c := AErrorMsg[i];
      end;
    Result := StrToInt(Num);
  end
  else
    Result := 1;
end;

end.
