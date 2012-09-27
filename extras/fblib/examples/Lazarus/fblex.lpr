program fblex;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { add your units here }, ufblex, fblib, udblogin;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFblex, frmFblex);
  Application.Run;
end.

