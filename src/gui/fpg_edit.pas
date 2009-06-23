{
    fpGUI  -  Free Pascal GUI Toolkit

    Copyright (C) 2006 - 2008 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      Defines a Text Edit control. Also known a Text Entry control.
}

// Future enhancements:
{ TODO -cEventHandler : OnSetText - same as OnSetValue but before SetValue. }
{ TODO -cEventHandler : OnGetText - Returns a string used for displaying in GUI. May be different to Value property.
                         Add extra parameter so we know if we need to display the formatted text
                         or the 'value' text. The latter is for when the component has focus. }
{ TODO -cEventHandler : OnTextEdited - per character evaluation. }
{ TODO -cEventHandler : OnSetValue - fired after ENTER but before Value is set. AValue can be rejected or changed. }
{ TODO -cEventHandler : OnDataEntered - fired after new value has been accepted and Value property has been set. }

unit fpg_edit;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  fpg_base,
  fpg_main,
  fpg_widget,
  fpg_menu;

type
  TfpgEditBorderStyle = (ebsNone, ebsDefault, ebsSingle);


  TfpgBaseEdit = class(TfpgWidget)
  private
    FAutoSelect: Boolean;
    FHideSelection: Boolean;
    FPopupMenu: TfpgPopupMenu;
    FDefaultPopupMenu: TfpgPopupMenu;
    FText: string;
    FPasswordMode: Boolean;
    FBorderStyle: TfpgEditBorderStyle;
    FOnChange: TNotifyEvent;
    FMaxLength: integer;
    FSelecting: Boolean;
    procedure   Adjust(UsePxCursorPos: boolean = false); virtual;
    procedure   AdjustTextOffset(UsePxCursorPos: boolean); virtual;
    procedure   AdjustDrawingInfo; virtual;
    // function    PointToCharPos(x, y: integer): integer;
    procedure   DeleteSelection;
    procedure   DoCopy;
    procedure   DoPaste;
    procedure   SetAutoSelect(const AValue: Boolean);
    procedure   SetBorderStyle(const AValue: TfpgEditBorderStyle);
    procedure   SetHideSelection(const AValue: Boolean);
    procedure   SetPasswordMode(const AValue: boolean);
    function    GetFontDesc: string;
    procedure   SetFontDesc(const AValue: string);
    procedure   SetText(const AValue: string);
    procedure   SetSideMargin(const AValue: integer);
    procedure   SetHeightMargin(const AValue: integer);
    procedure   DefaultPopupCut(Sender: TObject);
    procedure   DefaultPopupCopy(Sender: TObject);
    procedure   DefaultPopupPaste(Sender: TObject);
    procedure   DefaultPopupClearAll(Sender: TObject);
    procedure   SetDefaultPopupMenuItemsState;
  protected
    FFont: TfpgFont;
    FSideMargin: integer;
    FHeightMargin: integer;
    FMouseDragPos: integer;
    FSelStart: integer;
    FSelOffset: integer;
    FCursorPos: integer; // Caret position (characters)
    FCursorPx: integer;  // Caret position (pixels)
    FTextOffset: integer;
    FDrawOffset: integer;
    FVisibleText: TfpgString;
    FVisSelStartPx: integer;
    FVisSelEndPx: integer;
    function    GetMarginAdjustment: integer; virtual;
    procedure   DrawSelection; virtual;
    procedure   DoOnChange; virtual;
    procedure   ShowDefaultPopupMenu(const x, y: integer; const shiftstate: TShiftState); virtual;
    procedure   HandlePaint; override;
    procedure   HandleResize(awidth, aheight: TfpgCoord); override;
    procedure   HandleKeyChar(var AText: TfpgChar; var shiftstate: TShiftState; var consumed: Boolean); override;
    procedure   HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: Boolean); override;
    procedure   HandleLMouseDown(x, y: integer; shiftstate: TShiftState); override;
    procedure   HandleRMouseDown(x, y: integer; shiftstate: TShiftState); override;
    procedure   HandleRMouseUp(x, y: integer; shiftstate: TShiftState); override;
    procedure   HandleMouseMove(x, y: integer; btnstate: word; shiftstate: TShiftState); override;
    procedure   HandleDoubleClick(x, y: integer; button: word; shiftstate: TShiftState); override;
    procedure   HandleMouseEnter; override;
    procedure   HandleMouseExit; override;
    procedure   HandleSetFocus; override;
    procedure   HandleKillFocus; override;
    procedure   HandleHide; override;
    function    GetDrawText: String;
    property    AutoSelect: Boolean read FAutoSelect write SetAutoSelect default True;
    property    BorderStyle: TfpgEditBorderStyle read FBorderStyle write SetBorderStyle default ebsDefault;
    property    FontDesc: String read GetFontDesc write SetFontDesc;
    property    HideSelection: Boolean read FHideSelection write SetHideSelection default True;
    property    MaxLength: Integer read FMaxLength write FMaxLength;
    property    PasswordMode: Boolean read FPasswordMode write SetPasswordMode default False;
    property    PopupMenu: TfpgPopupMenu read FPopupMenu write FPopupMenu;
    property    Text: String read FText write SetText;
    property    OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    function    SelectionText: string;
    procedure   SelectAll;
    procedure   Clear;
    procedure   ClearSelection;
    procedure   CopyToClipboard;
    procedure   CutToClipboard;
    function    GetClientRect: TfpgRect; override;
    procedure   PasteFromClipboard;
    property    Font: TfpgFont read FFont;
    property    SideMargin: integer read FSideMargin write SetSideMargin default 3;
    property    HeightMargin: integer read FHeightMargin write SetHeightMargin default 2;
  end;


  TfpgBaseTextEdit = class(TfpgBaseEdit)
  private
    FExtraHint: string;
    procedure   SetExtraHint(const AValue: string);
  protected
    procedure   HandlePaint; override;
    property    ExtraHint: string read FExtraHint write SetExtraHint;
  public
    constructor Create(AOwner: TComponent); override;
  end;


  TfpgEdit = class(TfpgBaseTextEdit)
  public
    property    PopupMenu;  // UI Designer doesn't fully support it yet
  published
    property    AutoSelect;
    property    BackgroundColor default clBoxColor;
    property    BorderStyle;
    property    ExtraHint;
    property    FontDesc;
    property    HeightMargin;
    property    HideSelection;
    property    MaxLength;
    property    ParentShowHint;
    property    PasswordMode;
    property    ShowHint;
    property    SideMargin;
    property    TabOrder;
    property    Text;
    property    TextColor;
    property    OnChange;
    property    OnEnter;
    property    OnExit;
    property    OnKeyPress;
    property    OnMouseEnter;
    property    OnMouseExit;
    property    OnPaint;
  end;


  TfpgBaseNumericEdit = class(TfpgBaseEdit)
  private
    FDecimals: integer;
    FOldColor: TfpgColor;
    FAlignment: TAlignment;
    FDecimalseparator: TfpgChar;
    FNegativeColor: TfpgColor;
    FThousandSeparator: TfpgChar;
    FShowThousand: boolean;
    procedure   AdjustTextOffset(UsePxCursorPos: boolean); override;
    procedure   AdjustDrawingInfo; override;
    procedure   SetOldColor(const AValue: TfpgColor);
    procedure   SetAlignment(const AValue: TAlignment);
    procedure   SetDecimalSeparator(const AValue: TfpgChar);
    procedure   SetNegativeColor(const AValue: TfpgColor);
    procedure   SetThousandSeparator(const AValue: TfpgChar);
    procedure   SetShowThousand;
  protected
    function    GetMarginAdjustment: integer; override;
    procedure   HandlePaint; override;
    procedure   FormatEdit; virtual;
    procedure   Justify; virtual; // to implement in derived classes
    property    OldColor: TfpgColor read FOldColor write SetOldColor;
    property    Alignment: TAlignment read FAlignment write SetAlignment default taRightJustify;
    property    AutoSelect;
    property    BackgroundColor default clBoxColor;
    property    BorderStyle;
    {Someone likes to use English operating system but localized decimal and thousand separators
     Still to implement !!}
    property    CustomDecimalSeparator: TfpgChar read FDecimalseparator write SetDecimalSeparator;
    property    CustomThousandSeparator: TfpgChar read FThousandSeparator write SetThousandSeparator;
    property    NegativeColor: TfpgColor read FNegativeColor write SetNegativeColor;
    property    HideSelection;
