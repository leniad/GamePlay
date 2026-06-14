unit principal;

interface
uses
  Winapi.Windows,  System.SysUtils,  Vcl.Graphics, Vcl.Forms,
  Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,pngimage, Vcl.Controls,
  System.Classes, System.ImageList, Vcl.ImgList,inifiles,dialogs, Vcl.Mask,
  Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox3: TGroupBox;
    CheckBox14: TCheckBox;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox7: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    Image2: TImage;
    Image1: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Timer2: TTimer;
    CheckBox15: TCheckBox;
    Image7: TImage;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    Image8: TImage;
    ComboBox1: TComboBox;
    RadioButton12: TRadioButton;
    CheckBox3: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox17: TCheckBox;
    RadioButton13: TRadioButton;
    CheckBox10: TCheckBox;
    CheckBox9: TCheckBox;
    GroupBox2: TGroupBox;
    RadioButton2: TRadioButton;
    RadioButton9: TRadioButton;
    GroupBox10: TGroupBox;
    CheckBox20: TCheckBox;
    CheckBox19: TCheckBox;
    GroupBox9: TGroupBox;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StringGrid1DrawCell(Sender:TObject;ACol,ARow:LongInt;Rect:TRect;State:TGridDrawState);
    procedure RadioButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioButton1Click(Sender:TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure StringGrid1KeyUp(Sender:TObject; var Key:Word;Shift:TShiftState);
    procedure CheckBox15Click(Sender:TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton9Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure RadioButton10Click(Sender: TObject);
    procedure RadioButton11Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure RadioButton12Click(Sender: TObject);
    procedure RadioButton13Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1:TForm1;
  old_game:integer;

implementation
{$R *.dfm}
uses shellapi,strutils,acercade,config,idioma_info,main,dsp_data,
     games_download,system.UITypes;

var
  image_num:integer;
  typed:string;

function juego_manual(ngame:integer):string;
begin
  juego_manual:=games_final[ngame].manual;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then juego_manual:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].manual;
  end;
end;

function juego_guia(ngame:integer):string;
begin
  juego_guia:=games_final[ngame].guia;
  if (games_final[ngame].ref[0].nref<>0) then begin
      if form1.ComboBox1.ItemIndex>0 then juego_guia:=games_final_ref[games_final[ngame].ref[form1.ComboBox1.ItemIndex-1].nref and $ffff].guia;
  end;
end;

procedure comprobar_extras(ngame:integer);
begin
  form1.image4.visible:=juego_manual(ngame)<>'';
  form1.image3.visible:=juego_guia(ngame)<>'';
  form1.image5.visible:=games_final[ngame].map<>'';
  form1.label3.Caption:=games_final[ngame].company;
  form1.label4.Caption:=games_final[ngame].year;
end;

procedure TForm1.CheckBox10Click(Sender: TObject);
begin
  main_config.descargar_extra:=checkbox10.Checked;
end;

procedure TForm1.CheckBox15Click(Sender: TObject);
begin
  checkbox15.enabled;
  case main_config.motor of
    MMSDOS:groupbox9.visible:=checkbox15.Checked;
    MAPPLE2:groupbox2.visible:=checkbox15.Checked;
    MAMIGA:groupbox10.visible:=checkbox15.Checked;
  end;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
  mostrar_juegos;
end;

procedure TForm1.CheckBox9Click(Sender: TObject);
begin
  main_config.mostrar_funcionan:=checkbox9.Checked;
  mostrar_juegos;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  timer1.Enabled:=false;
  timer1.Enabled:=true;
  image_num:=-1;
  Timer1Timer(nil);
  StringGrid1.Refresh;
  image7.visible:=juego_setup(numero_juego)<>'';
  if form1.Visible then groupbox7.SetFocus;
  comprobar_extras(numero_juego);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  form_principal_close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  form_principal_create;
end;

procedure TForm1.FormShow(Sender: TObject);
var
  f:integer;
begin
  f:=(screen.Width-form1.Width) div 2;
  if f>0 then form1.Left:=f;
  f:=(screen.Height-form1.Height) div 2;
  if f>0 then form1.Top:=f;
  //Meto los juegos
  pillar_juegos;
  //Los ordeno...
  ordena_juegos;
  mostrar_juegos;
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  form4.showmodal;
  mostrar_juegos;
end;

procedure TForm1.Image3Click(Sender:TObject);
begin
abrir_ficheros_separados(juego_guia(numero_juego),main_config.dir_guias);
end;

procedure TForm1.Image4Click(Sender:TObject);
begin
abrir_ficheros_separados(juego_manual(numero_juego),main_config.dir_manual);
end;

procedure TForm1.Image5Click(Sender:TObject);
begin
abrir_ficheros_separados(games_final[numero_juego].map,main_config.dir_mapas);
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
  form3.showmodal;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.Image7Click(Sender: TObject);
begin
  ejecutar_setup:=true;
  form_principal_execute;
  ejecutar_setup:=false;
  if form1.Visible then groupbox7.SetFocus;
end;

procedure TForm1.Image8Click(Sender: TObject);
var
  ngame:integer;
begin
  ngame:=numero_juego;
  if ngame<>-1 then descargar_juego_sin_confirmar(ngame);
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  main_config.motor:=MMSDOS;
  checkbox3.Enabled:=true;
  checkbox16.Enabled:=true;
  checkbox6.Enabled:=true;
  checkbox4.Enabled:=true;
  checkbox5.Enabled:=true;
  checkbox7.Enabled:=true;
  checkbox8.Enabled:=true;
  checkbox17.Enabled:=true;
  checkbox2.Enabled:=true;
  checkbox15.Enabled:=true;
  checkbox10.Enabled:=true;
  groupbox9.visible:=form1.checkbox15.Checked;
  groupbox2.visible:=false;
  groupbox10.visible:=false;
  if total_juegos=0 then exit;
  stringgrid1.Row:=0;
  mostrar_juegos;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  main_config.apple2_joy:=false;
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
begin
  main_config.motor:=MSCUMM;
  combobox1.Visible:=false;
  checkbox3.Enabled:=false;
  checkbox16.Enabled:=false;
  checkbox6.Enabled:=false;
  checkbox4.Enabled:=false;
  checkbox5.Enabled:=false;
  checkbox7.Enabled:=false;
  checkbox8.Enabled:=false;
  checkbox17.Enabled:=false;
  checkbox2.Enabled:=false;
  checkbox15.Enabled:=true;
  checkbox10.Enabled:=true;
  groupbox9.visible:=false;
  groupbox2.visible:=false;
  groupbox10.visible:=false;
  if total_juegos=0 then exit;
  stringgrid1.Row:=0;
  mostrar_juegos;
  comprobar_scummvm;
end;

procedure TForm1.RadioButton4Click(Sender: TObject);
begin
  main_config.motor:=MDSP;
  combobox1.Visible:=false;
  checkbox3.Enabled:=false;
  checkbox16.Enabled:=false;
  checkbox6.Enabled:=false;
  checkbox4.Enabled:=false;
  checkbox5.Enabled:=false;
  checkbox7.Enabled:=false;
  checkbox8.Enabled:=false;
  checkbox17.Enabled:=false;
  checkbox2.Enabled:=false;
  checkbox15.Enabled:=false;
  checkbox10.Enabled:=false;
  groupbox9.visible:=false;
  groupbox2.visible:=false;
  groupbox10.visible:=false;
  if total_juegos=0 then exit;
  stringgrid1.Row:=0;
  mostrar_juegos;
end;

procedure TForm1.RadioButton5Click(Sender: TObject);
begin
  main_config.motor:=MAPPLE2;
  combobox1.Visible:=false;
  checkbox3.Enabled:=true;
  checkbox16.Enabled:=true;
  checkbox6.Enabled:=true;
  checkbox4.Enabled:=true;
  checkbox5.Enabled:=true;
  checkbox7.Enabled:=true;
  checkbox8.Enabled:=true;
  checkbox17.Enabled:=true;
  checkbox2.Enabled:=true;
  checkbox15.Enabled:=true;
  checkbox10.Enabled:=true;
  groupbox9.visible:=false;
  groupbox2.visible:=checkbox15.Checked;
  groupbox10.visible:=false;
  if total_juegos=0 then exit;
  stringgrid1.Row:=0;
  mostrar_juegos;
end;

procedure TForm1.RadioButton6Click(Sender: TObject);
begin
  main_config.motor:=MATARI8;
  combobox1.Visible:=false;
  checkbox3.Enabled:=true;
  checkbox16.Enabled:=true;
  checkbox6.Enabled:=true;
  checkbox4.Enabled:=true;
  checkbox5.Enabled:=true;
  checkbox7.Enabled:=true;
  checkbox8.Enabled:=true;
  checkbox17.Enabled:=true;
  checkbox2.Enabled:=true;
  checkbox15.Enabled:=false;
  checkbox10.Enabled:=true;
  groupbox9.visible:=false;
  groupbox2.visible:=false;
  groupbox10.visible:=false;
  if total_juegos=0 then exit;
  stringgrid1.Row:=0;
  mostrar_juegos;
end;

procedure TForm1.RadioButton7Click(Sender: TObject);
begin
  main_config.motor_msdos:=0;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.RadioButton8Click(Sender: TObject);
begin
  main_config.motor_msdos:=1;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.RadioButton9Click(Sender: TObject);
begin
  main_config.apple2_joy:=true;
end;

procedure TForm1.RadioButton10Click(Sender: TObject);
begin
  main_config.motor:=MAMIGA;
  combobox1.Visible:=false;
  checkbox3.Enabled:=true;
  checkbox16.Enabled:=true;
  checkbox6.Enabled:=true;
  checkbox4.Enabled:=true;
  checkbox5.Enabled:=true;
  checkbox7.Enabled:=true;
  checkbox8.Enabled:=true;
  checkbox17.Enabled:=true;
  checkbox2.Enabled:=true;
  checkbox15.Enabled:=true;
  checkbox10.Enabled:=true;
  groupbox9.visible:=false;
  groupbox2.visible:=false;
  groupbox10.visible:=checkbox15.Checked;
  if total_juegos=0 then exit;
  stringgrid1.Row:=0;
  mostrar_juegos;
end;

procedure TForm1.RadioButton11Click(Sender: TObject);
begin
  main_config.motor:=MATARIST;
  combobox1.Visible:=false;
  checkbox3.Enabled:=true;
  checkbox16.Enabled:=true;
  checkbox6.Enabled:=true;
  checkbox4.Enabled:=true;
  checkbox5.Enabled:=true;
  checkbox7.Enabled:=true;
  checkbox8.Enabled:=true;
  checkbox17.Enabled:=true;
  checkbox2.Enabled:=true;
  checkbox15.Enabled:=false;
  checkbox10.Enabled:=true;
  groupbox9.visible:=false;
  groupbox2.visible:=false;
  groupbox10.visible:=false;
  if total_juegos=0 then exit;
  stringgrid1.row:=0;
  mostrar_juegos;
end;

procedure TForm1.RadioButton12Click(Sender: TObject);
begin
  main_config.motor:=MWIN98;
  combobox1.Visible:=false;
  checkbox3.Enabled:=true;
  checkbox16.Enabled:=true;
  checkbox6.Enabled:=true;
  checkbox4.Enabled:=true;
  checkbox5.Enabled:=true;
  checkbox7.Enabled:=true;
  checkbox8.Enabled:=true;
  checkbox17.Enabled:=true;
  checkbox2.Enabled:=true;
  checkbox15.Enabled:=false;
  checkbox10.Enabled:=true;
  groupbox9.visible:=false;
  groupbox2.visible:=false;
  groupbox10.visible:=false;
  if total_juegos=0 then exit;
  stringgrid1.row:=0;
  mostrar_juegos;
  comprobar_win98;
end;

procedure TForm1.RadioButton13Click(Sender: TObject);
begin
  main_config.motor:=MWIN3;
  combobox1.Visible:=false;
  checkbox3.Enabled:=true;
  checkbox16.Enabled:=true;
  checkbox6.Enabled:=true;
  checkbox4.Enabled:=true;
  checkbox5.Enabled:=true;
  checkbox7.Enabled:=true;
  checkbox8.Enabled:=true;
  checkbox17.Enabled:=true;
  checkbox2.Enabled:=true;
  checkbox15.Enabled:=false;
  checkbox10.Enabled:=true;
  groupbox9.visible:=false;
  groupbox2.visible:=false;
  groupbox10.visible:=false;
  if total_juegos=0 then exit;
  stringgrid1.row:=0;
  mostrar_juegos;
  comprobar_win3;
end;

procedure TForm1.StringGrid1Click(Sender: TObject);
var
  image_string:string;
  ngame,f,cantidad:integer;

procedure poner_en_blanco;
var
  r:trect;
begin
  r.top:=0;
  r.Left:=image1.width;
  r.Right:=0;
  r.Bottom:=image1.height;
  image1.Picture:=nil;
  image1.Canvas.Brush.Color:=clBlack;
  image1.Canvas.FillRect(r);
end;

begin
  timer1.Enabled:=false;
  ngame:=numero_juego;
  if ((total_juegos=0) or (ngame=-1)) then begin
      poner_en_blanco;
      exit;
  end;
  if (old_game<>ngame) then begin
    image7.visible:=false;
    if ((main_config.motor=MMSDOS) or (main_config.motor=MSCUMM) or ((main_config.motor=MWIN98))) then begin
        combobox1.Visible:=false;
        if (games_final[ngame].ref[0].nref<>0) then begin
          combobox1.Items.Clear;
          combobox1.Items.Add(games_final_ref[games_final[ngame].ref[0].nref and $ffff].nombre_original);
          combobox1.ItemIndex:=0;
          cantidad:=0;
          for f:=0 to NREFS do begin
            if (games_final[ngame].ref[f].nref<>0) then begin
              if (((main_config.motor=MSCUMM) and ((games_final[ngame].ref[f].nref and NO_SCUMM)=0)) or (main_config.motor=MMSDOS) or (main_config.motor=MWIN98)) then begin
                combobox1.Items.Add(games_final_ref[games_final[ngame].ref[f].nref and $ffff].nombre);
                cantidad:=cantidad+1;
                if (games_final[ngame].ref[f].nref and $ff0000)<>0 then
                  case (games_final[ngame].ref[f].nref and $ff0000) of
                    ESP:if idioma_ind=0 then combobox1.ItemIndex:=cantidad;
                    ALE:if idioma_ind=2 then combobox1.ItemIndex:=cantidad;
                    FRA:if idioma_ind=3 then combobox1.ItemIndex:=cantidad;
                    ITA:if idioma_ind=4 then combobox1.ItemIndex:=cantidad;
                  end;
              end;
            end;
          end;
          if cantidad<>0 then combobox1.Visible:=true;
        end;
        if (main_config.motor=MMSDOS) then image7.visible:=juego_setup(ngame)<>'';
    end;
    comprobar_extras(ngame);
  end;
  old_game:=ngame;
  //Importante el orden!!
  if main_config.motor=MDSP then begin
      //Imagenes DSP
      image_string:=dir_dsp+'preview\'+games_final[ngame].dir+'.png';
      if FileExists(image_string) then begin
        if games_final[ngame].mal then PNGBlurEnImage(Image1,image_string) //oscurecerbitmap(Image1,image_string,IMAGE_FADE)
          else Image1.Picture.LoadFromFile(image_string)
      end else poner_en_blanco;
  end else begin
      //Muestro las imagenes si las hay y pongo en marcha el timer
      image_string:=main_config.dir_imgs+juego_imagen(ngame)+'_000.png';
      if FileExists(image_string) then begin
        if juego_mal(ngame) then PNGBlurEnImage(Image1,image_string) //oscurecerbitmap(Image1,image_string,IMAGE_FADE)
          else Image1.Picture.LoadFromFile(image_string);
        image_num:=0;
        timer1.Enabled:=true;
      end else poner_en_blanco;
  end;
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
  form_principal_execute;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.StringGrid1DrawCell(Sender:TObject;ACol,ARow:LongInt;Rect:TRect;State:TGridDrawState);
const
  SelectedColor=$ffffe8;
  BadColor=$e8e8e8;
  ScummColor=$ffe8e8;
var
  ngame:integer;
begin
  ngame:=numero_juego;
  if ngame=-1 then exit;
  if ((state=[gdSelected,gdFocused]) or (state=[gdSelected])) then begin
    image8.Visible:=false;
    with TStringGrid(Sender),Canvas do begin
      font.Color:=0;
      if juego_mal(ngame) then begin
        Brush.Color:=BadColor;
        image8.Visible:=true;
      end else if (games_final[ngame].motor=MSCUMM) then Brush.Color:=ScummColor
          else Brush.Color:=SelectedColor;
      FillRect(Rect);
      TextRect(Rect,Rect.Left+2,Rect.Top+2,Cells[aCol,aRow]);
    end;
  end;
end;

procedure TForm1.StringGrid1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  f:integer;
  temps:string;
begin
case key of
  13:if not(estoy_ejecutando) then StringGrid1DblClick(nil)
        else estoy_ejecutando:=false;
  48..57,65..90:begin
            typed:=typed+lowercase(char(key));
            timer2.Enabled:=false;
            timer2.Enabled:=true;
            for f:=1 to (stringgrid1.RowCount-1) do begin
              temps:=ansilowercase(copy(stringgrid1.Cells[0,f],0,length(typed)));
              if typed=temps then begin
                stringgrid1.row:=f;
                if (f-10)<1 then stringgrid1.TopRow:=1
                  else stringgrid1.TopRow:=f-10;
                StringGrid1Click(nil);
                break;
              end;
            end;
         end;
end;
end;

procedure TForm1.Timer1Timer(Sender:TObject);
function calc_image_num(number:integer):string;
begin
  if number<10 then calc_image_num:='00'+inttostr(number)
    else if number<100 then calc_image_num:='0'+inttostr(number)
      else calc_image_num:=inttostr(number);
end;
var
  ngame:integer;
  image_string:string;
begin
  ngame:=numero_juego;
  image_num:=image_num+1;
  image_string:=main_config.dir_imgs+juego_imagen(ngame)+'_'+calc_image_num(image_num)+'.png';
  if not(FileExists(image_string)) then begin
    image_num:=0;
    image_string:=main_config.dir_imgs+juego_imagen(ngame)+'_000.png';
  end;
  if FileExists(image_string) then begin
    if juego_mal(ngame) then PNGBlurEnImage(Image1,image_string) //oscurecerbitmap(Image1,image_string,IMAGE_FADE)
        else Image1.Picture.LoadFromFile(image_string);
  end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  timer2.Enabled:=false;
  typed:='';
end;

end.
