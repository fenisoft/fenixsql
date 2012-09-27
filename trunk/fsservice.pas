(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsservice.pas

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


unit fsservice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Menus, StdCtrls, FBLService, ActnList, FBLExcept, SynMemo, EditBtn,
  Buttons, IniFiles, types;

type

  { TServiceForm }

  TServiceForm = class(TForm)
    ConnectAction: TAction;
    CloseFormAction: TAction;
    LoadSettingAction: TAction;
    SaveSettingAction: TAction;
    GFixAction: TAction;
    StartRestoreAction: TAction;
    StartBackupAction: TAction;
    RefreshAction: TAction;
    GstatAction: TAction;
    ServerLogAction: TAction;
    DisconnectAction: TAction;
    ActionList1: TActionList;
    bkPanel: TPanel;
    StartBackupButton: TBitBtn;
    StartGstatButton: TBitBtn;
    StartRestoreButton: TBitBtn;
    StartGfixButton: TBitBtn;
    PageSizeCheckBox: TCheckBox;
    BackupCheckGroup: TCheckGroup;
    GfixCheckGroup: TCheckGroup;
    GstatCheckGroup: TCheckGroup;
    RestoreCheckGroup: TCheckGroup;
    PageSizeComboBox: TComboBox;
    ProtocolComboBox: TComboBox;
    dbEditPanel: TPanel;
    BackupBKEdit: TEditButton;
    BackupDBEdit: TEditButton;
    GfixDBEdit: TEditButton;
    GstatDBEdit: TEditButton;
    HostEdit: TEdit;
    PasswordEdit: TEdit;
    RestoreBKEdit: TEditButton;
    RestoreDBEdit: TEditButton;
    UserEdit: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    gstatTabSheet1: TTabSheet;
    HostLabel: TLabel;
    ProtocolLabel: TLabel;
    Label2: TLabel;
    UserLabel: TLabel;
    PasswordLabel: TLabel;
    lblServerInfo: TLabel;
    InfoSynMemo: TSynMemo;
    OutputMemo: TMemo;
    bkEditPanel: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    pServerInfo: TPanel;
    AccessModeRadioGroup: TRadioGroup;
    RestoreActionRadioGroup: TRadioGroup;
    servicesPageControl: TPageControl;
    ServiceImageList: TImageList;
    MainMenu1: TMainMenu;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    OpenDialog: TOpenDialog;
    Panel1: TPanel;
    SaveDialog: TSaveDialog;
    StatusBar1: TStatusBar;
    connectionTabSheet: TTabSheet;
    tabBackup: TTabSheet;
    restoreTabSheet: TTabSheet;
    gstatTabSheet: TTabSheet;
    gfixTabSheet: TTabSheet;
    outputTabSheet: TTabSheet;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure CloseFormActionExecute(Sender: TObject);
    procedure ConnectActionExecute(Sender: TObject);
    procedure DisconnectActionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure GFixActionExecute(Sender: TObject);
    procedure GstatActionExecute(Sender: TObject);
    procedure LoadSettingActionExecute(Sender: TObject);
    procedure RefreshActionExecute(Sender: TObject);
    procedure SaveSettingActionExecute(Sender: TObject);
    procedure ServerLogActionExecute(Sender: TObject);
    procedure StartBackupActionExecute(Sender: TObject);
    procedure StartRestoreActionExecute(Sender: TObject);
    procedure PageSizeCheckBoxChange(Sender: TObject);
    procedure BackupBKEditButtonClick(Sender: TObject);
    procedure BackupDBEditButtonClick(Sender: TObject);
    procedure GfixDBEditButtonClick(Sender: TObject);
    procedure GstatDBEditButtonClick(Sender: TObject);
    procedure RestoreBKEditButtonClick(Sender: TObject);
    procedure RestoreDBEditButtonClick(Sender: TObject);
    procedure FBLService1Connect(Sender: TObject);
    procedure FBLService1Disconnect(Sender: TObject);
    procedure FBLService1WriteOutput(Sender: TObject; TextLine: string;
      IscAction: integer);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    FBLService1: TFBLService;
    procedure ShowServerInfo;
    procedure LoadSetting(const AFileName: string);
    procedure SaveSetting(const AFileName: string);

  public
    { public declarations }
  end;

const
  DEFAULT_HEIGHT = 540;
  DEFAULT_WIDTH = 600;
//var
//ServiceForm: TServiceForm;

const

  {BACKUP options}
  BK_VERBOSE = 0;
  BK_METADATAONLY = 1;
  BK_CHECKSUM = 2;
  BK_LIMBO = 3;
  BK_NOGARBAGE = 4;
  BK_OLDDESC = 5;
  BK_NOTRASP = 6;
  {RESTORE options}
  RS_VERBOSE = 0;
  RS_DEACT_IDX = 1;
  RS_NOSHADOW = 2;
  RS_NOVAL = 3;
  RS_ONEATTIME = 4;
  RS_USEALLSPACE = 5;
  {GSTAT options}
  GS_DATA = 0;
  GS_LOG = 1;
  GS_HEADER = 2;
  GS_INDEX = 3;
  GS_SYSTEM = 4;
  GS_AVERAGE = 5;
  {GFIX options}
  GF_READONLY = 0;
  GF_IGNORECHECK = 1;
  GF_KILLSHADOW = 2;
  GF_PREPARE = 3;
  GF_VDATABASE = 4;
  GF_VRECORD = 5;
  GF_FORCEGARBAGE = 6;

implementation

uses
  fsconfig;

{ TServiceForm }


//------------------------------------------------------------------------------
procedure TServiceForm.LoadSetting(const AFileName: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(AFileName);
  try
    if inifile.ReadString('version', 'check', '') <> 'fsservice1.0' then
    begin
      ShowMessage('Incompatible file type');
      Exit;
    end;
    //server setting
    ProtocolComboBox.ItemIndex := inifile.ReadInteger('connection', 'protocol', 0);
    HostEdit.Text := inifile.ReadString('connection', 'host', '');
    UserEdit.Text := inifile.ReadString('connection', 'user', 'sysdba');

    //backup setting
   {BK_VERBOSE = 0;
   BK_METADATAONLY = 1;
   BK_CHECKSUM = 2;
   BK_LIMBO = 3;
   BK_NOGARBAGE = 4;
   BK_OLDDESC = 5;
   BK_NOTRASP = 6;}
    BackupDBEdit.Text := inifile.ReadString('backup', 'file-db', '');
    BackupBKEdit.Text := inifile.ReadString('backup', 'file-bk', '');
    BackupCheckGroup.Checked[BK_VERBOSE] := inifile.ReadBool('backup', 'verbose', True);
    BackupCheckGroup.Checked[BK_METADATAONLY] := inifile.ReadBool('backup', 'metadata-only', False);
    BackupCheckGroup.Checked[BK_CHECKSUM] := inifile.ReadBool('backup', 'ignore-check', False);
    BackupCheckGroup.Checked[BK_LIMBO] := inifile.ReadBool('backup', 'ignore-limbo', False);
    BackupCheckGroup.Checked[BK_NOGARBAGE] := inifile.ReadBool('backup', 'no-garbage', False);
    BackupCheckGroup.Checked[BK_OLDDESC] := inifile.ReadBool('backup', 'old-description', False);
    BackupCheckGroup.Checked[BK_NOTRASP] := inifile.ReadBool('backup', 'non-trasportable', False);
    //restore setting
   {
   RS_VERBOSE = 0;
   RS_DEACT_IDX = 1;
   RS_NOSHADOW = 2;
   RS_NOVAL = 3;
   RS_ONEATTIME = 4;
   RS_USEALLSPACE = 5;
   }
    RestoreBKEdit.Text := inifile.ReadString('restore', 'file-bk', '');
    RestoreDBEdit.Text := inifile.ReadString('restore', 'file-db', '');
    RestoreCheckGroup.Checked[RS_VERBOSE] := inifile.ReadBool('restore', 'verbose', True);
    RestoreCheckGroup.Checked[RS_DEACT_IDX] :=
      inifile.ReadBool('restore', 'deactivate-index', False);
    RestoreCheckGroup.Checked[RS_NOSHADOW] := inifile.ReadBool('restore', 'no-shadow', False);
    RestoreCheckGroup.Checked[RS_NOVAL] := inifile.ReadBool('restore', 'no-validity', False);
    RestoreCheckGroup.Checked[RS_ONEATTIME] := inifile.ReadBool('restore', 'one-at-time', False);
    RestoreCheckGroup.Checked[RS_USEALLSPACE] :=
      inifile.ReadBool('restore', 'use-all-space', False);
    RestoreActionRadioGroup.ItemIndex := inifile.ReadInteger('restore', 'action', 0);
    AccessModeRadioGroup.ItemIndex := inifile.ReadInteger('restore', 'access-mode', 0);
    PageSizeCheckBox.Checked := inifile.ReadBool('restore', 'page-size-enable', False);
    PageSizeComboBox.Text := inifile.ReadString('restore', 'page-size', '');
   {
   GS_DATA = 0;
   GS_LOG = 1;
   GS_HEADER = 2;
   GS_INDEX = 3;
   GS_SYSTEM = 4;
   GS_AVERAGE = 5;
   }
    GstatDBEdit.Text := inifile.ReadString('gstat', 'file-db', '');
    GstatCheckGroup.Checked[GS_DATA] := inifile.ReadBool('gstat', 'data-pages', False);
    GstatCheckGroup.Checked[GS_LOG] := inifile.ReadBool('gstat', 'log-pages', False);
    GstatCheckGroup.Checked[GS_HEADER] := inifile.ReadBool('gstat', 'header-pages', False);
    GstatCheckGroup.Checked[GS_INDEX] := inifile.ReadBool('gstat', 'index-pages', False);
    GstatCheckGroup.Checked[GS_SYSTEM] := inifile.ReadBool('gstat', 'system-relations', False);
    GstatCheckGroup.Checked[GS_AVERAGE] := inifile.ReadBool('gstat', 'record-versions', False);
   {
    GF_READONLY = 0;
    GF_IGNORECHECK = 1;
    GF_KILLSHADOW = 2;
    GF_PREPARE = 3;
    GF_VDATABASE = 4;
    GF_VRECORD = 5;
    GF_FORCEGARBAGE = 6;
   }
    GfixDBEdit.Text := inifile.ReadString('gfix', 'file-db', '');
    GfixCheckGroup.Checked[GF_READONLY] := inifile.ReadBool('gfix', 'read-only', False);
    GfixCheckGroup.Checked[GF_IGNORECHECK] := inifile.ReadBool('gfix', 'ignore-check', False);
    GfixCheckGroup.Checked[GF_KILLSHADOW] := inifile.ReadBool('gfix', 'kill-shadow', False);
    GfixCheckGroup.Checked[GF_PREPARE] := inifile.ReadBool('gfix', 'mend', False);
    GfixCheckGroup.Checked[GF_VDATABASE] := inifile.ReadBool('gfix', 'validate', False);
    GfixCheckGroup.Checked[GF_VRECORD] := inifile.ReadBool('gfix', 'full', False);
    GfixCheckGroup.Checked[GF_FORCEGARBAGE] := inifile.ReadBool('gfix', 'sweep', False);
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.SaveSetting(const AFileName: string);
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(AFileName);
  try
    inifile.WriteString('version', 'check', 'fsservice1.0');
    //server setting
    inifile.WriteInteger('connection', 'protocol', ProtocolComboBox.ItemIndex);
    inifile.WriteString('connection', 'host', HostEdit.Text);
    inifile.WriteString('connection', 'user', UserEdit.Text);
    //backup setting
   {BK_VERBOSE = 0;
   BK_METADATAONLY = 1;
   BK_CHECKSUM = 2;
   BK_LIMBO = 3;
   BK_NOGARBAGE = 4;
   BK_OLDDESC = 5;
   BK_NOTRASP = 6;}
    inifile.WriteString('backup', 'file-db', BackupDBEdit.Text);
    inifile.WriteString('backup', 'file-bk', BackupBKEdit.Text);
    inifile.WriteBool('backup', 'verbose', BackupCheckGroup.Checked[BK_VERBOSE]);
    inifile.WriteBool('backup', 'metadata-only', BackupCheckGroup.Checked[BK_METADATAONLY]);
    inifile.WriteBool('backup', 'ignore-check', BackupCheckGroup.Checked[BK_CHECKSUM]);
    inifile.WriteBool('backup', 'ignore-limbo', BackupCheckGroup.Checked[BK_LIMBO]);
    inifile.WriteBool('backup', 'no-garbage', BackupCheckGroup.Checked[BK_NOGARBAGE]);
    inifile.WriteBool('backup', 'old-description', BackupCheckGroup.Checked[BK_OLDDESC]);
    inifile.WriteBool('backup', 'non-trasportable', BackupCheckGroup.Checked[BK_NOTRASP]);
   {
   RS_VERBOSE = 0;
   RS_DEACT_IDX = 1;
   RS_NOSHADOW = 2;
   RS_NOVAL = 3;
   RS_ONEATTIME = 4;
   RS_USEALLSPACE = 5;
   }
    inifile.WriteString('restore', 'file-bk', RestoreBKEdit.Text);
    inifile.WriteString('restore', 'file-db', RestoreDBEdit.Text);
    inifile.WriteBool('restore', 'verbose', RestoreCheckGroup.Checked[RS_VERBOSE]);
    inifile.WriteBool('restore', 'deactivate-index', RestoreCheckGroup.Checked[RS_DEACT_IDX]);
    inifile.WriteBool('restore', 'no-shadow', RestoreCheckGroup.Checked[RS_NOSHADOW]);
    inifile.WriteBool('restore', 'no-validity', RestoreCheckGroup.Checked[RS_NOVAL]);
    inifile.WriteBool('restore', 'one-at-time', RestoreCheckGroup.Checked[RS_ONEATTIME]);
    inifile.WriteBool('restore', 'use-all-space', RestoreCheckGroup.Checked[RS_USEALLSPACE]);
    inifile.WriteInteger('restore', 'action', RestoreActionRadioGroup.ItemIndex);
    inifile.WriteInteger('restore', 'access-mode', AccessModeRadioGroup.ItemIndex);
    inifile.WriteBool('restore', 'page-size-enable', PageSizeCheckBox.Checked);
    inifile.WriteString('restore', 'page-size', PageSizeComboBox.Text);
   {
   GS_DATA = 0;
   GS_LOG = 1;
   GS_HEADER = 2;
   GS_INDEX = 3;
   GS_SYSTEM = 4;
   GS_AVERAGE = 5;
   }
    inifile.WriteString('gstat', 'file-db', GstatDBEdit.Text);
    inifile.WriteBool('gstat', 'data-pages', GstatCheckGroup.Checked[GS_DATA]);
    inifile.WriteBool('gstat', 'log-pages', GstatCheckGroup.Checked[GS_LOG]);
    inifile.WriteBool('gstat', 'header-pages', GstatCheckGroup.Checked[GS_HEADER]);
    inifile.WriteBool('gstat', 'index-pages', GstatCheckGroup.Checked[GS_INDEX]);
    inifile.WriteBool('gstat', 'system-relations', GstatCheckGroup.Checked[GS_SYSTEM]);
    inifile.WriteBool('gstat', 'record-versions', GstatCheckGroup.Checked[GS_AVERAGE]);
   {
   GF_READONLY = 0;
   GF_IGNORECHECK = 1;
   GF_KILLSHADOW = 2;
   GF_PREPARE = 3;
   GF_VDATABASE = 4;
   GF_VRECORD = 5;
   GF_FORCEGARBAGE = 6;
   }
    inifile.WriteString('gfix', 'file-db', GfixDBEdit.Text);
    inifile.WriteBool('gfix', 'read-only', GfixCheckGroup.Checked[GF_READONLY]);
    inifile.WriteBool('gfix', 'ignore-check', GfixCheckGroup.Checked[GF_IGNORECHECK]);
    inifile.WriteBool('gfix', 'kill-shadow', GfixCheckGroup.Checked[GF_KILLSHADOW]);
    inifile.WriteBool('gfix', 'mend', GfixCheckGroup.Checked[GF_PREPARE]);
    inifile.WriteBool('gfix', 'validate', GfixCheckGroup.Checked[GF_VDATABASE]);
    inifile.WriteBool('gfix', 'full', GfixCheckGroup.Checked[GF_VRECORD]);
    inifile.WriteBool('gfix', 'sweep', GfixCheckGroup.Checked[GF_FORCEGARBAGE]);
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.ConnectActionExecute(Sender: TObject);
begin
  if HostEdit.Text <> '' then
    FblService1.Host := HostEdit.Text;
  case ProtocolComboBox.ItemIndex of
    1: FblService1.Protocol := ptTcpIp;
    2: FblService1.Protocol := ptNetBeui;
    else
      FblService1.Protocol := ptLocal;
  end;
  FblService1.User := UserEdit.Text;
  FblService1.Password := PasswordEdit.Text;
  try
    FblService1.Connect;
  except
    on E: EFBLError do
      ShowMessage(E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.CloseFormActionExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.DisconnectActionExecute(Sender: TObject);
begin
  if FblService1.Connected then
    FblService1.Disconnect;
end;

procedure TServiceForm.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if FBLService1.Connected then
    FBLService1.Disconnect;
  fsconfig.SaveFormPos(self);
end;

//------------------------------------------------------------------------------

procedure TServiceForm.GFixActionExecute(Sender: TObject);
var
  GfixOption: TGfixRepairs;
begin
  if GfixDBEdit.Text = '' then
  begin
    ShowMessage('"Database file" cannot be blank');
    GfixDBEdit.SetFocus;
    Exit;
  end;
  GfixOption := [];
  {TGfixRepair = (gfrCheckDb,gfrIgnore,gfrKill,
   gfrMend,gfrValidate,gfrFull,gfrSweep)}
  {
  GF_READONLY = 0;
  GF_IGNORECHECK = 1;
  GF_KILLSHADOW = 2;
  GF_PREPARE = 3;
  GF_VDATABASE = 4;
  GF_VRECORD = 5;
  GF_FORCEGARBAGE = 6;}
  if GfixCheckGroup.Checked[GF_READONLY] then
    GfixOption := GfixOption + [gfrCheckDb];
  if GfixCheckGroup.Checked[GF_IGNORECHECK] then
    GfixOption := GfixOption + [gfrIgnore];
  if GfixCheckGroup.Checked[GF_KILLSHADOW] then
    GfixOption := GfixOption + [gfrKill];
  if GfixCheckGroup.Checked[GF_PREPARE] then
    GfixOption := GfixOption + [gfrMend];
  if GfixCheckGroup.Checked[GF_VDATABASE] then
    GfixOption := GfixOption + [gfrValidate];
  if GfixCheckGroup.Checked[GF_VRECORD] then
    GfixOption := GfixOption + [gfrFull];
  if GfixCheckGroup.Checked[GF_FORCEGARBAGE] then
    GfixOption := GfixOption + [gfrSweep];
  try
    FBLService1.GFixRepair(GfixDBEdit.Text, GfixOption);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.GstatActionExecute(Sender: TObject);
var
  StatOption: TStatOptions;
begin
  if GstatDBEdit.Text = '' then
  begin
    ShowMessage('"Database file" cannot be blank');
    GstatDBEdit.SetFocus;
    Exit;
  end;
  StatOption := [];
  {
  GS_DATA = 0;
  GS_LOG = 1;
  GS_HEADER = 2;
  GS_INDEX = 3;
  GS_SYSTEM = 4;
  GS_AVERAGE = 5;}
  if GstatCheckGroup.Checked[GS_DATA] then
    StatOption := StatOption + [stsDataPages];
  if GstatCheckGroup.Checked[GS_LOG] then
    StatOption := StatOption + [stsDbLog];
  if GstatCheckGroup.Checked[GS_HEADER] then
    StatOption := StatOption + [stsHdrPages];
  if GstatCheckGroup.Checked[GS_INDEX] then
    StatOption := StatOption + [stsIdxPages];
  if GstatCheckGroup.Checked[GS_SYSTEM] then
    StatOption := StatOption + [stsSysRelations];
  if GstatCheckGroup.Checked[GS_AVERAGE] then
    StatOption := StatOption + [stsRecordVersions];

  try
    OutputMemo.Lines.Clear;
    FBLService1.GetStatusReports(GstatDBEdit.Text, StatOption);
  except
    on E: EFBLError do
      ShowMessage(E.Message);
  end;
  //servicesPageControl.ActivePage := TabOut;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.LoadSettingActionExecute(Sender: TObject);
begin
  OpenDialog.Filter := 'Firebird service setting (*.fss)|*.fss|Any files (*.*)|*.*';
  if OpenDialog.Execute then
    LoadSetting(OpenDialog.FileName);
end;

//------------------------------------------------------------------------------

procedure TServiceForm.RefreshActionExecute(Sender: TObject);
begin
  ShowServerInfo;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.SaveSettingActionExecute(Sender: TObject);
begin
  SaveDialog.Filter := 'Firebird service setting (*.fss)|*.fss|Any files (*.*)|*.*';
  SaveDialog.DefaultExt := 'fss';
  SaveDialog.Options := [ofOverwritePrompt, ofPathMustExist, ofEnableSizing];
  if SaveDialog.Execute then
    SaveSetting(SaveDialog.FileName);
end;

//------------------------------------------------------------------------------

procedure TServiceForm.ServerLogActionExecute(Sender: TObject);
begin
  OutputMemo.Lines.Clear;
  FBLService1.GetLogFile;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.StartBackupActionExecute(Sender: TObject);
var
  BkpOptions: TBackupOptions;
begin
  BkpOptions := [];
  if BackupDBEdit.Text = '' then
  begin
    ShowMessage('"Database File" cannot be blank');
    BackupDBEdit.SetFocus;
    Exit;
  end;

  if BackupBKEdit.Text = '' then
  begin
    ShowMessage('"Backup File" cannot be blank');
    BackupBKEdit.SetFocus;
    Exit;
  end;

  if BackupCheckGroup.Checked[BK_VERBOSE] then
    BkpOptions := BkpOptions + [bkpVerbose];
  if BackupCheckGroup.Checked[BK_METADATAONLY] then
    BkpOptions := BkpOptions + [bkpMetadataOnly];
  if BackupCheckGroup.Checked[BK_CHECKSUM] then
    BkpOptions := BkpOptions + [bkpIgnoreCheckSum];
  if BackupCheckGroup.Checked[BK_LIMBO] then
    BkpOptions := BkpOptions + [bkpIgnoreLimbo];
  if BackupCheckGroup.Checked[BK_NOGARBAGE] then
    BkpOptions := BkpOptions + [bkpNoGarbageCollect];
  if BackupCheckGroup.Checked[BK_OLDDESC] then
    BkpOptions := BkpOptions + [bkpOldDescription];
  if BackupCheckGroup.Checked[BK_NOTRASP] then
    BkpOptions := BkpOptions + [bkpNoTrasportable];
  OutputMemo.Lines.Clear;
  FBLService1.Backup(BackupDBEdit.Text, BackupBKEdit.Text, BkpOptions);
  //servicesPageControl.ActivePage := tabOut;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.StartRestoreActionExecute(Sender: TObject);
var
  ResOptions: TRestoreOptions;
  PagSize: integer;
begin
  ResOptions := [];
  PagSize := 0;
  if RestoreBKEdit.Text = '' then
  begin
    ShowMessage('"Backup File" cannot be blank');
    RestoreBKEdit.SetFocus;
    Exit;
  end;
  if RestoreDBEdit.Text = '' then
  begin
    ShowMessage('"Database File" cannot be blank');
    RestoreDBEdit.SetFocus;
    Exit;
  end;

  try
    if PageSizeCheckBox.Checked then
      PagSize := StrToInt(PageSizeComboBox.Text);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      PageSizeComboBox.SetFocus;
    end;
  end;

  if RestoreActionRadioGroup.ItemIndex = 0 then    //replace
    ResOptions := ResOptions + [resReplace]
  else
    ResOptions := ResOptions + [resCreate];

  if AccessModeRadioGroup.ItemIndex = 1 then
    ResOptions := ResOptions + [resAccessModeReadOnly]
  else if AccessModeRadioGroup.ItemIndex = 2 then
    ResOptions := ResOptions + [resAccessModeReadWrite];

  if RestoreCheckGroup.Checked[RS_VERBOSE] then
    ResOptions := ResOptions + [resVerbose];

  if RestoreCheckGroup.Checked[RS_DEACT_IDX] then
    ResOptions := ResOptions + [resDeactivateIdx];

  if RestoreCheckGroup.Checked[RS_NOSHADOW] then
    ResOptions := ResOptions + [resNoShadow];

  if RestoreCheckGroup.Checked[RS_NOVAL] then
    ResOptions := ResOptions + [resNoValidity];

  if RestoreCheckGroup.Checked[RS_ONEATTIME] then
    ResOptions := ResOptions + [resOneAtATime];

  if RestoreCheckGroup.Checked[RS_USEALLSPACE] then
    ResOptions := ResOptions + [resUseAllSpace];

  OutputMemo.Lines.Clear;
  try
    FBLService1.Restore(RestoreBKEdit.Text, RestoreDBEdit.Text, ResOptions, PagSize);
  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.PageSizeCheckBoxChange(Sender: TObject);
begin
  PageSizeComboBox.Enabled := PageSizeCheckBox.Checked;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.BackupBKEditButtonClick(Sender: TObject);
begin
  SaveDialog.Filter := 'Firebird Backup file (*.gbk)|*.gbk';
  if SaveDialog.Execute then
    BackupBKEdit.Text := SaveDialog.FileName;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.BackupDBEditButtonClick(Sender: TObject);
begin
  OpenDialog.Filter := 'Firebird DB files (*.fdb;*.gdb)|*.fdb;*.gdb';
  if OpenDialog.Execute then
  begin
    BackupDBEdit.Text := OpenDialog.FileName;
    BackupBKEdit.Text := ChangeFileExt(OpenDialog.FileName, '.gbk');
  end;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.GfixDBEditButtonClick(Sender: TObject);
begin
  OpenDialog.Filter := 'Firebird DB files (*.fdb;*.gdb)|*.fdb;*.gdb';
  if OpenDialog.Execute then
    GfixDBEdit.Text := OpenDialog.FileName;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.GstatDBEditButtonClick(Sender: TObject);
begin
  OpenDialog.Filter := 'Firebird DB files (*.fdb;*.gdb)|*.fdb;*.gdb';
  if OpenDialog.Execute then
    GstatDBEdit.Text := OpenDialog.FileName;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.RestoreBKEditButtonClick(Sender: TObject);
begin
  SaveDialog.Filter := 'Firebird Backup file (*.gbk)|*.gbk|Any file(*.*)|*.*';
  if SaveDialog.Execute then
    RestoreBKEdit.Text := SaveDialog.FileName;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.RestoreDBEditButtonClick(Sender: TObject);
begin
  OpenDialog.Filter := 'Firebird DB files (*.fdb;*.gdb)|*.fdb;*.gdb';
  if OpenDialog.Execute then
    RestoreDBEdit.Text := OpenDialog.FileName;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.FBLService1Connect(Sender: TObject);
begin
  ConnectAction.Enabled := False;
  DisconnectAction.Enabled := True;
  ServerLogAction.Enabled := True;
  GstatAction.Enabled := True;
  RefreshAction.Enabled := True;
  StartBackupAction.Enabled := True;
  StartRestoreAction.Enabled := True;
  GFixAction.Enabled := True;
  ShowServerInfo;
  StatusBar1.Panels[0].Text := 'Service Manager : Connected';
end;

//------------------------------------------------------------------------------

procedure TServiceForm.FBLService1Disconnect(Sender: TObject);
begin
  ConnectAction.Enabled := True;
  DisconnectAction.Enabled := False;
  ServerLogAction.Enabled := False;
  GstatAction.Enabled := False;
  RefreshAction.Enabled := False;
  StartBackupAction.Enabled := False;
  StartRestoreAction.Enabled := False;
  GFixAction.Enabled := False;
  InfoSynMemo.Lines.Clear;
  StatusBar1.Panels[0].Text := 'Service Manager : Not Connected';
  InfoSynMemo.Lines.Clear;
end;

//------------------------------------------------------------------------------

procedure TServiceForm.FBLService1WriteOutput(Sender: TObject;
  TextLine: string; IscAction: integer);
begin
  servicesPAgeControl.PageIndex := 5;
  //servicesPageControl.ActivePage := tabOut;
  OutputMemo.Lines.Add(Trim(TextLine));
end;

//------------------------------------------------------------------------------



//------------------------------------------------------------------------------

procedure TServiceForm.FormCreate(Sender: TObject);
begin
  {$IFDEF UNIX}
  ProtocolComboBox.ItemIndex := 1;
  HostEdit.Text := 'Localhost';
  {$ENDIF}
  Self.Top := (Screen.Height - DEFAULT_HEIGHT) div 2;
  Self.Left := (Screen.Width - DEFAULT_WIDTH) div 2;
  self.Height := DEFAULT_HEIGHT;
  self.Width := DEFAULT_WIDTH;
  fsconfig.LoadFormPos(Self);
  self.Constraints.MinHeight := DEFAULT_HEIGHT;
  self.Constraints.MinWidth := DEFAULT_WIDTH;
  StatusBar1.Panels[0].Text := 'Service Manager : Not Connected';
  FBLService1 := TFBLService.Create(self);
  FBLService1.OnConnect := @FBLService1Connect;
  FBLService1.OnDisconnect := @FBLService1Disconnect;
  FBLService1.OnWriteOutput := @FBLService1WriteOutput;
end;



//------------------------------------------------------------------------------

procedure TServiceForm.ShowServerInfo;
var
  i, n: integer;
  sList: TStringList;
begin
  sList := TStringList.Create;
  try
    InfoSynMemo.Lines.Clear;
    InfoSynMemo.Lines.Add(Format('%-20s: %s', ['Version', FBLService1.ServerVersion]));
    InfoSynMemo.Lines.Add(Format('%-20s: %d', ['Service Mgr Version', FBLService1.Version]));
    InfoSynMemo.Lines.Add(Format('%-20s: %s', ['Implementation',
      FBLService1.ServerImplementation]));
    InfoSynMemo.Lines.Add(Format('%-20s: %s', ['Server Path', FBLService1.ServerPath]));
    InfoSynMemo.Lines.Add(Format('%-20s: %s', ['Server Lock Path',
      FBLService1.ServerLockPath]));
    InfoSynMemo.Lines.Add(Format('%-20s: %s', ['Server Msg Path', FBLService1.ServerMsgPath]));
    InfoSynMemo.Lines.Add(Format('%-20s: %s', ['User Db Path', FBLService1.UserDbPath]));
    {$IFNDEF UNIX}
    try
      InfoSynMemo.Lines.Add(Format('%-20s: %d', ['Num of Attachments',
        FBLService1.NumOfAttachments]));
      InfoSynMemo.Lines.Add(Format('%-20s: %d', ['Num of Databases',
        FBLService1.NumOfDatabases]));

      sList.Assign(FBLService1.DatabaseNames);
      n := sList.Count;
      if n > 0 then
      begin
        InfoSynMemo.Lines.Add('List of databases :');
        for i := 0 to n - 1 do
          InfoSynMemo.Lines.Add(Format(' %3d : %s', [(i + 1), sList.Strings[i]]));
      end;
    except
      on E: EFBLError do
        ShowMessage(E.Message + #10 + 'isc_error : ' + IntToStr(E.ISC_ErrorCode));

    end;
    {$ENDIF}
  finally
    sList.Free;
  end;
end;



initialization
  {$I fsservice.lrs}


end.
