(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file: fsbrowser.pas


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

unit fsbrowser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  SynMemo, ComCtrls, ActnList, Menus, StdCtrls, Grids, StdActns,
  SynEdit, FBLDatabase, FBLDsql, FBLExcept,
  FBLTextGridExport, ibase_h, FBLmixf, Math, FBLScript, SynEditMiscClasses, SynEditMarkupSpecialLine;

type

  TColDesc = record
    intType, Subtype: smallint;
  end;

  TScriptStat = record
    stm_count, ins_rows, del_rows, upg_rows, ddl_cmds: integer;
    start_t, end_t: TDatetime;
  end;

  TNodeDesc = class         //store information for each node
  private
    FNodeType: integer;
    FObjName: string;
    FObjDesc: string;
  public
    constructor Create(ANodeType: integer; AObjName, AObjDesc: string);
    property NodeType: integer read FNodeType write FNodeType;
    property ObjName: string read FObjName write FObjName;
    property ObjDesc: string read FObjDesc write FObjDesc;
  end;

  type

  { TScriptStm }

 TScriptStm = class
  private
    FLineStart: Integer;
    FStm: string;
  public
    constructor Create(ALineStart: Integer;const AStm:string);
    property LineStart: Integer read FLineStart write FLineStart;
    property Stm: string read FStm write FStm;
  end;

  { TBrowserForm }

  TBrowserForm = class(TForm)
    MenuItem50: TMenuItem;
    SqlCreateTableAutoInc: TAction;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    SqlCreateTableAction: TAction;
    ResultSetToJson: TAction;
    ResultSetToCsv: TAction;
    ExportToJsonAction: TAction;
    ExportToCsvAction: TAction;
    CommitAction: TAction;
    ClearHistoryAction: TAction;
    BackupDatabaseAction: TAction;
    CreateDbAction: TAction;
    ClearMessagesAction: TAction;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem9: TMenuItem;
    SelectAllSynMemoAction: TAction;
    DbConnectionsAction: TAction;
    ShowAboutAction: TAction;
    ToolBar2: TToolBar;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    MessagesTreeView: TTreeView;
    UsersAction: TAction;
    ServiceMgrAction: TAction;
    ShowTextOptionsAction: TAction;
    ShowOptionsAction: TAction;
    ShowOptionDescriptionAction: TAction;
    GrantMgrAction: TAction;
    ExportToSqlAction: TAction;
    ViewDataAction: TAction;
    DisconnectAction: TAction;
    RefreshAllAction: TAction;
    NextAction: TAction;
    PreviousAction: TAction;
    MetadataExtractAction: TAction;
    ExecSqlScriptAction: TAction;
    ExecSqlAction: TAction;
    RollBackAction: TAction;
    SaveScriptAction: TAction;
    OpenScriptAction: TAction;
    NewScriptAction: TAction;
    ActionList1: TActionList;
    EditCopyAction: TEditCopy;
    EditCutAction: TEditCut;
    EditPasteAction: TEditPaste;
    BrowserImageList: TImageList;
    TreeViewImageList: TImageList;
    lTitle: TLabel;
    ValuesListView: TListView;
    DdlSynMemo: TSynMemo;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuExit: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    ResultSetSynMemo: TSynMemo;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    PlanMemo: TMemo;
    SqlSynEdit: TSynEdit;
    MainPageControl: TPageControl;
    FieldsStringGrid: TStringGrid;
    ResultSetStringGrid: TStringGrid;
    SqlEditPanel: TPanel;
    sbarEdit: TStatusBar;
    ParamsStringGrid: TStringGrid;
    Splitter1: TSplitter;
    sqlPageControl: TPageControl;
    SqlDownPanel: TPanel;
    ItemPopUpMenu: TPopupMenu;
    DbPopUpMenu: TPopupMenu;
    SynMemoPopUpMenu: TPopupMenu;
    MessagesPopUpMenu: TPopupMenu;
    pTitle: TPanel;
    sbtvDb: TStatusBar;
    DdlTabSheet: TTabSheet;
    SqlTabSheet: TTabSheet;
    messagesTabSheet: TTabSheet;
    planTabSheet: TTabSheet;
    paramsTabSheet: TTabSheet;
    MenuItem1: TMenuItem;
    MainMenu: TMainMenu;
    OpenDialog: TOpenDialog;
    pListView: TPanel;
    pOut: TPanel;
    SaveDialog: TSaveDialog;
    slpMain: TSplitter;
    ResultSetTabSheet: TTabSheet;
    FieldCountTabSheet: TTabSheet;
    ToolBar1: TToolBar;
    ToolBarMain: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    DbTreeView: TTreeView;
    procedure ClearMessagesActionExecute(Sender: TObject);
    procedure CreateDbActionExecute(Sender: TObject);
    procedure DbConnectionsActionExecute(Sender: TObject);
    procedure ExportToCsvActionExecute(Sender: TObject);
    procedure ExportToJsonActionExecute(Sender: TObject);
    procedure ExportToSqlActionExecute(Sender: TObject);
    procedure ResultSetToCsvExecute(Sender: TObject);
    procedure ResultSetToJsonExecute(Sender: TObject);
    procedure ServiceMgrActionExecute(Sender: TObject);
    procedure ShowAboutActionExecute(Sender: TObject);
    procedure ShowOptionDescriptionActionExecute(Sender: TObject);
    procedure ShowOptionsActionExecute(Sender: TObject);
    procedure ShowTextOptionsActionExecute(Sender: TObject);
    procedure SqlCreateTableActionExecute(Sender: TObject);
    procedure SqlCreateTableAutoIncExecute(Sender: TObject);
    procedure SqlSynEditSpecialLineColors(Sender: TObject; Line: integer;
      var Special: boolean; var FG, BG: TColor);
    procedure UsersActionExecute(Sender: TObject);
    procedure ViewDataActionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BackupDatabaseActionExecute(Sender: TObject);
    procedure ClearHistoryActionExecute(Sender: TObject);
    procedure CommitActionExecute(Sender: TObject);
    procedure DisconnectActionExecute(Sender: TObject);
    procedure ExecSqlActionExecute(Sender: TObject);
    procedure ExecSqlScriptActionExecute(Sender: TObject);
    procedure MetadataExtractActionExecute(Sender: TObject);
    procedure NewScriptActionExecute(Sender: TObject);
    procedure NextActionExecute(Sender: TObject);
    procedure OpenScriptActionExecute(Sender: TObject);
    procedure PreviousActionExecute(Sender: TObject);
    procedure RefreshAllActionExecute(Sender: TObject);
    procedure RollBackActionExecute(Sender: TObject);
    procedure SaveScriptActionExecute(Sender: TObject);
    procedure MainPageControlChange(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure SelectAllSynMemoActionExecute(Sender: TObject);
    procedure SqlSynEditChange(Sender: TObject);
    procedure SqlSynEditClick(Sender: TObject);
    procedure SqlSynEditKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure nbMainPageChanged(Sender: TObject);
    procedure DbTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure DbTreeViewClick(Sender: TObject);
    procedure DbTreeViewDblClick(Sender: TObject);
    procedure DbTreeViewMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure DbTreeViewMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
  private
    FParamValue: array of string;
    FColDesc: array of TColDesc;
    FHistory: TStringList;
    FHistoryIdx: integer;
    FScriptStat: TScriptStat;
    FCurrentAlias: string;
    {Database Objects List}
    FDomainList: TStringList;
    FTableList: TStringList;
    FViewList: TStringList;
    FProcList: TStringList;
    FTriggerList: TStringList;
    FGeneratorList: TStringList;
    FUdfList: TStringList;
    FExceptionList: TStringList;
    FRoleList: TStringList;
    FSysTableList: TStringList;
    FSysTriggerList: TStringList;
    FExecutedDDLStm: boolean;
    Script: TFBLScript;
    {$IFDEF UNIX}
    FNeedRefresh: boolean;
    {$ENDIF}
    FErrorDllNotFound: boolean;
    FLineWithError: Integer;
    procedure DoAfterDisconnect;
    procedure CarretPos;
    procedure EndTr(ATrCommit: boolean = False); //False rollback (default) True commit
    procedure RefreshStatusBar;
    procedure StartTr;
    procedure FetchFieldsGrid;
    procedure FetchParamGrid;
    procedure InsertParams;
    procedure ClearDataGrid;
    procedure FetchDataGrid;
    procedure AddtoHistory(const AStm: string);
    procedure ShowBuffer;
    procedure LoadDbTreeView;
    procedure ClearDbTreeView;
    procedure LoadLists;
    procedure TreeViewEvents(ANode: TTreeNode);
    procedure ShowValues;
    procedure ShowDatabaseItems;
    procedure ShowListObject(const AObjType: integer; const AOption: string = '');
    procedure ShowDependencies(const ASqlObj: string);
    procedure ShowPrivileges(const ASqlObj: string);
    procedure DoAfterConnect;
    procedure LoadFontColor;
    procedure SetOutputType(const AType: integer);
    function ExecuteSQL(const ASqlText: string; const AVerbose: boolean; ALineStart: Integer = 0): boolean;
    function AbjustColWidth(const ACol: integer): integer;
    procedure ShowTableView(const ATableName: string);
    procedure ShowObjectDescription(const AType: integer; const ASqlObject: string);
    procedure LogMessage(const AMsg: string; AImageIndex: integer = -1);
    procedure LogErrorMessage(const AMsg: string; const AErrorMsg: string;
      AImageIndex: integer = -1; AImageErrorIndex: integer = -1);
    procedure EditLineError(ALineError: Integer);
    procedure EditResetError;
  public
    { public declarations }
  end;


const
  (*  tree view node name  *)
  CDOMAINS = 'Domains';
  CTABLES = 'Tables';
  CVIEWS = 'Views';
  CPROCEDURES = 'Procedures';
  CTRIGGERS = 'Triggers';
  CGENERATORS = ' Generators';
  CUDFS = 'UDFs';
  CEXCEPTIONS = 'Exceptions';
  CROLES = 'Roles';
  CSYSTEMTABLES = 'System Tables';
  CSYSTEMTRIGGERS = 'System Triggers';
  CDEP = 'Dependencies';
  CPRIV = 'Privileges';

  (* tree view item type *)
  CNT_DATABASE = 0;
  CNT_DOMAINS = 1;
  CNT_DOMAIN = 2;
  CNT_TABLES = 3;
  CNT_TABLE = 4;
  CNT_VIEWS = 5;
  CNT_VIEW = 6;
  CNT_PROCEDURES = 7;
  CNT_PROCEDURE = 8;
  CNT_TRIGGERS = 9;
  CNT_TRIGGER = 10;
  CNT_GENERATORS = 11;
  CNT_GENERATOR = 12;
  CNT_UDFS = 13;
  CNT_UDF = 14;
  CNT_EXCEPTIONS = 15;
  CNT_EXCEPTION = 16;
  CNT_ROLES = 17;
  CNT_ROLE = 18;
  CNT_DEP = 19;
  CNT_PRIV = 20;
  CNT_SYSTABLES = 21;
  CNT_SYSTABLE = 22;
  CNT_SYSTRIGGERS = 23;
  CNT_SYSTRIGGER = 24;
  CNT_TRIGGERSINTABLE = 25;

  (* Tree Views Bitmaps *)
  BMP_NONE = -1;
  BMP_DOMAIN = 0;
  BMP_TABLE = 1;
  BMP_VIEW = 2;
  BMP_PROCEDURE = 3;
  BMP_TRIGGER = 4;
  BMP_GENERATOR = 5;
  BMP_UDF = 6;
  BMP_SYSTEMTABLE = 7;
  BMP_DEP = 8;
  BMP_EXCEPTION = 9;
  BMP_ROLE = 10;
  BMP_SYSTEMTRIGGER = 11;
  BMP_DATABASE = 12;
  BMP_PRIV = 13;
  {$IFDEF UNIX}
  ROW_H = 5;
  {$ELSE}
  ROW_H = 2;
  {$ENDIF}

  DEFAULT_HEIGHT = 500;
  DEFAULT_WIDTH = 640;

  {Treeview messages bitmpas}
  BMP_TVM_COMMIT = 4;
  BMP_TVM_ROLLBACK = 5;
  BMP_TVM_ERROR = 25;
  BMP_TVM_ERR_MSG = 26;
  BMP_TVM_CLOCK = 27;
  BMP_TVM_STATE = 28;
  BMP_TVM_NOTE = 29;
  BMP_TVM_UNKNOW = 30;

var
  BrowserForm: TBrowserForm;

implementation

{$R *.lfm}

uses
  fsdm, fsconfig, fsmixf, fsparaminput, fsblobinput, fsblobtext, fslogin,
  fsdialogtran, fstableview, fscreatedb, fsdescription, fsoptions,
  fstextoptions, fsservice, fsusers, fsbackup, fsabout, fsdbconnections,
  fsexport, fsmessages, fssqlcodetemplate;

{ TScriptStm }

constructor TScriptStm.Create(ALineStart: Integer; const AStm: string);
begin
  FLineStart := ALineStart;
  FStm := AStm;
end;

{ TNodeDesc }

constructor TNodeDesc.Create(ANodeType: integer; AObjName, AObjDesc: string);
begin
  FNodeType := ANodeType;
  FObjName := AObjName;
  FObjDesc := AObjDesc;
end;

{ TBrowserForm }

{private functions procedures}

//------------------------------------------------------------------------------

procedure TBrowserForm.DoAfterDisconnect;
begin
  SqlTabSheet.TabVisible := False;
  ResultSetTabSheet.TabVisible := False;
  FieldCountTabSheet.TabVisible := False;
  paramsTabSheet.TabVisible := False;
  NewScriptAction.Enabled := False;
  OpenScriptAction.Enabled := False;
  SaveScriptAction.Enabled := False;
  CommitAction.Enabled := False;
  RollBackAction.Enabled := False;
  ExecSqlAction.Enabled := False;
  ExecSqlScriptAction.Enabled := False;
  MetadataExtractAction.Enabled := False;
  ClearHistoryAction.Enabled := False;
  FCurrentAlias := '';
  FHistory.Clear;
  FHistoryIdx := 0;
  PreviousAction.Enabled := False;
  NextAction.Enabled := False;
  SqlSynEdit.Lines.Clear;
  BackupDatabaseAction.Enabled := False;
  {$IFDEF UNIX}
  FNeedRefresh := False;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.DoAfterConnect;
var
  History: TStringList;
  i: integer;
begin
  History := TStringList.Create;

  SqlTabSheet.TabVisible := True;
  ResultSetTabSheet.TabVisible := False;

  NewScriptAction.Enabled := True;
  OpenScriptAction.Enabled := True;
  ExecSqlAction.Enabled := True;
  ExecSqlScriptAction.Enabled := True;
  MetadataExtractAction.Enabled := True;
  ClearHistoryAction.Enabled := True;
  RefreshStatusBar;
  BackupDatabaseAction.Enabled := True;
  try
    FsConfig.LoadHistory(FCurrentAlias, History);
    for i := 0 to History.Count - 1 do
      AddtoHistory(History.Strings[i]);
  finally
    History.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.CarretPos;
begin
  sbarEdit.Panels[0].Text := Format('%d:%d', [SqlSynEdit.CaretY, SqlSynEdit.CaretX]);
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.EndTr(ATrCommit: boolean = False);
//False rollback (default) True commit;
begin
  CommitAction.Enabled := False;
  RollBackAction.Enabled := False;
  if FExecutedDDLStm then
  begin
    //if ATrCommit then
      //RefreshAllActionExecute(Self);
    FExecutedDDLStm := False;
  end;
  RefreshStatusBar;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.RefreshStatusBar;
begin
  sbarEdit.Panels[0].Text := Format('%d:%d', [SqlSynEdit.CaretY, SqlSynEdit.CaretX]);
  if MainDataModule.MainTr.InTransaction then
  begin
    sBarEdit.Panels[1].Text := rsTransactionA;
    sBarEdit.Panels[1].Width := sBarEdit.Canvas.TextWidth(sBarEdit.Panels[1].Text) + 10;
  end
  else
    sBarEdit.Panels[1].Text := '';
  if FsConfig.AutoCommitDDL then
  begin
    sBarEdit.Panels[2].Text := rsAutoCommitDD;
    sBarEdit.Panels[2].Width := sBarEdit.Canvas.TextWidth(sBarEdit.Panels[2].Text) + 10;
  end
  else
    sBarEdit.Panels[2].Text := '';

  if FsConfig.MaxFetchResult > 0 then
  begin
    sBarEdit.Panels[3].Text := Format(rsFetchLimitD, [FsConfig.MaxFetchResult]);
    sBarEdit.Panels[3].Width := sBarEdit.Canvas.TextWidth(sBarEdit.Panels[3].Text) + 10;
  end
  else
    sBarEdit.Panels[3].Text := '';
  sBarEdit.Panels[4].Text := Format(rsDialectD, [MainDataModule.MainDb.SQLDialect]);
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.StartTr;
begin
  CommitAction.Enabled := True;
  RollBackAction.Enabled := True;
  RefreshStatusBar;
end;

//------------------------------------------------------------------------------
{ return true if error}

function TBrowserForm.ExecuteSQL(const ASqlText: string;
  const AVerbose: boolean; ALineStart: Integer = 0): boolean;
var
  PrepareTimeStart, ExecTime, ExecTimeStart, FetchTime, FetchTimeStart: TDateTime;
  i: integer;
begin
  Result := False;
  EditResetError;
  if  MessagesTreeview.Items.Count > 0 then
     LogMessage(' ');

  if not MainDataModule.MainTr.InTransaction then
  begin
    MainDataModule.MainTr.StartTransaction;
    StartTr;
    LogMessage(Format(rsStartTransaction, [TimeToStr(Now)]),BMP_TVM_STATE);
  end;

  MainDataModule.MainQry.Close;

  if Trim(MainDataModule.MainQry.SQL.Text) <> Trim(ASqlText) then
    MainDataModule.MainQry.SQL.Text := ASqlText;

  sqlPageControl.PageIndex := 0;
  try
    if not MainDataModule.MainQry.Prepared then
    begin
      if AVerbose then
        LogMessage(rsPreparing,BMP_TVM_STATE);
      PrepareTimeStart := Time;
      MainDataModule.MainQry.Prepare;
      if AVerbose then
      begin
        LogMessage(Format(rsStatementPre, [TimeT(Time - PrepareTimeStart)]),BMP_TVM_CLOCK);
        PlanMemo.Lines.Text := MainDataModule.MainQry.Plan;
      end;
    end

    else
    begin
      if AVerbose then
      begin
        LogMessage(rsStatementAlreadyPrepared,BMP_TVM_NOTE);
      end;
    end;
  except
    on E: EFBLError do
    begin
      beep;
      LogErrorMessage(Format(rsErrorInPrepare, [E.ISC_ErrorCode]),
        E.Message,BMP_TVM_ERROR);
      EditLineError(StmErrorAtLine(E.Message) + ALineStart);
      MainDataModule.MainQry.UnPrepare;
      Result := True;
      Exit;
    end;
  end;

  if MainDataModule.MainQry.ParamCount > 0 then
  begin
    try
      InsertParams;
    except
      on Er: Exception do
      begin
        LogErrorMessage(rsErrorInParam, Er.Message,BMP_TVM_ERROR);
        Exit;
      end;
    end;
  end;


  if MainDataModule.MainQry.FieldCount > 0 then
  begin
    ResultSetTabSheet.TabVisible := True;
    FieldCountTabSheet.TabVisible := True;
    FetchFieldsGrid;
    FieldCountTabSheet.Caption :=
      Format('Fields (%d)', [MainDataModule.MainQry.FieldCount]);
  end
  else
  begin
    ResultSetTabSheet.TabVisible := False;
    FieldCountTabSheet.TabVisible := False;
  end;

  if MainDataModule.MainQry.ParamCount > 0 then
  begin
    paramsTabSheet.TabVisible := True;
    FetchParamGrid;
    for i := 0 to MainDataModule.MainQry.ParamCount - 1 do
      ParamsStringGrid.Cells[1, i + 1] := FParamValue[i];
    ParamsTabSheet.Caption := Format('Params (%d)', [MainDataModule.MainQry.ParamCount]);
  end
  else
    paramsTabSheet.TabVisible := False;

  try
    Screen.Cursor := crSQLWait;
    try      //execute statement
      ExecTimeStart := Time;
      case MainDataModule.MainQry.QueryType of
        qtSelect:
        begin
          if AVerbose then
            LogMessage(rsExecuting,BMP_TVM_STATE);
          MainDataModule.MainQry.ExecSQL;
          ExecTime := Time - ExecTimeStart;
          FetchTimeStart := Time;
          if AVerbose then
          begin
            LogMessage(Format(rsStatementExecuted, [TimeT(ExecTime)]),BMP_TVM_CLOCK);
            LogMessage(rsFetching,BMP_TVM_STATE);
          end;
          Application.ProcessMessages;
          if FsConfig.OutputGridType = 0 then
            FetchDataGrid
          else if FsConfig.OutputGridType = 1 then
            TextGrid(MainDataModule.MainQry, ResultSetSynMemo.Lines, True);
          FetchTime := Time - FetchTimeStart;
          LogMessage(Format(rsDRowSFetched,
            [MainDataModule.MainQry.FetchCount, TimeT(FetchTime)]),BMP_TVM_STATE);
          ResultSetTabSheet.Caption :=
            Format(rsResultSetD, [MainDataModule.MainQry.FetchCount]);
          ResultSetToCsv.Enabled := MainDataModule.MainQry.FetchCount > 0;
          ResultSetToJson.Enabled := MainDataModule.MainQry.FetchCount > 0;
        end;
        qtInsert:
        begin
          MainDataModule.MainQry.ExecSQL;
          FScriptStat.ins_rows :=
            FScriptStat.ins_rows + MainDataModule.MainQry.RowsAffected;
          if AVerbose then
          begin
            ExecTime := Time - ExecTimeStart;
            LogMessage(Format(rsStatementExecuted, [TimeT(ExecTime)]),BMP_TVM_CLOCK);
            LogMessage(Format(rsDRowSInserte,
              [MainDataModule.MainQry.RowsAffected]),BMP_TVM_STATE);
          end;
        end;
        qtUpdate:
        begin
          MainDataModule.MainQry.ExecSQL;
          FScriptStat.upg_rows :=
            FScriptStat.upg_rows + MainDataModule.MainQry.RowsAffected;
          if AVerbose then
          begin
            ExecTime := Time - ExecTimeStart;
            LogMessage(Format(rsStatementExecuted, [TimeT(ExecTime)]),BMP_TVM_CLOCK);
            LogMessage(Format(rsDRowSUpdated,
              [MainDataModule.MainQry.RowsAffected]),BMP_TVM_STATE);
          end;
        end;
        qtDelete:
        begin
          MainDataModule.MainQry.ExecSQL;
          FScriptStat.del_rows :=
            FScriptStat.del_rows + MainDataModule.MainQry.RowsAffected;
          if AVerbose then
          begin
            ExecTime := Time - ExecTimeStart;
            LogMessage(Format(rsStatementExecuted, [TimeT(ExecTime)]),BMP_TVM_CLOCK);
            LogMessage(Format(rsDRowSDeleted,
              [MainDataModule.MainQry.RowsAffected]),BMP_TVM_STATE);
          end;
        end;
        qtDDL:
        begin
          MainDataModule.MainQry.ExecSQL;
          Inc(FScriptStat.ddl_cmds);
          FExecutedDDLStm := True;
          if AVerbose then
          begin
            ExecTime := Time - ExecTimeStart;
            LogMessage(Format(rsStatementExecuted, [TimeT(ExecTime)]),BMP_TVM_CLOCK);
          end;
          if AutoCommitDDL then
          begin
            MainDataModule.MainTr.CommitRetaining;
            LogMessage(rsTransactionCR,BMP_TVM_COMMIT);
          end;
        end;
        qtExecProcedure:
        begin
          MainDataModule.MainQry.ExecSQL;
          if AVerbose then
          begin
            execTime := Time - ExecTimeStart;
            LogMessage(Format(rsStoredProced, [TimeT(ExecTime)]),BMP_TVM_CLOCK);
            if MainDataModule.MainQry.FieldCount > 0 then
            begin
              LogMessage(rsFetching,BMP_TVM_STATE);
              if FsConfig.OutputGridType = 0 then
                FetchDataGrid
              else if FsConfig.OutputGridType = 1 then
                TextGrid(MainDataModule.MainQry, ResultSetSynMemo.Lines);
              ResultSetTabSheet.Caption :=
                Format(rsResultSetD, [MainDataModule.MainQry.FetchCount]);
            end;
            if MainDataModule.MainQry.FieldCount > 0 then
              LogMessage(Format(rsDRowSFetched2,
                [MainDataModule.MainQry.FetchCount]),BMP_TVM_STATE);
          end;
        end;
        qtCommit:
        begin
          MainDataModule.MainQry.ExecSQL;
          LogMessage(Format(rsTransactionC, [TimeToStr(Now)]),BMP_TVM_CLOCK);
          EndTr(True);
        end;
        qtRollback:
        begin
          MainDataModule.MainQry.ExecSQL;
          LogMessage(Format(rsTransactionR, [TimeToStr(Now)]),BMP_TVM_ROLLBACK);
          EndTr;
        end;
        qtSelectForUpdate:
        begin
          MainDataModule.MainQry.ExecSQL;
          if AVerbose then
          begin
            execTime := Time - ExecTimeStart;
            LogMessage(Format(rsStatementExecuted, [TimeT(ExecTime)]),BMP_TVM_CLOCK);
            LogMessage(rsSelectForUpd,BMP_TVM_STATE);
          end;
        end;
        qtSetGenerator:
        begin
          MainDataModule.MainQry.ExecSQL;
          Inc(FScriptStat.ddl_cmds);
          if AVerbose then
          begin
            ExecTime := Time - ExecTimeStart;
            LogMessage(Format(rsStatementExecuted,
              [TimeT(ExecTime)]),BMP_TVM_CLOCK);
            LogMessage(rsGeneratorSet, BMP_TVM_STATE);
          end;
        end;
      end;
    except
      on E: EFBLError do
      begin
        LogErrorMessage(Format(rsErrorInExecute,
          [E.ISC_ErrorCode]),E.Message,BMP_TVM_ERROR);
        EditLineError(StmErrorAtLine(E.Message) + ALineStart);
        MainDataModule.MainQry.Close;
        Result := True;
        Exit;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ClearDataGrid;
begin
  ResultSetStringGrid.Clean([gzNormal]);
  ResultSetStringGrid.DefaultRowHeight := ResultSetStringGrid.Canvas.TextHeight('X') + 2;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.FetchDataGrid;
var
  i, r, c: integer;
begin
  ClearDataGrid;
  with MainDataModule do
  begin
    FColDesc := nil;
    SetLength(FColDesc, MainQry.FieldCount);
    ResultSetStringGrid.ColCount := MainQry.FieldCount + 1;
    ResultSetStringGrid.ColWidths[0] :=
      ResultSetStringGrid.canvas.TextWidth('Rec. #X') + 2;
    ResultSetStringGrid.Cells[0, 0] := 'Rec. #';

    for i := 0 to MainQry.FieldCount - 1 do
    begin
      ResultSetStringGrid.ColWidths[i + 1] := AbjustColWidth(i);
      ResultSetStringGrid.Cells[i + 1, 0] := MainQry.FieldName(i);
      FColDesc[i].intType := MainQry.FieldType(i);
      FColDesc[i].Subtype := MainQry.FieldSubType(i);
    end;
    ResultSetStringGrid.DefaultRowHeight :=
      ResultSetStringGrid.Canvas.TextHeight('TEXT') + ROW_H;


    ResultSetStringGrid.RowCount := 50;
    r := 0;
    c := 0;

    while not MainQry.EOF do
    begin
      Inc(r);
      if r < FsConfig.MaxGridRows then
      begin
        ResultSetStringGrid.Cells[0, r] := IntToStr(MainQry.FetchCount);
        for i := 0 to MainQry.FieldCount - 1 do
        begin
          if MainQry.FieldRealName(i) = 'DB_KEY' then
            ResultSetStringGrid.Cells[i + 1, r] := DecodeDB_KEY(MainQry.FieldAsString(i))
          else if MainQry.FieldType(i) = SQL_BLOB then
          begin
            if MainQry.FieldSubtype(i) = 1 then // subtype text
            begin
              ResultSetStringGrid.Cells[i + 1, r] := '(Memo)';
            end
            else
              ResultSetStringGrid.Cells[i + 1, r] := '(Blob)';
          end
          else if MainQry.FieldType(i) = SQL_ARRAY then
            ResultSetStringGrid.Cells[i + 1, r] := '(Array)'
          else if MainQry.FieldIsNull(i) then
            ResultSetStringGrid.Cells[i + 1, r] := '(null)'
          //SQL_INT64, SQL_LONG ,SQL_SHORT ,SQL_DOUBLE, SQL_FLOAT, SQL_D_FLOAT
          else if (MainQry.FieldType(i) = SQL_INT64) or
            (MainQry.FieldType(i) = SQL_LONG) or (MainQry.FieldType(i) = SQL_SHORT) or
            (MainQry.FieldType(i) = SQL_DOUBLE) or (MainQry.FieldType(i) = SQL_FLOAT) or
            (MainQry.FieldType(i) = SQL_D_FLOAT) then
            if MainQry.FieldScale(i) <> 0 then
              ResultSetStringGrid.Cells[i + 1, r] := FormatNumericValue(
                MainQry.FieldAsDouble(i), MainQry.FieldScale(i))
            else
              ResultSetStringGrid.Cells[i + 1, r] := MainQry.FieldAsString(i)
          else
            ResultSetStringGrid.Cells[i + 1, r] := MainQry.FieldAsString(i);
        end;
      end;
      MainQry.Next;
      Inc(c);
      if c = 49 then
      begin
        ResultSetStringGrid.RowCount := ResultSetStringGrid.RowCount + 50;
        Application.ProcessMessages;
        c := 0;
      end;
    end;

    if MainQry.FetchCount = 0 then
      ResultSetStringGrid.RowCount := 2
    else
    begin
      if (MainQry.FetchCount + 1) > FsConfig.MaxGridRows then
        ResultSetStringGrid.RowCount := FsConfig.MaxGridRows
      else
        ResultSetStringGrid.RowCount := MainQry.FetchCount + 1;
    end;
  end; // end with MainDataModule
end;   // end procedure

//------------------------------------------------------------------------------

procedure TBrowserForm.InsertParams;
var
  i: integer;
  IsNull: boolean;
  ParaInt: integer;
  ParaDouble: double;
  ParaFloat: single;
  ParaText: string;
  ParaDate: TDateTime;
  Foo: boolean;
begin
  if not MainDataModule.MainQry.Prepared then
    Exit;
  FParamValue := nil;
  SetLength(FParamValue, MainDataModule.MainQry.ParamCount);
  for i := 0 to MainDataModule.MainQry.ParamCount - 1 do
  begin
    ParaInt := 0;
    ParaDouble := 0;
    ParaFloat := 0;
    Paratext := '';
    ParaDate := now;

    isNull := MainDataModule.MainQry.ParamIsNullable(i);
    case MainDataModule.MainQry.ParamType(i) of

      SQL_VARYING,
      SQL_TEXT:
        if InputParamString(Format('%d of %d',
          [i + 1, MainDataModule.MainQry.ParamCount]),
          MainDataModule.MainQry.ParamSQLTypeDesc(i), isNull, Paratext) then
        begin
          if isNull then
          begin
            MainDataModule.MainQry.ParamAsNull(i);
            FParamValue[i] := '<NULL>';
          end
          else
          begin
            MainDataModule.MainQry.ParamAsString(i, Paratext);
            FParamValue[i] := ParaText;
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));

      SQL_DOUBLE:
        if inputParamDouble(Format('%d of %d',
          [i + 1, MainDataModule.MainQry.ParamCount]),
          MainDataModule.MainQry.ParamSQLTypeDesc(i), isNull, ParaDouble) then
        begin
          if isNull then
          begin
            MainDataModule.MainQry.ParamAsNull(i);
            FParamValue[i] := '<NULL>';
          end
          else
          begin
            MainDataModule.MainQry.ParamAsDouble(i, ParaDouble);
            FParamValue[i] := FloatToStr(ParaDouble);
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));
      SQL_FLOAT,
      SQL_D_FLOAT:
        if inputParamFloat(Format('%d of %d',
          [i + 1, MainDataModule.MainQry.ParamCount]),
          MainDataModule.MainQry.ParamSQLTypeDesc(i), isNull, ParaFloat) then
        begin
          if isnull then
          begin
            MainDataModule.MainQry.ParamAsNull(i);
            FParamValue[i] := '<NULL>';
          end
          else
          begin
            MainDataModule.MainQry.ParamAsFloat(i, ParaFloat);
            FParamValue[i] := FloatToStr(ParaFloat);
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));


      SQL_INT64,
      SQL_LONG,
      SQL_SHORT:
        if MainDataModule.MainQry.ParamScale(i) = 0 then
        begin
          try
            foo := inputParamInt(Format('%d of %d',
              [i + 1, MainDataModule.MainQry.ParamCount]),
              MainDataModule.MainQry.ParamSQLTypeDesc(i), IsNull, ParaInt);
          except
            on E: Exception do
              ShowMessage(E.Message);
          end;

          if Foo = True then
          begin
            if IsNull then
            begin
              MainDataModule.MainQry.ParamAsNull(i);
              FParamValue[i] := '<NULL>';
            end
            else
            begin
              MainDataModule.MainQry.ParamAsLong(i, ParaInt);
              FParamValue[i] := IntToStr(ParaInt);
            end;
          end
          else
            raise Exception.Create(Format('Param #%d not assigned', [i]));

        end
        else
        if InputParamDouble(Format('%d of %d',
          [i + 1, MainDataModule.MainQry.ParamCount]),
          MainDataModule.MainQry.ParamSQLTypeDesc(i), IsNull, ParaDouble) then
        begin

          if IsNull then
          begin
            MainDataModule.MainQry.ParamAsNull(i);
            FParamValue[i] := '<NULL>';
          end
          else
          begin
            MainDataModule.MainQry.ParamAsDouble(i, ParaDouble);
            FParamValue[i] := FloatToStr(ParaDouble);
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));


      SQL_BLOB:
        if MainDataModule.MainQry.ParamSubType(i) = 1 then
        begin
          if InputParamMemo(Format('%d of %d',
            [i + 1, MainDataModule.MainQry.ParamCount]),
            MainDataModule.MainQry.ParamSQLTypeDesc(i), IsNull, ParaText) then
          begin
            if IsNull then
            begin
              MainDataModule.MainQry.ParamAsNull(i);
              FParamValue[i] := '<NULL>';
            end
            else
            begin
              MainDataModule.MainQry.ParamAsString(i, ParaText);
              FParamValue[i] := '(Memo)';
            end;
          end
          else
            raise Exception.Create(Format('Param #%d not assigned', [i]));
        end
        else
        begin
          if InputParamBlob(Format('%d of %d',
            [i + 1, MainDataModule.MainQry.ParamCount]),
            MainDataModule.MainQry.ParamSQLTypeDesc(i), IsNull, Paratext) then
          begin
            if IsNull then
            begin
              MainDataModule.MainQry.ParamAsNull(i);
              FParamValue[i] := '<NULL>';
            end
            else
            begin
              MainDataModule.MainQry.BlobParamLoadFromFile(i, Paratext);
              FParamValue[i] := '(Blob)';
            end;
          end
          else
            raise Exception.Create(Format('Param #%d not assigned', [i]));
        end;
      SQL_ARRAY: ;
      SQL_QUAD: ;
      SQL_TYPE_TIME:
      begin
        if InputParamDateTime(Format('%d of %d',
          [i + 1, MainDataModule.MainQry.ParamCount]),
          MainDataModule.MainQry.ParamSQLTypeDesc(i), IsNull, ParaDate) then
        begin
          try
            MainDataModule.MainQry.ParamAsDateTime(i, ParaDate);
            FParamValue[i] := TimeToStr(ParaDate);
          except
            on E: Exception do
              ShowMessage(E.Message);
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));
      end;
      SQL_TYPE_DATE:
      begin
        if InputParamDateTime(Format('%d of %d',
          [i + 1, MainDataModule.MainQry.ParamCount]),
          MainDataModule.MainQry.ParamSQLTypeDesc(i), IsNull, ParaDate) then
        begin
          try
            MainDataModule.MainQry.ParamAsDateTime(i, ParaDate);
            FParamValue[i] := DateToStr(ParaDate);
          except
            on E: Exception do
              ShowMessage(E.Message);
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));
      end;
      SQL_DATE:  //timestamp
      begin
        if InputParamDateTime(Format('%d of %d',
          [i + 1, MainDataModule.MainQry.ParamCount]),
          MainDataModule.MainQry.ParamSQLTypeDesc(i), IsNull, ParaDate) then
        begin
          try
            MainDataModule.MainQry.ParamAsDateTime(i, ParaDate);
            FParamValue[i] := DateTimeToStr(ParaDate);
          except
            on E: Exception do
              ShowMessage(E.Message);
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));
      end;
    end;
  end;
