program PrintAscii;
var
    i, j: integer;
begin
    write('|');
    for i := 1 to 12 do
        write('---');
    writeln;

    for i := 0 to 7 do
    begin
        write('|');
        for j := 4 to 15 do
            write('  ', chr(j*8 + i));
        writeln
    end
end.
