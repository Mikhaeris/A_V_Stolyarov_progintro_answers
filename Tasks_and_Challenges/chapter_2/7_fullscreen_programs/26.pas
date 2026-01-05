program Star_26;

uses crt;

const
    DelayDuration = 100;

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
    count: integer;
begin
    clrscr;

    s.CurX := ScreenWidth div 2;
    s.CurY := ScreenHeight div 2;
    s.dx := 0;
    s.dy := 0;

    dir := true;
    count := 0;
    
    ShowStar(s);
    while true do
    begin
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

        count := count + 1;
        if count = (3 * ScreenWidth) then
            break
    end;
    clrscr
end.
