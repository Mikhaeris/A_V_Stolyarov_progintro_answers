program ManyZStar;

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
    repeat
        write('Enter height of Z (positive odd, more then 5): ');
        readln(height)
    until (height >= 5) and (height mod 2 = 1);
    
    repeat
        write('Enter count of Z (positive): ');
        readln(count)
    until (count > 0);

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
