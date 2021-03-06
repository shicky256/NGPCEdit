unit BGColorForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls, Common;

type
  TBGColor = class(TForm)
    RedLabel: TLabel;
    GreenLabel: TLabel;
    BlueLabel: TLabel;
    PreviewLabel: TLabel;
    Image1: TImage;
    RedSpin: TSpinEdit;
    GreenSpin: TSpinEdit;
    BlueSpin: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure RedSpinChange(Sender: TObject);
    procedure GreenSpinChange(Sender: TObject);
    procedure BlueSpinChange(Sender: TObject);
    procedure RefreshColor();
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
  DEFAULT_BG_VAL = 15;
var
  BGColor: TBGColor;
  CommonInst: TCommon;

implementation

procedure TBGColor.FormCreate(Sender: TObject);
var color: TColor;
begin
  color := Palettes[0][0];
  RedSpin.Value := GetRValue(ColorToRGB(color)) div 16;
  GreenSpin.Value := GetGValue(ColorToRGB(color)) div 16;
  BlueSpin.Value := GetBValue(ColorToRGB(color)) div 16;
  Image1.Canvas.Brush.Color := Palettes[0][0];
  Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
end;

{$R *.dfm}

procedure TBGColor.BlueSpinChange(Sender: TObject);
begin
  RefreshColor();
end;

procedure TBGColor.GreenSpinChange(Sender: TObject);
begin
  RefreshColor();
end;

procedure TBGColor.RedSpinChange(Sender: TObject);
begin
  RefreshColor();
end;

procedure TBGColor.RefreshColor();
var i: Integer;
begin

  if (RedSpin.Value = 15) and (GreenSpin.Value = 15) and (BlueSpin.Value = 15) then
  begin
  Image1.Canvas.Brush.Color := clWhite;
    for i := 0 to 15 do
      Palettes[i][0] := clWhite;
  end
  else
  begin
  Image1.Canvas.Brush.Color := RGB(RedSpin.Value*16,GreenSpin.Value*16,BlueSpin.Value*16);
    for i := 0 to 15 do
      Palettes[i][0] := RGB(RedSpin.Value*16,GreenSpin.Value*16,BlueSpin.Value*16);
  end;
  Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
  CommonInst.Redraw;
end;

end.
