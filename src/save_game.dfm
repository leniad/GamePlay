object Form2: TForm2
  Left = 581
  Top = 196
  BiDiMode = bdLeftToRight
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsSingle
  Caption = 'A'#241'adir Juego'
  ClientHeight = 664
  ClientWidth = 772
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
  object Button1: TButton
    Left = 177
    Top = 600
    Width = 113
    Height = 49
    Caption = 'ACEPTAR'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 429
    Top = 600
    Width = 113
    Height = 49
    Caption = 'CANCELAR'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 637
    Top = 600
    Width = 113
    Height = 49
    Hint = 'Borrar el juego!'
    Caption = 'BORRAR'
    TabOrder = 2
    OnClick = Button3Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 769
    Height = 585
    ActivePage = TabSheet6
    TabOrder = 3
    StyleName = 'Windows'
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'MSDOS'
      object GroupBox10: TGroupBox
        Left = 3
        Top = 435
        Width = 742
        Height = 115
        Caption = 'DOSBOX'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        StyleName = 'Windows'
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
          StyleName = 'Windows'
        end
        object StaticText1: TStaticText
          Left = 123
          Top = 16
          Width = 88
          Height = 19
          Caption = 'Tipo Ordenador'
          TabOrder = 2
          StyleName = 'Windows'
        end
        object ComboBox1: TComboBox
          Left = 123
          Top = 32
          Width = 126
          Height = 23
          TabOrder = 1
          StyleName = 'Windows'
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
          StyleName = 'Windows'
        end
        object CheckBox1: TCheckBox
          Left = 579
          Top = 30
          Width = 97
          Height = 25
          Caption = 'Activar GUS'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
          StyleName = 'Windows'
        end
        object LabeledEdit13: TLabeledEdit
          Left = 382
          Top = 32
          Width = 167
          Height = 23
          EditLabel.Width = 114
          EditLabel.Height = 15
          EditLabel.Caption = 'Fichero mapa teclado'
          EditLabel.Transparent = True
          TabOrder = 5
          Text = ''
          StyleName = 'Windows'
        end
        object LabeledEdit14: TLabeledEdit
          Left = 16
          Top = 78
          Width = 355
          Height = 23
          EditLabel.Width = 133
          EditLabel.Height = 15
          EditLabel.Caption = 'Par'#225'metros extra DOSBox'
          EditLabel.Transparent = True
          TabOrder = 6
          Text = ''
          StyleName = 'Windows'
        end
        object CheckBox2: TCheckBox
          Left = 382
          Top = 76
          Width = 185
          Height = 25
          Caption = 'Compatible con ScummVM'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 7
          StyleName = 'Windows'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'ScummVM'
      ImageIndex = 1
    end
    object TabSheet3: TTabSheet
      Caption = 'Apple II'
      ImageIndex = 2
    end
    object TabSheet4: TTabSheet
      Caption = 'Atari 800'
      ImageIndex = 3
    end
    object TabSheet5: TTabSheet
      Caption = 'Amiga'
      ImageIndex = 4
    end
    object TabSheet6: TTabSheet
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Caption = 'Atari ST'
      ImageIndex = 5
    end
  end
  object GroupBox1: TGroupBox
    Left = 22
    Top = 40
    Width = 742
    Height = 157
    BiDiMode = bdLeftToRight
    Caption = 'Juego'
    Color = clDefault
    ParentBackground = False
    ParentBiDiMode = False
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
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
      Width = 374
      Height = 23
      EditLabel.Width = 100
      EditLabel.Height = 15
      EditLabel.Caption = 'Nombre Completo'
      EditLabel.Transparent = True
      TabOrder = 0
      Text = ''
      StyleName = 'Windows'
    end
    object LabeledEdit2: TLabeledEdit
      Left = 16
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
      StyleName = 'Windows'
    end
    object LabeledEdit3: TLabeledEdit
      Left = 123
      Top = 80
      Width = 145
      Height = 23
      EditLabel.Width = 55
      EditLabel.Height = 15
      EditLabel.Caption = 'Compa'#241#237'a'
      EditLabel.Transparent = True
      TabOrder = 2
      Text = ''
      StyleName = 'Windows'
    end
    object LabeledEdit4: TLabeledEdit
      Left = 323
      Top = 122
      Width = 166
      Height = 23
      EditLabel.Width = 115
      EditLabel.Height = 15
      EditLabel.Caption = 'Nombre de la imagen'
      EditLabel.Transparent = True
      TabOrder = 3
      Text = ''
      StyleName = 'Windows'
      OnKeyUp = LabeledEdit4KeyUp
    end
    object CheckBox4: TCheckBox
      Left = 17
      Top = 118
      Width = 252
      Height = 27
      Caption = 'Mostrar Juego'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 4
      StyleName = 'Windows'
    end
  end
  object GroupBox3: TGroupBox
    Left = 22
    Top = 203
    Width = 742
    Height = 113
    Caption = 'Programa'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    StyleName = 'Windows'
    object StaticText5: TStaticText
      Left = 16
      Top = 56
      Width = 31
      Height = 19
      Caption = 'ROM'
      TabOrder = 12
      StyleName = 'Windows'
    end
    object LabeledEdit5: TLabeledEdit
      Left = 178
      Top = 32
      Width = 153
      Height = 23
      EditLabel.Width = 54
      EditLabel.Height = 15
      EditLabel.Caption = 'Ejecutable'
      EditLabel.Transparent = True
      TabOrder = 1
      Text = ''
      StyleName = 'Windows'
      OnKeyUp = LabeledEdit5KeyUp
    end
    object LabeledEdit6: TLabeledEdit
      Left = 340
      Top = 32
      Width = 110
      Height = 23
      EditLabel.Width = 60
      EditLabel.Height = 15
      EditLabel.Caption = 'Par'#225'metros'
      EditLabel.Transparent = True
      TabOrder = 2
      Text = ''
      StyleName = 'Windows'
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
      StyleName = 'Windows'
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
      StyleName = 'Windows'
    end
    object LabeledEdit9: TLabeledEdit
      Left = 17
      Top = 32
      Width = 160
      Height = 23
      EditLabel.Width = 52
      EditLabel.Height = 15
      EditLabel.Caption = 'Directorio'
      EditLabel.Transparent = True
      TabOrder = 0
      Text = ''
      StyleName = 'Windows'
    end
    object LabeledEdit10: TLabeledEdit
      Left = 456
      Top = 32
      Width = 157
      Height = 23
      EditLabel.Width = 81
      EditLabel.Height = 15
      EditLabel.Caption = 'Imagen Disco 2'
      EditLabel.Transparent = True
      TabOrder = 3
      Text = ''
      StyleName = 'Windows'
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
      StyleName = 'Windows'
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
      StyleName = 'Windows'
    end
    object CheckBox3: TCheckBox
      Left = 644
      Top = 28
      Width = 95
      Height = 27
      Caption = 'Loadfix'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 8
      StyleName = 'Windows'
    end
    object StaticText4: TStaticText
      Left = 17
      Top = 56
      Width = 44
      Height = 19
      Caption = 'Chipset'
      TabOrder = 10
      StyleName = 'Windows'
    end
    object ComboBox2: TComboBox
      Left = 17
      Top = 74
      Width = 126
      Height = 23
      TabOrder = 9
      StyleName = 'Windows'
    end
    object ComboBox3: TComboBox
      Left = 16
      Top = 74
      Width = 126
      Height = 23
      TabOrder = 11
      StyleName = 'Windows'
    end
    object StaticText6: TStaticText
      Left = 17
      Top = 56
      Width = 38
      Height = 19
      Caption = 'Model'
      TabOrder = 14
      StyleName = 'Windows'
    end
    object ComboBox6: TComboBox
      Left = 16
      Top = 74
      Width = 126
      Height = 23
      TabOrder = 13
      StyleName = 'Windows'
    end
    object StaticText7: TStaticText
      Left = 162
      Top = 56
      Width = 107
      Height = 19
      Caption = 'Velocidad Disketera'
      TabOrder = 16
      StyleName = 'Windows'
    end
    object ComboBox7: TComboBox
      Left = 160
      Top = 74
      Width = 126
      Height = 23
      TabOrder = 15
      StyleName = 'Windows'
    end
  end
  object GroupBox12: TGroupBox
    Left = 22
    Top = 322
    Width = 742
    Height = 141
    Caption = 'Informaci'#243'n extra'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    StyleName = 'Windows'
    object LabeledEdit16: TLabeledEdit
      Left = 16
      Top = 31
      Width = 343
      Height = 23
      EditLabel.Width = 59
      EditLabel.Height = 15
      EditLabel.Caption = 'Manual(es)'
      EditLabel.Transparent = True
      TabOrder = 0
      Text = ''
      StyleName = 'Windows'
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
      StyleName = 'Windows'
    end
    object LabeledEdit18: TLabeledEdit
      Left = 16
      Top = 71
      Width = 343
      Height = 23
      EditLabel.Width = 37
      EditLabel.Height = 15
      EditLabel.Caption = 'Guia(s)'
      EditLabel.Transparent = True
      TabOrder = 2
      Text = ''
      StyleName = 'Windows'
    end
    object StaticText2: TStaticText
      Left = 374
      Top = 55
      Width = 41
      Height = 19
      Caption = 'Idioma'
      TabOrder = 3
      StyleName = 'Windows'
    end
    object ComboBox4: TComboBox
      Left = 375
      Top = 71
      Width = 145
      Height = 23
      TabOrder = 4
      StyleName = 'Windows'
    end
    object StaticText3: TStaticText
      Left = 573
      Top = 55
      Width = 28
      Height = 19
      Caption = 'Tipo'
      TabOrder = 5
      StyleName = 'Windows'
    end
    object ComboBox5: TComboBox
      Left = 573
      Top = 71
      Width = 145
      Height = 23
      TabOrder = 6
      StyleName = 'Windows'
    end
    object LabeledEdit15: TLabeledEdit
      Left = 16
      Top = 112
      Width = 343
      Height = 23
      EditLabel.Width = 165
      EditLabel.Height = 15
      EditLabel.Caption = 'Mensaje de informaci'#243'n/ayuda'
      EditLabel.Transparent = True
      TabOrder = 7
      Text = ''
      StyleName = 'Windows'
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 16
    Top = 600
  end
end
