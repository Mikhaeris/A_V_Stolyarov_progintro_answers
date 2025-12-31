program StarSquare3;

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

    StartSize = 3;
type
    rectangle = record
        CurW, CurH: integer;
    end;

procedure PrintStarSquare(WidthOffset, HeightOffset: integer);
var
    i, j: integer;
begin
    for i := 0 to StartSize - 1 do
    begin
        GotoXY(WidthOffset, HeightOffset + i);
        for j := 1 to StartSize do
            write('*')
    end;
    GotoXY(1, 1);
end;

procedure PrintSubStrChars(x, y, count: integer; ch: char);
var
    i: integer;
begin
    GotoXY(x, y);
    for i := 1 to count do
        write(ch);
    GotoXY(1, 1)
end;

procedure ScaleHeight(var r: rectangle; d: integer);
var
    WidthOffset, HeightOffset: integer;
begin
    if (r.CurH = 1) and (d = -1) then
        exit;

    WidthOffset  := (ScreenWidth  - r.CurW) div 2 + 1;
    HeightOffset := (ScreenHeight - r.CurH) div 2 + 1;
    
    if d = 1 then
    begin
        PrintSubStrChars(WidthOffset, HeightOffset - 1, r.CurW, '*');
        PrintSubStrChars(WidthOffset, HeightOffset + r.CurH, r.CurW, '*')
    end
    else
    begin
        PrintSubStrChars(WidthOffset, HeightOffset, r.CurW, ' ');
        PrintSubStrChars(WidthOffset, HeightOffset + r.CurH - 1, r.CurW, ' ')
    end;

    r.CurH := r.CurH + (2 * d);
end;

procedure PrintSubColChars(x, y, count: integer; ch: char);
var
    i: integer;
begin
    for i := 0 to count - 1 do
    begin
        GotoXY(x, y + i);
        write(ch)
    end;
    GotoXY(1, 1)
end;

procedure ScaleWidth(var r: rectangle; d: integer);
var
    WidthOffset, HeightOffset: integer;
begin
    if (r.CurW = 1) and (d = -1) then
        exit;

    WidthOffset  := (ScreenWidth  - r.CurW) div 2 + 1;
    HeightOffset := (ScreenHeight - r.CurH) div 2 + 1;
    
    if d = 1 then
    begin
        PrintSubColChars(WidthOffset - 1, HeightOffset, r.CurH, '*');
        PrintSubColChars(WidthOffset + r.CurW, HeightOffset, r.CurH, '*')
    end
    else
    begin
        PrintSubColChars(WidthOffset, HeightOffset, r.CurH, ' ');
        PrintSubColChars(WidthOffset + r.CurW - 1, HeightOffset, r.CurH, ' ')
    end;

    r.CurW := r.CurW + (2 * d);
end;
var
    r: rectangle;
    WidthOffset, HeightOffset: integer;
    c: integer;
begin
    if (ScreenWidth <= StartSize) or (ScreenHeight <= StartSize) then
    begin
        writeln('Error: width and height must be more than ', StartSize, '!');
        halt(1)
    end;
    
    clrscr;
    
    WidthOffset  := (ScreenWidth  - StartSize) div 2 + 1;
    HeightOffset := (ScreenHeight - StartSize) div 2 + 1;
    PrintStarSquare(WidthOffset, HeightOffset);

    r.CurW := StartSize;
    r.CurH := StartSize;

    while true do
    begin
        if not KeyPressed then
            continue;
        
        GetKey(c);
        case c of
            KeyLeft:   ScaleWidth(r, -1);
            KeyRight:  ScaleWidth(r, 1);
            KeyUp:     ScaleHeight(r, 1);
            KeyDown:   ScaleHeight(r, -1);
            KeySpace:  break;
            KeyEscape: break;
        end
    end;
    clrscr
end.
