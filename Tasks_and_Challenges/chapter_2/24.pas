program RealMult;

procedure GetReal(var x: real; str: string);
var
    i: integer;
    dot: boolean;
    pos: integer;
    num: integer;
    sign: integer;
begin
    x := 0.0;

    dot := false;
    pos := 10;
    sign := 1;
    for i := 1 to Length(str) do
    begin
        if (i = 1) and (str[1] = '-') then
        begin
            sign := -1;
            continue;
        end;

        if not (('0' <= str[i]) and (str[i] <= '9')) and (str[i] <> '.') then
        begin
            writeln('Error: bad arg, cannot parse!');
            halt(1)
        end;

        if str[i] = '.' then
        begin
            dot := true;
            continue
        end;
        
        num := ord(str[i]) - ord('0');
        if dot = false then
            x := (x * 10) + num
        else
        begin
            x := x + (num / pos);
            pos := pos * 10;
        end
    end;
    x := x * sign
end;

procedure GetInt(var n: integer; str: string);
var
    i: integer;
    sign: integer;
begin
    sign := 1;
    n := 0;
    for i := 1 to Length(str) do
    begin
        if (i = 1) and (str[1] = '-') then
        begin
            sign := -1;
            continue;
        end;

        if not (('0' <= str[i]) and (str[i] <= '9')) then
        begin
            writeln('Error: bad arg, cannot parse!');
            halt(1)
        end;
        n := n * 10 + (ord(str[i]) - ord('0'))
    end;
    n := n * sign
end;

procedure PrintFormatReal(z: real; var n: integer);
var
    i: integer;
    int_part: integer;
    num: integer;
begin
    int_part := trunc(z);
    z := z - int_part;

    write(int_part);
    if int_part < 0 then
        z := -z;
    if z = 0 then
    begin
        writeln;
        exit
    end;
    write('.');
    for i := 1 to n do
    begin
        z := z * 10;
        num := trunc(z);
        if num = 0 then
            break;
        write(num);
        z := z - num
    end;
    writeln
end;

var
    x, y, z: real;
    n: integer;
begin
    x := 0.0;
    y := 0.0;
    z := 0.0;
    n := 0;

    if ParamCount <> 3 then
    begin
        writeln('Error: too few args, need 3 args!');
        halt(1)
    end;
    
    GetReal(x, ParamStr(1));
    GetReal(y, ParamStr(2));
    GetInt(n, ParamStr(3));

    z := x * y;
    PrintFormatReal(z, n)
end.
