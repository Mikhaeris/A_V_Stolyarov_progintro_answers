program Task56;
type
    item = record
        name_: string[60];
        count_: integer;
    end;
    fileofitems = file of item;

procedure Find(var f: fileofitems; var name: string; var count: integer);
var
    cur_item: item;
begin
    seek(f, 0);
    while not eof(f) do
    begin
        read(f, cur_item);
        if name = cur_item.name_ then
        begin
            count := cur_item.count_;
            seek(f, 0);
            exit
        end
    end;
    count := 0;
    seek(f, 0)
end;

var
    f1, f2, fout: fileofitems;
    count: integer;
    temp_item: item;
begin
    {$I-}
    if ParamCount < 3 then
    begin
        writeln(ErrOutput, 'Expected: 3 file names');
        halt(1)
    end;
    
    assign(f1, ParamStr(1));
    reset(f1);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(1));
        halt(1)
    end;

    assign(f2, ParamStr(2));
    reset(f2);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(2));
        halt(1)
    end;

    assign(fout, ParamStr(3));
    rewrite(fout);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(3));
        halt(1)
    end;

    while not eof(f1) do
    begin
        read(f1, temp_item);
        Find(f2, temp_item.name_, count);
        temp_item.count_ := temp_item.count_ + count;
        write(fout, temp_item)
    end;

    while not eof(f2) do
    begin
        read(f2, temp_item);
        Find(fout, temp_item.name_, count);
        if count = 0 then
        begin
            seek(fout, filesize(fout));
            write(fout, temp_item)
        end
    end;

    close(f1);
    close(f2);
    close(fout)
end.
