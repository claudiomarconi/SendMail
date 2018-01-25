library CSMail;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  ShareMem,
  SysUtils,
  Classes,
  IdSMTP,
  IdSSLOpenSSL,
  IdMessage,
  IdText,
  IdAttachmentFile,
  IdExplicitTLSClientServerBase,
  EncdDecd,
  NetEncoding,
  SynLog,
  SynCommons;

{Função para criptografar e descriptografar uma string}

// Como estava no .exe para testar a DLL
//  Encripta( TNetEncoding.Base64.Encode(edtEncDec.Text));
function Encripta(Dados: string): string; stdcall;
var
  i: Integer;
  Res: string;
  sDados: string;
begin
  sDados := TNetEncoding.Base64.Encode(Dados);
  for i := 1 to Length(sDados) do
    Res := Res + Chr(Ord(sDados[i]) + 1);

  Result := Res;
  //Result := Res;
end;

// Como estava no .exe para testar a DLL
// TNetEncoding.Base64.Decode(Decripta(edtEncDec.Text));
function Decripta(Dados: string): string; stdcall;
var
  i: Integer;
  Res: string;
  sDados: string;
begin
  sDados := Dados;
  for i := 1 to Length(Dados) do
    Res := Res + Chr(Ord(sDados[i]) - 1);

  Result := TNetEncoding.Base64.Decode(Res);
  //Result := Res;
end;


(* Este codigo estava no .exe para testar a DLL. Resolvi trazer para a DLL e tirar do .exe
function TfrmTesteEmail.Decripta(Dados: string): string;
var
  i: Integer;
begin
  for i := 1 to Length(Dados) do
    Result := Result + Chr(Ord(Dados[i])-1);
end;


function TfrmTesteEmail.Encripta(Dados: string): string;
var
  i: Integer;
begin
  for i := 1 to Length(Dados) do
    Result := Result + Chr(Ord(Dados[i])+1);

end;
*)

procedure EnviarEmailDiversos(sAnexo, sEmailContabilidade, sCorpoEmail, sAssunto: PChar); stdcall;
var
  // variáveis e objetos necessários para o envio
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  ILog: ISynLog;
  s1, s2, s3, s4: AnsiString;
  sFileCfg, sExe: string;
  CfgHost, CfgPort, CfgUserName, CfgPassword, CfgFromAddress, CfgFromName: string;
  strFile: TStrings;
  sSenha: string;
  spAnexo, spEmailContabilidade, spCorpoEmail, spAssunto: AnsiString;
  ss: AnsiString;
