program Task47;
var
    f: text;
    ch: char;
begin
    {$I-}
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
        write(output, ch);
        if IOResult <> 0 then
        begin
            writeln(ErrOutput, 'Error while reading file');
            halt(1)
        end
    end

    close(f);
end.
