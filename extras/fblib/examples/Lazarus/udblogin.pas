unit udblogin; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls;

type

  { TfrmDbLogin }

  TfrmDbLogin = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    edUser: TEdit;
    edPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 
  
function DbLogin(var AUser,APassword: string): boolean;
//var
  //frmDbLogin: TfrmDbLogin;

implementation

{ TfrmDbLogin }

function DbLogin(var AUser,APassword: string): boolean;
var
  myDialog: TfrmDBlogin;
begin
  result := False;
  myDialog := TfrmDBlogin.Create(nil);
  try
    myDialog.edUser.Text := AUser;
    myDialog.edPassword.Text := APassword;
    if myDialog.ShowModal = mrOk then
    begin
      AUser := myDialog.edUser.Text;
      APassword  := myDialog.edPassword.Text;
      Result := True;
    end;
  finally
    myDialog.Free;
  end;
end;


procedure TfrmDbLogin.FormShow(Sender: TObject);
begin
  if edUser.Text = '' then
    edUser.SetFocus
  else
   edPassword.SetFocus;
end;

initialization
  {$I udblogin.lrs}

end.

