program CustomLinkedList;

type
    nodeptr = ^node;
    node = record
        data: longint;
        next: nodeptr;
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

procedure LLPushFront(var list: LinkedList; num: longint);
var
    temp: nodeptr;
begin
    new(temp);
    temp^.data := num;
    temp^.next := list.head;

    if list.size = 0 then
        list.tail := temp;
    list.head := temp;

    list.size := list.size + 1
end;

procedure LLPushBack(var list: LinkedList; num: longint);
var
    temp: nodeptr;
begin
    new(temp);
    temp^.data := num;
    temp^.next := nil;

    if list.size = 0 then
        list.head := temp
    else
        list.tail^.next := temp;
    list.tail := temp;

    list.size := list.size + 1
end;

procedure LLInsert(var list: LinkedList; num, pos: longint; var res: boolean);
var
    pp: ^nodeptr;
    temp: nodeptr;
    i: longint;
begin
    if (pos < 0) or (pos > list.size) then
    begin
        res := false;
        exit
    end;

    pp := @list.head;
    for i := 1 to pos do
        pp := @(pp^^.next);

    new(temp);
    temp^.data := num;
    temp^.next := pp^;
    pp^ := temp;

    if temp^.next = nil then
        list.tail := temp;

    list.size := list.size + 1;
    res := true
end;

procedure LLErase(var list: LinkedList; pos: longint; var res: boolean);
var
    pp: ^nodeptr;
    temp, prev: nodeptr;
    i: longint;
begin
    if (pos < 0) or (pos >= list.size) then
    begin
        res := false;
        exit
    end;

    pp := @list.head;
    prev := nil;
    for i := 1 to pos do
    begin
        prev := pp^;
        pp := @(pp^^.next)
    end;

    temp := pp^;
    pp^ := temp^.next;
    dispose(temp);

    list.size := list.size - 1;

    if list.size = pos then
        list.tail := prev;

    res := true
end;

procedure LLGet(var list: LinkedList; pos: longint; var num: longint; var res: boolean);
var
    temp: nodeptr;
    i: longint;
begin
    if (pos < 0) or (pos >= list.size) then
    begin
        res := false;
        exit
    end;
    
    temp := list.head;
    for i := 1 to pos do
        temp := temp^.next;
    
    num := temp^.data;
    res := true
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
    list.size := 0
end;

procedure LLPrint(var list: LinkedList);
var
    temp: nodeptr;
    i: longint;
begin
    i := 1;
    temp := list.head;
    while temp <> nil do
    begin
        writeln('[', i, ']: ', temp^.data);
        temp := temp^.next;
        i := i + 1
    end
end;

var
    list: LinkedList;
    i: integer;
    res: boolean;
begin
    LLInit(list);
    for i := 1 to 3 do
        LLPushBack(list, i);

    LLPrint(list);
    LLInsert(list, 4, list.size, res);
    writeln;
    LLPrint(list);
    
    for i := 0 to 4 do
    begin
        LLErase(list, 0, res);
        writeln;
        LLPrint(list);
    end;


    LLClear(list)
end.
