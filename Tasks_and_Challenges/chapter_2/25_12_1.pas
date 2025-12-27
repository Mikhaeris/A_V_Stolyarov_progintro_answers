program FillDiamodArg;

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

procedure PrintChars(ch: char; count: integer);
var
    i: integer;
begin
    for i := 1 to count do
        write(ch)
end;

procedure PrintLineOfDiamond(k, n: integer);
begin
    PrintChars(' ', n + 1 - k);
    PrintChars('*', 2*k - 1);
    writeln
end;

var
    n, k, h: integer;
begin
    if ParamCount <> 1 then
    begin
        writeln('Error: too few/many args, need one arg!');
        halt(1)
    end;

    StrToInt(h, ParamStr(1));
    if (h <= 0) or (h mod 2 = 0) then
    begin
        writeln('The diamond''s height must be positive odd!');
        halt(1)
    end;

    n := h div 2;
    for k := 1 to n + 1 do
        PrintLineOfDiamond(k, n);
    for k := n downto 1 do
        PrintLineOfDiamond(k, n);
end.
