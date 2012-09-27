(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsdialogtran.pas


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

unit fsdialogtran;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, StdCtrls,
  Buttons;

type

  { TDialogTransForm }

  TDialogTransForm = class(TForm)
    CommitButton: TBitBtn;
    RollBackButton: TBitBtn;
    CancelButton: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

//var
//DialogTransForm: TDialogTransForm;

implementation

{ TDialogTransForm }

procedure TDialogTransForm.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
end;

initialization
  {$I fsdialogtran.lrs}

end.
