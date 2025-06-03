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
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
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
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    Image1: TImage;
    ImageList1: TImageList;
    ImageList2: TImageList;
    ImageList3: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabeledEdit1: TLabeledEdit;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure CheckBox14Change(Sender: TObject);
    procedure CheckBox15Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit1KeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton3Clic(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation
uses save_game, acercade,config,idioma_info,strutils,games_data,
     games_info{$IFDEF WINDOWS},windows{$ELSE},LCLIntf,process{$ENDIF},main;

{$R *.lfm}

var
  image_num:integer;

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
abrir_ficheros_separados(games_final[numero_juego].manual,main_config.dir_manual);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
abrir_ficheros_separados(games_final[numero_juego].map,main_config.dir_mapas);
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  abrir_ficheros_separados(games_final[numero_juego].guia,main_config.dir_guias);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
 form_principal_execute;
 if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  form3.showmodal;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
  form4.showmodal;
  pillar_juegos;
  ordena_juegos;
  LabeledEdit1Change(nil);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  juego_editado:=total_juegos;
  estoy_anadiendo:=true;
  form2.showmodal;
  ordena_juegos;
  LabeledEdit1Change(nil);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  juego_editado:=numero_juego;
  if juego_editado=-1 then exit;
  estoy_anadiendo:=false;
  form2.showmodal;
  ordena_juegos;
  LabeledEdit1Change(nil);
end;

procedure TForm1.CheckBox10Click(Sender: TObject);
begin
  LabeledEdit1Change(nil);
end;

procedure TForm1.CheckBox14Change(Sender: TObject);
begin
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.CheckBox15Click(Sender: TObject);
begin
  if not(checkbox15.Checked) then begin
      button1.Visible:=false;
      button2.Visible:=false;
    end else begin
      button1.Visible:=true;
      button2.Visible:=true;
    end;
    if form1.Visible then StringGrid1.SetFocus;
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

procedure TForm1.LabeledEdit1Change(Sender: TObject);
var
    texto:string;
    pos,f:integer;
    nombre_temp:array[0..MAX_GAMES,0..1] of string;
begin
  mostrar_juegos;
  if LabeledEdit1.Text='' then exit;
  texto:=UpperCase(LabeledEdit1.Text);
  pos:=0;
  Timer1.Enabled:=false;
  for f:=0 to (stringgrid1.RowCount-1) do begin
    if ContainsText(uppercase(stringgrid1.Cells[0,f]),texto) then begin
        nombre_temp[pos,0]:=stringgrid1.Cells[0,f];
        nombre_temp[pos,1]:=stringgrid1.Cells[1,f];
        pos:=pos+1;
      end;
  end;
  for f:=0 to StringGrid1.ColCount-1 do StringGrid1.Cols[f].Clear;
  for f:=0 to (pos-1) do begin
    stringgrid1.Cells[0,f]:=nombre_temp[f,0];
    stringgrid1.Cells[1,f]:=nombre_temp[f,1];
  end;
  if pos=0 then begin
    stringgrid1.RowCount:=1;
    BitBtn1.Enabled:=false;
    BitBtn2.Enabled:=false;
    BitBtn3.Enabled:=false;
  end else stringgrid1.RowCount:=pos;
  Label5.Caption:='TOTAL: '+inttostr(pos)+'/'+inttostr(total_juegos);
  StringGrid1Click(nil);
  if stringgrid1.Cells[1,0]<>'' then button2.Enabled:=not(games_final[orden_games[pos]].interno) or main_config.leer_fijos;
end;

procedure TForm1.LabeledEdit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key=27 then LabeledEdit1.Text:='';
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  if total_juegos=0 then exit;
  mostrar_juegos;
  groupbox4.Enabled:=true;
  checkbox3.Enabled:=true;
  checkbox16.Enabled:=true;
  checkbox6.Enabled:=true;
  checkbox4.Enabled:=true;
  checkbox5.Enabled:=true;
  checkbox7.Enabled:=true;
  checkbox8.Enabled:=true;
  checkbox17.Enabled:=true;
  checkbox18.Enabled:=true;
  checkbox2.Enabled:=true;
  stringgrid1.Row:=0;
  LabeledEdit1.Text:='';
  if stringgrid1.Cells[1,0]<>'' then button2.Enabled:=not(games_final[strtoint(stringgrid1.Cells[1,0])].interno) or main_config.leer_fijos;
  if form1.Visible then StringGrid1.SetFocus;
end;

procedure TForm1.RadioButton3Clic(Sender: TObject);
begin
  if total_juegos=0 then exit;
  mostrar_juegos;
  groupbox4.Enabled:=false;
  checkbox3.Enabled:=false;
  checkbox16.Enabled:=false;
  checkbox6.Enabled:=false;
  checkbox4.Enabled:=false;
  checkbox5.Enabled:=false;
  checkbox7.Enabled:=false;
  checkbox8.Enabled:=false;
  checkbox17.Enabled:=false;
  checkbox18.Enabled:=false;
  checkbox2.Enabled:=false;
  stringgrid1.Row:=0;
  LabeledEdit1.Text:='';
  if stringgrid1.Cells[1,0]<>'' then button2.Enabled:=not(games_final[strtoint(stringgrid1.Cells[1,0])].interno) or main_config.leer_fijos;
  if form1.Visible then StringGrid1.SetFocus;
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
  //Muestro las imagenes si las hay y pongo en marcha el timer
  image_string:=main_config.dir_imgs+games_final[ngame].image_name+'_000.png';
  if FileExists(image_string) then begin
    Image1.Picture.LoadFromFile(image_string);
    image_num:=0;
    timer1.Enabled:=true;
  end else poner_en_blanco;
  //Compruebo si hay manuales, mapas o guia y activo los botones
  bitbtn1.Enabled:=games_final[ngame].manual<>'';
  bitbtn2.Enabled:=games_final[ngame].map<>'';
  bitbtn3.Enabled:=games_final[ngame].guia<>'';
  label3.Caption:=games_final[ngame].company;
  label4.Caption:=games_final[ngame].year;
  button2.Enabled:=not(games_final[ngame].interno) or main_config.leer_fijos;
end;

procedure TForm1.StringGrid1DblClick(Sender: TObject);
begin
  BitBtn4Click(nil);
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; aCol, aRow: Integer;aRect:TRect;aState:TGridDrawState);
const
  SColor=$ffffe8;
  AddedColor=$e8ffff;
  BadColor=$e8e8e8;
var
   ngame:integer;
begin
  ngame:=numero_juego;
  if ngame=-1 then exit;
  if (astate=[gdSelected,gdFocused]) then
    with TStringGrid(Sender),Canvas do begin
      if games_final[ngame].mal then Brush.Color:=BadColor
         else if games_final[ngame].interno then Brush.Color:=SColor
            else Brush.Color:=AddedColor;
      FillRect(aRect);
      TextRect(aRect,aRect.Left+2,aRect.Top+2,Cells[aCol,aRow]);
    end;
end;

procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
if (key<>char($d)) then begin
  if stringgrid1.Cells[1,0]='' then exit;
  case byte(key) of
    8:LabeledEdit1.Text:=copy(LabeledEdit1.Text,0,length(LabeledEdit1.Text)-1);
    27:LabeledEdit1.Text:='';
    else LabeledEdit1.Text:=LabeledEdit1.Text+key;
  end;
end else begin
  BitBtn4Click(nil);
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

end.

