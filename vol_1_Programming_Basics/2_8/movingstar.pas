program MovingStar;
uses crt;
const
    KeyLeft   = -75;
    KeyRight  = -77;
    KeyUp     = -72;
    KeyDown   = -80;
    KeyEscape = 27;
    DelayDuration = 100;

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

type
    star = record
        CurX, CurY, dx, dy: integer;
    end;

procedure ShowStar(var s: star);
begin
    GotoXY(s.CurX, s.CurY);
    write('*');
    GotoXY(1, 1)
end;

procedure HideStar(var s: star);
begin
    GotoXY(s.CurX, s.CurY);
    write(' ');
    GotoXY(1, 1)
end;

procedure MoveStar(var s: star);
begin
    HideStar(s);

    s.CurX := s.CurX + s.dx;
    if s.CurX > ScreenWidth then
        s.CurX := 1
    else if s.CurX < 1 then
        s.CurX := ScreenWidth;

    s.CurY := s.CurY + s.dy;
    if s.CurY > ScreenHeight then
        s.CurY := 1
    else if s.CurY < 1 then
        s.CurY := ScreenHeight;

    ShowStar(s)
end;

procedure SetDirection(var s: star; dx, dy: integer);
begin
    s.dx := dx;
    s.dy := dy
end;

var
    s: star;
    c: integer;
begin
    clrscr;
    
    s.CurX := ScreenWidth div 2;
    s.CurY := ScreenHeight div 2;
    s.dx := 0;
    s.dy := 0;

    ShowStar(s);
    while true do
    begin
        if not KeyPressed then
        begin
            MoveStar(s);
            delay(DelayDuration);
            continue
        end;
        GetKey(c);
        case c of
            KeyLeft:   SetDirection(s, -1,  0);
            KeyRight:  SetDirection(s,  1,  0);
            KeyUp:     SetDirection(s,  0, -1);
            KeyDown:   SetDirection(s,  0,  1);
            ord(' '):  SetDirection(s,  0,  0);
            KeyEscape: break
        end
    end;
    clrscr
end.
