(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsdbconnections.pas

  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.

*)


unit fsdbconnections;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Controls, Dialogs,
  StdCtrls, Buttons, EditBtn, Spin, IniFiles, FBLDatabase, FBLExcept;

type

  { TDbConnectionsForm }

  TDbConnectionsForm = class(TForm)
    TestButton: TBitBtn;
    ConnectButton: TBitBtn;
    CancelButton: TBitBtn;
    SaveAliasButton: TButton;
    DeleteAliasButton: TButton;
    savePasswordCheckBox: TCheckBox;
    AliasCombo: TComboBox;
    ProtocolCombo: TComboBox;
    CharSetCombo: TComboBox;
    HostEdit: TEdit;
    UserEdit: TEdit;
    PasswordEdit: TEdit;
    RoleEdit: TEdit;
    DatabaseEdit: TEditButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblDialect: TLabel;
    Label9: TLabel;
    odDBFile: TOpenDialog;
    PortSpinEdit: TSpinEdit;
    DialectSpinEdit: TSpinEdit;
    procedure ConnectButtonClick(Sender: TObject);
    procedure DeleteAliasButtonClick(Sender: TObject);
    procedure SaveAliasButtonClick(Sender: TObject);
    procedure TestButtonClick(Sender: TObject);
    procedure AliasComboSelect(Sender: TObject);
    procedure ProtocolComboSelect(Sender: TObject);
    procedure DatabaseEditButtonClick(Sender: TObject);
    procedure edDatabaseChange(Sender: TObject);
    procedure PasswordEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    FAlias: string;
    procedure LoadAliasName(const AAlias: string);
    procedure SaveAliasName(const AAlias: string);
    function DeleteAlias(const AAlias: string): boolean; //True if alias deleted
    function ValidateInputTest: boolean;
    function ValidateInputConn: boolean;
  public
    { public declarations }
    property AliasName: string read FAlias write FAlias;
  end;

  TFsConnectionsParams = record
    AliasName, Host, DBName, User, Password, Role: string;
    CharacterSet: string;
    Protocol, Port, Dialect: word;
  end;

  PFsConnectionsParams = ^TFsConnectionsParams;

const
  PROTOCOL_LOCAL = 0;
  PROTOCOL_TCP_IP = 1;
  PROTOCOL_NETBEUI = 2;

function DbConnection(AParams: PFsConnectionsParams): boolean;

implementation

{$R *.lfm}

uses
  fsconfig;

//------------------------------------------------------------------------------

function DbConnection(AParams: PFsConnectionsParams): boolean;
var
  ConnectionsForm: TDbConnectionsForm;
begin
  Result := False;
  ConnectionsForm := TDbConnectionsForm.Create(nil);
  try
    ConnectionsForm.AliasName := AParams^.AliasName;
    if ConnectionsForm.ShowModal = mrOk then
    begin
      AParams^.AliasName := ConnectionsForm.AliasCombo.Text;
      AParams^.Host := ConnectionsForm.HostEdit.Text;
      AParams^.DBName := ConnectionsForm.DatabaseEdit.Text;
      AParams^.User := ConnectionsForm.UserEdit.Text;
      APArams^.Password := ConnectionsForm.PasswordEdit.Text;
      AParams^.Role := ConnectionsForm.RoleEdit.Text;
      AParams^.Protocol := ConnectionsForm.ProtocolCombo.ItemIndex;
      AParams^.Port := ConnectionsForm.PortSpinEdit.Value;
      AParams^.Dialect := ConnectionsForm.DialectSpinEdit.Value;
      AParams^.CharacterSet := ConnectionsForm.CharSetCombo.Text;
      Result := True;
    end;
  finally
    ConnectionsForm.Free;
  end;
end;

//------------------------------------------------------------------------------

{ TDbConnectionsForm }

procedure TDbConnectionsForm.LoadAliasName(const AAlias: string);
var
  inifile: TIniFile;
  sProtocol: string;
