(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fstablefilter.pas


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
unit fstablefilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls;

type

  { TTableFilterForm }

  TTableFilterForm = class(TForm)
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    FieldsListView: TListView;
    FilterMemo: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    Splitter1: TSplitter;
    procedure OkButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FieldsListViewDblClick(Sender: TObject);
    procedure FilterMemoChange(Sender: TObject);
  private
    { private declarations }
    FTableName: string;
    FFilter: string;
    FIsOrder: boolean;
    function GetFilter: string;
    procedure SetFilter(const Value: string);
    procedure InsertStringInMemo(const AValue: string);
    procedure LoadFieldList;
  public
    { public declarations }
    constructor Create(Aower: TComponent; ATableName: string);
      reintroduce; overload;
    property Filter: string read GetFilter write SetFilter;
    property IsOrder: boolean read FIsOrder;
  end;


implementation

{$R *.lfm}

uses
  fsdm, FBLExcept;

//------------------------------------------------------------------------------


constructor TTableFilterForm.Create(Aower: TComponent; ATableName: string);
var
  i: integer;
begin
  inherited Create(AOwer);
  FTableName := ATableName;
  FIsOrder := False;
  LoadFieldList;
end;

//------------------------------------------------------------------------------

procedure TTableFilterForm.LoadFieldList;
var
  i: integer;
  item: TListItem;
begin
  if not MainDataModule.TableViewTr.InTransaction then
    MainDataModule.TableViewTr.StartTransaction;
  MainDataModule.TableFilterQry.SQL.Text := 'select * from ' + FTableName;
  MainDataModule.TableFilterQry.Prepare;
  for i := 0 to MainDataModule.TableFilterQry.FieldCount - 1 do
  begin
    item := FieldsListView.Items.Add;
    item.Caption := MainDataModule.TableFilterQry.FieldName(i);
    item.SubItems.Add(MainDataModule.TableFilterQry.FieldSQLTypeDesc(i));
  end;
  MainDataModule.TableFilterQry.UnPrepare;
end;



//------------------------------------------------------------------------------

procedure TTableFilterForm.OkButtonClick(Sender: TObject);
begin
  if not MainDataModule.TableViewTr.InTransaction then
    MainDataModule.TableViewTr.StartTransaction;
  MainDataModule.TableFilterQry.SQL.Text :=
    'select * from ' + FTableName + ' where ' + FilterMemo.Lines.Text;
  try
    MainDataModule.TableFilterQry.Prepare;
    FisOrder := (Pos('ORDER', MainDataModule.TableFilterQry.Plan) > 0);
    MainDataModule.TableFilterQry.UnPrepare;
    FFilter := FilterMemo.Lines.Text;
    ModalResult := mrOk;
  except
    on E: EFBLError do
      ShowMessage('Error in Filter' + LineEnding +
        Format('ISC_ERROR:%d', [E.ISC_ErrorCode]) + LineEnding + E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TTableFilterForm.FormShow(Sender: TObject);
begin
  FilterMemo.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TTableFilterForm.FieldsListViewDblClick(Sender: TObject);
begin
  if FieldsListView.Selected <> nil then
  begin
    InsertStringInMemo(FieldsListView.Selected.Caption);
    FilterMemo.SetFocus;
  end;
end;

//------------------------------------------------------------------------------

procedure TTableFilterForm.FilterMemoChange(Sender: TObject);
begin
  OkButton.Enabled := (FilterMemo.Lines.Count > 0);
end;

//------------------------------------------------------------------------------

function TTableFilterForm.GetFilter: string;
begin
  Result := FilterMemo.Lines.Text;
end;


//------------------------------------------------------------------------------

procedure TTableFilterForm.SetFilter(const Value: string);
begin
  FilterMemo.Lines.Text := Value;
end;

//------------------------------------------------------------------------------

procedure TTableFilterForm.InsertStringInMemo(const AValue: string);
var
  PosMemo: integer;
  TextMemo: string;
begin
  PosMemo := FilterMemo.SelStart;
  TextMemo := FilterMemo.Lines.Text;
  Insert(AValue, TextMemo, PosMemo + 1);
  FilterMemo.Lines.Text := TextMemo;
  FilterMemo.SelStart := Length(TextMemo);
end;

end.
