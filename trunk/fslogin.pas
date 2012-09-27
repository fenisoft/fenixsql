(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fslogin.pas

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

unit fslogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls;

type

  { TLoginForm }

  TLoginForm = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    PasswordEdit: TLabeledEdit;
    UserEdit: TLabeledEdit;
    Label1: TLabel;
    AliasLabel: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    function GetUser: string;
    function GetPassword: string;
    procedure SetAlias(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetUser(const Value: string);
  public
    { public declarations }
    property Alias: string write SetAlias;
    property User: string read GetUser write SetUser;
    property Password: string read GetPassword write SetPassword;
  end;

//var
//LoginForm: TLoginForm;

function FbDbLogin(AAlias: string; var AUser, APassword: string): boolean;

implementation

function FbDbLogin(AAlias: string; var AUser, APassword: string): boolean;
var
  LoginForm: TLoginForm;
begin
  Result := False;
  LoginForm := TLoginForm.Create(nil);
  try
    LoginForm.Alias := AALias;
    LoginForm.User := AUser;
    LoginForm.Password := APassword;
    //LoginForm.Role := ARole;
    if LoginForm.ShowModal = mrOk then
    begin
      AUser := LoginForm.User;
      APassword := LoginForm.Password;
      //ARole := LoginForm.Role;
      Result := True;
    end;
  finally
    LoginForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TLoginForm.FormShow(Sender: TObject);
begin
  if UserEdit.Text <> '' then
    PasswordEdit.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TLoginForm.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
end;

//------------------------------------------------------------------------------

function TLoginForm.GetUser: string;
begin
  Result := UserEdit.Text;
end;

//------------------------------------------------------------------------------

function TLoginForm.GetPassword: string;
begin
  Result := PasswordEdit.Text;
end;

//------------------------------------------------------------------------------
{
function TLoginForm.GetRole: string;
begin
  Result := edRole.Text;
end;
}
//------------------------------------------------------------------------------

procedure TLoginForm.SetAlias(const Value: string);
begin
  AliasLabel.Caption := Value;
end;

//------------------------------------------------------------------------------

procedure TLoginForm.SetUser(const Value: string);
begin
  UserEdit.Text := Value;
end;

//------------------------------------------------------------------------------
{
procedure TLoginForm.SetRole(const Value: string);
begin
  edRole.Text := Value;
end;
}
//------------------------------------------------------------------------------

procedure TLoginForm.SetPassword(const Value: string);
begin
  PasswordEdit.Text := Value;
end;

//------------------------------------------------------------------------------

initialization
  {$I fslogin.lrs}

end.
