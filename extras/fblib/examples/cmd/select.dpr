{$I examples.inc}

program select;

uses
  SysUtils, FBLDatabase,FBLTransaction,FBLDsql,FBLExcept,FBLTextGridExport;

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
 MyExp: TFBLTextGridExport;
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
   MyDb.DBFile:=DatabaseFile;
   MyDb.User:='sysdba';
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
     WriteLn('Database server version :' + MyDb.Version);
     WriteLn('Database client version :' + Mydb.ClientVersion);
     MyExp := TFBLTextGridExport.Create(MyDsql);
     try
       while not MyExp.EOF do
       begin
         MyExp.NextLine;
         WriteLn(MyExp.CurrentLine);
       end;
     finally
       MyExp.Free;
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
