{$I examples.inc}

{insert record with params}
program insertrecord2;


uses
  SysUtils, FBLDatabase, FBLTransaction ,FBLParamDsql, FBLExcept;

{$IFDEF UNIX}
const
 //with firebird 1.5 under linux/unix 
 //this folder must have the permissions in reading and writing for "firebird" user
 DBFolder = '/fire-data';  
{$ENDIF}


var
  MyDb: TFBLDatabase;
  MyTr: TFBLTransaction;
  MyDsql: TFBLParamDsql;
  NumberOfRecord: Integer;
  DatabaseFile: string;
begin
  MyDb := TFBLDatabase.Create(nil);
  MyTr := TFBLTransaction.Create(nil);
  MyDsql := TFBLParamDsql.Create(nil);
  NumberOfRecord := 0;
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
      myDb.Host := '127.0.0.1';
      {$ENDIF}
      MyDb.Connect;
      WriteLn('Database Connect Ok');
      WriteLn('Database Version :' + MyDb.Version);
      MyTr.StartTransaction;          
      WriteLn('Start Transaction');
      MyDsql.SQL.Text := 'insert into PLAYERS (PLAYER_ID,NAME,NUMBER) values (:player_id,:name,:number)';
      MyDsql.Prepare;               // prepare dsql
      WriteLn('Statement Prepared');
      //insert with ParamsbyName
      WriteLn('Number of params : ' + IntToStr(MyDsql.ParamCount));
      MyDsql.ParamByNameAsLong('player_id',5);
      MyDsql.ParamByNameAsString('name','Fabio Cannavaro');
      MyDsql.ParamByNameAsLong('number',5);
      MyDsql.ExecSQL;
      Inc(NumberOfRecord);
      WriteLn(Format('%d Records Add',[NumberOfRecord]));
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

