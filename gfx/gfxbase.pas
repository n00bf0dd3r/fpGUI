{
    fpGUI  -  Free Pascal GUI Library

    GFXBase  -  Abstract declarations to be implemented on each platform

    Copyright (C) 2000 - 2006 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
unit GfxBase;

{$IFDEF Debug}
  {$ASSERTIONS On}
{$ENDIF}

{$ifdef fpc}
  {$mode objfpc}{$H+}
{$endif}

interface

uses
  SysUtils,
  Classes;

{$INCLUDE keys.inc}

resourcestring
  // Exception message strings, to be used by target implementations
  SUnsupportedPixelFormat = 'Pixel format (%d bits/pixel) is not supported';
  SIncompatibleCanvasForBlitting = 'Cannot blit from %s to %s';

type

  TSize = record
    cx, cy: Integer;
  end;


  { We use a special 3x3 matrix for transformations of coordinates. As the
    only allowed transformations are translations and scalations, we need a
    matrix with the following content ([x,y] is a variable):
        [0,0]   0   [2,0]
          0   [1,1] [2,1]
          0     0     1
    [0,0]: X scalation
    [2,0]: X translation
    [1,1]: Y scalation
    [2,1]: Y translation
    NOTE: This may change in the future! Don't assume anything about the
	  structure of TGfxMatrix! TGfxCanvas only allows you to read and
	  write the current transformation matrix so that the matrix can
	  easily be saved and restored.
  }

  TGfxMatrix = record
    _00, _20, _11, _21: Integer;
  end;

const
  GfxIdentityMatrix: TGfxMatrix = (_00: 1; _20: 0; _11: 1; _21: 0);

type

  TColor = type LongWord;

  PGfxColor = ^TGfxColor;
  TGfxColor = packed record
    Red, Green, Blue, Alpha: Word;
  end;

  PGfxPixel = ^TGfxPixel;
  TGfxPixel = LongWord;


  TGfxImageType = (
    ftInvalid,
    ftMono,		// Monochrome
    ftPal4,		// 4 bpp using palette
    ftPal4A,		// 4 bpp using palette with alpha values > 0
    ftPal8,		// 8 bpp using palette
    ftPal8A,		// 8 bpp using palette with alpha values > 0
    ftRGB16,		// 15/16 bpp RGB
    ftRGBA16,		// 16 bpp RGBA
    ftRGB24,		// 24 bpp RGB
    ftRGB32,		// 32 bpp RGB
    ftRGBA32);	        // 32 bpp RGBA


  TGfxPixelFormat = record
    FormatType: TGfxImageType;
    RedMask: TGfxPixel;
    GreenMask: TGfxPixel;
    BlueMask: TGfxPixel;
    AlphaMask: TGfxPixel;
  end;


const

  FormatTypeBPPTable: array[TGfxImageType] of Integer =
    (0, 1, 4, 4, 8, 8, 16, 16, 24, 32, 32);

  { Predefined colors }

  colTransparent: TGfxColor	= (Red: $0000; Green: $0000; Blue: $0000; Alpha: $ffff);
  colBlack: TGfxColor		    = (Red: $0000; Green: $0000; Blue: $0000; Alpha: $0000);
  colBlue: TGfxColor		    = (Red: $0000; Green: $0000; Blue: $ffff; Alpha: $0000);
  colGreen: TGfxColor		    = (Red: $0000; Green: $ffff; Blue: $0000; Alpha: $0000);
  colCyan: TGfxColor		    = (Red: $0000; Green: $ffff; Blue: $ffff; Alpha: $0000);
  colRed: TGfxColor		      = (Red: $ffff; Green: $0000; Blue: $0000; Alpha: $0000);
  colMagenta: TGfxColor		  = (Red: $ffff; Green: $0000; Blue: $ffff; Alpha: $0000);
  colYellow: TGfxColor		  = (Red: $ffff; Green: $ffff; Blue: $0000; Alpha: $0000);
  colWhite: TGfxColor		    = (Red: $ffff; Green: $ffff; Blue: $ffff; Alpha: $0000);
  colGray: TGfxColor		    = (Red: $8000; Green: $8000; Blue: $8000; Alpha: $0000);
  colLtGray: TGfxColor		  = (Red: $c000; Green: $c000; Blue: $c000; Alpha: $0000);
  colDkBlue: TGfxColor		  = (Red: $0000; Green: $0000; Blue: $8000; Alpha: $0000);
  colDkGreen: TGfxColor		  = (Red: $0000; Green: $8000; Blue: $0000; Alpha: $0000);
  colDkCyan: TGfxColor		  = (Red: $0000; Green: $8000; Blue: $8000; Alpha: $0000);
  colDkRed: TGfxColor		    = (Red: $8000; Green: $0000; Blue: $0000; Alpha: $0000);
  colDkMagenta: TGfxColor	  = (Red: $8000; Green: $0000; Blue: $8000; Alpha: $0000);
  colDkYellow: TGfxColor	  = (Red: $8000; Green: $8000; Blue: $0000; Alpha: $0000);

  webBlack: TGfxColor		    = (Red: $0000; Green: $0000; Blue: $0000; Alpha: $0000);
  webMaroon: TGfxColor		  = (Red: $8000; Green: $0000; Blue: $0000; Alpha: $0000);
  webGreen: TGfxColor		    = (Red: $0000; Green: $8000; Blue: $0000; Alpha: $0000);
  webOlive: TGfxColor		    = (Red: $8000; Green: $8000; Blue: $0000; Alpha: $0000);
  webNavy: TGfxColor		    = (Red: $0000; Green: $0000; Blue: $8000; Alpha: $0000);
  webPurple: TGfxColor		  = (Red: $8000; Green: $0000; Blue: $8000; Alpha: $0000);
  webTeal: TGfxColor		    = (Red: $0000; Green: $8000; Blue: $8000; Alpha: $0000);
  webGray: TGfxColor		    = (Red: $8000; Green: $8000; Blue: $8000; Alpha: $0000);
  webSilver: TGfxColor		  = (Red: $c000; Green: $c000; Blue: $c000; Alpha: $0000);
  webRed: TGfxColor		      = (Red: $ffff; Green: $0000; Blue: $0000; Alpha: $0000);
  webLime: TGfxColor		    = (Red: $0000; Green: $ffff; Blue: $0000; Alpha: $0000);
  webYellow: TGfxColor		  = (Red: $ffff; Green: $ffff; Blue: $0000; Alpha: $0000);
  webBlue: TGfxColor		    = (Red: $0000; Green: $0000; Blue: $ffff; Alpha: $0000);
  webFuchsia: TGfxColor		  = (Red: $ffff; Green: $0000; Blue: $ffff; Alpha: $0000);
  webAqua: TGfxColor		    = (Red: $0000; Green: $ffff; Blue: $ffff; Alpha: $0000);
  webWhite: TGfxColor		    = (Red: $ffff; Green: $ffff; Blue: $ffff; Alpha: $0000);


  // Some predefined pixel formats:

  PixelFormatMono: TGfxPixelFormat = (
    FormatType: ftMono;
    RedMask:	  0;
    GreenMask:	0;
    BlueMask:	  0;
    AlphaMask:	0);

  PixelFormatPal4: TGfxPixelFormat = (
    FormatType: ftPal4;
    RedMask:	  0;
    GreenMask:	0;
    BlueMask:	  0;
    AlphaMask:	0);

  PixelFormatPal4A: TGfxPixelFormat = (
    FormatType: ftPal4A;
    RedMask:	  0;
    GreenMask:	0;
    BlueMask:	  0;
    AlphaMask:	0);

  PixelFormatPal8: TGfxPixelFormat = (
    FormatType: ftPal8;
    RedMask:	  0;
    GreenMask:	0;
    BlueMask:	  0;
    AlphaMask:	0);

  PixelFormatPal8A: TGfxPixelFormat = (
    FormatType: ftPal8A;
    RedMask:	  0;
    GreenMask:	0;
    BlueMask:	  0;
    AlphaMask:	0);

  { Windows requires this particular order for RGB images }

  { 5-6-5 storage }
  PixelFormatRGB16: TGfxPixelFormat = (
    FormatType:	ftRGB16;
    RedMask:	  $F800;
    GreenMask:	$07E0;
    BlueMask:	  $001F;
    AlphaMask:	0);

  PixelFormatRGB24: TGfxPixelFormat = (
    FormatType:	ftRGB24;
    RedMask:	  $ff0000;
    GreenMask:	$00ff00;
    BlueMask:	  $0000ff;
    AlphaMask:	0);

  PixelFormatRGB32: TGfxPixelFormat = (
    FormatType:	ftRGB32;
    RedMask:	  $ff0000;
    GreenMask:	$00ff00;
    BlueMask:	  $0000ff;
    AlphaMask:	0);

  PixelFormatRGBA32: TGfxPixelFormat = (
    FormatType: ftRGB32;
    RedMask:	  $00ff0000;
    GreenMask:	$0000ff00;
    BlueMask:	  $000000ff;
    AlphaMask:	$ff000000);

type

  EGfxError = class(Exception);

  EGfxUnsupportedPixelFormat = class(EGfxError)
    constructor Create(const APixelFormat: TGfxPixelFormat);
  end;


  TFCustomBitmap = class;
  TFCustomApplication = class;
  TFCustomWindow = class;

  TFWindowOption = (
    woWindow, woBorderless, woPopup, woToolWindow, woChildWindow,
    woX11SkipWMHints, woModal);
  TFWindowOptions = set of TFWindowOption;

  TFCursor = (crDefault, crNone, crArrow, crCross, crIBeam, crSize, crSizeNS,
    crSizeWE, cpUpArrow, crHourGlass, crNoDrop, crHelp);

  TMouseButton = (mbLeft, mbRight, mbMiddle);

  { TFEvent }
  
  TFEventType = (etCreate, etCanClose, etClose, etFocusIn, etFocusOut,
   etHide, etKeyPressed, etKeyReleased, etKeyChar,
   etMouseEnter, etMouseLeave, etMousePressed, etMouseReleased,
   etMouseMove, etMouseWheel, etPaint, etMove, etResize, etShow);

  TFEvent = class
  public
    { Windows Window Manager fields }
    Msg: Cardinal;
    wparam: Cardinal;
    lparam: Cardinal;
    Result: Cardinal;
    MouseButton: TMouseButton;
    { X11 Window Manager fields }
    EventPointer: Pointer;
    State: Cardinal;
    Button: Cardinal;
    X, Y: Cardinal;
    Width, Height: Cardinal;
    { fpGUI fields }
    EventType: TFEventType;
  end;

  { TFCustomFont }

  TGfxFontClass = (fcSerif, fcSansSerif, fcTypewriter, fcDingbats);

  TFCustomFont = class
  protected
    FHandle: Cardinal;
  public
    class function GetDefaultFontName(const AFontClass: TGfxFontClass): String; virtual;
    property    Handle: Cardinal read FHandle;
  end;


  { TGfxPalette }

  TGfxPalette = class
  private
    FRefCount: LongInt;
    FEntryCount: Integer;
    FEntries: PGfxColor;
    function    GetEntry(AIndex: Integer): TGfxColor;
  public
    constructor Create(AEntryCount: Integer; AEntries: PGfxColor);
    destructor  Destroy; override;
    procedure   AddRef;
    procedure   Release;
    property    EntryCount: Integer read FEntryCount;
    property    Entries[AIndex: Integer]: TGfxColor read GetEntry;
  end;


  { TFCustomCanvas }

  TGfxLineStyle = (lsSolid, lsDot);

  TFCustomCanvas = class(TObject)
  private
    FMatrix: TGfxMatrix;
  protected
    FWidth: Integer;
    FHeight: Integer;
    FHandle: Cardinal;
    FPixelFormat: TGfxPixelFormat;
    FColor: TGfxColor;
    function    DoExcludeClipRect(const ARect: TRect): Boolean; virtual; abstract;
    function    DoIntersectClipRect(const ARect: TRect): Boolean; virtual; abstract;
    function    DoUnionClipRect(const ARect: TRect): Boolean; virtual; abstract;
    function    DoGetClipRect: TRect; virtual; abstract;
    procedure   DoDrawArc(const ARect: TRect; StartAngle, EndAngle: Single); virtual; abstract;
    procedure   DoDrawCircle(const ARect: TRect); virtual; abstract;
    procedure   DoDrawLine(const AFrom, ATo: TPoint); virtual; abstract;
    procedure   DoDrawRect(const ARect: TRect); virtual;
    procedure   DoDrawPoint(const APoint: TPoint); virtual; abstract;
    procedure   DoFillRect(const ARect: TRect); virtual; abstract;
    procedure   DoFillTriangle(const P1, P2, P3: TPoint); virtual; abstract;
    procedure   DoTextOut(const APosition: TPoint; const AText: String); virtual; abstract;
    procedure   DoCopyRect(ASource: TFCustomCanvas; const ASourceRect: TRect; const ADestPos: TPoint); virtual; abstract;
    procedure   DoMaskedCopyRect(ASource, AMask: TFCustomCanvas; const ASourceRect: TRect; const AMaskPos, ADestPos: TPoint); virtual; abstract;
    procedure   DoDrawImageRect(AImage: TFCustomBitmap; ASourceRect: TRect; const ADestPos: TPoint); virtual; abstract;
  public
    constructor Create;
    // Transformations
    function    Transform(APoint: TPoint): TPoint;
    function    Transform(ARect: TRect): TRect;
    function    ReverseTransform(APoint: TPoint): TPoint;
    function    ReverseTransform(ARect: TRect): TRect;
    procedure   AppendTranslation(ADelta: TPoint);

    // Graphics state
    procedure   SaveState; virtual; abstract;
    procedure   RestoreState; virtual; abstract;
    procedure   EmptyClipRect; virtual;
    procedure   DoSetColor(AColor: TGfxPixel); virtual; abstract;
    procedure   SetColor(AColor: TGfxColor); virtual;
    procedure   SetFont(AFont: TFCustomFont); virtual; abstract;
    procedure   SetLineStyle(ALineStyle: TGfxLineStyle); virtual; abstract;
    function    ExcludeClipRect(const ARect: TRect): Boolean;
    function    IntersectClipRect(const ARect: TRect): Boolean;
    function    UnionClipRect(const ARect: TRect): Boolean;
    function    GetClipRect: TRect;
    function    MapColor(const AColor: TGfxColor): TGfxPixel; virtual; abstract;
    function    GetColor: TGfxColor;

    // Drawing functions
    procedure   DrawArc(const ARect: TRect; StartAngle, EndAngle: Single);
    procedure   DrawCircle(const ARect: TRect);
    procedure   DrawLine(const AFrom, ATo: TPoint);
    procedure   DrawPolyLine(const Coords: array of TPoint); virtual;
    procedure   DrawRect(const ARect: TRect);
    procedure   DrawPoint(const APoint: TPoint);
    procedure   FillRect(const ARect: TRect);
    procedure   FillTriangle(const P1, P2, P3: TPoint);

    // Fonts
    function    FontCellHeight: Integer; virtual; abstract;
    function    TextExtent(const AText: String): TSize; virtual;
    function    TextWidth(const AText: String): Integer; virtual;
    procedure   TextOut(const APosition: TPoint; const AText: String);
//    procedure TextRect(Rect: TRect; X, Y: Integer; const Text: WideString; TextFlags: Integer = 0);
    
    // Bit block transfers
    procedure   Copy(ASource: TFCustomCanvas; const ADestPos: TPoint); virtual;
    procedure   CopyRect(ASource: TFCustomCanvas; const ASourceRect: TRect; const ADestPos: TPoint);
    procedure   MaskedCopy(ASource, AMask: TFCustomCanvas; const ADestPos: TPoint);
{!!!:    procedure MaskedCopyRect(ASource, AMask: TGfxCanvas; const ASourceRect: TRect;
      const ADestPos: TPoint); virtual;}
    procedure   MaskedCopyRect(ASource, AMask: TFCustomCanvas; const ASourceRect: TRect; const AMaskPos, ADestPos: TPoint);

    // Image drawing
    procedure   DrawImage(AImage: TFCustomBitmap; const ADestPos: TPoint);
    procedure   DrawImageRect(AImage: TFCustomBitmap; ASourceRect: TRect; const ADestPos: TPoint);

    // Properties
    property    Width: Integer read FWidth;
    property    Height: Integer read FHeight;
    property    PixelFormat: TGfxPixelFormat read FPixelFormat;
    property    Matrix: TGfxMatrix read FMatrix write FMatrix;
    property    Handle: Cardinal read FHandle;
  end;

  { TFCustomBitmap }

  TFCustomBitmap = class(TObject)
  private
    FWidth, FHeight: Integer;
    FPixelFormat: TGfxPixelFormat;
    FPalette: TGfxPalette;
    procedure   SetPalette(APalette: TGfxPalette);
  protected
    FHandle: Cardinal;
    FStride: LongWord;
    FData: Pointer;
  public
    constructor Create(AWidth, AHeight: Integer; APixelFormat: TGfxPixelFormat); virtual;
    destructor  Destroy; override;
    procedure   Lock(out AData: Pointer; out AStride: LongWord); virtual; abstract;
    procedure   Unlock; virtual; abstract;
    procedure   SetPixelsFromData(AData: Pointer; AStride: LongWord);
    property    Width: Integer read FWidth;
    property    Height: Integer read FHeight;
    property    PixelFormat: TGfxPixelFormat read FPixelFormat;
    property    Palette: TGfxPalette read FPalette write SetPalette;
    property    Handle: Cardinal read FHandle;
    property    Data: Pointer read FData;
    property    Stride: LongWord read FStride;
  end;

  { TFCustomScreen }

  TFCustomScreen = class(TObject)
  protected
    procedure   SetMousePos(const NewPos: TPoint); virtual; abstract;
    function    GetMousePos: TPoint; virtual; abstract;
  public
    constructor Create; virtual;
    function    CreateBitmapCanvas(AWidth, AHeight: Integer): TFCustomCanvas; virtual; abstract;
    function    CreateMonoBitmapCanvas(AWidth, AHeight: Integer): TFCustomCanvas; virtual; abstract;
    property    MousePos: TPoint read GetMousePos write SetMousePos;
  end;

  { TFCustomApplication }

  TFCustomApplication = class(TComponent)
  private
    FOnIdle: TNotifyEvent;
    FQuitWhenLastWindowCloses: Boolean;
  protected
    FDisplayName: String;
    DoBreakRun: Boolean;
    FTitle: String;
    procedure   SetTitle(const ATitle: String);
  public
    Forms: TList;
    { Default methods }
    constructor Create; virtual; overload;
    destructor  Destroy; override;
    procedure   AddWindow(AWindow: TFCustomWindow); virtual;
    procedure   RemoveWindow(AWindow: TFCustomWindow); virtual;
    procedure   Initialize(ADisplayName: String = ''); virtual; abstract;
    procedure   Run; virtual;
    procedure   Quit; virtual; abstract;
    { Properties }
    property    OnIdle: TNotifyEvent read FOnIdle write FOnIdle;
    property    QuitWhenLastWindowCloses: Boolean read FQuitWhenLastWindowCloses write FQuitWhenLastWindowCloses;
    property    Title: String read FTitle write SetTitle;
  end;


  { TFCustomWindow }

  // Lifetime handling
  TGfxCanCloseEvent = function(Sender: TObject): Boolean of object;
  // Keyboard
  TGfxKeyEvent = procedure(Sender: TObject; AKey: Word; AShift: TShiftState) of object;
  TGfxKeyCharEvent = procedure(Sender: TObject; AKeyChar: Char) of object;
  // Mouse
  TGfxMouseButtonEvent = procedure(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint) of object;
  TGfxMouseMoveEvent = procedure(Sender: TObject; AShift: TShiftState; const AMousePos: TPoint) of object;
  TGfxMouseWheelEvent = procedure(Sender: TObject; AShift: TShiftState; AWheelDelta: Single; const AMousePos: TPoint) of object;
  // Painting
  TGfxPaintEvent = procedure(Sender: TObject; const ARect: TRect) of object;


  TFCustomWindow = class
  private
    FCursor: TFCursor;
    FOnCreate: TNotifyEvent;
    FOnCanClose: TGfxCanCloseEvent;
    FOnClose: TNotifyEvent;
    FOnFocusIn: TNotifyEvent;
    FOnFocusOut: TNotifyEvent;
    FOnHide: TNotifyEvent;
    FOnKeyPressed: TGfxKeyEvent;
    FOnKeyReleased: TGfxKeyEvent;
    FOnKeyChar: TGfxKeyCharEvent;
    FOnMouseEnter: TGfxMouseMoveEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMousePressed: TGfxMouseButtonEvent;
    FOnMouseReleased: TGfxMouseButtonEvent;
    FOnMouseMove: TGfxMouseMoveEvent;
    FOnMouseWheel: TGfxMouseWheelEvent;
    FOnPaint: TGfxPaintEvent;
    FOnMove: TNotifyEvent;
    FOnResize: TNotifyEvent;
    FOnShow: TNotifyEvent;
    procedure SetClientHeight(const AValue: Integer);
    procedure SetClientWidth(const AValue: Integer);
    procedure SetLeft(const AValue: Integer);
    procedure SetTop(const AValue: Integer);
    procedure SetWidth(AWidth: Integer);
    procedure SetHeight(AHeight: Integer);
    procedure SetCursor(ACursor: TFCursor);
    procedure SetWindowOptions(const AValue: TFWindowOptions); virtual;
  protected
    FParent: TFCustomWindow;
    FCanvas: TFCustomCanvas;
    FLeft: Integer;
    FTop: Integer;
    FWidth: Integer;
    FHeight: Integer;
    FClientWidth: Integer;
    FClientHeight: Integer;
    FWindowOptions: TFWindowOptions;
    FChildWindows: TList;
    FMinSize, FMaxSize: TSize;
    function  GetTitle: String; virtual;
    procedure SetTitle(const ATitle: String); virtual;
    procedure DoSetCursor; virtual; abstract;
    function  GetHandle: PtrUInt; virtual; abstract;
  public
    constructor Create(AParent: TFCustomWindow; AWindowOptions: TFWindowOptions); virtual;
    destructor  Destroy; override;
    function  CanClose: Boolean; virtual;
    procedure SetPosition(const APosition: TPoint); virtual;
    procedure SetSize(const ASize: TSize); virtual;
    procedure SetMinMaxSize(const AMinSize, AMaxSize: TSize); virtual;
    procedure SetClientSize(const ASize: TSize); virtual;
    procedure SetMinMaxClientSize(const AMinSize, AMaxSize: TSize); virtual;
    procedure Show; virtual; abstract;
    procedure Invalidate(const ARect: TRect); virtual; abstract;
    procedure PaintInvalidRegion; virtual; abstract;
    procedure CaptureMouse; virtual; abstract;
    procedure ReleaseMouse; virtual; abstract;
    procedure ProcessEvent(AEvent: TFEvent); virtual; abstract;

    property WindowOptions: TFWindowOptions read FWindowOptions write SetWindowOptions;
    property Canvas: TFCustomCanvas read FCanvas;
    property Handle: PtrUInt read GetHandle;
    property ChildWindows: TList read FChildWindows;
    // Window state
    property Left: Integer read FLeft write SetLeft;
    property Top: Integer read FTop write SetTop;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property ClientWidth: Integer read FClientWidth write SetClientWidth;
    property ClientHeight: Integer read FClientHeight write SetClientHeight;
    property Cursor: TFCursor read FCursor write SetCursor;
    property Title: String read GetTitle write SetTitle;
    property Parent: TFCustomWindow read FParent;
    // Event handlers
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnCanClose: TGfxCanCloseEvent read FOnCanClose write FOnCanClose;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnFocusIn: TNotifyEvent read FOnFocusIn write FOnFocusIn;
    property OnFocusOut: TNotifyEvent read FOnFocusOut write FOnFocusOut;
    property OnHide: TNotifyEvent read FOnHide write FOnHide;
    property OnKeyPressed: TGfxKeyEvent read FOnKeyPressed write FOnKeyPressed;
    property OnKeyReleased: TGfxKeyEvent read FOnKeyReleased write FOnKeyReleased;
    property OnKeyChar: TGfxKeyCharEvent read FOnKeyChar write FOnKeyChar;
    property OnMouseEnter: TGfxMouseMoveEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMousePressed: TGfxMouseButtonEvent read FOnMousePressed write FOnMousePressed;
    property OnMouseReleased: TGfxMouseButtonEvent read FOnMouseReleased write FOnMouseReleased;
    property OnMouseMove: TGfxMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseWheel: TGfxMouseWheelEvent read FOnMouseWheel write FOnMouseWheel;
    property OnPaint: TGfxPaintEvent read FOnPaint write FOnPaint;
    property OnMove: TNotifyEvent read FOnMove write FOnMove;
    property OnResize: TNotifyEvent read FOnResize write FOnResize;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
  end;

// Some helpers:

// Sizes, points etc.
function Size(AWidth, AHeight: Integer): TSize;
function Size(ARect: TRect): TSize;
function PtInRect(const ARect: TRect; const APoint: TPoint): Boolean;

{$ifdef fpc}
operator = (const ASize1, ASize2: TSize) b: Boolean;
operator + (const APoint1, APoint2: TPoint) p: TPoint;
operator + (const APoint: TPoint; ASize: TSize) p: TPoint;
operator + (const ASize: TSize; APoint: TPoint) s: TSize;
operator + (const ASize1, ASize2: TSize) s: TSize;
operator + (const APoint: TPoint; i: Integer) p: TPoint;
operator + (const ASize: TSize; i: Integer) s: TSize;
operator - (const APoint1, APoint2: TPoint) p: TPoint;
operator - (const APoint: TPoint; i: Integer) p: TPoint;
operator - (const ASize: TSize; const APoint: TPoint) s: TSize;
operator - (const ASize: TSize; i: Integer) s: TSize;

// Colors
operator = (const AColor1, AColor2: TGfxColor) b: Boolean;
{$endif}
function GetAvgColor(const AColor1, AColor2: TGfxColor): TGfxColor;
function GfxColorToTColor(const AColor: TGfxColor): TColor;


// Keyboard
function KeycodeToText(Key: Word; ShiftState: TShiftState): String;


implementation

uses
  CommandLineParams
  ;


{ Exceptions }

constructor EGfxUnsupportedPixelFormat.Create(const
  APixelFormat: TGfxPixelFormat);
begin
  inherited CreateFmt(SUnsupportedPixelFormat,
    [FormatTypeBPPTable[APixelFormat.FormatType]]);
end;

{ TFCustomFont }

class function TFCustomFont.GetDefaultFontName(const AFontClass: TGfxFontClass): String;
const
  FontNames: array[TGfxFontClass] of String = (
    'times', 'helvetica', 'courier', 'dingbats');
begin
  Result := FontNames[AFontClass];
end;

{ TGfxPalette }

destructor TGfxPalette.Destroy;
begin
  if Assigned(FEntries) then
    FreeMem(FEntries);
  inherited Destroy;
end;

procedure TGfxPalette.AddRef;
begin
  Inc(FRefCount);
end;

procedure TGfxPalette.Release;
begin
  if FRefCount <= 0 then
    Free
  else
    Dec(FRefCount);
end;

constructor TGfxPalette.Create(AEntryCount: Integer; AEntries: PGfxColor);
begin
  inherited Create;
  FEntryCount := AEntryCount;
  GetMem(FEntries, EntryCount * SizeOf(TGfxColor));
  if Assigned(AEntries) then
    Move(AEntries^, FEntries^, EntryCount * SizeOf(TGfxColor));
end;

function TGfxPalette.GetEntry(AIndex: Integer): TGfxColor;
begin
  if (AIndex >= 0) and (AIndex < EntryCount) then
    Result := FEntries[AIndex]
  else
    Result := colBlack;
end;


{ TFCustomCanvas }

constructor TFCustomCanvas.Create;
begin
  inherited Create;
  Matrix        := GfxIdentityMatrix;
  FColor        := colBlack;
end;

function TFCustomCanvas.Transform(APoint: TPoint): TPoint;
begin
  Result.x      := Matrix._00 * APoint.x + Matrix._20;
  Result.y      := Matrix._11 * APoint.y + Matrix._21;
end;

function TFCustomCanvas.Transform(ARect: TRect): TRect;
begin
  Result.Left   := Matrix._00 * ARect.Left + Matrix._20;
  Result.Top    := Matrix._11 * ARect.Top + Matrix._21;
  Result.Right  := Matrix._00 * ARect.Right + Matrix._20;
  Result.Bottom := Matrix._11 * ARect.Bottom + Matrix._21;
end;

function TFCustomCanvas.ReverseTransform(APoint: TPoint): TPoint;
begin
  Result.x      := (APoint.x - Matrix._20) div Matrix._00;
  Result.y      := (APoint.y - Matrix._21) div Matrix._11;
end;

function TFCustomCanvas.ReverseTransform(ARect: TRect): TRect;
begin
  Result.Left   := (ARect.Left - Matrix._20) div Matrix._00;
  Result.Top    := (ARect.Top - Matrix._21) div Matrix._11;
  Result.Right  := (ARect.Right - Matrix._20) div Matrix._00;
  Result.Bottom := (ARect.Bottom - Matrix._21) div Matrix._11;
end;

procedure TFCustomCanvas.AppendTranslation(ADelta: TPoint);
begin
  // Append a translation to the existing transformation matrix
  Inc(FMatrix._20, FMatrix._00 * ADelta.x);
  Inc(FMatrix._21, FMatrix._11 * ADelta.y);
end;

procedure TFCustomCanvas.EmptyClipRect;
begin
  IntersectClipRect(Rect(0, 0, 0, 0));
end;

function TFCustomCanvas.ExcludeClipRect(const ARect: TRect): Boolean;
var
  Rect: TRect;
begin
  Rect := Transform(ARect);
  if (Rect.Right > Rect.Left) and (Rect.Bottom > Rect.Top) then
    Result := DoExcludeClipRect(Rect)
  else
    Result := False;
end;

function TFCustomCanvas.IntersectClipRect(const ARect: TRect): Boolean;
var
  Rect: TRect;
begin
  Rect := Transform(ARect);
  if (Rect.Right > Rect.Left) and (Rect.Bottom > Rect.Top) then
    Result := DoIntersectClipRect(Rect)
  else
    Result := False;
end;

function TFCustomCanvas.UnionClipRect(const ARect: TRect): Boolean;
var
  Rect: TRect;
begin
  Rect := Transform(ARect);
  if (Rect.Right > Rect.Left) and (Rect.Bottom > Rect.Top) then
    Result := DoUnionClipRect(Rect)
  else
    with GetClipRect do
      Result := (Right > Left) and (Bottom > Top);
end;

function TFCustomCanvas.GetClipRect: TRect;
begin
  Result := ReverseTransform(DoGetClipRect);
end;

function TFCustomCanvas.GetColor: TGfxColor;
begin
  result := FColor;
end;

procedure TFCustomCanvas.SetColor(AColor: TGfxColor);
begin
  FColor := AColor;
  DoSetColor(MapColor(AColor));
end;

procedure TFCustomCanvas.DrawArc(const ARect: TRect; StartAngle, EndAngle: Single);
begin
  DoDrawArc(Transform(ARect), StartAngle, EndAngle);
end;

procedure TFCustomCanvas.DrawCircle(const ARect: TRect);
begin
  DoDrawCircle(Transform(ARect));
end;

procedure TFCustomCanvas.DrawLine(const AFrom, ATo: TPoint);
begin
  DoDrawLine(Transform(AFrom), Transform(ATo));
end;

procedure TFCustomCanvas.DrawPolyLine(const Coords: array of TPoint);
var
  i: Integer;
begin
  for i := Low(Coords) to High(Coords) do
    DrawLine(Coords[i], Coords[i + 1]);
end;

procedure TFCustomCanvas.DoDrawRect(const ARect: TRect);
begin
{  DrawPolyLine(
    [ARect.TopLeft,
     Point(ARect.Right - 1, ARect.Top),
     Point(ARect.Right - 1, ARect.Bottom - 1),
     Point(ARect.Left, ARect.Bottom - 1),
     ARect.TopLeft]);}
  DoDrawLine(ARect.TopLeft, Point(ARect.Right - 1, ARect.Top));
  DoDrawLine(Point(ARect.Right - 1, ARect.Top), Point(ARect.Right - 1, ARect.Bottom - 1));
  DoDrawLine(Point(ARect.Right - 1, ARect.Bottom - 1), Point(ARect.Left, ARect.Bottom - 1));
  DoDrawLine(Point(ARect.Left, ARect.Bottom - 1), ARect.TopLeft);
end;

procedure TFCustomCanvas.DrawRect(const ARect: TRect);
var
  r: TRect;
begin
  r := Transform(ARect);
  if (r.Right > r.Left) and (r.Bottom > r.Top) then
    DoDrawRect(r);
end;

procedure TFCustomCanvas.DrawPoint(const APoint: TPoint);
begin
  DoDrawPoint(Transform(APoint));
end;

procedure TFCustomCanvas.FillRect(const ARect: TRect);
var
  r: TRect;
begin
  r := Transform(ARect);
  if (r.Right > r.Left) and (r.Bottom > r.Top) then
    DoFillRect(r);
end;

procedure TFCustomCanvas.FillTriangle(const P1, P2, P3: TPoint);
begin
  DoFillTriangle(P1, P2, P3);
end;

function TFCustomCanvas.TextExtent(const AText: String): TSize;
begin
  Result.cx := TextWidth(AText);
  Result.cy := FontCellHeight;
end;

function TFCustomCanvas.TextWidth(const AText: String): Integer;
begin
  Result := TextExtent(AText).cx;
end;

procedure TFCustomCanvas.TextOut(const APosition: TPoint; const AText: String);
begin
  DoTextOut(Transform(APosition), AText);
end;

procedure TFCustomCanvas.Copy(ASource: TFCustomCanvas; const ADestPos: TPoint);
begin
  ASSERT(Assigned(ASource));
  CopyRect(ASource, Rect(0, 0, ASource.Width, ASource.Height), ADestPos);
end;

procedure TFCustomCanvas.CopyRect(ASource: TFCustomCanvas; const ASourceRect: TRect;
  const ADestPos: TPoint);
var
  SourceRect: TRect;
begin
  SourceRect := ASource.Transform(ASourceRect);
  with SourceRect do
    if (Left >= Right) or (Top >= Bottom) then
      exit;

  DoCopyRect(ASource, SourceRect, Transform(ADestPos));
end;

procedure TFCustomCanvas.MaskedCopy(ASource, AMask: TFCustomCanvas;
  const ADestPos: TPoint);
begin
  MaskedCopyRect(ASource, AMask, Rect(0, 0, ASource.Width, ASource.Height),
    Point(0, 0), ADestPos);
end;

procedure TFCustomCanvas.MaskedCopyRect(ASource, AMask: TFCustomCanvas;
  const ASourceRect: TRect; const AMaskPos, ADestPos: TPoint);
begin
  DoMaskedCopyRect(ASource, AMask, ASource.Transform(ASourceRect),
    AMask.Transform(AMaskPos), Transform(ADestPos));
end;

procedure TFCustomCanvas.DrawImage(AImage: TFCustomBitmap; const ADestPos: TPoint);
begin
  DrawImageRect(AImage, Rect(0, 0, AImage.Width, AImage.Height), ADestPos);
end;

procedure TFCustomCanvas.DrawImageRect(AImage: TFCustomBitmap; ASourceRect: TRect;
  const ADestPos: TPoint);
var
  SourceRect: TRect;
begin
  SourceRect := ASourceRect;
{  if SourceRect.Right > Width then
    SourceRect.Right := Width;
  if SourceRect.Bottom > Height then
    SourceRect.Bottom := Height;}

  if (SourceRect.Right > SourceRect.Left) and
    (SourceRect.Bottom > SourceRect.Top) then
    DoDrawImageRect(AImage, SourceRect, Transform(ADestPos));
end;

{ TFCustomBitmap }

destructor TFCustomBitmap.Destroy;
begin
  if Assigned(FPalette) then
    FPalette.Free;
  inherited Destroy;
end;

procedure TFCustomBitmap.SetPixelsFromData(AData: Pointer; AStride: LongWord);
var
  DestData: Pointer;
  DestStride, BytesPerScanline: LongWord;
  y: Integer;
begin
  DestStride  := 0;   // to remove compiler warning
  DestData    := nil;
  if Height <= 0 then
    exit;

  Lock(DestData, DestStride);
  try
    if DestStride = AStride then
      Move(AData^, DestData^, AStride * Height)
    else
    begin
      if DestStride > AStride then
        BytesPerScanline := AStride
      else
        BytesPerScanline := DestStride;

      y := 0;
      while True do
      begin
        Move(AData^, DestData^, BytesPerScanline);
	      Inc(y);
      	if y = Height then
      	  break;
      	Inc(AData, AStride);
      	Inc(DestData, DestStride);
      end;
    end;
  finally
    Unlock;
  end;
end;

constructor TFCustomBitmap.Create(AWidth, AHeight: Integer;
  APixelFormat: TGfxPixelFormat);
begin
  FWidth := AWidth;
  FHeight := AHeight;
  FPixelFormat := APixelFormat;
end;

procedure TFCustomBitmap.SetPalette(APalette: TGfxPalette);
begin
  if APalette <> Palette then
  begin
    if Assigned(Palette) then
      Palette.Release;

    FPalette := APalette;

    if Assigned(Palette) then
      Palette.AddRef;
  end;
end;

{ TFCustomScreen }

constructor TFCustomScreen.Create;
begin
  inherited Create;
  
end;

{ TFCustomWindow }

function TFCustomWindow.CanClose: Boolean;
begin
  if Assigned(OnCanClose) then
    Result := OnCanClose(Self)
  else
    Result := True;
end;

procedure TFCustomWindow.SetPosition(const APosition: TPoint);
begin
  // Empty
end;

procedure TFCustomWindow.SetSize(const ASize: TSize);
begin
  // Empty
end;

procedure TFCustomWindow.SetMinMaxSize(const AMinSize, AMaxSize: TSize);
begin
  // Empty
end;

procedure TFCustomWindow.SetClientSize(const ASize: TSize);
begin
  // Empty
end;

procedure TFCustomWindow.SetMinMaxClientSize(const AMinSize, AMaxSize: TSize);
begin
  // Empty
end;

function TFCustomWindow.GetTitle: String;
begin
  SetLength(Result, 0);
end;

procedure TFCustomWindow.SetTitle(const ATitle: String);
begin
  // Empty
end;

constructor TFCustomWindow.Create(AParent: TFCustomWindow;
        AWindowOptions: TFWindowOptions);
begin
  inherited Create;

  FWindowOptions := AWindowOptions;
  FParent := AParent;

  FChildWindows := TList.Create;
  
  if AParent <> nil then AParent.ChildWindows.Add(Self);
end;

destructor TFCustomWindow.Destroy;
begin
  FChildWindows.Free;

  inherited Destroy;
end;

procedure TFCustomWindow.SetWidth(AWidth: Integer);
begin
  SetSize(Size(AWidth, Height));
end;

procedure TFCustomWindow.SetLeft(const AValue: Integer);
begin
  SetPosition(Point(AValue, FTop));
end;

procedure TFCustomWindow.SetClientHeight(const AValue: Integer);
begin
  SetClientSize(Size(Width, AValue));
end;

procedure TFCustomWindow.SetClientWidth(const AValue: Integer);
begin
  SetClientSize(Size(AValue, Height));
end;

procedure TFCustomWindow.SetTop(const AValue: Integer);
begin
  SetPosition(Point(FLeft, AValue));
end;

procedure TFCustomWindow.SetHeight(AHeight: Integer);
begin
  SetSize(Size(Width, AHeight));
end;

procedure TFCustomWindow.SetCursor(ACursor: TFCursor);
begin
  if ACursor <> Cursor then
  begin
    FCursor := ACursor;
    DoSetCursor;
  end;
end;

procedure TFCustomWindow.SetWindowOptions(const AValue: TFWindowOptions);
begin
  if FWindowOptions=AValue then exit;
  FWindowOptions:=AValue;
end;

{ Global functions }

{ Sizes, points etc. }

function Size(AWidth, AHeight: Integer): TSize;
begin
  Result.cx := AWidth;
  Result.cy := AHeight;
end;

function Size(ARect: TRect): TSize;
begin
  Result.cx := ARect.Right - ARect.Left;
  Result.cy := ARect.Bottom - ARect.Top;
end;

function PtInRect(const ARect: TRect; const APoint: TPoint): Boolean;
begin
  with ARect, APoint do
    Result := (x >= Left) and (y >= Top) and (x < Right) and (y < Bottom);
end;

{ Only Free Pascal supports operator overloading at the moment }

{$ifdef fpc}

operator = (const ASize1, ASize2: TSize) b: Boolean;
begin
  b := (ASize1.cx = ASize2.cx) and (ASize1.cy = ASize2.cy);
end;

operator + (const APoint1, APoint2: TPoint) p: TPoint;
begin
  p.x := APoint1.x + APoint2.x;
  p.y := APoint1.y + APoint2.y;
end;

operator + (const APoint: TPoint; ASize: TSize) p: TPoint;
begin
  p.x := APoint.x + ASize.cx;
  p.y := APoint.y + ASize.cy;
end;

operator + (const ASize: TSize; APoint: TPoint) s: TSize;
begin
  s.cx := ASize.cx + APoint.x;
  s.cy := ASize.cy + APoint.y;
end;

operator + (const ASize1, ASize2: TSize) s: TSize;
begin
  s.cx := ASize1.cx + ASize2.cx;
  s.cy := ASize1.cy + ASize2.cy;
end;

operator + (const APoint: TPoint; i: Integer) p: TPoint;
begin
  p.x := APoint.x + i;
  p.y := APoint.y + i;
end;

operator + (const ASize: TSize; i: Integer) s: TSize;
begin
  s.cx := ASize.cx + i;
  s.cy := ASize.cy + i;
end;

operator - (const APoint1, APoint2: TPoint) p: TPoint;
begin
  p.x := APoint1.x - APoint2.x;
  p.y := APoint1.y - APoint2.y;
end;

operator - (const APoint: TPoint; i: Integer) p: TPoint;
begin
  p.x := APoint.x - i;
  p.y := APoint.y - i;
end;

operator - (const ASize: TSize; const APoint: TPoint) s: TSize;
begin
  s.cx := ASize.cx - APoint.x;
  s.cy := ASize.cy - APoint.y;
end;

operator - (const ASize: TSize; i: Integer) s: TSize;
begin
  s.cx := ASize.cx - i;
  s.cy := ASize.cy - i;
end;


{ Color functions }

operator = (const AColor1, AColor2: TGfxColor) b: Boolean;
begin
  b := (AColor1.Red = AColor2.Red) and (AColor1.Green = AColor2.Green) and
    (AColor1.Blue = AColor2.Blue) and (AColor1.Alpha = AColor2.Alpha);
end;
{$endif}

function GetAvgColor(const AColor1, AColor2: TGfxColor): TGfxColor;
begin
  Result.Red := AColor1.Red + (AColor2.Red - AColor1.Red) div 2;
  Result.Green := AColor1.Green + (AColor2.Green - AColor1.Green) div 2;
  Result.Blue := AColor1.Blue + (AColor2.Blue - AColor1.Blue) div 2;
  Result.Alpha := AColor1.Alpha + (AColor2.Alpha - AColor1.Alpha) div 2;
end;

function GfxColorToTColor(const AColor: TGfxColor): TColor;
begin
  Result := ((AColor.Red shr 8) and $ff)
            or (AColor.Green and $ff00)
            or ((AColor.Blue shl 8) and $ff0000);
end;


{ Keyboard functions }

function KeycodeToText(Key: Word; ShiftState: TShiftState): String;

  function GetASCIIText: String;
  var
    c: Char;
  begin
    result := '';
    c := Chr(Key and $ff);
    case c of
      #13:  Result := Result + 'Enter';
      #127: Result := Result + 'Del';
      '+':  Result := Result + 'Plus'
      else
        Result := Result + c;
    end;
  end;

var
  s: String;
begin
  SetLength(Result, 0);

  if ssShift in ShiftState then
    Result := 'Shift+';
  if ssCtrl in ShiftState then
    Result := 'Ctrl+';
  if ssAlt in ShiftState then
    Result := 'Alt+';

  if (Key > Ord(' ')) and (Key < 255) then
  begin
    Result := Result + GetASCIIText;
    exit;
  end;

  case Key of
    keyNul:           s := 'Null';
    keyBackSpace:     s := 'Backspace';
    keyTab:           s := 'Tab';
    keyLinefeed:      s := 'Linefeed';
    keyReturn:        s := 'Enter';
    keyEscape:        s := 'Esc';
    Ord(' '):         s := 'Space';
    keyDelete:        s := 'Del';
    keyVoid:          s := 'Void';
    keyBreak:         s := 'Break';
    keyScrollForw:    s := 'ScrollForw';
    keyScrollBack:    s := 'ScrollBack';
    keyBoot:          s := 'Boot';
    keyCompose:       s := 'Compose';
    keySAK:           s := 'SAK';
    keyUndo:          s := 'Undo';
    keyRedo:          s := 'Redo';
    keyMenu:          s := 'Menu';
    keyCancel:        s := 'Cancel';
    keyPrintScreen:   s := 'PrtScr';
    keyExecute:       s := 'Exec';
    keyFind:          s := 'Find';
    keyBegin:         s := 'Begin';
    keyClear:         s := 'Clear';
    keyInsert:        s := 'Ins';
    keySelect:        s := 'Select';
    keyMacro:         s := 'Macro';
    keyHelp:          s := 'Help';
    keyDo:            s := 'Do';
    keyPause:         s := 'Pause';
    keySysRq:         s := 'SysRq';
    keyModeSwitch:    s := 'ModeSw';
    keyUp:            s := 'Up';
    keyDown:          s := 'Down';
    keyLeft:          s := 'Left';
    keyRight:         s := 'Right';
    keyPrior:         s := 'PgUp';
    keyNext:          s := 'PgDown';
    keyHome:          s := 'Home';
    keyEnd:           s := 'End';
    keyF0..keyF64:    s := 'F' + IntToStr(Key - keyF0);
    keyP0..keyP9:     s := 'KP' + Chr(Key - keyP0 + Ord('0'));
    keyPA..keyPF:     s := 'KP' + Chr(Key - keyPA + Ord('A'));
    keyPPlus, keyPMinus, keyPSlash, keyPStar, keyPEqual, keyPSeparator,
      keyPDecimal, keyPParenLeft, keyPParenRight, keyPSpace, keyPEnter,
      keyPTab:        s := 'KP' + GetASCIIText;
    keyPPlusMinus:    s := 'KPPlusMinus';
    keyPBegin:        s := 'KPBegin';
    keyPF1..keyPF9:   s := 'KPF' + IntToStr(Key - keyPF1);
    keyShiftL:        s := 'ShiftL';
    keyShiftR:        s := 'ShiftR';
    keyCtrlL:         s := 'CtrlL';
    keyCtrlR:         s := 'CtrlR';
    keyAltL:          s := 'AltL';
    keyAltR:          s := 'AltR';
    keyMetaL:         s := 'MetaL';
    keyMetaR:         s := 'MetaR';
    keySuperL:        s := 'SuperL';
    keySuperR:        s := 'SuperR';
    keyHyperL:        s := 'HyperL';
    keyHyperR:        s := 'HyperR';
    keyAltGr:         s := 'AltGr';
    keyCaps:          s := 'Caps';
    keyNum:           s := 'Num';
    keyScroll:        s := 'Scroll';
    keyShiftLock:     s := 'ShiftLock';
    keyCtrlLock:      s := 'CtrlLock';
    keyAltLock:       s := 'AltLock';
    keyMetaLock:      s := 'MetaLock';
    keySuperLock:     s := 'SuperLock';
    keyHyperLock:     s := 'HyperLock';
    keyAltGrLock:     s := 'AltGrLock';
    keyCapsLock:      s := 'CapsLock';
    keyNumLock:       s := 'NumLock';
    keyScrollLock:    s := 'ScrollLock';
    keyDeadRing:      s := 'DeadRing';
    keyDeadCaron:     s := 'DeadCaron';
    keyDeadOgonek:    s := 'DeadOgonek';
    keyDeadIota:      s := 'DeadIota';
    keyDeadDoubleAcute:     s := 'DeadDoubleAcute';
    keyDeadBreve:           s := 'DeadBreve';
    keyDeadAboveDot:        s := 'DeadAboveDot';
    keyDeadBelowDot:        s := 'DeadBelowDot';
    keyDeadVoicedSound:     s := 'DeadVoicedSound';
    keyDeadSemiVoicedSound: s := 'DeadSemiVoicedSound';
    keyDeadAcute:           s := 'DeadAcute';
    keyDeadCedilla:         s := 'DeadCedilla';
    keyDeadCircumflex:      s := 'DeadCircumflex';
    keyDeadDiaeresis:       s := 'DeadDiaeresis';
    keyDeadGrave:           s := 'DeadGrave';
    keyDeadTilde:           s := 'DeadTilde';
    keyDeadMacron:          s := 'DeadMacron';

    keyEcuSign:       s := 'Ecu';
    keyColonSign:     s := 'Colon';
    keyCruzeiroSign:  s := 'Cruzeiro';
    keyFFrancSign:    s := 'FFranc';
    keyLiraSign:      s := 'Lira';
    keyMillSign:      s := 'Mill';
    keyNairaSign:     s := 'Naira';
    keyPesetaSign:    s := 'Peseta';
    keyRupeeSign:     s := 'Rupee';
    keyWonSign:       s := 'Won';
    keyNewSheqelSign: s := 'NewShequel';
    keyDongSign:      s := 'Dong';
    keyEuroSign:      s := 'Euro';
  else
    s := '#' + IntToHex(Key, 4);
  end;
  Result := Result + s;
end;

{ TFCustomApplication }

procedure TFCustomApplication.SetTitle(const ATitle: String);
begin
  if ATitle <> FTitle then FTitle := ATitle;
end;

constructor TFCustomApplication.Create;
begin
  inherited Create(nil);
  if gCommandLineParams.IsParam('display') then
    FDisplayName := gCommandLineParams.GetParam('display')
  else
    FDisplayName := '';
  Forms := TList.Create;
  FQuitWhenLastWindowCloses := True;
end;

destructor TFCustomApplication.Destroy;
begin
  Forms.Free;
  inherited Destroy;
end;

procedure TFCustomApplication.AddWindow(AWindow: TFCustomWindow);
begin
{$IFDEF VerboseFPGUI}
  WriteLn('[TFCustomApplication.AddWindow] Window Title: ', AWindow.Title);
{$ENDIF}

  if Forms.IndexOf(AWindow) = -1 then
    Forms.Add(AWindow);
end;

procedure TFCustomApplication.RemoveWindow(AWindow: TFCustomWindow);
begin
{$IFDEF VerboseFPGUI}
  WriteLn('[TFCustomApplication.RemoveWindow] Window Title: ', AWindow.Title);
{$ENDIF}

  if (Assigned(Forms) and Assigned(AWindow)) then Forms.Remove(AWindow);
end;

procedure TFCustomApplication.Run;
begin
  DoBreakRun := False;

  if gCommandLineParams.IsParam('?') or gCommandLineParams.IsParam('help') then
  begin
    writeln(' ');
    writeln(' The following parameters are supported by fpGUI applications.');
    writeln(' ');
    writeln(' -?               Shows this help');
    writeln(' -display         fpGUI/X11 only: sets the display to use');
    writeln(' -style           Overrides the default (auto detected) GUI style');
    writeln(' ');
    DoBreakRun := True;
  end;
end;

{procedure TFCustomApplication.CreateForm(AForm: TFCustomForm);
var
  form: PForm;
  Filename: String;
  TextStream, BinStream: TStream;
begin
  form := @Reference;
  form^ := TFCustomForm(InstanceClass.Create(Self));

  Filename := LowerCase(Copy(InstanceClass.ClassName, 2, 255)) + '.frm';

  TextStream := TFileStream.Create(Filename, fmOpenRead);
  BinStream := TMemoryStream.Create;
  ObjectTextToBinary(TextStream, BinStream);
  TextStream.Free;

  BinStream.Position := 0;
  BinStream.ReadComponent(Form^);
  BinStream.Free;

  Form^.Show;
end;}

end.
