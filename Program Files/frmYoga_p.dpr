program frmYoga_p;

uses
  Forms,
  frmYoga_u in 'frmYoga_u.pas' {frmYoga},
  clsNewStudent_u in 'clsNewStudent_u.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmYoga, frmYoga);
  Application.Run;
end.
