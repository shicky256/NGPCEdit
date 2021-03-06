unit Color;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.ComCtrls, Common;

type
  TColorPicker = class(TForm)
    RedLabel: TLabel;
    RedSpin: TSpinEdit;
    GreenLabel: TLabel;
    BlueLabel: TLabel;
    GreenSpin: TSpinEdit;
    BlueSpin: TSpinEdit;
    PreviewLabel: TLabel;
    Image1: TImage;
    PaletteLabel: TLabel;
    PaletteSpin: TSpinEdit;
    ColorLabel: TLabel;
    ColorSpin: TSpinEdit;
    procedure RedSpinChange(Sender: TObject);
    procedure GreenSpinChange(Sender: TObject);
    procedure BlueSpinChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PaletteSpinChange(Sender: TObject);
    procedure ColorSpinChange(Sender: TObject);
    procedure HandleColorChange;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ColorPicker: TColorPicker;
  CommonInst: TCommon;
  ShouldRedraw: Boolean; //keeps cascading redraws from ruining performance

implementation


{$R *.dfm}

procedure TColorPicker.BlueSpinChange(Sender: TObject);
begin
  HandleColorChange();
end;

procedure TColorPicker.ColorSpinChange(Sender: TObject);
var color: TColor;
begin
  color := Palettes[PaletteSpin.Value][ColorSpin.Value];
  ShouldRedraw := False; //don't need to redraw image when you're just changing which color to display
  RedSpin.Value := GetRValue(ColorToRGB(color)) div 16;
  GreenSpin.Value := GetGValue(ColorToRGB(color)) div 16;
  BlueSpin.Value := GetBValue(ColorToRGB(color)) div 16;
  ShouldRedraw := True;
  Image1.Canvas.Brush.Color := Palettes[PaletteSpin.Value][ColorSpin.Value];
  Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
end;

procedure TColorPicker.FormCreate(Sender: TObject);
var color: TColor;
begin
  PaletteSpin.Value := 0;
  ColorSpin.Value := 1;
  color := Palettes[PaletteSpin.Value][ColorSpin.Value];
  ShouldRedraw := False; //don't need to redraw image when you create the form
  RedSpin.Value := GetRValue(ColorToRGB(color)) div 16;
  GreenSpin.Value := GetGValue(ColorToRGB(color)) div 16;
  BlueSpin.Value := GetBValue(ColorToRGB(color)) div 16;
  ShouldRedraw := True;
  Image1.Canvas.Brush.Color := Palettes[PaletteSpin.Value][ColorSpin.Value];
  Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
end;

procedure TColorPicker.GreenSpinChange(Sender: TObject);
begin
  HandleColorChange();
end;

procedure TColorPicker.PaletteSpinChange(Sender: TObject);
var color: TColor;
begin
  color := Palettes[PaletteSpin.Value][ColorSpin.Value];
  ShouldRedraw := False; //don't need to redraw image when you're just changing the palette
  RedSpin.Value := GetRValue(ColorToRGB(color)) div 16;
  GreenSpin.Value := GetGValue(ColorToRGB(color)) div 16;
  BlueSpin.Value := GetBValue(ColorToRGB(color)) div 16;
  ShouldRedraw := True;
  Image1.Canvas.Brush.Color := Palettes[PaletteSpin.Value][ColorSpin.Value];
  Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
end;

procedure TColorPicker.RedSpinChange(Sender: TObject);
begin
  HandleColorChange();
end;

procedure TColorPicker.HandleColorChange();
begin
  //multiply by 16 because ngpc palette vals are from 0-15 while delphi vals are from 0-255
  Image1.Canvas.Brush.Color := RGB(RedSpin.Value*16,GreenSpin.Value*16,BlueSpin.Value*16);
  Palettes[PaletteSpin.Value][ColorSpin.Value] := RGB(RedSpin.Value*16,GreenSpin.Value*16,BlueSpin.Value*16);
  Image1.Canvas.FillRect(Rect(0,0,Image1.Width,Image1.Height));
  if ShouldRedraw then
    CommonInst.Redraw;
end;

end.
