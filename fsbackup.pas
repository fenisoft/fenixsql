(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsbackup.pas

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

unit fsbackup;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Dialogs, ExtCtrls,
  Buttons, StdCtrls, EditBtn, ComCtrls, FBLService, FBLDatabase, FBLExcept;

type

  { TBackupForm }

  TBackupForm = class(TForm)
    StartButton: TBitBtn;
    CancelButton: TBitBtn;
    OptionsCheckGroup: TCheckGroup;
    BackupFileEdit: TEditButton;
    DbFileEdit: TEdit;
    OutMemo: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    sdBkpFile: TSaveDialog;
    filesTabSheet: TTabSheet;
    outputTabSheet: TTabSheet;
    procedure StartButtonClick(Sender: TObject);
    procedure BackupFileEditButtonClick(Sender: TObject);
    procedure FBLService1WriteOutput(Sender: TObject; TextLine: string;
      IscAction: integer);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    FBLService1: TFBLService;
    function CheckInputData: boolean;
  public
    { public declarations }
  end;

procedure DatabaseBackup(aDb: TFBLDatabase);



implementation

{$R *.lfm}

procedure TBackupForm.FBLService1WriteOutput(Sender: TObject;
  TextLine: string; IscAction: integer);
begin
  OutMemo.Lines.Add(TextLine);
end;

//------------------------------------------------------------------------------

procedure TBackupForm.FormCreate(Sender: TObject);
begin
  FBLService1 := TFBLService.Create(self);
  FBLService1.OnWriteOutput := @FBLService1WriteOutput;
end;

//------------------------------------------------------------------------------

procedure TBackupForm.StartButtonClick(Sender: TObject);
var
  BkpOptions: TBackupOptions;
begin
  BkpOptions := [];
  if not CheckInputData then
    Exit;
  if OptionsCheckGroup.Checked[0] then
    BkpOptions := BkpOptions + [bkpVerbose];
  if OptionsCheckGroup.Checked[1] then
    BkpOptions := BkpOptions + [bkpMetadataOnly];
  if OptionsCheckGroup.Checked[2] then
    BkpOptions := BkpOptions + [bkpIgnoreCheckSum];
  if OptionsCheckGroup.Checked[3] then
    BkpOptions := BkpOptions + [bkpIgnoreLimbo];
  if OptionsCheckGroup.Checked[4] then
    BkpOptions := BkpOptions + [bkpNoGarbageCollect];
  if OptionsCheckGroup.Checked[5] then
    BkpOptions := BkpOptions + [bkpOldDescription];
  if OptionsCheckGroup.Checked[6] then
    BkpOptions := BkpOptions + [bkpNoTrasportable];

  try
    if not FBLService1.Connected then
      FBLService1.Connect;
    OutMemo.Lines.Clear;
    PageControl1.PageIndex := 1;
    FBLService1.Backup(DbFileEdit.Text, BackupFileEdit.Text, BkpOptions);
    if FBLService1.Connected then
      FBLService1.Disconnect;
  except
    on E: EFBLError do
    begin
      PageControl1.PageIndex := 1;
      OutMemo.Lines.Clear;
      OutMemo.Lines.Add('ERROR');
      OutMemo.Lines.Add('-------------');
      OutMemo.Lines.Add('isc_error: ' + IntToStr(E.ISC_ErrorCode));
      OutMemo.Lines.Text := OutMemo.Lines.Text + E.Message;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBackupForm.BackupFileEditButtonClick(Sender: TObject);
begin
  sdBkpFile.Filter := 'Firebird Backup file (*.gbk)|*.gbk';
  if sdBkpFile.Execute then
    BackupFileEdit.Text := sdBkpfile.FileName;
end;

//------------------------------------------------------------------------------

procedure DatabaseBackup(aDB: TFBLDatabase);
var
  BackupForm: TBackupForm;
begin
  BackupForm := TBackupForm.Create(nil);
  try
    BackupForm.FBLService1.User := aDB.User;
    BackupForm.FBLService1.Password := aDb.Password;
    BackupForm.FBLService1.Host := aDb.Host;
    if aDB.Protocol = ptLocal then
      BackupForm.FBLService1.Protocol := FBLService.sptLocal
    else if aDB.Protocol = ptTcpIp then
      BackupForm.FBLService1.Protocol := FBLService.sptTcpIp
    else if aDb.Protocol = ptNetBeui then
      BackupForm.FBLService1.Protocol := FBLService.sptNetBeui;
    BackupForm.DBFileEdit.Text := aDb.DBFile;
    BackupForm.ShowModal;
  finally
    BackupForm.Free;
  end;
end;

//------------------------------------------------------------------------------

function TBackupForm.CheckInputData: boolean;
begin
  Result := False;
  if DbFileEdit.Text = '' then
  begin
    ShowMessage('"Database File" cannot be blank');
    DbFileEdit.SetFocus;
    Exit;
  end;
  if BackupFileEdit.Text = '' then
  begin
    ShowMessage('"Backup File" cannot be blank');
    BackupFileEdit.SetFocus;
    Exit;
  end;
  Result := True;
end;


end.