end;


//------------------------------------------------------------------------------

procedure TBrowserForm.FetchFieldsGrid;
var
  i: integer;
begin
  FieldsStringGrid.RowCount := MainDataModule.MainQry.FieldCount + 1;
  FieldsStringGrid.ColCount := 9;
  FieldsStringGrid.DefaultRowHeight := FieldsStringGrid.Canvas.TextHeight('X') + ROW_H;

  FieldsStringGrid.Cells[0, 0] := 'Alias';
  FieldsStringGrid.Cells[1, 0] := 'Relation';
  FieldsStringGrid.Cells[2, 0] := 'Field';
  FieldsStringGrid.Cells[3, 0] := 'Ower';
  FieldsStringGrid.Cells[4, 0] := 'Type';
  FieldsStringGrid.Cells[5, 0] := 'Sql type';
  FieldsStringGrid.Cells[6, 0] := 'Size(bytes)';
  FieldsStringGrid.Cells[7, 0] := 'Subtype';
  FieldsStringGrid.Cells[8, 0] := 'Scale';

  for i := 0 to MainDataModule.MainQry.FieldCount - 1 do
  begin
    FieldsStringGrid.Cells[0, i + 1] := MainDataModule.MainQry.FieldName(i);
    if (FieldsStringGrid.ColWidths[0]) <
      (FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[0, i + 1]) + 4) then
      FieldsStringGrid.ColWidths[0] :=
        FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[0, i + 1]) + 4;
    FieldsStringGrid.Cells[1, i + 1] := MainDataModule.MainQry.FieldTableName(i);
    if (FieldsStringGrid.ColWidths[1]) <
      (FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[1, i + 1]) + 4) then
      FieldsStringGrid.ColWidths[1] :=
        FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[1, i + 1]) + 4;
    FieldsStringGrid.Cells[2, i + 1] := MainDataModule.MainQry.FieldRealName(i);
    if (FieldsStringGrid.ColWidths[2]) <
      (FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[2, i + 1]) + 4) then
      FieldsStringGrid.ColWidths[2] :=
        FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[2, i + 1]) + 4;

    FieldsStringGrid.Cells[3, i + 1] := MainDataModule.MainQry.FieldTableOwerName(i);
    if (FieldsStringGrid.ColWidths[3]) <
      (FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[3, i + 1]) + 4) then
      FieldsStringGrid.ColWidths[3] :=
        FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[3, i + 1]) + 4;

    FieldsStringGrid.Cells[4, i + 1] := TypeDesc(MainDataModule.MainQry.FieldType(i));
    if (FieldsStringGrid.ColWidths[4]) <
      (FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[4, i + 1]) + 4) then
      FieldsStringGrid.ColWidths[4] :=
        FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[4, i + 1]) + 4;

    FieldsStringGrid.Cells[5, i + 1] := MainDataModule.MainQry.FieldSQLTypeDesc(i);
    if (FieldsStringGrid.ColWidths[5]) <
      (FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[5, i + 1]) + 4) then
      FieldsStringGrid.ColWidths[5] :=
        FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[5, i + 1]) + 4;

    FieldsStringGrid.Cells[6, i + 1] := IntToStr(MainDataModule.MainQry.FieldSize(i));
    if (FieldsStringGrid.ColWidths[6]) <
      (FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[6, i + 1]) + 4) then
      FieldsStringGrid.ColWidths[6] :=
        FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[6, i + 1]) + 4;

    FieldsStringGrid.Cells[7, i + 1] := IntToStr(MainDataModule.MainQry.FieldSubType(i));
    if (FieldsStringGrid.ColWidths[7]) <
      (FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[7, i + 1]) + 4) then
      FieldsStringGrid.ColWidths[7] :=
        FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[7, i + 1]) + 4;

    FieldsStringGrid.Cells[8, i + 1] := IntToStr(MainDataModule.MainQry.FieldScale(i));
    if (FieldsStringGrid.ColWidths[8]) <
      (FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[8, i + 1]) + 4) then
      FieldsStringGrid.ColWidths[8] :=
        FieldsStringGrid.Canvas.TextWidth(FieldsStringGrid.Cells[8, i + 1]) + 4;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.FetchParamGrid;
