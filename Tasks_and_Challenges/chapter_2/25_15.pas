program ManyZStarArg;

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

procedure PrintLine(height, n, k: integer);
var
    h: integer;
begin
    h := (height - 1) div 2;
    n := n - ((k - 1) * h);
    
    if (n = 1) or (n = h + 1) or (n = height) then
        PrintChars('*', height)
    else if (n > 0) and (n < height) then
    begin
        PrintChars(' ', height - n); 
        write('*');
        PrintChars(' ', height - (height - n + 1))
    end
    else
        PrintChars(' ', height)
end;

var
    height, count: integer;
    n, k, h: integer;
begin
    if ParamCount <> 2 then
    begin
        writeln('Error: too few/many args, need one arg!');
        halt(1)
    end;

    StrToInt(height, ParamStr(1));
    if (height < 5) or (height mod 2 = 0) then
    begin
        writeln('Height of Z must be positive odd more then 5!');
        halt(1)
    end;
    
    StrToInt(count, ParamStr(2));
    if count <= 0 then
    begin
        writeln('Count of diamond''s must be positive!');
        halt(1)
    end;

    h := (height - 1) div 2;

    for n := 1 to height + (h * (count - 1)) do
    begin
        for k := 1 to count do
        begin
            PrintLine(height, n, k);
            write(' ')
        end;
        writeln;
    end
end.
