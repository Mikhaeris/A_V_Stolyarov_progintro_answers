program Task53;
var
    ffrom, fto: text;
    flength: file of integer;
    ch, prev_ch: char;
    length_line: integer;
    flag: boolean;
begin
    {$I-}
    if ParamCount < 3 then
    begin
        writeln(ErrOutput, 'Expected: 3 file names');
        halt(1)
    end;

    assign(ffrom, ParamStr(1));
    reset(ffrom);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(1));
        halt(1)
    end;

    assign(fto, ParamStr(2));
    rewrite(fto);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(2));
        halt(1)
    end;

    assign(flength, ParamStr(3));
    rewrite(flength);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(3));
        halt(1)
    end;

    prev_ch := #10;
    length_line := 0;
    flag := false;
    while not eof(ffrom) do
    begin
        read(ffrom, ch);
        if prev_ch = #10 then
        begin
            if ch = ' ' then
                flag := true
            else
                flag := false;
        end;

        if ch = #10 then
        begin
            write(flength, length_line);
            length_line := 0
        end;

        if flag then
            write(fto, ch);

        length_line := length_line + 1;
        prev_ch := ch
    end;

    if length_line > 0 then
        write(flength, length_line);
        

    close(ffrom);
    close(fto);
    close(flength);
end.
