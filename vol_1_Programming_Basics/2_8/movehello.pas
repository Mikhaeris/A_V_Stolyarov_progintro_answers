program MovingHello;
uses crt;
const
    KeyLeft  = -75;
    KeyRight = -77;
    KeyUp    = -72;
    KeyDown  = -80;
    TheMessage = 'Hello, world!';

procedure GetKey(var code: integer);
var
    c: char;
begin
    c := ReadKey;
    if c = #0 then
    begin
        c := ReadKey;
        code := -ord(c)
    end
    else
    begin
        code := ord(c)
    end
end;

procedure ShowMessage(x, y: integer; msg: string);
begin
    GotoXY(x, y);
    write(msg);
    GotoXY(1, 1)
end;

procedure HideMessage(x, y: integer; msg: string);
var
    len, i: integer;
begin
    len := length(msg);
    GotoXY(x, y);
    for i := 1 to len do
        write(' ');
    GotoXY(1, 1)
end;

procedure MoveMessage(var x, y: integer; msg: string; dx, dy: integer);
var
    maxX: integer;
begin
    HideMessage(x, y, msg);

    maxX := ScreenWidth - Length(msg);

    x := x + dx;
    y := y + dy;

    if x < 1 then
        x := maxX
    else if x > maxX then
        x := 1;

    if y < 1 then
        y := ScreenHeight
    else if y > ScreenHeight then
        y := 1;

    ShowMessage(x, y, msg)
end;

var
    CurX, CurY: integer;
    c: integer;
begin
    clrscr;
    CurX := (ScreenWidth - length(TheMessage)) div 2;
    CurY := ScreenHeight div 2;
    ShowMessage(CurX, CurY, TheMessage);
    while true do
    begin
        GetKey(c);
        if c > 0 then
            break;
        case c of
            KeyLeft:
                MoveMessage(CurX, CurY, TheMessage, -1, 0);
            KeyRight:
                MoveMessage(CurX, CurY, TheMessage, 1, 0);
            KeyUp:
                MoveMessage(CurX, CurY, Themessage, 0, -1);
            KeyDown:
                MoveMessage(CurX, CurY, TheMessage, 0, 1);
        end
    end;
    clrscr
end.