//    property    MaxLength;  { probably MaxValue and MinValue }
    property    TabOrder;
    property    TextColor;
    property    ShowThousand: boolean read FShowThousand write FShowThousand default False;
    property    OnChange;
    property    OnEnter;
    property    OnExit;
    property    OnKeyPress;
    property    OnMouseEnter;
    property    OnMouseExit;
    property    OnPaint;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property    FontDesc;
  end;


  TfpgEditInteger = class(TfpgBaseNumericEdit)
  protected
    function    GetValue: integer; virtual;
    procedure   SetValue(const AValue: integer); virtual;
    procedure   HandleKeyChar(var AText: TfpgChar; var shiftstate: TShiftState; var consumed: Boolean); override;
    procedure   HandleSetFocus; override;
    procedure   HandleKillFocus; override;
    procedure   HandlePaint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property    OldColor;
    property    Text;
  published
    property    CustomThousandSeparator;
    property    NegativeColor;
    property    ParentShowHint;
    property    ShowHint;
    property    ShowThousand default True;
    property    TabOrder;
    property    TextColor;
    property    Value: integer read GetValue write SetValue;
    property    OnChange;
    property    OnEnter;
    property    OnExit;
    property    OnKeyPress;
    property    OnMouseEnter;
    property    OnMouseExit;
    property    OnMouseMove;
  end;


  TfpgEditFloat = class(TfpgBaseNumericEdit)
  private
    FFixedDecimals: boolean;
  protected
    function    GetValue: extended; virtual;
    procedure   SetValue(const AValue: extended); virtual;
    procedure   SetDecimals(const AValue: integer);
    procedure   SetFixedDecimals(const AValue: boolean);
    procedure   HandleKeyChar(var AText: TfpgChar; var shiftstate: TShiftState; var consumed: Boolean); override;
    procedure   HandleSetFocus; override;
    procedure   HandleKillFocus; override;
    procedure   HandlePaint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property    OldColor;
    property    Text;
  published
    property    Decimals: integer read FDecimals write SetDecimals default -1;
    property    CustomDecimalSeparator;
    property    FixedDecimals: boolean read FFixedDecimals write SetFixedDecimals default False;
    property    NegativeColor;
    property    ShowThousand default True;
    property    TabOrder;
    property    TextColor;
    property    CustomThousandSeparator;
    property    Value: extended read GetValue write SetValue;
    property    ParentShowHint;
    property    ShowHint;
    property    OnChange;
    property    OnEnter;
    property    OnExit;
    property    OnKeyPress;
    property    OnMouseEnter;
    property    OnMouseExit;
    property    OnMouseMove;
  end;


  TfpgEditCurrency = class(TfpgBaseNumericEdit)
  protected
    function    GetValue: Currency; virtual;
    procedure   SetValue(const AValue: Currency); virtual;
    procedure   SetDecimals(AValue: integer);
    procedure   HandleKeyChar(var AText: TfpgChar; var shiftstate: TShiftState; var consumed: Boolean); override;
    procedure   HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: Boolean); override;
    procedure   HandleSetFocus; override;
    procedure   HandleKillFocus; override;
    procedure   HandlePaint; override;
  public
    constructor Create(AOwner: TComponent); override;
    property    OldColor;
    property    Text;
  published
    property    Decimals: integer read FDecimals write SetDecimals default 2;
    property    NegativeColor;
    property    CustomDecimalSeparator;
    property    CustomThousandSeparator;
    property    ShowThousand default True;
    property    Value: Currency read GetValue write SetValue;
    property    ParentShowHint;
    property    ShowHint;
    property    TabOrder;
    property    OnChange;
    property    OnEnter;
    property    OnExit;
    property    OnKeyPress;
    property    OnMouseEnter;
    property    OnMouseExit;
  end;


function CreateEdit(AOwner: TComponent; x, y, w, h: TfpgCoord): TfpgEdit;

function CreateEditInteger(AOwner: TComponent; x, y, w, h: TfpgCoord;
    AShowThousand: boolean= True): TfpgEditInteger;

function CreateEditFloat(AOwner: TComponent; x, y, w, h: TfpgCoord;
    AShowThousand: boolean= True; ADecimals: Integer= -1; AFixedDecimals: boolean= False): TfpgEditFloat;

function CreateEditCurrency(AOwner: TComponent; x, y, w, h: TfpgCoord;
    AShowThousand: boolean= True; ADecimals: Integer= 2): TfpgEditCurrency;


implementation

uses
  fpg_stringutils,
  fpg_constants;

const
  // internal popupmenu item names
  ipmCut        = 'miDefaultCut';
  ipmCopy       = 'miDefaultCopy';
  ipmPaste      = 'miDefaultPaste';
  ipmClearAll   = 'miDefaultClearAll';


function CreateEdit(AOwner: TComponent; x, y, w, h: TfpgCoord): TfpgEdit;
begin
  Result       := TfpgEdit.Create(AOwner);
  Result.Left  := x;
  Result.Top   := y;
  if w > 0 then
    Result.Width := w;
  if h < TfpgEdit(Result).FFont.Height + 4 + (Result.FHeightMargin * 2) then
    Result.Height := TfpgEdit(Result).FFont.Height + 4 + (Result.FHeightMargin * 2)
  else
    Result.Height:= h;
end;

function CreateEditInteger(AOwner: TComponent; x, y, w, h: TfpgCoord; AShowThousand: boolean= True): TfpgEditInteger;
begin
  Result       := TfpgEditInteger.Create(AOwner);
  Result.Left  := x;
  Result.Top   := y;
  Result.Width := w;
  Result.ShowThousand:= AShowThousand;
  if h < TfpgEditInteger(Result).FFont.Height + 4 + (Result.FHeightMargin * 2) then
    Result.Height := TfpgEditInteger(Result).FFont.Height + 4 + (Result.FHeightMargin * 2)
  else
    Result.Height:= h;
end;

function CreateEditFloat(AOwner: TComponent; x, y, w, h: TfpgCoord; AShowThousand: boolean= True;
         ADecimals: Integer= -1; AFixedDecimals: boolean= False): TfpgEditFloat;
begin
  Result       := TfpgEditFloat.Create(AOwner);
  Result.Left  := x;
  Result.Top   := y;
  Result.Width := w;
  Result.ShowThousand:= AShowThousand;
  Result.Decimals := ADecimals;
  Result.FFixedDecimals:= AFixedDecimals;
  if h < TfpgEditFloat(Result).FFont.Height + 4 + (Result.FHeightMargin * 2) then
    Result.Height := TfpgEditFloat(Result).FFont.Height + 4 + (Result.FHeightMargin * 2)
  else
    Result.Height:= h;
end;

function CreateEditCurrency(AOwner: TComponent; x, y, w, h: TfpgCoord; AShowThousand: boolean= True;
         ADecimals: Integer= 2): TfpgEditCurrency;
begin
  Result          := TfpgEditCurrency.Create(AOwner);
  Result.Left     := x;
  Result.Top      := y;
  Result.Width    := w;
  Result.ShowThousand:= AShowThousand;
  Result.Decimals := ADecimals;
  if h < TfpgEditCurrency(Result).FFont.Height + 4 + (Result.FHeightMargin * 2) then
    Result.Height := TfpgEditCurrency(Result).FFont.Height + 4 + (Result.FHeightMargin * 2)
  else
    Result.Height:= h;
end;


{ TfpgBaseEdit }

procedure TfpgBaseEdit.Adjust(UsePxCursorPos: boolean = false);
begin
  AdjustTextOffset(False);
  AdjustDrawingInfo;
end;

procedure TfpgBaseEdit.AdjustTextOffset(UsePxCursorPos: boolean);
{If UsePxCursorPos then determines FCursorPos from FCursorPx (that holds mouse pointer coordinates)
 Calculates exact FCursorPx (relative to the widget bounding box) from FCursorPos
 Calculates FTextOffset based on FCursorPx}
var
  dtext: string;
  ch: string;     // current character
  chnum: integer; // its ordinal number
  chx: integer;   // its X position relative to widget
  bestchx: integer; // chx, nearest to the mouse position (indicated by FCursorPx if UsePxCursorPos = True)
  tw: integer;      // total characters width, that becomes FCursorPx relative to the beginning of the text
  ptw: integer;
  dpos: integer;  // helps to pass through an utf-8 string quickly
  VisibleWidth: integer; // width of the edit field minus side margins
  r: TfpgRect;
