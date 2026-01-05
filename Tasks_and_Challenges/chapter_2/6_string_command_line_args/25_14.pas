program ZStarArg;

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

procedure PrintLine(i, n: integer);
begin
    if (i = 0) or (i = (n - 1) div 2) or (i = n - 1) then
    begin
        PrintChars('*', n);
        writeln;
        exit
    end;

    PrintChars(' ', n - i - 1); 
    writeln('*')
end;

var
    height: integer;
    i: integer;
begin
    if ParamCount <> 1 then
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
    
    for i := 0 to height-1 do
        PrintLine(i, height);
end.