begin
  inifile := TiniFile.Create(GetAliasIniFile);
  try
    if inifile.SectionExists(AAlias) then
    begin
      sProtocol := inifile.ReadString(AAlias, 'Protocol', 'LOCAL');
      if sProtocol = 'LOCAL' then
        ProtocolCombo.ItemIndex := 0
      else if sProtocol = 'TCPIP' then
        ProtocolCombo.ItemIndex := 1
      else if sProtocol = 'NETBEUI' then
        ProtocolCombo.ItemIndex := 2;
      ProtocolComboSelect(nil);
      HostEdit.Text := inifile.ReadString(AAlias, 'Host', '');
      DatabaseEdit.Text := inifile.ReadString(AAlias, 'Database', '');
      RoleEdit.Text := inifile.ReadString(AAlias, 'Role', '');
      UserEdit.Text := inifile.ReadString(AAlias, 'User', 'sysdba');
      PasswordEdit.Text := inifile.ReadString(AAlias, 'Password', '');
      savePasswordCheckBox.Checked  :=   PasswordEdit.Text <> '';
      CharSetCombo.Text := inifile.ReadString(AAlias, 'CharacterSet', 'NONE');
      DialectSpinEdit.Value := inifile.ReadInteger(AAlias, 'Dialect', 3);
      PortSpinEdit.Value := inifile.ReadInteger(AAlias, 'Port', 3050);
    end;
  finally
    inifile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.SaveAliasName(const AAlias: string);
var
  inifile: TIniFile;
begin
  inifile := TiniFile.Create(GetAliasIniFile);
  try
    //if inifile.SectionExists(AAlias) then
    //begin
    //  if MessageDlg('Connection::Alias',
    //    Format('Alias: [%s] exists, overwrite  ?', [AAlias]), mtConfirmation,
    //    [mbYes, mbNo], 0) = mrNo then
    //    Exit;
    //end;

    if ProtocolCombo.ItemIndex = 0 then
      inifile.WriteString(AAlias, 'Protocol', 'LOCAL')
    else if ProtocolCombo.ItemIndex = 1 then
      inifile.WriteString(AAlias, 'Protocol', 'TCPIP')
    else if ProtocolCombo.ItemIndex = 2 then
      inifile.WriteString(AAlias, 'Protocol', 'NETBEUI');
    inifile.WriteString(AAlias, 'Host', HostEdit.Text);
    inifile.WriteString(AAlias, 'Database', DatabaseEdit.Text);
    inifile.WriteString(AAlias, 'User', UserEdit.Text);
    if savePasswordCheckBox.Checked then
       inifile.WriteString(AAlias, 'Password', PasswordEdit.Text)
    else begin
       inifile.WriteString(AAlias, 'Password','');
    end;
    Inifile.WriteString(AAlias, 'CharacterSet', CharSetCombo.Text);
    inifile.WriteInteger(AAlias, 'Dialect', DialectSpinEdit.Value);
    inifile.WriteInteger(AAlias, 'Port', PortSpinEdit.Value);
    inifile.UpdateFile;
  finally
    inifile.Free;
  end;
end;

//------------------------------------------------------------------------------

function TDbConnectionsForm.DeleteAlias(const AAlias: string): boolean;
var
  inifile: TIniFile;
