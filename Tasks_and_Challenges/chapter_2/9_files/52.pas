program Task52;

procedure FindLongestLine(var filename: string;
                          var longest_line, num_longest_line: longint);
var
    f: text;
    length_line, num_line: longint;
    ch: char;
begin
    longest_line := 0;
    num_longest_line := 0;

    length_line := 0;
    num_line := 0;

    assign(f, filename);
    reset(f);

    while not eof(f) do
    begin
        read(f, ch);
        if ch = #10 then
        begin
            if length_line > longest_line then
            begin
                longest_line := length_line;
                num_longest_line := num_line;
            end;
            num_line := num_line + 1;
            length_line := 0;
            continue
        end;
        length_line := length_line + 1
    end;

    { last line }
    num_line := num_line + 1;
    if length_line > longest_line then
    begin
        longest_line := length_line;
        num_longest_line := num_line;
    end;
    length_line := 0;

    close(f);
end;

procedure PrintLine(var filename: string; num_line: longint);
var
    f: text;
    num_line_cur: longint;
    ch: char;
begin
    num_line_cur := 0;
    
    assign(f, filename);
    reset(f);

    while not eof(f) do
    begin
        read(f, ch);
        if num_line_cur = num_line then
        begin
            write(ch);
            if ch = #10 then
                break;
        end;
        if ch = #10 then
            num_line_cur := num_line_cur + 1;
    end;
    close(f)
end;

var
    longest_line_all: longint;
    longest_line_cur, num_longest_line: longint;
    i: longint;
    temp_filename: string;
begin
    {$I-}
    longest_line_all := 0;
    for i := 1 to ParamCount do
    begin
        temp_filename := ParamStr(i);
        FindLongestLine(temp_filename, longest_line_cur, num_longest_line);
        if longest_line_all < longest_line_cur then
            longest_line_all := longest_line_cur;
    end;

    for i := 1 to ParamCount do
    begin
        temp_filename := ParamStr(i);
        FindLongestLine(temp_filename, longest_line_cur, num_longest_line);
        if longest_line_cur = longest_line_all then
            write('*');
        write(temp_filename, ': ');
        PrintLine(temp_filename, num_longest_line)
    end
end.