var
  i: integer;
begin
  ParamsStringGrid.ColCount := 5;
  ParamsStringGrid.RowCount := MainDataModule.MainQry.ParamCount + 1;
  ParamsStringGrid.DefaultRowHeight := ParamsStringGrid.Canvas.TextHeight('X') + ROW_H;
  ParamsStringGrid.Cells[0, 0] := 'Par. #';
  ParamsStringGrid.Cells[1, 0] := 'Value';
  ParamsStringGrid.Cells[2, 0] := 'Type';
  ParamsStringGrid.Cells[3, 0] := 'Not null';
  for i := 0 to MainDataModule.MainQry.ParamCount - 1 do
  begin
    ParamsStringGrid.Cells[0, i + 1] := IntToStr(i);
    ParamsStringGrid.Cells[1, i + 1] := '';
    ParamsStringGrid.Cells[2, i + 1] := MainDataModule.MainQry.ParamSQLTypeDesc(i);
    if MainDataModule.MainQry.ParamIsNullable(i) then
    begin
      ParamsStringGrid.Cells[3, i + 1] := 'not null';
    end;
  end;
end;

//------------------------------------------------------------------------------

function TBrowserForm.AbjustColWidth(const ACol: integer): integer;
var
  wn, wt: integer;
begin
  wn := ResultSetStringGrid.Canvas.TextWidth(MainDataModule.MainQry.FieldName(ACol));
  case MainDataModule.MainQry.FieldType(ACol) of
    SQL_SHORT:
      wt := ResultSetStringGrid.Canvas.TextWidth('-32768.');
    SQL_LONG:
      wt := ResultSetStringGrid.Canvas.TextWidth('-2147483648.');
    SQL_INT64,
    SQL_FLOAT,
    SQL_D_FLOAT,
    SQL_DOUBLE:
      wt := ResultSetStringGrid.Canvas.TextWidth(StringOfChar('9', 20));
    SQL_VARYING,
    SQL_TEXT:
    begin
      if MainDataModule.MainQry.FieldRealName(ACol) = 'DB_KEY' then
        wt := ResultSetStringGrid.Canvas.TextWidth(StringOfChar('X',
          MainDataModule.MainQry.FieldSize(ACol) * 2))
      else if MainDataModule.MainQry.FieldSize(ACol) < 70 then
        wt := ResultSetStringGrid.Canvas.TextWidth(StringOfChar('X',
          MainDataModule.MainQry.FieldSize(ACol)))
      else
        wt := ResultSetStringGrid.Canvas.TextWidth(StringOfChar('X', 70));
    end;
    SQL_BLOB:
      wt := ResultSetStringGrid.Canvas.TextWidth('(BLOB)');
    SQL_ARRAY:
      wt := ResultSetStringGrid.Canvas.TextWidth('(ARRAY)');
    SQL_TIMESTAMP:
      wt := ResultSetStringGrid.Canvas.TextWidth(DateTimeToStr(now));
    SQL_TYPE_TIME:
      wt := ResultSetStringGrid.Canvas.TextWidth(TimeToStr(now));
    SQL_TYPE_DATE:
      wt := ResultSetStringGrid.Canvas.TextWidth(DateToStr(now));
    else
      wt := 100;
  end;
  Result := ifthen(wt > wn, wt, wn) + 2;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.AddtoHistory(const AStm: string);
begin
  if FHistory.Count = 0 then
  begin
    FHistory.Add(AStm);
    FHistoryIDX := FHistory.Count;
    PreviousAction.Enabled := True;
    NextAction.Enabled := False;
  end
  else
  begin
    if FHistory.IndexOf(AStm) = -1 then
      FHistory.Add(AStm);
    FHistoryIDX := FHistory.Count;
    PreviousAction.Enabled := True;
    NextAction.Enabled := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowBuffer;
begin
  MainPageControl.PageIndex := 0;
  if not DdlSynMemo.Visible then
  begin
    ValuesListView.Visible := False;
    DdlSynMemo.Align := alClient;
    DdlSynMemo.Visible := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.LoadDbTreeView;
var
  nDb, nObj, nItem, nDepend, nPriv, nTrigTable, nTrigTableItem: TTreeNode;
  i, it: integer;
