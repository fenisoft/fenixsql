program fenixsql;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, fsusers, fsabout, fsbackup, fsblobinput, fsblobtext, fsblobviewdialog,
  fsbrowser, fsconfig, fscreatedb, fsdbconnections, fsdescription, fsdialogtran,
  fsdm, fsgridintf, fslogin, fsmixf, fsoptions, fsparaminput, fsservice,
  fstablefilter, fstableview, fstextoptions, fsusermod, fsexport, fsmessages
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TBrowserForm, BrowserForm);
  Application.CreateForm(TMainDataModule, MainDataModule);
  Application.Run;
end.

