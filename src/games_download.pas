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
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function descargar_juego(ngame,descarga:integer):boolean;
  function descargar_fichero(origen,destino:string;check:boolean):boolean;
  function comprobar_version_lista:string;

const
  USUARIO='user';
  PASSWORD='password';
  URL_GAMEPLAY='url1';
  URL_API='url2';
  DESC_SINCONFIRMAR=0;
  DESC_NORMAL=1;
  DESC_MANUAL=2;
  DESC_UPDATE=3;

var
  Form5:TForm5;

implementation
uses download_game,main,zip,idioma_info,principal,mensajes;

var
  FApi:TApiClient;
  game_number:integer;
  juego_descargado:boolean;
  tipo_descarga:integer;

{$R *.dfm}

function descargar_juego(ngame,descarga:integer):boolean;
begin
  game_number:=ngame;
  juego_descargado:=false;
  tipo_descarga:=descarga;
  case descarga of
    DESC_SINCONFIRMAR:form5.Button1Click(nil); //Descarga sin confirmar
    DESC_NORMAL,DESC_MANUAL,DESC_UPDATE:form5.showmodal; //Descarga normal o manuales, guias, etc, o update
  end;
  descargar_juego:=juego_descargado;
end;

function comprobar_version_lista:string;
begin
  comprobar_version_lista:=FApi.GetServerVersion;
end;

function descargar_fichero(origen,destino:string;check:boolean):boolean;
procedure mostrar_mensaje;
begin
  MessageDlg('Error downloading. Pease contact leniad2[@]hotmal.com or visit https://github.com/leniad/GamePlay',mtError,[mbOk],0);
end;
var
  lmsg:string;
begin
  //Conexion+token
  descargar_fichero:=false;
  try
    if not(FApi.Login(USUARIO,PASSWORD,lmsg)) then begin
      mostrar_mensaje;
      exit;
    end;
  except
    on E: Exception do begin
      mostrar_mensaje;
      exit;
    end;
  end;
  //Descargar fichero
  try
    if not(FApi.DownloadFile(origen,destino,LMsg)) then begin
      if not(check) then begin
        {$I-}
        deletefile(destino);
        {$I+}
        exit;
      end;
      mostrar_mensaje;
      exit;
    end;
  except
    on E: Exception do begin
      mostrar_mensaje;
      exit;
    end;
  end;
  //Cerrar conexion
  try
    if not(FApi.Logout(LMsg)) then begin
      mostrar_mensaje;
      exit;
    end;
  except
    on E: Exception do begin
      mostrar_mensaje;
      exit;
    end;
  end;
  descargar_fichero:=true;
end;

procedure TForm5.Button1Click(Sender:TObject);
var
  origen,destino:string;

procedure unzip_all(directorio:string);
var
  ZipFile:TZipFile;
begin
  ZipFile:=TZipFile.Create;
  if Zipfile.IsValid(destino) then begin
    ZipFile.Open(destino,zmRead);
    ZipFIle.ExtractAll(directorio);
    ZipFile.Close;
  end;
  ZipFile.Free;
  {$I-}
  deletefile(destino);
  {$I+}
end;

procedure descargar_extras;
begin
  origen:=juego_dir(game_number)+'_extra.zip';
  destino:=main_config.dir_base+'extras\'+juego_dir(game_number)+'_extra.zip';
  if descargar_fichero(origen,destino,false) then unzip_all(main_config.dir_base+'\extras');
end;

begin
    //Descargarse la lista de juegos y las imagenes
    if game_number=-1 then begin
        origen:='gameplay_list.zip';
        destino:=main_config.dir_base+'gameplay_list.zip';
        message_num:=1;
        if descargar_fichero(origen,destino,false) then begin
          form2.show;
          form2.update;
          unzip_all(main_config.dir_base);
          form2.close;
        end;
        origen:='gameplay_imgs.zip';
        destino:=main_config.dir_base+'gameplay_imgs.zip';
        if descargar_fichero(origen,destino,false) then begin
          form2.show;
          form2.update;
          unzip_all(main_config.dir_imgs);
          form2.close;
        end;
        exit;
    end;
    //Descargar solo extras
    if (tipo_descarga=DESC_MANUAL) then descargar_extras
      else if games_final[game_number].motor=MDSP then begin
                origen:=games_final[game_number].dir+'_dsp.zip';
                destino:=main_config.dir_base+'dsp\roms\'+games_final[game_number].dir+'.zip';
                if not(descargar_fichero(origen,destino,true)) then exit;
              end else begin
                origen:=juego_dir(game_number);
                destino:=main_config.dir_zip+juego_dir(game_number);
                if not(descargar_fichero(origen+'.zip',destino+'.zip',false)) then
                  if not(descargar_fichero(origen+'.rar',destino+'.rar',true)) then exit;
                //Descargar extras
                if main_config.descargar_extra then descargar_extras;
              end;
    comprobar_juegos;
    mostrar_juegos;
    juego_descargado:=true;
    close;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TForm5.FormCreate(Sender: TObject);
begin
  cambiar_idioma_descarga;
  FApi:=TApiClient.Create;
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
  case tipo_descarga of
    DESC_NORMAL:Label1.Caption:=list_descarga[6];
    DESC_MANUAL:Label1.Caption:=list_descarga[7];
    DESC_UPDATE:Label1.Caption:=list_descarga[9];
  end;
end;

end.
