{
  A very quick and basic style implementation. It took all of 10 minutes.
  To apply this style, follow these instructions:

    * free the old fpgStyle
    * instantiate the new style class
    * and assign this new instance to fpgStyle variable


  Example:

    procedure MainProc;
    var
      frm: TMainForm;
    begin
      fpgApplication.Initialize;
      frm := TMainForm.Create(nil);
      try
        // Free the old and set the new style
        if Assigned(fpgStyle) then
          fpgStyle.Free;
        fpgStyle := TMyStyle.Create;

        // now continue with the application
        frm.Show;
        fpgApplication.Run;
      finally
        frm.Free;
      end;
    end;

}
unit mystyle;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpg_main, fpg_base;

type
  TMyStyle = class(TfpgStyle)
  public
    constructor Create; override;
    procedure DrawControlFrame(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord); override;
    procedure DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord; AFlags: TFButtonFlags); override;
  end;


implementation

{ TMyStyle }

constructor TMyStyle.Create;
begin
  inherited Create;
  fpgSetNamedColor(clWindowBackground, TfpgColor($eeeeec));
end;

procedure TMyStyle.DrawControlFrame(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord);
var
  r: TfpgRect;
begin
  r.SetRect(x, y, w, h);
  ACanvas.SetColor(clShadow1);
  ACanvas.Clear(clYellow);
  ACanvas.DrawRectangle(r);
end;

procedure TMyStyle.DrawButtonFace(ACanvas: TfpgCanvas; x, y, w, h: TfpgCoord; AFlags: TFButtonFlags);
var
  r: TfpgRect;
begin
  r.SetRect(x, y, w, h);

  if btfIsDefault in AFlags then
  begin
    ACanvas.SetColor(TfpgColor($7b7b7b));
    ACanvas.SetLineStyle(1, lsSolid);
    ACanvas.DrawRectangle(r);
    InflateRect(r, -1, -1);
    Exclude(AFlags, btfIsDefault);
    fpgStyle.DrawButtonFace(ACanvas, r.Left, r.Top, r.Width, r.Height, AFlags);
    Exit; //==>
  end;

  // Clear the canvas
  ACanvas.SetColor(clWindowBackground);
  ACanvas.FillRectangle(r);

  if (btfFlat in AFlags) and not (btfIsPressed in AFlags) then
    Exit; // no need to go further

  // outer rectangle
  ACanvas.SetLineStyle(1, lsSolid);
  ACanvas.SetColor(TfpgColor($a6a6a6));
  ACanvas.DrawRectangle(r);

  // so we don't paint over the border
  InflateRect(r, -1, -1);
  // now paint the face of the button
  if (btfIsPressed in AFlags) then
  begin
    ACanvas.GradientFill(r, TfpgColor($cccccc), TfpgColor($e4e4e4), gdVertical);
  end
  else
  begin
    ACanvas.GradientFill(r, TfpgColor($fafafa), TfpgColor($e2e2e2), gdVertical);
    ACanvas.SetColor(TfpgColor($cccccc));
    ACanvas.DrawLine(r.Right, r.Top, r.Right, r.Bottom);   // right
    ACanvas.DrawLine(r.Right, r.Bottom, r.Left, r.Bottom);   // bottom
  end;
end;

end.

