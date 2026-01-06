program ReverLinkedList;
type
    itemptr = ^item;
    item = record
        data: integer;
        next: itemptr;
    end;

procedure PushFront(var head: itemptr; num: integer);
var
    temp: itemptr;
begin
    new(temp);
    temp^.data := num;
    temp^.next := head;

    head := temp
end;

procedure RevertLL(var head: itemptr);
var
    newhead: itemptr;
    temp: itemptr;
begin
    newhead := nil;
    while head <> nil do
    begin
        temp := head;
        head := head^.next;
        temp^.next := newhead;
        newhead := temp
    end;
    head := newhead
end;

procedure ClearLL(head: itemptr);
var
    temp: itemptr;
begin
    while head <> nil do
    begin
        temp := head^.next;
        dispose(head);
        head := temp
    end
end;

procedure PrintLL(head: itemptr);
var
    i: integer;
begin
    i := 1;
    while head <> nil do
    begin
        writeln('[', i, ']: ', head^.data);
        head := head^.next;
        i := i + 1
    end
end;

var
    head: itemptr;
    num: integer;
begin
    while not SeekEof do
    begin
        read(num);
        PushFront(head, num);
    end;

    RevertLL(head);

    PrintLL(head);

    ClearLL(head)
end.