begin
  if UsePxCursorPos then
  begin
    if FCursorPx > 0 then // bestchx < chx minimum
      bestchx := Low(chx)  + 1 + FCursorPx
    else                  // bestchx > chx maximum
      bestchx := High(chx) - 1 + FCursorPx;
  end else
    FCursorPx := 0;

  dtext := GetDrawText;
  ch    := '';
  chnum := 0;
  tw    := 0;
  dpos  := 0;

  while dpos <= Length(dtext) do
  begin
    dpos := UTF8CharAtByte(dtext, dpos, ch);
    ptw := tw;
    tw  := tw + FFont.TextWidth(ch);
    chx := tw - FTextOffset + FSideMargin;
    if UsePxCursorPos then
    begin
      if abs(chx - FCursorPx) < abs(bestchx - FCursorPx) then
      begin
        bestchx := chx;
        FCursorPos := chnum;
      end else
      begin
        tw := ptw;
        break;
      end;
    end else
    begin
      if chnum >= FCursorPos then
        break;
    end;
    Inc(chnum);
  end;

  r := GetClientRect;
  VisibleWidth := (r.Width - (2 * FSideMargin));
  if tw - FTextOffset > VisibleWidth - 2 then
    FTextOffset := tw - VisibleWidth + 2
  else if tw - FTextOffset < 0 then
  begin
    FTextOffset := tw;
    if tw <> 0 then
      Dec(FTextOffset, 2);
  end;

  FCursorPx := tw - FTextOffset + FSideMargin;
end;

procedure TfpgBaseEdit.AdjustDrawingInfo;
// Calculates FVisSelStartPx, FVisSelEndPx, FVisibleText, FDrawOffset
var
  vtstartbyte, vtendbyte: integer; // visible characters' start/end in utf-8 string, bytes
  bestfx, bestlx: integer;
  dtext: string;
  ch: string;     // current character
  chnum: integer; // its ordinal number
  chx: integer;   // its X position relative to widget
  tw: integer;    // total characters width, that becomes FCursorPx relative to the beginning of the text
  ptw: integer;   // total width on the previous step
  dpos: integer;  // helps to pass through an utf-8 string quickly
  pdp: integer;   // dpos on the previous step
  vstart, vend: integer;    // visible area start and end, pixels
  slstart, slend: integer;  // selection start and end, pixels
begin
  vstart  := FSideMargin;
  vend    := FWidth - FSideMargin;
  if FSelOffset > 0 then
  begin
    slstart := FSelStart;
    slend   := FSelStart + FSelOffset;
  end else
  begin
    slstart := FSelStart + FSelOffset;
    slend   := FSelStart;
  end;
  FVisSelStartPx := vend; // because we stop the search
  FVisSelEndPx   := vend; // after last visible character is found
  bestfx := Low(chx) + 1 + vstart;
  bestlx := Low(chx) + 1 + vend;

  dtext := GetDrawText;
  ch    := '';
  chnum := 0;
  tw    := 0;
  dpos  := 0;

  FDrawOffset := 0;
  while dpos <= Length(dtext) do
  begin
    pdp := dpos;
    dpos := UTF8CharAtByte(dtext, dpos, ch);
    ptw := tw;
    tw  := tw + FFont.TextWidth(ch);
    chx := tw - FTextOffset + FSideMargin;

    // calculate selection-related fields
    if chnum = slstart then
      FVisSelStartPx := chx;
    if chnum = slend then
      FVisSelEndPx := chx;

    // search for the first/last visible characters
    if abs(chx - vstart) < abs(bestfx - vstart) then
    begin
      bestfx := chx;
      vtstartbyte := pdp;
      FDrawOffset := ptw;
    end;
    // in small edit field the same character can be both the first and the last, so no 'else' allowed
    if abs(chx - vend) < abs(bestlx - vend) then
    begin
      bestlx := chx;
      vtendbyte := UTF8CharAtByte(dtext, dpos, ch); // plus one more character
    end else
      break; // we can safely break after last visible character is found
    Inc(chnum);
  end;

  if FVisSelStartPx < vstart then
    FVisSelStartPx := vstart;
  if FVisSelEndPx > vend then
    FVisSelEndPx := vend;

  // FVisibleText := UTF8Copy(dtext, fvc, lvc - fvc + 2);
  FVisibleText := Copy(dtext, vtstartbyte, vtendbyte - vtstartbyte);
  FDrawOffset := FTextOffset - FDrawOffset;
end;

{function TfpgBaseEdit.PointToCharPos(x, y: integer): integer;
var
  n: integer;
  cx: integer; // character X position
  bestcx: integer;
  dtext: string;
  tw, dpos: integer;
  ch: string;
begin
  ch     := '';
  dtext  := GetDrawText;
  if x > 0 then // bestcx < cx minimum
    bestcx := Low(cx) + 1 + x
  else          // bestcx > cx maximum
    bestcx := High(cx) - 1 + x;

  tw   := 0;
  dpos := 0;
  n    := 0;
  Result := n;
  // searching the appropriate character position
  while dpos <= Length(dtext) do
  begin
    dpos := UTF8CharAtByte(dtext, dpos, ch);
    tw := tw + FFont.TextWidth(ch);
    cx := tw - FTextOffset + FSideMargin;
    if abs(cx - x) < abs(bestcx - x) then
    begin
      bestcx := cx;
      Result := n;
    end else
      Exit; //==>
    Inc(n);
  end;
end;}

procedure TfpgBaseEdit.SetBorderStyle(const AValue: TfpgEditBorderStyle);
begin
  if FBorderStyle = AValue then
    Exit; //==>
  FBorderStyle := AValue;
  RePaint;
end;

procedure TfpgBaseEdit.SetHideSelection(const AValue: Boolean);
begin
  if FHideSelection = AValue then
    Exit;
  FHideSelection := AValue;
end;

// paint selection rectangle
procedure TfpgBaseEdit.DrawSelection;
var
  lcolor: TfpgColor;
  rs: TfpgRect;
  r: TfpgRect;
begin
  r := Canvas.GetClipRect;  // contains adjusted size based on borders

  if Focused then
  begin
    lcolor := clSelection;
    Canvas.SetTextColor(clSelectionText);
  end
  else
  begin
    lcolor := clInactiveSel;
    Canvas.SetTextColor(clText1);
  end;

  rs.SetRect(FVisSelStartPx, r.Top + FHeightMargin, FVisSelEndPx - FVisSelStartPx, FFont.Height);
  Canvas.SetColor(lcolor);
  Canvas.FillRectangle(rs);
  Canvas.SetTextColor(clWhite);
  Canvas.AddClipRect(rs);
  fpgStyle.DrawString(Canvas, -FDrawOffset + GetMarginAdjustment, r.Top + FHeightMargin, FVisibleText, Enabled);
  Canvas.ClearClipRect;
end;

procedure TfpgBaseEdit.HandlePaint;
var
  r: TfpgRect;
begin
  Canvas.ClearClipRect;
  r.SetRect(0, 0, Width, Height);
  case BorderStyle of
    ebsNone:
        begin
          // do nothing
        end;
    ebsDefault:
        begin
          Canvas.DrawControlFrame(r);
          InflateRect(r, -2, -2);
        end;
    ebsSingle:
        begin
          Canvas.SetColor(clShadow2);
          Canvas.DrawRectangle(r);
          InflateRect(r, -1, -1);
        end;
  end;
  Canvas.SetClipRect(r);

  if Enabled then
    Canvas.SetColor(FBackgroundColor)
  else
    Canvas.SetColor(clWindowBackground);
  Canvas.FillRectangle(r);

  Canvas.SetFont(FFont);
end;

procedure TfpgBaseEdit.HandleResize(awidth, aheight: TfpgCoord);
begin
  inherited HandleResize(awidth, aheight);
  AdjustDrawingInfo;
end;

procedure TfpgBaseEdit.HandleKeyChar(var AText: TfpgChar;
  var shiftstate: TShiftState; var consumed: Boolean);
var
  s: TfpgChar;
  prevval: string;
