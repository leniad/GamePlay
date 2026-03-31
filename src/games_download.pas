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
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function descargar_juego(ngame:integer):boolean;
  procedure descargar_juego_sin_confirmar(ngame:integer);

var
  Form5:TForm5;

implementation
uses download_game,main,zip,idioma_info;

var
  FApi:TApiClient;
  game_number:integer;
  juego_descargado:boolean;

const
  USUARIO='usuario';
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

procedure TForm5.Button1Click(Sender:TObject);
var
  lmsg:string;
  ZipFile:TZipFile;
  temps:string;
begin
  //Conexion+token
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
    if games_final[game_number].motor=MDSP then begin
      if not(FApi.DownloadFile(games_final[game_number].dir+'_dsp.zip',main_config.dir_base+'\dsp\roms\'+games_final[game_number].dir+'.zip',LMsg)) then begin
        MessageDlg('Error descargando '+lmsg,mtError,[mbOk],0);
        exit;
      end;
    end else begin
      if not(FApi.DownloadFile(games_final[game_number].dir+'.zip',main_config.dir_zip+games_final[game_number].dir+'.zip',LMsg)) then begin
        MessageDlg('Error descargando '+lmsg,mtError,[mbOk],0);
        exit;
      end;
      //Descargar extras
      temps:=main_config.dir_base+'\extras\'+games_final[game_number].dir+'_extra.zip';
      if FApi.DownloadFile(games_final[game_number].dir+'_extra.zip',temps,LMsg) then begin
        ZipFile:=TZipFile.Create;
        if Zipfile.IsValid(temps) then begin
            ZipFile.Open(temps,zmRead);
            ZipFIle.ExtractAll(main_config.dir_base+'\extras');
            ZipFile.Close;
        end;
        ZipFile.Free;
        deletefile(temps);
      end;
    end;
    pillar_juegos;
    ordena_juegos;
    mostrar_juegos;
    juego_descargado:=true;
    games_final[game_number].mostrar:=true;
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
  close;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  close;
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
end;

end.
