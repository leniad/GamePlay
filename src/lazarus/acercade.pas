unit acercade;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm3 }

  TForm3 = class(TForm)
    Copyright: TLabel;
    Image1: TImage;
    Image2: TImage;
    Label2: TLabel;
    Label3: TLabel;
    OKButton: TButton;
    Panel1: TPanel;
    ProductName: TLabel;
    procedure FormShow(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation
uses principal,main;

{$R *.lfm}

{ TForm3 }

procedure TForm3.OKButtonClick(Sender: TObject);
begin
  form3.close;
end;

procedure TForm3.FormShow(Sender: TObject);
var
   f:integer;
begin
   f:=(form1.Width-form3.Width) div 2;
   if f>0 then form3.Left:=f+form1.left;
   f:=(form1.Height-form3.Height) div 2;
   if f>0 then form3.Top:=f+form1.top;
   label3.Caption:='Version '+VERSION;
end;

end.

