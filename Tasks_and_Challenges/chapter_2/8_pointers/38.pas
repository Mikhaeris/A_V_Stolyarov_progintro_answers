program Task38;
type
    iptr3 = array [1..3] of ^integer;
var
    a: iptr3;
    p: ^iptr3;

    x, y, z: integer;
    i: integer;
begin
    x := 1;
    y := 2;
    z := 3;

    a[1] := @x;
    a[2] := @y;
    a[3] := @z;
    p := @a;
    
    for i := 1 to 3 do
        writeln('a[', i, ']: ', p^[i]^)
end.
