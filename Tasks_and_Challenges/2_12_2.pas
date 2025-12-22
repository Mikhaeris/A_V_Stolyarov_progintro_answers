program ReversFillDiamod;

procedure PrintChars(ch: char; count: integer);
var
    i: integer;
begin
    for i := 1 to count do
        write(ch)
end;

procedure PrintLineOfDiamond(k, n: integer);
var
    stars: integer;
begin
    stars := n + 2 - k;
    PrintChars('*', stars);
    PrintChars(' ', 2*k - 1);
    PrintChars('*', stars);
    writeln
end;

var
    n, k, h: integer;
begin
    repeat
        write('Enter the diamiond''s height (positive odd): ');
        readln(h)
    until (h > 0) and (h mod 2 = 1);

    n := h div 2;
    PrintChars('*', h + 2);
    writeln;
    for k := 1 to n + 1 do
        PrintLineOfDiamond(k, n);
    for k := n downto 1 do
        PrintLineOfDiamond(k, n);
    PrintChars('*', h + 2);
    writeln
end.
