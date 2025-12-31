program StarSquare;

uses crt;

const
    Left  = 2;
    Right = 0;
    Up    = 3;
    Down  = 1;
    DelayDuration = 100;
type
    hashtag = record
        CurX, CurY, dx, dy: integer;
    end;

procedure ShowHashtag(var h: hashtag);
begin
    GotoXY(h.CurX, h.CurY);
    write('#');
    GotoXY(1, 1)
end;

procedure HideHashtag(var h: hashtag);
begin
    GotoXY(h.CurX, h.CurY);
    write('*');
    GotoXY(1, 1)
end;

procedure MoveHashtag(var h: hashtag);
begin
    HideHashtag(h);
    h.CurX := h.CurX + h.dx;
    h.CurY := h.CurY + h.dy;
    ShowHashtag(h)
end;

procedure SetDirection(var h: hashtag; dx, dy: integer);
begin
    h.dx := dx;
    h.dy := dy
end;

procedure PrintStarSquare(WidthOffset, HeightOffset: integer);
var
    i, j: integer;
begin
    for i := 0 to 10 - 1 do
    begin
        GotoXY(WidthOffset, HeightOffset + i);
        for j := 1 to 10 do
            write('*')
    end;
    GotoXY(1, 1);
end;

var
    h: hashtag;

    WidthOffset, HeightOffset: integer;
    counter, dir: integer;
begin
    if (ScreenWidth < 12) or (ScreenHeight < 12) then
    begin
        writeln('Error: width and height must be more than 11!');
        halt(1)
    end;

    clrscr;
    
    WidthOffset := (ScreenWidth - 10) div 2 + 1;
    HeightOffset := (ScreenHeight - 10) div 2 + 1;
    PrintStarSquare(WidthOffset, HeightOffset);

    h.CurX := WidthOffset;
    h.CurY := HeightOffset;
    h.dx := 0;
    h.dy := 0;
    ShowHashtag(h);

    counter := 1;
    dir := 0;
    while not KeyPressed do
    begin
        if counter = 10 then
        begin
            dir := dir + 1;
            if dir = 4 then
                dir := 0;
            counter := 1
        end;

        case dir of
            Left:  SetDirection(h, -1, 0);
            Right: SetDirection(h, 1, 0);
            Up:    SetDirection(h, 0, -1);
            Down:  SetDirection(h, 0, 1);
        end;
        MoveHashtag(h);
        delay(DelayDuration);

        counter := counter + 1
    end;
    clrscr
end.
