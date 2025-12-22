program ZStar;

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
    repeat
        write('Enter height of Z (positive odd, more then 5): ');
        readln(height)
    until (height >= 5) and (height mod 2 = 1);
    
    for i := 0 to height-1 do
        PrintLine(i, height);
end.
