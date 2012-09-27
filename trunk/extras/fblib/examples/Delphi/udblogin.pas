unit udblogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfrmDBlogin = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    Label1: TLabel;
    edUser: TEdit;
    edPassword: TEdit;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
  //frmDBlogin: TfrmDBlogin;

  function DbLogin(var AUser,APassword: string): boolean;


implementation

{$R *.dfm}

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

procedure TfrmDBlogin.FormShow(Sender: TObject);
begin
   if edUser.Text = '' then
       edUser.SetFocus
   else
       edPassword.SetFocus;
end;

end.