begin
  try
    Screen.Cursor := crSQLWait;
    LoadLists;
    ClearDbTreeView;
    DbTreeView.Items.BeginUpdate;
    if not MainDataModule.BrowserTr.InTransaction then
      MainDataModule.BrowserTr.StartTransaction;
    nDb := DbTreeView.Items.Add(nil, FCurrentAlias);
    nDb.Data := TNodeDesc.Create(CNT_DATABASE, '', 'Database alias::' + FCurrentAlias);
    ndb.SelectedIndex := BMP_DATABASE;
    nDb.ImageIndex := BMP_DATABASE;
    // Add Domains
    nObj := DbTreeView.Items.AddChild(nDb, Format(CDOMAINS + ' (%d)',
      [FDomainList.Count]));
    nObj.SelectedIndex := BMP_DOMAIN;
    nObj.ImageIndex := BMP_DOMAIN;
    nObj.Data := TNodeDesc.Create(CNT_DOMAINS, '', 'DOMAINS');
    for i := 0 to FDomainList.Count - 1 do
    begin
      nItem := DbTreeView.Items.AddChild(nObj, FDomainList.Strings[i]);
      nItem.SelectedIndex := BMP_DOMAIN;
      nItem.ImageIndex := BMP_DOMAIN;
      nItem.Data := TNodeDesc.Create(CNT_DOMAIN, FDomainList.Strings[i],
        'DOMAIN::' + FDomainList.Strings[i]);
    end;
    // Add Tables
    nObj := DbTreeView.Items.AddChild(nDb, Format(CTABLES + ' (%d)',
      [FTableList.Count]));
    nObj.SelectedIndex := BMP_TABLE;
    nObj.ImageIndex := BMP_TABLE;
    nObj.Data := TNodeDesc.Create(CNT_TABLES, '', 'TABLES');
    MainDataModule.SynSqlSyn1.TableNames.Clear;
    for i := 0 to FTableList.Count - 1 do
    begin
      nItem := DbTreeView.Items.AddChild(nObj, FTableList.Strings[i]);
      MainDataModule.SynSqlSyn1.TableNames.Add(FTableList.Strings[i]);
      nItem.ImageIndex := BMP_TABLE;
      nItem.SelectedIndex := BMP_TABLE;
      nItem.Data := TNodeDesc.Create(CNT_TABLE, FTableList.Strings[i],
        'TABLE::' + FTableList.Strings[i]);
      nTrigTable := DbTreeView.Items.AddChild(nItem, CTRIGGERS);

      nTrigTable.Data := TNodeDesc.Create(CNT_TRIGGERSINTABLE,
        FTableList.Strings[i], 'TABLE::' + FTableList.Strings[i] + '::[Triggers]');
      nTrigTable.ImageIndex := BMP_TRIGGER;
      nTrigTable.SelectedIndex := BMP_TRIGGER;
      for it := 0 to MainDataModule.SqlMetaData.TriggersInTable(
          FTableList.Strings[i]).Count - 1 do
      begin
        nTrigTableItem :=
          DbTreeView.Items.AddChild(nTrigTable,
          MainDataModule.SqlMetaData.TriggersInTable(
          FTableList.Strings[i]).Strings[it]);
        nTrigTableItem.ImageIndex := BMP_TRIGGER;
        nTrigTableItem.SelectedIndex := BMP_TRIGGER;
        nTrigTableItem.Data :=
          TNodeDesc.Create(CNT_TRIGGER, MainDataModule.SqlMetaData.TriggersInTable(
          FTableList.Strings[i]).Strings[it], 'TABLE::' +
          MainDataModule.SqlMetaData.tables.Strings[i] + '::[Trigger]::' +
          MainDataModule.SqlMetaData.TriggersInTable(FTableList.Strings[i]).Strings[it]);
      end;
      nDepend := DbTreeView.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FTableList.Strings[i],
        'TABLE::' + FTableList.Strings[i] + '[Dependencies]');
      nPriv := DbTreeView.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FTableList.Strings[i],
        'TABLE::' + FTableList.Strings[i] + '[Privileges]');
    end;
    // views
    nObj := DbTreeView.Items.AddChild(nDb, Format(CVIEWS + ' (%d)', [FViewList.Count]));
    nObj.ImageIndex := BMP_VIEW;
    nObj.SelectedIndex := BMP_VIEW;
    nObj.Data := TNodeDesc.Create(CNT_VIEWS, '', 'VIEWS');
    for i := 0 to FViewList.Count - 1 do
    begin
      nItem := DbTreeView.Items.AddChild(nObj, FViewList.Strings[i]);
      MainDataModule.SynSqlSyn1.TableNames.Add(FViewList.Strings[i]);
      nItem.ImageIndex := BMP_VIEW;
      nItem.SelectedIndex := BMP_VIEW;
      nItem.Data := TNodeDesc.Create(CNT_VIEW, FViewList.Strings[i],
        'VIEW::' + FViewList.Strings[i]);
      nDepend := DbTreeView.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FViewList.Strings[i],
        'VIEW::' + FViewList.Strings[i] + '[Dependencies]');
      nPriv := DbTreeView.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FViewList.Strings[i],
        'VIEW::' + FViewList.Strings[i] + '[Privileges]');
    end;
    //Procedures
    nObj := DbTreeView.Items.AddChild(nDb, Format(CPROCEDURES + ' (%d)',
      [FProcList.Count]));
    nObj.ImageIndex := BMP_PROCEDURE;
    nObj.SelectedIndex := BMP_PROCEDURE;
    nObj.Data := TNodeDesc.Create(CNT_PROCEDURES, '', 'PROCEDURES');
    for i := 0 to FProcList.Count - 1 do
    begin
      nItem := DbTreeView.Items.AddChild(nObj, FProcList.Strings[i]);
      nItem.ImageIndex := BMP_PROCEDURE;
      nItem.SelectedIndex := BMP_PROCEDURE;
      nItem.Data := TNodeDesc.Create(CNT_PROCEDURE, FProcList.Strings[i],
        'PROCEDURE::' + FProcList.Strings[i]);
      nDepend := DbTreeView.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FProcList.Strings[i],
        'PROCEDURE::' + FProcList.Strings[i] + '[Dependencies]');
      nPriv := DbTreeView.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FProcList.Strings[i],
        'PROCEDURE::' + FProcList.Strings[i] + '[Privileges]');
    end;
    //Triggers
    nObj := DbTreeView.Items.AddChild(nDb, Format(CTRIGGERS + ' (%d)',
      [FTriggerList.Count]));
    nObj.ImageIndex := BMP_TRIGGER;
    nObj.SelectedIndex := BMP_TRIGGER;
    nObj.Data := TNodeDesc.Create(CNT_TRIGGERS, '', 'TRIGGERS');
    for i := 0 to FTriggerList.Count - 1 do
    begin
      nItem := DbTreeView.Items.AddChild(nObj, FTriggerList.Strings[i]);
      nItem.ImageIndex := BMP_TRIGGER;
      nItem.SelectedIndex := BMP_TRIGGER;
      nItem.Data := TNodeDesc.Create(CNT_TRIGGER, FTriggerList.Strings[i],
        'TRIGGER::' + FTriggerList.Strings[i]);
      nDepend := DbTreeView.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FTriggerList.Strings[i],
        'TRIGGER::' + FTriggerList.Strings[i] + '[Dependencies]');
      nPriv := DbTreeView.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FTriggerList.Strings[i],
        'TRIGGER::' + FTriggerList.Strings[i] + '[Privileges]');
    end;
    //Generators
    nObj := DbTreeView.Items.AddChild(nDb, Format(CGENERATORS + ' (%d)',
      [FGeneratorList.Count]));
    nObj.ImageIndex := BMP_GENERATOR;
    nObj.SelectedIndex := BMP_GENERATOR;
    nObj.Data := TNodeDesc.Create(CNT_GENERATORS, '', 'GENERATORS');
    for i := 0 to FGeneratorList.Count - 1 do
    begin
      nItem := DbTreeView.Items.AddChild(nObj, FGeneratorList.Strings[i]);
      nItem.ImageIndex := BMP_GENERATOR;
      nItem.SelectedIndex := BMP_GENERATOR;
      nItem.Data := TNodeDesc.Create(CNT_GENERATOR, FGeneratorList.Strings[i],
        'GENERATOR::' + FGeneratorList.Strings[i]);
    end;
    //UDFS
    nObj := DbTreeView.Items.AddChild(nDb, Format(CUDFS + ' (%d)', [FUdfList.Count]));
    nObj.ImageIndex := BMP_UDF;
    nObj.SelectedIndex := BMP_UDF;
    nObj.Data := TNodeDesc.Create(CNT_UDFS, '', 'UDFS');
    for i := 0 to FUdfList.Count - 1 do
    begin
      nItem := DbTreeView.Items.AddChild(nObj, FUdfList.Strings[i]);
      nItem.ImageIndex := BMP_UDF;
      nItem.SelectedIndex := BMP_UDF;
      nItem.Data := TNodeDesc.Create(CNT_UDF, FUdfList.Strings[i],
        'UDF::' + FUdfList.Strings[i]);
    end;
    // Exceptions
    nObj := DbTreeView.Items.AddChild(nDb, Format(CEXCEPTIONS + ' (%d)',
      [FExceptionList.Count]));
    nObj.ImageIndex := BMP_EXCEPTION;
    nObj.SelectedIndex := BMP_EXCEPTION;
    nObj.Data := TNodeDesc.Create(CNT_EXCEPTIONS, '', 'EXCEPTIONS');
    for i := 0 to FExceptionList.Count - 1 do
    begin
      nItem := DbTreeView.Items.AddChild(nObj, FExceptionList.Strings[i]);
      nItem.ImageIndex := BMP_EXCEPTION;
      nItem.SelectedIndex := BMP_EXCEPTION;
      nItem.Data := TNodeDesc.Create(CNT_EXCEPTION, FExceptionList.Strings[i],
        'EXCEPTION::' + FExceptionList.Strings[i]);
      nDepend := DbTreeView.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FExceptionList.Strings[i],
        'EXCEPTION::' + FExceptionList.Strings[i] + '[Privileges]');
    end;
    // Roles
    nObj := DbTreeView.Items.AddChild(nDb, Format(CROLES + ' (%d)', [FRoleList.Count]));
    nObj.ImageIndex := BMP_ROLE;
    nObj.SelectedIndex := BMP_ROLE;
    nObj.Data := TNodeDesc.Create(CNT_ROLES, '', 'ROLES');
    for i := 0 to FRoleList.Count - 1 do
    begin
      nItem := DbTreeView.Items.AddChild(nObj, FRoleList.Strings[i]);
      nItem.ImageIndex := BMP_ROLE;
      nItem.SelectedIndex := BMP_ROLE;
      nItem.Data := TNodeDesc.Create(CNT_ROLE, FRoleList.Strings[i],
        'ROLE::' + FRoleList.Strings[i]);
      nPriv := DbTreeView.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FRoleList.Strings[i],
        'ROLE::' + FRoleList.Strings[i] + '[Privileges]');
    end;

    if FsConfig.SystemObjectsVisible then
    begin
      //system tables
      nObj := DbTreeView.Items.AddChild(nDb, Format(CSYSTEMTABLES +
        ' (%d)', [FSysTableList.Count]));
      nObj.ImageIndex := BMP_SYSTEMTABLE;
      nObj.SelectedIndex := BMP_SYSTEMTABLE;
      nObj.Data := TNodeDesc.Create(CNT_SYSTABLES, '', 'SYSTEM_TABLES');
      for i := 0 to FSysTableList.Count - 1 do
      begin
        nItem := DbTreeView.Items.AddChild(nObj, FSysTableList.Strings[i]);
        nItem.ImageIndex := BMP_SYSTEMTABLE;
        nItem.SelectedIndex := BMP_SYSTEMTABLE;
        nItem.Data := TNodeDesc.Create(CNT_SYSTABLE, FSysTableList.Strings[i],
          'SYSTEM_TABLE::' + FSysTableList.Strings[i]);
      end;
      // system Triggers
      nObj := DbTreeView.Items.AddChild(nDb, Format(CSYSTEMTRIGGERS +
        ' (%d)', [FSysTriggerList.Count]));
      nObj.ImageIndex := BMP_SYSTEMTRIGGER;
      nObj.SelectedIndex := BMP_SYSTEMTRIGGER;
      nObj.Data := TNodeDesc.Create(CNT_SYSTRIGGERS, '', 'SYSTEM_TRIGGERS');
      for i := 0 to FSysTriggerList.Count - 1 do
      begin
        nItem := DbTreeView.Items.AddChild(nObj, FSysTriggerList.Strings[i]);
        nItem.ImageIndex := BMP_SYSTEMTRIGGER;
        nItem.SelectedIndex := BMP_SYSTEMTRIGGER;
        nItem.Data := TNodeDesc.Create(CNT_SYSTRIGGER, FSysTriggerList.Strings[i],
          'SYSTEM_TRIGGERS::' + FSysTriggerList.Strings[i]);
      end;
    end;
    nDb.Expand(False);
    sbTvDb.Panels.Items[0].Text := Format('%d: items', [DbTreeView.Items.Count]);
  finally
    Screen.Cursor := crDefault;
    DbTreeView.Items.EndUpdate;
    if MainDataModule.BrowserTr.InTransaction then
      MainDataModule.BrowserTr.RollBack;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ClearDbTreeView;
var
  i: integer;
begin

  DbTreeView.Items.BeginUpdate;
  try
    for i := 0 to DbTreeView.Items.Count - 1 do
      if Assigned(DbTreeView.Items[i].Data) then
      begin
        TNodeDesc(DbTreeView.Items[i].Data).Free;
        DbTreeView.Items[i].Data := nil;
      end;

    DbTreeView.Items.Clear;
      {$ifdef UNIX}
    //if FNeedRefresh then  //ShowMessage('Refresh Ok');
      {$endif}
  finally
    DbTreeView.Items.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.LoadLists;
begin
  FDomainList.Assign(MainDataModule.SqlMetaData.Domains);
  FDomainList.Sort;
  FTableList.Assign(MainDataModule.SqlMetaData.Tables);
  FtableList.Sort;
  FViewList.Assign(MainDataModule.SqlMetaData.Views);
  FViewList.Sort;
  FProcList.Assign(MainDataModule.SqlMetaData.Procedures);
  FProcList.Sort;
  FTriggerList.Assign(MainDataModule.SqlMetaData.Triggers);
  FTriggerList.Sort;
  FGeneratorList.Assign(MainDataModule.SqlMetaData.Generators);
  FGeneratorList.Sort;
  FUdfList.Assign(MainDataModule.SqlMetaData.UDFs);
  FUdfList.Sort;
  FExceptionList.Assign(MainDataModule.SqlMetaData.Exceptions);
  FExceptionList.Sort;
  FRoleList.Assign(MainDataModule.SqlMetaData.Roles);
  FRoleList.Sort;
  if FSConfig.SystemObjectsVisible then
  begin
    FSysTableList.Assign(MainDataModule.SqlMetaData.SystemTables);
    FSySTableLIst.Sort;
    FSysTriggerList.Assign(MainDataModule.SqlMetaData.SystemTriggers);
    FSysTriggerList.Sort;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.TreeViewEvents(ANode: TTreeNode);
var
  temp, obj_Name: string;
