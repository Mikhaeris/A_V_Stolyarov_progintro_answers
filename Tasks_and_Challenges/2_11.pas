program task_2_11;

{ Kernighan fast count bit algorithm }
function BitCount(n: longint): integer;
begin
    BitCount := 0;
    while n <> 0 do
    begin
        n := n and (n - 1);
        BitCount := BitCount + 1
    end
end;

var
    x: longint;
    ans: integer;
begin
    x := 3;
    ans := BitCount(x);
    writeln(ans)
end.
