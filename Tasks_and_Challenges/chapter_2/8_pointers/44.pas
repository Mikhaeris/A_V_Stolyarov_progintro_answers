program Task44;

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
        size: longint;
    end;
    sllptr = ^SLinkedList;

procedure SLInit(var sll: sllptr);
begin
    new(sll);
    sll^.head := nil;
    sll^.tail := nil;
    sll^.size := 0;
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
    SLIsEmpty := slist.size = 0
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
    slist.tail := temp;
    slist.size := slist.size + 1
end;

procedure SLPopFront(var sll: sllptr);
var
    temp: snodeptr;
begin
    if SlIsEmpty(sll^) then
        exit;
    temp := sll^.head^.next;
    if sll^.head = sll^.tail then
        sll^.tail := temp;
    dispose(sll^.head);
    sll^.head := temp;
    sll^.size := sll^.size - 1
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

    WLinkedList = record
        head: wnodeptr;
        tail: wnodeptr;
    end;
    wllptr = ^WLinkedList;

procedure WLInit(var wll: wllptr);
begin
    new(wll);
    wll^.head := nil;
    wll^.tail := nil
end;

procedure WLClear(var wll: wllptr);
var
    temp, curr: wnodeptr;
begin
    if wll = nil then
        exit;
    curr := wll^.head;
    while curr <> nil do
    begin
        if curr^.data <> nil then
            SLClear(curr^.data);
        temp := curr^.next;
        dispose(curr);
        curr := temp
    end;
    dispose(wll);
    wll := nil
end;

function WLIsEmpty(var wlist: WLinkedList): boolean;
begin
    WLIsEmpty := (wlist.head = nil) and (wlist.tail = nil);
end;

procedure WLPushFront(var wlist: WLinkedList);
var
    temp: wnodeptr;
begin
    new(temp);
    temp^.data := nil;
    temp^.next := wlist.head;

    if WLIsEmpty(wlist) then
        wlist.tail := temp;
    wlist.head := temp
end;

procedure WLPushBack(var wlist: WLinkedList);
var
    temp: wnodeptr;
begin
    new(temp);
    temp^.data := nil;
    temp^.next := nil;

    if WLIsEmpty(wlist) then
        wlist.head := temp
    else
        wlist.tail^.next := temp;
    wlist.tail := temp
end;

procedure WLUpdateData(var wlist: WLinkedList; ch: char);
begin
    if WLIsEmpty(wlist) then
        exit;

    if wlist.tail^.data = nil then
        SLInit(wlist.tail^.data);
    
    SLPushBack(wlist.tail^.data^, ch)
end;

procedure WLMaxLength(var wll: wllptr; var max_length: longint);
var
    temp: wnodeptr;
begin
    max_length := 0;
    temp := wll^.head;
    while temp <> nil do
    begin
        if max_length < temp^.data^.size then
            max_length := temp^.data^.size;
        temp := temp^.next
    end
end;

procedure WLPrint(var wll: wllptr; max_length: longint);
var
    temp: wnodeptr;
begin
    temp := wll^.head;
    while temp <> nil do
    begin
        if temp^.data^.size = max_length then
        begin
            SlPrint(temp^.data^);
            if temp^.next <> nil then
                write(' ')
        end;
        temp := temp^.next
    end;
    writeln;
end;

function IsSpace(var ch: char): boolean;
begin
    IsSpace := (ch = ' ') or (ch = #9)
end;

function IsNumerical(var ch: char): boolean;
begin
    IsNumerical := ('0' <= ch) and (ch <= '9')
end;

var
    ch, prev_ch: char;
    wll: wllptr;
    max_length: longint;
begin
    prev_ch := ' ';
    WLInit(wll);

    while not eof do
    begin
        read(ch);

        if IsNumerical(ch) and not IsNumerical(prev_ch) then
            WLPushBack(wll^);

        if ch = #10 then
        begin
            WLMaxLength(wll, max_length);
            WLPrint(wll, max_length);
            WLClear(wll);
            WlInit(wll);
            prev_ch := ' ';
            continue;
        end;

        prev_ch := ch;
        if not IsNumerical(ch) then
            continue;

        WLUpdateData(wll^, ch)
    end;

    if wll <> nil then
    begin
        WLMaxLength(wll, max_length);
        WLPrint(wll, max_length);
        WLClear(wll)
    end
end.
