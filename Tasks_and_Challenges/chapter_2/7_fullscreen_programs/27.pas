program Star_26;

uses crt;

const
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
    s.CurY := s.CurY + s.dy;
    ShowStar(s)
end;

procedure SetDirection(var s: star; dx, dy: integer);
begin
    s.dx := dx;
    s.dy := dy
end;

var
    s: star;
    dir: boolean;
begin
    clrscr;

    s.CurX := ScreenWidth div 2;
    s.CurY := ScreenHeight div 2;
    s.dx := 0;
    s.dy := 0;

    dir := true;
    
    ShowStar(s);
    while not KeyPressed do
    begin
        if dir and (s.CurX = ScreenWidth) and (s.CurY = ScreenHeight - 1) then
        begin
            HideStar(s);
            s.CurX := ScreenWidth;
            s.CurY := 1;
            ShowStar(s);
        end
        else if (not dir) and (s.CurX = 1) and (s.CurY = ScreenHeight - 1) then
        begin
            HideStar(s);
            s.CurX := 1;
            s.CurY := 1;
            ShowStar(s);
        end;

        if (s.CurX = 1) or (s.CurX = ScreenWidth) then
        begin
            SetDirection(s,  0,  1);
            MoveStar(s);
            dir := not dir
        end;

        if dir then
            SetDirection(s,  1,  0)
        else
            SetDirection(s, -1,  0);

        MoveStar(s);
        delay(DelayDuration);
    end;
    clrscr
end.
