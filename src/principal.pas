unit principal;

interface
uses
  Winapi.Windows,  System.SysUtils,  Vcl.Graphics, Vcl.Forms,
  Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,pngimage, Vcl.Controls,
  System.Classes, System.ImageList, Vcl.ImgList,inifiles,dialogs, Vcl.Mask;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    GroupBox5: TGroupBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
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
    GroupBox8: TGroupBox;
    Button1: TButton;
    Button2: TButton;
    Image2: TImage;
    Image1: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Timer2: TTimer;
    GroupBox9: TGroupBox;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    CheckBox15: TCheckBox;
    CheckBox18: TCheckBox;
    GroupBox2: TGroupBox;
    RadioButton2: TRadioButton;
    RadioButton9: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StringGrid1DrawCell(Sender:TObject;ACol,ARow:LongInt;Rect:TRect;State:TGridDrawState);
    procedure RadioButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RadioButton1Click(Sender:TObject);
    procedure Button1Click(Sender:TObject);
    procedure Button2Click(Sender:TObject);
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1:TForm1;

implementation
{$R *.dfm}
uses shellapi,strutils,save_game,acercade,config,idioma_info,main,dsp_data;

var
  image_num:integer;
  typed:string;

procedure TForm1.Button1Click(Sender: TObject);
begin
  juego_editado:=total_juegos;
  estoy_anadiendo:=true;
  form2.showmodal;
  ordena_juegos;
  mostrar_juegos;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  juego_editado:=numero_juego;
  if juego_editado=-1 then exit;
  estoy_anadiendo:=false;
  form2.showmodal;
  ordena_juegos;
  mostrar_juegos;
end;

procedure TForm1.CheckBox15Click(Sender: TObject);
begin
  groupbox8.visible:=checkbox15.Checked;
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
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  form4.showmodal;
  pillar_juegos;
  ordena_juegos;
  mostrar_juegos;
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
abrir_ficheros_separados(games_final[numero_juego].guia,main_config.dir_guias);
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
  abrir_ficheros_separados(games_final[numero_juego].manual,main_config.dir_manual);
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
abrir_ficheros_separados(games_final[numero_juego].map,main_config.dir_mapas);
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
  form3.showmodal;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure opciones_avanzadas_msdos;
begin
  form1.checkbox15.Enabled:=true;
  form1.button1.Visible:=true;
  form1.button2.Visible:=true;
  form1.groupbox2.visible:=false;
  form1.groupbox8.visible:=form1.checkbox15.Checked;
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  main_config.motor:=MMSDOS;
  checkbox9.Enabled:=true;
  checkbox10.Enabled:=true;
  checkbox11.Enabled:=true;
  checkbox12.Enabled:=true;
  checkbox13.Enabled:=true;
  checkbox18.Enabled:=true;
  checkbox3.Enabled:=true;
  checkbox16.Enabled:=true;
  checkbox6.Enabled:=true;
  checkbox4.Enabled:=true;
  checkbox5.Enabled:=true;
  checkbox7.Enabled:=true;
  checkbox8.Enabled:=true;
  checkbox17.Enabled:=true;
  checkbox2.Enabled:=true;
  groupbox9.visible:=true;
  form1.groupbox8.Height:=148;
  opciones_avanzadas_msdos;
  if stringgrid1.Cells[1,0]<>'' then button2.Enabled:=not(games_final[strtoint(stringgrid1.Cells[1,0])].interno) or main_config.leer_fijos;
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
  checkbox9.Enabled:=true;
  checkbox10.Enabled:=true;
  checkbox11.Enabled:=true;
  checkbox12.Enabled:=true;
  checkbox13.Enabled:=true;
  checkbox18.Enabled:=true;
  checkbox3.Enabled:=false;
  checkbox16.Enabled:=false;
  checkbox6.Enabled:=false;
  checkbox4.Enabled:=false;
  checkbox5.Enabled:=false;
  checkbox7.Enabled:=false;
  checkbox8.Enabled:=false;
  checkbox17.Enabled:=false;
  checkbox2.Enabled:=false;
  groupbox9.visible:=false;
  form1.groupbox8.Height:=90;
  opciones_avanzadas_msdos;
  if stringgrid1.Cells[1,0]<>'' then button2.Enabled:=not(games_final[strtoint(stringgrid1.Cells[1,0])].interno) or main_config.leer_fijos;
  if total_juegos=0 then exit;
  stringgrid1.Row:=0;
  mostrar_juegos;
end;

