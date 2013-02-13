unit fssqlcodetemplate;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function TableCreate(const AName: string;const APk: string = ''): string;
function TableCreateWithAutoIncrement(AName: string; APk: string = 'ID'): string;
function TableInsert(const ATableName: string): string;



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

function TableInsert(const ATableName: string): string;
var
  i: integer;
  code:  TStringList;
  sep : string;
begin
   code :=  TStringList.Create;
   try
      if not MainDataModule.BrowserTr.InTransaction then
        MainDataModule.BrowserTr.StartTransaction;
      MainDataModule.BrowserQry.SQL.Text := 'select * from ' +   ATableName;
      MainDataModule.BrowserQry.Prepare;
      code.Add('insert into ' + ATableName);
      code.Add('(');
      for i:= 0 to  MainDataModule.BrowserQry.FieldCount - 1 do
      begin
        if (i <  (MainDataModule.BrowserQry.FieldCount - 1)) then
          sep := ' ,'
        else
          sep := '';
        code.Add('  ' + MainDataModule.BrowserQry.FieldName(i) + sep);
      end;
      code.Add(')');
      code.Add('values');
      code.Add('(');
      for i:= 0 to  MainDataModule.BrowserQry.FieldCount - 1 do
      begin
        if (i <  (MainDataModule.BrowserQry.FieldCount - 1)) then
          sep := ' ,'
        else
          sep := '';
        code.Add('  ?'  + sep);
      end;
      code.Add(')');
      MainDataModule.BrowserQry.UnPrepare;
      Result := code.Text;
   finally
      code.Free;
   end;


end;

end.

