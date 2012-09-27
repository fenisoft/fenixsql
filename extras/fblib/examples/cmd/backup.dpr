{$I examples.inc}

program backup;

uses
  SysUtils,FBLService,FBLExcept;

{$IFDEF UNIX}
const
 //with firebird 1.5 under linux/unix 
 //this folder must have the permissions in reading and writing for "firebird" user
 DBFolder = '/fire-data';  
{$ENDIF}


type
  TPrintOut = class
  public
     procedure PrintLine(Sender: TObject; Line: string;IscAction: Integer);
  end;

procedure TPrintOut.PrintLine(Sender: TObject; Line: string;IscAction: Integer);
begin
 WriteLn(Trim(Line));
end;

var
 FBService: TFBLService;
 P: TPrintOut;
 DatabaseFile,BackupFile: string;
begin
  FBService := TFBLService.Create(nil);
  P := TPrintOut.Create;
  {$IFDEF FPC}
  FBService.OnWriteOutput := @P.PrintLine;
  {$ELSE}
  FBService.OnWriteOutput := P.PrintLine;
  {$ENDIF}
  {$IFDEF UNIX}
    DatabaseFile := DBFolder + '/juventus.fdb';
    BackupFile := DBFolder + '/juventus.gbk';
  {$ELSE}
    DatabaseFile := GetCurrentDir + '\juventus.fdb';
    BackupFile := GetCurrentDir + '\juventus.gbk';
  {$ENDIF}
  try
    FBService.User := 'sysdba';
    FBService.Password := 'masterkey';
    {$IFDEF UNIX}
    // under linux and firebird 1.5 
    FBService.Protocol := ptTcpIp;
    FBService.Host := '127.0.0.1';
    {$ENDIF}
    try
      FBService.Connect;
      FBService.Backup(DatabaseFile,BackupFile,[bkpVerbose]);
      FBService.Disconnect;
    except
      on E:EFBLError do
         WriteLn(E.Message);
    end;
  finally
   FBService.OnWriteOutput := nil;
   FBService.Free;
   P.Free;
  end;
end.
