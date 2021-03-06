program NGPCEdit;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Editor},
  Color in 'Color.pas' {ColorPicker},
  Common in 'Common.pas',
  BGColorForm in 'BGColorForm.pas' {BGColor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TEditor, Editor);
  Application.CreateForm(TColorPicker, ColorPicker);
  Application.CreateForm(TBGColor, BGColor);
  Application.Run;
end.
