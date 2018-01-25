program EmailTeste;

uses
  Forms,
  TesteEmailForm in 'TesteEmailForm.pas' {frmTesteEmail};

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmTesteEmail, frmTesteEmail);
  Application.Run;
end.