begin
  prevval   := Text;
  s         := AText;

  if not consumed then
  begin
    // Handle only printable characters
    // UTF-8 characters beyond ANSI range are supposed to be printable
    if ((Ord(AText[1]) > 31) and (Ord(AText[1]) < 127)) or (Length(AText) > 1) then
    begin
      if (FMaxLength <= 0) or (UTF8Length(FText) < FMaxLength) then
      begin
        DeleteSelection;
        UTF8Insert(s, FText, FCursorPos + 1);
        Inc(FCursorPos);
        FSelStart := FCursorPos;
        Adjust;
      end;
      consumed := True;
    end;

    if prevval <> Text then
      DoOnChange;
  end;

  if consumed then
    RePaint;

  inherited HandleKeyChar(AText, shiftstate, consumed);
end;

procedure TfpgBaseEdit.HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: boolean);
var
  hasChanged: boolean;

  procedure StopSelection;
  begin
    FSelStart  := FCursorPos;
    FSelOffset := 0;
  end;

begin
  hasChanged := False;
  fpgApplication.HideHint;

  Consumed := True;
  case CheckClipBoardKey(keycode, shiftstate) of
    ckCopy:
        begin
          DoCopy;
        end;
    ckPaste:
        begin
          DoPaste;
          hasChanged := True;
        end;
    ckCut:
        begin
          DoCopy;
          DeleteSelection;
          Adjust;
          hasChanged := True;
        end;
  else
    Consumed := False;
  end;

  if not Consumed then
  begin
    // checking for movement keys:
    case keycode of
      keyLeft:
        if FCursorPos > 0 then
        begin
          consumed := True;
          Dec(FCursorPos);

          if (ssCtrl in shiftstate) then
            // word search...
            //                    while (FCursorPos > 0) and not ptkIsAlphaNum(copy(FText,FCursorPos,1))
            //                      do Dec(FCursorPos);
            //                    while (FCursorPos > 0) and ptkIsAlphaNum(copy(FText,FCursorPos,1))
            //                      do Dec(FCursorPos);
          ;

        end;

      keyRight:
        if FCursorPos < UTF8Length(FText) then
        begin
          consumed := True;
          Inc(FCursorPos);

          if (ssCtrl in shiftstate) then
            // word search...
            //                    while (FCursorPos < Length(FText)) and ptkIsAlphaNum(copy(FText,FCursorPos+1,1))
            //                      do Inc(FCursorPos);
            //                    while (FCursorPos < Length(FText)) and not ptkIsAlphaNum(copy(FText,FCursorPos+1,1))
            //                      do Inc(FCursorPos);
          ;
        end;

      keyHome:
        begin
          consumed := True;
          FCursorPos := 0;
        end;

      keyEnd:
        begin
          consumed := True;
          FCursorPos := UTF8Length(FText);
        end;
    end;

    if Consumed then
    begin
      FSelecting := (ssShift in shiftstate);

      if FSelecting then
        FSelOffset := FCursorPos - FSelStart
      else
        StopSelection;

      Adjust;
    end;
  end; // movement key checking

  if not Consumed then
  begin
    consumed := True;

    case keycode of
      keyBackSpace:
          begin
            if FSelOffset <> 0 then
              DeleteSelection
            else if FCursorPos > 0 then
            begin
              UTF8Delete(FText, FCursorPos, 1);
              Dec(FCursorPos);
              hasChanged := True;
            end;// backspace
          end;


      keyDelete:
          begin
            if FSelOffset <> 0 then
              DeleteSelection
            else if FCursorPos < UTF8Length(FText) then
              UTF8Delete(FText, FCursorPos + 1, 1);
            hasChanged := True;
          end;
      else
        Consumed := False;
    end;

    if Consumed then
    begin
      StopSelection;
      Adjust;
    end;
  end;  { if }

  if consumed then
    RePaint
  else
    inherited HandleKeyPress(keycode, shiftstate, consumed);

  if hasChanged then
    if Assigned(FOnChange) then
      FOnChange(self);
end;

procedure TfpgBaseEdit.HandleLMouseDown(x, y: integer; shiftstate: TShiftState);
begin
  fpgApplication.HideHint;
  inherited HandleLMouseDown(x, y, shiftstate);

  FCursorPx := x;
  AdjustTextOffset(True);
  FMouseDragPos := FCursorPos;
  if (ssShift in shiftstate) then
    FSelOffset := FCursorPos - FSelStart
  else
  begin
    FSelStart  := FCursorPos;
    FSelOffset := 0;
  end;
  AdjustDrawingInfo;
  RePaint;
end;

procedure TfpgBaseEdit.HandleRMouseDown(x, y: integer;
  shiftstate: TShiftState);
begin
  // keyMenu was pressed
  if shiftstate = [ssExtra1] then
    HandleRMouseUp(x, y, [])
  else
    inherited HandleRMouseDown(x, y, shiftstate);
end;

procedure TfpgBaseEdit.HandleRMouseUp(x, y: integer; shiftstate: TShiftState);
begin
  inherited HandleRMouseUp(x, y, shiftstate);
  if Assigned(PopupMenu) then
    PopupMenu.ShowAt(self, x, y)
  else
    ShowDefaultPopupMenu(x, y, ShiftState);
end;

procedure TfpgBaseEdit.HandleMouseMove(x, y: integer; btnstate: word; shiftstate: TShiftState);
var
  cp: integer;
begin
  if (btnstate and MOUSE_LEFT) = 0 then // Left button not down
  begin
    inherited HandleMouseMove(x, y, btnstate, shiftstate);
    Exit; //==>
  end;

  cp := FCursorPos;
  FCursorPx := x;
  AdjustTextOffset(True);
  if FCursorPos <> cp then
  begin
    FSelOffset := FCursorPos - FSelStart;
    AdjustDrawingInfo;
    Repaint;
  end;
end;

procedure TfpgBaseEdit.HandleDoubleClick(x, y: integer; button: word; shiftstate: TShiftState);
begin
  // button is always Mouse_Left, but lets leave this test here for good measure
  if button = MOUSE_LEFT then
    SelectAll
  else
    inherited;
end;

procedure TfpgBaseEdit.HandleMouseEnter;
begin
  inherited HandleMouseEnter;
  if (csDesigning in ComponentState) then
    Exit;
  if Enabled then
    MouseCursor := mcIBeam;
end;

procedure TfpgBaseEdit.HandleMouseExit;
begin
  inherited HandleMouseExit;
  if (csDesigning in ComponentState) then
    Exit;
  MouseCursor := mcDefault;
end;

procedure TfpgBaseEdit.HandleSetFocus;
begin
  inherited HandleSetFocus;
  if AutoSelect then
    SelectAll;
end;

procedure TfpgBaseEdit.HandleKillFocus;
begin
  inherited HandleKillFocus;
  if AutoSelect then
    FSelOffset := 0;
end;

procedure TfpgBaseEdit.HandleHide;
begin
  fpgCaret.UnSetCaret (Canvas);
  inherited;
end;

function TfpgBaseEdit.GetDrawText: string;
begin
  if not PassWordMode then
    Result := FText
  else
    Result := StringOfChar('*', UTF8Length(FText));
end;

constructor TfpgBaseEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFont             := fpgGetFont('#Edit1');  // owned object !
  Focusable         := True;
  FHeight           := FFont.Height + 8;     // (BorderStyle + HeightMargin) * 2
  FWidth            := 120;
  FTextColor        := Parent.TextColor;
  FBackgroundColor  := clBoxColor;
  FAutoSelect       := True;
  FSelecting        := False;
  FHideSelection    := True;
  FSideMargin       := 3;
  FHeightMargin     := 2;
  FMaxLength        := 0; // no limit
  FText             := '';
  FCursorPos        := UTF8Length(FText);
  FSelStart         := FCursorPos;
  FSelOffset        := 0;
  FTextOffset       := 0;
  FPasswordMode     := False;
  FBorderStyle      := ebsDefault;
  FPopupMenu        := nil;
  FDefaultPopupMenu := nil;
  FOnChange         := nil;

end;

destructor TfpgBaseEdit.Destroy;
begin
  if Assigned(FDefaultPopupMenu) then
    FDefaultPopupMenu.Free;
  FFont.Free;
  inherited Destroy;
end;

