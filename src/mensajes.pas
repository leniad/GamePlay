unit mensajes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  message_num:integer;

implementation
uses idioma_info;

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
    message_num:=0;
end;

procedure TForm2.FormShow(Sender: TObject);
var
  f:integer;
begin
  case message_num of
    0:label1.Caption:=list_descarga[3];
    1:label1.Caption:='Unzip...';
  end;
  f:=(screen.Width-form2.Width) div 2;
  if f>0 then form2.Left:=f;
  f:=(screen.Height-form2.Height) div 2;
  if f>0 then form2.Top:=f;
end;

end.
