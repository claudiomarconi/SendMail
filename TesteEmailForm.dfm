object frmTesteEmail: TfrmTesteEmail
  Left = 0
  Top = 0
  Caption = 'frmTesteEmail'
  ClientHeight = 422
  ClientWidth = 646
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 56
    Width = 66
    Height = 13
    Caption = 'Email destino:'
  end
  object Label2: TLabel
    Left = 10
    Top = 7
    Width = 35
    Height = 13
    Caption = 'Anexo:'
  end
  object Label3: TLabel
    Left = 10
    Top = 104
    Width = 39
    Height = 13
    Caption = 'Assunto'
  end
  object Label4: TLabel
    Left = 10
    Top = 152
    Width = 39
    Height = 13
    Caption = 'Assunto'
  end
  object Button1: TButton
    Left = 254
    Top = 266
    Width = 75
    Height = 25
    Caption = 'Enviar'
    TabOrder = 0
    OnClick = Button1Click
  end
  object edtAnexo: TEdit
    Left = 8
    Top = 24
    Width = 321
    Height = 21
    TabOrder = 1
    Text = 'C:\DR285393.O7H'
  end
  object edtEmailDestino: TEdit
    Left = 8
    Top = 72
    Width = 321
    Height = 21
    TabOrder = 2
    Text = 'claudio.marconi@outlook.com'
  end
  object Button2: TButton
    Left = 161
    Top = 347
    Width = 75
    Height = 25
    Caption = 'Encriptar'
    TabOrder = 3
    OnClick = Button2Click
  end
  object edtEncDec: TEdit
    Left = 8
    Top = 320
    Width = 309
    Height = 21
    TabOrder = 4
    Text = 'claudio.marconi@outlook.com'
  end
  object Button3: TButton
    Left = 242
    Top = 347
    Width = 75
    Height = 25
    Caption = 'Decriptar'
    TabOrder = 5
    OnClick = Button3Click
  end
  object edtResultEncDec: TEdit
    Left = 8
    Top = 378
    Width = 309
    Height = 21
    TabOrder = 6
  end
  object mmo: TMemo
    Left = 335
    Top = 24
    Width = 290
    Height = 267
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'Port=465'
      'Host=smtp.gmail.com'
      'Username=cmarcony@gmail.com'
      'Password=JzOoc3:ocHWBcohiLkV{Ox>>'
      'From.Address=cmarcony@gmail.com'
      'From.Name=Software Contribuinte NFe')
    ParentFont = False
    TabOrder = 7
  end
  object edtAssunto: TEdit
    Left = 8
    Top = 120
    Width = 321
    Height = 21
    TabOrder = 8
    Text = 'Informar o assunto do email'
  end
  object mmoMensagem: TMemo
    Left = 8
    Top = 171
    Width = 321
    Height = 89
    Lines.Strings = (
      'Informar o conteudo da mensagem do email')
    TabOrder = 9
  end
end
