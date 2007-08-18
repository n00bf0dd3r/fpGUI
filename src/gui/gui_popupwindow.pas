unit gui_popupwindow;

{$mode objfpc}{$H+}

{
  Still under construction!!!!!
}

interface

uses
  Classes,
  SysUtils,
  gfxbase,
  fpgfx,
  gfx_widget;
  
type
  TfpgPopupWindow = class(TfpgWidget)
  protected
    procedure   MsgClose(var msg: TfpgMessageRec); message FPGM_CLOSE;
    procedure   AdjustWindowStyle; override;
    procedure   SetWindowParameters; override;
    procedure   HandleShow; override;
    procedure   HandleHide; override;
    procedure   HandleClose; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure   ShowAt(AWidget: TfpgWidget; x, y: TfpgCoord);
    procedure   Close;
  end;


implementation


type
  // Popup window linked list. Maybe we can implemnt it via a TList as well.
  PPopupListRec = ^PopupListRec;
  PopupListRec = record
    Widget: TfpgPopupWindow;
    Next: PPopupListRec;
  end;

var
  uOriginalFocusRoot: TfpgWidget;
  uFirstPopup: PPopupListRec;
  uLastPopup: PPopupListRec;
  
  
// local helper functions

procedure ClosePopups;
begin
  while uFirstPopup <> nil do
  begin
    TfpgPopupWindow(uFirstPopup^.Widget).Close;
  end;
end;

procedure PopupListAdd(pw: TfpgPopupWindow);
var
  p: PPopupListRec;
begin
  if pw = nil then
    Exit; //==>

  if uFirstPopup = nil then
    uOriginalFocusRoot := FocusRootWidget;

  FocusRootWidget := pw;

  New(p);
  p^.Widget := pw;
  p^.Next := nil;
  if uFirstPopup = nil then
    uFirstPopup := p
  else
    uLastPopup^.Next := p;
  uLastPopup := p;
end;

procedure PopupListRemove(pw: TfpgPopupWindow);
var
  prevp: PPopupListRec;
  p: PPopupListRec;
  px: PPopupListRec;
begin
  p := uFirstPopup;
  prevp := nil;

  while p <> nil do
  begin
    if p^.Widget = pw then
    begin
      if prevp = nil then
        uFirstPopup := p^.Next
      else
        prevp^.Next := p^.Next;
      if uLastPopup = p then
        uLastPopup := prevp;
      px := p;
      p := p^.Next;
      Dispose(px);
    end
    else
    begin
      prevp := p;
      p := p^.Next;
    end;
  end;

  if uLastPopup <> nil then
    FocusRootWidget := uLastPopup^.Widget
  else
    FocusRootWidget := uOriginalFocusRoot;
end;

function PopupListFirst: TfpgPopupWindow;
begin
  if uFirstPopup <> nil then
    Result := uFirstPopup^.Widget
  else
    Result := nil;
end;

{
function PopupListFind(AWinHandle: TfpgWinHandle): TfpgPopupWindow;
var
  p: PPopupListRec;
begin
  p := uFirstPopup;
  while p <> nil do
  begin
    if p^.Widget.WinHandle = AWinHandle then
    begin
      Result := p^.Widget;
      Exit; //==>
    end;
    p := p^.Next;
  end;
  Result := nil;
end;
}

{ TfpgPopupWindow }

procedure TfpgPopupWindow.MsgClose(var msg: TfpgMessageRec);
begin
  HandleClose;
end;

procedure TfpgPopupWindow.AdjustWindowStyle;
begin
  inherited AdjustWindowStyle;
  // We could possibly change this later
  Exclude(FWindowAttributes, waSizeable);
end;

procedure TfpgPopupWindow.SetWindowParameters;
begin
  inherited SetWindowParameters;
end;

procedure TfpgPopupWindow.HandleShow;
begin
  inherited HandleShow;
  CaptureMouse;
end;

procedure TfpgPopupWindow.HandleHide;
begin
  ReleaseMouse;
  inherited HandleHide;
end;

procedure TfpgPopupWindow.HandleClose;
begin
  HandleHide;
end;

constructor TfpgPopupWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WindowType := wtPopup;
end;

procedure TfpgPopupWindow.ShowAt(AWidget: TfpgWidget; x, y: TfpgCoord);
var
  pt: TPoint;
begin
  // translate coordinates
  pt    := WindowToScreen(AWidget, Point(x, y));
  // reposition
  Left  := pt.X;
  Top   := pt.Y;
  // and show
  HandleShow;
end;

procedure TfpgPopupWindow.Close;
begin
  HandleHide;
end;


initialization
  uFirstPopup := nil;
  uLastPopup  := nil;

end.

