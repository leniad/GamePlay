unit config;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.Mask,
  Vcl.ExtCtrls;

type
  TForm4 = class(TForm)
    GroupBox1: TGroupBox;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    GroupBox2: TGroupBox;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    Button7: TButton;
    GroupBox3: TGroupBox;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    LabeledEdit9: TLabeledEdit;
    Button12: TButton;
    LabeledEdit10: TLabeledEdit;
    Button13: TButton;
    LabeledEdit11: TLabeledEdit;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    Button14: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    LabeledEdit12: TLabeledEdit;
    Button15: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure CheckBox10Click(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  semaforo,semaforo2,semaforo3:boolean;

implementation
uses principal,idioma_info,main;

{$R *.dfm}

procedure TForm4.Button10Click(Sender: TObject);
var
  dir:string;
begin
dir:=seleccionar_directorio(main_config.dir_guias);
if dir<>'' then labelededit8.Text:=dir+'\';
end;

procedure TForm4.Button11Click(Sender: TObject);
var
  dir:string;
begin
dir:=seleccionar_directorio(main_config.dir_zip);
if dir<>'' then labelededit9.Text:=dir+'\';
end;

procedure TForm4.Button12Click(Sender: TObject);
var
  dir:string;
begin
dir:=seleccionar_directorio(main_config.dir_imgs);
if dir<>'' then labelededit10.Text:=dir+'\';
end;

procedure TForm4.Button13Click(Sender: TObject);
var
  dir:string;
begin
dir:=seleccionar_directorio(main_config.dir_mt32);
if dir<>'' then labelededit11.Text:=dir;
end;

procedure TForm4.Button14Click(Sender: TObject);
begin
  labelededit1.Text:=main_config.dir_base+'extras\dosbox\dosbox.exe';
  labelededit2.Text:=main_config.dir_base+'extras\dosbox_x\dosbox-x.exe';
  labelededit3.Text:=main_config.dir_base+'extras\scummvm\scummvm.exe';
  labelededit6.Text:=main_config.dir_base+'extras\manual\';
  labelededit7.Text:=main_config.dir_base+'extras\maps\';
  labelededit8.Text:=main_config.dir_base+'extras\walk\';
  labelededit9.Text:=main_config.dir_base+'zip_games\';
  labelededit10.Text:=main_config.dir_base+'extras\imgs\';
  labelededit11.Text:=main_config.dir_base+'extras\mt32';
  labelededit4.Text:=main_config.dir_base+'extras\config\dosbox.conf';
  labelededit5.Text:=main_config.dir_base+'extras\config\dosbox-x.conf';
  labelededit12.Text:=main_config.dir_base+'extras\config\scummvm.ini';
end;

procedure TForm4.Button15Click(Sender: TObject);
begin
  openDialog1.InitialDir:=extractfilepath(main_config.scumm_exe);
  openDialog1.Options:=[ofFileMustExist];
  Opendialog1.Filter:='Config file (*.ini)|*.ini';
  if Opendialog1.Execute then labelededit12.Text:=opendialog1.FileName;
end;

procedure TForm4.Button1Click(Sender: TObject);
begin
  main_config.config_dosbox:=labelededit4.Text;
  main_config.config_dosbox_x:=labelededit5.Text;
  main_config.config_scummvm:=labelededit12.Text;
  form1.button2.Enabled:=main_config.leer_fijos;
  main_config.dosbox_exe:=labelededit1.Text;
  main_config.dosbox_x_exe:=labelededit2.Text;
  main_config.scumm_exe:=labelededit3.Text;
  main_config.dir_manual:=labelededit6.Text;
  main_config.dir_mapas:=labelededit7.Text;
  main_config.dir_guias:=labelededit8.Text;
  main_config.dir_zip:=labelededit9.Text;
  main_config.dir_imgs:=labelededit10.Text;
  main_config.dir_mt32:=labelededit11.Text;
  form4.close;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
  openDialog1.InitialDir:=extractfilepath(main_config.dosbox_exe);
  openDialog1.Options:=[ofFileMustExist];
  Opendialog1.Filter:='Config file (*.conf)|*.conf';
  if Opendialog1.Execute then labelededit4.Text:=opendialog1.FileName;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
  openDialog1.InitialDir:=extractfilepath(main_config.dosbox_x_exe);
  openDialog1.Options:=[ofFileMustExist];
  Opendialog1.Filter:='Config file (*.conf)|*.conf';
  if Opendialog1.Execute then labelededit5.Text:=opendialog1.FileName;
end;

procedure TForm4.Button4Click(Sender: TObject);
begin
  openDialog1.InitialDir:=extractfilepath(main_config.dosbox_exe);
  openDialog1.Options:=[ofFileMustExist];
  Opendialog1.Filter:='EXE file (*.exe)|*.exe';
  if Opendialog1.Execute then labelededit1.Text:=opendialog1.FileName;
end;

procedure TForm4.Button5Click(Sender: TObject);
begin
  openDialog1.InitialDir:=extractfilepath(main_config.dosbox_x_exe);
  openDialog1.Options:=[ofFileMustExist];
  Opendialog1.Filter:='EXE file (*.exe)|*.exe';
  if Opendialog1.Execute then labelededit2.Text:=opendialog1.FileName;
end;

procedure TForm4.Button6Click(Sender: TObject);
begin
  openDialog1.InitialDir:=extractfilepath(main_config.scumm_exe);
  openDialog1.Options:=[ofFileMustExist];
  Opendialog1.Filter:='EXE file (*.exe)|*.exe';
  if Opendialog1.Execute then labelededit3.Text:=opendialog1.FileName;
end;

procedure TForm4.Button7Click(Sender: TObject);
begin
  form4.close;
end;

procedure TForm4.Button8Click(Sender:TObject);
var
  dir:string;
begin
dir:=seleccionar_directorio(main_config.dir_manual);
if dir<>'' then labelededit6.Text:=dir+'\';
end;

procedure TForm4.Button9Click(Sender: TObject);
var
  dir:string;
begin
dir:=seleccionar_directorio(main_config.dir_mapas);
if dir<>'' then labelededit7.Text:=dir+'\';
end;

procedure TForm4.CheckBox10Click(Sender: TObject);
begin
  main_config.leer_fijos:=checkbox10.Checked;
end;

procedure TForm4.CheckBox11Click(Sender: TObject);
begin
 semaforo2:=true;
 if not(semaforo) then checkbox1.Checked:=false;
 if not(semaforo3) then checkbox2.Checked:=false;
 main_config.mostrar_todos:=checkbox11.Checked;
 semaforo2:=false;
end;

procedure TForm4.CheckBox1Click(Sender: TObject);
begin
  semaforo:=true;
  if not(semaforo2) then checkbox11.Checked:=false;
  if not(semaforo3) then checkbox2.Checked:=false;
  main_config.mostrar_fallan:=checkbox1.Checked;
  semaforo:=false;
end;

procedure TForm4.CheckBox2Click(Sender: TObject);
begin
  semaforo3:=true;
  if not(semaforo) then checkbox1.Checked:=false;
  if not(semaforo2) then checkbox11.Checked:=false;
  main_config.mostrar_anadidos:=checkbox2.Checked;
  semaforo3:=false;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  cambiar_idioma_avanzado;
end;

procedure TForm4.FormShow(Sender: TObject);
var
  f:integer;
begin
  f:=((form1.Width-form4.Width) div 2)+form1.left;
  if f>0 then form4.Left:=f;
  f:=((form1.Height-form4.Height) div 2)+form1.top;
  if f>0 then form4.Top:=f;
  config_show;
  semaforo:=false;
  semaforo2:=false;
  semaforo3:=false;
end;

procedure TForm4.RadioButton1Click(Sender: TObject);
begin
  idioma_sel:=200;
  seleccionar_idioma;
  cambiar_idioma_principal;
  cambiar_idioma_grabar;
  cambiar_idioma_avanzado;
end;

procedure TForm4.RadioButton2Click(Sender: TObject);
begin
  idioma_sel:=0;
  idioma_ind:=0;
  cambiar_idioma_principal;
  cambiar_idioma_grabar;
  cambiar_idioma_avanzado;
end;

procedure TForm4.RadioButton3Click(Sender: TObject);
begin
  idioma_sel:=1;
  idioma_ind:=1;
  cambiar_idioma_principal;
  cambiar_idioma_grabar;
  cambiar_idioma_avanzado;
end;

procedure TForm4.RadioButton4Click(Sender: TObject);
begin
  idioma_sel:=2;
  idioma_ind:=2;
  cambiar_idioma_principal;
  cambiar_idioma_grabar;
  cambiar_idioma_avanzado;
end;

procedure TForm4.RadioButton5Click(Sender: TObject);
begin
  idioma_sel:=3;
  idioma_ind:=3;
  cambiar_idioma_principal;
  cambiar_idioma_grabar;
  cambiar_idioma_avanzado;
end;

procedure TForm4.RadioButton6Click(Sender: TObject);
begin
  idioma_sel:=4;
  idioma_ind:=4;
  cambiar_idioma_principal;
  cambiar_idioma_grabar;
  cambiar_idioma_avanzado;
end;

end.
