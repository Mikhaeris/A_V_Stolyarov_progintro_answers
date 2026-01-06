program LinkedList2;
type
    itemptr = ^item;
    item = record
        data: integer;
        next: itemptr;
    end;

procedure PushBack(var tail: itemptr; num: integer);
var
    temp: itemptr;
begin
    new(temp);
    temp^.data := num;
    temp^.next := nil;
    
    if tail <> nil then
        tail^.next := temp;
    tail := temp
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
    head, tail: itemptr;

    num: integer;
begin
    head := nil;
    tail := nil;

    while not SeekEof do
    begin
        read(num);
        PushBack(tail, num);
        if head = nil then
            head := tail
    end;

    writeln('First print:');
    PrintLinkedList(head);

    writeln('Second print:');
    PrintLinkedList(head);

    ClearLinkedList(head)
end.
