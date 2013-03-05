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
  SysUtils, FBLDSql, LazUTF8, ibase_h, FBLMixf;

procedure ExportToCsvFile(AQuery: TFBLDsql; const AFilename: string);
procedure ExportToSQLScript(AQuery: TFBLDsql; const ATablename, AFilename: string);
procedure ExportToJson(AQuery: TFBLDsql; const AFileName: string;
  AJsonArray: boolean = True);

implementation

function FieldForCsv(const AString: string): string;
var
  i: integer;
  SepChar: string;
  NeedDoubleQuoted: boolean;
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
  f: TextFile;
  SepChar: string;
begin
  if DefaultFormatSettings.DecimalSeparator = ',' then
    SepChar := ';'
  else
    SepChar := ',';

  AssignFile(f, AFilename);
  try
    ReWrite(f);
    Line := '';
    for i := 0 to AQuery.FieldCount - 1 do
    begin
      Line := Line + FieldForCsv(AQuery.FieldName(i));
      if i < (AQuery.FieldCount - 1) then
        Line := Line + SepChar;
    end;
    WriteLn(f, Line);
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
      WriteLn(f, Line);
      AQuery.Next;
    end;
  finally
    CloseFile(f);
  end;
end;

procedure ExportToSQLScript(AQuery: TFBLDsql; const ATableName, AFileName: string);
var
  i: integer;
  Line: string;
  f: TextFile;
  TempDecimalSeparator: char;
begin
  AssignFile(f, AFilename);
  try
    ReWrite(f);
    while not AQuery.EOF do
    begin
      Line := 'insert into ' + ATableName + ' (';
      for i := 0 to AQuery.FieldCount - 1 do
      begin
        if not (AQuery.FieldIsNull(i) or
          ((AQuery.FieldType(i) = SQL_BLOB) and
          (AQuery.FieldSubType(i) <> isc_blob_text))) then
          Line := Line + AQuery.FieldName(i) + ',';
      end;
      Line := LeftStr(Line, Length(Line) - 1) + ') values (';

      for i := 0 to AQuery.FieldCount - 1 do
      begin
        if not (AQuery.FieldIsNull(i) or
          ((AQuery.FieldType(i) = SQL_BLOB) and
          (AQuery.FieldSubType(i) <> isc_blob_text))) then
        begin
          case AQuery.FieldType(i) of
            SQL_VARYING, SQL_TEXT:
              Line := Line + QuotedStr(Trim(AQuery.FieldAsString(i)));
            SQL_TYPE_DATE:
              Line := Line + QuotedStr(DateToSql(AQuery.FieldAsDateTime(i)));
            SQL_TYPE_TIME:
              Line := Line + QuotedStr(TimeToSql(AQuery.FieldAsDateTime(i)));
            SQL_TIMESTAMP:
              Line := Line + QuotedStr(DateTimeToSql(AQuery.FieldAsDateTime(i)));
            SQL_BLOB:
            begin
              if AQuery.FieldSubType(i) = isc_blob_text then
                Line := Line + QuotedStr(AQuery.BlobFieldAsString(i));
            end
            else
            begin
              TempDecimalSeparator := DefaultFormatSettings.DecimalSeparator;
              try
                DefaultFormatSettings.DecimalSeparator := '.';
                Line := Line + AQuery.FieldAsString(i);
              finally
                DefaultFormatSettings.DecimalSeparator := TempDecimalSeparator
              end;
            end;
          end;
          Line := Line + ',';
        end;

      end;
      Line := LeftStr(Line, Length(Line) - 1) + ');';
      WriteLn(f, Line);
      AQuery.Next;
    end;
  finally
    CloseFile(f);
  end;
end;


function StringForJson(AString: string): string;
var
  p: PChar;
  Unicode: cardinal;
  CharLen: integer;
begin
  Result := '';
  if Length(AString) > 0 then
  begin
    p := PChar(AString);
    repeat
      Unicode := UTF8CharacterToUnicode(p, CharLen);

      if CharLen > 1 then
        Result := Result + '\u' + LowerCase(IntToHex(unicode, 4))
      else
      begin
        case unicode of
          8: Result := Result + '\b';
          9: Result := Result + '\t';
          10: Result := Result + '\n';
          13: Result := Result + '\r';
          11: Result := Result + '\v';
          12: Result := Result + '\f';
          34: Result := Result + '\"';
          39: Result := Result + '\''';
          92: Result := Result + '\\';
          else
            if unicode > 0 then
              Result := Result + char(Unicode);
        end;
      end;
      Inc(p, CharLen);
    until (CharLen = 0) or (unicode = 0);
  end;
  Result := '"' + Result + '"';
end;


procedure ExportToJson(AQuery: TFBLDsql; const AFileName: string;
  AJsonArray: boolean = True);
var
  Line: string;
  f: TextFile;
  TempDecimalSeparator: char;
  i: integer;
begin
  AssignFile(f, AFilename);
  try
    ReWrite(f);
    while not AQuery.EOF do
    begin
      if Aquery.FetchCount = 1 then
      begin
        if AJsonArray then
          Line := '[{'
        else
          Line := '{';
      end
      else
        Line := '{';

      for i := 0 to AQuery.FieldCount - 1 do
      begin
        if AQuery.FieldIsNull(i) then
          Line := Line + '"' + AQuery.FieldName(i) + '":' + 'null,'
        else
        begin

          case AQuery.FieldType(i) of
            SQL_BLOB:
            begin
              if AQuery.FieldSubType(i) = isc_blob_text then
                Line :=
                  Line + '"' + AQuery.FieldName(i) + '":' +
                  StringForJson(AQuery.BlobFieldAsString(i)) + ','
              else
                Line := Line + '"' + AQuery.FieldName(i) + '":"",';
            end;
            SQL_VARYING, SQL_TEXT:
              Line := Line + '"' + AQuery.FieldName(i) + '":' +
                StringForJson(AQuery.FieldAsString(i)) + ',';

            SQL_TYPE_DATE, SQL_TYPE_TIME, SQL_TIMESTAMP:
              Line := Line + '"' + AQuery.FieldName(i) + '":"' +
                AQuery.FieldAsString(i) + '",';
            else
            begin
              TempDecimalSeparator := DefaultFormatSettings.DecimalSeparator;
              try
                DefaultFormatSettings.DecimalSeparator := '.';
                Line :=
                  Line + '"' + AQuery.FieldName(i) + '":' + AQuery.FieldAsString(i) + ',';
              finally
                DefaultFormatSettings.DecimalSeparator := TempDecimalSeparator
              end;
            end;
          end;

        end;
      end;
      AQuery.Next;
      Line := LeftStr(Line, Length(Line) - 1) + '}';
      if AJsonArray then
      begin
        if AQuery.EOF then
          Line := Line + ']'
        else
          Line := Line + ',';
      end;
      Writeln(f, Line);
    end;
  finally
    CloseFile(f);
  end;
end;

end.
