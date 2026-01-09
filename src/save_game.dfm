object Form2: TForm2
  Left = 581
  Top = 196
  BiDiMode = bdLeftToRight
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'A'#241'adir Juego'
  ClientHeight = 557
  ClientWidth = 758
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentBiDiMode = False
  Position = poDesigned
  Scaled = False
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = -3
    Width = 742
    Height = 157
    BiDiMode = bdLeftToRight
    Caption = 'Juego'
    ParentBiDiMode = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object Image1: TImage
      Left = 502
      Top = 16
      Width = 227
      Height = 129
      Stretch = True
    end
    object LabeledEdit1: TLabeledEdit
      Left = 16
      Top = 32
      Width = 290
      Height = 23
      EditLabel.Width = 100
      EditLabel.Height = 15
      EditLabel.Caption = 'Nombre Completo'
      EditLabel.Transparent = True
      TabOrder = 0
      Text = ''
    end
    object LabeledEdit2: TLabeledEdit
      Left = 17
      Top = 80
      Width = 93
      Height = 23
      EditLabel.Width = 87
      EditLabel.Height = 15
      EditLabel.Caption = 'A'#241'o Publicaci'#243'n'
      EditLabel.Transparent = True
      NumbersOnly = True
      TabOrder = 1
      Text = ''
    end
    object LabeledEdit3: TLabeledEdit
      Left = 135
      Top = 80
      Width = 145
      Height = 23
      EditLabel.Width = 55
      EditLabel.Height = 15
      EditLabel.Caption = 'Compa'#241#237'a'
      EditLabel.Transparent = True
      TabOrder = 2
      Text = ''
    end
    object LabeledEdit4: TLabeledEdit
      Left = 336
      Top = 32
      Width = 145
      Height = 23
      EditLabel.Width = 115
      EditLabel.Height = 15
      EditLabel.Caption = 'Nombre de la imagen'
      EditLabel.Transparent = True
      TabOrder = 3
      Text = ''
      OnKeyUp = LabeledEdit4KeyUp
    end
    object CheckBox2: TCheckBox
      Left = 17
      Top = 109
      Width = 185
      Height = 25
      Caption = 'Compatible con ScummVM'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object CheckBox4: TCheckBox
      Left = 17
      Top = 129
      Width = 251
      Height = 25
      Caption = 'S'#243'lo funciona con ScummVM'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnClick = CheckBox4Click
    end
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 160
    Width = 742
    Height = 113
    Caption = 'Programa'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    object LabeledEdit5: TLabeledEdit
      Left = 138
      Top = 32
      Width = 145
      Height = 23
      EditLabel.Width = 54
      EditLabel.Height = 15
      EditLabel.Caption = 'Ejecutable'
      EditLabel.Transparent = True
      TabOrder = 1
      Text = ''
      OnKeyUp = LabeledEdit5KeyUp
    end
    object LabeledEdit6: TLabeledEdit
      Left = 284
      Top = 32
      Width = 106
      Height = 23
      EditLabel.Width = 60
      EditLabel.Height = 15
      EditLabel.Caption = 'Par'#225'metros'
      EditLabel.Transparent = True
      TabOrder = 2
      Text = ''
    end
    object LabeledEdit7: TLabeledEdit
      Left = 17
      Top = 74
      Width = 162
      Height = 23
      EditLabel.Width = 81
      EditLabel.Height = 15
      EditLabel.Caption = 'Ejecutar ANTES'
      EditLabel.Transparent = True
      TabOrder = 4
      Text = ''
    end
    object LabeledEdit8: TLabeledEdit
      Left = 196
      Top = 74
      Width = 163
      Height = 23
      EditLabel.Width = 92
      EditLabel.Height = 15
      EditLabel.Caption = 'Ejecutar DESPU'#201'S'
      EditLabel.Transparent = True
      TabOrder = 5
      Text = ''
    end
    object LabeledEdit9: TLabeledEdit
      Left = 17
      Top = 32
      Width = 120
      Height = 23
      EditLabel.Width = 52
      EditLabel.Height = 15
      EditLabel.Caption = 'Directorio'
      EditLabel.Transparent = True
      TabOrder = 0
      Text = ''
    end
    object LabeledEdit10: TLabeledEdit
      Left = 407
      Top = 32
      Width = 145
      Height = 23
      EditLabel.Width = 81
      EditLabel.Height = 15
      EditLabel.Caption = 'Imagen Disco 2'
      EditLabel.Transparent = True
      Enabled = False
      TabOrder = 3
      Text = ''
    end
    object LabeledEdit19: TLabeledEdit
      Left = 556
      Top = 74
      Width = 162
      Height = 23
      EditLabel.Width = 48
      EditLabel.Height = 15
      EditLabel.Caption = 'CD-ROM'
      EditLabel.Transparent = True
      TabOrder = 7
      Text = ''
    end
    object LabeledEdit20: TLabeledEdit
      Left = 375
      Top = 74
      Width = 162
      Height = 23
      EditLabel.Width = 128
      EditLabel.Height = 15
      EditLabel.Caption = 'Programa de Instalaci'#243'n'
      EditLabel.Transparent = True
      TabOrder = 6
      Text = ''
    end
  end
  object GroupBox10: TGroupBox
    Left = 8
    Top = 278
    Width = 742
    Height = 107
    Caption = 'DOSBOX'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object LabeledEdit11: TLabeledEdit
      Left = 16
      Top = 32
      Width = 93
      Height = 23
      EditLabel.Width = 58
      EditLabel.Height = 15
      EditLabel.Caption = 'Ciclos CPU'
      EditLabel.Transparent = True
      NumbersOnly = True
      TabOrder = 0
      Text = ''
    end
    object StaticText1: TStaticText
      Left = 123
      Top = 16
      Width = 88
      Height = 19
      Caption = 'Tipo Ordenador'
      TabOrder = 2
    end
    object ComboBox1: TComboBox
      Left = 123
      Top = 32
      Width = 126
      Height = 23
      TabOrder = 1
    end
    object LabeledEdit12: TLabeledEdit
      Left = 266
      Top = 32
      Width = 93
      Height = 23
      EditLabel.Width = 77
      EditLabel.Height = 15
      EditLabel.Caption = 'Memoria RAM'
      EditLabel.Transparent = True
      NumbersOnly = True
      TabOrder = 3
      Text = ''
    end
    object CheckBox1: TCheckBox
      Left = 375
      Top = 26
      Width = 97
      Height = 25
      Caption = 'Activar GUS'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
    end
    object LabeledEdit13: TLabeledEdit
      Left = 562
      Top = 32
      Width = 167
      Height = 23
      EditLabel.Width = 114
      EditLabel.Height = 15
      EditLabel.Caption = 'Fichero mapa teclado'
      EditLabel.Transparent = True
      TabOrder = 5
      Text = ''
    end
    object LabeledEdit14: TLabeledEdit
      Left = 374
      Top = 73
      Width = 355
      Height = 23
      EditLabel.Width = 133
      EditLabel.Height = 15
      EditLabel.Caption = 'Par'#225'metros extra DOSBox'
      EditLabel.Transparent = True
      TabOrder = 7
      Text = ''
    end
    object LabeledEdit15: TLabeledEdit
      Left = 16
      Top = 73
      Width = 343
      Height = 23
      EditLabel.Width = 165
      EditLabel.Height = 15
      EditLabel.Caption = 'Mensaje de informaci'#243'n/ayuda'
      EditLabel.Transparent = True
      TabOrder = 6
      Text = ''
    end
  end
  object GroupBox12: TGroupBox
    Left = 8
    Top = 388
    Width = 742
    Height = 106
    Caption = 'Informaci'#243'n extra'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    object LabeledEdit16: TLabeledEdit
      Left = 17
      Top = 31
      Width = 343
      Height = 23
      EditLabel.Width = 59
      EditLabel.Height = 15
      EditLabel.Caption = 'Manual(es)'
      EditLabel.Transparent = True
      TabOrder = 0
      Text = ''
    end
    object LabeledEdit17: TLabeledEdit
      Left = 375
      Top = 31
      Width = 343
      Height = 23
      EditLabel.Width = 43
      EditLabel.Height = 15
      EditLabel.Caption = 'Mapa(s)'
      EditLabel.Transparent = True
      TabOrder = 1
      Text = ''
    end
    object LabeledEdit18: TLabeledEdit
      Left = 17
      Top = 71
      Width = 343
      Height = 23
      EditLabel.Width = 37
      EditLabel.Height = 15
      EditLabel.Caption = 'Guia(s)'
      EditLabel.Transparent = True
      TabOrder = 2
      Text = ''
    end
    object StaticText2: TStaticText
      Left = 374
      Top = 55
      Width = 41
      Height = 19
      Caption = 'Idioma'
      TabOrder = 3
    end
    object ComboBox4: TComboBox
      Left = 375
      Top = 72
      Width = 145
      Height = 23
      TabOrder = 4
    end
    object StaticText3: TStaticText
      Left = 573
      Top = 55
      Width = 28
      Height = 19
      Caption = 'Tipo'
      TabOrder = 5
    end
    object ComboBox5: TComboBox
      Left = 573
      Top = 72
      Width = 145
      Height = 23
      TabOrder = 6
    end
  end
  object Button1: TButton
    Left = 224
    Top = 507
    Width = 113
    Height = 49
    Caption = 'ACEPTAR'
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 415
    Top = 507
    Width = 113
    Height = 49
    Caption = 'CANCELAR'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 637
    Top = 507
    Width = 113
    Height = 49
    Hint = 'Borrar el juego!'
    Caption = 'BORRAR'
    TabOrder = 6
    OnClick = Button3Click
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 80
    Top = 504
  end
end
