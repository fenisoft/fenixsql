(*
   fenixsql
   author Alessandro Batisti
   http://code.google.com/p/fenixsql
   http://fblib.altervista.org

   file:fsabout.pas


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

unit fsabout;

{$mode objfpc}{$H+}

interface

uses
  Forms, Controls, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, LCLIntf;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    Label2: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    AuthorLabel: TLabel;
    Title2Table: TLabel;
    Title1Label: TLabel;
    UrlLabel: TLabel;
    VersionLabel: TLabel;
    mLic: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    InfoTabSheet: TTabSheet;
    licTabSheet: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure UrlLabelClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

procedure ShowAbout(AAppVersion, AAuthor, AUrl: string);

implementation

{$R *.lfm}

procedure ShowAbout(AAppVersion, AAuthor, AUrl: string);
var
  AboutForm: TAboutForm;
begin
  AboutForm := TAboutForm.Create(nil);
  try
    AboutForm.VersionLabel.Caption := AAppVersion;
    AboutForm.AuthorLabel.Caption := AAuthor;
    AboutForm.UrlLabel.Caption := AUrl;
    AboutForm.ShowModal;
  finally
    AboutForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  licTabSheet.Caption := 'License Agreement';
  infoTabSheet.Caption := 'Info';
  UrlLabel.Cursor := crHandPoint;
end;

procedure TAboutForm.UrlLabelClick(Sender: TObject);
begin
  OpenUrl(UrlLabel.Caption);
end;

end.
