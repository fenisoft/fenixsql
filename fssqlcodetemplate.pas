(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file: fssqlcodetemplate.pas


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
unit fssqlcodetemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function TableCreate(const AName: string;const APk: string = ''): string;
function TableCreateWithAutoIncrement(AName: string; APk: string = 'ID'): string;
function TableInsert(const ATableName: string; AFields:  TStringList): string;
function TableUpdate(const ATableName: string; AFields:  TStringList): string;


implementation

uses fsdm;


function TableCreate(const AName: string; const APk: string = ''): string;
var
  code: TStringList;
begin
  code := TStringList.Create;
  try
    with code do
    begin
      Add('CREATE TABLE ' + AName);
      Add('(');
      if (APk <> '') then
         Add(Format('  %s INTEGER NOT NULL,',[APk]));
      Add('  column_name {< datatype> | COMPUTED BY (< expr>) | domain}');
      Add('    [DEFAULT { literal | NULL | USER}] [NOT NULL]');
      Add('  ');
      Add(Format('  CONSTRAINT %s_PK',[AName]));
      Add(Format('        PRIMARY KEY (%s)',[APk]));
      Add(');');
    end;
    Result := code.Text;
  finally
    code.Free;
  end;
end;

function TableCreateWithAutoIncrement(AName: string; APk: string = 'ID'): string;
var
  code: TStringList;
begin
  code := TStringList.Create;
  try
    with code do
    begin
      Add(Format('CREATE TABLE %s',[AName]));
      Add('(');
      Add(Format('  %s INTEGER NOT NULL,',[APk]));
      Add('  column_name {< datatype> | COMPUTED BY (< expr>) | domain}');
      Add('    [DEFAULT { literal | NULL | USER}] [NOT NULL]');
      Add('  ');
      Add(Format('  CONSTRAINT %s_PK',[AName]));
      Add(Format('        PRIMARY KEY (%s)',[APk]));
      Add(');');
      Add(' ');
      Add(Format('CREATE GENERATOR GEN_%s_ID;',[AName]));
      Add('');
      Add('SET TERM ^;');
      Add(Format('CREATE TRIGGER TRIG_%s_BI FOR %s',[AName,AName]));
      Add('ACTIVE BEFORE INSERT');
      Add('POSITION 0');
      Add('as');
      Add('begin');
      Add('/* Trigger Text */');
      Add(Format('  if (new.%s is null )then',[APk]));
      Add(Format('    new.%s = gen_id(GEN_%s_ID ,1);',[APk,AName]));
      Add('end^');
      Add('SET TERM ;^');
    end;
    Result := code.Text;
  finally
    code.Free;
  end;
end;

function TableInsert(const ATableName: string; AFields:  TStringList): string;
var
  i: integer;
  code:  TStringList;
  sep : string;
begin
   code :=  TStringList.Create;
   try
      code.Add('insert into ' + ATableName);
      code.Add('(');
      for i:= 0 to  AFields.Count - 1 do
      begin
        if (i <  (AFields.Count - 1)) then
          sep := ' ,'
        else
          sep := '';
        code.Add('  ' + AFields.Strings[i] + sep);
      end;
      code.Add(')');
      code.Add('values');
      code.Add('(');
      for i:= 0 to  AFields.Count - 1  do
      begin
        if (i <  (AFields.Count - 1 )) then
          sep := ' ,'
        else
          sep := '';
        code.Add('  ?'  + sep);
      end;
      code.Add(')');
      Result := code.Text;
   finally
      code.Free;
   end;
end;

function TableUpdate(const ATableName: string; AFields:  TStringList): string;
var
  i: integer;
  code:  TStringList;
  sep : string;
begin
   code :=  TStringList.Create;
   try
      code.Add('update ' + ATableName);
      for i:= 0 to AFields.Count - 1 do
      begin
        if (i <  (AFields.Count  - 1)) then
          sep := ' ,'
        else
          sep := '';

        if i = 0 then
          code.Add('set ' + AFields.Strings[i] + ' = ?' + sep)
        else
          code.Add('    ' + AFields.Strings[i] + ' = ?' + sep)
      end;
      code.Add('where');
      code.Add('<primary key> = ?');
      Result := code.Text;
   finally
      code.Free;
   end;
end;

end.

