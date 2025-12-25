program WordLengthTwo;

function CheckSp(var c: char): boolean;
begin
    CheckSp := (c = ' ') or (c = #9) or (c = #10);
end;

var
    c, prev_c: char;
    word_len: integer;
    i, j: integer;
    str: array [0..1] of char;
begin
    prev_c := ' ';
    word_len := 0;
    j := 0;
    
    for i := 0 to 1 do
        str[i] := #0;

    while not eof do
    begin
        read(c);

        if not CheckSp(prev_c) and CheckSp(c) then
        begin
            if word_len = 2 then
            begin
                for i := 0 to 1 do
                    write(str[i]);
                write(' ')
            end;

            word_len := 0;
            j := 0
        end;

        if c = #10 then
            write(c);
        
        if CheckSp(c) then
            continue;

        word_len := word_len + 1;
        if (j mod 2) = 0 then
            str[0] := c
        else
            str[1] := c;
        j := j + 1;
        prev_c := c
    end
end.
