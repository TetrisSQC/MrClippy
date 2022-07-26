unit umain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, clippyagent;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    cbAnimation: TComboBox;
    procedure cbAnimationChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FCLippy: TClippy;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

procedure TfrmMain.FormCreate(Sender: TObject);
var
  i: integer;
begin
  FCLippy := TClippy.Create(self);
  FClippy.Parent := self;
  FClippy.Top := 50;
  for i := 0 to FClippy.Count - 1 do
    cbAnimation.Items.add(FClippy.Items[i]);
  cbAnimation.ItemIndex := 0;
  cbAnimationChange(nil);

 (* BorderStyle := bsNone;
  Color := clRed;
  SetWindowLongPtr(Self.Handle, GWL_EXSTYLE, GetWindowLongPtr(Self.Handle,
    GWL_EXSTYLE) or WS_EX_LAYERED);
  SetLayeredWindowAttributes(Self.Handle, clRed, 0, LWA_COLORKEY);
  *)
end;

procedure TfrmMain.cbAnimationChange(Sender: TObject);
begin
  FClippy.LoadAnim(FClippy.Items[cbAnimation.ItemIndex]);
end;

end.
