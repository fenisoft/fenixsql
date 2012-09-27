(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://web.tiscali.it/fblib

   file:FsParamInput.pas


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

unit fsparaminput;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, Calendar, ExtDlgs;

type
  TInputValueType = (ivInteger, ivDouble, ivString, ivTimeStamp, ivTime, ivDate);
  { TParamForm }

  TParamForm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    NowButton: TButton;
    OkButton: TBitBtn;
    CancelButton: TBitBtn;
    NullCheckBox: TCheckBox;
    ValueEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    ParamNumberLabel: TLabel;
    Label3: TLabel;
    ParamTypeLabel: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure NowButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
    procedure NullCheckBoxClick(Sender: TObject);
    procedure edValueChange(Sender: TObject);
    procedure ValueEditKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
  private
    InputValueType: TInputValueType;
    function CheckInput: boolean;
    { private declarations }
  public
    { public declarations }
    function GetNullValue: boolean;
  end; 

//var
  //ParamForm: TParamForm;

{exported functions}

function InputParamInt(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: Integer): Boolean;
function InputParamDouble(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: Double): Boolean;
function InputParamFloat(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: single): Boolean;
function InputParamString(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: string): Boolean;
function InputParamDateTime(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: TDateTime): Boolean;
  

implementation

{exported functions implementation}

function InputParamInt(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AValue: Integer): Boolean;
var
  ParamForm: TParamForm;
begin
  ParamForm := TParamForm.Create(Application);
  Result := False;
  try

    ParamForm.NullCheckBox.Visible := AisNullable;
    ParamForm.NullCheckBox.Checked := AisNullable;
    if not AisNullable then
    begin
      ParamForm.ValueEdit.Text := '0';
      ParamForm.ParamTypeLabel.Caption := AParamType + ' NOT NULL';
    end
    else
      ParamForm.ParamTypeLabel.Caption := AParamType;

    ParamForm.ParamNumberLabel.Caption := AParamNum;
    ParamForm.inputValueType := ivInteger;
    ParamForm.NowButton.Visible := False;
    if ParamForm.ShowModal = mrOk then
    begin
      AisNullable := ParamForm.GetNullValue();
      if AisNullable then
         AValue := 0
      else
         AValue := StrToInt(ParamForm.ValueEdit.Text);
      Result := True;
    end;
  finally
    ParamForm.Free;
  end;
end;

//------------------------------------------------------------------------------

function InputParamDouble(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AValue: Double): Boolean;
var
  ParamForm: TParamForm;
begin
  ParamForm := TParamForm.Create(Application);
  try
    Result := False;
    ParamForm.NullCheckBox.Visible := AisNullable;
    ParamForm.NullCheckBox.Checked := AisNullable;
    if not AisNullable then
    begin
      ParamForm.ValueEdit.Text := '0';
      ParamForm.ParamTypeLabel.Caption := AParamType + ' NOT NULL';
    end
    else
      ParamForm.ParamTypeLabel.Caption := AParamType;

    ParamForm.ParamNumberLabel.Caption := AParamNum;
    ParamForm.ParamTypeLabel.Caption := AParamType;
    ParamForm.inputValueType := ivDouble;
    ParamForm.NowButton.Visible := False;
    if ParamForm.ShowModal = mrOk then
    begin
      AisNullable := ParamForm.GetNullValue();
      if AisNullable then
        AValue := 0
      else
        AValue := StrToFloat(ParamForm.ValueEdit.Text);
      Result := True;
    end;
  finally
    ParamForm.Free;
  end;
end;

//------------------------------------------------------------------------------

function InputParamFloat(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: Single): Boolean;
var
  ParamForm: TParamForm;
begin
  ParamForm := TParamForm.Create(Application);
  try
    Result := False;
    ParamForm.NullCheckBox.Visible := AisNullable;
    ParamForm.NullCheckBox.Checked := AisNullable;
    if not AisNullable then
    begin
      ParamForm.ValueEdit.Text := '0';
      ParamForm.ParamTypeLabel.Caption := AParamType + ' NOT NULL';
    end
    else
      ParamForm.ParamTypeLabel.Caption := AParamType;

    ParamForm.ParamNumberLabel.Caption := AParamNum;
    ParamForm.ParamTypeLabel.Caption := AParamType;
    ParamForm.inputValueType := ivDouble;
    ParamForm.NowButton.Visible := False;
    if ParamForm.ShowModal = mrOk then
    begin
      AisNullable := ParamForm.GetNullValue();
      if  AisNullable then
        AValue := 0
      else
        AValue := StrToFloat(ParamForm.ValueEdit.Text);
      Result := True;
    end;
  finally
    ParamForm.Free;
  end;
end;

//------------------------------------------------------------------------------

function InputParamString(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AValue: string): Boolean;
var
  ParamForm: TParamForm;
begin
  ParamForm := TParamForm.Create(Application);
  try
    Result := False;
    ParamForm.NullCheckBox.Visible := AisNullable;
    ParamForm.NullCheckBox.Checked := AisNullable;
    ParamForm.ValueEdit.Text := AValue;
    if not AisNullable then
      ParamForm.ParamTypeLabel.Caption := AParamType + ' NOT NULL'
    else
      ParamForm.ParamTypeLabel.Caption := AParamType;

    ParamForm.ParamNumberLabel.Caption := AParamNum;
    ParamForm.ParamTypeLabel.Caption := AParamType;
    ParamForm.inputValueType := ivString;
    ParamForm.NowButton.Visible := False;
    if ParamForm.ShowModal = mrOk then
    begin
      AisNullable := ParamForm.GetNullValue();
      if AisNullable then
        AValue := ''
      else
        AValue := ParamForm.ValueEdit.Text;
      Result := True;
    end;
  finally
    ParamForm.Free;
  end;
end;

//------------------------------------------------------------------------------

function InputParamDateTime(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AValue: TDateTime): Boolean;
var
  ParamForm: TParamForm;
begin
  ParamForm := TParamForm.Create(Application);
  try
    Result := False;
    ParamForm.NullCheckBox.Visible := AisNullable;
    ParamForm.NullCheckBox.Checked := AisNullable;

    if not AisNullable then
      ParamForm.ParamTypeLabel.Caption := AParamType + ' NOT NULL'
    else
      ParamForm.ParamTypeLabel.Caption := AParamType;
    ParamForm.ParamNumberLabel.Caption := AParamNum;
    ParamForm.ParamTypeLabel.Caption := AParamType;

    if AParamType = 'TIMESTAMP' then
    begin
      ParamForm.ValueEdit.Text := DateTimeToStr(AValue);
      ParamForm.inputValueType := ivTimeStamp;
      ParamForm.NowButton.Visible := True;
    end
    else if AParamType = 'DATE' then
    begin
      ParamForm.ValueEdit.Text := DateToStr(AValue);
      ParamForm.inputValueType := ivDate;
      ParamForm.NowButton.Visible := True;
    end
    else if AParamType = 'TIME' then
    begin
      ParamForm.ValueEdit.Text := TimeToStr(AValue);
      ParamForm.inputValueType := ivTime;
      ParamForm.NowButton.Visible := True;
    end;

    if ParamForm.ShowModal = mrOk then
    begin
      AisNullable := ParamForm.GetNullValue();
      if AisNullable then
        AValue := Now()
      else
        AValue := StrToDateTime(ParamForm.ValueEdit.Text);
      Result := True;
    end;
  finally
    ParamForm.Free;
  end;
end;

{ TParamForm }

//------------------------------------------------------------------------------

function TParamForm.CheckInput: boolean;
begin
  Result := False;
  case inputValueType of
    ivInteger:
      try
        StrToInt(ValueEdit.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('Integer convert error',
            mtError, [mbOK], 0);
      end;
    ivDouble:
      try
        StrToFloat(ValueEdit.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('Float convert error',
            mtError, [mbOK], 0);
      end;
    ivTimeStamp:
      try
        StrToDateTime(ValueEdit.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('DateTime convert error',
            mtError, [mbOK], 0);
      end;
    ivTime:
      try
        StrToTime(ValueEdit.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('Time convert error',
            mtError, [mbOK], 0);
      end;
    ivDate:
      try
        StrToDate(ValueEdit.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('Date convert error',
            mtError, [mbOK], 0);
      end;
    else
      Result := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TParamForm.edValueChange(Sender: TObject);
begin
  if NullCheckBox.Visible then
    NullCheckBox.Checked := (ValueEdit.Text = '');
end;

//------------------------------------------------------------------------------

procedure TParamForm.NullCheckBoxClick(Sender: TObject);
begin
  if NullCheckBox.Checked then ValueEdit.Text := '';
end;

//------------------------------------------------------------------------------

procedure TParamForm.NowButtonClick(Sender: TObject);
begin
  case inputValueType of
    ivTimeStamp:
      ValueEdit.Text := DateTimeToStr(Now);
    ivTime:
      ValueEdit.Text := TimeToStr(Now);
    ivDate:
      ValueEdit.Text := DateTostr(Now);
  end;
end;

//------------------------------------------------------------------------------

procedure TParamForm.OkButtonClick(Sender: TObject);
begin
  if not NullCheckBox.Checked then
  begin
    if CheckInput then ModalResult := mrOk;
  end
  else
  begin
    ModalResult := mrOk;
  end;
end;

//------------------------------------------------------------------------------

procedure TParamForm.ValueEditKeyPress(Sender: TObject; var Key: char);
begin
  case inputValueType of
    ivInteger:
      if not (key in ['0'..'9', #8]) then key := #0;
    ivDouble:
      if not (key in ['0'..'9', #8, DecimalSeparator]) then key := #0;
    ivTimeStamp:
      if not (key in ['0'..'9', #8, DateSeparator, TimeSeparator]) then key := #0;
    ivDate:
      if not (key in ['0'..'9', #8, DateSeparator]) then key := #0;
    ivTime:
      if not (key in ['0'..'9', #8, TimeSeparator]) then key := #0;
  end;
end;

//------------------------------------------------------------------------------

function TParamForm.GetNullValue: boolean;
begin
  result := NullCheckBox.Checked;
end;


//------------------------------------------------------------------------------

procedure TParamForm.FormCreate(Sender: TObject);
begin
 // {$I fsunixborder.inc}
end;

initialization
  {$I fsparaminput.lrs}

end.

