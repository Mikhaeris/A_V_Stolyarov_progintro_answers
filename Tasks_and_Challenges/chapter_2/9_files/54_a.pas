program Task54A;
var
    f: file of integer;
    num: integer;
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

    while not SeekEof do
    begin
        read(num);
        write(f, num);
    end;

    close(f);
end.
