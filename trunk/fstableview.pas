(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fstableview.pas


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

unit fstableview;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ComCtrls,
  Grids, ActnList, Math, Menus;

type

  { TTableViewForm }

  TTableViewForm = class(TForm)
    ViewBlobAction: TAction;
    RefreshAction: TAction;
    RemoveFilterAction: TAction;
    FilterAction: TAction;
    FetchNextAction: TAction;
    ActionList1: TActionList;
    tableViewImageList: TImageList;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    SaveDialog: TSaveDialog;
    BlobSaveDialog: TSaveDialog;
    sbTableView: TStatusBar;
    DataStringGrid: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure FetchNextActionExecute(Sender: TObject);
    procedure FilterActionExecute(Sender: TObject);
    procedure RefreshActionExecute(Sender: TObject);
    procedure RemoveFilterActionExecute(Sender: TObject);
    procedure ViewBlobActionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tableViewImageListChange(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure DataStringGridDblClick(Sender: TObject);
    procedure DataStringGridMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure DataStringGridSelectCell(Sender: TObject; Col, Row: integer;
      var CanSelect: boolean);

  private
    { private declarations }
    FTableName: string;
    FDbKey: TStringList;
    FRecCount: integer;
    FBlobCellSelected: boolean;
    FFilter: string;
    FIsOrder: boolean;
    function AbjustColWidth(const ACol: integer): integer;
    procedure ClearGrid;
    procedure FetchGrid;
    procedure PrepareGrid;
    procedure BlobView(const ADbKey, AFieldName: string);
    procedure ExecuteSql;
  public
    { public declarations }
    property TableName: string read FTableName write FTableName;
  end;


const
  MAX_ROWS = 500;
    {$IFDEF UNIX}
  ROW_H = 5;
    {$ELSE}
  ROW_H = 2;
    {$ENDIF}
  DEFAULT_HEIGHT = 320;
  DEFAULT_WIDTH = 580;

implementation

{$R *.lfm}

uses
  ibase_h, fsdm, fstablefilter, fsblobviewdialog, fsblobtext, fsconfig, fsmixf;

{ TTableViewForm }


//------------------------------------------------------------------------------

function TTableViewForm.AbjustColWidth(const ACol: integer): integer;
var
  wn, wt: integer;
begin
  wn := DataStringGrid.Canvas.TextWidth(MainDataModule.TableViewQry.FieldName(ACol));
  case MainDataModule.TableViewQry.FieldType(ACol) of
    SQL_SHORT:
      wt := DataStringGrid.Canvas.TextWidth('-32768.');
    SQL_LONG:
      wt := DataStringGrid.Canvas.TextWidth('-2147483648.');
    SQL_INT64,
    SQL_FLOAT,
    SQL_D_FLOAT,
    SQL_DOUBLE:
      wt := DataStringGrid.Canvas.TextWidth(StringOfChar('9', 16));
    SQL_VARYING, SQL_TEXT:
    begin
      if MainDataModule.TableViewQry.FieldSize(ACol) < 70 then
        wt := DataStringGrid.Canvas.TextWidth(StringOfChar('X',
          MainDataModule.TableViewQry.FieldSize(ACol)))
      else
        wt := DataStringGrid.Canvas.TextWidth(StringOfChar('X', 70));
    end;
    SQL_BLOB:
      wt := DataStringGrid.Canvas.TextWidth('(BLOB) ');
    SQL_ARRAY:
      wt := DataStringGrid.Canvas.TextWidth('(ARRAY)');
    SQL_TIMESTAMP:
      wt := DataStringGrid.Canvas.TextWidth(DateTimeToStr(now));
    SQL_TYPE_TIME:
      wt := DataStringGrid.Canvas.TextWidth(TimeToStr(now));
    SQL_TYPE_DATE:
      wt := DataStringGrid.Canvas.TextWidth(DateToStr(now));
    else
      wt := 100;
  end;
  Result := IfThen(wt > wn, wt, wn) + 2;
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.ClearGrid;
{
var
  i: Integer;
  Head: TStringList;}
begin
  {
  Head := TStringList.Create;
  try
    Head.Assign(DataStringGrid.Rows[0]);
    for i := 0 to DataStringGrid.ColCount - 1 do
    begin
      DataStringGrid.Cols[i].BeginUpdate;
      DataStringGrid.Cols[i].Clear;
      DataStringGrid.Cols[i].EndUpdate;
    end;
    DataStringGrid.Rows[0].Assign(Head);
    DataStringGrid.RowCount := 2;

  finally
    Head.Free;
  end; }
  DataStringGrid.Clean;
end;


//------------------------------------------------------------------------------

procedure TTableViewForm.FetchNextActionExecute(Sender: TObject);
//var
//Head : TStringList;
begin
  //Head := TStringList.Create;
  //try
  //Head.Assign(DataStringGrid.Rows[0]);
  //ClearGrid;
  DataStringGrid.Clean([gzNormal]);
  FetchNextAction.Enabled := False;
  FetchGrid;
  //DataStringGrid.Rows[0].Assign(head);
  //finally
  //head.Free;
  //end;
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.PrepareGrid;
var
  i: integer;
begin
  FRecCount := 0;
  DataStringGrid.ColCount := MainDataModule.TableViewQry.FieldCount;
  DataStringGrid.RowCount := 2;
  DataStringGrid.DefaultRowHeight := DataStringGrid.Canvas.TextHeight('X') + ROW_H;
  for i := 0 to MainDataModule.TableViewQry.FieldCount - 1 do
  begin
    if i = 0 then
    begin
      DataStringGrid.Cells[i, 0] := 'REC. #';
      DataStringGrid.ColWidths[i] := DataStringGrid.Canvas.TextWidth('REC. ####') + 2;
    end
    else
    begin
      DataStringGrid.Cells[i, 0] := MainDataModule.TableViewQry.FieldName(i);
      DataStringGrid.Cells[i, 1] := '';
      DataStringGrid.ColWidths[i] := AbjustColWidth(i);
    end;
  end;
end;

//------------------------------------------------------------------------------


procedure TTableViewForm.FetchGrid;
var
  i: integer;
  nRows: integer;
begin
  FDBKey.Clear;
  nRows := 0;
  DataStringGrid.RowCount := MAX_ROWS + 1;

  while not MainDataModule.TableViewQry.EOF do
  begin
    Inc(FRecCount);
    for i := 0 to MainDataModule.TableViewQry.FieldCount - 1 do
    begin
      if i = 0 then
      begin
        DataStringGrid.Cells[i, nRows + 1] := IntToStr(FRecCount);
        FDBKey.Add(MainDataModule.TableViewQry.FieldAsString(i));
      end
      else
      begin
        //DataStringGrid.RowCount :=  DataStringGrid.RowCount + 1;
        if MainDataModule.TableViewQry.FieldIsNull(i) then
          DataStringGrid.Cells[i, nROws + 1] := ''
        else
        begin
          case MainDataModule.TableViewQry.FieldType(i) of
            SQL_BLOB:
              if MainDataModule.TableViewQry.FieldSubType(i) = 1 then
                DataStringGrid.Cells[i, nRows + 1] := '(Memo)'
              else
                DataStringGrid.Cells[i, nRows + 1] := '(Blob)';

            SQL_ARRAY:
              //DataStringGrid.Cells[i, FRowsInGrid] := dmib.qryTableView.FieldAsString(i);
              DataStringGrid.Cells[i, nRows + 1] := '(Array)';
            SQL_INT64, SQL_LONG, SQL_SHORT, SQL_DOUBLE, SQL_FLOAT, SQL_D_FLOAT:
              if MainDataModule.TableViewQry.FieldScale(i) <> 0 then
                DataStringGrid.Cells[i, nRows + 1] :=
                  FormatNumericValue(MainDataModule.TableViewQry.FieldAsDouble(i),
                  MainDataModule.TableViewQry.FieldScale(i))
              else
                DataStringGrid.Cells[i, nRows + 1] :=
                  MainDataModule.TableViewQry.FieldAsString(i);
            else
              DataStringGrid.Cells[i, nRows + 1] :=
                MainDataModule.TableViewQry.FieldAsString(i);
          end;
        end;
      end;
    end;   // end for
    Inc(nRows);
    if nRows = MAX_ROWS then
    begin
      FetchNextAction.Enabled := True;
      MainDataModule.TableViewQry.Next;
      Break;
    end
    else
      MainDataModule.TableViewQry.Next;
  end;

  if nRows <= 1 then
    DataStringGrid.RowCount := 2
  else
    DataStringGrid.RowCount := nRows + 1;
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.ExecuteSql;
var
  SqlText, SqlNumRecord: string;
begin

  if FFilter = '' then
  begin
    SqlText := 'Select RDB$DB_KEY ,' + FTableName + '.*  from ' + FTableName;
    SqlNumRecord := 'Select count(*) from ' + FTableName;
  end
  else
  begin
    SqlText := 'Select RDB$DB_KEY ,' + FTableName + '.*  from ' +
      FTableName + ' where ' + FFilter;
    if not FisOrder then
      SqlNumRecord := 'Select count(*) from ' + FTableName + ' where ' + FFilter;
  end;

  try

    Screen.Cursor := crSQLWait;
    if not MainDataModule.TableViewTr.InTransaction then
      MainDataModule.TableViewTr.StartTransaction;
    if MainDataModule.TableViewQry.Prepared then
      MainDataModule.TableViewQry.UnPrepare;
    MainDataModule.TableViewQry.SQL.Text := SqlNumRecord;
    MainDataModule.TableViewQry.ExecSQL;

    sbTableView.Panels[0].Text :=
      Format('Total records : %d', [MainDataModule.TableViewQry.FieldAsInteger(0)]);
    MainDataModule.TableViewQry.UnPrepare;
    FRecCount := 0;
    FetchNextAction.Enabled := False;
    if MainDataModule.TableViewQry.Prepared then
      MainDataModule.TableViewQry.UnPrepare;
    MainDataModule.TableViewQry.SQL.Text := SqlText;
    MainDataModule.TableViewQry.Prepare;
    ClearGrid;
    PrepareGrid;
    MainDataModule.TableViewQry.ExecSQL;
    FetchGrid;
  finally
    Screen.Cursor := crDefault;
  end;
end;


//------------------------------------------------------------------------------

procedure TTableViewForm.FilterActionExecute(Sender: TObject);
var
  TableFilterForm: TTableFilterForm;
begin
  TableFilterForm := TTableFilterForm.Create(self, FTableName);
  try
    TableFilterForm.Caption := 'Set table filter :: ' + FTableName;
    TableFilterForm.Filter := FFilter;
    if TableFilterForm.ShowModal = mrOk then
    begin
      FFilter := TableFilterForm.Filter;
      FIsOrder := TableFilterForm.IsOrder;
      ExecuteSql;
      FilterAction.Hint := 'Filter: Active' + #10 + FFilter;
      RemoveFilterAction.Enabled := True;
    end;
  finally
    TableFilterForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.RefreshActionExecute(Sender: TObject);
begin
  ExecuteSql;
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.RemoveFilterActionExecute(Sender: TObject);
begin
  FFilter := '';
  FilterAction.Hint := 'Set Filter';
  ExecuteSql;
  RemoveFilterAction.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.ViewBlobActionExecute(Sender: TObject);
begin
  if FBlobCellSelected then
    BlobView(FdbKey.Strings[DataStringGrid.row - 1],
      DataStringGrid.Cells[DataStringGrid.Col, 0]);
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if MainDataModule.TableViewTr.InTransaction then
    MainDataModule.TableViewTr.Commit;
  fsconfig.SaveFormPos(self);
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.FormCreate(Sender: TObject);
begin
  FDbKey := TStringList.Create;
  FFilter := '';
  FBlobCellSelected := False;
  FetchNextAction.Hint := Format('Fetch next %d record', [MAX_ROWS]);
  Self.Top := (Screen.Height - DEFAULT_HEIGHT) div 2;
  Self.Left := (Screen.Width - DEFAULT_WIDTH) div 2;
  Self.Height := DEFAULT_HEIGHT;
  Self.Width := DEFAULT_WIDTH;
  fsconfig.LoadFormPos(Self);
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.FormDestroy(Sender: TObject);
begin
  FDbKey.Free;
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.FormShow(Sender: TObject);
begin
  Caption := 'View Data Table :: ' + FTableName;
  ExecuteSql;
end;

procedure TTableViewForm.tableViewImageListChange(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------

procedure TTableViewForm.MenuItem10Click(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.DataStringGridDblClick(Sender: TObject);
begin
  if FBlobCellSelected then
    BlobView(FdbKey.Strings[DataStringGrid.row - 1],
      DataStringGrid.Cells[DataStringGrid.Col, 0]);
end;


//------------------------------------------------------------------------------

procedure TTableViewForm.DataStringGridMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: integer);
var
  c, r: integer;
begin
  DataStringGrid.MouseToCell(X, Y, c, r);
  if (c > 0) and (r > 0) then
  begin
    if (DataStringGrid.Cells[c, r] = '(Memo)') or
      (DataStringGrid.Cells[c, r] = '(Blob)') then
    begin
      DataStringGrid.Cursor := crHandPoint;
    end
    else
    begin
      DataStringGrid.Cursor := crDefault;
    end;
  end
  else
  begin
    DataStringGrid.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------

procedure TTableViewForm.DataStringGridSelectCell(Sender: TObject;
  Col, Row: integer; var CanSelect: boolean);
begin
  FBlobCellSelected := (DataStringGrid.Cells[Col, Row] = '(Memo)') or
    (DataStringGrid.Cells[Col, Row] = '(Blob)');
  ViewBlobAction.Enabled := FBlobCellSelected;
end;

//------------------------------------------------------------------------------


procedure TTableViewForm.BlobView(const AdbKey, AFieldName: string);
var
  BlobViewDialogForm: TBlobViewDialogForm;
begin
  BlobViewDialogForm := TBlobViewDialogForm.Create(self);
  try
    if not MainDataModule.BlobViewTr.InTransaction then
      MainDataModule.BlobViewTr.StartTransaction;
    MainDataModule.BlobViewQry.SQL.Text :=
      'Select ' + AFieldName + ' from ' + FTableName + ' where RDB$DB_KEY = ?';
    MainDataModule.BlobViewQry.Prepare;
    MainDataModule.BlobViewQry.ParamAsString(0, ADbkey);
    MainDataModule.BlobViewQry.ExecSQL;
    BlobViewDialogForm.FieldName := MainDataModule.BlobViewQry.FieldName(0);
    BlobViewDialogForm.BlobType := MainDataModule.BlobViewQry.FieldSubType(0);
    if BlobViewDialogForm.ShowModal = mrOk then
    begin
      if BlobViewDialogForm.BlobType = 1 then
        FsBlobText.ViewBlobText(MainDataModule.BlobViewQry.BlobFieldAsString(0))
      else
      begin
        if BlobSaveDialog.Execute then
        begin
          MainDataModule.BlobViewQry.BlobFieldSaveToFile(0, BlobSaveDialog.FileName);
        end;
      end;
    end;
    MainDataModule.BlobViewQry.UnPrepare;
    MainDataModule.BlobViewTr.RollBack;
  finally
    BlobViewDialogForm.Free;
  end;
end;


end.