function TfpgBaseEdit.SelectionText: string;
begin
  if FSelOffset <> 0 then
  begin
    if FSelOffset < 0 then
      Result := UTF8Copy(FText, 1 + FSelStart + FSelOffset, -FSelOffset)
    else
    begin
      Result := UTF8Copy(FText, 1 + FSelStart, FSelOffset);
    end;
  end
  else
    Result := '';
end;

procedure TfpgBaseEdit.SetPasswordMode (const AValue: boolean );
begin
  if FPasswordMode = AValue then
    Exit; //==>
  FPasswordMode := AValue;
  Adjust;
  RePaint;
end;

function TfpgBaseEdit.GetFontDesc: string;
begin
  Result := FFont.FontDesc;
end;

procedure TfpgBaseEdit.SetFontDesc(const AValue: string);
begin
  FFont.Free;
  FFont := fpgGetFont(AValue);
  case BorderStyle of
    ebsNone:
      if Height < FFont.Height + (FHeightMargin * 2) then
        Height:= FFont.Height + (FHeightMargin * 2);
    ebsDefault:
      if Height < FFont.Height + 4 + (FHeightMargin * 2) then
        Height:= FFont.Height + 4 + (FHeightMargin * 2);
    ebsSingle:
      if Height < FFont.Height + 2 + (FHeightMargin * 2) then
        Height:= FFont.Height + 2 + (FHeightMargin * 2);
  end;
  Adjust;
  RePaint;
end;

procedure TfpgBaseEdit.SetText(const AValue: string);
var
  s: string;
  prevval: TfpgString;
begin
  if FText = AValue then
    Exit;
  prevval := FText;

  if FMaxLength <> 0 then
  begin
    if UTF8Length(FText) > FMaxLength then
      s := UTF8Copy(AValue, 1, FMaxLength)
    else
      s := AValue;
  end
  else
    s := AValue;

  FText       := s;
  FCursorPos  := UTF8Length(FText);
  FSelStart   := FCursorPos;
  FSelOffset  := 0;
  FTextOffset := 0;

  Adjust;
  RePaint;

  if prevval <> Text then
    DoOnChange;
end;

procedure TfpgBaseEdit.SetSideMargin(const AValue: integer);
begin
  if (FSideMargin = AValue) or (AValue <= 0) then
    Exit; //=>
  FSideMargin := AValue;
  Repaint;
end;

procedure TfpgBaseEdit.SetHeightMargin(const AValue: integer);
begin
  if (FHeightMargin = AValue) or (AValue <= 0) then
    Exit; //=>
  FHeightMargin := AValue;
  case BorderStyle of
    ebsNone:
      Height:= FFont.Height + (FHeightMargin * 2);
    ebsDefault:
      Height:= FFont.Height + 4 + (FHeightMargin * 2);
    ebsSingle:
      Height:= FFont.Height + 2 + (FHeightMargin * 2);
    end;
  Repaint;
end;

procedure TfpgBaseEdit.DefaultPopupCut(Sender: TObject);
begin
  CutToClipboard;
end;

procedure TfpgBaseEdit.DefaultPopupCopy(Sender: TObject);
begin
  CopyToClipboard;
end;

procedure TfpgBaseEdit.DefaultPopupPaste(Sender: TObject);
begin
  PasteFromClipboard
end;

procedure TfpgBaseEdit.DefaultPopupClearAll(Sender: TObject);
begin
  Clear;
end;

procedure TfpgBaseEdit.SetDefaultPopupMenuItemsState;
var
  i: integer;
  itm: TfpgMenuItem;
begin
  for i := 0 to FDefaultPopupMenu.ComponentCount-1 do
  begin
    if FDefaultPopupMenu.Components[i] is TfpgMenuItem then
    begin
      itm := TfpgMenuItem(FDefaultPopupMenu.Components[i]);
      // enabled/disable menu items
      if itm.Name = ipmCut then
        itm.Enabled := FSelOffset <> 0
      else if itm.Name = ipmCopy then
        itm.Enabled := FSelOffset <> 0
      else if itm.Name = ipmPaste then
        itm.Enabled := fpgClipboard.Text <> ''
      else if itm.Name = ipmClearAll then
        itm.Enabled := Text <> '';
    end;
  end;
end;

function TfpgBaseEdit.GetMarginAdjustment: integer;
begin
  Result := FSideMargin;
end;

procedure TfpgBaseEdit.DoOnChange;
begin
  if Assigned(FOnChange) then
    FOnChange(self);
end;

procedure TfpgBaseEdit.ShowDefaultPopupMenu(const x, y: integer;
  const shiftstate: TShiftState);
var
  itm: TfpgMenuItem;
begin
  if not Assigned(FDefaultPopupMenu) then
  begin
    { todo: This text needs to be localized }
    FDefaultPopupMenu := TfpgPopupMenu.Create(nil);
    itm := FDefaultPopupMenu.AddMenuItem(rsCut, '', @DefaultPopupCut);
    itm.Name := ipmCut;
    itm := FDefaultPopupMenu.AddMenuItem(rsCopy, '', @DefaultPopupCopy);
    itm.Name := ipmCopy;
    itm := FDefaultPopupMenu.AddMenuItem(rsPaste, '', @DefaultPopupPaste);
    itm.Name := ipmPaste;
    itm := FDefaultPopupMenu.AddMenuItem(rsDelete, '', @DefaultPopupClearAll);
    itm.Name := ipmClearAll;
  end;

  SetDefaultPopupMenuItemsState;
  FDefaultPopupMenu.ShowAt(self, x, y);
end;

procedure TfpgBaseEdit.DeleteSelection;
var
  prevval: TfpgString;
begin
  prevval := FText;
  if FSelOffset <> 0 then
  begin
    if FSelOffset < 0 then
    begin
      UTF8Delete(FText, 1 + FSelStart + FSelOffset, -FSelOffset);
      FCurSorPos := FSelStart + FSelOffset;
    end
    else
    begin
      UTF8Delete(FText, 1 + FSelStart, FSelOffset);
      FCurSorPos := FSelStart;
    end;
    FSelOffset := 0;
    FSelStart := FCursorPos;
  end;
  if prevval <> Text then
    DoOnChange;
end;

procedure TfpgBaseEdit.DoCopy;
begin
  if FSelOffset = 0 then
    Exit; //==>
  fpgClipboard.Text := SelectionText;
end;

procedure TfpgBaseEdit.DoPaste;
var
  s: string;
  prevval: TfpgString;
begin
  prevval := FText;
  DeleteSelection;
  s := fpgClipboard.Text;

  if (FMaxLength > 0) then
    if UTF8Length(FText) + UTF8Length(s) > FMaxLength then
      s := UTF8Copy(s, 1, FMaxLength - UTF8Length(FText));  // trim the clipboard text if needed

  if UTF8Length(s) < 1 then
    Exit; //==>

  UTF8Insert(s, FText, FCursorPos + 1);
  FCursorPos := FCursorPos + UTF8Length(s);
  FSelStart  := FCursorPos;
  Adjust;
  Repaint;
  if prevval <> Text then
    DoOnChange;
end;

procedure TfpgBaseEdit.SetAutoSelect(const AValue: Boolean);
begin
  if FAutoSelect = AValue then
    Exit; //==>
  FAutoSelect := AValue;
end;

procedure TfpgBaseEdit.SelectAll;
begin
  FSelecting  := True;
  FSelStart   := 0;
  FSelOffset  := UTF8Length(FText);
  FCursorPos  := FSelOffset;
  Adjust;
  Repaint;
end;

procedure TfpgBaseEdit.Clear;
begin
  Text := '';
end;

procedure TfpgBaseEdit.ClearSelection;
begin
  DeleteSelection;
  Adjust;
  RePaint;
end;

procedure TfpgBaseEdit.CopyToClipboard;
begin
  DoCopy;
end;

procedure TfpgBaseEdit.CutToClipboard;
begin
  DoCopy;
  DeleteSelection;
  Adjust;
  RePaint;
end;

function TfpgBaseEdit.GetClientRect: TfpgRect;
begin
  case BorderStyle of
    ebsNone:      inherited GetClientRect;
    ebsDefault:   Result.SetRect(2, 2, Width-4, Height-4);
    ebsSingle:    Result.SetRect(1, 1, Width-2, Height-2);
  end;
end;

