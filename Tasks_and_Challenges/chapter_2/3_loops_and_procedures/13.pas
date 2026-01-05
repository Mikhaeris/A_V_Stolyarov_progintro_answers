program ManyDiamods;

procedure PrintSpaces(count: integer);
var
    i: integer;
begin
    for i := 1 to count do
        write(' ')
end;

procedure PrintLineOfDiamond(k, n: integer);
begin
    PrintSpaces(n + 1 - k);
    write('*');
    if k > 1 then
    begin
        PrintSpaces(2*k - 3);
        write('*')
    end;
    PrintSpaces(n + 1 - k);
end;

var
    height, count: integer;
    i, j: integer;
    n: integer;
begin
    repeat
        write('Enter the diamond''s height (positive odd): ');
        readln(height)
    until (height > 0) and (height mod 2 = 1);

    repeat
        write('Enter count of diamond''s (positive): ');
        readln(count)
    until (count > 0);

    n := height div 2;
    for i := 1 to n + 1 do
    begin
        for j := 1 to count do
        begin
            PrintLineOfDiamond(i, n);
        end;
        writeln
    end;

    for i := n downto 1 do
    begin
        for j := 1 to count do
        begin
            PrintLineOfDiamond(i, n)
        end;
        writeln
    end
end.
