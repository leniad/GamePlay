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
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function descargar_juego(ngame:integer):boolean;

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
      if checkbox1.Checked then begin
        temps:=main_config.dir_base+'\extras\'+games_final[game_number].dir+'_extra.zip';
        if not(FApi.DownloadFile(games_final[game_number].dir+'_extra.zip',temps,LMsg)) then begin
          MessageDlg('Error descargando '+lmsg,mtError,[mbOk],0);
          exit;
        end;
        ZipFile:=TZipFile.Create;
        if not(Zipfile.IsValid(temps)) then exit;
        ZipFile.Open(temps,zmRead);
        ZipFIle.ExtractAll(main_config.dir_base+'\extras');
        ZipFile.Close;
        ZipFile.Free;
      end;
    end;
    deletefile(temps);
    pillar_juegos;
    ordena_juegos;
    mostrar_juegos;
    juego_descargado:=true;
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
