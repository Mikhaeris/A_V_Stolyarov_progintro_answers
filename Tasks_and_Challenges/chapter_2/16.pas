program CharCounter;
const
    CountChars = 128;
var
    characters: array[0..CountChars] of integer;
    str: string;
    str_len: integer;

    i: integer;
begin
    for i := 0 to CountChars do
        characters[i] := 0;

    readln(str);
    str_len := length(str);
    
    for i := 1 to str_len do
        characters[ord(str[i])] := characters[ord(str[i])] + 1;

    for i := 1 to str_len do
    begin
        if (characters[ord(str[i])] > 1) and (str[i] <> ' ')then
        begin
            write(str[i]);
            characters[ord(str[i])] := 0
        end
    end;
    writeln;
end.
