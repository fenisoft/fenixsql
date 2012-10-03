(*
   fenixsql
   author Alessandro Batisti

   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsexport.pas

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
unit fsexport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FBLDSql;

function FieldForCsv(const AString: string): string;
procedure ExportToCsvFile(AQuery: TFBLDsql; const AFilename: string);
procedure ExportToCsvFile2(AQuery: TFBLDsql; const AFilename: string);

implementation

function FieldForCsv(const AString: string): string;
var
  i: Integer;
  SepChar: string;
  NeedDoubleQuoted: Boolean;
begin
  NeedDoubleQuoted := False;
  if DefaultFormatSettings.DecimalSeparator = ',' then
    SepChar := ';'
  else
    SepChar := ',';
  Result := AString;
  if (Pos(#10, AString) > 0) or (Pos(#13, AString) > 0) or
    (Pos(SepChar, AString) > 0) then
  begin
    NeedDoubleQuoted := True;
  end;
  if Pos('"', AString) > 0 then
  begin
    Result := '';
    NeedDoubleQuoted := True;
    for i := 1 to Length(AString) do
    begin
      if AString[i] <> '"' then
        Result := Result + AString[i]
      else
        Result := Result + AString[i] + '"';
    end;
  end;

  if NeedDoubleQuoted then
     Result := '"' + Result + '"';
end;

procedure ExportToCsvFile(AQuery: TFBLDsql; const AFilename: string);
var
  Line: string;
  i: integer;
  List: TStringList;
  SepChar: string;
begin
  if DefaultFormatSettings.DecimalSeparator = ',' then
    SepChar := ';'
  else
    SepChar := ',';
  List := TStringList.Create;
  try
    Line := '';
    for i := 0 to AQuery.FieldCount - 1 do
    begin
      Line := Line + FieldForCsv(AQuery.FieldName(i));
      if i < (AQuery.FieldCount - 1) then
        Line := Line + SepChar;
    end;
    List.Add(Line);
    while not AQuery.EOF do
    begin
      Line := '';
      for i := 0 to AQuery.FieldCount - 1 do
      begin
        if not AQuery.FieldIsNull(i) then
          Line := Line + FieldForCsv(AQuery.FieldAsString(i));
        if i < (AQuery.FieldCount - 1) then
          Line := Line + SepChar;
      end;
      List.Add(Line);
      AQuery.Next;
    end;
    List.SaveToFile(AFilename);
  finally
    List.Free;
  end;
end;


procedure ExportToCsvFile2(AQuery: TFBLDsql; const AFilename: string);
var
  Line: string;
  i: integer;
  f: TextFile;
  SepChar: string;
begin
  if DefaultFormatSettings.DecimalSeparator = ',' then
    SepChar := ';'
  else
    SepChar := ',';

  AssignFile(f,AFilename);
  try
    ReWrite(f);
    Line := '';
    for i := 0 to AQuery.FieldCount - 1 do
    begin
      Line := Line + FieldForCsv(AQuery.FieldName(i));
      if i < (AQuery.FieldCount - 1) then
        Line := Line + SepChar;
    end;
    WriteLn(f,Line);
    while not AQuery.EOF do
    begin
      Line := '';
      for i := 0 to AQuery.FieldCount - 1 do
      begin
        if not AQuery.FieldIsNull(i) then
          Line := Line + FieldForCsv(AQuery.FieldAsString(i));
        if i < (AQuery.FieldCount - 1) then
          Line := Line + SepChar;
      end;
      WriteLn(f,Line);
      AQuery.Next;
    end;
  finally
    CloseFile(f);
  end;
end;
end.
