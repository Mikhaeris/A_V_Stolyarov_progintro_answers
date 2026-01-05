program Task54;

procedure GetInf(var filename: string; var count_num, min_num, max_num: longint);
var
    f: file of integer;
    num: integer;
begin
    count_num := 0;
    min_num := high(longint);
    max_num := 0;

    assign(f, filename);
    reset(f);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', filename);
        halt(1)
    end;

    while not eof(f) do
    begin
        read(f, num);

        if num < min_num then
            min_num := num;
        if num > max_num then
            max_num := num;
        count_num := count_num + 1
    end;

    close(f);
end;

var
    f: text;
    i: longint;
    filename: string;

    count_num, min_num, max_num: longint;
begin
    {$I-}
    if ParamCount < 1 then
    begin
        writeln(ErrOutput, 'Expected: file name');
        halt(1)
    end;

    assign(f, ParamStr(ParamCount));
    rewrite(f);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(1));
        halt(1)
    end;

    for i := 1 to ParamCount - 1 do
    begin
        filename := ParamStr(i);
        GetInf(filename, count_num, min_num, max_num);
        writeln(f, filename, ': ', count_num, ' ', min_num, ' ', max_num);
    end;

    close(f);
end.
