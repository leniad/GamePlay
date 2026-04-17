unit games_download;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,uitypes;

type
  TForm5 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function descargar_juego(ngame:integer):boolean;
  procedure descargar_juego_sin_confirmar(ngame:integer);
  function descargar_fichero(origen,destino:string;check:boolean):boolean;

var
  Form5:TForm5;

implementation
uses download_game,main,zip,idioma_info;

var
  FApi:TApiClient;
  game_number:integer;
  juego_descargado:boolean;

const
  USUARIO='user';
  PASSWORD='password';
  URL='url';

{$R *.dfm}

procedure descargar_juego_sin_confirmar(ngame:integer);
begin
  game_number:=ngame;
  form5.Button1Click(nil);
end;


function descargar_juego(ngame:integer):boolean;
begin
  game_number:=ngame;
  juego_descargado:=false;
  form5.showmodal;
  descargar_juego:=juego_descargado;
end;

function descargar_fichero(origen,destino:string;check:boolean):boolean;
var
  lmsg:string;
begin
  //Conexion+token
  descargar_fichero:=false;
  try
    if not(FApi.Login(USUARIO,PASSWORD,lmsg)) then begin
      MessageDlg('Error login '+lmsg,mtError,[mbOk],0);
      exit;
    end;
  except
    on E: Exception do begin
      MessageDlg('Error incontrolado login',mtError,[mbOk],0);
      exit;
    end;
  end;
  //Descargar fichero
  try
    if not(FApi.DownloadFile(origen,destino,LMsg)) then begin
      if not(check) then exit;
      MessageDlg('Error descargando '+lmsg,mtError,[mbOk],0);
      exit;
    end;
  except
    on E: Exception do begin
      MessageDlg('Error incontrolado download',mtError,[mbOk],0);
      exit;
    end;
  end;
  //Cerrar conexion
  try
    if not(FApi.Logout(LMsg)) then begin
      MessageDlg('Error logout '+lmsg,mtError,[mbOk],0);
      exit;
    end;
  except
    on E: Exception do begin
      MessageDlg('Error incontrolado logout',mtError,[mbOk],0);
      exit;
    end;
  end;
  descargar_fichero:=true;
end;


procedure TForm5.Button1Click(Sender:TObject);
var
  origen,destino:string;
  ZipFile:TZipFile;
begin
    if games_final[game_number].motor=MDSP then begin
      origen:=games_final[game_number].dir+'_dsp.zip';
      destino:=main_config.dir_base+'dsp\roms\'+games_final[game_number].dir+'.zip';
      if not(descargar_fichero(origen,destino,true)) then exit;
    end else begin
      origen:=juego_dir(game_number)+'.zip';
      destino:=main_config.dir_zip+juego_dir(game_number)+'.zip';
      if not(descargar_fichero(origen,destino,true)) then exit;
      //Descargar extras
      if main_config.descargar_extra then begin
        origen:=juego_dir(game_number)+'_extra.zip';
        destino:=main_config.dir_base+'extras\'+juego_dir(game_number)+'_extra.zip';
        if descargar_fichero(origen,destino,false) then begin
          ZipFile:=TZipFile.Create;
          if Zipfile.IsValid(destino) then begin
              ZipFile.Open(destino,zmRead);
              ZipFIle.ExtractAll(main_config.dir_base+'\extras');
              ZipFile.Close;
          end;
          ZipFile.Free;
        end;
        {$I-}
        deletefile(destino);
        {$I+}
      end;
    end;
    pillar_juegos;
    ordena_juegos;
    mostrar_juegos;
    juego_descargado:=true;
    games_final[game_number].mostrar:=true;
    close;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm5.CheckBox1Click(Sender: TObject);
begin
  main_config.descargar_extra:=checkbox1.Checked;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  cambiar_idioma_descarga;
  FApi:=TApiClient.Create(URL);
end;

procedure TForm5.FormDestroy(Sender: TObject);
begin
  FApi.Free;
end;

procedure TForm5.FormShow(Sender: TObject);
var
  f:integer;
begin
  f:=(screen.Width-form5.Width) div 2;
  if f>0 then form5.Left:=f;
  f:=(screen.Height-form5.Height) div 2;
  if f>0 then form5.Top:=f;
  checkbox1.Checked:=main_config.descargar_extra;
end;

end.
