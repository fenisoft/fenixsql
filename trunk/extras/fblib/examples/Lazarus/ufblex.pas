unit ufblex;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, ActnList, FBLDatabase, FBLTransaction, FBLDsql, FBLMetadata,
  FBLService, FBLEvents, FBLExcept, FBLTextGridExport, Buttons, FBLDataset;

type

  { TfrmFblex }

  TfrmFblex = class(TForm)
    aBackup: TAction;
    aCommit: TAction;
    aConnect: TAction;
    aCreateDb: TAction;
    ActionList1: TActionList;
    aDelete: TAction;
    aDisconnect: TAction;
    aInsertRecord: TAction;
    aMetadata: TAction;
    aRollback: TAction;
    aSelect: TAction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    fbdb: TFBLDatabase;
    fbevt: TFBLEvent;
    fbmd: TFBLMetadata;
    fbsql: TFBLDsql;
    fbsrv: TFBLService;
    fbtr: TFBLTransaction;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mMsg: TMemo;
    Panel1: TPanel;
    procedure aBackupExecute(Sender: TObject);
    procedure aCommitExecute(Sender: TObject);
    procedure aConnectExecute(Sender: TObject);
    procedure aCreateDbExecute(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure aDisconnectExecute(Sender: TObject);
    procedure aInsertExecute(Sender: TObject);
    procedure aMetadataExecute(Sender: TObject);
    procedure aRollbackExecute(Sender: TObject);
    procedure aSelectExecute(Sender: TObject);
    procedure fbdbConnect(Sender: TObject);
    procedure fbdbDisconnect(Sender: TObject);
    procedure fbevtPostEvent(Sender: TObject; EventName: string;
      EventCount: integer);
    procedure fbsrvWriteOutput(Sender: TObject; TextLine: string;
      IscAction: integer);
    procedure fbtrEndTransaction(Sender: TObject; trAction: TTRAction);
    procedure fbtrStartTransaction(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
  private
    { private declarations }
    FUser, FPassword: string;
    function GetDatabaseFile: string;
    function GetbackupFile: string;
  public
    { public declarations }
  end; 

var
  frmFblex: TfrmFblex;
  
const
  DB_FILE = 'test.fdb';
  BK_FILE = 'test.fbk';
  {$IFDEF UNIX}
  FIREBIRD_DATA_PATH = '/fire-data/';
  {$ENDIF}

implementation

uses
   udblogin;

{ TfrmFblex }

procedure TfrmFblex.aCreateDbExecute(Sender: TObject);
begin
  if udblogin.DBlogin(FUser,FPassword) then
    try
      fbdb.CreateDatabase(GetDatabaseFile,FUser,FPassword);
      fbdb.DBFile := GetDatabaseFile;
      fbdb.User :=  FUser;
      fbdb.Password := FPassword;
      fbdb.Connect;
      if not fbtr.InTransaction then
        fbtr.StartTransaction;
      //create table
      fbsql.SQL.Text := 'CREATE TABLE TEST (IDX INTEGER NOT NULL,' +
        'DATE_NOW TIMESTAMP)';
      fbsql.ExecSQL;
      //primary key
      fbsql.SQL.Text := 'ALTER TABLE TEST ADD CONSTRAINT ' +
        'PK_IDX PRIMARY KEY (IDX)';
      fbsql.ExecSQL;
      //generator
      fbsql.SQL.Text := 'CREATE GENERATOR GEN_TEST';
      fbsql.ExecSQL;
      //trigger for generator
      fbsql.SQL.Clear;
      fbsql.SQL.Add('CREATE TRIGGER TEST_BI FOR TEST');
      fbsql.SQL.Add('ACTIVE BEFORE INSERT');
      fbsql.SQL.Add('POSITION  0');
      fbsql.SQL.Add('as');
      fbsql.SQL.Add('begin');
      fbsql.SQL.Add('if (NEW.IDX IS NULL) THEN');
      fbsql.SQL.Add('   NEW.IDX=GEN_ID(GEN_TEST,1);');
      fbsql.SQL.Add('end');
      fbsql.ExecSQL;
      // trigger insert for test event
      fbsql.SQL.Clear;
      fbsql.SQL.Add('CREATE TRIGGER TEST_AI FOR TEST');
      fbsql.SQL.Add('ACTIVE AFTER INSERT');
      fbsql.SQL.Add('POSITION  0');
      fbsql.SQL.Add('as');
      fbsql.SQL.Add('begin');
      fbsql.SQL.Add('POST_EVENT ''AFTER_INSERT'';');
      fbsql.SQL.Add('end');
      fbsql.ExecSQL;
      // trigger  delete for test event
       fbsql.SQL.Clear;
      fbsql.SQL.Add('CREATE TRIGGER TEST_AD FOR TEST');
      fbsql.SQL.Add('ACTIVE AFTER DELETE');
      fbsql.SQL.Add('POSITION  0');
      fbsql.SQL.Add('as');
      fbsql.SQL.Add('begin');
      fbsql.SQL.Add('POST_EVENT ''AFTER_DELETE'';');
      fbsql.SQL.Add('end');
      fbsql.ExecSQL;
      //commit
      fbtr.Commit;
      fbdb.Disconnect;
      mMsg.Lines.Add('Database : "' + GetDatabaseFile +  '" Created');
    except
       on  E: EFBLError do
         mMsg.Lines.Add(E.Message);
    end;
end;

procedure TfrmFblex.aDeleteExecute(Sender: TObject);
begin
  if not fbtr.InTransaction then
    fbtr.StartTransaction;
  try
    fbsql.SQL.Text := 'delete from test';
    fbsql.ExecSQL;
    mMsg.Lines.Add(Format('%d : record deleted', [fbsql.RowsAffected]));
    fbsql.UnPrepare;
  except on E:EFBLerror do
    begin
     mMsg.Lines.Add('');
     mMsg.Lines.Add(E.message);
    end;
  end;
end;

procedure TfrmFblex.aDisconnectExecute(Sender: TObject);
begin
  if fbdb.Connected then
  begin
    fbdb.Disconnect;
  end;
end;

procedure TfrmFblex.aInsertExecute(Sender: TObject);
begin
  if not fbtr.InTransaction then
    fbtr.StartTransaction;
  fbsql.SQL.Text := 'insert into test (DATE_NOW) values(?)';
  fbsql.Prepare;
  fbsql.ParamAsDateTime(0,now);
  fbsql.ExecSQL;
  mMsg.Lines.Add('insert');
end;

procedure TfrmFblex.aMetadataExecute(Sender: TObject);
begin
  mMsg.Clear;
  mMsg.Lines.Add(fbmd.Metadata.Text);
end;

procedure TfrmFblex.aRollbackExecute(Sender: TObject);
begin
  fbtr.RollBack;
end;

procedure TfrmFblex.aSelectExecute(Sender: TObject);
begin
  if not fbtr.InTransaction then fbtr.StartTransaction;
  fbsql.SQL.Text  := 'select * from test';
  fbsql.ExecSQL;
  mMsg.Lines.Add('Select');
  TextGrid(fbsql,mMsg.Lines);
  mMsg.Lines.Add(Format('%d: record fetched',[fbsql.FetchCount]));
  fbsql.UnPrepare;
end;

procedure TfrmFblex.fbdbConnect(Sender: TObject);
begin
  aConnect.Enabled := False;
  aDisconnect.Enabled := True;
  aInsertRecord.Enabled := True;
  aMetadata.Enabled := True;
  aDelete.Enabled := True;
  aSelect.Enabled := True;
  mMsg.Lines.Add('database connected') ;
  mMsg.Lines.Add(Format('server version : %s', [fbdb.Version]))
end;

procedure TfrmFblex.fbdbDisconnect(Sender: TObject);
begin
  aConnect.Enabled := True;
  aDisconnect.Enabled := False;
  aInsertRecord.Enabled := False;
  aMetadata.Enabled := False;
  aDelete.Enabled := False;
  aSelect.Enabled := False;
  mMsg.Lines.Add('database disconnected') ;
end;

procedure TfrmFblex.fbevtPostEvent(Sender: TObject; EventName: string;
  EventCount: integer);
begin
  mMsg.Lines.Add(Format('event fired: EventName = %s EventCount = %d',[EventName,EventCount]));
end;

procedure TfrmFblex.fbsrvWriteOutput(Sender: TObject; TextLine: string;
  IscAction: integer);
begin
  mMsg.Lines.Add(TextLine);
end;

procedure TfrmFblex.fbtrEndTransaction(Sender: TObject; trAction: TTRAction);
begin
  if trAction = TARollback then
     mMsg.Lines.Add('transaction rolled back')
   else
     mMsg.Lines.Add('transaction commited');
   aCommit.Enabled := False;
   aRollBack.Enabled := False
end;

procedure TfrmFblex.fbtrStartTransaction(Sender: TObject);
begin
  mMsg.Lines.Add('Start transaction');
  aCommit.Enabled := True;
  aRollBack.Enabled := True
end;

procedure TfrmFblex.FormCreate(Sender: TObject);
begin
  FUser := 'sysdba';
  FPassword := 'masterkey';
end;

procedure TfrmFblex.MenuItem7Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmFblex.aConnectExecute(Sender: TObject);
begin
  if udblogin.DBlogin(FUser,FPassword) then
   begin
     try
         fbdb.DBFile := GetDatabaseFile;
         fbdb.User := FUser;
         fbdb.Password := FPassword;
         fbdb.Connect;
         {$IFNDEF UNIX}
         fbevt.Start;
         mMsg.Lines.Add('event listen started') ;
         {$ENDIF}
     except
        on  E:EFBLError do
          mMsg.Lines.Add(E.Message);
     end;
   end;
end;

procedure TfrmFblex.aCommitExecute(Sender: TObject);
begin
  fbtr.Commit;
end;

procedure TfrmFblex.aBackupExecute(Sender: TObject);
begin
   if not fbdb.Connected then
    if not udblogin.DBlogin(FUser,FPassword) then Exit;
   fbsrv.User := Fuser;
   fbsrv.Password := FPassword;
   try
      fbsrv.Connect;
      fbsrv.Backup(GetDatabasefile,GetBackupFile,[bkpVerbose]);
      fbsrv.Disconnect;
   except
      on E:EFBLError do
      begin
        ShowMessage(e.Message);
        if fbsrv.Connected then fbsrv.Disconnect;
      end;
    end;
end;

function  TfrmFblex.GetDatabaseFile:string;
begin
  {$IFNDEF UNIX}
  result := ExtractFilePath(Application.ExeName) + DB_FILE;
  {$ELSE}
  result := FIREBIRD_DATA_PATH + DB_FILE;
  {$ENDIF}
end;

function  TfrmFblex.GetbackupFile: string;
begin
  {$IFNDEF UNIX}
  result := ExtractFilePath(Application.ExeName) + BK_FILE;
  {$ELSE}
  result := FIREBIRD_DATA_PATH + BK_FILE;
  {$ENDIF}
end;

initialization
  {$I ufblex.lrs}

end.

