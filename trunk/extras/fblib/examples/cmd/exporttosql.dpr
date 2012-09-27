{$I examples.inc}

program exporttosql;

uses
  SysUtils, Classes, FBLDatabase,FBLExcept,FBLTableToSqlScriptExport;

{$IFDEF UNIX}
const
 //with firebird 1.5 under linux/unix 
 //this folder must have the permissions in reading and writing for "firebird" user
 DBFolder = '/fire-data';  
{$ENDIF}

var
 MyDb: TFBLDatabase;
 MyExp: TFBLTableToSqlScriptExport;
 SqlOut : TFileStream;
 SqlLine: string;
 DataBaseFile: string; 
begin
  MyDb:=TFBLDatabase.Create(nil);
  SqlOut := TFileStream.Create('players.sql',fmCreate);
  {$IFDEF UNIX}
    DatabaseFile := DBFolder + '/juventus.fdb';
  {$ELSE}
    DatabaseFile := GetCurrentDir + '\juventus.fdb';
  {$ENDIF}
  try
   MyDb.DBFile := DataBaseFile;
   MyDb.User:='sysdba';
   MyDb.Password:='masterkey';
   {$IFDEF UNIX}
   // under linux and firebird 1.5 
   MyDb.Protocol := ptTcpIp;
   MyDb.Host := '127.0.0.1';
   {$ENDIF}
   try
     Mydb.Connect;
     MyExp := TFBLTableToSqlScriptExport.Create(MyDb,'PLAYERS');
     try
       while not MyExp.EOF do
       begin
         MyExp.NextLine;
         {$IFDEF UNIX}
         SqlLine := MyExp.CurrentLine + #10;
         {$ELSE}
         SqlLine := MyExp.CurrentLine + #13 + #10;
         {$ENDIF}
         SqlOut.Write(SqlLine[1],Length(SqlLine));
       end;
     finally
       MyExp.Free;
     end;
    WriteLn('File "players.sql" created'); 
    except
    on E:EFBLError do
      begin
        WriteLn('ISC_ERROR :' + IntToStr(E.ISC_ErrorCode));
        WriteLn(E.Message);
      end;
    end;
  finally
   SqlOut.Free;
   MyDb.Free;
  end;
end.
