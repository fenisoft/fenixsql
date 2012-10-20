(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsusermod.pas

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
unit fsusermod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type
  TUserModType = (umInsert, umModify);

  { TUserModForm }
  TUserModForm = class(TForm)
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    UserNameEdit: TLabeledEdit;
    PasswordEdit: TLabeledEdit;
    ConfirmPasswordEdit: TLabeledEdit;
    FirstNameEdit: TLabeledEdit;
    MiddleNameEdit: TLabeledEdit;
    LastNameEdit: TLabeledEdit;
    procedure OkButtonClick(Sender: TObject);
    procedure ConfirmPasswordEditChange(Sender: TObject);
    procedure FirstNameEditChange(Sender: TObject);
    procedure LastNameEditChange(Sender: TObject);
    procedure MiddleNameEditChange(Sender: TObject);
    procedure PasswordEditChange(Sender: TObject);
    procedure UserNameEditChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    FUserModType: TUserModType;
    function GetUserName: string;
    function GetPassword: string;
    function GetFirstName: string;
    function GetMiddleName: string;
    function GetLastName: string;
    procedure SetUserName(const Value: string);
    procedure SetFirstName(const Value: string);
    procedure SetMiddleName(const Value: string);
    procedure SetLastName(const Value: string);
  public
    { public declarations }
    property UserName: string read GetUserName write SetUserName;
    property PassWord: string read GetPassword;
    property FirstName: string read GetFirstName write SetFirstName;
    property MiddleName: string read GetMiddleName write SetMiddleName;
    property LastName: string read GetLastName write SetLastName;
    property UserModeType: TUserModType read FUserModType write FUserModType;
  end;



implementation

{$R *.lfm}

procedure TUserModForm.FormShow(Sender: TObject);
begin
  case FuserModType of
    umInsert:
      Caption := 'Add User';
    umModify:
    begin
      Caption := 'Modify User';
      UserNameEdit.ReadOnly := True;
      PasswordEdit.SetFocus;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TUserModForm.UserNameEditChange(Sender: TObject);
begin
  if FUserModType = umInsert then
    OkButton.Enabled := (UserNameEdit.Text <> '') and (PasswordEdit.Text <> '') and
      (ConfirmPasswordEdit.Text <> '');
end;



//------------------------------------------------------------------------------

procedure TUserModForm.PasswordEditChange(Sender: TObject);
begin
  if FUserModType = umInsert then
    OkButton.Enabled := (UserNameEdit.Text <> '') and (PasswordEdit.Text <> '') and
      (ConfirmPasswordEdit.Text <> '')
  else
    OkButton.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TUserModForm.ConfirmPasswordEditChange(Sender: TObject);
begin
  if FUserModType = umInsert then
    OkButton.Enabled := (UserNameEdit.Text <> '') and (PasswordEdit.Text <> '') and
      (ConfirmPasswordEdit.Text <> '');
end;

//------------------------------------------------------------------------------

procedure TUserModForm.OkButtonClick(Sender: TObject);
begin
  if PasswordEdit.Text <> ConfirmPasswordEdit.Text then
    ShowMessage('Password insert error')
  else
    Modalresult := mrOk;
end;

//------------------------------------------------------------------------------

procedure TUserModForm.FirstNameEditChange(Sender: TObject);
begin
  if FuserModType = umModify then
    OkButton.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TUserModForm.LastNameEditChange(Sender: TObject);
begin
  if FuserModType = umModify then
    OkButton.Enabled := True;
end;

procedure TUserModForm.MiddleNameEditChange(Sender: TObject);
begin
  if FuserModType = umModify then
    OkButton.Enabled := True;
end;

//------------------------------------------------------------------------------

function TUserModForm.GetUserName: string;
begin
  Result := UserNameEdit.Text;
end;

function TUserModForm.GetPassword: string;
begin
  if Length(PasswordEdit.Text) > 8 then
    Result := LeftStr(PasswordEdit.Text, 8)
  else
    Result := PasswordEdit.Text;
end;

function TUserModForm.GetFirstName: string;
begin
  Result := FirstNameEdit.Text;
end;

function TUserModForm.GetMiddleName: string;
begin
  Result := MiddleNameEdit.Text;
end;

function TUserModForm.GetLastName: string;
begin
  Result := LastNameEdit.Text;
end;

procedure TUserModForm.SetUserName(const Value: string);
begin
  UserNameEdit.Text := Value;
end;

procedure TUserModForm.SetFirstName(const Value: string);
begin
  FirstNameEdit.Text := Value;
end;

procedure TUserModForm.SetMiddleName(const Value: string);
begin
  MiddleNameEdit.Text := Value;
end;

procedure TUserModForm.SetLastName(const Value: string);
begin
  LastNameEdit.Text := Value;
end;

end.