procedure TForm1.RadioButton4Click(Sender: TObject);
begin
  main_config.motor:=MDSP;
  checkbox9.Enabled:=false;
  checkbox10.Enabled:=false;
  checkbox11.Enabled:=false;
  checkbox12.Enabled:=false;
  checkbox13.Enabled:=false;
  checkbox18.Enabled:=false;
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
  groupbox8.visible:=false;
  if total_juegos=0 then exit;
  stringgrid1.Row:=0;
  mostrar_juegos;
end;

procedure TForm1.RadioButton5Click(Sender: TObject);
begin
  main_config.motor:=MAPPLE2;
  checkbox9.Enabled:=false;
  checkbox10.Enabled:=false;
  checkbox11.Enabled:=false;
  checkbox12.Enabled:=false;
  checkbox13.Enabled:=false;
  checkbox18.Enabled:=false;
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
  button1.Visible:=false;
  button2.Visible:=false;
  form1.groupbox8.Height:=90;
  groupbox9.visible:=false;
  groupbox2.visible:=true;
  groupbox8.visible:=checkbox15.Checked;
  if total_juegos=0 then exit;
  stringgrid1.Row:=0;
  mostrar_juegos;
end;

procedure TForm1.RadioButton6Click(Sender: TObject);
begin
  main_config.motor:=MATARI8;
  form1.checkbox9.Enabled:=false;
  form1.checkbox10.Enabled:=false;
  form1.checkbox11.Enabled:=false;
  form1.checkbox12.Enabled:=false;
  form1.checkbox13.Enabled:=false;
  form1.checkbox18.Enabled:=false;
  form1.checkbox3.Enabled:=true;
  form1.checkbox16.Enabled:=true;
  form1.checkbox6.Enabled:=true;
  form1.checkbox4.Enabled:=true;
  form1.checkbox5.Enabled:=true;
  form1.checkbox7.Enabled:=true;
  form1.checkbox8.Enabled:=true;
  form1.checkbox17.Enabled:=true;
  form1.checkbox2.Enabled:=true;
  form1.checkbox15.Enabled:=false;
  form1.groupbox8.visible:=false;
  if total_juegos=0 then exit;
  form1.stringgrid1.Row:=0;
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

procedure TForm1.StringGrid1Click(Sender: TObject);
var
  image_string:string;
  ngame:integer;

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
  if main_config.motor=MDSP then begin
    //Imagenes DSP
    image_string:=dir_dsp+'preview\'+games_final[ngame].dir+'.png';
    if FileExists(image_string) then Image1.Picture.LoadFromFile(image_string)
      else poner_en_blanco;
  end else begin
    //Muestro las imagenes si las hay y pongo en marcha el timer
    image_string:=main_config.dir_imgs+games_final[ngame].image_name+'_000.png';
    if FileExists(image_string) then begin
      Image1.Picture.LoadFromFile(image_string);
      image_num:=0;
      timer1.Enabled:=true;
    end else poner_en_blanco;
  end;
  //Compruebo si hay manuales, mapas o guia y activo los botones
  image4.visible:=games_final[ngame].manual<>'';
  image3.visible:=games_final[ngame].guia<>'';
  image5.visible:=games_final[ngame].map<>'';
  label3.Caption:=games_final[ngame].company;
  label4.Caption:=games_final[ngame].year;
  button2.Enabled:=not(games_final[ngame].interno) or main_config.leer_fijos;
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
  form_principal_execute;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.StringGrid1DrawCell(Sender:TObject;ACol,ARow:LongInt;Rect:TRect;State:TGridDrawState);
const
  SelectedColor=$ffffe8;
  AddedColor=$e8ffff;
  BadColor=$e8e8e8;
  ScummColor=$ffe8e8;
var
  ngame:integer;
begin
  ngame:=numero_juego;
  if ngame=-1 then exit;
  if ((state=[gdSelected,gdFocused]) or (state=[gdSelected])) then
    with TStringGrid(Sender),Canvas do begin
      font.Color:=0;
      if games_final[ngame].mal then Brush.Color:=BadColor
        else if (games_final[ngame].motor=MSCUMM) then Brush.Color:=ScummColor
          else if (games_final[ngame].interno or (games_final[ngame].motor=MDSP)) then Brush.Color:=SelectedColor
            else Brush.Color:=AddedColor;
      FillRect(Rect);
      TextRect(Rect,Rect.Left+2,Rect.Top+2,Cells[aCol,aRow]);
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
  image_string:=main_config.dir_imgs+games_final[ngame].image_name+'_'+calc_image_num(image_num)+'.png';
  if not(FileExists(image_string)) then begin
    image_num:=0;
    image_string:=main_config.dir_imgs+games_final[ngame].image_name+'_000.png';
  end;
  if FileExists(image_string) then Image1.Picture.LoadFromFile(image_string);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  timer2.Enabled:=false;
  typed:='';
end;

end.
