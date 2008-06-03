program anim_test;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils,
  // fpGUI
  fpgfx, gui_form, gfxbase, gui_button,
  gui_label, gui_trackbar, gui_animation;

type

  TMainForm = class(TfpgForm)
  private
    procedure TrackbarChanged(Sender: TObject; APosition: integer);
    procedure btnQuitClicked(Sender: TObject);
    procedure btnStartClicked(Sender: TObject);
  public
    {@VFD_HEAD_BEGIN: MainForm}
    btnQuit: TfpgButton;
    btnStart: TfpgButton;
    tbName1: TfpgTrackBar;
    Anim1: TfpgImgAnim;
    wanda: TfpgImgAnim;
    lblName1: TfpgLabel;
    lblName2: TfpgLabel;
    lblName3: TfpgLabel;
    {@VFD_HEAD_END: MainForm}
    procedure AfterCreate; override;
  end;

{@VFD_NEWFORM_DECL}



{@VFD_NEWFORM_IMPL}

procedure TMainForm.TrackbarChanged(Sender: TObject; APosition: integer);
begin
  Anim1.Position := APosition;
end;

procedure TMainForm.btnQuitClicked(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.btnStartClicked(Sender: TObject);
begin
  if btnStart.Tag = 0 then
    btnStart.Tag := 1
  else
    btnStart.Tag := 0;
    
  case btnStart.Tag of
    0:
      begin
        btnStart.Text := 'Start';
        Anim1.Enabled := False;
      end;

    1:
      begin
        btnStart.Text := 'Stop';
        Anim1.Enabled := True;
      end;
  end;  { case }
end;

procedure TMainForm.AfterCreate;
begin
  {@VFD_BODY_BEGIN: MainForm}
  Name := 'MainForm';
  SetPosition(329, 251, 300, 250);
  WindowTitle := 'Animation Demo';
  Sizeable := False;
  WindowPosition := wpScreenCenter;

  btnQuit := TfpgButton.Create(self);
  with btnQuit do
  begin
    Name := 'btnQuit';
    SetPosition(212, 216, 80, 24);
    Text := 'Quit';
    FontDesc := '#Label1';
    ImageName := '';
    OnClick := @btnQuitClicked;
  end;

  btnStart := TfpgButton.Create(self);
  with btnStart do
  begin
    Name := 'btnStart';
    SetPosition(140, 12, 80, 24);
    Text := 'Start';
    FontDesc := '#Label1';
    ImageName := '';
    TabOrder := 1;
    OnClick := @btnStartClicked;
  end;

  tbName1 := TfpgTrackBar.Create(self);
  with tbName1 do
  begin
    Name := 'tbName1';
    SetPosition(154, 84, 100, 30);
    Max := 3;
    ShowPosition := True;
    TabOrder := 2;
    OnChange := @TrackbarChanged;
  end;

  Anim1 := TfpgImgAnim.Create(self);
  with Anim1 do
  begin
    Name := 'Anim1';
    SetPosition(16, 12, 110, 100);
    ImageFileName := 'gears.bmp';
  end;

  wanda := TfpgImgAnim.Create(self);
  with wanda do
  begin
    Name := 'wanda';
    SetPosition(64, 156, 104, 40);
    IsTransparent := False;
    ImageFileName := 'wanda.bmp';
    FrameCount := 8;
    Interval := 300;
    Enabled := True;
  end;

  lblName1 := TfpgLabel.Create(self);
  with lblName1 do
  begin
    Name := 'lblName1';
    SetPosition(140, 52, 152, 16);
    FontDesc := '#Label2';
    Text := 'Step through frames';
  end;

  lblName2 := TfpgLabel.Create(self);
  with lblName2 do
  begin
    Name := 'lblName2';
    SetPosition(56, 136, 192, 16);
    FontDesc := '#Label2';
    Text := 'Wanda the fish';
  end;

  lblName3 := TfpgLabel.Create(self);
  with lblName3 do
  begin
    Name := 'lblName3';
    SetPosition(140, 68, 152, 16);
    FontDesc := '#Label1';
    Text := '(stop the animation first)';
  end;

  {@VFD_BODY_END: MainForm}
end;


procedure MainProc;
var
  frm: TMainForm;
begin
  fpgApplication.Initialize;
  frm := TMainForm.Create(nil);
  try
    frm.Show;
    fpgApplication.Run;
  finally
    frm.Free;
  end;
end;

begin
  MainProc;
end.

