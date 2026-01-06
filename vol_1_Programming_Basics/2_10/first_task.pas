program LinkedList1;
type
    itemptr = ^item;
    item = record
        data: integer;
        next: itemptr;
    end;

procedure PushFront(var head: itemptr; var num: integer);
var
    temp: itemptr;
begin
    new(temp);
    temp^.data := num;
    temp^.next := head;

    head := temp
end;

procedure ClearLinkedList(head: itemptr);
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

procedure PrintLinkedList(head: itemptr);
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
    num: integer;
    head: itemptr;
begin
    head := nil;
    while not SeekEof do
    begin
        read(num);
        PushFront(head, num);
    end;

    PrintLinkedList(head);

    ClearLinkedList(head)
end.
