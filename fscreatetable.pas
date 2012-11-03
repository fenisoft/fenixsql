unit fscreatetable;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls, ButtonPanel;

type

  { TCreateTableForm }

  TCreateTableForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    AutoIncChekBox: TCheckBox;
    TableNameEdit: TEdit;
    PrimaryKeyEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure AutoIncChekBoxChange(Sender: TObject);
    procedure PrimaryKeyEditChange(Sender: TObject);
    procedure TableNameEditChange(Sender: TObject);
  private
    FAutoInc: boolean;
    { private declarations }
    function GetTableName: string;
    function GetPrimaryKey: string;
    function GetAutoInc: boolean;
  public
    { public declarations }
    property TableName: string read GetTableName;
    property PrimaryKey: string read GetPrimaryKey;
    property AutoInc: boolean read FAutoInc;
  end;

//var
//CreateTableForm: TCreateTableForm;

implementation

{$R *.lfm}

{ TCreateTableForm }


procedure TCreateTableForm.TableNameEditChange(Sender: TObject);
begin
  ButtonPanel1.OKButton.Enabled := TableNameEdit.Text <> '';
end;

procedure TCreateTableForm.PrimaryKeyEditChange(Sender: TObject);
begin
  if AutoIncChekBox.Checked then
    ButtonPanel1.OKButton.Enabled :=
      ((PrimaryKeyEdit.Text <> '') and (TableNameEdit.Text <> ''))
  else
    ButtonPanel1.OKButton.Enabled := TableNameEdit.Text <> '';
end;

procedure TCreateTableForm.AutoIncChekBoxChange(Sender: TObject);
begin
  if AutoIncChekBox.Checked then
    ButtonPanel1.OKButton.Enabled :=
      ((PrimaryKeyEdit.Text <> '') and (TableNameEdit.Text <> ''));
end;

function TCreateTableForm.GetTableName: string;
begin
  Result := TableNameEdit.Text;
end;

function TCreateTableForm.GetPrimaryKey: string;
begin
  Result := PrimaryKeyEdit.Text;
end;

function TCreateTableForm.GetAutoInc: boolean;
begin
  Result := AutoIncChekBox.Checked;
end;



end.
