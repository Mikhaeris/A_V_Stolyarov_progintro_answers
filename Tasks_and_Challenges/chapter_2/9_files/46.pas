program HumptyDumpty;

procedure WriteHumptyDumpty(var f: text);
begin
    writeln(f, 'Humpty Dumpty sat on a wall');
    writeln(f, 'Humpty Dumpty had a great fall');
    writeln(f, 'All the king''s horses and all the king''s men');
    writeln(f, 'Couldn''t put Humpty together again');
    writeln(f);
    writeln(f, 'Humpty Dumpty sat on the ground');
    writeln(f, 'Humpty Dumpty looked all around');
    writeln(f, 'Gone were the chimneys, gone were the rooves');
    writeln(f, 'All he could see were buckles and hooves');
    writeln(f);
    writeln(f, 'More of Dumpty');
    writeln(f, 'More of Dumpty');
    writeln(f, 'More of Dumpty');
    writeln(f, 'Dumpty');
    writeln(f);
    writeln(f, 'More of Dumpty');
    writeln(f, 'More of Dumpty');
    writeln(f, 'More of Dumpty');
    writeln(f, 'More of Dumpty, Dumpty');
    writeln(f);
    writeln(f, 'Humpty Dumpty counted to ten');
    writeln(f, 'Humpty Dumpty brought out a pen');
    writeln(f, 'All the King''s horses and all the King''s men');
    writeln(f, 'Were happy that Humpty''s together again.')
end;

var
    f: text;
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

    WriteHumptyDumpty(f);

    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t write to the file');
        halt(1)
    end;
    close(f)
end.