begin
  Result := False;
  inifile := TiniFile.Create(GetAliasIniFile);
  try
    if inifile.SectionExists(AAlias) then
    begin
      Inifile.EraseSection(AAlias);
      inifile.UpdateFile;
      fsconfig.DeleteHistory(AAlias);
      Result := True;
    end;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.FormCreate(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.FormShow(Sender: TObject);
var
  item: integer;
begin
  fsconfig.GetAliasNames(AliasCombo.Items);
  if AliasCombo.Items.Count > 0 then
  begin
    item := AliasCombo.Items.IndexOf(AliasName);
    if item > -1 then
    begin
      AliasCombo.ItemIndex := item;
      LoadAliasName(AliasCombo.Text);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.ProtocolComboSelect(Sender: TObject);
begin
  case ProtocolCombo.ItemIndex of
    PROTOCOL_LOCAL:
    begin
      HostEdit.Enabled := False;
      PortSpinEdit.Enabled := False;
    end;
    else
    begin
      HostEdit.Enabled := True;
      PortSpinEdit.Enabled := True;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.DatabaseEditButtonClick(Sender: TObject);
begin
  with odDBFile do
  begin
    Title := 'Select database file';
    Filter := FileFilterForDialog;
    if Execute then
      DatabaseEdit.Text := FileName;

  end;
end;

procedure TDbConnectionsForm.edDatabaseChange(Sender: TObject);
begin
AliasCombo.Text:= '';
end;

procedure TDbConnectionsForm.PasswordEditChange(Sender: TObject);
begin
  ConnectButton.Default := PasswordEdit.Text <> '';
end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.ConnectButtonClick(Sender: TObject);
begin
  if ValidateInputConn then
  begin
    SaveAliasName(AliasCombo.Text);
    ModalResult := mrOk;
  end;
end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.DeleteAliasButtonClick(Sender: TObject);
begin
  if AliasCombo.Text = '' then
    Exit;
  if MessageDlg('Delete Alias ' + AliasCombo.Text + LineEnding +
    'Are You sure ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if self.DeleteAlias(AliasCombo.Text) then
    begin
      AliasCombo.Text := '';
      fsconfig.GetAliasNames(AliasCombo.Items);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.SaveAliasButtonClick(Sender: TObject);
begin
  if AliasCombo.Text <> '' then
    SaveAliasName(AliasCombo.Text);
end;

//------------------------------------------------------------------------------

function TDbConnectionsForm.ValidateInputTest: boolean;
begin
  Result := False;

  if ProtocolCombo.ItemIndex > 0 then
    if HostEdit.Text = '' then
    begin
      ShowMessage('"Host" cannot be blank');
      HostEdit.SetFocus;
      Exit;
    end;

  if DatabaseEdit.Text = '' then
  begin
    ShowMessage('"Database" cannot be blank');
    DatabaseEdit.SetFocus;
    Exit;
  end;

  if UserEdit.Text = '' then
  begin
    ShowMessage('"User" cannot be blank');
    UserEdit.SetFocus;
    Exit;
  end;

  if PasswordEdit.Text = '' then
  begin
    ShowMessage('"Password" cannot be blank');
    PasswordEdit.SetFocus;
    Exit;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------

function TDbConnectionsForm.ValidateInputConn: boolean;
begin
  Result := False;
  if AliasCombo.Text = '' then
  begin
    ShowMessage('"Aliases" cannot be blank');
    AliasCombo.SetFocus;
    Exit;
  end;
  Result := ValidateInputTest;
end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.TestButtonClick(Sender: TObject);
var
  TestDb: TFBLDatabase;
begin
  TestDb := TFBLDatabase.Create(self);
  try
    if not ValidateInputTest then
      Exit;
    TestDb.Host := HostEdit.Text;
    TestDb.User := UserEdit.Text;
    TestDb.Role := RoleEdit.Text;

    case ProtocolCombo.ItemIndex of
      1:
        TestDb.Protocol := ptTcpIp;
      2:
        TestDb.Protocol := ptNetBeui;
      else
        TestDb.Protocol := ptLocal;
    end;

    TestDb.Password := PasswordEdit.Text;
    TestDb.TcpPort := PortSpinEdit.Value;
    TestDb.DBFile := DatabaseEdit.Text;
    try
      TestDb.Connect;
      ShowMessage('Connection Ok');
      TestDb.Disconnect;
    except
      on E: EFBLError do
      begin
        ShowMessage(Format('Error Code : %d', [E.ISC_ErrorCode]) +
          LineEnding + Format('SQL Code : %d', [E.SqlCode]) +
          LineEnding + E.Message);
      end;
    end;
  finally
    TestDb.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TDbConnectionsForm.AliasComboSelect(Sender: TObject);
begin
  LoadAliasName(AliasCombo.Text);
end;


end.
