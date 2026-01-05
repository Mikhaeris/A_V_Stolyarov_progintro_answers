program Task40;

type
    nodeptr = ^node;
    node = record
        data:  longint;
        count: longint;
        next:  nodeptr;
    end;
    LinkedList = record
        head: nodeptr;
        tail: nodeptr;
        size: longint;
    end;

procedure LLInit(var list: LinkedList);
begin
    list.head := nil;
    list.tail := nil;
    list.size := 0
end;

procedure LLClear(var list: LinkedList);
var
    temp, thead: nodeptr;
begin
    thead := list.head;
    while thead <> nil do
    begin
        temp := thead^.next;
        dispose(thead);
        thead := temp
    end;
    list.head := nil;
    list.tail := nil;
end;

function LLIsEmpty(var list: LinkedList): boolean;
begin
    LLIsEmpty := list.size = 0
end;

procedure LLFindInc(var list: LinkedList; num: longint; var res: boolean);
var
    temp: nodeptr;
begin
    temp := list.head;
    while temp <> nil do
    begin
        if temp^.data = num then
        begin
            temp^.count := temp^.count + 1;
            res := true;
            exit
        end;
        temp := temp^.next;
    end;
    res := false
end;

procedure LLPushBack(var list: LinkedList; num: longint);
var
    temp: nodeptr;
begin
    new(temp);
    temp^.data  := num;
    temp^.count := 1;
    temp^.next  := nil;

    if LLIsEmpty(list) then
        list.head := temp
    else
        list.tail^.next := temp;
    list.tail := temp;

    list.size := list.size + 1
end;

var
    list: LinkedList;
    num: longint;

    res: boolean;

    temp: nodeptr;
begin
    LLInit(list);

    while not SeekEof do
    begin
        read(num);
        LLFindInc(list, num, res);
        if not res then
            LLPushBack(list, num);
    end;

    writeln(#10'Answer:');
    temp := list.head;
    while temp <> nil do
    begin
        if temp^.count = 3 then
            write(temp^.data, ' ');
        temp := temp^.next;
    end;
    writeln;

    LLClear(list)
end.
