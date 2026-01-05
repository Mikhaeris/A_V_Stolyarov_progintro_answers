program ProcessOneStrArg;

function CheckSp(var c: char): boolean;
begin
    CheckSp := (c = ' ') or (c = #9) or (c = #10);
end;

type
    int_t = integer;
var
    i: int_t;
    c, prev_c: char;
    count_words: int_t;
begin
    prev_c := ' ';
    count_words := 0;
    if ParamCount < 1 then
    begin
        writeln('Error: don''t get args or too many args, need one arg!');
        halt(1)
    end;

    for i := 1 to Length(ParamStr(1)) do
    begin
        c := ParamStr(1)[i];
        { word start }
        if CheckSp(prev_c) and not CheckSp(c) then
            count_words := count_words + 1;
        prev_c := c
    end;
    writeln('Letter have ', count_words, ' words')
end.
