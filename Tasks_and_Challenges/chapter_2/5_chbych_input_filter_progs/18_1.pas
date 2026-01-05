program ReadNum;

function GetNum(var c: char): integer;
begin
    if ('0' <= c) and (c <= '9') then
        GetNum := ord(c) - ord('0')
    else if ('a' <= c) and (c <= 'z') then
        GetNum := ord(c) - ord('a') + 10
    else if ('A' <= c) and (c <= 'Z') then
        GetNum := ord(c) - ord('A') + 10
    else
        GetNum := -1
end;

procedure NumberToDec(var str: string; var basis: integer; var answer: longint);
var
    i, temp: integer;
begin
    answer := 0;
    if str[1] = '-' then
        i := 2
    else
        i := 1;

    while i < length(str) do
    begin
        temp := GetNum(str[i]);
        if (temp = -1) or (temp > (basis - 1)) then
        begin
            writeln('Wrong input!');
            halt(1)
        end;
        answer := answer * basis + temp;
        i := i + 1
    end;

    if str[1] = '-' then
        answer := -answer;
end;

var
    c: char;
    str: string;
    basis: integer;
    i: integer;
    
    answer: longint;
begin
    {$I-}
    
    str := '';
    i := 1;
    repeat
        read(c);
        str[i] := c;
        i := i + 1;
        if i >= 256 then
        begin
            writeln('Too long first parameter!');
            halt(1)
        end;
    until (c = ' ');
    SetLength(str, i-1);
    
    
    readln(basis);
    if IOResult <> 0 then
    begin
        writeln('Incorrect data');
        halt(1);
    end;

    NumberToDec(str, basis, answer);
    writeln(answer)
end.
