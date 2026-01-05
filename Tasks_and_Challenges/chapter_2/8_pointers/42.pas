program Task42;

{ symbol }
type
    snodeptr = ^snode;
    snode = record
        ch: char;
        next: snodeptr;
    end;
    SLinkedList = record
        head: snodeptr;
        tail: snodeptr;
    end;
    sllptr = ^SLinkedList;

procedure SLInit(var sll: sllptr);
begin
    new(sll);
    sll^.head := nil;
    sll^.tail := nil;
end;

procedure SLClear(var sll: sllptr);
var
    temp, curr: snodeptr;
begin
    if sll = nil then
        exit;
    curr := sll^.head;
    while curr <> nil do
    begin
        temp := curr^.next;
        dispose(curr);
        curr := temp
    end;
    dispose(sll);
    sll := nil
end;

function SLIsEmpty(var slist: SLinkedList): boolean;
begin
    SLIsEmpty := (slist.head = nil) and (slist.tail = nil)
end;

procedure SLPushBack(var slist: SLinkedList; ch: char);
var
    temp: snodeptr;
begin
    new(temp);
    temp^.ch   := ch;
    temp^.next := nil;
    
    if SLIsEmpty(slist) then
        slist.head := temp
    else
        slist.tail^.next := temp;
    slist.tail := temp
end;

procedure SLPrint(var slist: SLinkedList);
var
    temp: snodeptr;
begin
    temp := slist.head;
    while temp <> nil do
    begin
        write(temp^.ch);
        temp := temp^.next
    end
end;

{ word }
type
    wnodeptr = ^wnode;
    wnode = record
        data: sllptr;
        next: wnodeptr;
    end;

procedure WNClear(var head: wnodeptr);
var
    temp: wnodeptr;
begin
    while head <> nil do
    begin
        if head^.data <> nil then
            SLClear(head^.data);
        temp := head^.next;
        dispose(head);
        head := temp
    end
end;

procedure WNPushFront(var head: wnodeptr);
var
    temp: wnodeptr;
begin
    new(temp);
    temp^.data := nil;
    temp^.next := head;
    head := temp
end;

procedure WNUpdateData(var head: wnodeptr; ch: char);
begin
    if head = nil then
        exit;

    if head^.data = nil then
        SLInit(head^.data);
    
    SLPushBack(head^.data^, ch)
end;

procedure WNPrint(head: wnodeptr);
begin
    while head <> nil do
    begin
        SLPrint(head^.data^);
        if head^.next <> nil then
            write(' ');
        head := head^.next
    end;
    writeln
end;

function IsSpace(var ch: char): boolean;
begin
    IsSpace := (ch = ' ') or (ch = #9)
end;

var
    ch, prev_ch: char;
    head: wnodeptr;
begin
    prev_ch := ' ';
    head := nil;

    while not eof do
    begin
        read(ch);

        if not IsSpace(ch) and IsSpace(prev_ch) then
            WNPushFront(head);

        if ch = #10 then
        begin
            WNPrint(head);
            WNClear(head);
            prev_ch := ' ';
            continue;
        end;

        prev_ch := ch;
        if IsSpace(ch) then
            continue;

        WNUpdateData(head, ch)
    end;

    if head <> nil then
    begin
        WNPrint(head);
        WNClear(head)
    end
end.
