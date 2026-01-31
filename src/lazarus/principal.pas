unit principal;

{$mode delphi}{$H+}

{$DEFINE IS_DEBUG}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, Grids,
  Buttons, ExtCtrls, Types,dialogs;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    GroupBox1: TGroupBox;
    GroupBox9: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    RadioButton1: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox14Change(Sender: TObject);
    procedure CheckBox15Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  typed:string;

implementation
uses save_game, acercade,config,idioma_info,strutils,games_data,dsp_data,
     games_info{$IFDEF WINDOWS},windows{$ELSE},LCLIntf,process{$ENDIF},main;

{$R *.lfm}

var
  image_num:integer;

procedure TForm1.Button1Click(Sender: TObject);
begin
  juego_editado:=total_juegos;
  estoy_anadiendo:=true;
  form2.showmodal;
  ordena_juegos;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  juego_editado:=numero_juego;
  if juego_editado=-1 then exit;
  estoy_anadiendo:=false;
  form2.showmodal;
  ordena_juegos;
end;

{ TForm1 }
procedure TForm1.CheckBox14Change(Sender: TObject);
begin
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.CheckBox15Click(Sender: TObject);
begin
  groupbox8.visible:=checkbox15.Checked;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.CheckBox2Click(Sender: TObject);
begin
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
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

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
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
  checkbox15.Enabled:=true;
  groupbox8.visible:=checkbox15.Checked;
  groupbox9.visible:=true;
  if stringgrid1.Cells[1,0]<>'' then button2.Enabled:=not(games_final[strtoint(stringgrid1.Cells[1,0])].interno) or main_config.leer_fijos;
  if total_juegos=0 then exit;
  mostrar_juegos;
  stringgrid1.Row:=0;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
begin
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
  checkbox15.Enabled:=true;
  groupbox8.visible:=checkbox15.Checked;
  groupbox9.visible:=false;
  if stringgrid1.Cells[1,0]<>'' then button2.Enabled:=not(games_final[strtoint(stringgrid1.Cells[1,0])].interno) or main_config.leer_fijos;
  if total_juegos=0 then exit;
  mostrar_juegos;
  stringgrid1.Row:=0;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.RadioButton4Click(Sender: TObject);
begin
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
  mostrar_juegos;
  stringgrid1.Row:=0;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.RadioButton5Click(Sender: TObject);
begin
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
  checkbox15.Enabled:=false;
  groupbox8.visible:=false;
  if total_juegos=0 then exit;
  mostrar_juegos;
  stringgrid1.Row:=0;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.RadioButton7Click(Sender: TObject);
begin
  main_config.motor_msdos:=0;
end;

procedure TForm1.RadioButton8Click(Sender: TObject);
begin
  main_config.motor_msdos:=1;
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
  if radiobutton4.Checked then begin
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

procedure TForm1.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;aRect:TRect;aState:TGridDrawState);
const
  SColor=$ffffe8;
  AddedColor=$e8ffff;
  BadColor=$e8e8e8;
  ScummColor=$ffe8e8;
var
   ngame:integer;
begin
  ngame:=numero_juego;
  if ngame=-1 then exit;
  if (astate=[gdSelected,gdFocused]) then
    with TStringGrid(Sender),Canvas do begin
      font.Color:=0;
      if games_final[ngame].mal then Brush.Color:=BadColor
         else if games_final[ngame].motor=1 then Brush.Color:=ScummColor
            else if (games_final[ngame].interno or (games_final[ngame].motor=255)) then Brush.Color:=SColor
               else Brush.Color:=AddedColor;
      FillRect(aRect);
      TextRect(aRect,aRect.Left+2,aRect.Top+2,Cells[aCol,aRow]);
    end;
end;

procedure TForm1.StringGrid1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  f:integer;
  temps:string;
begin
case key of
  13:StringGrid1DblClick(nil);
  48..57,65..90:begin
            typed:=typed+lowercase(char(key));
            timer2.Enabled:=false;
            timer2.Enabled:=true;
            for f:=1 to (stringgrid1.RowCount-1) do begin
              temps:=ansilowercase(copy(stringgrid1.Cells[0,f],0,length(typed)));
              if typed=temps then begin
                if (f-10)<1 then stringgrid1.TopRow:=1
                  else stringgrid1.TopRow:=f-10;
                stringgrid1.row:=f;
                StringGrid1Click(nil);
                break;
              end;
            end;
         end;
end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
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

