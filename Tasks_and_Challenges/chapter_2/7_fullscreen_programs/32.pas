program StarSquare5;

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

    ColorCount = 16;

    Size = 5;
var
    ColorText: integer;
    ColorBackground: integer;
    AllColors: array [1..ColorCount] of word =
    (
        Black, Blue, Green, Cyan,
        Red, Magenta, Brown, LightGray,
        DarkGray, LightBlue, LightGreen, LightCyan,
        LightRed, LightMagenta, Yellow, White
    );

procedure PrintStarSquare(WidthOffset, HeightOffset: integer);
var
    i, j: integer;
begin
    for i := 0 to Size - 1 do
    begin
        GotoXY(WidthOffset, HeightOffset + i);
        for j := 1 to Size do
            write('*')
    end;
    GotoXY(1, 1)
end;

procedure SetColorBackground(d: integer);
begin
    ColorBackground := ColorBackground + d;
    TextBackground(AllColors[ColorBackground]);
    if ColorBackground = 0 then
        ColorBackground := 16
    else if ColorBackground = 17 then
        ColorBackground := 1
end;

procedure SetColorText(d: integer);
begin
    ColorText := Colortext + d;
    TextColor(AllColors[ColorText]);
    if ColorText = 0 then
        ColorText := 16
    else if ColorText = 17 then
        ColorText := 1
end;

var
    SaveTextAttr: integer;

    WidthOffset, HeightOffset: integer;
    c: integer;
begin
    if (ScreenWidth <= Size) or (ScreenHeight <= Size) then
    begin
        writeln('Error: width and height must be more than', Size, '!');
        halt(1)
    end;

    ColorText := 1;
    ColorBackground := 1;

    randomize;
    SaveTextAttr := TextAttr;
    clrscr;
    
    WidthOffset  := (ScreenWidth  - Size) div 2 + 1;
    HeightOffset := (ScreenHeight - Size) div 2 + 1;
    PrintStarSquare(WidthOffset, HeightOffset);

    while true do
    begin
        GetKey(c);
        case c of
            KeyLeft:  SetColorBackground(-1);
            KeyRight: SetColorBackground(1);
            KeyUp:    SetColorText(1);
            KeyDown:  SetColorText(-1);
            KeySpace:  break;
            KeyEscape: break;
        end;
        PrintStarSquare(WidthOffset, HeightOffset);
    end;
    TextAttr := SaveTextAttr;
    clrscr
end.
