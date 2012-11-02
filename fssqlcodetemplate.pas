unit fssqlcodetemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function TableCreate(const AName: string): string;
function TableCreateWithAutoIncrement(AName: string; APk: string = 'ID'): string;


implementation


function TableCreate(const AName: string): string;
var
  code: TStringList;
begin
  code := TStringList.Create;
  try
    with code do
    begin
      Add('CREATE TABLE ' + AName);
      Add('(');
      Add('  column_name {< datatype> | COMPUTED BY (< expr>) | domain}');
      Add('    [DEFAULT { literal | NULL | USER}] [NOT NULL]');
      Add('  ...');
      Add('  CONSTRAINT constraint_name');
      Add('        PRIMARY KEY (column_list),');
      Add('        UNIQUE      (column_list),');
      Add('        FOREIGN KEY (column_list) REFERENCES other_table (column_list),');
      Add('        CHECK       (condition),');
      Add('  ...');
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

end.

