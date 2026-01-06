program CustomDeque;

type
    node_ptr = ^node;
    node = record
        data: longint;
        prev: node_ptr;
        next: node_ptr;
    end;

    Deque = record
        head: node_ptr;
        tail: node_ptr;
        size: longint;
    end;

procedure NodeInit(var new_node: node_ptr; num: longint; prev, next: node_ptr);
begin
    new(new_node);
    new_node^.data := num;
    new_node^.prev := prev;
    new_node^.next := next;
end;

procedure DequeInit(var deq: Deque);
begin
    deq.head := nil;
    deq.tail := nil;
    deq.size := 0;
end;

procedure DequeClear(var deq: Deque);
var
    cur, tmp: node_ptr;
begin
    cur := deq.head;

    while cur <> nil do
    begin
        tmp := cur^.next;
        dispose(cur);
        cur := tmp
    end;
    
    deq.head := nil;
    deq.tail := nil;
    deq.size := 0;
end;

procedure DequePushFront(var deq: Deque; num: longint);
var
    new_node: node_ptr;
begin
    NodeInit(new_node, num, nil, deq.head);

    if deq.size = 0 then
        deq.tail := new_node
    else
        deq.head^.prev := new_node;
    deq.head := new_node;

    deq.size := deq.size + 1
end;

procedure DequePushBack(var deq: Deque; num: longint);
var
    new_node: node_ptr;
begin
    NodeInit(new_node, num, deq.tail, nil);

    if deq.size = 0 then
        deq.head := new_node
    else
        deq.tail^.next := new_node;
    deq.tail := new_node;

    deq.size := deq.size + 1
end;

procedure DequePopFront(var deq: Deque; var num: longint);
var
    tmp: node_ptr;
begin
    if deq.size = 0 then
        exit;

    tmp := deq.head^.next;
    if tmp <> nil then
        tmp^.prev := nil;
    num := deq.head^.data;
    dispose(deq.head);
    deq.size := deq.size - 1;

    deq.head := tmp;
    if deq.size = 0 then
        deq.tail := tmp;
end;

procedure DequePopBack(var deq: Deque; var num: longint);
var
    tmp: node_ptr;
begin
    if deq.size = 0 then
        exit;

    tmp := deq.tail^.prev;
    if tmp <> nil then
        tmp^.next := nil;
    num := deq.tail^.data;
    dispose(deq.tail);
    deq.size := deq.size - 1;

    deq.tail := tmp;
    if deq.size = 0 then
        deq.head := tmp;
end;

function DequeIsEmpty(var deq: Deque): boolean;
begin
    DequeIsEmpty := deq.size = 0
end;

var
    deq: Deque;
    i: longint;
    num: longint;
begin
    DequeInit(deq);
    for i := 1 to 3 do
        DequePushBack(deq, i);

    for i := 0 to 4 do
    begin
        if not DequeIsEmpty(deq) then
        begin
            DequePopFront(deq, num);
            writeln(num)
        end
        else
            writeln('Deque empty');
    end;

    DequeClear(deq)
end.
