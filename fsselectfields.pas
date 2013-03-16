unit fsselectfields;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ButtonPanel,
  CheckLst;

type

  { TSelectFieldsForm }

  TSelectFieldsForm = class(TForm)
    ButtonPanel1: TButtonPanel;
    FieldsCheckList: TCheckListBox;
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    FTableName: string;
    procedure LoadList;
  public
    property TableName: string  read   FTableName write   FTableName;
  end;

//var
  //SelectFieldsForm: TSelectFieldsForm;

implementation


{$R *.lfm}
uses fsdm;
{ TSelectFieldsForm }



procedure TSelectFieldsForm.FormShow(Sender: TObject);
begin
  LoadList;
end;

procedure TSelectFieldsForm.LoadList;
var
  i: Integer;
begin
   if not MainDataModule.BrowserTr.InTransaction then
        MainDataModule.BrowserTr.StartTransaction;
      MainDataModule.BrowserQry.SQL.Text := 'select * from ' +   FTableName;
      MainDataModule.BrowserQry.Prepare;
   for i:=0 to MainDataModule.BrowserQry.FieldCount -1 do
   begin
      FieldsCheckList.Items.Add(MainDataModule.BrowserQry.FieldName(i));
   end;
end;

end.

