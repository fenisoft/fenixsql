{$I examples.inc}


program createdb;

uses
  SysUtils,
  FBLDatabase, FBLExcept,ibase_h;
  
{$IFDEF UNIX}
//with firebird 1.5 under linux/unix 
//this folder must have the permissions in reading and writing for "firebird" user
const
 DBFolder = '/fire-data';
{$ENDIF}

var
  MyDb: TFBLDatabase;
  DatabaseFile: string;
begin
  MyDb := TFBLDatabase.Create(nil);
  {$IFDEF UNIX}
    DatabaseFile :=  DBFolder + '/juventus.fdb';
  {$ELSE}
    DatabaseFile := GetCurrentDir + '\juventus.fdb';
  {$ENDIF}
  try
    try
      MyDb.CreateDatabase(DatabaseFile,'sysdba','masterkey',3);
      WriteLn('Database: ' + QuotedStr(DatabaseFile) + ' Created');
    except
      on E:EFBLError do
        begin
          WriteLn('ISC_ERROR :' + IntToStr(E.ISC_ErrorCode));
          WriteLn(E.Message);
        end;
    end;
  finally
    MyDb.Free
  end;
end.
