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

procedure NumberToDec(var basis: integer; var answer: longint);
var
    c: char;
    temp: integer;
    sign: boolean;
begin
    answer := 0;
    repeat
        read(c);
    until c <> ' ';

    sign := (c = '-');
    if sign then
        read(c);

    repeat
        temp := GetNum(c);
        if (temp = -1) or (temp > (basis - 1)) then
        begin
            writeln('Wrong input!');
            halt(1)
        end;
        answer := answer * basis + temp;
        read(c)
    until eof;

    if sign then
        answer := -answer;
end;

var
    c: char;
    basis: integer;
    answer: longint;
begin
    {$I-}
    
    read(basis);
    if IOResult <> 0 then
    begin
        writeln('Incorrect data');
        halt(1);
    end;

    NumberToDec(basis, answer);
    writeln(answer)
end.
