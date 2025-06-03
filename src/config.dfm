object Form4: TForm4
  Left = 662
  Top = 376
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Configuraci'#243'n Avanzada'
  ClientHeight = 476
  ClientWidth = 1169
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesigned
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 591
    Top = 8
    Width = 577
    Height = 150
    Caption = 'Fichero configuraci'#243'n'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Button2: TButton
      Left = 532
      Top = 28
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 532
      Top = 75
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 4
      OnClick = Button3Click
    end
    object LabeledEdit5: TLabeledEdit
      Left = 10
      Top = 77
      Width = 517
      Height = 23
      EditLabel.Width = 51
      EditLabel.Height = 15
      EditLabel.Caption = 'DosBox-X'
      TabOrder = 1
      Text = ''
    end
    object LabeledEdit4: TLabeledEdit
      Left = 10
      Top = 30
      Width = 516
      Height = 23
      EditLabel.Width = 39
      EditLabel.Height = 15
      EditLabel.Caption = 'DosBox'
      TabOrder = 0
      Text = ''
    end
    object LabeledEdit12: TLabeledEdit
      Left = 10
      Top = 120
      Width = 517
      Height = 23
      EditLabel.Width = 59
      EditLabel.Height = 15
      EditLabel.Caption = 'ScummVM'
      TabOrder = 2
      Text = ''
    end
    object Button15: TButton
      Left = 532
      Top = 119
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 5
      OnClick = Button15Click
    end
  end
  object Button1: TButton
    Left = 680
    Top = 391
    Width = 121
    Height = 49
    Caption = 'ACEPTAR'
    TabOrder = 15
    OnClick = Button1Click
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 8
    Width = 577
    Height = 158
    Caption = 'Ejecutables'
    TabOrder = 0
    object LabeledEdit1: TLabeledEdit
      Left = 19
      Top = 30
      Width = 514
      Height = 23
      EditLabel.Width = 39
      EditLabel.Height = 15
      EditLabel.Caption = 'DosBox'
      TabOrder = 0
      Text = ''
    end
    object LabeledEdit2: TLabeledEdit
      Left = 19
      Top = 75
      Width = 514
      Height = 23
      EditLabel.Width = 51
      EditLabel.Height = 15
      EditLabel.Caption = 'DosBox-X'
      TabOrder = 1
      Text = ''
    end
    object LabeledEdit3: TLabeledEdit
      Left = 19
      Top = 120
      Width = 514
      Height = 23
      EditLabel.Width = 59
      EditLabel.Height = 15
      EditLabel.Caption = 'ScummVM'
      TabOrder = 2
      Text = ''
    end
    object Button4: TButton
      Left = 539
      Top = 29
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 3
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 539
      Top = 74
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 4
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 539
      Top = 119
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 5
      OnClick = Button6Click
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 591
    Top = 164
    Width = 294
    Height = 90
    Caption = 'Idioma'
    TabOrder = 3
  end
  object RadioButton1: TRadioButton
    Left = 648
    Top = 187
    Width = 89
    Height = 15
    Caption = 'Auto'
    TabOrder = 4
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 648
    Top = 208
    Width = 89
    Height = 15
    Caption = 'Espa'#241'ol'
    TabOrder = 5
    OnClick = RadioButton2Click
  end
  object RadioButton3: TRadioButton
    Left = 648
    Top = 229
    Width = 89
    Height = 15
    Caption = 'English'
    TabOrder = 6
    OnClick = RadioButton3Click
  end
  object RadioButton4: TRadioButton
    Left = 752
    Top = 187
    Width = 89
    Height = 15
    Caption = 'Deutsch'
    TabOrder = 7
    OnClick = RadioButton4Click
  end
  object RadioButton5: TRadioButton
    Left = 752
    Top = 208
    Width = 81
    Height = 15
    Caption = 'Fran'#231'ais'
    TabOrder = 8
    OnClick = RadioButton5Click
  end
  object RadioButton6: TRadioButton
    Left = 752
    Top = 229
    Width = 81
    Height = 15
    Caption = 'Italiano'
    TabOrder = 9
    OnClick = RadioButton6Click
  end
  object Button7: TButton
    Left = 952
    Top = 391
    Width = 121
    Height = 49
    Caption = 'CANCELAR'
    TabOrder = 16
    OnClick = Button7Click
  end
  object GroupBox3: TGroupBox
    Left = 8
    Top = 172
    Width = 577
    Height = 292
    Caption = 'Directorios Base'
    TabOrder = 2
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
    end
    object LabeledEdit7: TLabeledEdit
      Left = 19
      Top = 75
      Width = 514
      Height = 23
      EditLabel.Width = 35
      EditLabel.Height = 15
      EditLabel.Caption = 'Mapas'
      ReadOnly = True
      TabOrder = 1
      Text = ''
    end
    object LabeledEdit8: TLabeledEdit
      Left = 19
      Top = 120
      Width = 514
      Height = 23
      EditLabel.Width = 29
      EditLabel.Height = 15
      EditLabel.Caption = 'Guias'
      ReadOnly = True
      TabOrder = 2
      Text = ''
    end
    object Button8: TButton
      Left = 539
      Top = 30
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 6
      OnClick = Button8Click
    end
    object Button9: TButton
      Left = 539
      Top = 79
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 7
      OnClick = Button9Click
    end
    object Button10: TButton
      Left = 539
      Top = 125
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 8
      OnClick = Button10Click
    end
    object Button11: TButton
      Left = 539
      Top = 166
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 9
      OnClick = Button11Click
    end
    object LabeledEdit9: TLabeledEdit
      Left = 19
      Top = 165
      Width = 514
      Height = 23
      EditLabel.Width = 22
      EditLabel.Height = 15
      EditLabel.Caption = 'ZIPs'
      ReadOnly = True
      TabOrder = 3
      Text = ''
    end
    object Button12: TButton
      Left = 539
      Top = 206
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 10
      OnClick = Button12Click
    end
    object LabeledEdit10: TLabeledEdit
      Left = 19
      Top = 210
      Width = 514
      Height = 23
      EditLabel.Width = 51
      EditLabel.Height = 15
      EditLabel.Caption = 'Imagenes'
      ReadOnly = True
      TabOrder = 4
      Text = ''
    end
    object Button13: TButton
      Left = 539
      Top = 253
      Width = 33
      Height = 25
      Caption = 'Abrir'
      TabOrder = 11
      OnClick = Button13Click
    end
    object LabeledEdit11: TLabeledEdit
      Left = 19
      Top = 255
      Width = 514
      Height = 23
      EditLabel.Width = 30
      EditLabel.Height = 15
      EditLabel.Caption = 'MT32'
      ReadOnly = True
      TabOrder = 5
      Text = ''
    end
  end
  object CheckBox10: TCheckBox
    Left = 910
    Top = 172
    Width = 195
    Height = 17
    Caption = 'Leer valores de los juegos fijos'
    TabOrder = 10
    OnClick = CheckBox10Click
  end
  object CheckBox11: TCheckBox
    Left = 910
    Top = 207
    Width = 195
    Height = 17
    Caption = 'Mostrar todos los juegos'
    TabOrder = 11
    OnClick = CheckBox11Click
  end
  object Button14: TButton
    Left = 816
    Top = 324
    Width = 121
    Height = 49
    BiDiMode = bdLeftToRight
    Caption = 'VALORES'#13' POR DEFECTO'
    ParentBiDiMode = False
    TabOrder = 14
    WordWrap = True
    OnClick = Button14Click
  end
  object CheckBox1: TCheckBox
    Left = 910
    Top = 230
    Width = 195
    Height = 40
    Caption = 'Mostrar solo los juegos que no funcionan'
    TabOrder = 12
    WordWrap = True
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 910
    Top = 267
    Width = 195
    Height = 40
    Caption = 'Mostrar solo juegos a'#241'adidos'
    TabOrder = 13
    WordWrap = True
    OnClick = CheckBox2Click
  end
  object OpenDialog1: TOpenDialog
    Left = 628
    Top = 301
  end
end
