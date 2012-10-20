(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsblobtext.pas

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
unit fsblobtext;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, Buttons, ActnList;

type

  { TBlobTextForm }

  TBlobTextForm = class(TForm)
    SaveAction: TAction;
    LoadAction: TAction;
    ActionList1: TActionList;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    NullCheckBox: TCheckBox;
    ValueMemo: TMemo;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    ParamNumberLabel: TLabel;
    ParamTypeLabel: TLabel;
    OpenDialog1: TOpenDialog;
    pBottom: TPanel;
    ParamsPanel: TPanel;
    SaveDialog1: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure LoadActionExecute(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
    procedure ValueMemoChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;


procedure ViewBlobText(const AValue: string);

function InputParamMemo(const AParamNum, AParamType: string;
  var AisNullable: boolean; var AValue: string): boolean;


implementation

{$R *.lfm}

procedure ViewBlobText(const AValue: string);
var
  BlobTextForm: TBlobTextForm;
begin
  BlobTextForm := TBlobTextForm.Create(Application);
  try
    BlobTextForm.ParamsPanel.Visible := False;
    BlobTextForm.NullCheckBox.Visible := False;
    BlobTextForm.LoadAction.Enabled := False;
    BlobTextForm.ValueMemo.Lines.Text := AValue;
    BlobTextForm.ShowModal;
  finally
    BlobTextForm.Free;
  end;
end;


function InputParamMemo(const AParamNum, AParamType: string;
  var AisNullable: boolean; var AValue: string): boolean;
var
  BlobTextForm: TBlobTextForm;
begin
  BlobTextForm := TBlobTextForm.Create(Application);
  Result := False;
  try
    BlobTextForm.NullCheckBox.Visible := AisNullable;
    BlobTextForm.NullCheckBox.Checked := AisNullable;
    BlobTextForm.ValueMemo.Text := AValue;
    if not AisNullable then
      BlobTextForm.ParamTypeLabel.Caption := AParamType + ' NOT NULL'
    else
      BlobTextForm.ParamTypeLabel.Caption := AParamType;
    BlobTextForm.ParamNumberLabel.Caption := AParamNum;

    BlobTextForm.ValueMemo.Lines.Text := AValue;
    if BlobTextForm.ShowModal = mrOk then
    begin
      AValue := BlobTextForm.ValueMemo.Lines.Text;
      AisNullable := BlobTextForm.NullCheckBox.Checked;
      Result := True;
    end;
  finally
    BlobTextForm.Free;
  end;
end;


{ TBlobTextForm }

procedure TBlobTextForm.LoadActionExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    ValueMemo.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TBlobTextForm.SaveActionExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    ValueMemo.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TBlobTextForm.ValueMemoChange(Sender: TObject);
begin
  if NullCheckBox.Checked then
    if ValueMemo.Lines.Text <> '' then
      NullCheckBox.Checked := False;
end;


end.
