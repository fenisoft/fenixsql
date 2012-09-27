{$I examples.inc}

program testsimple;

uses
  SysUtils, FBLSimple;

var
 fbdb: TFBLSimple;
 conn,user,passwd: string;  //connection string 

{$IFDEF UNIX}
const
 //with firebird 1.5 under linux/unix 
 //this folder must have the permissions in reading and writing for "firebird" user
 DBFolder = '/fire-data';  
{$ENDIF}


begin
  {$IFDEF UNIX}
     conn := 'localhost:' + DBFolder + '/juventus.fdb';
  {$ELSE}
     conn := 'localhost:' + GetCurrentDir + '\juventus.fdb';
  {$ENDIF}
  user := 'sysdba';
  passwd := 'masterkey';
  fbdb := TFBLSimple.Create(conn,user,passwd);
  try
    try
      fbdb.Connect;
      fbdb.StartTransaction;  
      fbdb.SQL.Text := 'SELECT * FROM PLAYERS';
      fbdb.ExecSQL;
      while not fbdb.Eof do
      begin
        WriteLn(Format('player_id: %d',[fbdb.FieldbyNameAsInteger('player_id')]));
        WriteLn(Format('name: %s',[fbdb.FieldbyNameAsString('name')]));
        WriteLn(Format('number: %d',[fbdb.FieldbyNameAsInteger('number')]));
        WriteLn('');     
        fbdb.Next;
      end;
      fbdb.Close;
      fbdb.Commit;
      fbdb.Disconnect;
    except
      on E:Exception do
        WriteLn(E.Message);
    end;
  finally
    fbdb.Free; 
  end;
end.
