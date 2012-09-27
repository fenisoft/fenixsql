{$I examples.inc}

program select2;

uses
  SysUtils, FBLDatabase, FBLTransaction, FBLDsql, FBLExcept;

{$IFDEF UNIX}
const
 //with firebird 1.5 under linux/unix 
 //this folder must have the permissions in reading and writing for "firebird" user
 DBFolder = '/fire-data';  
{$ENDIF}


var
 MyDb: TFBLDatabase;
 MyTr: TFBLTransaction;
 MyDsql: TFBLDsql;
 DatabaseFile: string; 
begin
  MyDb:=TFBLDatabase.Create(nil);
  MyTr:=TFBLTransaction.Create(nil);
  MyDsql:=TFBLdsql.Create(nil);
  {$IFDEF UNIX}
    DatabaseFile := DBFolder + '/juventus.fdb';
  {$ELSE}
    DatabaseFile := GetCurrentDir + '\juventus.fdb';
  {$ENDIF}
  try
   MyTr.Database:=MyDb;
   MyDsql.Transaction:=MyTr;
   MyDb.DBFile := DatabaseFile;
   MyDb.User := 'sysdba';
   MyDb.Password:='masterkey';
   {$IFDEF UNIX}
   // under linux and firebird 1.5 
   MyDb.Protocol := ptTcpIp;
   MyDb.Host := '127.0.0.1';
   {$ENDIF}
   try
     Mydb.Connect;
     MyTr.StartTransaction;
     MyDsql.SQL.Text := 'SELECT * FROM PLAYERS';
     MyDsql.ExecSQL;
     while not MyDsql.EOF do
     begin
       WriteLn(Format('%-11s:%s',[MyDsql.FieldName(0),MyDSql.FieldAsString(0)]));
       WriteLn(Format('%-11s:%s',[MyDsql.FieldName(1),MyDSql.FieldByNameAsString('Name')]));
       WriteLn(Format('%-11s:%s',[MyDsql.FieldName(2),MyDSql.FieldByNameAsString('Number')]));
       WriteLn(' ');
       MyDsql.Next;
     end;
     MyDSql.Close;
    except
    on E:EFBLError do
      begin
        WriteLn('ISC_ERROR :' + IntToStr(E.ISC_ErrorCode));
        WriteLn(E.Message);
      end;
    end;
  finally
   MyDsql.Free;
   MyTr.Free;
   MyDb.Free;
  end;
end.
