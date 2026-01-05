program ManyDiamods;

procedure StrToInt(var h: integer; str: string);
var
    i: integer;
    sign: integer;
begin
    sign := 1;
    h := 0;
    for i := 1 to Length(str) do
    begin
        if (i = 1) and (str[1] = '-') then
        begin
            sign := -1;
            continue
        end;

        if not (('0' <= str[i]) and (str[i] <= '9')) then
        begin
            writeln('Error: bad arg!');
            halt(1)
        end;
        
        h := h * 10 + (ord(str[i]) - ord('0'));
    end;
    h := h * sign
end;

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
    if ParamCount <> 2 then
    begin
        writeln('Error: too few/many args, need one arg!');
        halt(1)
    end;

    StrToInt(height, ParamStr(1));
    if (height <= 0) or (height mod 2 = 0) then
    begin
        writeln('The diamond''s height nust be positive odd!');
        halt(1)
    end;

    StrToInt(count, ParamStr(2));
    if count <= 0 then
    begin
        writeln('Count of diamond''s must be positive!');
        halt(1)
    end;

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
