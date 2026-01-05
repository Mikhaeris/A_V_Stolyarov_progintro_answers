program RandStar;

uses crt;

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

const
    { Keys }
    KeyLeft   = -75;
    KeyRight  = -77;
    KeyUp     = -72;
    KeyDown   = -80;
    KeySpace  = 32;
    KeyEscape = 27;

    { dir }
    Left  = 2;
    Right = 0;
    Up    = 3;
    Down  = 1;

    DelayDuration = 100;
    Probability = 10;
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

procedure RandDir(var dir: integer);
var
    s: integer;
begin
    if random(Probability) = 0 then
    begin
        s := random(2);
        if s = 0 then
            dir := dir - 1
        else 
            dir := dir + 1;
    end;

    dir := (dir + 4) mod 4;
end;

procedure SetDir(var s: star; dir: integer);
begin
    case dir of
        Left:   SetDirection(s, -1,  0);
        Right:  SetDirection(s,  1,  0);
        Up:     SetDirection(s,  0, -1);
        Down:   SetDirection(s,  0,  1);
    end;
end;

procedure StopGame();
begin
    clrscr;
    halt(0)
end;

procedure KeyController(var c: integer; var s: star; var dir: integer);
begin
    case c of
        KeyLeft:
            begin
                SetDirection(s, -1,  0);
                dir := Left
            end;
        KeyRight:
            begin
                SetDirection(s,  1,  0);
                dir := Right
            end;
        KeyUp:
            begin
                SetDirection(s,  0, -1);
                dir := Up
            end;
        KeyDown:
            begin
                SetDirection(s,  0,  1);
                dir := Down
            end;
        KeySpace:  StopGame;
        KeyEscape: StopGame;
    end
end;

var
    s: star;
    c: integer;
    dir: integer;
begin
    clrscr;
    randomize;

    s.CurX := ScreenWidth div 2;
    s.CurY := ScreenHeight div 2;
    s.dx := 0;
    s.dy := 0;
    
    dir := random(4);
    SetDir(s, dir);
    ShowStar(s);

    while true do
    begin
        if KeyPressed then
        begin
            GetKey(c);
            KeyController(c, s, dir);
        end
        else
        begin
            RandDir(dir);
            SetDir(s, dir)
        end;

        MoveStar(s);
        delay(DelayDuration)
    end
end.
