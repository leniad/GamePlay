unit save_game;

{$mode ObjFPC}{$H+}

interface

uses
  Classes,SysUtils,Forms,Controls,Graphics,Dialogs,StdCtrls,ExtCtrls,strutils,main;

type

  { TForm2 }

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox12: TGroupBox;
    GroupBox3: TGroupBox;
    Image1: TImage;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit10: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    LabeledEdit12: TLabeledEdit;
    LabeledEdit13: TLabeledEdit;
    LabeledEdit14: TLabeledEdit;
    LabeledEdit15: TLabeledEdit;
    LabeledEdit16: TLabeledEdit;
    LabeledEdit17: TLabeledEdit;
    LabeledEdit18: TLabeledEdit;
    LabeledEdit19: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit20: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    LabeledEdit9: TLabeledEdit;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit4KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LabeledEdit5KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;
  image_num:integer;
  datos_cancel:tipo_final;

implementation
uses principal,idioma_info;


{$R *.lfm}

{ TForm2 }
procedure TForm2.Button1Click(Sender: TObject);
begin
if save_game_accept then form2.close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  games_final[juego_editado]:=datos_cancel;
  form2.close;
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  f:integer;
begin
  if MessageDlg(list_error[6], mtWarning, [mbYes]+[mbNo],0)=7 then exit;
  if (juego_editado+1)=total_juegos then begin
    total_juegos:=total_juegos-1;
  end else begin
    for f:=juego_editado to (total_juegos-1) do begin
      games_final[f]:=games_final[f+1];
    end;
    total_juegos:=total_juegos-1;
  end;
  form2.close;
end;

procedure TForm2.CheckBox3Click(Sender: TObject);
begin
  if checkbox3.checked then begin
    groupbox3.Caption:=list_zip[1];
    labelededit9.EditLabel.Caption:=list_zip[3];
  end else begin
    groupbox3.Caption:=list_zip[0];
    labelededit9.EditLabel.Caption:=list_zip[2];
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  cambiar_idioma_grabar;
  combobox1.Items.Clear;
  combobox1.Items.Add('EGA/VGA/sVGA');
  combobox1.Items.Add('CGA');
  combobox1.Items.Add('Tandy');
  combobox1.Items.Add('PC-Jr');
  combobox1.Items.Add('CGA Composite');
  combobox1.Items.Add('Hercules');
end;

procedure TForm2.FormShow(Sender: TObject);
var
  f:integer;
begin
  f:=((form1.Width-form2.Width) div 2)+form1.left;
  if f>0 then form2.Left:=f;
  f:=((form1.Height-form2.Height) div 2)+form1.top;
  if f>0 then form2.Top:=f;
  save_game_show;
end;

procedure TForm2.LabeledEdit4KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  r:trect;
  image_string:string;
begin
image_string:=main_config.dir_imgs+labelededit4.text+'_000.png';
if FileExists(image_string) then begin
    Image1.Picture.LoadFromFile(image_string);
    image_num:=0;
    timer1.Enabled:=true;
end else begin
    r.top:=0;
    r.Left:=image1.width;
    r.Right:=0;
    r.Bottom:=image1.height;
    image1.Picture:=nil;
    image1.Canvas.Brush.Color:=clBlack;
    image1.Canvas.FillRect(r);
    timer1.Enabled:=false;
end;
end;

procedure TForm2.LabeledEdit5KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if ContainsText(labelededit5.Text,'.img') then labelededit10.Enabled:=true
  else labelededit10.Enabled:=false;
end;

procedure TForm2.Timer1Timer(Sender: TObject);
function calc_image_num(number:integer):string;
begin
  if number<10 then calc_image_num:='00'+inttostr(number)
    else if number<100 then calc_image_num:='0'+inttostr(number)
      else calc_image_num:=inttostr(number);
end;
var
  image_string:string;
begin
  image_num:=image_num+1;
  image_string:=main_config.dir_imgs+labelededit4.text+'_'+calc_image_num(image_num)+'.png';
  if not(FileExists(image_string)) then begin
    image_num:=0;
    image_string:=main_config.dir_imgs+labelededit4.text+'_000.png';
  end;
  if FileExists(image_string) then Image1.Picture.LoadFromFile(image_string);
end;

end.

