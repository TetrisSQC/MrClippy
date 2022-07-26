unit clippyagent;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, ExtCtrls;

type
  TClippy = class(TGraphicControl)
  private
    FAgent: TPicture;
    FAnim: TStringList;
    FTimer: TTimer;
    FFrames: array of integer;
    FIndex: integer;
    FLoop: boolean;

    procedure DoTimer(Sender: TObject);
    function GetCount: integer;
    function GetItems(const AIndex: integer): string;
  protected
    procedure Paint; override;
  public
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;

    procedure LoadAnim(const AGesture: string);

    property Items[index: integer]: string read GetItems;
    property Count: integer read GetCount;
    property Loop: boolean read FLoop write FLoop;
  end;

implementation

uses lcltype;

{$R clippyagent.res}

const
  AGENT_HEIGHT = 93;
  AGENT_WIDTH = 124;

function GetToken(var Line: string; ch: char = ','): string;
var
  i: integer;
begin
  i := pos(ch, Line);
  if i > 0 then
  begin
    Result := copy(Line, 1, i - 1);
    Delete(Line, 1, i);
  end
  else
  begin
    Result := Line;
    Line := '';
  end;
end;

constructor TClippy.Create(AOwner: TComponent);
var
  LStream: TResourceStream;
begin
  inherited;
  FAgent := TPicture.Create;
  FAnim := TStringList.Create;

  LStream := TResourceStream.Create(hinstance, 'AGENT', RT_RCDATA);
  try
    LStream.Position := 0;
    FAgent.LoadFromStream(LStream);
  finally
    LStream.Free;
  end;

  LStream := TResourceStream.Create(hinstance, 'ANIM', RT_RCDATA);
  try
    FAnim.LoadFromStream(LStream);
  finally
    LStream.Free;
  end;

  FTimer := TTimer.Create(nil);
  FTimer.Interval := 100;
  FTimer.OnTimer := @DoTimer;
  FTimer.Enabled := True;
  Width := AGENT_WIDTH;
  Height := AGENT_HEIGHT;
  LoadAnim('Idle');
end;

destructor TClippy.Destroy;
begin
  FAgent.Free;
  FAnim.Free;
  inherited;
end;

function TClippy.GetCount: integer;
begin
  Result := FAnim.Count;
end;

function TClippy.GetItems(const AIndex: integer): string;
begin
  Result := FAnim.Names[AIndex];
end;

procedure TClippy.LoadAnim(const AGesture: string);
var
  Value: string;
  frame: integer;
begin
  SetLength(FFrames, 0);

  Value := FAnim.Values[AGesture];
  while Value <> '' do
  begin
    frame := StrToInt(GetToken(Value));
    SetLength(FFrames, Length(FFrames) + 1);
    FFrames[high(FFrames)] := frame;
  end;

  if Length(FFrames) = 0 then
  begin
    SetLength(FFrames, 1);
    FFrames[0] := 0;
  end;

  FIndex := 0;
end;


procedure TClippy.DoTimer(Sender: TObject);
var
  lastIndex: integer;
begin
  lastIndex := FIndex;

  if FLoop then
  begin
    FIndex := (Findex + 1) mod length(FFrames);
  end
  else
  begin
    if FIndex < High(FFrames) then
      Inc(FIndex);
  end;

  if lastIndex <> FIndex then
    invalidate;
end;

procedure TClippy.Paint;
var
  R: TRect;
  P: TPoint;
  columns, index: integer;
begin
  index := FFrames[FIndex];
  columns := FAgent.Width div AGENT_WIDTH;

  P.x := index mod columns;
  P.y := index div columns;

  R := Rect(P.x * AGENT_WIDTH, P.y * AGENT_HEIGHT, P.x * AGENT_WIDTH +
    AGENT_WIDTH, P.y * AGENT_HEIGHT + AGENT_HEIGHT);

  Canvas.CopyRect(Rect(0, 0, Width, Height), FAgent.Bitmap.Canvas, R);
end;


end.