procedure TfpgBaseEdit.PasteFromClipboard;
begin
  DoPaste;
end;

{ TfpgBaseTextEdit }

procedure TfpgBaseTextEdit.HandlePaint;
var
  r: TfpgRect;
begin
  inherited HandlePaint;
  r := Canvas.GetClipRect;    // contains adjusted size based on borders

  if (FVisibleText = '') and not Focused then
  begin
    Canvas.SetTextColor(clShadow1);
    fpgStyle.DrawString(Canvas, -FDrawOffset + GetMarginAdjustment, r.Top + FHeightMargin, FExtraHint, Enabled);
  end
  else
  begin
    Canvas.SetTextColor(FTextColor);
    fpgStyle.DrawString(Canvas, -FDrawOffset + GetMarginAdjustment, r.Top + FHeightMargin, FVisibleText, Enabled);
  end;

  if Focused then
  begin
    // drawing selection
    if FSelOffset <> 0 then
      DrawSelection;
    // drawing cursor
    fpgCaret.SetCaret(Canvas, FCursorPx, r.Top + FHeightMargin, fpgCaret.Width, FFont.Height);
  end
  else
  begin
    // drawing selection
    if (AutoSelect = False) and (FSelOffset <> 0) and (HideSelection = False) then
      DrawSelection;
    fpgCaret.UnSetCaret(Canvas);
  end;
end;

constructor TfpgBaseTextEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FExtraHint := '';
end;

procedure TfpgBaseTextEdit.SetExtraHint(const AValue: string);
begin
  if FExtraHint = AValue then
    Exit; //==>
  FExtraHint := AValue;
  Repaint;
end;

{ TfpgBaseNumericEdit }

procedure TfpgBaseNumericEdit.AdjustTextOffset(UsePxCursorPos: boolean);
{If UsePxCursorPos then determines FCursorPos from FCursorPx (that holds mouse pointer coordinates)
 Calculates exact FCursorPx (relative to the widget bounding box) from FCursorPos
 Calculates FTextOffset based on FCursorPx}
var
  dtext: string;
  ch: string;     // current character
  chnum: integer; // its ordinal number
  chx: integer;   // its X position relative to widget
  bestchx: integer; // chx, nearest to the mouse position (indicated by FCursorPx if UsePxCursorPos = True)
  tw: integer;      // total characters width, that becomes FCursorPx relative to the beginning of the text
  ptw: integer;
  dpos: integer;  // helps to pass through an utf-8 string quickly
  VisibleWidth: integer; // width of the edit field minus side margins
  r: TfpgRect;
begin
  if UsePxCursorPos then
  begin
    if FCursorPx > 0 then // bestchx < chx minimum
      bestchx := Low(chx)  + 1 + FCursorPx
    else                  // bestchx > chx maximum
      bestchx := High(chx) - 1 + FCursorPx;
  end else
    FCursorPx := 0;

  dtext := GetDrawText;
  ch    := '';
  chnum := 0;
  tw    := 0;
  dpos  := 0;
  r := GetClientRect;

  while dpos <= Length(dtext) do
  begin
    dpos := UTF8CharAtByte(dtext, dpos, ch);
    ptw := tw;
    tw  := tw + FFont.TextWidth(ch);
    case FAlignment of
    taLeftJustify:
      chx := tw - FTextOffset + FSideMargin;
    taRightJustify:
      chx := tw - FTextOffset - FSideMargin + r.Width - FFont.TextWidth(dtext);
    end;
    if UsePxCursorPos then
    begin
      if abs(chx - FCursorPx) < abs(bestchx - FCursorPx) then
      begin
        bestchx := chx;
        FCursorPos := chnum;
      end else
      begin
        tw := ptw;
        break;
      end;
    end else
    begin
      if chnum >= FCursorPos then
        break;
    end;
    Inc(chnum);
  end;

  VisibleWidth := (r.Width - (2 * FSideMargin));
  if tw - FTextOffset > VisibleWidth - 2 then
    FTextOffset := tw - VisibleWidth + 2
  else if tw - FTextOffset < 0 then
  begin
    FTextOffset := tw;
    if tw <> 0 then
      Dec(FTextOffset, 2);
  end;

  case FAlignment of
  taLeftJustify:
    FCursorPx := tw - FTextOffset + FSideMargin;
  taRightJustify:
    FCursorPx := tw - FTextOffset - FSideMargin + r.Width - FFont.TextWidth(dtext);
  end;
end;

procedure TfpgBaseNumericEdit.AdjustDrawingInfo;
// Calculates FVisSelStartPx, FVisSelEndPx, FVisibleText, FDrawOffset
var
  vtstartbyte, vtendbyte: integer; // visible characters' start/end in utf-8 string, bytes
  bestfx, bestlx: integer;
  dtext: string;
  ch: string;     // current character
  chnum: integer; // its ordinal number
  chx: integer;   // its X position relative to widget
  tw: integer;    // total characters width, that becomes FCursorPx relative to the beginning of the text
  ptw: integer;   // total width on the previous step
  dpos: integer;  // helps to pass through an utf-8 string quickly
  pdp: integer;   // dpos on the previous step
  vstart, vend: integer;    // visible area start and end, pixels
  slstart, slend: integer;  // selection start and end, pixels
  r: TfpgRect;
begin
  vstart  := FSideMargin;
  vend    := FWidth - FSideMargin;
  if FSelOffset > 0 then
  begin
    slstart := FSelStart;
    slend   := FSelStart + FSelOffset;
  end else
  begin
    slstart := FSelStart + FSelOffset;
    slend   := FSelStart;
  end;
  FVisSelStartPx := vend; // because we stop the search
  FVisSelEndPx   := vend; // after last visible character is found
  bestfx := Low(chx) + 1 + vstart;
  bestlx := Low(chx) + 1 + vend;

  dtext := GetDrawText;
  ch    := '';
  chnum := 0;
  tw    := 0;
  dpos  := 0;

  r := GetClientRect;
  FDrawOffset := 0;
  while dpos <= Length(dtext) do
  begin
    pdp := dpos;
    dpos := UTF8CharAtByte(dtext, dpos, ch);
    ptw := tw;
    tw  := tw + FFont.TextWidth(ch);
    case FAlignment of
    taLeftJustify:
      chx := tw - FTextOffset + FSideMargin;
    taRightJustify:
      chx := tw - FTextOffset - FSideMargin + r.Width - FFont.TextWidth(dtext);
    end;

    // calculate selection-related fields
    if chnum = slstart then
      FVisSelStartPx := chx;
    if chnum = slend then
      FVisSelEndPx := chx;

    // search for the first/last visible characters
    if abs(chx - vstart) < abs(bestfx - vstart) then
    begin
      bestfx := chx;
      vtstartbyte := pdp;
      case FAlignment of
      taLeftJustify:
        FDrawOffset := ptw;
      taRightJustify:
        FDrawOffset := ptw + r.Width - FFont.TextWidth(dtext);
      end;
    end;
    // in small edit field the same character can be both the first and the last, so no 'else' allowed
    if abs(chx - vend) < abs(bestlx - vend) then
    begin
      bestlx := chx;
      vtendbyte := UTF8CharAtByte(dtext, dpos, ch); // plus one more character
    end else
      break; // we can safely break after last visible character is found
    Inc(chnum);
  end;

  if FVisSelStartPx < vstart then
    FVisSelStartPx := vstart;
  if FVisSelEndPx > vend then
    FVisSelEndPx := vend;

  // FVisibleText := UTF8Copy(dtext, fvc, lvc - fvc + 2);
  FVisibleText := Copy(dtext, vtstartbyte, vtendbyte - vtstartbyte);
  FDrawOffset := FTextOffset - FDrawOffset;
end;

procedure TfpgBaseNumericEdit.SetOldColor(const AValue: TfpgColor);
begin
  if FOldColor=AValue then exit;
  FOldColor:=AValue;
end;

procedure TfpgBaseNumericEdit.SetAlignment(const AValue: TAlignment);
begin
  if FAlignment=AValue then exit;
  FAlignment:=AValue;
end;

procedure TfpgBaseNumericEdit.SetDecimalSeparator(const AValue: TfpgChar);
begin
  if FDecimalseparator=AValue then exit;
  FDecimalseparator:=AValue;
end;

