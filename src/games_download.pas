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
  function descargar_juego(ngame:integer):boolean;
  procedure descargar_juego_sin_confirmar(ngame:integer);
  function descargar_fichero(origen,destino:string;check:boolean):boolean;
  function descargar_manual(ngame:integer):boolean;
  function comprobar_version_lista:string;

const
  USUARIO='user';
  PASSWORD='password';
  URL_GAMEPLAY='url1';
  URL_API='url2';

var
  Form5:TForm5;

implementation
uses download_game,main,zip,idioma_info,principal;

var
  FApi:TApiClient;
  game_number:integer;
  juego_descargado:boolean;
  manual_descargar:boolean;

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
  manual_descargar:=false;
  form5.showmodal;
  descargar_juego:=juego_descargado;
end;

function descargar_manual(ngame:integer):boolean;
begin
  game_number:=ngame;
  juego_descargado:=false;
  manual_descargar:=true;
  form5.showmodal;
  descargar_manual:=juego_descargado;
end;

function comprobar_version_lista:string;
begin
  comprobar_version_lista:=FApi.GetServerVersion;
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
      if not(check) then begin
        {$I-}
        deletefile(destino);
        {$I+}
        exit;
      end;
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
    //Descargar solo extras
    if manual_descargar then begin
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
    end else
    if games_final[game_number].motor=MDSP then begin
      origen:=games_final[game_number].dir+'_dsp.zip';
      destino:=main_config.dir_base+'dsp\roms\'+games_final[game_number].dir+'.zip';
      if not(descargar_fichero(origen,destino,true)) then exit;
    end else begin
      //Descargarse la lista de juegos y las imagenes
      if game_number=0 then begin
        origen:='gameplay_list.zip';
        destino:=main_config.dir_base+'gameplay_list.zip';
        if descargar_fichero(origen,destino,false) then begin
          ZipFile:=TZipFile.Create;
          if Zipfile.IsValid(destino) then begin
              ZipFile.Open(destino,zmRead);
              ZipFIle.ExtractAll(main_config.dir_base);
              ZipFile.Close;
          end;
          ZipFile.Free;
        end;
        {$I-}
        deletefile(destino);
        {$I+}
        origen:='gameplay_imgs.zip';
        destino:=main_config.dir_base+'gameplay_imgs.zip';
        if descargar_fichero(origen,destino,false) then begin
          ZipFile:=TZipFile.Create;
          if Zipfile.IsValid(destino) then begin
              ZipFile.Open(destino,zmRead);
              ZipFIle.ExtractAll(main_config.dir_imgs);
              ZipFile.Close;
          end;
          ZipFile.Free;
        end;
        {$I-}
        deletefile(destino);
        {$I+}
        exit;
    end;
      origen:=juego_dir(game_number);
      destino:=main_config.dir_zip+juego_dir(game_number);
      if not(descargar_fichero(origen+'.zip',destino+'.zip',false)) then
        if not(descargar_fichero(origen+'.rar',destino+'.rar',true)) then exit;
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
  if manual_descargar then Label1.Caption:=list_descarga[7]
    else Label1.Caption:=list_descarga[6];
end;

end.
