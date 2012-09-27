unit FblClientDataset;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, DB, DBClient, Provider,
  FBlDatabase,FBLDataset,FBLTransaction, DBLogDlg ;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    mSql: TMemo;
    Panel2: TPanel;
    Splitter1: TSplitter;
    edDatabase: TEdit;
    btnConnect: TBitBtn;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    btnExecute: TBitBtn;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
    fbdb: TFBLDatabase;
    fbtr: TFBLTransaction;
    fbds: TFBLDataset;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnConnectClick(Sender: TObject);
var
   user,password: string;
begin
  user := 'sysdba';
  password := '';
  if not fbdb.Connected then
    if not LoginDialog(edDatabase.Text,user,password) then Exit;

  fbdb.DBFile := edDatabase.Text;
  fbdb.User := user;
  fbdb.Password := password;
  fbdb.Connected := not fbdb.Connected;
  if fbdb.Connected then
   btnConnect.Caption := 'Disconnect'
  else
  begin
   btnConnect.Caption := 'Connect';
   if ClientDataSet1.Active then  ClientDataSet1.Close;
  end;
  
end;

procedure TForm1.btnExecuteClick(Sender: TObject);
begin
   fbds.SQL.Assign(mSql.Lines);
   fbds.Active := True;
   if ClientDataSet1.Active then  ClientDataSet1.Close;
   ClientDataSet1.Open;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   fbdb := TFBLDatabase.Create(self);
   fbtr := TFblTRansaction.Create(self);
   fbtr.Database := fbdb;
   fbds := TFBLDataset.Create(self);
   fbds.Transaction := fbtr;
   fbds.AutoStartTransaction := True;
   DataSetProvider1.DataSet := fbds;
   edDatabase.Text :=  'C:\PROGRAMMI\FIREBIRD\FIREBIRD_2_0\EXAMPLES\EMPBUILD\EMPLOYEE.FDB';
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edDatabase.Text := OpenDialog1.FileName;
end;

end.