procedure TfpgBaseNumericEdit.SetNegativeColor(const AValue: TfpgColor);
begin
  if FNegativeColor=AValue then exit;
  FNegativeColor:=AValue;
end;

procedure TfpgBaseNumericEdit.SetThousandSeparator(const AValue: TfpgChar);
begin
  if FThousandSeparator=AValue then exit;
  FThousandSeparator:=AValue;
end;

procedure TfpgBaseNumericEdit.SetShowThousand;
var
	i,long: integer;
  txt, texte, decimal: string;
begin
  if FDecimals > 0 then
  begin
    if Pos(FDecimalSeparator, fText) > 0 then
    begin
      txt := UTF8Copy(fText, 1, Pred(UTF8Pos(FDecimalSeparator, fText)));
      if UTF8Length(fText)-UTF8Pos(FDecimalSeparator, fText) > FDecimals then
        decimal := UTF8Copy(fText, Succ(UTF8Pos(FDecimalSeparator, fText)), FDecimals)
      else
        decimal := UTF8Copy(fText, Succ(UTF8Pos(FDecimalSeparator, fText)), UTF8Length(fText)-UTF8Pos(FDecimalSeparator, fText));
    end
    else
      txt := fText;
  end
  else
  begin
    if FDecimals = 0 then
    begin
      if Pos(FDecimalSeparator, fText) > 0 then
        txt := UTF8Copy(fText, 1, Pred(UTF8Pos(FDecimalSeparator, fText)))
      else
        txt := fText;
    end
    else
      if Pos(FDecimalSeparator, fText) > 0 then
      begin
        txt := UTF8Copy(fText, 1, Pred(UTF8Pos(FDecimalSeparator, fText)));
        decimal := UTF8Copy(fText, Succ(UTF8Pos(FDecimalSeparator, fText)), UTF8Length(fText)-UTF8Pos(FDecimalSeparator, fText));
      end
      else
        txt := fText;
  end;
  if ShowThousand then
  begin
    if fText > '' then
      if fText[1] = '-' then
        txt:= UTF8Copy(txt, 2, UTF8Length(txt)-1);
  	long := UTF8Length(txt);
  	if long = 0 then
  		texte := ''
  	else
  	begin
      for i := 1 to UTF8Length(txt) do
        if fpgCharAt(txt, i) = FThousandSeparator then
        begin
          txt:= UTF8Copy(txt, 1, i - 1) + UTF8Copy(txt, i + 1, long - i);
          dec(long);
        end;
  		i := 0;
  		texte := '';
  		repeat
  			if i > 0 then
  				if ((i mod 3) = 0) and (fpgCharAt(txt,UTF8Length(txt)-UTF8Length(texte)) <> FThousandSeparator) then
          begin
  					texte := FThousandSeparator + texte;
            if fText[1] = '-' then
            begin
              if Pred(FCursorPos) <= UTF8Length(texte) then
                Inc(FCursorPos);
            end
            else
              if FCursorPos <= UTF8Length(texte) then
                Inc(FCursorPos);
          end;
  			texte := Copy(txt, long - i, 1) + texte;
  			inc(i);
  		until i = long;
  	end;
  if fText > '' then
    if fText[1] = '-' then
      if UTF8Pos(FDecimalSeparator, fText) > 0 then
        fText := '-' + texte + FDecimalSeparator + decimal
      else
        fText := '-' + texte
    else
      if UTF8Pos(FDecimalSeparator, fText) > 0 then
        fText := texte + FDecimalSeparator + decimal
      else
        fText := texte + decimal;
  end;
end;

function TfpgBaseNumericEdit.GetMarginAdjustment: integer;
begin
  // Due to numeric edits being right aligned, the margin is negative
  Result := -FSideMargin;
end;

procedure TfpgBaseNumericEdit.Justify;
begin
  //based on Alignment property this method will align the derived edit correctly.
end;

procedure TfpgBaseNumericEdit.HandlePaint;
var
  x: TfpgCoord;
  r: TfpgRect;
begin
  inherited HandlePaint;

  if Alignment = taRightJustify then
  begin
    r := GetClientRect;
    Canvas.SetClipRect(r);

    if Enabled then
      Canvas.SetColor(FBackgroundColor)
    else
      Canvas.SetColor(clWindowBackground);
    Canvas.FillRectangle(r);

    Canvas.SetFont(Font);
    Canvas.SetTextColor(TextColor);
    x := r.Width - Font.TextWidth(Text) - FSideMargin;
    fpgStyle.DrawString(Canvas, x, r.Top + FHeightMargin, Text, Enabled);

    if Focused then
    begin
      // drawing selection
      if FSelOffset <> 0 then
        DrawSelection;
      // drawing cursor
      fpgCaret.SetCaret(Canvas, FCursorPx, r.Top + FHeightMargin, fpgCaret.Width, FFont.Height);
    end
    else
    begin
      // drawing selection
      if (AutoSelect = False) and (FSelOffset <> 0) and (HideSelection = False) then
        DrawSelection;
      fpgCaret.UnSetCaret(Canvas);
    end;
  end;
end;

procedure TfpgBaseNumericEdit.FormatEdit;
begin
  SetShowThousand;
  // Colour negative number
  if LeftStr(Text,1) = '-' then
    TextColor := NegativeColor
  else
    TextColor := OldColor;
end;

constructor TfpgBaseNumericEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlignment := taRightJustify;
  FDecimalSeparator := DecimalSeparator;
  FThousandSeparator := ThousandSeparator;
  NegativeColor := clRed;
  OldColor := TextColor;
end;

{ TfpgEditInteger }

function TfpgEditInteger.GetValue: integer;
var
  txt: string;
begin
  if ShowThousand then
  begin
    if Copy(fText, 1, 1) = '-' then
      txt := Copy(ftext, 2, Length(fText) - 1)
    else
      txt := fText;
  	while UTF8Pos(FThousandSeparator, txt) > 0 do
  		txt := UTF8Copy(txt, 1, Pred(UTF8Pos(FThousandSeparator, txt)))
             +UTF8Copy(txt, Succ(UTF8Pos(FThousandSeparator, txt)), Length(txt) - UTF8Pos(FThousandSeparator, txt));
    if UTF8Copy(fText, 1, 1) = '-' then
      fText := '-' + txt
    else
      fText := txt;
  end;

  if fText = '-' then
  begin
    Result := 0;
    Text := fText;
  end
  else
  begin
    if Text <> '' then
    begin
      try
        Result := StrToInt(fText);
      except
        on E: EConvertError do
        begin
          Result := 0;
          Text := '';
          Invalidate;
        end;
      end;
    end
    else
      Result := 0;
  end;
end;

procedure TfpgEditInteger.SetValue(const AValue: integer);
begin
  try
    Text := IntToStr(AValue);
    FormatEdit;
  except
    on E: EConvertError do
      Text := '';
  end;
end;

procedure TfpgEditInteger.HandleKeyChar(var AText: TfpgChar;
  var shiftstate: TShiftState; var consumed: Boolean);
var
  n: integer;
begin
  n := Ord(AText[1]);
  if ((n >= 48) and (n <= 57) or (AText = '-') and (UTF8Pos(AText, Text) <= 0)) then
    consumed := False
  else
    consumed := True;
  inherited HandleKeyChar(AText, shiftstate, consumed);
end;

procedure TfpgEditInteger.HandleSetFocus;
begin
  try
    if GetValue = 0 then
      Text := ''
    else
      Text := IntToStr(GetValue);
  except
    on E: EConvertError do
      Text := '';
  end;
  inherited HandleSetFocus;
end;

procedure TfpgEditInteger.HandleKillFocus;
begin
  try
    Text := IntToStr(GetValue);
    FormatEdit;
  except
    on E: EConvertError do
      Text := '';
  end;
  inherited HandleKillFocus;
end;

procedure TfpgEditInteger.HandlePaint;
begin
  inherited HandlePaint;
  // To make it more visible in the UI Designer
  if csDesigning in ComponentState then
  begin
    Canvas.SetTextColor(clInactiveWgFrame);
    Canvas.DrawString(2, 3, '<Int>');
  end;
end;

constructor TfpgEditInteger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowThousand := True;
  FDecimals := 0;
end;

{ TfpgEditFloat }

function TfpgEditFloat.GetValue: extended;
var
  txt: string;
