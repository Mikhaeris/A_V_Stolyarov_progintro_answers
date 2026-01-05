program Task49;
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
    rewrite(f);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(1));
        halt(1)
    end;

    while not eof(input) do
    begin
        read(ch);
        write(f, ch);
        if IOResult <> 0 then
        begin
            writeln(ErrOutput, 'Error while write to file');
            halt(1)
        end
    end;

    close(f)
end.
