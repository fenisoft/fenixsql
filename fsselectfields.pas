unit fsselectfields;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ButtonPanel,
  CheckLst, StdCtrls, Menus, ActnList;

type

  { TSelectFieldsForm }

  TSelectFieldsForm = class(TForm)
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    SelectAllAction: TAction;
    UnSelectAllAction: TAction;
    ActionList1: TActionList;
    ButtonPanel1: TButtonPanel;
    FieldsCheckList: TCheckListBox;
    PopupMenu1: TPopupMenu;
    procedure FieldsCheckListClickCheck(Sender: TObject);
    procedure UnSelectAllActionExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SelectAllActionExecute(Sender: TObject);
  private
    { private declarations }
    FTableName: string;
    procedure LoadList;
    function CheckChecked: boolean;
  public
    property TableName: string read FTableName write FTableName;
  end;


function GetFieldsFromTable(const ATableName: string; AFields: TStringList): boolean;

implementation

{$R *.lfm}

uses fsdm;

function GetFieldsFromTable(const ATableName: string; AFields: TStringList): boolean;
var
  SelectFieldsForm: TSelectFieldsForm;
  i: integer;
begin
  Result := False;
  SelectFieldsForm := TSelectFieldsForm.Create(nil);
  SelectFieldsForm.TableName := ATableName;
  try
    if SelectFieldsForm.ShowModal = mrOk then
    begin
      for i := 0 to SelectFieldsForm.FieldsCheckList.Items.Count - 1 do
        if SelectFieldsForm.FieldsCheckList.Checked[i] then
          AFields.Add(SelectFieldsForm.FieldsCheckList.Items.Strings[i]);
    end;
  finally
    SelectFieldsForm.Free;
  end;
end;

procedure TSelectFieldsForm.FormShow(Sender: TObject);
begin
  LoadList;
end;

procedure TSelectFieldsForm.UnSelectAllActionExecute(Sender: TObject);
begin
  FieldsCheckList.CheckAll(cbUnchecked);
  ButtonPanel1.OKButton.Enabled := False;
end;

procedure TSelectFieldsForm.FieldsCheckListClickCheck(Sender: TObject);
begin
  ButtonPanel1.OKButton.Enabled := CheckChecked;
end;


procedure TSelectFieldsForm.SelectAllActionExecute(Sender: TObject);
begin
  FieldsCheckList.CheckAll(cbChecked);
  ButtonPanel1.OKButton.Enabled := True;
end;

procedure TSelectFieldsForm.LoadList;
var
  i: integer;
begin
  if not MainDataModule.BrowserTr.InTransaction then
    MainDataModule.BrowserTr.StartTransaction;
  MainDataModule.BrowserQry.SQL.Text := 'select * from ' + FTableName;
  MainDataModule.BrowserQry.Prepare;
  for i := 0 to MainDataModule.BrowserQry.FieldCount - 1 do
  begin
    FieldsCheckList.Items.Add(MainDataModule.BrowserQry.FieldName(i));
    FieldsCheckList.Checked[i] := True;
  end;
end;

function TSelectFieldsForm.CheckChecked: boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to FieldsCheckList.Items.Count - 1 do
  begin
    if FieldsCheckList.Checked[i] then
    begin
      Result := True;
      Break;
    end;
  end;
end;

end.

