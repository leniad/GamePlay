object Form4: TForm4
  Left = 662
  Top = 376
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Configuraci'#243'n Avanzada'
  ClientHeight = 631
  ClientWidth = 869
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  Scaled = False
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object Button1: TButton
    Left = 216
    Top = 567
    Width = 121
    Height = 49
    Caption = 'ACEPTAR'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button7: TButton
    Left = 588
    Top = 567
    Width = 121
    Height = 49
    Caption = 'CANCELAR'
    TabOrder = 3
    OnClick = Button7Click
  end
  object GroupBox3: TGroupBox
    Left = 25
    Top = 280
    Width = 600
    Height = 261
    Caption = 'Directorios Base'
    TabOrder = 0
    StyleName = 'Windows10'
    object LabeledEdit6: TLabeledEdit
      Left = 19
      Top = 30
      Width = 514
      Height = 23
      EditLabel.Width = 51
      EditLabel.Height = 15
      EditLabel.Caption = 'Manuales'
      ReadOnly = True
      TabOrder = 0
      Text = ''
      StyleName = 'Windows'
    end
    object LabeledEdit7: TLabeledEdit
      Left = 19
      Top = 70
      Width = 514
      Height = 23
      EditLabel.Width = 35
      EditLabel.Height = 15
      EditLabel.Caption = 'Mapas'
      ReadOnly = True
      TabOrder = 1
      Text = ''
      StyleName = 'Windows'
    end
    object LabeledEdit8: TLabeledEdit
      Left = 19
      Top = 110
      Width = 514
      Height = 23
      EditLabel.Width = 29
      EditLabel.Height = 15
      EditLabel.Caption = 'Guias'
      ReadOnly = True
      TabOrder = 2
      Text = ''
      StyleName = 'Windows'
    end
    object Button8: TButton
      Left = 539
      Top = 29
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 6
      StyleName = 'Windows'
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 539
      Top = 69
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 7
      StyleName = 'Windows'
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 539
      Top = 109
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 8
      StyleName = 'Windows'
      OnClick = Button10Click
    end
    object Button11: TButton
      Left = 539
      Top = 149
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 9
      StyleName = 'Windows'
      OnClick = Button11Click
    end
    object LabeledEdit9: TLabeledEdit
      Left = 19
      Top = 150
      Width = 514
      Height = 23
      EditLabel.Width = 22
      EditLabel.Height = 15
      EditLabel.Caption = 'ZIPs'
      ReadOnly = True
      TabOrder = 3
      Text = ''
      StyleName = 'Windows'
    end
    object Button12: TButton
      Left = 539
      Top = 189
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 10
      StyleName = 'Windows'
      OnClick = Button12Click
    end
    object LabeledEdit10: TLabeledEdit
      Left = 19
      Top = 190
      Width = 514
      Height = 23
      EditLabel.Width = 51
      EditLabel.Height = 15
      EditLabel.Caption = 'Imagenes'
      ReadOnly = True
      TabOrder = 4
      Text = ''
      StyleName = 'Windows'
    end
    object Button13: TButton
      Left = 539
      Top = 229
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 11
      StyleName = 'Windows'
      OnClick = Button13Click
    end
    object LabeledEdit11: TLabeledEdit
      Left = 19
      Top = 230
      Width = 514
      Height = 23
      EditLabel.Width = 30
      EditLabel.Height = 15
      EditLabel.Caption = 'MT32'
      ReadOnly = True
      TabOrder = 5
      Text = ''
      StyleName = 'Windows'
    end
  end
  object Button14: TButton
    Left = 688
    Top = 135
    Width = 121
    Height = 49
    BiDiMode = bdLeftToRight
    Caption = 'VALORES'#13' POR DEFECTO'
    ParentBiDiMode = False
    TabOrder = 1
    WordWrap = True
    OnClick = Button14Click
  end
  object GroupBox5: TGroupBox
    Left = 641
    Top = 279
    Width = 168
    Height = 94
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Idioma'
    TabOrder = 4
    object RadioButton1: TRadioButton
      Left = 10
      Top = 27
      Width = 89
      Height = 15
      Caption = 'Auto'
      TabOrder = 0
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 10
      Top = 48
      Width = 72
      Height = 15
      Caption = 'Espa'#241'ol'
      TabOrder = 1
      OnClick = RadioButton2Click
    end
    object RadioButton3: TRadioButton
      Left = 10
      Top = 69
      Width = 69
      Height = 15
      Caption = 'English'
      TabOrder = 2
      OnClick = RadioButton3Click
    end
    object RadioButton4: TRadioButton
      Left = 80
      Top = 27
      Width = 67
      Height = 15
      Caption = 'Deutsch'
      TabOrder = 3
      OnClick = RadioButton4Click
    end
    object RadioButton5: TRadioButton
      Left = 80
      Top = 48
      Width = 68
      Height = 15
      Caption = 'Fran'#231'ais'
      TabOrder = 4
      OnClick = RadioButton5Click
    end
    object RadioButton6: TRadioButton
      Left = 80
      Top = 69
      Width = 68
      Height = 15
      Caption = 'Italiano'
      TabOrder = 5
      OnClick = RadioButton6Click
    end
  end
  object PageControl1: TPageControl
    Left = 25
    Top = 10
    Width = 600
    Height = 247
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ActivePage = TabSheet1
    TabOrder = 5
    StyleName = 'Windows'
    object TabSheet1: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'MSDOS'
      object LabeledEdit4: TLabeledEdit
        Left = 15
        Top = 125
        Width = 514
        Height = 23
        EditLabel.Width = 76
        EditLabel.Height = 15
        EditLabel.Caption = 'DosBox config'
        TabOrder = 0
        Text = ''
      end
      object Button2: TButton
        Left = 535
        Top = 124
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 535
        Top = 166
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 2
        OnClick = Button3Click
      end
      object LabeledEdit5: TLabeledEdit
        Left = 15
        Top = 167
        Width = 514
        Height = 23
        EditLabel.Width = 88
        EditLabel.Height = 15
        EditLabel.Caption = 'DosBox-X config'
        TabOrder = 3
        Text = ''
      end
      object LabeledEdit1: TLabeledEdit
        Left = 15
        Top = 23
        Width = 514
        Height = 23
        EditLabel.Width = 61
        EditLabel.Height = 15
        EditLabel.Caption = 'DosBox EXE'
        EditLabel.Color = clBtnFace
        EditLabel.ParentColor = False
        TabOrder = 4
        Text = ''
      end
      object LabeledEdit2: TLabeledEdit
        Left = 15
        Top = 65
        Width = 514
        Height = 23
        EditLabel.Width = 73
        EditLabel.Height = 15
        EditLabel.Caption = 'DosBox-X EXE'
        TabOrder = 5
        Text = ''
      end
      object Button5: TButton
        Left = 535
        Top = 64
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 6
        OnClick = Button5Click
      end
      object Button4: TButton
        Left = 535
        Top = 22
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 7
        OnClick = Button5Click
      end
    end
    object TabSheet2: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'ScummVM'
      ImageIndex = 1
      object Button6: TButton
        Left = 535
        Top = 22
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 0
        OnClick = Button6Click
      end
      object LabeledEdit3: TLabeledEdit
        Left = 15
        Top = 23
        Width = 514
        Height = 23
        EditLabel.Width = 81
        EditLabel.Height = 15
        EditLabel.Caption = 'ScummVM EXE'
        TabOrder = 1
        Text = ''
      end
      object LabeledEdit12: TLabeledEdit
        Left = 15
        Top = 125
        Width = 514
        Height = 23
        EditLabel.Width = 96
        EditLabel.Height = 15
        EditLabel.Caption = 'ScummVM config'
        TabOrder = 2
        Text = ''
      end
      object Button15: TButton
        Left = 535
        Top = 124
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 3
        OnClick = Button15Click
      end
    end
    object TabSheet3: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'DSP Emulator'
      ImageIndex = 2
      object Button16: TButton
        Left = 535
        Top = 22
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 0
        OnClick = Button16Click
      end
      object LabeledEdit13: TLabeledEdit
        Left = 15
        Top = 23
        Width = 514
        Height = 23
        EditLabel.Width = 94
        EditLabel.Height = 15
        EditLabel.Caption = 'DSP Emulator EXE'
        TabOrder = 1
        Text = ''
      end
      object LabeledEdit20: TLabeledEdit
        Left = 15
        Top = 125
        Width = 514
        Height = 23
        EditLabel.Width = 58
        EditLabel.Height = 15
        EditLabel.Caption = 'DSP config'
        TabOrder = 2
        Text = ''
      end
      object Button23: TButton
        Left = 535
        Top = 124
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 3
        OnClick = Button23Click
      end
    end
    object TabSheet4: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Apple II'
      ImageIndex = 3
      object LabeledEdit14: TLabeledEdit
        Left = 15
        Top = 23
        Width = 514
        Height = 23
        EditLabel.Width = 74
        EditLabel.Height = 15
        EditLabel.Caption = 'AppleWin EXE'
        TabOrder = 0
        Text = ''
      end
      object Button17: TButton
        Left = 535
        Top = 22
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 1
        OnClick = Button17Click
      end
      object Button20: TButton
        Left = 535
        Top = 124
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 2
        OnClick = Button20Click
      end
      object LabeledEdit17: TLabeledEdit
        Left = 15
        Top = 125
        Width = 514
        Height = 23
        EditLabel.Width = 89
        EditLabel.Height = 15
        EditLabel.Caption = 'AppleWin config'
        TabOrder = 3
        Text = ''
      end
    end
    object TabSheet5: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Atari 800'
      ImageIndex = 4
      object Button18: TButton
        Left = 535
        Top = 22
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 0
        OnClick = Button18Click
      end
      object LabeledEdit15: TLabeledEdit
        Left = 15
        Top = 23
        Width = 514
        Height = 23
        EditLabel.Width = 54
        EditLabel.Height = 15
        EditLabel.Caption = 'Altirra EXE'
        TabOrder = 1
        Text = ''
      end
      object Button21: TButton
        Left = 535
        Top = 124
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 2
        OnClick = Button21Click
      end
      object LabeledEdit18: TLabeledEdit
        Left = 15
        Top = 125
        Width = 514
        Height = 23
        EditLabel.Width = 69
        EditLabel.Height = 15
        EditLabel.Caption = 'Altirra config'
        TabOrder = 3
        Text = ''
      end
    end
    object TabSheet6: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Amiga'
      ImageIndex = 5
      object Button19: TButton
        Left = 535
        Top = 22
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 0
        OnClick = Button19Click
      end
      object LabeledEdit16: TLabeledEdit
        Left = 15
        Top = 23
        Width = 514
        Height = 23
        EditLabel.Width = 62
        EditLabel.Height = 15
        EditLabel.Caption = 'Winuae EXE'
        TabOrder = 1
        Text = ''
      end
      object Button22: TButton
        Left = 535
        Top = 124
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 2
        OnClick = Button22Click
      end
      object LabeledEdit19: TLabeledEdit
        Left = 15
        Top = 125
        Width = 514
        Height = 23
        EditLabel.Width = 77
        EditLabel.Height = 15
        EditLabel.Caption = 'Winuae config'
        TabOrder = 3
        Text = ''
      end
    end
    object TabSheet7: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Atari ST'
      ImageIndex = 6
      object LabeledEdit21: TLabeledEdit
        Left = 23
        Top = 31
        Width = 514
        Height = 23
        EditLabel.Width = 63
        EditLabel.Height = 15
        EditLabel.Caption = 'Atari ST EXE'
        TabOrder = 0
        Text = ''
      end
      object LabeledEdit22: TLabeledEdit
        Left = 23
        Top = 133
        Width = 514
        Height = 23
        EditLabel.Width = 78
        EditLabel.Height = 15
        EditLabel.Caption = 'Atari ST config'
        TabOrder = 1
        Text = ''
      end
      object Button24: TButton
        Left = 543
        Top = 30
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 2
        OnClick = Button24Click
      end
      object Button25: TButton
        Left = 543
        Top = 132
        Width = 33
        Height = 25
        Caption = 'Abrir'
        TabOrder = 3
        OnClick = Button25Click
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 1176
    Top = 348
    Width = 278
    Height = 158
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'GroupBox4'
    TabOrder = 6
  end
  object GroupBox6: TGroupBox
    Left = 641
    Top = 390
    Width = 211
    Height = 116
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    TabOrder = 7
    object CheckBox10: TCheckBox
      Left = 12
      Top = 10
      Width = 189
      Height = 25
      Caption = 'Leer valores de los juegos fijos'
      TabOrder = 0
      OnClick = CheckBox10Click
    end
    object CheckBox2: TCheckBox
      Left = 12
      Top = 60
      Width = 195
      Height = 25
      Caption = 'Mostrar solo juegos a'#241'adidos'
      TabOrder = 1
      WordWrap = True
      OnClick = CheckBox2Click
    end
    object CheckBox1: TCheckBox
      Left = 12
      Top = 35
      Width = 195
      Height = 25
      Caption = 'Mostrar todos los juegos'
      TabOrder = 2
      WordWrap = True
      OnClick = CheckBox1Click
    end
    object CheckBox3: TCheckBox
      Left = 12
      Top = 85
      Width = 195
      Height = 25
      Caption = 'Descargar Extras'
      TabOrder = 3
      WordWrap = True
      OnClick = CheckBox2Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 716
    Top = 45
  end
end
