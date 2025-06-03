unit acercade;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.GIFImg,
  Vcl.ExtCtrls;

type
  TForm3 = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Copyright: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    OKButton: TButton;
    Label3: TLabel;
    procedure OKButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
uses principal,main;

{$R *.dfm}

procedure TForm3.FormShow(Sender: TObject);
var
  f:integer;
begin
  f:=((form1.Width-form3.Width) div 2)+form1.left;
  if f>0 then form3.Left:=f;
  f:=((form1.Height-form3.Height) div 2)+form1.top;
  if f>0 then form3.Top:=f;
  label3.Caption:='Version '+VERSION;
end;

procedure TForm3.OKButtonClick(Sender: TObject);
begin
form3.close;
end;

end.
