program fblEx;

uses
  Forms,
  uexamples in 'uexamples.pas' {frmFblEx},
  udblogin in 'udblogin.pas' {frmDBlogin};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmFblEx, frmFblEx);
  Application.Run;
end.