begin
  sExe := ParamStr(0);
  sFileCfg := IncludeTrailingPathDelimiter(ExtractFilePath(sExe)) + 'CSMail.inf';

  strFile := TStringList.Create;
  try
    strFile.LoadFromFile(sFileCfg);
    CfgHost := strFile.Values['Host'];
    CfgPort := strFile.Values['Port'];
    CfgUserName := strFile.Values['UserName'];
    CfgFromAddress := strFile.Values['From.Address'];
    CfgFromName := strFile.Values['From.Name'];
    sSenha := strFile.Values['Password'];
  finally
    strFile.Free;
  end;
  CfgPassword :=  Decripta(sSenha);

  ss := PAnsiChar(sAnexo);
  s2 := PAnsiChar(sEmailContabilidade);
  s3 := PAnsiChar(sCorpoEmail);
  s4 := PAnsiChar(sAssunto);

  spAnexo := PAnsiChar(sAnexo);
  spEmailContabilidade := PAnsiChar(sEmailContabilidade);
  spCorpoEmail := PAnsiChar(sCorpoEmail);
  spAssunto := PAnsiChar(sAssunto);

  with TSynLog.Family do
  begin
    Level := LOG_VERBOSE;
    PerThreadLog := ptOneFilePerThread;
    DestinationPath := 'C:\Logs';
  end;

  ILog := TSynLog.Enter(nil, 'EnviarEmailDiversos');

  // instanciação dos objetos
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  IdSMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);
  try
    // Configuração do protocolo SSL (TIdSSLIOHandlerSocketOpenSSL)
    IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

    // Configuração do servidor SMTP (TIdSMTP)
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    IdSMTP.UseTLS := utUseImplicitTLS;
    IdSMTP.AuthType := satDefault;
    IdSMTP.Port := StrToInt(CfgPort); // 465;
    IdSMTP.Host := CfgHost; // 'smtp.gmail.com';
    IdSMTP.Username := CfgUserName; // 'cmarcony@gmail.com';//'contribuintenfe@gmail.com';
    IdSMTP.Password := CfgPassword; // '##google@nx!*537';//'ContribuinteNFe@96537807';

    // Configuração da mensagem (TIdMessage)
    IdMessage.From.Address := CfgFromAddress; //'contribuintenfe@gmail.com';
    IdMessage.From.Name := CfgFromName; //'Software Contribuinte NFe';
    IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
    IdMessage.Recipients.Add.Text := Trim(string(spEmailContabilidade));
    //IdMessage.Recipients.Add.Text  := 'destinatario2@email.com'; // opcional
    //IdMessage.Recipients.Add.Text  := 'destinatario3@email.com'; // opcional
    IdMessage.Subject := Trim(string(spAssunto));
    IdMessage.Encoding := meMIME;

    // do some stuff
    TSynLog.Enter.Log(sllInfo, 'Configuracao:');
    TSynLog.Enter.Log(sllInfo, 'Host:' + IdSMTP.Host); // + #13#10
    TSynLog.Enter.Log(sllInfo, 'Username: ' + CfgUserName); // + #13#10
    TSynLog.Enter.Log(sllInfo, 'Password: '); //     + #13#10
    TSynLog.Enter.Log(sllInfo, 'From.Address: ' + CfgFromAddress); // + #13#10
    TSynLog.Enter.Log(sllInfo, 'From.Name: ' + CfgFromName ); // + #13#10
    TSynLog.Enter.Log(sllInfo, 'ReplyTo.EMailAddresses: ' + IdMessage.From.Address); // + #13#10
    TSynLog.Enter.Log(sllInfo, 'Recipients: ' + Trim(string(spEmailContabilidade))); // + #13#10
    TSynLog.Enter.Log(sllInfo, 'Subject: ' + Trim(string(spAssunto)));

    // Configuração do corpo do email (TIdText)
    IdText := TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add(string(spCorpoEmail));
    IdText.ContentType := 'text/plain; charset=iso-8859-1';

    // Opcional - Anexo da mensagem (TIdAttachmentFile)
    if FileExists(string(spAnexo)) then
    begin
      TIdAttachmentFile.Create(IdMessage.MessageParts, string(spAnexo));
    end;

    // Conexão e autenticação
    try
      TSynLog.Enter.Log(sllEnter, 'Conectando...');
      IdSMTP.Connect;
      ILog.Log(sllLeave, 'Conectado');
      //Application.ProcessMessages;
      ILog.Log(sllEnter, 'Autenticando...');
      IdSMTP.Authenticate;
      ILog.Log(sllLeave, 'Autenticado');
      //Application.ProcessMessages;
    except
      on E: Exception do
      begin
        TSynLog.Enter.Log(sllException, E.Message);
        //MessageDlg('Erro na conexão ou autenticação: ' +  E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;

    // Envio da mensagem
    try
      TSynLog.Enter.Log(sllEnter, 'Enviando...');
      IdSMTP.Send(IdMessage);
      TSynLog.Enter.Log(sllLeave, 'Enviado');
      //Application.MessageBox('Arquivos enviados com sucesso!','Envio de arquivos', MB_OK + MB_ICONINFORMATION);
      //MessageDlg('', mtInformation, [mbOK], 0);
    except
      on E: Exception do
      begin
        TSynLog.Enter.Log(sllException, E.Message);
        //MessageDlg('Erro ao enviar a mensagem: ' + E.Message, mtWarning, [mbOK], 0);
      end;
    end;
  finally
    // desconecta do servidor
    TSynLog.Enter.Log(sllEnter, 'Desconectando...');
    IdSMTP.Disconnect;
    TSynLog.Enter.Log(sllLeave, 'Desconectado');
    // liberação da DLL
    UnLoadOpenSSLLibrary;
    // liberação dos objetos da memória
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
end;
{$R *.res}

exports
  EnviarEmailDiversos;

exports
  Encripta;

exports
  Decripta;

begin

end.

