(*
   fenixsql
   author Alessandro Batisti

   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsdm.pas

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
unit fsdm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Dialogs, FBLDatabase,
  SynHighlighterSQL, FBLTransaction, FBLDsql, FBLMetadata;

type

  { TMainDataModule }

  TMainDataModule = class(TDataModule)
    SynSQLSyn1: TSynSQLSyn;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    MainDb: TFBLDatabase;
    BlobViewTr: TFBLTransaction;
    BlobViewQry: TFBLDsql;
    TableFilterQry: TFBLDsql;
    TableViewTr: TFBLTransaction;
    TableViewQry: TFBLDsql;
    BrowserTr: TFBLTransaction;
    BrowserQry: TFBLDsql;
    MainQry: TFBLDsql;
    MainTr: TFBLTransaction;
    SqlMetaData: TFBLMetadata;
  end;

var
  MainDataModule: TMainDataModule;

implementation

{$R *.lfm}

{ TMainDataModule }

procedure TMainDataModule.DataModuleCreate(Sender: TObject);
begin
  MainDb := TFBLDatabase.Create(self);

  BlobViewTr := TFBLTransaction.Create(self);
  BlobViewQry := TFBLDsql.Create(self);
  BlobViewTr.Database := MainDb;
  BlobViewQry.Transaction := BlobViewTr;


  TableViewTr := TFBLTransaction.Create(self);
  TableFilterQry := TFBLDsql.Create(self);
  TableViewQry := TFBLDsql.Create(self);
  TableViewTr.Database := MainDb;
  TableViewQry.Transaction := TableViewTr;
  TableFilterQry.Transaction := TableViewTr;


  BrowserTr := TFBLTransaction.Create(self);
  BrowserQry := TFBLDsql.Create(self);
  BrowserTr.Database := MainDb;
  BrowserQry.Transaction := BrowserTr;

  MainTr := TFBLTransaction.Create(self);
  MainQry := TFBLDsql.Create(self);
  MainTr.Database := MainDb;
  MainQry.Transaction := MainTr;

  SqlMetaData := TFBLMetadata.Create(self);
  SqlMetaData.Database := MainDb;

end;

procedure TMainDataModule.DataModuleDestroy(Sender: TObject);
begin

end;


end.