begin
  //if ANode.Data = nil then exit;
  lTitle.Caption := TNodeDesc(ANode.Data).ObjDesc;
  obj_name := TNodeDesc(ANode.Data).ObjName;
  if DdlSynMemo.Highlighter = nil then
    DdlSynMemo.Highlighter := MainDataModule.SynSQLSyn1;
  case TNodeDesc(ANode.Data).Nodetype of
    CNT_DATABASE:
    begin
      ShowValues;
      ShowDataBaseItems;
    end;
    CNT_DOMAINS:
    begin
      ShowValues;
      //DdlSynMemo.Lines.Clear;
      //DdlSynMemo.Lines.Assign(dmib.IBMeta.Domains);
      ShowListObject(CNT_DOMAINS);
    end;
    CNT_DOMAIN:
    begin
      try
        ShowBuffer;
        DdlSynMemo.Lines.BeginUpdate;
        DdlSynMemo.Lines.Clear;
        DdlSynMemo.Lines.Text := MainDataModule.SqlMetaData.DomainSource(obj_name);
      finally
        DdlSynMemo.Lines.EndUpdate;
      end;
    end;
    CNT_TABLES:
    begin
      ShowValues;
      ShowListObject(CNT_TABLES);
    end;
    CNT_TABLE, CNT_SYSTABLE:
    begin
      try
        ShowBuffer;
        DdlSynMemo.Lines.BeginUpdate;
        DdlSynMemo.Lines.Clear;
        DdlSynMemo.Lines.Text := MainDataModule.SqlMetaData.TableSource(obj_name);
        temp := MainDataModule.SqlMetaData.PrimaryKeyConstraintSource(obj_name);
        if temp <> '' then
        begin
          DdlSynMemo.Lines.Add(' ');
          DdlSynMemo.Lines.Add('/* Primary key */');
          DdlSynMemo.Lines.Add('');
          DdlSynMemo.Lines.Text := DdlSynMemo.Lines.Text + temp;
        end;
        temp := MainDataModule.SqlMetaData.ForeignKeyConstraintSource(obj_name);
        if temp <> '' then
        begin
          DdlSynMemo.Lines.Add(' ');
          DdlSynMemo.Lines.Add('/* Foreign key(s) */');
          DdlSynMemo.Lines.Add('');
          DdlSynMemo.Lines.Text := DdlSynMemo.Lines.Text + temp;
        end;
        temp := MainDataModule.SqlMetaData.CheckConstraintSource(obj_name);
        if temp <> '' then
        begin
          DdlSynMemo.Lines.Add(' ');
          DdlSynMemo.Lines.Add('/* Check Constraints */');
          DdlSynMemo.Lines.Add('');
          DdlSynMemo.Lines.Text := DdlSynMemo.Lines.Text + temp;
        end;
        temp := MainDataModule.SqlMetaData.UniqueConstraintSource(obj_name);
        if temp <> '' then
        begin
          DdlSynMemo.Lines.Add(' ');
          DdlSynMemo.Lines.Add('/* Unique Constraints */');
          DdlSynMemo.Lines.Add('');
          DdlSynMemo.Lines.Text := DdlSynMemo.Lines.Text + temp;
        end;
        temp := MainDataModule.SqlMetaData.IndexSource(obj_name);
        if temp <> '' then
        begin
          DdlSynMemo.Lines.Add(' ');
          DdlSynMemo.Lines.Add('/* Indices */');
          DdlSynMemo.Lines.Add('');
          DdlSynMemo.Lines.Text := DdlSynMemo.Lines.Text + temp;
        end;
      finally
        DdlSynMemo.Lines.EndUpdate;
      end;  // end try
    end;
    CNT_VIEWS:
    begin
      ShowValues;
      ShowListObject(CNT_VIEWS);
    end;
    CNT_VIEW:
    begin
      try
        ShowBuffer;
        DdlSynMemo.Lines.BeginUpdate;
        DdlSynMemo.Lines.Clear;
        DdlSynMemo.Lines.Text := MainDataModule.SqlMetaData.ViewSource(obj_name);
      finally
        DdlSynMemo.Lines.EndUpdate;
      end;
    end;
    CNT_PROCEDURES:
    begin
      ShowValues;
      ShowListObject(CNT_PROCEDURES);
    end;
    CNT_PROCEDURE:
    begin
      try
        ShowBuffer;
        DdlSynMemo.Lines.BeginUpdate;
        DdlSynMemo.Lines.Clear;
        DdlSynMemo.Lines.Text := MainDataModule.SqlMetaData.ProcedureSource(obj_name);
      finally
        DdlSynMemo.Lines.EndUpdate;
      end;
    end;
    CNT_TRIGGERS:
    begin
      ShowValues;
      ShowListObject(CNT_TRIGGERS);
    end;
    CNT_TRIGGER, CNT_SYSTRIGGER:
    begin
      try
        ShowBuffer;
        DdlSynMemo.Lines.BeginUpdate;
        DdlSynMemo.Lines.Clear;
        DdlSynMemo.Lines.Text :=
          DdlSynMemo.Lines.Text + MainDataModule.SqlMetaData.TriggerSource(obj_name);
        ;
      finally
        DdlSynMemo.Lines.EndUpdate;
      end;
    end;
    CNT_GENERATORS:
    begin
      ShowValues;
      ShowListObject(CNT_GENERATORS);
    end;
    CNT_GENERATOR:
    begin
      try
        ShowBuffer;
        DdlSynMemo.Lines.BeginUpdate;
        DdlSynMemo.Lines.Clear;
        DdlSynMemo.Lines.Add('CREATE GENERATOR ' + obj_name + ';');
        DdlSynMemo.Lines.Add('');
        DdlSynMemo.Lines.add('SET GENERATOR ' + obj_name + ' TO ' +
          MainDataModule.SqlMetaData.GeneratorValue(obj_name) + ';');
      finally
        DdlSynMemo.Lines.EndUpdate;
      end;
    end;
    CNT_UDFS:
    begin
      ShowValues;
      ShowListObject(CNT_UDFS);
    end;
    CNT_UDF:
    begin
      try
        ShowBuffer;
        DdlSynMemo.Lines.BeginUpdate;
        DdlSynMemo.Lines.Clear;
        DdlSynMemo.Lines.Text := MainDataModule.SqlMetaData.UDFSource(obj_name);
      finally
        DdlSynMemo.Lines.EndUpdate;
      end;
    end;
    CNT_EXCEPTIONS:
    begin
      ShowValues;
      ShowListObject(CNT_EXCEPTIONS);
    end;
    CNT_EXCEPTION:
    begin
      try
        ShowBuffer;
        DdlSynMemo.Lines.BeginUpdate;
        DdlSynMemo.Lines.Clear;
        DdlSynMemo.Lines.Text := MainDataModule.SqlMetaData.ExceptionSource(obj_name);
      finally
        DdlSynMemo.Lines.EndUpdate;
      end;
    end;
    CNT_ROLES:
    begin
      ShowValues;
      ShowListObject(CNT_ROLES);
    end;
    CNT_ROLE:
    begin
      try
        ShowBuffer;
        DdlSynMemo.Lines.BeginUpdate;
        DdlSynMemo.Lines.Clear;
        DdlSynMemo.Lines.Add('CREATE ROLE ' + obj_name);
      finally
        DdlSynMemo.Lines.EndUpdate;
      end;
    end;
    CNT_PRIV:
    begin
      ShowBuffer;
      ShowPrivileges(obj_name);
      DdlSynMemo.Highlighter := nil;
    end;
    CNT_DEP:
    begin
      ShowValues;
      ShowDependencies(obj_name);
    end;
    CNT_SYSTABLES:
    begin
      ShowValues;
      ShowListObject(CNT_SYSTABLES);
    end;
    CNT_SYSTRIGGERS:
    begin
      ShowValues;
      ShowListObject(CNT_SYSTRIGGERS);
    end;
    CNT_TRIGGERSINTABLE:
    begin
      ShowValues;
      ShowListObject(CNT_TRIGGERSINTABLE, obj_name);
    end;
    else  // else case
  end;    // end case
  if MainDataModule.BrowserTr.InTransaction then
    MainDataModule.BrowserTr.RollBack;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowValues;
begin
  MainPageControl.PageIndex := 0;
  if not ValuesListView.Visible then
  begin
    ValuesListView.Visible := True;
    ValuesListView.Align := alClient;
    DdlSynMemo.Visible := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowDatabaseItems;
var
  item: TListItem;
  column: TListColumn;
begin
  ValuesListView.Columns.Clear;
  column := ValuesListView.Columns.Add;
  column.Caption := 'Item';
  column.Width := 150;
  column := ValuesListView.Columns.Add;
  column.Caption := 'Value';
  column.Width := 250;
  try
    ValuesListView.Items.Clear;
    item := ValuesListView.Items.Add;
    item.Caption := 'Server Version         ';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(MainDataModule.MainDb.Version);
    item := ValuesListView.Items.Add;
    item.Caption := 'ODS Version';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.ODSVersion));
    item := ValuesListView.Items.Add;
    item.Caption := 'ODS Minor Version';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.ODSMinorVersion));
    item := ValuesListView.Items.Add;
    item.Caption := 'Base Level';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.BaseLevel));
    item := ValuesListView.Items.Add;
    item.Caption := 'Implemetation Num';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.ImplementationNumber));
    item := ValuesListView.Items.Add;
    item.Caption := 'Implemetation Class';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.ImplementationClass));
    item := ValuesListView.Items.Add;
    item.Caption := 'Server type';
    item.ImageIndex := BMP_NONE;
    case MainDataModule.MainDb.ServerInfo of
      siSuperServer: item.SubItems.Add('Super Server');
      siClassicServer: item.SubItems.Add('Classic Server');
      else
        item.SubItems.Add(' ');
    end;
    item := ValuesListView.Items.Add;
    item.Caption := 'Connection type';
    item.ImageIndex := BMP_NONE;
    if MainDataModule.MainDb.IsLocalConnection then
      item.SubItems.Add('Local')
    else
      item.SubItems.Add('Remote');
    item := ValuesListView.Items.Add;
    item.Caption := 'Host name';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(MainDataModule.MainDb.DBSiteName);
    item := ValuesListView.Items.Add;
    item.Caption := 'File name';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(MainDataModule.MainDb.DBFileName);
    item := ValuesListView.Items.Add;
    item.Caption := 'Sql dialect';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.DBSQLDialect));
    item := ValuesListView.Items.Add;
    item.Caption := 'Page size';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.PageSize));
    item := ValuesListView.Items.Add;
    item.Caption := 'Current memory';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.CurrentMemory));
    item := ValuesListView.Items.Add;
    item.Caption := 'Max memory';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.MaxMemory));
    item := ValuesListView.Items.Add;
    item.Caption := 'Allocation';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.Allocation));
    item := ValuesListView.Items.Add;
    item.Caption := 'Num buffers';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.NumBuffers));
    item := ValuesListView.Items.Add;
    item.Caption := 'Sweep interval';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.SweepInterval));
    item := ValuesListView.Items.Add;
    item.Caption := 'Reads';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.Reads));
    item := ValuesListView.Items.Add;
    item.Caption := 'Writes';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.Writes));
    item := ValuesListView.Items.Add;
    item.Caption := 'Fetches';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(MainDataModule.MainDb.Fetches));
    item := ValuesListView.Items.Add;
    item.Caption := 'Default charset';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(MainDataModule.SqlMetaData.DefaultCharset);
    item := ValuesListView.Items.Add;
    item.Caption := 'Current user';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(MainDataModule.SqlMetaData.User);
    item := ValuesListView.Items.Add;
    item.Caption := 'Client library';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(ibase_h.DLL);
    if GetFbClientVersion = 7 then
    begin
      item := ValuesListView.Items.Add;
      item.Caption := 'Client Version';
      item.ImageIndex := BMP_NONE;
      item.SubItems.Add(MainDataModule.MainDb.ClientVersion);
      item := ValuesListView.Items.Add;
      item.Caption := 'Client Major Version';
      item.ImageIndex := BMP_NONE;
      item.SubItems.Add(IntToStr(MainDataModule.MainDb.ClientMajorVersion));
      item := ValuesListView.Items.Add;
      item.Caption := 'Client Minor Version';
      item.ImageIndex := BMP_NONE;
      item.SubItems.Add(IntToStr(MainDataModule.MainDb.ClientMinorVersion));
    end;
  finally
    //ValuesListView.Items.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowListObject(const AObjType: integer;
  const AOption: string = '');
var
  i: integer;
  Item: TListItem;
  Column: TListColumn;
begin
  ValuesListView.Columns.Clear;
  ValuesListView.Items.Clear;
  case AObjType of
    CNT_DOMAINS:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'Domains';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FDomainList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FDomainList.Strings[i];
        Item.ImageIndex := BMP_DOMAIN;
      end;
    end;
    CNT_TABLES:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'Tables';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FTableList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FTableList.Strings[i];
        Item.ImageIndex := BMP_TABLE;
      end;
    end;
    CNT_VIEWS:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'Views';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FViewList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FViewList.Strings[i];
        Item.ImageIndex := BMP_VIEW;
      end;
    end;
    CNT_PROCEDURES:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'Procedures';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FProcList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FProcList.Strings[i];
        Item.ImageIndex := BMP_PROCEDURE;
      end;
    end;
    CNT_TRIGGERS:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'Triggers';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FTriggerList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FTriggerList.Strings[i];
        Item.ImageIndex := BMP_TRIGGER;
      end;
    end;
    CNT_GENERATORS:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'Generators';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FGeneratorList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FGeneratorList.Strings[i];
        Item.ImageIndex := BMP_GENERATOR;
      end;
    end;
    CNT_UDFS:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'UDFS';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FUdfList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FUdfList.Strings[i];
        Item.ImageIndex := BMP_UDF;
      end;
    end;
    CNT_EXCEPTIONS:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'Exceptions';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FExceptionList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FExceptionList.Strings[i];
        Item.ImageIndex := BMP_UDF;
      end;
    end;
    CNT_ROLES:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'Roles';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FRoleList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FRoleList.Strings[i];
        Item.ImageIndex := BMP_ROLE;
      end;
    end;
    CNT_SYSTABLES:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'System Tables';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FSysTableList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FSysTableList.Strings[i];
        Item.ImageIndex := BMP_SYSTEMTABLE;
      end;
    end;
    CNT_SYSTRIGGERS:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'System Triggers';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to FSysTriggerList.Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := FSysTriggerList.Strings[i];
        Item.ImageIndex := BMP_SYSTEMTRIGGER;
      end;
    end;
    CNT_TRIGGERSINTABLE:
    begin
      Column := ValuesListView.Columns.Add;
      Column.Caption := 'Triggers';
      Column.Width := 150;
      //Column.AutoSize := True;
      for i := 0 to MainDataModule.SqlMetaData.TriggersInTable(AOption).Count - 1 do
      begin
        Item := ValuesListView.Items.Add;
        Item.Caption := MainDataModule.SqlMetaData.TriggersInTable(AOption).Strings[i];
        Item.ImageIndex := BMP_TRIGGER;
      end;
    end;
    else
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowPrivileges(const ASqlOBj: string);
var
  listUsers: TStringList;
  i: integer;
  sTmp: string;

  function DesExtend(const ADesc: string): string;
  begin
    if ADesc = 'S' then
      Result := 'SELECT'
    else if ADesc = 'I' then
      Result := 'INSERT'
    else if ADesc = 'U' then
      Result := 'UPDATE'
    else if ADesc = 'D' then
      Result := 'DELETE'
    else if ADesc = 'R' then
      Result := 'REFERENCE'
    else if ADesc = 'X' then
      Result := 'EXECUTE'
    else if ADesc = 'M' then
      Result := 'MEMBER'
    else
      Result := ADesc;
  end;

const
  CFORMAT = #9 + '%-31s%-10s%-20s%';
