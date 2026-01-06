program CustomDoubleLinkedList;

type
    node_ptr = ^node;
    node = record
        data: longint;
        prev: node_ptr;
        next: node_ptr;
    end;

    DoubleLinkedList = record
        head: node_ptr;
        tail: node_ptr;
        size: longint;
    end;

    DLL = DoubleLinkedList;

procedure NodeInit(var new_node: node_ptr; num: longint; prev, next: node_ptr);
begin
    new(new_node);
    new_node^.data := num;
    new_node^.prev := prev;
    new_node^.next := next;
end;

procedure DLLInit(var list: DLL);
begin
    list.head := nil;
    list.tail := nil;
    list.size := 0;
end;

procedure DLLClear(var list: DLL);
var
    cur, tmp: node_ptr;
begin
    cur := list.head;

    while cur <> nil do
    begin
        tmp := cur^.next;
        dispose(cur);
        cur := tmp
    end;
    
    list.head := nil;
    list.tail := nil;
    list.size := 0;
end;

procedure DLLPushFront(var list: DLL; num: longint);
var
    new_node: node_ptr;
begin
    NodeInit(new_node, num, nil, list.head);

    if list.size = 0 then
        list.tail := new_node
    else
        list.head^.prev := new_node;
    list.head := new_node;

    list.size := list.size + 1
end;

procedure DLLPushBack(var list: DLL; num: longint);
var
    new_node: node_ptr;
begin
    NodeInit(new_node, num, list.tail, nil);

    if list.size = 0 then
        list.head := new_node
    else
        list.tail^.next := new_node;
    list.tail := new_node;

    list.size := list.size + 1
end;

procedure DLLInsert(var list: DLL; num, pos: longint; var res: boolean);
label
    good;
var
    new_node, cur: node_ptr;
    i: longint;
begin
    if (pos < 0) or (pos > list.size) then
    begin
        res := false;
        exit
    end;

    if pos = 0 then
    begin
        DLLPushFront(list, num);
        goto good
    end
    else if pos = list.size then
    begin
        DLLPushBack(list, num);
        goto good;
    end;

    cur := list.head;
    for i := 1 to pos - 1 do
        cur := cur^.next;

    NodeInit(new_node, num, cur, cur^.next);
    cur^.next^.prev := new_node;
    cur^.next := new_node;

    list.size := list.size + 1;
good:
    res := true
end;

procedure DLLPopFront(var list: DLL);
var
    tmp: node_ptr;
begin
    if list.size = 0 then
        exit;

    tmp := list.head^.next;
    if tmp <> nil then
        tmp^.prev := nil;
    dispose(list.head);
    list.size := list.size - 1;

    list.head := tmp;
    if list.size = 0 then
        list.tail := tmp;
end;

procedure DLLPopBack(var list: DLL);
var
    tmp: node_ptr;
begin
    if list.size = 0 then
        exit;

    tmp := list.tail^.prev;
    if tmp <> nil then
        tmp^.next := nil;
    dispose(list.tail);
    list.size := list.size - 1;

    list.tail := tmp;
    if list.size = 0 then
        list.head := tmp;
end;

procedure DLLErase(var list: DLL; pos: longint);
var
    cur: node_ptr;
    i: longint;
begin
    if (pos < 0) or (pos >= list.size) then
        exit;

    if pos = 0 then
    begin
        DLLPopFront(list);
        exit
    end
    else if pos = list.size - 1 then
    begin
        DLLPopBack(list);
        exit
    end;

    cur := list.head;
    for i := 1 to pos do
        cur := cur^.next;

    cur^.prev^.next := cur^.next;
    cur^.next^.prev := cur^.prev;
    dispose(cur);

    list.size := list.size - 1
    {
        if cur^.prev = nil then
            list.head := cur^.next
        else
            cur^.prev^.next := cur^.next;
        if cur^.next = nil then
            list.tail := cur^.prev
        else
            cur^.next^.prev = cur^.prev;
        dispose(cur);
    }
end;

procedure DLLGet(var list: DLL; pos: longint; var num: longint);
var
    cur: node_ptr;
    i: longint;
begin
    if (pos < 0) or (pos >= list.size) then
        exit;

    if pos = 0 then
    begin
        num := list.head^.data;
        exit
    end
    else if pos = list.size - 1 then
    begin
        num := list.tail^.data;
        exit
    end;

    cur := list.head;
    for i := 1 to pos do
        cur := cur^.next;
    
    num := cur^.data;
end;

procedure DLLPrint(var list: DLL);
var
    tmp: node_ptr;
    i: longint;
begin
    i := 1;
    tmp := list.head;
    while tmp <> nil do
    begin
        writeln('[', i, ']: ', tmp^.data);
        tmp := tmp^.next;
        i := i + 1
    end
end;

var
    list: DLL;
    i: integer;
    res: boolean;
begin
    DLLInit(list);
    for i := 1 to 3 do
        DLLPushBack(list, i);

    DLLPrint(list);
    DLLInsert(list, 4, list.size, res);
    writeln;
    DLLPrint(list);
    
    for i := 0 to 4 do
    begin
        DLLErase(list, 0);
        writeln;
        DLLPrint(list);
    end;


    DLLClear(list)
end.
