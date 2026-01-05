program Task48;
var
    f: text;
    ch: char;
    count_lines: longint;
begin
    {$I-}
    count_lines := 0;
    if ParamCount < 1 then
    begin
        writeln(ErrOutput, 'Expected: file name');
        halt(1)
    end;

    assign(f, ParamStr(1));
    reset(f);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(1));
        halt(1)
    end;

    while not eof(f) do
    begin
        read(f, ch);
        if IOResult <> 0 then
        begin
            writeln(ErrOutput, 'Error while reading file');
            halt(1)
        end;
        if ch = #10 then
            count_lines := count_lines + 1
    end;
    writeln('Count lines: ', count_lines);
    close(f)
end.
