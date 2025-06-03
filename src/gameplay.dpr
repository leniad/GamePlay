
program gameplay;

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  principal in 'principal.pas' {Form1},
  Vcl.Themes,
  Vcl.Styles,
  games_data in 'games_data.pas',
  games_info in 'games_info.pas',
  save_game in 'save_game.pas' {Form2},
  acercade in 'acercade.pas' {Form3},
  config in 'config.pas' {Form4},
  idioma_info in 'idioma_info.pas',
  main in 'main.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
