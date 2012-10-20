(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
  

   File: fsblobviewdialog.pas

  * This file is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This file is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
*)
unit fsblobviewdialog;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, ExtCtrls,
  StdCtrls, Buttons;

type

  { TBlobViewDialogForm }

  TBlobViewDialogForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    FieldNameLabel: TLabel;
    Label3: TLabel;
    SubTypeLabel: TLabel;
    Panel1: TPanel;
    Panel5: TPanel;
    TypeRadioGroup: TRadioGroup;
  private
    { private declarations }
    function GetBlobType: integer;
    function GetFieldName: string;
    procedure SetBlobType(Value: integer);
    procedure SetFieldName(Value: string);
  public
    { public declarations }
    property BlobType: integer read GetBlobType write SetBlobType;
    property FieldName: string read GetFieldName write SetFieldName;
  end;


implementation

{$R *.lfm}

function TBlobViewDialogForm.GetBlobType: integer;
begin
  Result := TypeRadioGroup.ItemIndex;
end;

//------------------------------------------------------------------------------

function TBlobViewDialogForm.GetFieldName: string;
begin
  Result := FieldNameLabel.Caption;
end;

//------------------------------------------------------------------------------

procedure TBlobViewDialogForm.SetBlobType(Value: integer);
begin
  if Value = 1 then
  begin
    TypeRadioGroup.ItemIndex := 1;
    SubTypeLabel.Caption := '1 - TEXT';
  end
  else
  begin
    TypeRadioGroup.ItemIndex := 0;
    SubTypeLabel.Caption := IntToStr(Value);
  end;
end;

//------------------------------------------------------------------------------

procedure TBlobViewDialogForm.SetFieldName(Value: string);
begin
  FieldNameLabel.Caption := Value;
end;

end.
