{$I examples.inc}

program createtable;

uses
  SysUtils, FBLDatabase, FBLTransaction ,FBLDsql, FBLExcept;

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
  MyDb := TFBLDatabase.Create(nil);
  MyTr := TFBLTransaction.Create(nil);
  MyDsql := TFBLDsql.Create(nil);
  {$IFDEF UNIX}
    DatabaseFile := DBFolder + '/juventus.fdb';
  {$ELSE}
    DatabaseFile := GetCurrentDir + '\juventus.fdb';
  {$ENDIF}
  try
    MyTr.Database := MyDb;
    MyDsql.Transaction := MyTr;
    try
      MyDb.DBFile := DatabaseFile;
      MyDb.User := 'sysdba';
      MyDb.Password := 'masterkey';
      {$IFDEF UNIX}
      // under linux and firebird 1.5 
      MyDb.Protocol := ptTcpIp;
      MyDb.Host := '127.0.0.1';
      {$ENDIF}
      MyDb.Connect;
      WriteLn('Database Connect Ok');
      WriteLn('Database server version :' + MyDb.Version);
      WriteLn('Database client version :' + Mydb.ClientVersion);
      MyTr.StartTransaction;
      WriteLn('Start Transaction');
      MyDsql.SQL.Text := 'Create Table PLAYERS (PLAYER_ID INTEGER NOT NULL, ' +
                         'NAME VARCHAR(25) NOT NULL, ' +
                         'NUMBER INTEGER, ' +
                         'constraint PK_PLAYERS primary key(PLAYER_ID))';
      MyDsql.ExecSQL;
      WriteLn('Table "PLAYERS" Created');
      MyTr.Commit;
      WriteLn('Commit Transaction');
      MyDb.Disconnect;
      WriteLn('Datatabase Disconnect');
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