begin
  if FDecimals > 0 then
  begin
    if UTF8Pos(FDecimalSeparator, fText) > 0 then
      if UTF8Length(fText)-UTF8Pos(FDecimalSeparator, fText) > FDecimals then
        fText := UTF8Copy(fText, 1, UTF8Length(fText) - 1);
  end
  else
    if FDecimals = 0 then
      if UTF8Pos(FDecimalSeparator, fText) > 0 then
        fText := UTF8Copy(fText, 1, UTF8Length(fText) - 1);

  if ShowThousand then
  begin
    if Copy(fText, 1, 1) = '-' then   // No need for utf8 version here
      txt := Copy(ftext, 2, Length(fText) - 1)
    else
      txt := fText;
  	while UTF8Pos(FThousandSeparator, txt) > 0 do
  		txt := UTF8Copy(txt, 1, Pred(UTF8Pos(FThousandSeparator, txt)))
             +UTF8Copy(txt, Succ(UTF8Pos(FThousandSeparator, txt)), UTF8Length(txt) - UTF8Pos(FThousandSeparator, txt));
    if Copy(fText, 1, 1) = '-' then // No need for utf8 version here
      fText := '-' + txt
    else
      fText := txt;
  end;

  if fText = '-' then
  begin
    Result := 0;
    Text := fText;
  end
  else
  begin
    if fText <> '' then
    begin
      try
        Result := StrToFloat(fText);
      except
        on E: EConvertError do
        begin
          Result := 0;
          Text := '';
          Invalidate;
        end;
      end;  { try..except }
    end
    else
      Result := 0;
  end;
end;

procedure TfpgEditFloat.SetValue(const AValue: extended);
begin
  try
    if FFixedDecimals then
      Text := FloatToStrF(AValue, ffFixed, 18, FDecimals)
    else
      Text := FloatToStr(AValue);
    FormatEdit;
  except
    on E: EConvertError do
      Text := '';
  end;
end;

procedure TfpgEditFloat.SetDecimals(const AValue: integer);
begin
  if AValue < -1 then
    Exit; // =>
  if FDecimals <> AValue then
    FDecimals := AValue
end;

procedure TfpgEditFloat.SetFixedDecimals(const AValue: boolean);
begin
  if FFixedDecimals <> AValue then
    FFixedDecimals := AValue;
end;

procedure TfpgEditFloat.HandleKeyChar(var AText: TfpgChar;
  var shiftstate: TShiftState; var consumed: Boolean);
var
  n: integer;
begin
  n := Ord(AText[1]);
  if ((n >= 48) and (n <= 57) or (AText = '-') and (UTF8Pos(AText, Text) <= 0))
     or ((AText = FDecimalSeparator) and (UTF8Pos(AText, Text) <= 0)) then
    consumed := False
  else
    consumed := True;
  inherited HandleKeyChar(AText, shiftstate, consumed);
end;

procedure TfpgEditFloat.HandleSetFocus;
begin
  try
    if GetValue = 0 then
      Text := ''
    else
    begin
      if FFixedDecimals then
        Text := FloatToStrF(GetValue, ffFixed, 18, FDecimals)
      else
        Text := FloatToStr(GetValue);
    end;
  except
    on E: EConvertError do
      Text := '';
  end;
  inherited HandleSetFocus;
end;

procedure TfpgEditFloat.HandleKillFocus;
begin
  try
    if FFixedDecimals then
      Text := FloatToStrF(GetValue, ffFixed, 18, FDecimals)
    else
      Text := FloatToStr(GetValue);
    FormatEdit;
  except
    on E: EConvertError do
      Text := '';
  end;
  inherited HandleKillFocus;
end;

procedure TfpgEditFloat.HandlePaint;
begin
  inherited HandlePaint;
  // To make it more visible in the UI Designer
  if csDesigning in ComponentState then
  begin
    Canvas.SetTextColor(clInactiveWgFrame);
    Canvas.DrawString(2, 3, '<Float>');
  end;
end;

constructor TfpgEditFloat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDecimals := -1;
  FFixedDecimals := False;
  FShowThousand := True;
end;

{ TfpgEditCurrency }

function TfpgEditCurrency.GetValue: Currency;
var
  txt: string;
begin
  if FDecimals > 0 then
    if UTF8Pos(FDecimalSeparator, fText) > 0 then
      if UTF8Length(fText)-UTF8Pos(FDecimalSeparator, fText) > FDecimals then
        fText := UTF8Copy(fText, 1, UTF8Length(fText) - 1);
  if ShowThousand then
  begin
    if Copy(fText, 1, 1) = '-' then
      txt := Copy(ftext, 2, Length(fText) - 1)
    else
      txt := fText;
  	while UTF8Pos(FThousandSeparator, txt) > 0 do
  		txt := UTF8Copy(txt, 1, Pred(UTF8Pos(FThousandSeparator, txt)))
             +UTF8Copy(txt, Succ(UTF8Pos(FThousandSeparator, txt)), UTF8Length(txt) - UTF8Pos(FThousandSeparator, txt));
    if Copy(fText, 1, 1) = '-' then
      fText := '-' + txt
    else
      fText := txt;
  end;
  if fText = '-' then
  begin
    Result := 0;
    Text:= fText;
  end
  else
    if fText > '' then
    try
      Result := StrToCurr(fText);
    except
      on E: EConvertError do
      begin
        Result := 0;
        Text := '';
        Invalidate;
      end;
    end
  else
    Result := 0;
end;

procedure TfpgEditCurrency.SetValue(const AValue: Currency);
begin
  try
    Text := FloatToStrF(AValue, ffFixed, -1, FDecimals);
    FormatEdit;
  except
    on E: EConvertError do
      Text := '';
  end;
end;

procedure TfpgEditCurrency.SetDecimals(AValue: integer);
begin
  if (AValue < 0) or (AValue > 4) then
    Exit; // =>
  if FDecimals <> AValue then
    FDecimals := AValue
end;

procedure TfpgEditCurrency.HandleKeyPress(var keycode: word; var shiftstate: TShiftState; var consumed: Boolean);
begin
  case keycode of
    keyReturn, keyPEnter, keyTab:
      if FDecimals > 0 then
      begin
        if Pos(FDecimalSeparator, fText) = 0 then
          begin
          fText := fText + FDecimalSeparator;
          Inc(FCursorPos);
          end;
        if UTF8Length(fText)-UTF8Pos(FDecimalSeparator, fText) < FDecimals then
          while UTF8Length(fText)-UTF8Pos(FDecimalSeparator, fText) < FDecimals do
          begin
            fText := fText + '0';
            Inc(FCursorPos);
          end;
      end;
    end;
  inherited HandleKeyPress(keycode,shiftstate,consumed);
end;

procedure TfpgEditCurrency.HandleKeyChar(var AText: TfpgChar;
  var shiftstate: TShiftState; var consumed: Boolean);
var
  n: integer;
begin
  n := Ord(AText[1]);
  if ((n >= 48) and (n <= 57) or (AText = '-') and (UTF8Pos(AText, Text) <= 0))
     or ((AText = FDecimalSeparator) and (UTF8Pos(AText, Text) <= 0)) then
    consumed := False
  else
    consumed := True;
  inherited HandleKeyChar(AText, shiftstate, consumed);
end;

procedure TfpgEditCurrency.HandleSetFocus;
begin
  try
    if GetValue = 0 then
      Text := ''
    else
      Text := FloatToStrF(GetValue, ffFixed, -1, FDecimals);
  except
    on E: EConvertError do
      Text := '';
  end;
  inherited HandleSetFocus;
end;

procedure TfpgEditCurrency.HandleKillFocus;
begin
  try
    Text := FloatToStrF(GetValue, ffFixed, -1, FDecimals);
    FormatEdit;
  except
    on E: EConvertError do
      Text := '';
  end;
  inherited HandleKillFocus;
end;

procedure TfpgEditCurrency.HandlePaint;
begin
  inherited HandlePaint;
  // To make it more visible in the UI Designer
  if csDesigning in ComponentState then
  begin
    Canvas.SetTextColor(clInactiveWgFrame);
    Canvas.DrawString(2, 3, '<Curr>');
  end;
end;

constructor TfpgEditCurrency.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDecimals := 2;
  FShowThousand := True;
end;


end.

