(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fstextoptions.pas

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
unit fstextoptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, SynMemo, SynHighlighterSQL, ColorBox, ComCtrls;

type

  { TextOptionsForm }

  { TTextOptionsForm }

  TTextOptionsForm = class(TForm)
    ColorSqlButton: TBitBtn;
    FontDllButton: TBitBtn;
    FontSqlButton: TBitBtn;
    FontTextGridButton: TButton;
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    TextGridColorButton: TButton;
    BackColorButton: TColorButton;
    ForeColorButton: TColorButton;
    FontColorDialog: TColorDialog;
    StyleCheckGroup: TCheckGroup;
    FontDialog1: TFontDialog;
    ColorDdlButton: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lbElements: TListBox;
    FontDdlLabel: TLabel;
    FontSqlLabel: TLabel;
    FontTextGridLabel: TLabel;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelDown: TPanel;
    PanelUp: TPanel;
    smPreview: TSynMemo;
    TempSynSql: TSynSQLSyn;
    FontTabSheet: TTabSheet;
    SynColorTabSheet: TTabSheet;
    procedure BackColorButtonColorChanged(Sender: TObject);
    procedure ColorSqlButtonClick(Sender: TObject);
    procedure FontDllButtonClick(Sender: TObject);
    procedure FontSqlButtonClick(Sender: TObject);
    procedure FontTextGridButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure ForeColorButtonColorChanged(Sender: TObject);
    procedure TextGridColorButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StyleCheckGroupItemClick(Sender: TObject; Index: integer);
    procedure ColorDdlButtonClick(Sender: TObject);
    procedure lbElementsClick(Sender: TObject);
  private
    { private declarations }
    FDDLChanged, FSQLChanged, FTextGridChanged: boolean;
    function GetFontDDL: TFont;
    function GetColorDDL: TColor;
    function GetFontSQL: TFont;
    function GetColorSQL: TColor;
    function GetFontTextGrid: TFont;
    function GetColorTextGrid: TColor;
    procedure SetFontDDL(Value: TFont);
    procedure SetColorDDL(Value: TColor);
    procedure SetFontSQL(Value: TFont);
    procedure SetColorSQL(Value: TColor);
    procedure SetFontTextGrid(Value: TFont);
    procedure SetColorTextGrid(Value: TColor);
    procedure LoadSynAttrib;
    procedure SaveSynAttrib;
    procedure SetAttrib;
  public
    { public declarations }
    property FontDDL: TFont read GetFontDDL write SetFontDDL;
    property ColorDDL: TColor read GetColorDDL write SetColorDDL;
    property DDLChanged: boolean read FDDLChanged;

    property FontSQL: TFont read GetFontSQL write SetFontSQL;
    property ColorSQL: TColor read GetColorSQL write SetColorSQL;
    property SQLChanged: boolean read FSQLChanged;

    property FontTextGrid: TFont read GetFontTextGrid write SetFontTextGrid;
    property ColorTextGrid: TColor read GetColorTextGrid write SetColorTextGrid;
    property TextGridChanged: boolean read FTextGridChanged;

  end;

//var
//TextOptionsForm: TTextOptionsForm;
const
  BOLD = 0;
  ITALIC = 1;
  UNDERLINE = 2;

implementation

uses
  fsconfig, fsdm;


{ TTextOptionsForm }


function TTextOptionsForm.GetFontDDL: TFont;
begin
  Result := FontDdlLabel.Font;
end;

//------------------------------------------------------------------------------

function TTextOptionsForm.GetColorDDL: TColor;
begin
  Result := FontDdlLabel.Color;
end;

//------------------------------------------------------------------------------

function TTextOptionsForm.GetFontSQL: TFont;
begin
  Result := FontSqlLabel.Font;
end;

//------------------------------------------------------------------------------

function TTextOptionsForm.GetColorSQL: TColor;
begin
  Result := FontSqlLabel.Color;
end;

//------------------------------------------------------------------------------

function TTextOptionsForm.GetFontTextGrid: TFont;
begin
  Result := FontTextGridLabel.Font;
end;

//------------------------------------------------------------------------------

function TTextOptionsForm.GetColorTextGrid: TColor;
begin
  Result := FontTextGridLabel.Color;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.SetFontDDL(Value: TFont);
begin
  FontDdlLabel.Font := Value;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.SetColorDDL(Value: TColor);
begin
  FontDdlLabel.Color := Value;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.SetFontSQL(Value: TFont);
begin
  FontSqlLabel.Font := Value;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.SetColorSQL(Value: TColor);
begin
  FontSqlLabel.Color := Value;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.SetFontTextGrid(Value: TFont);
begin
  FontTextGridLabel.Font := Value;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.SetColorTextGrid(Value: TColor);
begin
  FontTextGridLabel.Color := Value;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.FontDllButtonClick(Sender: TObject);
begin
  FontDialog1.Font := FontDdlLabel.Font;
  if FontDialog1.Execute then
  begin
    FontDdlLabel.Font := FontDialog1.Font;
    FDDLChanged := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.ColorDdlButtonClick(Sender: TObject);
begin
  FontColorDialog.Color := FontDdlLabel.Color;
  if FontColorDialog.Execute then
  begin
    FontDdlLabel.Color := FontColorDialog.Color;
    FDDLChanged := True;
  end;
end;


//------------------------------------------------------------------------------

procedure TTextOptionsForm.lbElementsClick(Sender: TObject);
var
  item: string;
begin
  ForeColorButton.OnColorChanged := nil;
  BackColorButton.OnColorChanged := nil;
  try
    if lbelements.ItemIndex >= 0 then
    begin
      item := lbElements.Items.Strings[lbelements.ItemIndex];

      if item = 'Comment' then
      begin
        ForeColorButton.ButtonColor := TempSynSql.CommentAttri.Foreground;
        BackColorButton.ButtonColor := TempSynSql.CommentAttri.Background;

        StyleCheckGroup.Checked[BOLD] := fsBold in TempSynSql.CommentAttri.Style;
        StyleCheckGroup.Checked[ITALIC] := fsItalic in TempSynSql.CommentAttri.Style;
        StyleCheckGroup.Checked[UNDERLINE] := fsUnderline in TempSynSql.CommentAttri.Style;
      end
      else if item = 'Reserved word' then
      begin
        ForeColorButton.ButtonColor := TempSynSql.KeyAttri.Foreground;
        BackColorButton.ButtonColor := TempSynSql.KeyAttri.Background;
        StyleCheckGroup.Checked[BOLD] := fsBold in TempSynSql.KeyAttri.Style;
        StyleCheckGroup.Checked[ITALIC] := fsItalic in TempSynSql.KeyAttri.Style;
        StyleCheckGroup.Checked[UNDERLINE] := fsUnderline in TempSynSql.KeyAttri.Style;
      end
      else if item = 'Number' then
      begin
        ForeColorButton.ButtonColor := TempSynSql.NumberAttri.Foreground;
        BackColorButton.ButtonColor := TempSynSql.NumberAttri.Background;
        StyleCheckGroup.Checked[BOLD] := fsBold in TempSynSql.NumberAttri.Style;
        StyleCheckGroup.Checked[ITALIC] := fsItalic in TempSynSql.NumberAttri.Style;
        StyleCheckGroup.Checked[UNDERLINE] := fsUnderline in TempSynSql.NumberAttri.Style;
      end
      else if item = 'String' then
      begin
        ForeColorButton.ButtonColor := TempSynSql.StringAttri.Foreground;
        BackColorButton.ButtonColor := TempSynSql.StringAttri.Background;
        StyleCheckGroup.Checked[BOLD] := fsBold in TempSynSql.StringAttri.Style;
        StyleCheckGroup.Checked[ITALIC] := fsItalic in TempSynSql.StringAttri.Style;
        StyleCheckGroup.Checked[UNDERLINE] := fsUnderline in TempSynSql.StringAttri.Style;
      end
      else if item = 'Tablenames' then
      begin
        ForeColorButton.ButtonColor := TempSynSql.TableNameAttri.Foreground;
        BackColorButton.ButtonColor := TempSynSql.TableNameAttri.Background;
        StyleCheckGroup.Checked[BOLD] := fsBold in TempSynSql.TableNameAttri.Style;
        StyleCheckGroup.Checked[ITALIC] := fsItalic in TempSynSql.TableNameAttri.Style;
        StyleCheckGroup.Checked[UNDERLINE] := fsUnderline in TempSynSql.TableNameAttri.Style;
      end
      else if item = 'Datatype' then
      begin
        ForeColorButton.ButtonColor := TempSynSql.DataTypeAttri.Foreground;
        BackColorButton.ButtonColor := TempSynSql.DataTypeAttri.Background;
        StyleCheckGroup.Checked[BOLD] := fsBold in TempSynSql.DataTypeAttri.Style;
        StyleCheckGroup.Checked[ITALIC] := fsItalic in TempSynSql.DataTypeAttri.Style;
        StyleCheckGroup.Checked[UNDERLINE] := fsUnderline in TempSynSql.DataTypeAttri.Style;
      end
      else if item = 'Identifier' then
      begin
        ForeColorButton.ButtonColor := TempSynSql.IdentifierAttri.Foreground;
        BackColorButton.ButtonColor := TempSynSql.IdentifierAttri.Background;
        StyleCheckGroup.Checked[BOLD] := fsBold in TempSynSql.IdentifierAttri.Style;
        StyleCheckGroup.Checked[ITALIC] := fsItalic in TempSynSql.IdentifierAttri.Style;
        StyleCheckGroup.Checked[UNDERLINE] := fsUnderline in TempSynSql.IdentifierAttri.Style;
      end;
      ForeColorButton.Hint := ColorToString(ForeColorButton.ButtonColor);
      BackColorButton.Hint := ColorToString(BackColorButton.ButtonColor);
    end;
  finally
    ForeColorButton.OnColorChanged := @ForeColorButtonColorChanged;
    BackColorButton.OnColorChanged := @BackColorButtonColorChanged;
  end;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.FontSqlButtonClick(Sender: TObject);
begin
  FontDialog1.Font := FontSqlLabel.Font;
  if FontDialog1.Execute then
  begin
    FontSqlLabel.Font := FontDialog1.Font;
    FSQLChanged := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.ColorSqlButtonClick(Sender: TObject);
begin
  FontColorDialog.Color := FontSqlLabel.Color;
  if FontColorDialog.Execute then
  begin
    FontSqlLabel.Color := FontColorDialog.Color;
    FSQLChanged := True;
  end;
end;



procedure TTextOptionsForm.BackColorButtonColorChanged(Sender: TObject);
begin
   SetAttrib;
   BackColorButton.Hint := ColorToString(BackColorButton.ButtonColor);
end;


//------------------------------------------------------------------------------

procedure TTextOptionsForm.FontTextGridButtonClick(Sender: TObject);
begin
  FontDialog1.Font := FontTextGridLabel.Font;
  if FontDialog1.Execute then
  begin
    FontTextGridLabel.Font := FontDialog1.Font;
    FTextGridChanged := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.OkButtonClick(Sender: TObject);
begin
  SaveSynAttrib;
  FsConfig.WriteConfigSynEdit;
  ModalResult := mrOk;
end;


//------------------------------------------------------------------------------

procedure TTextOptionsForm.TextGridColorButtonClick(Sender: TObject);
begin
  FontColorDialog.Color := FontTextGridLabel.Color;
  if FontColorDialog.Execute then
  begin
    FontTextGridLabel.Color := FontColorDialog.Color;
    FTextGridChanged := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.ForeColorButtonColorChanged(Sender: TObject);
begin
  SetAttrib;
  ForeColorButton.Hint := ColorToString(ForeColorButton.ButtonColor);
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.FormCreate(Sender: TObject);
begin
  //{$I fsunixborder.inc}
  FDDLChanged := False;
  FSQLChanged := False;
  FTextGridChanged := False;
  LoadSynAttrib;
  TempSynSql.TableNames.Clear;
  TempSynSql.TableNames.Add('Table1');
  lbElements.ItemIndex := 0;
  lbElementsClick(self);
end;


//------------------------------------------------------------------------------

procedure TTextOptionsForm.StyleCheckGroupItemClick(Sender: TObject; Index: integer);
begin
  SetAttrib;
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.LoadSynAttrib;
begin
  TempSynSql.CommentAttri.Assign(MainDataModule.SynSQLSyn1.CommentAttri);
  TempSynSql.KeyAttri.Assign(MainDataModule.SynSQLSyn1.KeyAttri);
  TempSynSql.NumberAttri.Assign(MainDataModule.SynSQLSyn1.NumberAttri);
  TempSynSql.StringAttri.Assign(MainDataModule.SynSQLSyn1.StringAttri);
  TempSynSql.TableNameAttri.Assign(MainDataModule.SynSQLSyn1.TableNameAttri);
  TempSynSql.DataTypeAttri.Assign(MainDataModule.SynSQLSyn1.DataTypeAttri);
  TempSynSql.IdentifierAttri.Assign(MainDataModule.SynSQLSyn1.IdentifierAttri);
end;

//------------------------------------------------------------------------------

procedure TTextOptionsForm.SaveSynAttrib;
begin
  with MainDataModule do
  begin
    SynSqlSyn1.CommentAttri.Assign(TempSynSql.CommentAttri);
    SynSqlSyn1.KeyAttri.Assign(TempSynSql.KeyAttri);
    SynSqlSyn1.NumberAttri.Assign(TempSynSql.NumberAttri);
    SynSqlSyn1.StringAttri.Assign(TempSynSql.StringAttri);
    SynSqlSyn1.TableNameAttri.Assign(TempSynSql.TableNameAttri);
    SynSqlSyn1.DataTypeAttri.Assign(TempSynSql.DataTypeAttri);
    SynSqlSyn1.IdentifierAttri.Assign(TempSynSql.IdentifierAttri);
  end;
end;
//------------------------------------------------------------------------------

procedure TTextOptionsForm.SetAttrib;
var
  item: string;
begin
  item := lbElements.Items.Strings[lbelements.ItemIndex];
  if item = 'Comment' then
  begin
    TempSynSql.CommentAttri.Foreground := ForeColorButton.ButtonColor;
    TempSynSql.CommentAttri.Background := BackColorButton.ButtonColor;
    if StyleCheckGroup.Checked[BOLD] then
      TempSynSql.CommentAttri.Style := TempSynSql.CommentAttri.Style + [fsBold]
    else
      TempSynSql.CommentAttri.Style := TempSynSql.CommentAttri.Style - [fsBold];
    if StyleCheckGroup.Checked[ITALIC] then
      TempSynSql.CommentAttri.Style := TempSynSql.CommentAttri.Style + [fsItalic]
    else
      TempSynSql.CommentAttri.Style := TempSynSql.CommentAttri.Style - [fsItalic];
    if StyleCheckGroup.Checked[UNDERLINE] then
      TempSynSql.CommentAttri.Style := TempSynSql.CommentAttri.Style + [fsUnderline]
    else
      TempSynSql.CommentAttri.Style := TempSynSql.CommentAttri.Style - [fsUnderline];
  end;

  if item = 'Reserved word' then
  begin
    TempSynSql.KeyAttri.Foreground := ForeColorButton.ButtonColor;
    TempSynSql.KeyAttri.Background := BackColorButton.ButtonColor;
    if StyleCheckGroup.Checked[BOLD] then
      TempSynSql.KeyAttri.Style := TempSynSql.KeyAttri.Style + [fsBold]
    else
      TempSynSql.KeyAttri.Style := TempSynSql.KeyAttri.Style - [fsBold];
    if StyleCheckGroup.Checked[ITALIC] then
      TempSynSql.KeyAttri.Style := TempSynSql.KeyAttri.Style + [fsItalic]
    else
      TempSynSql.KeyAttri.Style := TempSynSql.KeyAttri.Style - [fsItalic];
    if StyleCheckGroup.Checked[UNDERLINE] then
      TempSynSql.KeyAttri.Style := TempSynSql.KeyAttri.Style + [fsUnderline]
    else
      TempSynSql.KeyAttri.Style := TempSynSql.KeyAttri.Style - [fsUnderline];
  end;

  if item = 'Number' then
  begin
    TempSynSql.NumberAttri.Foreground := ForeColorButton.ButtonColor;
    TempSynSql.NumberAttri.Background := BackColorButton.ButtonColor;
    if StyleCheckGroup.Checked[BOLD] then
      TempSynSql.NumberAttri.Style := TempSynSql.NumberAttri.Style + [fsBold]
    else
      TempSynSql.NumberAttri.Style := TempSynSql.NumberAttri.Style - [fsBold];
    if StyleCheckGroup.Checked[ITALIC] then
      TempSynSql.NumberAttri.Style := TempSynSql.NumberAttri.Style + [fsItalic]
    else
      TempSynSql.NumberAttri.Style := TempSynSql.NumberAttri.Style - [fsItalic];
    if StyleCheckGroup.Checked[UNDERLINE] then
      TempSynSql.NumberAttri.Style := TempSynSql.NumberAttri.Style + [fsUnderline]
    else
      TempSynSql.NumberAttri.Style := TempSynSql.NumberAttri.Style - [fsUnderline];
  end;

  if item = 'String' then
  begin
    TempSynSql.StringAttri.Foreground := ForeColorButton.ButtonColor;
    TempSynSql.StringAttri.Background := BackColorButton.ButtonColor;
    if StyleCheckGroup.Checked[BOLD] then
      TempSynSql.StringAttri.Style := TempSynSql.StringAttri.Style + [fsBold]
    else
      TempSynSql.StringAttri.Style := TempSynSql.StringAttri.Style - [fsBold];
    if StyleCheckGroup.Checked[ITALIC] then
      TempSynSql.StringAttri.Style := TempSynSql.StringAttri.Style + [fsItalic]
    else
      TempSynSql.StringAttri.Style := TempSynSql.StringAttri.Style - [fsItalic];
    if StyleCheckGroup.Checked[UNDERLINE] then
      TempSynSql.StringAttri.Style := TempSynSql.StringAttri.Style + [fsUnderline]
    else
      TempSynSql.StringAttri.Style := TempSynSql.StringAttri.Style - [fsUnderline];
  end;

  if item = 'Tablenames' then
  begin
    TempSynSql.TableNameAttri.Foreground := ForeColorButton.ButtonColor;
    TempSynSql.TableNameAttri.Background := BackColorButton.ButtonColor;
    if StyleCheckGroup.Checked[BOLD] then
      TempSynSql.TableNameAttri.Style := TempSynSql.TableNameAttri.Style + [fsBold]
    else
      TempSynSql.TableNameAttri.Style := TempSynSql.TableNameAttri.Style - [fsBold];
    if StyleCheckGroup.Checked[ITALIC] then
      TempSynSql.TableNameAttri.Style := TempSynSql.TableNameAttri.Style + [fsItalic]
    else
      TempSynSql.TableNameAttri.Style := TempSynSql.TableNameAttri.Style - [fsItalic];
    if StyleCheckGroup.Checked[UNDERLINE] then
      TempSynSql.TableNameAttri.Style := TempSynSql.TableNameAttri.Style + [fsUnderline]
    else
      TempSynSql.TableNameAttri.Style := TempSynSql.TableNameAttri.Style - [fsUnderline];
  end;

  if item = 'Datatype' then
  begin
    TempSynSql.DataTypeAttri.Foreground := ForeColorButton.ButtonColor;
    TempSynSql.DataTypeAttri.Background := BackColorButton.ButtonColor;
    if StyleCheckGroup.Checked[BOLD] then
      TempSynSql.DataTypeAttri.Style := TempSynSql.DataTypeAttri.Style + [fsBold]
    else
      TempSynSql.DataTypeAttri.Style := TempSynSql.DataTypeAttri.Style - [fsBold];
    if StyleCheckGroup.Checked[ITALIC] then
      TempSynSql.DataTypeAttri.Style := TempSynSql.DataTypeAttri.Style + [fsItalic]
    else
      TempSynSql.DataTypeAttri.Style := TempSynSql.DataTypeAttri.Style - [fsItalic];
    if StyleCheckGroup.Checked[UNDERLINE] then
      TempSynSql.DataTypeAttri.Style := TempSynSql.DataTypeAttri.Style + [fsUnderline]
    else
      TempSynSql.DataTypeAttri.Style := TempSynSql.DataTypeAttri.Style - [fsUnderline];
  end;

  if item = 'Identifier' then
  begin
    TempSynSql.IdentifierAttri.Foreground := ForeColorButton.ButtonColor;
    TempSynSql.IdentifierAttri.Background := BackColorButton.ButtonColor;
    if StyleCheckGroup.Checked[BOLD] then
      TempSynSql.IdentifierAttri.Style := TempSynSql.IdentifierAttri.Style + [fsBold]
    else
      TempSynSql.IdentifierAttri.Style := TempSynSql.IdentifierAttri.Style - [fsBold];
    if StyleCheckGroup.Checked[ITALIC] then
      TempSynSql.IdentifierAttri.Style := TempSynSql.IdentifierAttri.Style + [fsItalic]
    else
      TempSynSql.IdentifierAttri.Style := TempSynSql.IdentifierAttri.Style - [fsItalic];
    if StyleCheckGroup.Checked[UNDERLINE] then
      TempSynSql.IdentifierAttri.Style :=
        TempSynSql.IdentifierAttri.Style + [fsUnderline]
    else
      TempSynSql.IdentifierAttri.Style :=
        TempSynSql.IdentifierAttri.Style - [fsUnderline];
  end;
end;


initialization
  {$I fstextoptions.lrs}

end.
