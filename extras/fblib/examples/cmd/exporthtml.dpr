{$I examples.inc}

program exporthtml;

uses
  SysUtils, Classes, FBLDatabase,FBLTransaction,FBLDsql,FBLExcept,FBLHtmlExport;
  
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
 MyExp: TFBLHtmlExport;
 HtmlOut: TFileStream;
 DataBaseFile: string;
begin
  MyDb := TFBLDatabase.Create(nil);
  MyTr := TFBLTransaction.Create(nil);
  MyDsql := TFBLdsql.Create(nil);
  HtmlOut := TFileStream.Create('juventus.html',fmCreate);
  {$IFDEF UNIX}
    DatabaseFile := DBFolder + '/juventus.fdb';
  {$ELSE}
    DatabaseFile := GetCurrentDir + '\juventus.fdb';
  {$ENDIF}
  try
   MyTr.Database := MyDb;
   MyDsql.Transaction := MyTr;
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
     MyTr.StartTransaction;
     MyDsql.SQL.Text := 'SELECT * FROM PLAYERS';
     MyDsql.ExecSQL;
     MyExp := TFBLHtmlExport.Create(MyDsql);
     MyExp.HtmlPageType := hptComplete;
     MyExp.TagTableOption := 'border="1"';
     MyExp.BeginFetch;
     MyExp.HtmlHeader.SaveToStream(HtmlOut);
     try
       while not MyExp.EOF do
       begin
         MyExp.HtmlCurrentRecord.SaveToStream(HtmlOut);
         MyExp.NextRecord;
       end;
       MyExp.HtmlFooter.SaveToStream(HtmlOut);
     finally
       MyExp.Free;
     end;
     WriteLn('File "juventus.html" created');
     MyDSql.Close;
    except
    on E:EFBLError do
      begin
        WriteLn('ISC_ERROR :' + IntToStr(E.ISC_ErrorCode));
        WriteLn(E.Message);
      end;
    end;
  finally
   HtmlOut.Free;
   MyDsql.Free;
   MyTr.Free;
   MyDb.Free;
  end;
end.
