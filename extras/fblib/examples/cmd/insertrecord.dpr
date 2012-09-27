{$I examples.inc}


program insertrecord;


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
  NumberOfRecord: Integer;
  DatabaseFile: string;
begin
  MyDb := TFBLDatabase.Create(nil);
  MyTr := TFBLTransaction.Create(nil);
  MyDsql := TFBLDsql.Create(nil);
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
      MyDsql.SQL.Text := 'insert into PLAYERS (PLAYER_ID,NAME,NUMBER) values (?,?,?)';
      MyDsql.Prepare;               // prepare dsql
      WriteLn('Statement Prepared');
      //insert with Params
      WriteLn('Number of params : ' + IntToStr(MyDsql.ParamCount));
      MyDsql.ParamAsLong(0,1);
      MyDsql.ParamAsString(1,'Alessandro Del Piero');
      MyDsql.ParamAsLong(2,10);
      MyDsql.ExecSQL;
      Inc(NumberOfRecord);
      MyDsql.ParamAsLong(0,2);
      MyDsql.ParamAsString(1,'Pavel Nedved');
      MyDsql.ParamAsLong(2,11);
      MyDsql.ExecSQL;
      Inc(NumberOfRecord);
      MyDsql.ParamAsLong(0,3);
      MyDsql.ParamAsString(1,'Gian Luigi Buffon');
      MyDsql.ParamAsLong(2,1);
      MyDsql.ExecSQL;
      Inc(NumberOfRecord);
      MyDsql.ParamAsLong(0,4);
      MyDsql.ParamAsString(1,'Alessandro Birindelli');
      MyDsql.ParamAsLong(2,2);
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

