program Task55;
uses SysUtils;
type
    item = record
        name_: string[60];
        count_: integer;
    end;
    fileofitems = file of item;

procedure Add(var f: fileofitems; var name: string);
var
    cur_item: item;
begin
    while not eof(f) do
    begin
        read(f, cur_item);
        if name = cur_item.name_ then
        begin
            cur_item.count_ := cur_item.count_ + 1;
            seek(f, FilePos(f)-1);
            write(f, cur_item);
            exit
        end
    end;
    cur_item.name_  := name;
    cur_item.count_ := 1;
    write(f, cur_item)
end;

procedure Find(var f: fileofitems; var name: string);
var
    cur_item: item;
begin
    while not eof(f) do
    begin
        read(f, cur_item);
        if name = cur_item.name_ then
        begin
            writeln(cur_item.count_);
            exit
        end
    end;
    writeln(0)
end;

procedure PrintAll(var f: fileofitems);
var
    cur_item: item;
begin
    while not eof(f) do
    begin
        read(f, cur_item);
        writeln(cur_item.name_, ': ', cur_item.count_);
    end
end;

var
    f: fileofitems;
    command, name: string[60];
begin
    {$I-}
    if ParamCount < 2 then
    begin
        writeln(ErrOutput, 'Expected: filename command name');
        halt(1)
    end;

    assign(f, ParamStr(1));
    if FileExists(ParamStr(1)) then
        reset(f)
    else
        rewrite(f);
    if IOResult <> 0 then
    begin
        writeln(ErrOutput, 'Couldn''t open file: ', ParamStr(1));
        halt(1)
    end;
    
    command := ParamStr(2);
    if ((command = 'add') or (command = 'query')) and (ParamCount < 3) then
    begin
        writeln(ErrOutput, 'Expected: 3 parameters');
    end;
    name := ParamStr(3);
    if command = 'add' then
        Add(f, name)
    else if command = 'query' then
        Find(f, name)
    else if command = 'list' then
        PrintAll(f);

    close(f);
end.