begin
  listUsers := TStringList.Create;
  DdlSynMemo.Lines.Clear;
  try
    if not MainDataModule.BrowserTr.InTransaction then
      MainDataModule.BrowserTr.StartTransaction;
    with MainDataModule do
    begin
      BrowserQry.SQL.Text :=
        'SELECT DISTINCT RDB$USER FROM RDB$USER_PRIVILEGES WHERE RDB$RELATION_NAME = ?';
      BrowserQry.Prepare;
      BrowserQry.ParamAsString(0, ASqlOBj);
      BrowserQry.ExecSQL;
      while not BrowserQry.EOF do
      begin
        ListUsers.Add(trim(BrowserQry.FieldAsString(0)));
        BrowserQry.Next;
      end;
      BrowserQry.UnPrepare;

      BrowserQry.SQL.Text := 'SELECT RDB$PRIVILEGE,RDB$GRANT_OPTION, RDB$USER_TYPE,' +
        'RDB$GRANTOR , RDB$FIELD_NAME ' + 'FROM RDB$USER_PRIVILEGES ' +
        'WHERE RDB$RELATION_NAME = ? AND RDB$USER = ? ORDER BY RDB$PRIVILEGE';
      BrowserQry.Prepare;

      for i := 0 to ListUsers.Count - 1 do
      begin
        BrowserQry.ParamAsString(0, ASqlOBj);
        BrowserQry.ParamAsString(1, listUsers.Strings[i]);
        BrowserQry.ExecSQL;

        if BrowserQry.FieldAsLong(2) = 13 then
          sTmp := 'ROLE: ' + listUsers.Strings[i]
        else
          sTmp := 'USER: ' + listUsers.Strings[i];
        DdlSynMemo.Lines.Add(sTmp);
        DdlSynMemo.Lines.Add(Format(CFORMAT, ['GRANTOR', 'PRIVIL.', 'OPTION']));
        DdlSynMemo.Lines.Add(#9 + StringOfChar('-', 61));
        while not BrowserQry.EOF do
        begin
          if (BrowserQry.FieldAsLong(1) = 1) then
            sTmp := 'WITH GRANT OPTION'
          else if (BrowserQry.FieldAsLong(1) = 2) then
            sTmp := 'WITH ADMIN OPTION'
          else
            sTmp := '';
          DdlSynMemo.Lines.Add(format(CFORMAT,
            [trim(BrowserQry.FieldAsString(3)),
            DesExtend(Trim(BrowserQry.FieldAsString(0))), sTmp]));
          BrowserQry.Next;
        end;
        BrowserQry.Close;
        DdlSynMemo.Lines.Add(' ');
      end;
      BrowserQry.UnPrepare;
    end;
  finally
    ListUsers.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowDependencies(const ASqlObj: string);

  function DescType(t: integer): string;
  begin
    case t of
      0: Result := 'TABLE';
      1: Result := 'VIEW';
      2: Result := 'TRIGGER';
      3: Result := 'COMPUTED_FIELD';
      4: Result := 'VALIDATION';
      5: Result := 'PROCEDURE';
      6: Result := 'EXPRESSION_INDEX';
      7: Result := 'EXCEPTION';
      8: Result := 'USER';
      9: Result := 'FIELD';
      10: Result := 'INDEX';
      else
        Result := '';
    end;
  end;

  function ImageBmp(const ABmp: integer): integer;
  begin
    case ABmp of
      0: Result := BMP_TABLE;      // TABLE
      1: Result := BMP_VIEW;       // VIEW
      2: Result := BMP_TRIGGER;    // TRIGGER
      3: Result := BMP_DOMAIN;     // COMPUTED_FIELD
      4: Result := -1;             // VALIDATION
      5: Result := BMP_PROCEDURE;  // PROCEDURE
      6: Result := -1;             // EXPRESSION_INDEX
      7: Result := BMP_EXCEPTION;  // EXCEPTION
      8: Result := -1;             // USER
      9: Result := BMP_DOMAIN;     // FIELD
      10: Result := -1;             // INDEX
      else
        Result := -1;
    end;
  end;

var
  item: TListItem;
  column: TListColumn;
begin
  ValuesListView.Columns.Clear;
  column := ValuesListView.Columns.Add;
  column.Caption := 'Type';
  column.Width := 150;
  //column.AutoSize := True;
  column := ValuesListView.Columns.Add;
  column.Caption := 'Object';
  column.Width := 150;
  //column.AutoSize := True;
  column := ValuesListView.Columns.Add;
  column.Caption := 'Fields';
  column.Width := 150;
  //column.AutoSize := True;

  if not MainDataModule.BrowserTr.InTransaction then
    MainDataModule.BrowserTr.StartTransaction;
  with MainDataModule do
  begin
    try
      //ValuesListView.Items.BeginUpdate;
      ValuesListView.Items.Clear;
      //DdlSynMemo.Lines.Clear;
      BrowserQry.SQL.Text := 'select  RDB$DEPENDED_ON_NAME ,' +
        'RDB$FIELD_NAME,' + 'RDB$DEPENDED_ON_TYPE ' + 'from rdb$dependencies ' +
        'where rdb$dependent_name = ? ' + 'ORDER BY RDB$DEPENDED_ON_NAME';
      BrowserQry.Prepare;
      BrowserQry.ParamAsString(0, ASqlObj);
      BrowserQry.ExecSQL;

      while not BrowserQry.EOF do
      begin
        item := ValuesListView.Items.Add;
        item.Caption := DescType(BrowserQry.FieldAsLong(2));
        item.ImageIndex := ImageBmp(BrowserQry.FieldAsLong(2));
        item.SubItems.Add(BrowserQry.FieldAsString(0));
        item.SubItems.Add(BrowserQry.FieldAsString(1));
        BrowserQry.Next;
      end;
      BrowserQry.UnPrepare;
      ;
      BrowserQry.SQL.Text := 'SELECT RDB$DEPENDENT_NAME ,' +
        'RDB$FIELD_NAME,' + 'RDB$DEPENDENT_TYPE ' + 'from rdb$dependencies ' +
        'where rdb$depended_on_name = ? ' + 'ORDER BY  RDB$DEPENDENT_NAME ';
      BrowserQry.Prepare;
      BrowserQry.ParamAsString(0, ASqlObj);
      BrowserQry.ExecSQL;

      while not BrowserQry.EOF do
      begin
        item := ValuesListView.Items.Add;
        item.Caption := DescType(BrowserQry.FieldAsLong(2));
        item.ImageIndex := ImageBmp(BrowserQry.FieldAsLong(2));
        item.SubItems.Add(BrowserQry.FieldAsString(0));
        item.SubItems.Add(BrowserQry.FieldAsString(1));
        BrowserQry.Next;
      end;
    finally
      //ValuesListView.Items.EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.SetOutputType(const AType: integer);
begin
  case AType of
    1:
    begin
      ResultSetStringGrid.Visible := False;
      ClearDataGrid;
      ResultSetSynMemo.Align := alClient;
      ResultSetSynMemo.Visible := True;
    end;
    else
      ResultSetSynMemo.Visible := False;
      ResultSetSynMemo.Lines.Clear;
      ResultSetStringGrid.Align := alClient;
      ResultSetStringGrid.Visible := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowTableView(const ATableName: string);
var
  TableViewForm: TTableViewForm;
begin
  TableViewForm := TTableViewForm.Create(self);
  try
    TableViewForm.TableName := ATableName;
    TableViewForm.ShowModal;
  finally
    TableViewForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.LoadFontColor;
var
  MyColor: TColor;
begin
  MyColor := DdlSynMemo.Color;
  ReadConfigEdit(SECTION_FONT_BROWSER, DdlSynMemo.Font, MyColor);
  DdlSynMemo.Color := MyColor;
  MyColor := SqlSynEdit.Color;
  ReadConfigEdit(SECTION_FONT_EDIT, SqlSynEdit.Font, MyColor);
  SqlSynEdit.Color := MyColor;
  MyColor := ResultSetSynMemo.Color;
  ReadConfigEdit(SECTION_FONT_TEXTGRID, ResultSetSynMemo.Font, MyColor);
  ResultSetSynMemo.Color := MyColor;
  ReadConfigSynEdit;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowObjectDescription(const AType: integer;
  const ASqlObject: string);
var
  DescriptionForm: TDescriptionForm;
begin
  DescriptionForm := TDescriptionForm.Create(Self);
  try
    case AType of
      CNT_TABLE, CNT_VIEW, CNT_SYSTABLE:
      begin
        if not MainDataModule.BrowserTr.InTransaction then
          MainDataModule.BrowserTr.StartTransaction;
        MainDataModule.BrowserQry.SQL.Text :=
          'SELECT RDB$DESCRIPTION FROM RDB$RELATIONS WHERE RDB$RELATION_NAME = ?';
        MainDataModule.BrowserQry.Prepare;
        MainDataModule.BrowserQry.ParamAsString(0, ASqlObject);
        MainDataModule.BrowserQry.ExecSQL;
        DescriptionForm.Caption := 'Description :: ' + ASqlObject;
        DescriptionForm.Text := MainDataModule.BrowserQry.FieldAsString(0);
        MainDataModule.BrowserQry.Close;
        if DescriptionForm.ShowModal = mrOk then
        begin
          if DescriptionForm.Text <> '' then
          begin
            MainDataModule.BrowserQry.SQL.Text :=
              'UPDATE RDB$RELATIONS SET RDB$DESCRIPTION = ? WHERE RDB$RELATION_NAME = ?';
            MainDataModule.BrowserQry.Prepare;
            MainDataModule.BrowserQry.ParamAsString(0, DescriptionForm.Text);
            MainDataModule.BrowserQry.ParamAsString(1, ASqlObject);
            MainDataModule.BrowserQry.ExecSQL;
            MainDataModule.BrowserQry.Close;
          end;
        end;
        MainDataModule.BrowserTr.Commit;
      end;

      CNT_DOMAIN:
      begin
        if not MainDataModule.BrowserTr.InTransaction then
          MainDataModule.BrowserTr.StartTransaction;
        MainDataModule.BrowserQry.SQL.Text :=
          'SELECT RDB$DESCRIPTION FROM RDB$FIELDS WHERE RDB$FIELD_NAME = ?';
        MainDataModule.BrowserQry.Prepare;
        MainDataModule.BrowserQry.ParamAsString(0, ASqlObject);
        MainDataModule.BrowserQry.ExecSQL;
        DescriptionForm.Caption := 'Description :: ' + ASqlObject;
        DescriptionForm.Text := MainDataModule.BrowserQry.FieldAsString(0);
        MainDataModule.BrowserQry.Close;
        if DescriptionForm.ShowModal = mrOk then
        begin
          if DescriptionForm.Text <> '' then
          begin
            MainDataModule.BrowserQry.SQL.Text :=
              'UPDATE RDB$FIELDS SET RDB$DESCRIPTION = ? WHERE RDB$FIELD_NAME = ?';
            MainDataModule.BrowserQry.Prepare;
            MainDataModule.BrowserQry.ParamAsString(0, DescriptionForm.Text);
            MainDataModule.BrowserQry.ParamAsString(1, ASqlObject);
            MainDataModule.BrowserQry.ExecSQL;
            MainDataModule.BrowserQry.Close;
          end;
        end;
        MainDataModule.BrowserTr.Commit;
      end;

      CNT_PROCEDURE:
      begin
        if not MainDataModule.BrowserTr.InTransaction then
          MainDataModule.BrowserTr.StartTransaction;
        MainDataModule.BrowserQry.SQL.Text :=
          'SELECT RDB$DESCRIPTION FROM RDB$PROCEDURES WHERE RDB$PROCEDURE_NAME = ?';
        MainDataModule.BrowserQry.Prepare;
        MainDataModule.BrowserQry.ParamAsString(0, ASqlObject);
        MainDataModule.BrowserQry.ExecSQL;
        DescriptionForm.Caption := 'Description :: ' + ASqlObject;
        DescriptionForm.Text := MainDataModule.BrowserQry.FieldAsString(0);
        MainDataModule.BrowserQry.Close;
        if DescriptionForm.ShowModal = mrOk then
        begin
          if DescriptionForm.Text <> '' then
          begin
            MainDataModule.BrowserQry.SQL.Text :=
              'UPDATE RDB$PROCEDURES SET RDB$DESCRIPTION = ? WHERE RDB$PROCEDURE_NAME = ?';
            MainDataModule.BrowserQry.Prepare;
            MainDataModule.BrowserQry.ParamAsString(0, DescriptionForm.Text);
            MainDataModule.BrowserQry.ParamAsString(1, ASqlObject);
            MainDataModule.BrowserQry.ExecSQL;
            MainDataModule.BrowserQry.Close;
          end;
        end;
        MainDataModule.BrowserTr.Commit;
      end;

      CNT_TRIGGER, CNT_SYSTRIGGER:
      begin
        if not MainDataModule.BrowserTr.InTransaction then
          MainDataModule.BrowserTr.StartTransaction;
        MainDataModule.BrowserQry.SQL.Text :=
          'SELECT RDB$DESCRIPTION FROM RDB$TRIGGERS WHERE RDB$TRIGGER_NAME = ?';
        MainDataModule.BrowserQry.Prepare;
        MainDataModule.BrowserQry.ParamAsString(0, ASqlObject);
        MainDataModule.BrowserQry.ExecSQL;
        DescriptionForm.Caption := 'Description :: ' + ASqlObject;
        DescriptionForm.Text := MainDataModule.BrowserQry.FieldAsString(0);
        MainDataModule.BrowserQry.Close;
        if DescriptionForm.ShowModal = mrOk then
        begin
          if DescriptionForm.Text <> '' then
          begin
            MainDataModule.BrowserQry.SQL.Text :=
              'UPDATE RDB$TRIGGER SET RDB$DESCRIPTION = ? WHERE RDB$TRIGGER_NAME = ?';
            MainDataModule.BrowserQry.Prepare;
            MainDataModule.BrowserQry.ParamAsString(0, DescriptionForm.Text);
            MainDataModule.BrowserQry.ParamAsString(1, ASqlObject);
            MainDataModule.BrowserQry.ExecSQL;
            MainDataModule.BrowserQry.Close;
          end;
        end;
        MainDataModule.BrowserTr.Commit;
      end;

      CNT_UDF:
      begin
        if not MainDataModule.BrowserTr.InTransaction then
          MainDataModule.BrowserTr.StartTransaction;
        MainDataModule.BrowserQry.SQL.Text :=
          'SELECT RDB$DESCRIPTION FROM RDB$FUNCTIONS WHERE RDB$FUNCTION_NAME = ?';
        MainDataModule.BrowserQry.Prepare;
        MainDataModule.BrowserQry.ParamAsString(0, ASqlObject);
        MainDataModule.BrowserQry.ExecSQL;
        DescriptionForm.Caption := 'Description :: ' + ASqlObject;
        DescriptionForm.Text := MainDataModule.BrowserQry.FieldAsString(0);
        MainDataModule.BrowserQry.Close;
        if DescriptionForm.ShowModal = mrOk then
        begin
          if DescriptionForm.Text <> '' then
          begin
            MainDataModule.BrowserQry.SQL.Text :=
              'UPDATE RDB$FUNCTIONS SET RDB$DESCRIPTION = ? WHERE RDB$FUNCTION_NAME = ?';
            MainDataModule.BrowserQry.Prepare;
            MainDataModule.BrowserQry.ParamAsString(0, DescriptionForm.Text);
            MainDataModule.BrowserQry.ParamAsString(1, ASqlObject);
            MainDataModule.BrowserQry.ExecSQL;
            MainDataModule.BrowserQry.Close;
          end;
        end;
        MainDataModule.BrowserTr.Commit;
      end;

      CNT_EXCEPTION:
      begin
        if not MainDataModule.BrowserTr.InTransaction then
          MainDataModule.BrowserTr.StartTransaction;
        MainDataModule.BrowserQry.SQL.Text :=
          'SELECT RDB$DESCRIPTION FROM RDB$EXCEPTIONS WHERE RDB$EXCEPTION_NAME = ?';
        MainDataModule.BrowserQry.Prepare;
        MainDataModule.BrowserQry.ParamAsString(0, ASqlObject);
        MainDataModule.BrowserQry.ExecSQL;
        DescriptionForm.Caption := 'Description :: ' + ASqlObject;
        DescriptionForm.Text := MainDataModule.BrowserQry.FieldAsString(0);
        MainDataModule.BrowserQry.Close;
        if DescriptionForm.ShowModal = mrOk then
        begin
          if DescriptionForm.Text <> '' then
          begin
            MainDataModule.BrowserQry.SQL.Text :=
              'UPDATE RDB$EXCEPTIONS SET RDB$DESCRIPTION = ? WHERE RDB$EXCEPTION_NAME = ?';
            MainDataModule.BrowserQry.Prepare;
            MainDataModule.BrowserQry.ParamAsString(0, DescriptionForm.Text);
            MainDataModule.BrowserQry.ParamAsString(1, ASqlObject);
            MainDataModule.BrowserQry.ExecSQL;
            MainDataModule.BrowserQry.Close;
          end;
        end;
        MainDataModule.BrowserTr.Commit;
      end;

      CNT_ROLE:
      begin
        if not MainDataModule.BrowserTr.InTransaction then
          MainDataModule.BrowserTr.StartTransaction;
        MainDataModule.BrowserQry.SQL.Text :=
          'SELECT RDB$DESCRIPTION FROM RDB$ROLES WHERE RDB$ROLE_NAME = ?';
        MainDataModule.BrowserQry.Prepare;
        MainDataModule.BrowserQry.ParamAsString(0, ASqlObject);
        MainDataModule.BrowserQry.ExecSQL;
        DescriptionForm.Caption := 'Description :: ' + ASqlObject;
        DescriptionForm.Text := MainDataModule.BrowserQry.FieldAsString(0);
        MainDataModule.BrowserQry.Close;
        if DescriptionForm.ShowModal = mrOk then
        begin
          if DescriptionForm.Text <> '' then
          begin
            MainDataModule.BrowserQry.SQL.Text :=
              'UPDATE RDB$ROLES SET RDB$DESCRIPTION = ? WHERE RDB$ROLE_NAME = ?';
            MainDataModule.BrowserQry.Prepare;
            MainDataModule.BrowserQry.ParamAsString(0, DescriptionForm.Text);
            MainDataModule.BrowserQry.ParamAsString(1, ASqlObject);
            MainDataModule.BrowserQry.ExecSQL;
            MainDataModule.BrowserQry.Close;
          end;
        end;
        MainDataModule.BrowserTr.Commit;
      end;
      else
    end;
  finally
    DescriptionForm.Free;
  end;
end;

procedure TBrowserForm.LogMessage(const AMsg: string; AImageIndex: integer = -1);
var
  TreeNode: TTreeNode;
begin
  TreeNode := MessagesTreeView.Items.Add(nil, AMsg);
  TreeNode.StateIndex := AImageIndex;
  MessagesTreeView.Selected := MessagesTreeView.Items.GetLastNode;
end;

procedure TBrowserForm.LogErrorMessage(const AMsg: string; const AErrorMsg: string;
  AImageIndex: integer = -1; AImageErrorIndex: integer = -1);
var
  TreeNode, TreeChildNode: TTreeNode;
  sl: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  try
    sl.Text := AErrorMsg;
    TreeNode := MessagesTreeView.Items.Add(nil, AMsg);
    TreeNode.StateIndex := AImageIndex;
    for i := 0 to sl.Count - 1 do
    begin
      TreeChildNode := MessagesTreeView.Items.AddChild(TreeNode, sl.Strings[i]);
      TreeChildNode.StateIndex := AImageErrorIndex;
    end;
    MessagesTreeView.Selected := MessagesTreeView.Items.GetLastNode;
  finally
    sl.Free;
  end;
end;

procedure TBrowserForm.EditLineError(ALineError: Integer);
begin
   FLineWithError := ALineError;
   SqlSynEdit.Invalidate;
end;

procedure TBrowserForm.EditResetError;
begin
   FLineWithError := 0;
   SqlSynEdit.Invalidate;
end;



//------------------------------------------------------------------------------
{Events procedure}

procedure TBrowserForm.FormCreate(Sender: TObject);
begin
  FErrorDllNotFound := False;
  Script := TFBLScript.Create(self);
  FHIstory := TStringList.Create;
  FDomainList := TStringList.Create;
  FTableList := TStringList.Create;
  FViewList := TStringList.Create;
  FProcList := TStringList.Create;
  FTriggerList := TStringList.Create;
  FGeneratorList := TStringList.Create;
  FUdfList := TStringList.Create;
  FExceptionList := TStringList.Create;
  FRoleList := TStringList.Create;
  FSysTableList := TStringList.Create;
  FSysTriggerList := TStringList.Create;
  FHistoryIdx := 0;
  Caption := APP_TITLE + ' ' + APP_VERSION;
  FExecutedDDLstm := False;
  Self.Top := (Screen.Height - DEFAULT_HEIGHT) div 2;
  Self.Left := (Screen.Width - DEFAULT_WIDTH) div 2;
  Self.Height := DEFAULT_HEIGHT;
  Self.Width := DEFAULT_WIDTH;
  try
    ibase_h.CheckFbClientLoaded;
    FsConfig.SetDefaultVariable;
    FsConfig.InitFileConfig;
    //ReadAliasNames;
    FsConfig.ReadConfigFile;
    DoAfterDisconnect;
    FsConfig.LoadFormPos(Self);
  except
    on E: Exception do
      FErrorDllNotFound := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ViewDataActionExecute(Sender: TObject);
begin
  if Assigned(DbTreeView.Selected) then
  begin
    if Assigned(TNodeDesc(DbTreeView.Selected.Data)) then
    begin
      if (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_TABLE) or
        (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_VIEW) or
        (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_SYSTABLE) then
        ShowTableView(TNodeDesc(DbTreeView.Selected.Data).ObjName);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.CreateDbActionExecute(Sender: TObject);
var
  CreateDBForm: TCreateDBForm;
begin
  CreateDBForm := TCreateDBForm.Create(self);
  try
    CreateDBForm.ShowModal;
  finally
    CreateDBForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ClearMessagesActionExecute(Sender: TObject);
begin
  try
    MessagesTreeView.Items.BeginUpdate;
    MessagesTreeView.Items.Clear;
  finally
    MessagesTreeView.Items.EndUpdate;
  end;
end;


//------------------------------------------------------------------------------

procedure TBrowserForm.ExportToSqlActionExecute(Sender: TObject);
begin
  if not MainDataModule.BrowserTr.InTransaction then
    MainDataModule.BrowserTr.StartTransaction;
  if Assigned(DbTreeView.Selected.Data) then
    if (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_TABLE) or
      (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_SYSTABLE) then
    begin
      try
        MainDataModule.BrowserQry.SQL.Text :=
          'select * from ' + TNodeDesc(DbTreeView.Selected.Data).ObjName;
        MainDataModule.BrowserQry.ExecSQL;
        SaveDialog.DefaultExt := 'sql';
        SaveDialog.Filter := 'sql script (*.sql)|*.sql|Text (*.txt)|*.txt|Any(*.*)|*.*';
        SaveDialog.Title := 'Export table ::' +
          TNodeDesc(DbTreeView.Selected.Data).ObjName + ':: To sql script';
        if SaveDialog.Execute then
        begin
          ExportToSQLScript(MainDataModule.BrowserQry,
            TNodeDesc(DbTreeView.Selected.Data).ObjName,
            SaveDialog.FileName);
          ShowMessage('File: [' + SaveDialog.FileName + '] created' +
            LineEnding + IntToStr(MainDataModule.BrowserQry.FetchCount) +
            ' record exported');
        end;
      finally
        MainDataModule.BrowserQry.UnPrepare;
      end;
    end;
end;

procedure TBrowserForm.ResultSetToCsvExecute(Sender: TObject);
begin
  MainDataModule.MainQry.Close;
  MainDataModule.MainQry.ExecSQL;
  SaveDialog.DefaultExt := 'csv';
  SaveDialog.Filter :=
    'comma separated values (*.csv)|*.csv|Text (*.txt)|*.txt|Any(*.*)|*.*';
  SaveDialog.Title := 'Export resultset  to csv';
  if SaveDialog.Execute then
  begin
    ExportToCsvFile(MainDataModule.MainQry, SaveDialog.FileName);
    ShowMessage('File: [' + SaveDialog.FileName + '] created' +
      LineEnding + IntToStr(MainDataModule.MainQry.FetchCount) + ' record exported');
  end;
end;

procedure TBrowserForm.ResultSetToJsonExecute(Sender: TObject);
begin
  MainDataModule.MainQry.Close;
  MainDataModule.MainQry.ExecSQL;
  SaveDialog.DefaultExt := 'js';
  SaveDialog.Filter :=
    'javascript (*.js)|*.js|json (*.json)|*.json|Text (*.txt)|*.txt|Any(*.*)|*.*';
  SaveDialog.Title := 'Export resultset  to Json';
  if SaveDialog.Execute then
  begin
    ExportToJson(MainDataModule.MainQry, SaveDialog.FileName);
    ShowMessage('File: [' + SaveDialog.FileName + '] created' +
      LineEnding + IntToStr(MainDataModule.MainQry.FetchCount) + ' record exported');
  end;
end;


//------------------------------------------------------------------------------

procedure TBrowserForm.ServiceMgrActionExecute(Sender: TObject);
var
  ServiceForm: TServiceForm;
begin
  ServiceForm := TServiceForm.Create(self);
  try
    ServiceForm.ShowModal;
  finally
    ServiceForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowAboutActionExecute(Sender: TObject);
begin
  fsabout.ShowAbout(APP_VERSION, 'alessandro batisti', APP_PROJECT_URL);
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowOptionDescriptionActionExecute(Sender: TObject);
begin
  if Assigned(DbTreeView.Selected.Data) then
  begin
    if Assigned(DbTreeView.Selected.Data) then
    begin
      case TNodeDesc(DbTreeView.Selected.Data).Nodetype of
        CNT_DOMAIN:
          ShowObjectDescription(CNT_DOMAIN, TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_TABLE:
          ShowObjectDescription(CNT_TABLE, TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_VIEW:
          ShowObjectDescription(CNT_VIEW, TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_PROCEDURE:
          ShowObjectDescription(CNT_PROCEDURE,
            TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_TRIGGER:
          ShowObjectDescription(CNT_TRIGGER,
            TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_GENERATOR:
          ShowObjectDescription(CNT_GENERATOR,
            TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_UDF:
          ShowObjectDescription(CNT_UDF, TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_EXCEPTION:
          ShowObjectDescription(CNT_EXCEPTION,
            TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_ROLE:
          ShowObjectDescription(CNT_ROLE, TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_SYSTABLE:
          ShowObjectDescription(CNT_SYSTABLE,
            TNodeDesc(DbTreeView.Selected.Data).ObjName);
        CNT_SYSTRIGGER:
          ShowObjectDescription(CNT_SYSTRIGGER,
            TNodeDesc(DbTreeView.Selected.Data).ObjName);
        else
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowOptionsActionExecute(Sender: TObject);
var
  OptionsForm: TOptionsForm;
begin
  OptionsForm := TOptionsForm.Create(Self);
  try
    if OptionsForm.ShowModal = mrOk then
    begin
      MainDataModule.MainQry.MaxFetch := FsConfig.MaxFetchResult;
      MainDataModule.SqlMetaData.SetTerm := FsConfig.SetTermVisible;
      SetOutputType(FsConfig.OutputGridType);
      RefreshStatusBar;
    end;
  finally
    OptionsForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ShowTextOptionsActionExecute(Sender: TObject);
var
  UserModForm: TTextOptionsForm;
begin
  UserModForm := TTextOptionsForm.Create(nil);
  try
    UserModForm.FontDDL := DdlSynMemo.Font;
    UserModForm.ColorDDL := DdlSynMemo.Color;
    UserModForm.FontSQL := SqlSynEdit.Font;
    UserModForm.ColorSQL := SqlSynEdit.Color;
    UserModForm.FontTextGrid := ResultSetSynMemo.Font;
    UserModForm.ColorTextGrid := ResultSetSynMemo.Color;
    if UserModForm.ShowModal = mrOk then
    begin
      if UserModForm.DDLChanged then
      begin
        DdlSynMemo.Font := UserModForm.FontDDL;
        DdlSynMemo.Color := UserModForm.ColorDDL;
        WriteConfigEdit(SECTION_FONT_BROWSER, DdlSynMemo.Font, DdlSynMemo.Color);
      end;
      if UserModForm.SQLChanged then
      begin
        SqlSynEdit.Font := UserModForm.FontSQL;
        SqlSynEdit.Color := UserModForm.ColorSQL;
        WriteConfigEdit(SECTION_FONT_EDIT, SqlSynEdit.Font, SqlSynEdit.Color);
      end;
      if UserModForm.TextGridChanged then
      begin
        ResultSetSynMemo.Font := UserModForm.FontTextGrid;
        ResultSetSynMemo.Color := UserModForm.ColorTextGrid;
        WriteConfigEdit(SECTION_FONT_TEXTGRID, ResultSetSynMemo.Font,
          ResultSetSynMemo.Color);
      end;
    end;
  finally
    UserModForm.Free;
  end;
end;

procedure TBrowserForm.SqlCreateTableActionExecute(Sender: TObject);
begin
   SqlSynEdit.Lines.Text:=TableCreate('TableName');;
end;

procedure TBrowserForm.SqlCreateTableAutoIncExecute(Sender: TObject);
var
  TableName: string;
begin
   TableName := InputBox('table name',
    'New Table with PK Autoinc','');
  if TableName  <> ''  then
       SqlSynEdit.Lines.Text := TableCreateWithAutoIncrement(TableName);
end;


procedure TBrowserForm.SqlSynEditSpecialLineColors(Sender: TObject;
  Line: integer; var Special: boolean; var FG, BG: TColor);
begin
  if Line = FLineWithError then
  begin
    FG := clWhite;
    BG := clRed;
   special := true;
  end;
end;



//------------------------------------------------------------------------------

procedure TBrowserForm.UsersActionExecute(Sender: TObject);
var
  UsersForm: TUsersForm;
  pUser, pPassword: string;
  ShowLogin: boolean;
begin
  if MainDataModule.MainDb.Connected then
  begin
    pUser := MainDataModule.MainDb.User;
    pPassword := MainDataModule.MainDb.Password;
    //pRole := MainDataModule.MainDb.Role;
    ShowLogin := True;
  end
  else
    ShowLogin := fslogin.FbDbLogin('SecurDb', pUser, pPassword);

  UsersForm := TUsersForm.Create(self, pUser, pPassword);
  try
    if ShowLogin then
      if UsersForm.TryFetchList then
        UsersForm.ShowModal;
  finally
    UsersForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FCurrentAlias <> '' then
    fsconfig.SaveHistory(FcurrentAlias, FHistory);
  fsconfig.SaveFormPos(self);
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  DialogTransForm: TDialogTransForm;
begin
  DialogTransForm := TDialogTransForm.Create(self);
  try
    if not FErrorDllNotFound then
    begin
      if MainDataModule.MainTr.InTransaction then
        case DialogTransForm.ShowModal of
          mrYes:
          begin
            MainDataModule.MainTr.Commit;
            CanClose := True;
          end;
          mrNo:
          begin
            MainDataModule.MainTr.RollBack;
            CanClose := True;
          end;
          mrCancel:
            CanClose := False;
        end;
    end;
  finally
    DialogTransForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.FormDestroy(Sender: TObject);
begin
  Script.Free;
  FParamValue := nil;
  FColDesc := nil;
  FHistory.Free;
  FDomainList.Free;
  FTableList.Free;
  FViewList.Free;
  FProcList.Free;
  FTriggerList.Free;
  FGeneratorList.Free;
  FUdfList.Free;
  FExceptionList.Free;
  FRoleList.Free;
  FSysTableList.Free;
  FSysTriggerList.Free;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.FormShow(Sender: TObject);
begin
  LoadFontColor;
  MainDataModule.MainQry.MaxFetch := FsConfig.MaxFetchResult;
  MainDataModule.SqlMetaData.SetTerm := FsConfig.SetTermVisible;
  SetOutputType(FsConfig.OutputGridType);
  DdlSynMemo.Highlighter := MainDataModule.SynSQLSyn1;
  SqlSynEdit.Highlighter := MainDataModule.SynSQLSyn1;
  DdlSynMemo.Align := alClient;
  if FErrorDllNotFound then
  begin
    ShowMessage('firebird client dll library [fbclient.dll or gds32.dll] not found');
    Close();
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.BackupDatabaseActionExecute(Sender: TObject);
begin
  fsbackup.DatabaseBackup(MainDataModule.MainDb);
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ClearHistoryActionExecute(Sender: TObject);
begin
  if MessageDlg('Clear History :: ' + FCurrentAlias, mtConfirmation, [mbYes, mbNo], 0) =
    mrYes then
  begin
    FHistoryIdx := 0;
    PreviousAction.Enabled := False;
    NextAction.Enabled := False;
    FHistory.Clear;
    fsconfig.DeleteHistory(FCurrentAlias);
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.CommitActionExecute(Sender: TObject);
begin
  try
    LogMessage(' ');
    MainDataModule.MainTr.Commit;
    LogMessage(Format(rsTransactionC, [TimeToStr(Now)]),BMP_TVM_COMMIT);
    EndTr(True);
  except
    on E: EFBLError do
    begin
      LogErrorMessage(Format(rsErrorInTrans, [E.ISC_ErrorCode]), E.Message,BMP_TVM_ERROR);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.DbConnectionsActionExecute(Sender: TObject);
var
  ConParams: TFsConnectionsParams;
begin
  ConParams.AliasName := fsconfig.LastAliasConnected;
  if not DbConnection(@ConParams) then
    Exit;

  if ConParams.Protocol = fsdbconnections.PROTOCOL_LOCAL then
    MainDataModule.MainDb.Protocol := ptLocal
  else if ConParams.Protocol = fsdbconnections.PROTOCOL_TCP_IP then
  begin
    MainDataModule.MainDb.Protocol := ptTcpIp;
    MainDataModule.MainDb.Host := ConParams.Host;
  end
  else if ConParams.Protocol = fsdbconnections.PROTOCOL_NETBEUI then
  begin
    MainDataModule.MainDb.Protocol := ptNetBeui;
    MainDataModule.MainDb.Host := ConParams.Host;
  end;

  MainDataModule.MainDb.TcpPort := ConParams.Port;
  MainDataModule.MainDb.SQLDialect := ConParams.Dialect;
  MainDataModule.MainDb.CharacterSet := ConParams.CharacterSet;
  MainDataModule.MainDb.DBFile := ConParams.DBName;
  MainDataModule.MainDb.User := ConParams.User;
  MainDataModule.MainDb.Password := ConParams.Password;
  MainDataModule.MainDb.Role := ConParams.Role;
  try
    MainDataModule.MainDb.Connect;
    FCurrentAlias := ConParams.AliasName;
    LoadDbTreeView;
    DbConnectionsAction.Enabled := False;
    DisconnectAction.Enabled := True;
    DoAfterConnect;
    fsconfig.LastAliasConnected := ConParams.AliasName;
    fsConfig.WriteConfigFile;
  except
    on E: EFBLError do
      ShowMessage(Format('Error Code : %d', [E.ISC_ErrorCode]) +
        LineEnding + Format('SQL Code : %d', [E.SqlCode]) + LineEnding +
        E.Message);
  end;
end;

procedure TBrowserForm.ExportToCsvActionExecute(Sender: TObject);
begin
  if not MainDataModule.BrowserTr.InTransaction then
    MainDataModule.BrowserTr.StartTransaction;

  if Assigned(DbTreeView.Selected.Data) then
    if (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_TABLE) or
      (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_SYSTABLE) then
    begin
      try

        MainDataModule.BrowserQry.SQL.Text :=
          'select * from ' + TNodeDesc(DbTreeView.Selected.Data).ObjName;
        MainDataModule.BrowserQry.ExecSQL;
        SaveDialog.DefaultExt := 'csv';
        SaveDialog.Filter :=
          'comma separated values (*.csv)|*.csv|Text (*.txt)|*.txt|Any(*.*)|*.*';
        SaveDialog.Title := 'Export table ::' +
          TNodeDesc(DbTreeView.Selected.Data).ObjName + ':: To csv';
        if SaveDialog.Execute then
        begin
          ExportToCsvFile(MainDataModule.BrowserQry, SaveDialog.FileName);
          ShowMessage('File: [' + SaveDialog.FileName + '] created' +
            LineEnding + IntToStr(MainDataModule.BrowserQry.FetchCount) +
            ' record exported');
        end;
      finally
        MainDataModule.BrowserQry.UnPrepare;
      end;
    end;
end;

procedure TBrowserForm.ExportToJsonActionExecute(Sender: TObject);
begin
  if not MainDataModule.BrowserTr.InTransaction then
    MainDataModule.BrowserTr.StartTransaction;

  if Assigned(DbTreeView.Selected.Data) then
    if (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_TABLE) or
      (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_SYSTABLE) then
    begin
      try

        MainDataModule.BrowserQry.SQL.Text :=
          'select * from ' + TNodeDesc(DbTreeView.Selected.Data).ObjName;
        MainDataModule.BrowserQry.ExecSQL;
        SaveDialog.DefaultExt := 'js';
        SaveDialog.Filter :=
          'javascript (*.js)|*.js|json (*.json)|*.json|Text (*.txt)|*.txt|Any(*.*)|*.*';
        SaveDialog.Title := 'Export table ::' +
          TNodeDesc(DbTreeView.Selected.Data).ObjName + ':: To Json';
        if SaveDialog.Execute then
        begin
          ExportToJson(MainDataModule.BrowserQry, SaveDialog.FileName);
          ShowMessage('File: [' + SaveDialog.FileName + '] created' +
            LineEnding + IntToStr(MainDataModule.BrowserQry.FetchCount) +
            ' record exported');
        end;
      finally
        MainDataModule.BrowserQry.UnPrepare;
      end;
    end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.DisconnectActionExecute(Sender: TObject);
var
  DialogTransForm: TDialogTransForm;
begin
  DialogTransForm := TDialogTransForm.Create(self);
  try
    if MainDataModule.MainTr.InTransaction then
      case DialogTransForm.ShowModal of
        mrYes:
          MainDataModule.MainTr.Commit;
        mrNo:
          MainDataModule.MainTr.RollBack;
        mrCancel:
          exit;
      end;
  finally
    DialogTransForm.Free;
  end;

  MainDataModule.MainDb.Disconnect;
  FsConfig.SaveHistory(FCurrentAlias, FHistory);
  DbConnectionsAction.Enabled := True;
  DisconnectAction.Enabled := False;
  ClearDbTreeView;
  lTitle.Caption := '';
  DdlSynMemo.Lines.Clear;
  ShowBuffer;
  DoAfterDisconnect;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ExecSqlActionExecute(Sender: TObject);
var
  stm: string;
begin
  stm := Trim(SqlSynEdit.Lines.Text);
  if stm = '' then
    ShowMessage(rsEmpyQuery)
  else
  begin
    ClearMessagesActionExecute(nil);
    if not ExecuteSQL(SqlSynEdit.Lines.Text, True) then
    begin
      AddToHistory(stm);
      RefreshStatusBar;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.ExecSqlScriptActionExecute(Sender: TObject);
var
  i: integer;
  SqlError: boolean;
  stm: string;
  SQLScript: TList;
  FParseError: boolean;
begin
  FParseError := False;
  SqlError := True;
  FScriptStat.stm_count := 0;
  FScriptStat.ins_rows := 0;
  FScriptStat.del_rows := 0;
  FScriptStat.upg_rows := 0;
  FScriptStat.ddl_cmds := 0;
  FScriptStat.start_t := now;
  if Trim(SqlSynEdit.Text) = '' then
  begin
    ShowMessage(rsEmpyQuery);
    Exit;
  end;
  ClearMessagesActionExecute(nil);
  SQLScript := TList.Create;
  try
    Screen.Cursor := crSqlWait;
    Script.SQLScript := SqlSynEdit.Lines;
    Script.Reset;
    SQLScript.Clear;
    LogMessage(Format(rsStartScriptS, [TimeToStr(Now)]),BMP_TVM_CLOCK);
    while not Script.EOF do
    begin
      stm := Script.Statement;
      if script.StatementType = stUnknow then
      begin
        FParseError := True;
        LogErrorMessage(rsErrorStatementUnknow,stm +  'at line ' +
          IntToStr(Script.CurrentLineNumber),BMP_TVM_UNKNOW);
        EditLineError(Script.CurrentLineNumber);
        LogMessage(rsScriptStopped,BMP_TVM_NOTE);
      end;
      if (Script.StatementType <> stSetTerm) and (script.StatementType <> stSelect) then
        SQLScript.Add(TScriptStm.Create(Script.CurrentLineNumber,stm));
    end;

    if not FParseError then
    begin
      for i := 0 to SQLScript.Count - 1 do
      begin
        SqlError := ExecuteSQL(TScriptStm(SQLScript.Items[i]).Stm, FsConfig.VerboseSqlScript,TScriptStm(SQLScript.Items[i]).LineStart - 1);
        if SqlError then
        begin
          LogErrorMessage(rsErrorInStatement, TScriptStm(SQLScript.Items[i]).Stm,BMP_TVM_ERROR);
          LogMessage(rsScriptStopped,BMP_TVM_NOTE);
          LogMessage(' ');
          LogMessage(Format(rsDRowSInserte, [FScriptStat.ins_rows]),BMP_TVM_STATE);
          LogMessage(Format(rsDRowSUpdated, [FScriptStat.upg_rows]),BMP_TVM_STATE);
          LogMessage(Format(rsDRowSDeleted, [FScriptStat.del_rows]),BMP_TVM_STATE);
          LogMessage(Format(rsDDDLSStateme, [FScriptStat.ddl_cmds]),BMP_TVM_STATE);
          break;
        end;
      end;
    end;
    if not SqlError then
    begin
      FScriptStat.end_t := now;
      LogMessage(Format(rsScriptExecuted, [TimeT(FScriptStat.end_t - FScriptStat.start_t)]),BMP_TVM_CLOCK);
      LogMessage(' ');
      LogMessage(Format(rsDRowSInserte, [FScriptStat.ins_rows]),BMP_TVM_STATE);
      LogMessage(Format(rsDRowSUpdated, [FScriptStat.upg_rows]),BMP_TVM_STATE);
      LogMessage(Format(rsDRowSDeleted, [FScriptStat.del_rows]),BMP_TVM_STATE);
      LogMessage(Format(rsDDDLSStateme, [FScriptStat.ddl_cmds]),BMP_TVM_STATE);
    end;
  finally
    Screen.Cursor := crDefault;
    for i:=0 to  SQLScript.Count -1 do
        TScriptStm(SQLScript.Items[i]).Free;
    SQLScript.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.MetadataExtractActionExecute(Sender: TObject);
begin
  if MainDataModule.MainDb.Connected then
  begin
    ShowBuffer;
    lTitle.Caption := ' METADATA';
    try
      Screen.Cursor := crSqlWait;
      if not MainDataModule.BrowserTr.InTransaction then
        MainDataModule.BrowserTr.StartTransaction;
      DdlSynMemo.Lines := MainDataModule.SqlMetaData.Metadata;
    finally
      if MainDataModule.BrowserTr.InTransaction then
        MainDataModule.BrowserTr.RollBack;
      Screen.Cursor := crDefault;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.NewScriptActionExecute(Sender: TObject);
begin
  if MainPageControl.PageIndex <> 1 then
    MainPageControl.PageIndex := 1;
  SqlSynEdit.SetFocus;
  SqlSynEdit.Lines.Clear;
  CarretPos;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.OpenScriptActionExecute(Sender: TObject);
begin
  OpenDialog.DefaultExt := '*.sql';
  OpenDialog.Filter :=
    'Sql scripts (*.sql)|*.sql|Text files (*.txt)|*.txt|Any file (*.*)|*.*';
  if OpenDialog.Execute then
  begin
    MainPageControl.PageIndex := 1;
    SqlSynEdit.Lines.LoadFromFile(OpenDialog.FileName);
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.PreviousActionExecute(Sender: TObject);
begin
  Dec(FHistoryIDX);
  SqlSynEdit.Lines.Text := FHistory.Strings[FHistoryIDX];
  if FHistoryIDX = 0 then
    PreviousAction.Enabled := False;
  if (FHistory.Count > 1) and (FHistoryIDX < (FHistory.Count - 1)) then
    NextAction.Enabled := True
  else
    NextAction.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.RefreshAllActionExecute(Sender: TObject);
begin
  DbTreeView.OnChange := nil;
  try
    if MainDataModule.MainDb.Connected then
    begin
      {$IFDEF UNIX}
      FNeedRefresh := True;
      {$ENDIF}
      ShowBuffer;
      DdlSynMemo.Lines.Clear;
      DbTreeView.FullCollapse;
      LoadDbTreeView;
    end;
  finally
    DbTreeView.OnChange := @DbTreeViewChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.NextActionExecute(Sender: TObject);
begin
  Inc(FHistoryIDX);
  SqlSynEdit.Lines.Text := FHistory.Strings[FHistoryIDX];
  if FHistoryIdx = (FHistory.Count - 1) then
    NextAction.Enabled := False;
  PreviousAction.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.RollBackActionExecute(Sender: TObject);
begin
  try
    MainDataModule.MainTr.Rollback;
    LogMessage(Format(rsTransactionR, [TimeToStr(Now)]),BMP_TVM_ROLLBACK);
    EndTr;
  except
    on E: EFBLError do
    begin
      LogErrorMessage(Format(rsErrorInTransR,[E.ISC_ErrorCode]),E.Message,BMP_TVM_ERROR);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.SaveScriptActionExecute(Sender: TObject);
begin
  SaveDialog.DefaultExt := 'sql';
  SaveDialog.Filter :=
    'sql scripts (*.sql)|*.sql|text files (*.txt)|*.txt|any file (*.*)|*.*';
  SaveDialog.Title := 'save sql script as';
  if SaveDialog.Execute then
    SqlSynEdit.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TBrowserForm.MainPageControlChange(Sender: TObject);
begin
  if MainPageControl.PageIndex = 1 then
    SqlSynEdit.SetFocus;
end;

procedure TBrowserForm.MenuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TBrowserForm.SelectAllSynMemoActionExecute(Sender: TObject);
begin
  if ActiveControl is TCustomSynEdit then
    TCustomSynEdit(ActiveControl).SelectAll;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.SqlSynEditChange(Sender: TObject);
begin
  SaveScriptAction.Enabled := SqlSynEdit.Text <> '';
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.SqlSynEditClick(Sender: TObject);
begin
  CarretPos;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.SqlSynEditKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  CarretPos;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.nbMainPageChanged(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------

procedure TBrowserForm.DbTreeViewChange(Sender: TObject; Node: TTreeNode);
begin
  if Node <> nil then
    if MainDataModule.MainDb.Connected then
      TreeViewEvents(Node);
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.DbTreeViewClick(Sender: TObject);
begin
  if MainPageControl.PageIndex <> 0 then
    MainPageControl.PageIndex := 0;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.DbTreeViewDblClick(Sender: TObject);
begin
  if Assigned(DbTreeView.Selected) then
  begin
    if Assigned(TNodeDesc(DbTreeView.Selected.Data)) then
    begin
      if (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_TABLE) or
        (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_VIEW) or
        (TNodeDesc(DbTreeView.Selected.Data).NodeType = CNT_SYSTABLE) then
        ShowTableView(TNodeDesc(DbTreeView.Selected.Data).ObjName);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.DbTreeViewMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if Button = mbRight then
    if Assigned(DbTreeView.GetNodeAt(X, Y)) then
      DbTreeView.Selected := DbTreeView.GetNodeAt(X, Y);
end;

//------------------------------------------------------------------------------

procedure TBrowserForm.DbTreeViewMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Button = mbRight then
  begin
    if Assigned(DbTreeView.GetNodeAt(X, Y)) then
    begin
      if Assigned(DbTreeView.Selected.Data) then
      begin
        ExportToSqlAction.Enabled := False;
        ExportToCsvAction.Enabled := False;
        ExportToJsonAction.Enabled := False;
        ViewDataAction.Enabled := False;
        GrantMgrAction.Enabled := False;
        case TNodeDesc(DbTreeView.Selected.Data).Nodetype of
          CNT_DATABASE:
            DbPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X +
              X, (Sender as TTreeView).ClientOrigin.Y + Y);
          CNT_DOMAIN:
          begin
            ShowOptionDescriptionAction.Enabled := True;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_TABLE:
          begin
            ExportToSqlAction.Enabled := True;
            ExportToCsvAction.Enabled := True;
            ExportToJsonAction.Enabled := True;
            ViewDataAction.Enabled := True;
            GrantMgrAction.Enabled := True;
            ShowOptionDescriptionAction.Enabled := True;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_VIEW:
          begin
            ShowOptionDescriptionAction.Enabled := True;
            ViewDataAction.Enabled := True;
            GrantMgrAction.Enabled := True;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_PROCEDURE:
          begin
            GrantMgrAction.Enabled := True;
            ShowOptionDescriptionAction.Enabled := True;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_TRIGGER:
          begin
            ShowOptionDescriptionAction.Enabled := True;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_GENERATOR:
          begin
            ShowOptionDescriptionAction.Enabled := False;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_UDF:
          begin
            ShowOptionDescriptionAction.Enabled := True;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_EXCEPTION:
          begin
            ShowOptionDescriptionAction.Enabled := True;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_ROLE:
          begin
            ShowOptionDescriptionAction.Enabled := True;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_SYSTABLE:
          begin
            ViewDataAction.Enabled := True;
            ExportToSqlAction.Enabled := True;
            ExportToCsvAction.Enabled := True;
            ExportToJsonAction.Enabled := True;
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          CNT_SYSTRIGGER:
          begin
            ItemPopUpMenu.Popup((Sender as TTreeView).ClientOrigin.X + X,
              (Sender as TTreeView).ClientOrigin.Y + Y);
          end;
          else
        end;
      end;
    end;
  end;
end;

end.
