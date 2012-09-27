(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://web.tiscali.it/fblib

   File: fscreatedb.pas

  * This file is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This file is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
*)

unit fscreatedb;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ExtCtrls, Buttons, FBLExcept;

type

  { TCreateDbForm }

  TCreateDbForm = class(TForm)
    CreateDbButton: TBitBtn;
    CancelButton: TBitBtn;
    PageSizeCombo: TComboBox;
    DialectCombo: TComboBox;
    CharsetCombo: TComboBox;
    FileNameEdit: TEditButton;
    UserEdit: TEdit;
    passwordEdit: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    userLabel: TLabel;
    passwordLabel: TLabel;
    Label3: TLabel;
    LSql: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    sdDb: TSaveDialog;
    procedure CreateDbButtonClick(Sender: TObject);
    procedure FileNameEditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    function CheckFileName(const AFileName: string): boolean;
  public
    { public declarations }
  end; 

//var
  //CreateDbForm: TCreateDbForm;


implementation

uses
   fsdm, {fsconst,} fsconfig;


{ TCreateDbForm }

function TCreateDbForm.CheckFileName(const AFileName: string): boolean;
var
  Test: string ;
begin
  Result := False;
  if AFileName = '' then
  begin
    ShowMessage('"DB File Name" cannot be blank');
    Exit;
  end;
  if Length(AFileName) < 5 then
  begin
    ShowMessage('File Name not valid');
    Exit;
  end;
  Test :=  UpperCase(ExtractFileExt(AFileName));
  if (Test <> '.GDB') and (Test <> '.FDB') then
  begin
    ShowMessage('File Name not valid');
    Exit;
  end;
  if FileExists(AFileName) then
  begin
    ShowMessage(AFileName + ' already exists');
    Exit;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------


procedure TCreateDbForm.FormCreate(Sender: TObject);
begin
  //  {$I fsunixborder.inc}
  DialectCombo.ItemIndex := 0;    // dialect 3
  PageSizeCombo.ItemIndex := 2;   // page size 4096
  CharsetCombo.ItemIndex := 0;
end;

//------------------------------------------------------------------------------

procedure TCreateDbForm.CreateDbButtonClick(Sender: TObject);
var
  FileName: string;
begin
   FileName := Trim(FileNameEdit.Text);
  try
    if CheckFileName(FileName) then
    begin
      if CharsetCombo.Text = 'NONE' then
        MainDataModule.MainDb.CreateDatabase(FileName, UserEdit.Text, passwordEdit.Text,
          StrToInt(DialectCombo.Text), StrToInt(PageSizeCombo.Text))
      else
        MainDataModule.MainDb.CreateDatabase(FileName, UserEdit.Text, passwordEdit.Text,
          StrToInt(DialectCombo.Text), StrToInt(PageSizeCombo.Text), CharsetCombo.Text);
      ShowMessage('Database' + LineEnding + FileNameEdit.Text + LineEnding + 'Created');
    end;
  except
    on E: EFBLError do
      ShowMessage(Format('Error Code : %d' ,[E.ISC_ErrorCode]) + LineEnding  +
        Format('SQL Code : %d',[E.SqlCode]) +
        LineEnding  + E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TCreateDbForm.FileNameEditButtonClick(Sender: TObject);
begin
  with sdDb do
  begin
    Title := 'Create database file';
    DefaultExt := FileExtentionForDialog;
    Filter :=  FileFilterForDialog;
    if Execute then
      FileNameEdit.Text := FileName;
  end;
end;

initialization
  {$I fscreatedb.lrs}
  


end.

