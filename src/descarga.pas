unit descarga;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TDescargando = class(TForm)
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Descargando: TDescargando;

implementation
uses idioma_info;

{$R *.dfm}

procedure TDescargando.FormCreate(Sender: TObject);
begin
    cambiar_idioma_descarga2;
end;

procedure TDescargando.FormShow(Sender: TObject);
var
  f:integer;
begin
  f:=(screen.Width-descargando.Width) div 2;
  if f>0 then descargando.Left:=f;
  f:=(screen.Height-descargando.Height) div 2;
  if f>0 then descargando.Top:=f;
end;

end.
