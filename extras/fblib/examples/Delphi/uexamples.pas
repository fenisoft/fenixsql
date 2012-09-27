unit uexamples;
{$DEFINE WEVENT}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FBLDatabase,FBLTransaction,FBLDsql,FBLExcept,
  FBLMetadata, FBLEvents, ActnList, ComCtrls, ExtCtrls, FBLService, Buttons,
  Menus,FBLTextGridExport;

type
  TfrmFblEx = class(TForm)
    ActionList1: TActionList;
    aConnect: TAction;
    StatusBar1: TStatusBar;
    aCreateDb: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    mMsg: TMemo;
    aInsertRecord: TAction;
    aCommit: TAction;
    aRollback: TAction;
    aDisconnect: TAction;
    aMetadata: TAction;
    aBackup: TAction;
    aDelete: TAction;
    MainMenu1: TMainMenu;
    Database1: TMenuItem;
    CreateDatabase1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    CreateDatabase2: TMenuItem;
    N3: TMenuItem;
    Exit1: TMenuItem;
    Sql1: TMenuItem;
    Insertrecord1: TMenuItem;
    Delete1: TMenuItem;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Action1: TMenuItem;
    exctractMetadata1: TMenuItem;
    Backup1: TMenuItem;
    aSelect: TAction;
    aSelect1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure aConnectExecute(Sender: TObject);
    procedure aCreateDbExecute(Sender: TObject);
    procedure aInsertRecordExecute(Sender: TObject);
    procedure aCommitExecute(Sender: TObject);
    procedure aRollbackExecute(Sender: TObject);
    procedure aDisconnectExecute(Sender: TObject);
    procedure aMetadataExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure aBackupExecute(Sender: TObject);
    procedure aDeleteExecute(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure aSelectExecute(Sender: TObject);
  private
    { Private declarations }
    FUser,FPassword: string;
    fbdb: TFBLDatabase;
    fbtr: TFBLTransaction;
    fbsql: TFBLDsql;
    fbsrv: TFBLService;
    fbmd: TFBLMetadata;
    {$IFDEF WEVENT}
    fbevt: TFBLEvent;
    {$ENDIF}
    function GetDatabaseFile: string;
    function  GetbackupFile: string;
    procedure fbtrStartTransaction(Sender: TObject);
    procedure fbtrEndTransaction(Sender: TObject; trAction: TTRAction);
    procedure fbdbConnect(Sender:  TObject);
    procedure fbdbDisconnect(Sender: TObject);
    procedure fbsrvWriteOutput(Sender: TObject; TextLine: string; IscAction: integer);
     {$IFDEF WEVENT}
    procedure fbevtPostEvent(Sender: TObject; EventName: string; EventCount: integer);
    {$ENDIF}
  public
    { Public declarations }
  end;

var
  frmFblEx: TfrmFblEx;

const
  DB_FILE = 'test.fdb';
  BK_FILE = 'test.fbk';

implementation

uses udblogin;

{$R *.dfm}

procedure TfrmFblEx.aBackupExecute(Sender: TObject);
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

procedure TfrmFblEx.aCommitExecute(Sender: TObject);
begin
  fbtr.Commit;
end;

procedure TfrmFblEx.aConnectExecute(Sender: TObject);
begin
   if udblogin.DBlogin(FUser,FPassword) then
   begin
     try
         fbdb.DBFile := GetDatabaseFile;
         fbdb.User := FUser;
         fbdb.Password := FPassword;
         fbdb.Connect;
         {$IFDEF WEVENT}
         fbevt.Start;
         mMsg.Lines.Add('event listen started') ;
         {$endif}
     except
        on  E:EFBLError do
          mMsg.Lines.Add(E.Message);

     end;
   end;
end;

procedure TfrmFblEx.aCreateDbExecute(Sender: TObject);
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
       on  E:EFBLError do
         mMsg.Lines.Add(E.Message);
    end;
end;


procedure TfrmFblEx.aDeleteExecute(Sender: TObject);
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

procedure TfrmFblEx.aDisconnectExecute(Sender: TObject);
begin
  if fbdb.Connected then
  begin
    fbdb.Disconnect;
  end;  
end;

procedure TfrmFblEx.aInsertRecordExecute(Sender: TObject);
begin
 if not fbtr.InTransaction then
    fbtr.StartTransaction;
 fbsql.SQL.Text := 'insert into test (DATE_NOW) values(?)';
 fbsql.Prepare;
 fbsql.ParamAsDateTime(0,now);
 fbsql.ExecSQL;
 mMsg.Lines.Add('insert');
end;

procedure TfrmFblEx.aMetadataExecute(Sender: TObject);
begin
  mMsg.Clear;
  mMsg.Lines.Add(fbmd.Metadata.Text);
end;

procedure TfrmFblEx.aRollbackExecute(Sender: TObject);
begin
  fbtr.RollBack;
end;


procedure TfrmFblEx.aSelectExecute(Sender: TObject);
begin
  if not fbtr.InTransaction then fbtr.StartTransaction;
  fbsql.SQL.Text  := 'select * from test';
  fbsql.ExecSQL;
  mMsg.Lines.Add('Select');
  TextGrid(fbsql,mMsg.Lines);
  mMsg.Lines.Add(Format('%d: record fethed',[fbsql.FetchCount]));
  fbsql.UnPrepare;
end;

procedure TfrmFblEx.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //if fbevt.Active  then fbevt.Stop;
end;

procedure TfrmFblEx.FormCreate(Sender: TObject);
begin
  FUser := 'sysdba';
  FPassword := 'masterkey';
  //create fblib objects
  fbdb := TFBLDatabase.Create(self);
  fbtr := TFBLTransaction.Create(self);
  fbsql := TFBLDsql.Create(self);
  fbmd := TFBLMetadata.Create(self);
  fbsrv := TFBLService.Create(self);
  {$IFDEF WEVENT}
  fbevt := TFBLEvent.Create(self);
  {$ENDIF}
  // set properties
  fbtr.Database := fbdb;
  fbsql.Transaction := fbtr;
  fbmd.Database := fbdb;

  {$IFDEF WEVENT}
  fbevt.Database := fbdb;
  fbevt.EventList.Add('AFTER_INSERT');
  fbevt.EventList.Add('AFTER_DELETE');
  //fbevt.EventList.Add('PIPPO');
  fbevt.OnPostEvent := fbevtPostEvent;
  fbsrv.OnWriteOutput := fbsrvWriteOutput;
  {$ENDIF}
  // connect events
  fbdb.OnConnect := fbdbConnect;
  fbdb.OnDisconnect := fbdbDisconnect;
  fbtr.OnStartTransaction := fbtrStartTransaction;
  fbtr.OnEndTransaction :=  fbtrEndTransaction;
end;

procedure TfrmFblEx.FormDestroy(Sender: TObject);
begin
  fbdb.Free;
  fbmd.Free;
  {$IFDEF WEVENT}
  fbevt.Free;
  {$ENDIF}
  fbsql.Free;
  fbtr.Free;
  fbsrv.Free;
end;

function  TfrmFblEx.GetDatabaseFile:string;
begin
   result := ExtractFilePath(Application.ExeName) + DB_FILE;
end;

function  TfrmFblEx.GetbackupFile: string;
begin
   result := ExtractFilePath(Application.ExeName) + BK_FILE;
end;

procedure TfrmFblEx.fbtrStartTransaction(Sender: TObject);
begin
   mMsg.Lines.Add('Start transaction');
   aCommit.Enabled := True;
   aRollBack.Enabled := True
end;


procedure TfrmFblEx.fbtrEndTransaction(Sender: TObject; trAction: TTRAction);
begin
   if trAction = TARollback then
     mMsg.Lines.Add('transaction rolled back')
   else
     mMsg.Lines.Add('transaction commited');
   aCommit.Enabled := False;
   aRollBack.Enabled := False
end;

procedure TfrmFblEx.fbdbConnect(Sender:  TObject);
begin
   aConnect.Enabled := False;
   aDisconnect.Enabled := True;
   aInsertRecord.Enabled := True;
   aMetadata.Enabled := True;
   aDelete.Enabled := True;
   aSelect.Enabled := True;
   mMsg.Lines.Add('database connected') ;
   mMsg.Lines.Add(Format('server version : %s', [fbdb.Version]));

end;

procedure TfrmFblEx.fbdbDisconnect(Sender:  TObject);
begin
   aConnect.Enabled := True;
   aDisconnect.Enabled := False;
   aInsertRecord.Enabled := False;
   aMetadata.Enabled := False;
   aDelete.Enabled := False;
   aSelect.Enabled := False;
   mMsg.Lines.Add('database disconnected') ;
end;

{$IFDEF WEVENT}
procedure TfrmFblEx.fbevtPostEvent(Sender: TObject; EventName: string; EventCount: integer);
begin
   mMsg.Lines.Add(Format('event fired: EventName = %s EventCount = %d',[EventName,EventCount]));
end;
{$ENDIF}

procedure TfrmFblEx.fbsrvWriteOutput(Sender: TObject; TextLine: string; IscAction: integer);
begin
  mMsg.Lines.Add(TextLine);
end;



procedure TfrmFblEx.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.
