(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org
  
   File: fsoptions.pas

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
unit fsoptions;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, ExtCtrls,
  StdCtrls, Spin, Buttons, ComCtrls;

type

  { TOptionsForm }

  TOptionsForm = class(TForm)
    CancelButton: TBitBtn;
    OkButton: TBitBtn;
    BrowserGroupBox: TCheckGroup;
    SqlCheckGroup: TCheckGroup;
    GroupBox1: TGroupBox;
    GroupBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    PageControl1: TPageControl;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    OutputRadioGroup: TRadioGroup;
    MaxFetchSplinEdit: TSpinEdit;
    MaxGridRowsSpinEdit: TSpinEdit;
    TabSheet1: TTabSheet;
    procedure OkButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MaxFetchSplinEditChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;



implementation

{$R *.lfm}

uses
  fsconfig;

{ TOptionsForm }

procedure TOptionsForm.FormCreate(Sender: TObject);
begin
  //{$I fsunixborder.inc}
  BrowserGroupBox.Checked[0] := FsConfig.SystemObjectsVisible;
  SqlCheckGroup.Checked[0] := FsConfig.AutoCommitDDL;
  SqlCheckGroup.Checked[1] := FsConfig.VerboseSqlScript;
  SqlCheckGroup.Checked[2] := FsConfig.SetTermVisible;
  MaxGridRowsSpinEdit.Value := FsConfig.MaxGridRows;
  MaxFetchSplinEdit.Value := FsConfig.MaxFetchResult;
  OutputRadioGroup.ItemIndex := FsConfig.OutputGridType;
end;


//------------------------------------------------------------------------------

procedure TOptionsForm.MaxFetchSplinEditChange(Sender: TObject);
begin
  if MaxFetchSplinEdit.Value < 0 then
    MaxFetchSplinEdit.Value := 0;
end;



//------------------------------------------------------------------------------

procedure TOptionsForm.OkButtonClick(Sender: TObject);
begin
  FsConfig.SystemObjectsVisible := BrowserGroupBox.Checked[0];
  FsConfig.AutoCommitDDL := SqlCheckGroup.Checked[0];
  FsConfig.VerboseSqlScript := SqlCheckGroup.Checked[1];
  FsConfig.SetTermVisible := SqlCheckGroup.Checked[2];
  FsConfig.OutputGridType := OutputRadioGroup.ItemIndex;
  FsConfig.MaxGridRows := MaxGridRowsSpinEdit.Value;
  FsConfig.MaxFetchResult := MaxFetchSplinEdit.Value;
  FsConfig.WriteConfigFile;
  ModalResult := mrOk;
end;



end.
