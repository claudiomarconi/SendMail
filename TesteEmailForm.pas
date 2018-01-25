unit TesteEmailForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics,
  Controls, Forms, Dialogs,  StdCtrls,
  Classes;

type
  TfrmTesteEmail = class(TForm)
    Button1: TButton;
    edtAnexo: TEdit;
    edtEmailDestino: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    edtEncDec: TEdit;
    Button3: TButton;
    edtResultEncDec: TEdit;
    mmo: TMemo;
    edtAssunto: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    mmoMensagem: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTesteEmail: TfrmTesteEmail;

procedure EnviarEmailDiversos(sAnexo, sEmailContabilidade, sCorpoEmail, sAssunto : PWideString); stdcall; External 'CSMail.dll';
function Encripta(Dados : string): string; stdcall; External 'CSMail.dll';
function Decripta(Dados : string): string; stdcall; External 'CSMail.dll';

implementation

uses
  NetEncoding;


{$R *.dfm}

procedure TfrmTesteEmail.Button1Click(Sender: TObject);
var
  sAnexo, sEmailContabilidade,
  sCorpoEmail, sAssunto: string;
begin
  try
  sAnexo := edtAnexo.Text;
  sEmailContabilidade := edtEmailDestino.Text;


  sCorpoEmail := mmoMensagem.Lines.GetText;
  sAssunto := edtAssunto.Text
  except on E: Exception do
    ShowMessage('Erro: ' + E.Message);
  end;

  EnviarEmailDiversos(
    PWideString(sAnexo),
    PWideString(sEmailContabilidade),
    PWideString(sCorpoEmail),
    PWideString(sAssunto )
  );

end;

procedure TfrmTesteEmail.Button2Click(Sender: TObject);
begin
  edtResultEncDec.Text := Encripta(edtEncDec.Text);
end;

procedure TfrmTesteEmail.Button3Click(Sender: TObject);
begin
  edtResultEncDec.Text := Decripta(edtEncDec.Text);
end;


end.
