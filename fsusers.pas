(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsusers.pas

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
unit fsusers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls,
  StdCtrls, Buttons, FBLExcept, FBLService;

type

  { TUsersForm }

  TUsersForm = class(TForm)
    CloseButton: TBitBtn;
    AddButton: TButton;
    ModifyButton: TButton;
    DeleteButton: TButton;
    RefreshButton: TButton;
    GroupBox1: TGroupBox;
    UsersListBox: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    procedure AddButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure ModifyButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    {private declarations }
    FUser, FPassword: string;
    FLocalConnection: boolean;
    FBLService1: TFBLService;

  public
    { public declarations }
    constructor Create(Aower: TComponent; AUser, APassword: string);
      reintroduce; overload;
    function TryFetchList: boolean;
  end;


implementation

{$R *.lfm}

uses
  fsusermod;

//------------------------------------------------------------------------------

procedure TUsersForm.AddButtonClick(Sender: TObject);
var
  UserModForm: TUserModForm;
begin
  UserModForm := TUserModForm.Create(self);
  try
    UserModForm.UserModeType := umInsert;
    if UserModForm.ShowModal = mrOk then
    begin
      try
        FBLService1.AddUser(UserModForm.UserName, UserModForm.PassWord,
          UserModForm.FirstName,
          UserModForm.MiddleName, UserModForm.LastName);
        ShowMessage('User "' + UserModForm.UserName + '" added');
        TryFetchList;
      except
        on E: EFBLError do
          ShowMessage(E.Message);
      end;
    end;
  finally
    UserModForm.Free;
  end;
end;


//------------------------------------------------------------------------------

procedure TUsersForm.DeleteButtonClick(Sender: TObject);
var
  UserName: string;
begin
  UserName := UsersListBox.Items.Strings[UsersListBox.ItemIndex];
  if MessageDlg('Delete user ' + UserName + #10 + 'Are You sure ?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FBLService1.DeleteUser(UserName);
      ShowMessage('User "' + UserName + '" deleted');
      TryFetchList;
    except
      on
        E: EFBLError do
        ShowMessage(E.Message);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TUsersForm.ModifyButtonClick(Sender: TObject);
var
  UserModForm: TUserModForm;
  UserName, FirstName, MidName, LastName: string;
  UserID, GroupId: longint;
begin
  UserModForm := TUserModForm.Create(self);
  try
    UserName := UsersListBox.Items[UsersListBox.ItemIndex];
    try
      FBLService1.ViewUser(UserName, FirstName, MidName, LastName, UserId, GroupId);
      UserModForm.UserName := UserName;
      UserModForm.FirstName := FirstName;
      UserModForm.MiddleName := MidName;
      UserModForm.LastName := LastName;
      UserModForm.UserModeType := umModify;
      if UserModForm.ShowModal = mrOk then
      begin
        FBLService1.ModifyUser(UserModForm.UserName, UserModForm.PassWord,
          UserModForm.FirstName, UserModForm.MiddleName, UserModForm.LastName);
        ShowMessage('User "' + UserName + '" Modified');
      end;
    except
      on
        E: EFBLError do
        ShowMessage(E.Message);
    end;
  finally
    UserModForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TUsersForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if fblservice1.Connected then
    fblservice1.Disconnect;
end;

procedure TUsersForm.FormCreate(Sender: TObject);
begin
  FBLService1 := TFBLService.Create(nil);
end;

procedure TUsersForm.FormDestroy(Sender: TObject);
begin
  FBLService1.Free;
end;

//------------------------------------------------------------------------------

constructor TUsersForm.Create(AOwer: TComponent; AUser, Apassword: string);
begin
  inherited Create(AOwer);
  Fuser := AUser;
  FPassword := APassword;
end;

//------------------------------------------------------------------------------

function TUsersForm.TryFetchList: boolean;
begin
  Result := False;
  if not fblservice1.Connected then
  begin
    fblservice1.Host := '127.0.0.1'; // localhost
    fblservice1.Protocol := FBLService.sptTcpIp;
    fblservice1.User := FUser;
    fblservice1.Password := FPassword;
  end;
  try
    if not fblservice1.Connected then
      fblservice1.Connect;

    UsersListBox.items.Assign(fblservice1.UserNames);
    if UsersListBox.Items.Count > 0 then
      UsersListBox.ItemIndex := 0;
    Result := True;

  except
    on E: EFBLError do
      MessageDlg(Format('Error number: %d ' + LineEnding + 'Sql Error: %d' +
        LineEnding + LineEnding + E.Message, [E.ISC_errorCode, E.SqlCode]),
        mtError, [mbOK], 0);
  end;
end;


end.
