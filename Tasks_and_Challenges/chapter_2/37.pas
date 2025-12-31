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
    Size = 3;
type
    star = record
        CurX, CurY, dx, dy: integer;
    end;
var
    LoseLetter: string = 'You Lose!';
    WinLetter:  string = 'You Win!';

    allCountMoves:  integer = 1000;
    allCountImpact: integer = 50;

procedure PrintAtSquare(WidthOffset, HeightOffset: integer);
var
    i, j: integer;
begin
    for i := 0 to Size - 1 do
    begin
        GotoXY(WidthOffset, HeightOffset + i);
        for j := 1 to Size do
            write('@');
    end;
    GotoXY(1, 1);
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
    else if s.CurY <= 1 then
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

procedure PauseGame();
var
    c: integer;
begin
    while true do
    begin
        GetKey(c);
        case c of
            KeySpace: break;
            KeyEscape: StopGame;
        end
    end
end;

procedure KeyController(var c, wdir: integer);
begin
    case c of
        KeyLeft:   wdir := Left;
        KeyRight:  wdir := Right;
        KeyUp:     wdir := Up;
        KeyDown:   wdir := Down;
        KeySpace:  PauseGame;
        KeyEscape: StopGame;
    end
end;

procedure EndGame(var str: string);
begin
    clrscr;
    GotoXY((ScreenWidth - length(str)) div 2 + 1, ScreenHeight div 2 + 1);
    write(str);
    GotoXY(1, 1);
    while not KeyPressed do;
    StopGame;
end;

procedure PrintInf();
begin
    GotoXY(ScreenWidth - 31, 1);
    write('Star Moves: ', allCountMoves:4);
    write(' Your Moves: ', allCountImpact:3);
    GotoXY(1, 1)
end;

var
    s: star;
    c: integer;

    WidthOffset, HeightOffset: integer;
    dir, wdir: integer;
    countMoves: integer;
begin
    if (ScreenWidth <= Size) or (ScreenHeight <= Size) then
    begin
        writeln('Error: width and height must be more than', Size, '!');
        halt(1)
    end;

    clrscr;
    randomize;

    PrintInf;

    WidthOffset  := (ScreenWidth  - Size) div 2 + 1;
    HeightOffset := (ScreenHeight - Size) div 2 + 2;
    PrintAtSquare(WidthOffset, HeightOffset);

    s.CurX := 1;
    s.CurY := 2;
    s.dx := 0;
    s.dy := 0;

    countMoves := 0;
    
    wdir := -1;
    SetDir(s, Right);
    ShowStar(s);

    while true do
    begin
        if KeyPressed then
        begin
            GetKey(c);
            KeyController(c, wdir);
        end;
        
        if (countMoves >= 10) and (wdir >= 0) then
        begin
            SetDir(s, wdir);
            dir := wdir;
            wdir := -1;
            countMoves := 0;
            
            allCountImpact := allCountImpact - 1;
        end
        else
        begin
            RandDir(dir);
            SetDir(s, dir)
        end;

        MoveStar(s);
        if (WidthOffset  <= s.CurX) and (s.CurX < WidthOffset  + Size) and
           (HeightOffset <= s.CurY) and (s.CurY < HeightOffset + Size) then
            EndGame(WinLetter);

        countMoves := countMoves + 1;
        allCountMoves := allCountMoves - 1;
            
        PrintInf;
        if (allCountMoves <= 0) or (allCountImpact <= 0) then
            EndGame(LoseLetter);

        delay(DelayDuration)
    end
end.
