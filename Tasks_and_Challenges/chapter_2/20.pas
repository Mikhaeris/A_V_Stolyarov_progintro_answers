program BracketsWords;

function CheckSp(var c: char): boolean;
begin
    CheckSp := (c = ' ') or (c = #9) or (c = #10);
end;

var
    c, prev_c: char;
begin
    prev_c := ' ';
    while not eof do
    begin
        read(c);
        if CheckSp(prev_c) and not CheckSp(c) then
            write('(');
        if not CheckSp(prev_c) and CheckSp(c) then
            write(')');
        write(c);
        prev_c := c
    end
end.
