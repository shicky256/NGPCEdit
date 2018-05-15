unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.FileCtrl, Vcl.Menus,
  Vcl.ToolWin, Vcl.ComCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.Samples.Spin, Math, Unit2, Palette;

type
  TEditor = class(TForm)
    MainMenu1: TMainMenu;
    FileMenu: TMenuItem;
    Exit1: TMenuItem;
    ToolBar1: TToolBar;
    Color1: TSpeedButton;
    Color2: TSpeedButton;
    Color3: TSpeedButton;
    Color4: TSpeedButton;
    DrawGrid1: TDrawGrid;
    ScalingSpin: TSpinEdit;
    ScalingLabel: TLabel;
    XLabel: TLabel;
    XSpin: TSpinEdit;
    YLabel: TLabel;
    YSpin: TSpinEdit;
    Export: TMenuItem;
    DrawButton: TSpeedButton;
    SelectButton: TSpeedButton;
    StatusBar1: TStatusBar;
    PaletteLabel: TLabel;
    PaletteSpin: TSpinEdit;
    Palette1: TMenuItem;
    Edit: TMenuItem;
    Import: TMenuItem;
    ExportPalette1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Color1Click(Sender: TObject);
    procedure Color2Click(Sender: TObject);
    procedure Color3Click(Sender: TObject);
    procedure Color4Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ScalingSpinChange(Sender: TObject);
    procedure XSpinChange(Sender: TObject);
    procedure YSpinChange(Sender: TObject);
    procedure ExportClick(Sender: TObject);
    procedure DrawButtonClick(Sender: TObject);
    procedure SelectButtonClick(Sender: TObject);
    procedure PaletteSpinChange(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure ExportPalette1Click(Sender: TObject);
    procedure ImportClick(Sender: TObject);
    procedure SetPixelValue(x, y: Integer; value: Byte);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TTile = array[0..8, 0..8] of Byte;
  TPalette = array[0..3] of TColor;
const
  DEFAULT_COLORS : array [0..3] of TColor = (clWhite, clLtGray, clDkGray, clBlack);
  PIXELS_PER_TILE = 8;
  GRID_PADDING = 1; //num of pixels to pad out grid by
  WINDOW_X_PADDING = 40;
  WINDOW_Y_PADDING = 120;
  MIN_WINDOW_WIDTH = 725;
  MIN_WINDOW_HEIGHT = 379;
  MAX_GRID_WIDTH = 1500;
  MAX_GRID_HEIGHT = 900;
  TAB = #9;
  NEWLINE = #13#10;
var
  Editor: TEditor;
  CurrColor: Integer; //current color (1=black, 4=white)
  ScalingFactor: Integer;
  NumTilesX, NumTilesY: Integer;
  SelectedX, SelectedY: Integer; //selected TILE not pixel
  TileMap: array of array of TTile;
  PaletteIndexes: array of array of Integer;
  IsDrawing: Boolean;

implementation

{$R *.dfm}

procedure TEditor.FormCreate(Sender: TObject); //init procedure
var i, j: Integer;
begin
  CurrColor := 0;
  ScalingFactor := 3;
  ScalingSpin.Value := 3;
  NumTilesX := 1;
  NumTilesY := 1;
  IsDrawing := False;
  SelectButton.Down := True;
  SetLength(TileMap, NumTilesX, NumTilesY);
  SetLength(PaletteIndexes, NumTilesX, NumTilesY);
  for i := 0 to 15 do
    for j := 0 to 3 do
      Palettes[i][j] := DEFAULT_COLORS[j];
end;

procedure TEditor.ImportClick(Sender: TObject);
var
 OpenDialog: TOpenDialog;
 Image: TBitmap;
 Line: pByteArray;
 i, j: Integer;
begin
  OpenDialog := TOpenDialog.Create(self);
  OpenDialog.Options := [ofFileMustExist];
  OpenDialog.Title := 'Find an image to import from';
  OpenDialog.Filter := '8-bit greyscale bitmap|*.bmp';
  OpenDialog.FilterIndex := 1;
  if OpenDialog.Execute then
  begin
    Image := TBitmap.Create;
    Image.LoadFromFile(OpenDialog.FileName);
    XSpin.Value := Image.Width div PIXELS_PER_TILE;
    YSpin.Value := Image.Height div PIXELS_PER_TILE;
    for i := 0 to Image.Height - 1 do
    begin
      Line := pByteArray(Image.ScanLine[i]);
      for j := 0 to Image.Width - 1 do
      begin
        if Line[j] < 64 then
          SetPixelValue(j, i, 3)
        else if Line[j] < 128 then
          SetPixelValue(j, i, 2)
        else if Line[j] < 192 then
          SetPixelValue(j, i, 1)
        else
          SetPixelValue(j, i, 0);
      end;
    end;
  end;
end;

//makes TileMap addressable like a 2d array of pixels
procedure TEditor.SetPixelValue(x, y: Integer; value: Byte);
begin
  TileMap[x div PIXELS_PER_TILE][y div PIXELS_PER_TILE][x mod PIXELS_PER_TILE][y mod PIXELS_PER_TILE] := value;
end;

procedure TEditor.PaletteSpinChange(Sender: TObject);
begin
  PaletteIndexes[SelectedX][SelectedY] := PaletteSpin.Value;
  DrawGrid1.Invalidate;
end;

procedure TEditor.ScalingSpinChange(Sender: TObject);
begin
  ScalingFactor := ScalingSpin.Value;
  DrawGrid1.DefaultColWidth := ScalingFactor;
  DrawGrid1.DefaultRowHeight := ScalingFactor;
  DrawGrid1.Invalidate;
end;

procedure TEditor.XSpinChange(Sender: TObject);
var
  i, j: Integer;
  BlankTile: TTile;
begin
  SetLength(TileMap, XSpin.Value, NumTilesY);
  if NumTilesX < XSpin.Value then
  begin
    for i := 0 to PIXELS_PER_TILE - 1 do
      for j := 0 to PIXELS_PER_TILE - 1 do
        BlankTile[i][j] := 0;

    for j := 0 to NumTilesY - 1 do
      for i := NumTilesX to XSpin.Value - 1 do
        TileMap[i][j] := BlankTile;
  end;
  NumTilesX := XSpin.Value;
  //SetLength(TileMap, NumTilesX, NumTilesY);
  SetLength(PaletteIndexes, NumTilesX, NumTilesY);
  DrawGrid1.ColCount := NumTilesX * PIXELS_PER_TILE;
  if NumTilesX*PIXELS_PER_TILE*ScalingFactor + XSpin.Value * GRID_PADDING < MAX_GRID_WIDTH then
    DrawGrid1.Width := NumTilesX*PIXELS_PER_TILE*ScalingFactor + XSpin.Value * GRID_PADDING
  else
    DrawGrid1.Width := MAX_GRID_WIDTH;
  DrawGrid1.Invalidate;
  if Self.WindowState <> wsMaximized then
    Editor.Width := Max(DrawGrid1.Width + WINDOW_X_PADDING, MIN_WINDOW_WIDTH);
end;

procedure TEditor.YSpinChange(Sender: TObject);
var
  i, j: Integer;
  BlankTile: TTile;
begin
  SetLength(TileMap, NumTilesX, YSpin.Value);
  if NumTilesY < YSpin.Value then
  begin
    for i := 0 to PIXELS_PER_TILE - 1 do
      for j := 0 to PIXELS_PER_TILE - 1 do
        BlankTile[i][j] := 0;

    for j := NumTilesY to YSpin.Value - 1 do
      for i := 0 to NumTilesX - 1 do
        TileMap[i][j] := BlankTile;
  end;
  NumTilesY := YSpin.Value;
  SetLength(PaletteIndexes, NumTilesX, NumTilesY);
  DrawGrid1.RowCount := NumTilesY * PIXELS_PER_TILE;
  if NumTilesY*PIXELS_PER_TILE*ScalingFactor * GRID_PADDING < MAX_GRID_HEIGHT then
    DrawGrid1.Height := NumTilesY*PIXELS_PER_TILE*ScalingFactor * GRID_PADDING
  else
    DrawGrid1.Height := MAX_GRID_HEIGHT;
  DrawGrid1.Invalidate;
  if Self.WindowState <> wsMaximized then
    Editor.Height := Max(DrawGrid1.Height + WINDOW_Y_PADDING, MIN_WINDOW_HEIGHT);
end;

procedure TEditor.Color1Click(Sender: TObject);
begin
  CurrColor := 0;
end;

procedure TEditor.Color2Click(Sender: TObject);
begin
  CurrColor := 1;
end;

procedure TEditor.Color3Click(Sender: TObject);
begin
  CurrColor := 2;
end;

procedure TEditor.Color4Click(Sender: TObject);
begin
  CurrColor := 3;
end;

procedure TEditor.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var TileX, TileY, PixelX, PixelY: Integer;
begin
  TileX := ACol div PIXELS_PER_TILE;
  TileY := ARow div PIXELS_PER_TILE;
  PixelX := ACol mod PIXELS_PER_TILE;
  PixelY := ARow mod PIXELS_PER_TILE;
  DrawGrid1.Canvas.Brush.Color := Palettes[PaletteIndexes[TileX,TileY]][TileMap[TileX,TileY][PixelX,PixelY]];
  DrawGrid1.Canvas.FillRect(Rect);
end;

procedure TEditor.DrawButtonClick(Sender: TObject);
begin
  IsDrawing := True;
end;

procedure TEditor.SelectButtonClick(Sender: TObject);
begin
  IsDrawing := False;
end;

//procedure TEditor.DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
//  Shift: TShiftState; X, Y: Integer);
//begin
//  TileMap[((X - DrawGrid1.Left) div ScalingFactor), (Y div ScalingFactor)] := CurrColor;
//  IsDrawing := True;
//  DrawGrid1.Invalidate;
//end;
//
//procedure TEditor.DrawGrid1MouseLeave(Sender: TObject);
//begin
//  IsDrawing := False;
//end;
//
//procedure TEditor.DrawGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
//  Y: Integer);
//var
//  XArrIndex, YArrIndex: Integer;
//begin
//  XArrIndex := (X - DrawGrid1.Left) div ScalingFactor;
//  YArrIndex := Y div ScalingFactor;
//  if IsDrawing and (XArrIndex < NumTilesX) and (YArrIndex < NumTilesY) then
//    begin
//        TileMap[((X - DrawGrid1.Left) div ScalingFactor), (Y div ScalingFactor)] := CurrColor;
//        DrawGrid1.Invalidate;
//    end;
//end;
//
//procedure TEditor.DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton;
//  Shift: TShiftState; X, Y: Integer);
//begin
//  IsDrawing := False;
//  DrawGrid1.Invalidate;
//end;

procedure TEditor.DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var TileX, TileY, PixelX, PixelY: Integer;
begin
  TileX := ACol div PIXELS_PER_TILE;
  TileY := ARow div PIXELS_PER_TILE;
  SelectedX := TileX;
  SelectedY := TileY;
  PaletteSpin.Value := PaletteIndexes[SelectedX][SelectedY];
  PixelX := ACol mod PIXELS_PER_TILE;
  PixelY := ARow mod PIXELS_PER_TILE;
  if IsDrawing then
  begin
    TileMap[TileX,TileY][PixelX,PixelY] := CurrColor;
    DrawGrid1.Invalidate;
  end;
  StatusBar1.Panels[0].Text := 'Selected Tile X: ' + IntToStr(TileX) + ' Y: ' + IntToStr(TileY);
end;

procedure TEditor.EditClick(Sender: TObject);
begin
  ColorPicker.Show;
end;

procedure TEditor.Exit1Click(Sender: TObject);
begin
  Editor.Close;
end;
procedure TEditor.ExportClick(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  ExportFile: TextFile;
  i, j, k: Integer;
  HexString: String;
begin
  SaveDialog := TSaveDialog.Create(self);
  SaveDialog.Title := 'Enter a filename to export to';
  SaveDialog.Filter := 'C source|*.c';
  SaveDialog.DefaultExt := 'c';
  SaveDialog.FilterIndex := 1;
  if SaveDialog.Execute then
  begin
    AssignFile(ExportFile, SaveDialog.FileName);
    SaveDialog.Free;
    ReWrite(ExportFile);
    WriteLn(ExportFile,'const unsigned short Tiles[' +
      IntToStr(NumTilesX * NumTilesY) + '][' + IntToStr(PIXELS_PER_TILE) + '] = {');
    for j := 0 to NumTilesY - 1 do
      for i := 0 to NumTilesX - 1 do
      begin
        Write(ExportFile, TAB + TAB + '{');
        for k := 0 to PIXELS_PER_TILE - 1 do
        begin
          if k <> 0 then
             Write(ExportFile, ', ');
          HexString := IntToHex(TileMap[i][j][7][k] or (TileMap[i][j][6][k] shl 2) or
            (TileMap[i][j][5][k] shl 4) or (TileMap[i][j][4][k] shl 6) or (TileMap[i][j][3][k] shl 8) or
            (TileMap[i][j][2][k] shl 10) or (TileMap[i][j][1][k] shl 12) or (TileMap[i][j][0][k] shl 14));
          HexString := copy(HexString,5,4);
          Write(ExportFile,'0x' + HexString);
        end;
        if (i < NumTilesY-1) or (j < NumTilesX-1) then
          WriteLn(ExportFile, '},')
        else
          WriteLn(ExportFile, '}');
      end;
    Writeln(ExportFile, '};');
    CloseFile(ExportFile);
  end
  else
    SaveDialog.Free;

end;

procedure TEditor.ExportPalette1Click(Sender: TObject);
var
  SaveDialog: TSaveDialog;
  ExportFile: TextFile;
  i: Integer;
  Color: TColor;
begin
  SaveDialog := TSaveDialog.Create(self);
  SaveDialog.Title := 'Enter a filename to export to';
  SaveDialog.Filter := 'C source|*.c';
  SaveDialog.DefaultExt := 'c';
  SaveDialog.FilterIndex := 1;
  if SaveDialog.Execute then
  begin
    AssignFile(ExportFile, SaveDialog.FileName);
    SaveDialog.Free;
    ReWrite(ExportFile);
    WriteLn(ExportFile,'const u16 palettes[15][3] = {');
    for i := 0 to 15 do
    begin
        if i <> 0 then
          Write(ExportFile, ', ' + NEWLINE);
        Write(ExportFile, TAB + '{');
        Color := Palettes[i][1]; //don't write color 0 because it's transparent
        Write(ExportFile, 'RGB(' + IntToStr(GetRValue(ColorToRGB(Color)) div 16) + ', ' +
          IntToStr(GetGValue(ColorToRGB(Color)) div 16) + ', ' +
          IntToStr(GetBValue(ColorToRGB(Color)) div 16) + '), ');
        Color := Palettes[i][2];
        Write(ExportFile, 'RGB(' + IntToStr(GetRValue(ColorToRGB(Color)) div 16) + ', ' +
          IntToStr(GetGValue(ColorToRGB(Color)) div 16) + ', ' +
          IntToStr(GetBValue(ColorToRGB(Color)) div 16) + '), ');
        Color := Palettes[i][3];
        Write(ExportFile, 'RGB(' + IntToStr(GetRValue(ColorToRGB(Color)) div 16) + ', ' +
          IntToStr(GetGValue(ColorToRGB(Color)) div 16) + ', ' +
          IntToStr(GetBValue(ColorToRGB(Color)) div 16) + ')}');
    end;
    Write(ExportFile, NEWLINE + '};');
    CloseFile(ExportFile);
  end
  else
    SaveDialog.Free
end;

end.
