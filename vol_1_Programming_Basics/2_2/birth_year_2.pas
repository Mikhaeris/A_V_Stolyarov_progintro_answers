program BirthYear_2;
var
    year: integer;
begin
    repeat
        write('Please type in your birth year: ');
        readln(year);
    until (year >= 1900) and (year <= 2023);
    writeln('The year ', year, ' is accepted. Thank you!')
end.
