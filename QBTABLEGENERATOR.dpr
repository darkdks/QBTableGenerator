program QBTABLEGENERATOR;

uses
  Forms,
  main in 'main.pas' {Form3},
  UFuncoes in 'UFuncoes.pas',
  QBTables in 'QBTables.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
