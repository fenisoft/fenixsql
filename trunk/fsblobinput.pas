(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://web.tiscali.it/fblib

   file:fsblobinput.pas


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

unit fsblobinput;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  EditBtn, Buttons, StdCtrls;

type

  { TBlobInputForm }

  TBlobInputForm = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    NullCheckBox: TCheckBox;
    ValueEdit: TFileNameEdit;
    Label1: TLabel;
    ParamNumberLabel: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ParamTypeLabel: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnOkClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

//var
//  BlobInputForm: TBlobInputForm;

function InputParamBlob(const AParamNum, AParamType: string;
  var AisNullable: boolean; var AFileName: string): boolean;

implementation



function InputParamBlob(const AParamNum, AParamType: string;
  var AisNullable: boolean; var AFileName: string): boolean;
var
  BlobInputForm: TBlobInputForm;
begin
  BlobInputForm := TBlobInputForm.Create(Application);
  try
    Result := False;
    BlobInputForm.NullCheckBox.Visible := AisNullable;
    BlobInputForm.NullCheckBox.Checked := AisNullable;
    if not AisNullable then
    begin
      BlobInputForm.ValueEdit.Text := '';
      BlobInputForm.ParamTypeLabel.Caption := AParamType + ' NOT NULL';
    end
    else
      BlobInputForm.ParamTypeLabel.Caption := AParamType;

    BlobInputForm.ParamNumberLabel.Caption := AParamNum;
    if BlobInputForm.ShowModal = mrOk then
    begin
      AFileName := BlobInputForm.ValueEdit.Text;
      AisNullable := BlobInputForm.NullCheckBox.Checked;
      Result := True;
    end;
  finally
    BlobInputForm.Free;
  end;
end;


{ TBlobInputForm }

procedure TBlobInputForm.btnOkClick(Sender: TObject);
begin
  if NullCheckBox.Checked then
    ModalResult := mrOk
  else
  if FileExists(ValueEdit.Text) then
    ModalResult := mrOk
  else
    ShowMessage('Insert a valid filename');
end;

initialization
  {$I fsblobinput.lrs}

end.
